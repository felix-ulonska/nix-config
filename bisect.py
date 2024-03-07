import json

state_file = "binary_search_state.json"

def save_state(state):
    with open(state_file, "w") as f:
        json.dump(state, f)

def load_state():
    if not os.path.exists(state_file):
        return None
    with open(state_file, "r") as f:
        return json.load(f)

def update_nixpkgs(commit):
    subprocess.run(["nix", "flake", "update", "--commit", commit], check=True)

def rebuild_system():
    subprocess.run(["sudo", "nixos-rebuild", "switch"], check=True)

def ask_user_if_fixed():
    response = input("Is the error fixed? (yes/no): ").strip().lower()
    return response == "yes"

def binary_search(commits):
    state = load_state()
    if state:
        low, high, last_bad, first_good = state['low'], state['high'], state['last_bad'], state['first_good']
    else:
        low, high, last_bad, first_good = 0, len(commits) - 1, None, None

    while low <= high:
        mid = (low + high) // 2
        mid_commit = commits[mid]

        print(f"Testing commit: {mid_commit}")
        update_nixpkgs(mid_commit)
        rebuild_system()

        print("Please reboot your system now and check if the error is resolved.")
        print("After rebooting, rerun this script and enter whether the error was fixed.")
        if ask_user_if_fixed():
            print(f"Error fixed at commit: {mid_commit}")
            first_good = mid
            high = mid - 1
        else:
            last_bad = mid
            low = mid + 1

        # Save the current state before the potential reboot
        save_state({'low': low, 'high': high, 'last_bad': last_bad, 'first_good': first_good})

    if first_good is not None:
        print(f"The error was fixed at commit: {commits[first_good]}")
        if last_bad is not None:
            print(f"The last commit with the error was: {commits[last_bad]}")
    else:
        print("The exact commit where the error was fixed could not be determined.")

    # Cleanup state file after completion
    os.remove(state_file)

if __name__ == "__main__":
    # Example list of commits; replace with actual commits from your repo
    commits = ["start_commit_hash", "middle_commit_hash", "end_commit_hash"]
    binary_search(commits)

How to clean commit history in all or some of my remote repositories?

1. Install Nix if you haven't already:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```
2. Clone the repository:
   ```bash
   git clone 'https://github.com/rayanamal/clean-my-commit-history/'
   ```
3. Run the script:
   ```bash
   clean-my-commit-history/clean.sh
   ```

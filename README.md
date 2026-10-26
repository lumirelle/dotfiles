# Dotfiles

My personal dotfiles (also mise bootstrap configurations), out-of-box (for me).

## Usage

For more details about the difference between `mise bootstrap --adopt` & `mise bootstrap --from`, please refer to [the Mise documentation](https://mise.jdx.dev/bootstrap/from-repository.html#choose-from-or-adopt).

### Method 1: Overwrite Your Global Mise Configuration

Via HTTPS (For You):

```sh
mise bootstrap --adopt https://github.com/lumirelle/dotfiles.git
```

Via HTTPS (For Myself):

```sh
mise bootstrap --adopt git@github.com:lumirelle/dotfiles.git
```

### Method 2: Preserve Your Global Mise Configuration

Via HTTPS (For You):

```sh
mise bootstrap --from https://github.com/lumirelle/dotfiles.git
```

Via HTTPS (For Myself):

```sh
mise bootstrap --from git@github.com:lumirelle/dotfiles.git
```

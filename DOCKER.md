
# Beginner Docker Guide for MASt3R-SLAM

This guide will walk you through building, running, and managing the MASt3R-SLAM Docker container, step by step.

---

## 1. Build the Docker Image

Open a terminal in your project root and run:

```bash
sudo docker build -t mast3r-slam:latest .
```

This command creates a Docker image named `mast3r-slam:latest` using the Dockerfile in your project.

---

## 2. Start and Use the Container (Recommended: Persistent Mode)

To keep your work and installed files between sessions, start the container in the background (detached mode):

```bash
sudo docker run --gpus all -d -it \
	--name mast3r-slam-container \
	-v "$PWD":/workspace \
	mast3r-slam:latest
```

- `--gpus all` enables GPU access (omit if you don't have an NVIDIA GPU).
- `-d` runs the container in the background.
- `-it` gives you an interactive shell.
- `--name mast3r-slam-container` names your container for easy access.
- `-v "$PWD":/workspace` mounts your project folder inside the container.

---

## 3. Enter the Running Container

To open a shell in your running container at any time:

```bash
sudo docker exec -it mast3r-slam-container bash
```

You can open as many shells as you want this way.

---

## 4. Stop and Remove the Container

When you're done, stop and remove the container:

```bash
sudo docker stop mast3r-slam-container
sudo docker rm mast3r-slam-container
```

---

## 5. (Optional) Remove All Unused Docker Data

To free up disk space:

```bash
sudo docker system prune -a
```

---

## 6. (Optional) One-Time Quick Run (Not Persistent)

If you just want to try the container and don't care about saving changes, use:

```bash
sudo docker run --gpus all --rm -it \
	-v "$PWD":/workspace \
	mast3r-slam:latest
```

This deletes the container when you exit.

---

## 7. Tips

- All your work should be done inside `/workspace` in the container (it maps to your project folder on your computer).
- If you install anything inside the container (not in `/workspace`), it will be lost if you delete the container (unless you use persistent mode).
- You can always re-enter a persistent container with `docker exec`.

For more, see the [Docker documentation](https://docs.docker.com/).



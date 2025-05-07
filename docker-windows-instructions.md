# Run the "rsinglecell"   Rstudio Docker container on Windows

If you encounter problems please email Ashley FLetcher, [af206@duke.edu](mailto:af206@duke.edu) with a copy of the error message.

I will check email over the weekend.

Please let me know if you find errors in these instructions.

### IMPORTANT: you need admin rights on your PC for installing "Windows Subsystem Linux" (WSL) and Docker Desktop

## 1 Install "Windows Subsystem Linux" WSL

Documentation at [Install WSL | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/install)

The key is to run powershell in administrator mode, by typing the windows (start) key and then typing `powershell`, then right-click on the "Windows PowerShell" app and select "Run as administrator".

In PowerShell, type:

```cmd
wsl --install
```

Then restart your machine.

## 2 Download and install Docker Desktop

Go to [Docker Desktop: The #1 Containerization Tool for Developers | Docker](https://www.docker.com/products/docker-desktop) and download and install Docker Desktop. Click the "Download Docker Desktop" button and the website will automatically detect that you're on Windows.

You will probably have to restart again after installing Docker Desktop.

Hopefully, at this point, Docker Desktop will be "integrated" with WSL, so that you can use docker commands inside WSL.

## 3 Open WSL and get the "rsinglecell" Docker image

You can open WSL from the start menu.

Then download the Docker image for the workshop:

```bash
docker pull ashfletch/cosmxr:with-packages
```

Check to see if cosmxr:with-packages got installed:

```bash
docker images
```

In `Terminal`, create a folder for the workshop information in the directory you want to work in (where you downloaded the course data) and change your working directory to there. 
You can do this by running the command below:

```bash
cd your/data/folder/ # change to the folder path your workshop data is in
# Check you are in the right folder
ls # lists the files in the directory you are in
```

We'll call the directory `project`, but you can use any name without spaces.

```bash
docker run --rm -e PASSWORD=xxx -p 8787:8787 \
  -v $(pwd):/home/rstudio/project \
  ashfletch/cosmxr:with-packages
```

## 4 Connect to the Rstudio server

In your browser, open http://localhost:8787/

**Important**: That is http://, **not** https://

Log in with:

- Username: rstudio
- Password: xxx (the password you set in the `docker run` command)

In the `Files` tab you should see a single folder, your `project` folder. In the R `Console` tab, you should enter

```r
setwd('project')
```

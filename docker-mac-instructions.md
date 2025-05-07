# Run the "rsinglecell" container on a Mac

If you encounter problems please email Ashley Fletcher, af206@duke.edu with a copy of the error message.



I will check email over the weekend.

Please let me know if you find errors in these instructions.

## 1 Download and install Docker Desktop

Go to [Docker Desktop: The #1 Containerization Tool for Developers | Docker](https://www.docker.com/products/docker-desktop) and download and install Docker Desktop (Blue button "Download Docker Desktop" and select whether your mac is running an Apple Silicon chip or an Intel chip).

## 2 Open Terminal and get the Docker image for the workshop

Use `Terminal` to download the Docker image, which contains an Rstudio server plus the R packages needed for the workshop:

```bash
docker pull --platform linux/amd64 ashfletch/cosmxr:with-packages
```

Check to see if cosmxr:with-packages got installed:

```bash
docker images
```

## 3 Start the Docker image

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

This will start an Rstudio server process in the background, and shares your current local folder (where you ran the command) into the container.

## 4 Connect to the the Rstudio server

In your broswer, open http://localhost:8787/. 

**Important**: that is http://, **not** https://

Log in with:

- Username: rstudio
- Password: xxx (the password you set in the 'docker run' command)

In the `Files` tab you should see a single folder, your `project` folder. In the R `Console` tab, you should enter

```r
setwd('project')
```

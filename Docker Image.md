- 
- Easy to edit
- Supports **bold**, *italic*, and \`code\`
- Can include [links](https://example.com)





Use `Terminal` to download the Docker image, which contains an Rstudio server plus the R packages needed for the workshop:

```bash
docker pull ashfletch/cosmxr # for non-M1 macs
docker pull --platform linux/amd64 ashfletch/cosmxr # for M1 macs
```

Check to see if rcosmx got installed:

```bash
docker images
```
Run the docker image to start R with required packages installed

```bash
docker run --rm -e PASSWORD=xxx -p 8787:8787 \
  -v $(pwd):/home/rstudio/project \
  ashfletch/cosmxr
```
Then go to: http://localhost:8787
	•	Username: rstudio
	•	Password: xxx

You’ll be dropped into RStudio running inside Docker with your files accessible.

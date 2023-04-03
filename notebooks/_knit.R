
## Set the working directory as the location of the _knit.R file

## knit ----
rmarkdown::render("./01_eda_preds.Rmd", 
                  output_dir = "./_knit")

md_filename <- "./_knit/01_eda_preds.md"
md_txt <- readLines(md_filename)
md_txt <- gsub(paste0(getwd(), "/_knit/"), "./", md_txt)
cat(md_txt, file=md_filename, sep="\n")

rmarkdown::render("./02_yearly_grid_mean.Rmd", 
                  output_dir = "./_knit")

md_filename <- "./_knit/02_yearly_grid_mean.md"
md_txt <- readLines(md_filename)
md_txt <- gsub(paste0(getwd(), "/_knit/"), "./", md_txt)
cat(md_txt, file=md_filename, sep="\n")

rmarkdown::render("./03_match_cts_extent.Rmd", 
                  output_dir = "./_knit")

md_filename <- "./_knit/03_match_cts_extent.md"
md_txt <- readLines(md_filename)
md_txt <- gsub(paste0(getwd(), "/_knit/"), "./", md_txt)
cat(md_txt, file=md_filename, sep="\n")

rmarkdown::render("./04_test_grid_to_zip.Rmd", 
                  output_dir = "./_knit")

md_filename <- "./_knit/04_test_grid_to_zip.md"
md_txt <- readLines(md_filename)
md_txt <- gsub(paste0(getwd(), "/_knit/"), "./", md_txt)
cat(md_txt, file=md_filename, sep="\n")

rmarkdown::render("./06_eda_output.Rmd", 
                  output_dir = "./_knit")

md_filename <- "./_knit/06_eda_output.md"
md_txt <- readLines(md_filename)
md_txt <- gsub(paste0(getwd(), "/_knit/"), "./", md_txt)
cat(md_txt, file=md_filename, sep="\n")

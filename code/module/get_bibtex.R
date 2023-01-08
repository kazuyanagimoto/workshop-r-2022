library(bibtex)
library(RefManageR)
BibOptions(check.entries = FALSE,
           bib.style = "authoryear",
           cite.style = "year",
           style = "markdown",
           hyperlink = TRUE,
           dashed = FALSE)

bib <- ReadZotero(user = Sys.getenv("USER_ZOTERO"),
                  .params = list(
                    key = Sys.getenv("KEY_ZOTERO"),
                    collection = Sys.getenv("COLLECTION_R_WORKSHOP")))

dirs_export <- c(here::here("output"))
for (dir in dirs_export) {
  WriteBib(bib, file = paste0(dir, "/references.bib"))
}
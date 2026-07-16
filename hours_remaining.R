# ostudents = download Student Hours from oasesonline.com.
# oparents = download Other Area/Parent from oasesonline.com.
# These can be downloaded only as .xlsx. Must be converted to .csv

source('~/Testive/db_testive/basic_tools.R')

hhmm_to_decimal <- function(x) {
  parts <- do.call(rbind, strsplit(x, ":"))
  hours <- as.numeric(parts[, 1])
  minutes <- as.numeric(parts[, 2])
  hours + minutes / 60
}

ostudents = read.csv('~/Desktop/ostudents.csv') %>%
  mutate(Hours.Left = hhmm_to_decimal(Hours.Left)) %>%
  filter(grepl('Test Prep', District) &
           Status == 'Active' &
           Hours.Left <= 3 &
           !grepl('Fake', Student)) %>%
  select(Student, Tutor, Student.ID, Hours.Left)

oparents = read.csv('~/Desktop/oparents.csv') %>%
  filter(Student.ID %in% ostudents$Student.ID) %>%
  select(Parent, Email, Student.ID)

remaining = left_join(ostudents, oparents) %>%
  select(-Student.ID) %>%
  arrange(Hours.Left) %>%
  distinct(.)

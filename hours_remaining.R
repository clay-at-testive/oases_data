# ostudents = download Student Details from oasesonline.com.
# ohours = download Student Invoiced Hours from oasesonline.com.
# These can be downloaded only as .xlsx. Must be converted to .csv.

source('~/Testive/db_testive/basic_tools.R')

ohours = read.csv('~/Desktop/oases_hours.csv') %>%
  filter(Hours.Invoiced > 0) %>%
  rename(Hours.Remaining = Hours.Left) %>%
  unite('Student', Lastname:Firstname, sep = ', ') %>%
  select(Student, Session.Type, Hours.Remaining)

ostudents = read.csv('~/Desktop/oases_students.csv') %>%
  select(Student, Tutor, Parent, Parent.Cell, Email) %>%
  rename(Parent.Email = Email)

remaining = left_join(ohours, ostudents) %>%
  filter(Hours.Remaining < 5) %>%
  arrange(Hours.Remaining)

write.csv(file = '~/Desktop/oremaining.csv', remaining, row.names = FALSE)

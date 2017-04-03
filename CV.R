library(ggplot2)

skill_name <- c('SAS', 'SQL', 'R', 'Python', 'Excel', 'Hadoop')
skill_level <- c('Advanced', 'Advanced', 'Intermediate', 'Intermediate', 'Advanced', 'Beginner')
skill_level <- factor(skill_level, levels =  c('Beginner', 'Intermediate', 'Advanced'), ordered = TRUE )

myskills <- data.frame(skill_name, skill_level)

ggplot(data = myskills, aes(skill_name, skill_level, fill = skill_name) ) + 
  geom_bar(stat = "identity") +
  labs(title = 'Technical Skills', x = '', y = '') +
  guides(fill = FALSE)

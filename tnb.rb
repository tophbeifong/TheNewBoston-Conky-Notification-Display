require 'rubygems'
require 'mechanize'

#
# Enter your login information below
# Between the quot's :)
#

EMAIL = "email"
PASSWORD = "password"

agent = Mechanize.new

page = agent.get('https://thenewboston.com')

thenewboston_login_form = page.form()
thenewboston_login_form.email = EMAIL
thenewboston_login_form.password = PASSWORD

page = agent.submit(thenewboston_login_form, thenewboston_login_form.buttons.first)

notification = page.at('.notifications-table tr .description').text.split("  ")
notification.delete("")
notification.delete("\n")
notification.delete(" \n")
case notification[2][0..3].downcase
when "phot" then notification[2] = "Photo"
when "post" then notification[2] = "Post"
when "vide" then notification[2] = "Video"
end

file = File.read("./notification.log")
file_chars = file.split(" ")
if file_chars[0].chop.to_i <= 10
  case file_chars[1].downcase
  when "seconds" then print "(new) "
  when "minutes" then print "(new) "
  when "hours" then print "(new) "
  else print ""
  end
end

File.open("./notification.log", "w") do |file|
  file.puts notification[notification.length - 1]
end

for n in 0..notification.length - 2
  if n == 3
    print "#{notification[n][0..15]}.."
  else
    print "#{notification[n].chomp("\n")} "
  end
end
print "."

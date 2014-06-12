# encoding: utf-8
# require "csv"
# f = open("ozone.txt","r")
# p f
ar[] = 0
i = 0
open("ozone.txt"){|f|
    while line = f.gets
	ar[i] = line.split(",")
	p ar[i]
	i += 1
    end
}
# CSV.open("ozone.txt","r") do |row|
#    p row
# end


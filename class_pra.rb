require "csv"
require "date"

$data = []
$gtime = []
$data1 = []

# ozone.txtを一行ずつ回して、Time.localに時間データ rowにその他の情報を入れる
class Imput
    CSV.foreach("ozone.txt", encoding: "ASCii:UTF-8") do |row|
	time = row.shift
        time2 = time.split("/")
	month = time2[0]
        day = time2[1]
	year = time2[2]
        $data.push(row)
	$gtime.push(Time.local(year, month, day))
    end
end

n = $data.size

# ?を補間するfor文
for i in 0 .. n-1
    if $data[i][1] == "?"
	$data[i][1] = "0"
    end
    $data1.push($data[i][1].to_f)
end

for j in 0 .. n-1
    print("#{$gtime[j]},#{$data1[j]}\n")
end

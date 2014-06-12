require "date"

# オゾンのデータを宣言するクラス
class Ozone_data
    def initialize()
	@date = Date
	@wsr = Array.new()
	@wsr_peek=0
	@wsr_average=0
	@t =Array.new()
	@t_peek=0
	@t_average=0
	@t_850hpal
	@rh_850hpal
	@u_850hpal
	@v_850hapl
	@ht_850hpal
	@t_700hpal
	@rh_700hpal
	@u_700hpal
	@v_700hpal
	@ht_700hpal
	@t_500hpal
	@rh_500hpal
	@u_500hpal
	@v_500hpal
	@ht_500hpal
	@ki
	@tt
	@slp
	@slp_
	@precp
     end

    attr_accessor :date, :wsr, :wsr_peek, :wsr_average, :t, :t_peek, :t_average, :t_850hpal, :rh_850hpal, :u_850hpal, :v_850hpal, :ht_850hpal, :t_700hpal, :rh_700hpal, :u_700hpal, :v_700hpal, :ht_700hpal, :t_500hpal, :rh_500hpal, :u_500hpal, :v_500hpal, :ht_500hpal, :ki, :tt, :slp, :slp_, :precp
end ## Data

# データを読み込むクラス
class Loader
    @data

    attr_accessor :data, :predict

    def initialize(filename )
	@data = Array.new()
	@predict = Array.new()
        temp=0 #行の数
	counter=0 #カンマの数
        switch="date"
	open(filename).each{ |line|
	    line.split(',').each{ |item|
		case switch
		    when "date" 
			@data.push(Ozone_data.new())
		        american_format='%m/%d/%Y'
			@data[temp].date = Date::strptime(item, american_format)
		        switch = "WSR"
		    when "WSR"
		      if counter <= 24 then
			@data[temp].wsr.push(item.to_f) if item != '?'
			@data[temp].wsr.push(item)	if item == '?'
		      end
			@data[temp].wsr_peek = item.to_f if counter == 25
			@data[temp].wsr_average = item.to_f if counter == 26
		        switch = "T" if counter == 27 
		    when "T" 
			@data[temp].t.push(item.to_f) 
			@data[temp].t_peek = item.to_f if counter == 51
			@data[temp].t_average = item.to_f if counter == 52 
			switch = "850" if counter == 53
		    when "850"
			@data[temp].t_850hpal = item.to_f
			@data[temp].rh_850hpal = item.to_f if counter == 54
			@data[temp].u_850hpal = item.to_f if counter == 55
			@data[temp].v_850hpal = item.to_f if counter == 56
			@data[temp].ht_850hpal = item.to_f if counter == 57
			switch = "700"
		    when "700"
			@data[temp].t_700hpal = item.to_f
			@data[temp].rh_700hpal = item.to_f
			@data[temp].u_700hpal = item.to_f
			@data[temp].v_700hpal = item.to_f
			@data[temp].ht_700hpal = item.to_f
			switch = "500"
		    when "500"
			switch = "others"
		    when "others"

		    case counter
			when 73 then
			    temp +=1
			    switch="date"
		    end ##counter
		end ##switch
		counter +=1
	    } ## item
	    counter=0
	} ## line
=begin
	for i in @data
	    p i
        end ## for @data
=end
    @predict = Marshal.load(Marshal.dump(@data))
    end ## initialize 
end ## class Loader

# @wsrをひとつの配列にする 
class Converter
end

# ?を補間するクラス
class Interpolation
end

x = Loader.new( "ozone.txt" )


sum = 0 # 24時間の合計
ques_c = 0 # ?の数
answer = 0 # 補間するもの

# データの数全てで回す
for i in 0...x.data.length #...は１つ減らす
# x.data[i].wsr.each{| l |
#   puts x.data[i].date.to_s+":"+l.to_s
# }
sum=0
ques_c=0
answer=0
    # データのwsrの数で回す 0..24で回す
    for j in 0...x.data[i].wsr.length
=begin
	# ?を0に補間するif文
	if x.data[i].wsr[j].to_s == "?"
	    x.data[i].wsr[j] = "0"
	end
=end 

=begin
	# 補間のif文
	if x.data[i].wsr[j].to_s == "?"
	    # 周りに?があれば0を補間し、そうでなければ両隣の平均を補間する
	    if x.data[i].wsr[j+1].to_s == "?" || x.data[i].wsr[j-1].to_s == "?"
		x.data[i].wsr[j] = "0"
	    else
		x.data[i].wsr[j] = (x.data[i].wsr[j+1].to_f + x.data[i].wsr[j-1].to_f) / 2
	    end
	end
=end
#	p x.data[i].wsr_average
	

	if x.data[i].wsr[j].to_s == "?"
	    ques_c += 1
	else
	    sum += x.data[i].wsr[j].to_f
	end
#	puts x.data[i].date.to_s+":"+j.to_s+":"+x.data[i].wsr[j].to_s
    end

=begin
    p sum
    p ques_c
    p x.data[i].wsr_average.to_f
=end

    # answer計算
    # ques_c =1 if ques_c == 0
    answer = (x.data[i].wsr_average.to_f * 24 - sum) / ques_c

    # answerを補間するfor文
    for j in 0...x.data[i].wsr.length
	if ques_c != 0
	    x.predict[i].wsr[j] = answer
	end
	#sprintf("%f, %02d, %f",x.predict[i].date.to_f, j.to_i, x.predict[i].wsr[j].to_f)
	#sprintf("%d, %02d, %d",x.predict[i].date.to_s+","+j.to_s+","+x.predict[i].wsr[j].to_s)
	print(x.predict[i].date)
	print(",")
	print(sprintf("%02d",j.to_i))
	print(",")
	print(x.predict[i].wsr[j])
	print("\n")
    end
    #puts "::" + x.data[i].wsr_average.to_s + "__"+ ques_c.to_s 
end



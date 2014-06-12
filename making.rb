class Ozone_data
    @data
    @wsr = Array.new(24)
    @wsr_peek
    @wsr_average
    @t= Array.new(24)
    @t_peek
    @t_average
    @t_850hpal
    @rh_850hpal
    @u_850hpal
    @v_850hapl
    @ht_850pal
    @t_700hapl
    @rh_700hapl
    @u_700hapl
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

class Loader
    @data
    def initialize(filename )
	counter=0
        switch="date"
	open(filename).each{ |line|
	    case switch
	    when "date" then
		Ozone_data.new()

	    when "WSR" then
	    when "T" then
	    when "850" then
	    when "700" then
	    when "500" then
	    when "others" then
	    end
	    counter++;
	}
    end
end


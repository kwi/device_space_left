require 'spec_helper'

describe :device_space_left do

  let(:dsl) { DeviceSpaceLeft }

  it "check if df return something" do
    dsl.df.should_not be nil
    dsl.df.size.should > 10
  end
  
  context "with stubbed df" do

    before do
      
      fake_df = <<-EOF

      Filesystem            Size  Used Avail Use% Mounted on
      /dev/md1              5.0G  2.0G  2.8G  42% /
      none                  987M  200K  986M   1% /dev
      none                  987M     0  987M   0% /dev/shm
      none                  987M   84K  986M   1% /var/run
      none                  987M     0  987M   0% /var/lock
      none                  987M     0  987M   0% /lib/init/rw
      /dev/md2              4.1T  882G  3.0T  23% /home
      EOF
      
      dsl.stub!(:df).and_return(fake_df)
    end

    it "should return correct percent used when device given" do
      dsl.percent_used('/home').should == 23
      dsl.percent_used('/dev/md2').should == 23
    end
    
    it "should return max percent used when no device given" do
      dsl.percent_used(nil).should == 42
    end
    
    it "should return free percent" do
      dsl.percent_free('/home').should == 77
      dsl.percent_free('/dev/md2').should == 77
      dsl.percent_free(nil).should == 58
    end

    it "should return correct space available" do
      dsl.space_available('/home').should == 3.0 * 1024 * 1024 * 1024 * 1024
      dsl.space_available(nil).should == 986 * 1024 * 1024
    end

    it "should return correct space used" do
      dsl.space_used('/home').should == 882 * 1024 * 1024 * 1024
      dsl.space_used(nil).should == 882 * 1024 * 1024 * 1024
    end
    
    it "should return correct total size" do
      dsl.size('/home').should == (4.1 * 1024 * 1024 * 1024 * 1024).to_i
      dsl.size(nil).should == 4518541105561
    end
    

  end

end

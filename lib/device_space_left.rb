module DeviceSpaceLeft

private
  
  # Return the df linux command output
  def self.df
    `df`
  end

  def self.parse_df_size(size)
    return size if !(String === size)
    
    return (size.to_f * 1024 * 1024 * 1024 * 1024).to_i if size.index('T')
    return (size.to_f * 1024 * 1024 * 1024).to_i if size.index('G')
    return (size.to_f * 1024 * 1024).to_i if size.index('M')
    return (size.to_f * 1024).to_i if size.index('K')
    return (size.to_i) if size.index('B')

    size.to_i
  end
  
  # Return a df infos line corresponding to the filesystem name or to the mount point
  def self.find_df_infos(mount_name)
    h = df_hashed
    return h[mount_name.to_sym] if h[mount_name.to_sym]

    h.each_value do |v|
      return v if v[:filesystem] == mount_name.to_s
    end

    return nil
  end

  # Return a value or a max looking through the df hash
  def self.find_value_or_max(value_name, mount_name = nil, max_meth = :max)
    h = df_hashed
    
    if mount_name
      t = find_df_infos(mount_name)
      return t[value_name] if t
    end

    max = []
    h.each_value do |v|
      max << v[value_name]
    end
    
    if max_meth == :sum and max
      total = 0
      max.each { |v| total += v }
      return total
    end
    
    max.send(max_meth) || 0
  end

public
  
  # Return the df output in a ruby hash
  def self.df_hashed
    h = {}

    df.strip.split("\n").each do |l|
      if l.size > 10
        tab = l.strip.split(/ +/)
        if tab.first != 'Filesystem'
          size = parse_df_size(tab[1])
          used = parse_df_size(tab[2])
          available = parse_df_size(tab[3])
          percent_used = tab[4].gsub('%', '').to_i
      
          h[tab.last.to_sym] = {:filesystem => tab[0], :size => size, :used => used, :available => available, :percent_used => percent_used, :mount_on => tab.last}
        end
      end
    end

    return h
  end
  
  # Return the percentage of used space on the device named "mount_name"
  # If mount_name is nil => Return the maximum
  def self.percent_used(mount_name = nil)
    find_value_or_max(:percent_used, mount_name)
  end

  # Return the percentage of free space on "mount_name"
  # If mount_name is nil => Return the minimum
  def self.percent_free(mount_name = nil)
    100 - find_value_or_max(:percent_used, mount_name)
  end
  
  # Return the space available on "mount_name"
  # If mount_name is nil => Return the minimum
  def self.space_available(mount_name = nil)
    find_value_or_max(:available, mount_name, :min)
  end
  
  # Return the space used on "mount_name"
  # If mount_name is nil => Return the maximum
  def self.space_used(mount_name = nil)
    find_value_or_max(:used, mount_name)
  end
  
  # Return the size of "mount_name"
  # If mount_name is nil => Return the total
  def self.size(mount_name = nil)
    find_value_or_max(:size, mount_name, :sum)
  end
  
  

end
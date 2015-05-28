# Check to see if this server is in a Cluster

    Facter.add(:proxmoxcluster) do
      setcode do
        if File.exist? "/etc/pve/cluster.conf"
         true
	else
	 false
        end
      end
    end

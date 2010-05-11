From: Rodrigo Nascimento <nascimento.rp@gmail.com>
Subject: DM-MP Read Performance
Date: Tue, 11 May 2010 15:59:18 -0300
Message-ID: <AANLkTimEJp1QVIDHtmC83v9l94SuzUmUT8P8Fee5ZOWn@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi All,

I have a Oracle Enterprise Linux box, the kernel is 2.6.18...,
accessing LUs in a NetApp Box.
At NetApp box side, I have two Gigabit Ethernet NICs, each NIC is
member of a VLAN and this two interfaces are members of a
TargetPortalGroup.
At Host side, I have two Gigabit Ethernet NICs, each NIC is member of a VLAN.
I have this configuration at DM-MP conf file:

default
{
    use_friendly_names no
    max_fds 4096
    rr_min_io 128
}

devnode_blacklist
{
   devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
   devnode "^hd[a-z]"
   devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

devices
{
   vendor "NetApp"
   product "LUN"
   flush_on_last_del yes
   getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
   prio_callout "/sbin/mpath_prio_netapp /dev/n%"
   features "1 queue_if_no_path"
   hardware_handler 0
   path_grouping_policy multibus
   failback immediate
   path_checker directio
}

When I simulate write operations on a LU I reach 90MB/s on each NIC.
When I simulate read operations on a LU I reach 40MB/s on each NIC.
It's a very poor number.
When it is running on Read Operations I can see the devices /dev/sdb
and /dev/sdc at 50% busy each and the dm-1 at 100%.

Anyone can help me to identify Why this throughput to read is poor?

Thanks,

---
Nascimento
NetApp - Enjoy it!

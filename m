From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: dm-rdac problem
Date: Wed, 12 Mar 2008 11:14:23 -0700
Message-ID: <1205345663.31859.47.camel@linuxchandra>
References: <Pine.LNX.4.64.0803121506220.5697@paranoid.lipkowski.org>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0803121506220.5697@paranoid.lipkowski.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, 2008-03-12 at 16:36 +0100, Jacek Lipkowski wrote:
> Hello,
> 
> I'm having a problem with getting dm-rdac to work. I do realize that this 
> is a development list, but it seems like the only place to ask for help, 
> and http://christophe.varoqui.free.fr is down. In the logs i get the 
> following errors, after starting multipathd:
> 
> device-mapper: multipath rdac: using RDAC command with timeout 60000
> device-mapper: table: 253:0: multipath: Unknown error
> device-mapper: ioctl: error adding target to table
> 
> multipath -ll doesn't show anything.

Can you send the o/p of "multipath -v4". Also, can you change the
prio_callout from  mpath_prio_rdac to mpath_prio_tpc.
> 
> The system is the following:
> - centos 5.1, with kernel changed to vanilla 2.6.24.3
> - tried both multipath-tools from centos (patched 0.4.7), and vanilla 
> 0.4.8
> - 2 qlogic QLA2340 hba's, connected to different fabrics
> - 2 IBM DS4500 Storage Servers (each connected to both fabrics), each 
> exports two luns, one 1.5TB lun, and one 100MB lun. I've also tried using 
> one IBM DS4500 Storage Server with one 1.5TB lun, and one 100MB lun.
> 
> If i disable AVT (change the host type from Linux to LNXCLVMWARE) i also 
> get read errors from unavaliable paths:
> end_request: I/O error, dev sda, sector 0
> end_request: I/O error, dev sdd, sector 0
> etc... (this is normal).
> 
> I can get multipath to work using the tur checker.

If you are running in AVT, you do not need dm-rdac (or the rdac path
checker) at all. Do you see any problems if you do not have them in your
multipath.conf file ?

> 
> my /etc/multipath.conf is the following:
> defaults {
>     multipath_tool "/sbin/multipath -v 0 -S"
>     udev_dir         /dev
>     polling_interval 10
>     default_selector         round-robin
>     default_selector_args 0
>     default_path_grouping_policy     failover
>     default_getuid_callout "/sbin/scsi_id -g -u -s"
>     default_prio_callout     "/bin/false"
> user_friendly_names yes
> }
> devnode_blacklist {
>     devnode fd
>     devnode hd
>     devnode dm
>     devnode sr
>     devnode scd
>     devnode st
>     devnode ram
>     devnode raw
>     devnode loop
> #root fs is on /dev/rd/c0d0
> #   devnode sda
> #   devnode sdb
> }
> 
> 
> devices {
>     device {
>        vendor IBM
>        product 1742-900
>        path_grouping_policy group_by_prio
> hardware_handler        "1 rdac"
> prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
>                  failback                immediate
>        path_checker rdac
> getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>     }
> }
> 
> 
> multipaths {
>          multipath {
>                  device {
>                          vendor IBM
>                          product 1742-900
>                  }
>          }
> }
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------

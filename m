From: Jorge Salamero Sanz <bencer@cauterized.net>
Subject: paths scsi names persistence after rescan
Date: Mon, 30 May 2011 21:57:14 +0200
Message-ID: <201105302157.15330.bencer@cauterized.net>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


hi all,

i've configured multipath on a linux box and i'm getting these messages on 
syslog:

May 30 10:50:05 mail-1 udevd-work[25148]: rename(/dev/disk/by-
id/wwn-0x6006016052b022002e770b609680e011.udev-tmp, /dev/disk/by-
id/wwn-0x6006016052b022002e770b609680e011) failed: No such file or directory

and sometimes after a path failure,  the different paths get different scsi 
names, /proc/partitions shows in that case:

   8       16  838860800 sdb
   8       32  849582720 sdc
   8       80  838860800 sdf
   8       96  849582720 sdg
 252        3  849582720 dm-3
 252        4  838860800 dm-4
   8      208  838860800 sdn
   8      224  849582720 sdo
  65        0  849582720 sdq
   8      240  838860800 sdp

and then multipath gets crazy:

May 25 12:26:51 mail-1 multipathd: sdh: emc_clariion_checker: sending query 
command failed
...

i guess i should tell udev to asign persistant names using uuid? what's the 
right way to address this problem?

this is my config:

root@mail-1:~# multipath -ll
backup (36006016052b022009cd7f2aeaf80e011) dm-3 DGC     ,RAID 5        
[size=810G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][active]
 \_ 3:0:1:1 sdg 8:96  [active][ready]
 \_ 4:0:0:1 sde 8:64  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 3:0:0:1 sdc 8:32  [active][ready]
 \_ 4:0:1:1 sdi 8:128 [active][ready]
mail (36006016052b022002e770b609680e011) dm-4 DGC     ,RAID 5        
[size=800G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][active]
 \_ 4:0:0:0 sdd 8:48  [active][ready]
 \_ 3:0:1:0 sdf 8:80  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 3:0:0:0 sdb 8:16  [active][ready]
 \_ 4:0:1:0 sdh 8:112 [active][ready]

root@mail-1:~# cat /etc/multipath.conf 
#

blacklist {
    devnode "sda"
    devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
    devnode "^hd[a-z][[0-9]*]"
    devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

defaults {
    user_friendly_names no
}

devices {
	device {
		vendor "DGC"
		product "*"
		path_grouping_policy group_by_prio
		getuid_callout "/lib/udev/scsi_id -g -u -d /dev/%n"
		prio_callout "/sbin/mpath_prio_emc /dev/%n"
		hardware_handler "1 emc"
		no_path_retry 300
		path_checker emc_clariion
		failback immediate   
	}
}

multipaths {
	multipath {
		wwid 36006016052b022002e770b609680e011
		alias mail
	}
	multipath {
		wwid 36006016052b022009cd7f2aeaf80e011
		alias backup
	}
}

thanks in advance!

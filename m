From: Liutauras Adomaitis <liutauras.adomaitis@gmail.com>
Subject: help needed for Dell MD3000i and multipathing
Date: Thu, 3 Dec 2009 23:13:03 +0000
Message-ID: <c1ec9ac0912031513k9983d63n6fd7f02ac886cac4@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi,

I'm trying to setup DELL MD3000i with multipathing. The connections
are with crossover cables (no switches), 2 nics on server connected
directly to 2 controlers on storage - 2 paths in total. This storage
is active/passive. My guess is that problem is in multipathing driver
which does not see Vendor and Product attributes and
host:channel:target:lun (as you can see below). I managed to configure
multipathd by setting default values and loaded rdac. This helped me
to get passive path be marked as ghost. I cannot set per device
section, because it is mpath driver doesn't match any device.
The main problem is that if I try change preferred controler then no
mpath partitions are mounted every thing seems fine, but then any
partition is mounted I get a lot IO errors and both paths are marked
as failed.
On the other hand this is my first setup with iscsi and multpathing so
I don't know what to expect. Let say it seems strange for me that in
active/passive situation my linux box doesn't get any info about
partitions on passive virtual disks. How can it do fail over, then
there are no partition block devices of passive controler disks.

Thanks for any hints
Liutauras

Here is a output from various commands:
# multipath -ll
mpath0 (360026b9000372cf3000005384ac4961e) dm-16 ,
[size=20M][features=0][hwhandler=0]
\_ round-robin 0 [prio=3][enabled]
 \_ #:#:#:# sdf 8:80  [active][ready]
\_ round-robin 0 [prio=3][enabled]
 \_ #:#:#:# sdg 8:96  [active][ready]
mpath8 (360026b9000372ce900000a8f4b14fb0d) dm-15 ,
[size=250G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=3][enabled]
 \_ #:#:#:# sdd 8:48  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# sde 8:64  [active][ghost]
mpath7 (360026b9000372cf300000ece4b14fa59) dm-14 ,
[size=250G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=3][enabled]
 \_ #:#:#:# sdb 8:16  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# sdc 8:32  [active][ghost]


# SMdevices
Dell Modular Disk Storage Manager Devices, Version 10.01.A6.01
Built Mon Sep 22 09:20:05 CDT 2008
Copyright (C) 2006 - 2008  Dell Inc. All rights reserved.

  /dev/sdg (/dev/sg10) [Storage Array NLV-md3000i, Virtual Disk
Access, LUN 31, Virtual Disk ID <60026b9000372cf3000005384ac4961e>]
  /dev/sdb (/dev/sg5) [Storage Array NLV-md3000i, Virtual Disk
VD1_NAV, LUN 1, Virtual Disk ID <60026b9000372cf300000ece4b14fa59>,
Preferred

Path (Controller-0): In Use]
  /dev/sdc (/dev/sg6) [Storage Array NLV-md3000i, Virtual Disk
VD1_NAV, LUN 1, Virtual Disk ID <60026b9000372cf300000ece4b14fa59>,
Alternate

Path (Controller-1): Not In Use]
  /dev/sdd (/dev/sg7) [Storage Array NLV-md3000i, Virtual Disk
VD2_SQL, LUN 2, Virtual Disk ID <60026b9000372ce900000a8f4b14fb0d>,
Preferred

Path (Controller-0): In Use]
  /dev/sde (/dev/sg8) [Storage Array NLV-md3000i, Virtual Disk
VD2_SQL, LUN 2, Virtual Disk ID <60026b9000372ce900000a8f4b14fb0d>,
Alternate

Path (Controller-1): Not In Use]
  /dev/sdf (/dev/sg9) [Storage Array NLV-md3000i, Virtual Disk Access,
LUN 31, Virtual Disk ID <60026b9000372cf3000005384ac4961e>]

# cat /etc/mu
multipath.conf      multipath.conf_bkp
[root@NLV-xendom0 multipath-tools]# cat /etc/multipath.conf
defaults {
        udev_dir                /dev
        user_friendly_names     yes
        path_checker            rdac
        # path_grouping_policy    group_by_prio
        hardware_handler        "1 rdac"
        path_grouping_policy    failover
        prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
        features                "1 queue_if_no_path"
        failback                immediate
        no_path_retry           fail
}
blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^sda"
        devnode "^sda[0-9]"
        device {
                vendor DELL
                product "PERC|Universal"
        }
}
blacklist_execptions {
        device {
                vendor "IBM"
                product "S/390 DASD.*"
        }
}
devices {
        device {
                vendor                  "DELL"
                product                 "MD3000i*"
                product_blacklist       "Universal Xport  "
                features                "1 queue_if_no_path"
                hardware_handler        "1 rdac"
                path_grouping_policy    group_by_prio
                prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
                getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
        }
}
multipaths {
        multipath {
                wwid                    360026b9000372cf300000ece4b14fa59
                alias                   mpath7
                path_grouping_policy    group_by_prio
                path_selector           "round-robin 0"
                failback                manual
                rr_weight               priorities
                no_path_retry           5
                rr_min_io               100
                hardware_handler        "1 rdac"
        }
        multipath {
                wwid                    360026b9000372ce900000a8f4b14fb0d
                alias                   mpath8
                path_grouping_policy    group_by_prio
                path_selector           "round-robin 0"
                failback                manual
                rr_weight               priorities
                no_path_retry           5
                rr_min_io               100
                hardware_handler        "1 rdac"
        }
}



# lsscsi
[0:0:32:0]   enclosu DP       BACKPLANE        1.05  -
[0:2:0:0]    disk    DELL     PERC 6/i         1.11  /dev/sda
[2:0:0:0]    cd/dvd  TEAC     DVD-ROM DV28EV   D.AG  /dev/sr0
[14:0:0:0]   disk    DELL     MD3000i          0735  -
[14:0:0:1]   disk    DELL     MD3000i          0735  /dev/sdc
[14:0:0:2]   disk    DELL     MD3000i          0735  /dev/sde
[14:0:0:31]  disk    DELL     Universal Xport  0735  /dev/sdg
[15:0:0:0]   disk    DELL     MD3000i          0735  -
[15:0:0:1]   disk    DELL     MD3000i          0735  /dev/sdb
[15:0:0:2]   disk    DELL     MD3000i          0735  /dev/sdd
[15:0:0:31]  disk    DELL     Universal Xport  0735  /dev/sdf

From: Matti Keranen <matti.keranen@fmi.fi>
Subject: multipath devices fail with CX-700
Date: Fri, 09 Jun 2006 14:58:46 +0300
Message-ID: <44896276.5010607@fmi.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

hei,

we have two Altix 3700bx boxes with sles9 connected to two Clariion 
CX-700.  The other host  has  problems  with multipath:


sambo:~ # multipath -l
dm names   N
dm table 360060160f389120074e2fa5c6092da11p1  N
dm table 360060160f389120074e2fa5c6092da11  N
dm table 360060160f389120074e2fa5c6092da11  N
dm status 360060160f389120074e2fa5c6092da11  N
dm info 360060160f389120074e2fa5c6092da11  O
dm table 360060160685510009659bbb697cfda11  N
dm table 360060160685510009659bbb697cfda11  N
dm status 360060160685510009659bbb697cfda11  N
dm info 360060160685510009659bbb697cfda11  O
dm table 350060160b06013a050060160b06013a0  N
dm table 350060160b06013a050060160b06013a0  N
dm status 350060160b06013a050060160b06013a0  N
dm info 350060160b06013a050060160b06013a0  O
dm table 360060160685510002aee0cba1da9da11  N
dm table 360060160685510002aee0cba1da9da11  N
dm status 360060160685510002aee0cba1da9da11  N
dm info 360060160685510002aee0cba1da9da11  O
360060160f389120074e2fa5c6092da11
[size=250 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 3:0:1:2     sdn  8:208  [active][ready]
 \_ 4:0:1:2     sdw  65:96  [active][ready]
\_ round-robin 0 [enabled]
 \_ 3:0:0:2     sdl  8:176  [active][faulty]
 \_ 4:0:0:2     sdu  65:64  [active][faulty]

360060160685510009659bbb697cfda11
[size=3668 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 4:0:2:4     sdz  65:144 [active][ready]
 \_ 3:0:2:4     sdad 65:208 [active][ready]
\_ round-robin 0 [enabled]
 \_ 4:0:3:4     sdac 65:192 [active][faulty]
 \_ 3:0:3:4     sds  65:32  [active][faulty]

350060160b06013a050060160b06013a0
[size=1 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 3:0:0:0     sdk  8:160  [failed][faulty]
 \_ 3:0:1:0     sdm  8:192  [failed][faulty]
 \_ 4:0:0:0     sdt  65:48  [failed][faulty]
 \_ 4:0:1:0     sdv  65:80  [failed][faulty]

360060160685510002aee0cba1da9da11
[size=240 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 3:0:2:3     sdp  8:240  [failed][faulty]
 \_ 4:0:2:3     sdy  65:128 [failed][faulty]
\_ round-robin 0 [active]
 \_ 4:0:3:3     sdab 65:176 [active][ready]
 \_ 3:0:3:3     sdr  65:16  [active][ready]


Secondary paths to this last 240GB lun are failed . Interesting is that 
paths to other LUNs from the same target(s) are ok.
Is there any command to force the multipath rescan the devices? I have 
restarted the multpathd but it does not help. Yesterday evening all 
paths to this device failed but running multpath fixed this issue.

Another issue is the 1GB "LUN" that actually is not a LUN but the 
Clariion SP .  When the host is booted we need to disconnect the FC 
otherwise the system won't come up but stop in "creating devices" . My 
guess is that when the multipath finds this device with no active paths 
the multipath gives up but the boot does not continue.

The last boot messages:

device-mapper: dm-emc: emc_endio: pg_init error -5
device-mapper: dm-emc: emc_endio: Found valid sense data 052602
device-mapper: dm-multipath: 65:192: Error trying to initialize PG, 
failing path
device-mapper: dm-multipath: Failing path 65:192

without fc the system boots up ok and I can add the scsi devices 
manually and run multpath without any problems. I have blacklisted the 
device in multipath.conf but for some reason blacklisting does not work 
for this device.

Any ideas how to fix this boot issue?

multipath-tools is the one shipped with Suse. There is newer package 
available but it has similar problems plus it does not read the 
blacklist from multipath.conf (or maybe the syntax has changed?) .


sambo:~ # rpm -qa |grep multipath
multipath-tools-0.4.5-0.11

kernel is the SGI sn2 .

sambo:~ # uname -a
Linux sambo 2.6.5-7.252-sn2 #1 SMP Tue Feb 14 11:11:04 UTC 2006 ia64 
ia64 ia64 GNU/Linux


multipath.conf:

I wrote the defaults out as the multipath did not always recognize the 
Clariion devices correctly.

sambo:~ # cat /etc/multipath.conf
# multipath config 8.3.2006 mattik
# katso /usr/share/doc/packages/multipath-tools/multipath.conf.annotated

defaults {

        multipath_tool  "/sbin/multipath v0"
        udev_dir        /dev
        polling_interval 5
        default_selector "round-robin 0"
        default_path_grouping_policy    multibus
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    /bin/true
        rr_min_io       1000
        rr_weight       uniform
        failback        immediate
}

devnode_blacklist {

        #SGI local & JBOD
        wwid SSGI_ST3146707LC_3KS0FX0K00007535HKZN
        wwid SSGI_ST373454LC_3KP0HZTZ000075443N5B
        wwid SSGI_ST373454LC_3KP0J0DH00007535H6SF
        wwid SSGI_ST373454LC_3KP0JJMD000075444QP9
        wwid SSGI_ST373454LC_3KP0HSFL00007544WT2U
        wwid SSGI_ST373454LC_3KP0JB4P00007543R83C
        wwid SSGI_ST373454LC_3KP0JAE8000075443RKN
        wwid SSGI_ST373454LC_3KP0J53H000075431M8Q
        wwid SSGI_ST373454LC_3KP0J64F00007544WRLC
        wwid 360060160f3891200e4d229aefa3ada11

        #dvd
        devnode "/dev/dvd"
        # sp
        wwid    350060160b060139650060160b0601396

        # defaults
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"
}

# oletukset (hwtable.c)
devices {
        device {
                vendor "DGC"
                product "*"
                path_grouping_policy group_by_prio
                prio_callout    "/sbin/mpath_prio_emc /dev/%n"
                hardware_handler "1 emc"
                features "1 queue_if_no_path"
                checker "emc_clariion"
       }
}




any help appreciated

cheers

Matti Keranen

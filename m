From: Nicola Murino <n.murino@theorematica.it>
Subject: EMC CX 300 multipath problem
Date: Mon, 12 Sep 2005 10:04:52 +0200
Message-ID: <432536A4.7040306@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
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
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I have some problem with multipath-tools,

 multipath -ll
web (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:4 sdf 8:80  [active][ready]

mysql (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32  [active][ready]

mail (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:0 sdb 8:16  [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:2 sdd 8:48  [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][ready]

only one disk is active,

I have to do the command:

nodob mapper # multipath /dev/sdb
error calling out /sbin/scsi_id -g -u -s /block/sda
reload: mail (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [prio=1]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
 \_ 2:0:0:0 sdg 8:96  [ready]

and now the other path is activated:

nodob mapper # multipath /dev/sdb
error calling out /sbin/scsi_id -g -u -s /block/sda
reload: mail (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [prio=1]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
 \_ 2:0:0:0 sdg 8:96  [active][ready]


multipath -ll
web (3600601608c9012006269b8f63b87d911)
[size=5 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:4 sdf 8:80  [active][ready]

mysql (3600601608c901200ccfe543f4053d911)
[size=200 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32  [active][ready]

mail (3600601608c9012008ae5de2cc985d911)
[size=300 GB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
 \_ 2:0:0:0 sdg 8:96  [active][ready]

3600601608c901200a8b8972f4053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:2 sdd 8:48  [active][ready]

3600601608c901200bc7680294053d911
[size=100 MB][features="0"][hwhandler="1 emc"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][ready]

in /dev/mapper I have the following:

brw-------  1 root root 254,  3 Sep 12  2005
3600601608c901200a8b8972f4053d911
brw-------  1 root root 254,  1 Sep 12  2005
3600601608c901200bc7680294053d911
crw-rw----  1 root root  10, 63 Sep 12  2005 control
brw-------  1 root root 254,  4 Sep 12  2005 mail
brw-------  1 root root 254,  5 Sep 12  2005 mail1
brw-------  1 root root 254,  0 Sep 10 20:23 mysql
brw-------  1 root root 254,  2 Sep 10 20:23 mysql1
brw-------  1 root root 254,  7 Sep 12  2005 vg00-admin
brw-------  1 root root 254, 13 Sep 12  2005 vg00-log
brw-------  1 root root 254, 11 Sep 12  2005 vg00-portage
brw-------  1 root root 254,  8 Sep 12  2005 vg00-root
brw-------  1 root root 254,  9 Sep 12  2005 vg00-tmp
brw-------  1 root root 254, 10 Sep 12  2005 vg00-usr
brw-------  1 root root 254, 12 Sep 12  2005 vg00-var
brw-------  1 root root 254,  6 Sep 12  2005 web

is correct?

grep -v "#" /etc/multipath.conf
defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
}
multipaths {
        multipath {
                wwid                    3600601608c9012008ae5de2cc985d911
                alias                   mail
                path_grouping_policy    multibus
                 path_checker           readsector0
                path_selector           "round-robin 0"

                failback                immediate
}
        multipath {
                wwid                    3600601608c901200ccfe543f4053d911
                alias                   mysql
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
        }
        multipath {
                wwid                    3600601608c9012006269b8f63b87d911
                alias                   web
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
        }
}

nodob mapper # lspci
0000:00:00.0 Host bridge: Intel Corp. E7520 Memory Controller Hub (rev 09)
0000:00:02.0 PCI bridge: Intel Corp. E7525/E7520/E7320 PCI Express Port
A (rev 09)
0000:00:04.0 PCI bridge: Intel Corp. E7525/E7520 PCI Express Port B (rev 09)
0000:00:05.0 PCI bridge: Intel Corp. E7520 PCI Express Port B1 (rev 09)
0000:00:06.0 PCI bridge: Intel Corp. E7520 PCI Express Port C (rev 09)
0000:00:1d.0 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #1 (rev 02)
0000:00:1d.1 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB
UHCI Controller #2 (rev 02)
0000:00:1d.2 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB
UHCI #3 (rev 02)
0000:00:1d.7 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB2
EHCI Controller (rev 02)
0000:00:1e.0 PCI bridge: Intel Corp. 82801 PCI Bridge (rev c2)
0000:00:1f.0 ISA bridge: Intel Corp. 82801EB/ER (ICH5/ICH5R) LPC
Interface Bridge (rev 02)
0000:00:1f.1 IDE interface: Intel Corp. 82801EB/ER (ICH5/ICH5R) IDE
Controller (rev 02)
0000:01:00.0 PCI bridge: Intel Corp. 80332 [Dobson] I/O processor (rev 06)
0000:01:00.2 PCI bridge: Intel Corp. 80332 [Dobson] I/O processor (rev 06)
0000:02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID
controller 4 (rev 06)
0000:05:00.0 PCI bridge: Intel Corp. 6700PXH PCI Express-to-PCI Bridge A
(rev 09)
0000:05:00.2 PCI bridge: Intel Corp. 6700PXH PCI Express-to-PCI Bridge B
(rev 09)
0000:06:07.0 Ethernet controller: Intel Corp. 82541GI/PI Gigabit
Ethernet Controller (rev 05)
0000:07:08.0 Ethernet controller: Intel Corp. 82541GI/PI Gigabit
Ethernet Controller (rev 05)
0000:08:00.0 PCI bridge: Intel Corp. 6700PXH PCI Express-to-PCI Bridge A
(rev 09)
0000:08:00.2 PCI bridge: Intel Corp. 6700PXH PCI Express-to-PCI Bridge B
(rev 09)
0000:09:04.0 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A
U160/m (rev 01)
0000:09:04.1 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A
U160/m (rev 01)
0000:0a:02.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter
(rev 02)
0000:0a:03.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter
(rev 02)
0000:0b:0d.0 VGA compatible controller: ATI Technologies Inc Radeon
RV100 QY [Radeon 7000/VE]


nodob mapper # lsmod
Module                  Size  Used by
dm_round_robin          4096  1
qla2300               125056  0
qla2xxx               112092  20 qla2300
firmware_class          8832  1 qla2xxx
dm_emc                  6144  1
dm_multipath           19464  3 dm_round_robin,dm_emc
dm_mod                 52380  12 dm_multipath

from dmesg:

device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
e1000: eth0: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex
e1000: eth1: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: emc_pg_init: sending switch-over command
device-mapper: dm-emc: emc_pg_init: sending switch-over command
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)

I'm using gentoo, udev-0.68, device-mapper-1.03, multipath-tools-0.4.5,
kernel-2.6.13 (2.6.12 give oops when load qla2300)


some suggestions?

I have to post other specific configuration o log file?

thanks,

Nicola

From: John Little <jslittl@hendricks.org>
Subject: Multipath and SAN Fabric failover
Date: Thu, 7 Sep 2006 13:39:43 -0400
Message-ID: <20060907133943.4aa92481@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

Hi all,

I am trying to setup our server so that we have fabric failover from
the san.  However my file sytem comes up read-only when I pull a cable
for testing.

I am using the following:
SLES 10
multipath-tools-0.4.6-25.8
q-logic 2342 dual port hba
emc cx600 san
(4) McData DS-24 switches (2 for fabric a and 2 for fabric b)

I have one port from the hba plugged into fabric a and the other
plugged into fabric b.

multipath -v2 -d before failover gives the following:
xen2:~ # multipath -v2 -d
create: SSEAGATE_ST973401LSUN72G0910FQL9_3LB0FQL9SEAGATE,ST973401LSUN72G
[size=68G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][undef]
 \_ 0:2:0:0 sda 8:0   [undef][ready]
SSEAGATE_ST973401LSUN72G0910FPHE_3LB0FPHESEAGATE,ST973401LSUN72G
[size=68G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][undef]
 \_ 0:3:1:0 sdb 8:16  [active][ready]
capsprod (360060160f06109004352b218eb51da11) DGC,RAID 5
[size=50G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=1][undef]
 \_ 1:0:0:0 sdc 8:32  [active][ready]
\_ round-robin 0 [prio=1][undef]
 \_ 1:0:1:0 sde 8:64  [active][ready]
360060160f0610900ea604e9d2412db11DGC,RAID 5
[size=58G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][undef]
 \_ 1:0:0:1 sdd 8:48  [active][ready]
 \_ 1:0:1:1 sdf 8:80  [active][ready]
capsprod (360060160f06109004352b218eb51da11) DGC,RAID 5
[size=50G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=1][undef]
 \_ 1:0:0:0 sdc 8:32  [undef][ready]
\_ round-robin 0 [prio=1][undef]
 \_ 1:0:1:0 sde 8:64  [undef][ready]
360060160f0610900ea604e9d2412db11DGC,RAID 5
[size=58G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][undef]
 \_ 1:0:0:1 sdd 8:48  [undef][ready]
 \_ 1:0:1:1 sdf 8:80  [undef][ready]

The disc that I'm using for test has the alias capsprod.

When I pull the cable from fabric a multipath -v2 -d gives:
xen2:~ # multipath -v2 -d
sdc: checker msg is "emc_clariion_checker: query command indicates
error"
error calling out /sbin/scsi_id -g -u -s /block/sdc
sdd: checker msg is "emc_clariion_checker: query command indicates
error"
error calling out /sbin/scsi_id -g -u -s /block/sdd
sde: checker msg is "emc_clariion_checker: query command indicates
error"
error calling out /sbin/scsi_id -g -u -s /block/sde
sdf: checker msg is "emc_clariion_checker: query command indicates
error"
error calling out /sbin/scsi_id -g -u -s /block/sdf
create: SSEAGATE_ST973401LSUN72G0910FQL9_3LB0FQL9SEAGATE,ST973401LSUN72G
[size=68G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][undef]
 \_ 0:2:0:0 sda 8:0   [undef][ready]
SSEAGATE_ST973401LSUN72G0910FPHE_3LB0FPHESEAGATE,ST973401LSUN72G
[size=68G][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][undef]
 \_ 0:3:1:0 sdb 8:16  [active][ready]
sdc: checker msg is "emc_clariion_checker: query command indicates
error"
sde: checker msg is "emc_clariion_checker: query command indicates
error"
capsprod (360060160f06109004352b218eb51da11) DGC,RAID 5
[size=50G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:0:0 sdc 8:32  [failed][faulty]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:1:0 sde 8:64  [failed][faulty]
sdd: checker msg is "emc_clariion_checker: query command indicates
error"
sdf: checker msg is "emc_clariion_checker: query command indicates
error"
360060160f0610900ea604e9d2412db11DGC,RAID 5
[size=58G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:0:1 sdd 8:48  [failed][faulty]
 \_ 1:0:1:1 sdf 8:80  [failed][faulty]
sdc: checker msg is "emc_clariion_checker: query command indicates
error"
sde: checker msg is "emc_clariion_checker: query command indicates
error"
capsprod (360060160f06109004352b218eb51da11) DGC,RAID 5
[size=50G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:0:0 sdc 8:32  [undef][faulty]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:1:0 sde 8:64  [undef][faulty]
sdd: checker msg is "emc_clariion_checker: query command indicates
error"
sdf: checker msg is "emc_clariion_checker: query command indicates
error"
360060160f0610900ea604e9d2412db11DGC,RAID 5
[size=58G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:0:1 sdd 8:48  [undef][faulty]
 \_ 1:0:1:1 sdf 8:80  [undef][faulty]

/etc/multipath.conf has the following entries:

xen2:~ # grep -v "#" /etc/multipath.conf
defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        failback                immediate
}
devnode_blacklist {
        device {
                vendor SEAGATE
                product ST973401LSUN72G
        }
}
multipaths {
        multipath {
                wwid                    360060160f06109004352b218eb51da11
                alias                   capsprod
                path_grouping_policy    failover
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
        }
}

Can someone point me in the right direction to get this resolved?

Best regards,
John Little, Network Systems
Hendricks Regional Health
http://hendrickshospital.org

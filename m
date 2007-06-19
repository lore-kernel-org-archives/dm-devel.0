From: "Wilson, Christopher J" <chris.j.wilson@verizonbusiness.com>
Subject: Device mapper devices not created before fsck at boot
Date: Tue, 19 Jun 2007 22:52:44 +0100
Message-ID: <500DD6DE2DFA8E40A33E5898D9471B9702268C22@ASHEVS006.mcilink.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Apologies for my previous reply.  Here's the same on a new thread.
=20
I have a system(s) which is failing to fsck /dev/mapper/<wwn> devices
during boot time.  The dev-mapper devices are not created from the time
dmsetup is run in rc.sysinit until the device fsck is run (next block).
The only device in /dev/mapper is /dev/mapper/control, none of the <wwn>
devices exist before fsck attempts to run.  I have put in a "sleep 10"
in between the two code blocks and this has worked on one system and not
others. =20

From our research our understanding is that there is a race condition
somewhere in udev and dmsetup.  Does anyone know if there is a fix for
this issue or have encountered anything similar?  Is there anything I
can pass to dmsetup to ensure that devices are created before it
returns?  This appears to be specific to the latest generation HP
servers for some reason (faster procs?).

Information about the system and lsmod and ls -al /dev/mapper/ commands
inserted in rc.sysinit below.

OS: RHAS 4
Kernel: 2.6.9-42.Elsmp and 2.6.9-55.Elsmp

Hardware: HP DL380G5
		2x proc (latest multi-core)
		external disk: 3PARdata
		HBA: Qlogic 2460 PCI-x
		HBA driver: 8.01.04-d7

Tue Jun 19 17:12:09 EDT 2007

>> ls -al /dev/mapper/* is run here

crw-------  1 root root 10, 63 Jun 19 13:11 /dev/mapper/control

>> lsmod is run here - note dm_round_robin is not loaded

Module                  Size  Used by
dm_mirror              32465  0
dm_multipath           21841  0
button                  9057  0
battery                11209  0
ac                      6729  0
hw_random               7137  0
bnx2                  147253  0
qla2400               201025  0
ext3                  137809  2
jbd                    69104  1 ext3
dm_mod                 68097  2 dm_mirror,dm_multipath
ata_piix               14405  0
libata                 78473  1 ata_piix
qla2300               127425  0
qla2322               137537  0
cciss                  69809  3
qla2xxx               183201  3 qla2400,qla2300,qla2322
scsi_transport_fc      11841  1 qla2xxx
sd_mod                 19393  0
scsi_mod              141457  5
libata,cciss,qla2xxx,scsi_transport_fc,sd_mod

Tue Jun 19 17:12:19 EDT 2007

>> ls -al /dev/mapper/* run again 10 seconds later

brw-rw----  1 root disk 253,  0 Jun 19 17:12
/dev/mapper/350002ac0000c03fd
brw-rw----  1 root disk 253,  1 Jun 19 17:12
/dev/mapper/350002ac0000c03fd1
crw-------  1 root root  10, 63 Jun 19 13:11 /dev/mapper/control

>> dm_round_robin is loaded

Module                  Size  Used by
dm_round_robin          4929  1
dm_mirror              32465  0
dm_multipath           21841  2 dm_round_robin
button                  9057  0
battery                11209  0
ac                      6729  0
hw_random               7137  0
bnx2                  147253  0
qla2400               201025  0
ext3                  137809  2
jbd                    69104  1 ext3
dm_mod                 68097  6 dm_mirror,dm_multipath
ata_piix               14405  0
libata                 78473  1 ata_piix
qla2300               127425  0
qla2322               137537  0
cciss                  69809  3
qla2xxx               183201  5 qla2400,qla2300,qla2322
scsi_transport_fc      11841  1 qla2xxx
sd_mod                 19393  2
scsi_mod              141457  5
libata,cciss,qla2xxx,scsi_transport_fc,sd_mod




______________________________________________________________________
This e-mail has been scanned by Verizon Managed Email Content Service, us=
ing Skeptic=99 technology powered by MessageLabs. For more information on=
 Verizon Managed Email Content Service, visit http://www.verizonbusiness.=
com.
______________________________________________________________________

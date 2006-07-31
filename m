From: "Jeff Gibson" <jgibson@spscommerce.com>
Subject: Bug in multipath detecting devices
Date: Mon, 31 Jul 2006 17:29:51 -0500
Message-ID: <E59516884AA0B041BCB80771B7714983365199@lumbergh.spscommerce.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

I believe I have found a bug in multipath when it detects devices.  But
first off here is my config:

Redhat 4 update 3 x86-64
1 internal LSI Logic RAID controller (mirrored disks on device sda)
2 dual-port Qlogic 2342 Fibre-channel HBA.  Port 1 grabs disks sdb-sds,
Port 2 grabs sdt-sdak.
2 McData 4500 Fibre switches
1 Hitachi DF600F SAN.  Dual RAID controller with 2 Fibre ports per
controller.

I have each port from the qlogic card going to a separate switch.  Each
switch then has 2 links back to the SAN, 1 going to each port on each
raid controller.  A rough text drawing would look like this:

			_______________
		     |	HBA	   |
			---1--------2--
			   |        |
		___________      ___________
	     |   SW-1    |    |    SW-2   |
		-|-------|-      -|-------|-
		 \       |  ______|_______/
		  \______|_/____  |     =20
			   | |    \ |         =20
			---|-|SAN-|-|---
		     |        |       |
		     | ctlr1  | ctlr2 |
		     |        |       |
			----------------

The result is that each disk/lun on the SAN shows up to the OS 4 times.
Using pp_hds_modular with multipath I can load balance to both ports on
the same controller on the SAN (there is a performance loss on Hitachi
systems of you load balance between controllers).  The downside to this
is that your end up using a lot of disk devices in linux.  For example,
I have 9 luns shared out on the SAN, but the OS sees 36 disks.  Using
multipath I can bring that back down to 9, but here's where we run into
the bug.	=09

It seems that if you have more than 26 disks/luns it will detect sdaa
before it detects sdb (sda is the onboard raid & is blacklisted).  The
result is that the major/minor numbers in /dev/mapper get out of order
with the disks presented to the system.  For example:

# multipath -v2
create: 1HITACHI_D60085320025
[size=3D50 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [prio=3D2]
 \_ 2:0:1:7 sdaj 66:48  [ready]
 \_ 1:0:0:7 sdi  8:128  [ready]
\_ round-robin 0
 \_ 2:0:0:7 sdaa 65:160 [ready]
 \_ 1:0:1:7 sdr  65:16  [ready]

create: 1HITACHI_D60085320018
[size=3D200 MB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [prio=3D2]
 \_ 1:0:1:0 sdk  8:160  [ready]
 \_ 2:0:0:0 sdt  65:48  [ready]
\_ round-robin 0
 \_ 2:0:1:0 sdac 65:192 [ready]
 \_ 1:0:0:0 sdb  8:16   [ready]


# ls -l /dev/mapper
total 0
brw-rw----  1 root disk 253,  2 Jul 31 16:29 1HITACHI_D60085320018
brw-rw----  1 root disk 253,  3 Jul 31 16:29 1HITACHI_D60085320019
brw-rw----  1 root disk 253,  4 Jul 31 16:29 1HITACHI_D60085320020
brw-rw----  1 root disk 253,  5 Jul 31 16:29 1HITACHI_D60085320021
brw-rw----  1 root disk 253,  6 Jul 31 16:29 1HITACHI_D60085320022
brw-rw----  1 root disk 253,  7 Jul 31 16:29 1HITACHI_D60085320023
brw-rw----  1 root disk 253,  8 Jul 31 16:29 1HITACHI_D60085320024
brw-rw----  1 root disk 253,  0 Jul 31 16:29 1HITACHI_D60085320025
brw-rw----  1 root disk 253,  1 Jul 31 16:29 1HITACHI_D60085320026
crw-------  1 root root  10, 63 Jul 31 16:01 control

In the above 1HITACHI_D60085320018 (the container of sdb) *should* be at
253,0.  Instead sdaa is.

The major problem with this is that if I add another disk/lun in the
future sdaa will change to another disk.  This is because sdaa is on the
second port of the qlogic card and gets detected as a later device than
before.  When multipath comes along it creates the device in /dev/mapper
that sdaa is a member of before sdb's device is created.  As a result
the multipath devices aren't in the same sequnce as the devices that the
OS detects (sdb, sdc, etc).  It would be better if sdb was always
detected before sdaa.  However, I don't see a way to do that in
/etc/multipath.conf without blacklisting all of the sda* drives.
Another option would be to have a user-configurable scan order, which I
don't think exists (correct me if I'm wrong). =20

Anyway, I hope this information helps.  Let me know if you have any
questions of if I'm missing something.

Thanks,
JG=20

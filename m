From: "Chen, Yukun" <yukun.chen@intel.com>
Subject: Fail to mkfs after multipath runs
Date: Wed, 30 Mar 2005 17:35:12 +0800
Message-ID: <16A54BF5D6E14E4D916CE26C9AD305750184A649@pdsmsx402.ccr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
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

Hi all,

   I have setuped a multipath enviornment as follows:
   (S/W)
	Linux distribution =E2=80=93 RHEL 4
	Linux kernel --- 2.6.10 or later (kernel.org)
	QLogic driver version =E2=80=93 8.00.00b21
	Multipath I/O kernel patch =E2=80=93 2.6.10-rc1-udm1
	Multipath I/O tools =E2=80=93 multipath-tools-0.4.3=20
	Udev version =E2=80=93 v045

    (H/W)=20
          2 QLogic ISP2312 dual port FC HBA
	Emulex 375 Fiber Channel switch( 2 ports are connected to JBOD)
	Adaptec Fiber Channel JBOD

     First, I edit /etc/multipath.conf to add alias for sda and sdc.

     Then,=20
             multipathd
             multipath =20
             mkfs /udev/disk1 -t ext3

      Now, sda is formating and sometimes some error messages appeared on=
 screen:

#################
	mke2fs 1.35 (28-Feb-2004)
	max_blocks 4294967295, rsv_groups =3D 0, rsv_gdb =3D 1024
	Filesystem label=3D
	OS type: Linux
	Block size=3D4096 (log=3D2)
	Fragment size=3D4096 (log=3D2)
	4447744 inodes, 8891620 blocks
	444581 blocks (5.00%) reserved for the super user
	First data block=3D0
	Maximum filesystem blocks=3D12582912
	272 block groups
	32768 blocks per group, 32768 fragments per group
	16352 inodes per group
	Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 26=
54208,
        4096000, 7962624

	Writing inode tables: done
	inode.i_blocks =3D 98312, i_size =3D 4243456
	Creating journal (8192 blocks): done
	Writing superblocks and filesystem accounting information: 1:0:0:0: sg_i=
o failed
	 status 0x0 0x2 0x0 0x0
	1:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
	pb getting path info, free
	1:0:1:0: sg_io failed status 0x0 0x1 0x0 0x0
	1:0:1:0: Unable to get INQUIRY vpd 1 page 0x0.
	pb getting path info, free
	1:0:2:0: sg_io failed status 0x0 0x1 0x0 0x0
.......
#############################

In the meanwhile, I can get some error messages from dmesg as follows:
############################
qla2300 0000:07:01.1: Performing ISP error recovery - ha=3D c2314250.
SCSI error : <1 0 0 0> return code =3D 0x20000
end_request: I/O error, dev sdd, sector 42731920
qla2300 0000:07:01.0: LIP reset occured (f7f7).
qla2300 0000:07:01.0: LIP occured (f7f7).
qla2300 0000:07:01.1: Parity error -- HCCR=3D5cb0.
qla2300 0000:07:01.0: LIP reset occured (f7f7).
qla2300 0000:07:01.0: LIP occured (f7f7).
qla2300 0000:07:01.1: Performing ISP error recovery - ha=3D c2314250.
############################

Any comments for it?
Thanx.

-Aaron=20

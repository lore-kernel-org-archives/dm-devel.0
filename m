From: Guy Coates <gmpc@sanger.ac.uk>
Subject: Re: Detecting Multiple Paths to LU
Date: Wed, 16 Feb 2005 14:22:51 +0000 (GMT)
Message-ID: <Pine.OSF.4.44.0502161409520.1852333-100000@ecs2c.internal.sanger.ac.uk>
References: <002401c51431$065872a0$11051aac@pcp41116>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <002401c51431$065872a0$11051aac@pcp41116>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: shahid.shaikh@patni.com, device-mapper development <dm-devel@redhat.com>
Cc: "Sandhya Suman (E-mail)" <sandhya.suman@odc.patni.com>, "Christophe Varoqui (E-mail)" <christophe.varoqui@free.fr>
List-Id: dm-devel.ids


You need to set up lvm.conf to do the following. It probably is totally
correct, but it seems to work well enough.


# Make lvm look at the multipath device maps only, not the
# single devices

scan = [ "/dev/mapper" ]

# exclude the raw disks, just to be paranoid
filter = ["r|/dev/sd|"]

# make lvm use dm devices
types = [ "device-mapper", 16 ]


Once you assembled the multipath devices you can then run

pvcreate /dev/mapper/XXXXX

and create your volume groups.


I've created and then extended and LVM across two multipathed physical
volumes on my test system.



  --- Volume group ---
  VG Name               web409mysqltest
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               199.99 GB
  PE Size               4.00 MB
  Total PE              51198
  Alloc PE / Size       51198 / 199.99 GB
  Free  PE / Size       0 / 0
  VG UUID               CzUDTb-KpRz-KNLS-U24P-5TmZ-4WLN-OSjGBB

  --- Logical volume ---
  LV Name                /dev/web409mysqltest/mysqltest1
  VG Name                web409mysqltest
  LV UUID                tT9PHO-1UVt-RsNN-6iFM-KgQx-Gl9r-adck9U
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                199.99 GB
  Current LE             51198
  Segments               2
  Allocation             inherit
  Read ahead sectors     0
  Block device           254:16

  --- Physical volumes ---
  PV Name               /dev/mapper/3600508b40001417e0001c00001b60000
  PV UUID               3QvL3p-t45P-AY4x-nIHp-C44s-IM6O-2Ymuwy
  PV Status             allocatable
  Total PE / Free PE    25599 / 0

  PV Name               /dev/mapper/3600508b40001417e0001c00001c90000
  PV UUID               QGEVaA-W3sJ-DkLB-Ble1-13sU-bL6u-3tNy78
  PV Status             allocatable
  Total PE / Free PE    25599 / 0



/sbin/dmsetup  status  /dev/mapper/3600508b40001417e0001c00001c90000
0 209715200 multipath 1 0 0 2 2 E 0 2 0 65:240 A 0 8:176 A 0 E 0 2 0 8:16 A 0 65:80 A 0

 /sbin/dmsetup  status /dev/mapper/3600508b40001417e0001c00001b60000
0 209715200 multipath 1 0 0 2 2 E 0 2 0 65:224 A 0 8:160 A 0 E 0 2 0 8:0 A 0 65:64 A 0



lvm version report

lvm version
  LVM version:     2.00.24 (2004-09-16)
  Library version: 1.00.19-ioctl (2004-07-03)
  Driver version:  4.3.0


Guy


-- 
Dr. Guy Coates,  Informatics System Group
The Wellcome Trust Sanger Institute, Hinxton, Cambridge, CB10 1SA, UK
Tel: +44 (0)1223 834244 ex 7199


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

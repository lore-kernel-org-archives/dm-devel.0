From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: Detecting Multiple Paths to LU
Date: Thu, 17 Feb 2005 13:09:48 +0530
Message-ID: <006f01c514c3$dbfa2830$11051aac@pcp41116>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1108625676-5493-167"
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: gmpc@sanger.ac.uk
Cc: "Dm-Devel (E-mail)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format...

------------=_1108625676-5493-167
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Coates,

Thanks for the information.I am close to the solution now.

>>Once you assembled the multipath devices you can then run pvcreate
/dev/mapper/XXXXX  and create your volume groups.

But the only thing i am unable to understand is that how would I assemble
the multipath device?
who will do this for us LVM2 or Device mapper and how?
What are the steps I need to follow? What argument should I provide to
pvcreate as I had already filtered "sd" devices?
How would I create my assembled device "/dev/mapper/XXXXX"?
It would be very helpful if you could tell me what are the steps to create
assembled device "/dev/mapper/XXXXX". How this assembled device is mapped to
the underlying "sd" devices?


Regards
Shahid Shaikh.



-----Original Message-----
From: Guy Coates [mailto:gmpc@sanger.ac.uk]
Sent: Wednesday, February 16, 2005 7:53 PM
To: shahid.shaikh@patni.com; device-mapper development
Cc: Christophe Varoqui (E-mail); Sandhya Suman (E-mail)
Subject: Re: [dm-devel] Detecting Multiple Paths to LU



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
0 209715200 multipath 1 0 0 2 2 E 0 2 0 65:240 A 0 8:176 A 0 E 0 2 0 8:16 A
0 65:80 A 0

 /sbin/dmsetup  status /dev/mapper/3600508b40001417e0001c00001b60000
0 209715200 multipath 1 0 0 2 2 E 0 2 0 65:224 A 0 8:160 A 0 E 0 2 0 8:0 A 0
65:64 A 0



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



http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail.
_____________________________________________________________________






http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail. 
_____________________________________________________________________

------------=_1108625676-5493-167
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
------------=_1108625676-5493-167--

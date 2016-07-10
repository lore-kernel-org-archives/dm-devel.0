From: Michel Dubois <michel.dubois.mtl@gmail.com>
Subject: Recover filenames from failed RAID0
Date: Sun, 10 Jul 2016 19:03:45 -0400
Message-ID: <CAAVC+N5m74MyDqZamHgy71vRMhcEY8w_OkiG-GMQKU=JG-QkxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2994197344977923620=="
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
To: linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, NeilBrown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

--===============2994197344977923620==
Content-Type: multipart/alternative; boundary=94eb2c13f53047b6f10537500c68

--94eb2c13f53047b6f10537500c68
Content-Type: text/plain; charset=UTF-8

Dear linux-raid mailing list,

I have a RAID0 array of four 3TB disks that failed on the "third" disk.

I am aware of the non-redundancy of RAID0 but I would like to recover the
filenames from that RAID0. If I could recover some data it would be a bonus.

Below you'll find the outputs of the following commands
 mdadm --examine /dev/sd[abcd]1
 fdisk -l

where sda1, sdb1, sdc1 and sdd1 should be the 4 RAID devices.

What could be my next step?

I thank you for your time

Michel Dubois

======================
mdadm --examine /dev/sd[abcd]1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
  Creation Time : Mon Apr 23 19:55:36 2012
     Raid Level : raid1
  Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
     Array Size : 20980800 (20.01 GiB 21.48 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 27 21:12:23 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1a57db60 - correct
         Events : 164275


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
  Creation Time : Mon Apr 23 19:55:36 2012
     Raid Level : raid1
  Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
     Array Size : 20980800 (20.01 GiB 21.48 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 27 21:12:23 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1a57db72 - correct
         Events : 164275


      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
  Creation Time : Mon Apr 23 19:55:36 2012
     Raid Level : raid1
  Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
     Array Size : 20980800 (20.01 GiB 21.48 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 27 21:12:23 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1a57db86 - correct
         Events : 164275


      Number   Major   Minor   RaidDevice State
this     3       8       33        3      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1

======================
fdisk -l

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk
doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 3000.5 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x03afffbe

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      267350  2147483647+  ee  EFI GPT

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util fdisk
doesn't support GPT. Use GNU Parted.


Disk /dev/sdb: 3000.5 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x142a889c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1      267350  2147483647+  ee  EFI GPT

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util fdisk
doesn't support GPT. Use GNU Parted.


Disk /dev/sdc: 3000.5 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x3daebd50

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      267350  2147483647+  ee  EFI GPT

Disk /dev/md0: 21.4 GB, 21484339200 bytes
2 heads, 4 sectors/track, 5245200 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table

--94eb2c13f53047b6f10537500c68
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-size:12.8px">Dear=C2=A0linux-raid mail=
ing list,</span><div style=3D"font-size:12.8px"><br></div><div style=3D"fon=
t-size:12.8px">I have a RAID0 array of four 3TB disks that failed on the &q=
uot;third&quot; disk.</div><div style=3D"font-size:12.8px"><br></div><div s=
tyle=3D"font-size:12.8px">I am aware of the non-redundancy of RAID0 but I w=
ould like to recover the filenames from that RAID0. If I could recover some=
 data it would be a bonus.</div><div style=3D"font-size:12.8px"><br></div><=
div style=3D"font-size:12.8px">Below you&#39;ll find the outputs of the fol=
lowing commands</div><div style=3D"font-size:12.8px">=C2=A0mdadm --examine =
/dev/sd[abcd]1<br></div><div style=3D"font-size:12.8px">=C2=A0fdisk -l<br><=
/div><div style=3D"font-size:12.8px"><br></div><div style=3D"font-size:12.8=
px">where sda1, sdb1, sdc1 and sdd1 should be the 4 RAID devices.</div><div=
 style=3D"font-size:12.8px"><br></div><div style=3D"font-size:12.8px">What =
could be my next step?</div><div style=3D"font-size:12.8px"><br></div><div =
style=3D"font-size:12.8px">I thank you for your time</div><div style=3D"fon=
t-size:12.8px"><br></div><div style=3D"font-size:12.8px">Michel Dubois</div=
><div style=3D"font-size:12.8px"><br></div><div style=3D"font-size:12.8px">=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</div><di=
v style=3D""><div style=3D"font-size:12.8px">mdadm --examine /dev/sd[abcd]1=
<br></div><div style=3D""><div style=3D""><span style=3D"font-size:12.8px">=
/dev/sda1:</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc</span></div><div style=3D"=
"><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 00=
.90.00</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b2=
1</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 Creat=
ion Time : Mon Apr 23 19:55:36 2012</span></div><div style=3D""><span style=
=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0Raid Level : raid1</span></div><d=
iv style=3D""><span style=3D"font-size:12.8px">=C2=A0 Used Dev Size : 20980=
800 (20.01 GiB 21.48 GB)</span></div><div style=3D""><span style=3D"font-si=
ze:12.8px">=C2=A0 =C2=A0 =C2=A0Array Size : 20980800 (20.01 GiB 21.48 GB)</=
span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0Ra=
id Devices : 4</span></div><div style=3D""><span style=3D"font-size:12.8px"=
>=C2=A0 Total Devices : 3</span></div><div style=3D""><span style=3D"font-s=
ize:12.8px">Preferred Minor : 0</span></div><div style=3D""><span style=3D"=
font-size:12.8px"><br></span></div><div style=3D""><span style=3D"font-size=
:12.8px">=C2=A0 =C2=A0 Update Time : Mon Jun 27 21:12:23 2016</span></div><=
div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 State : clean</span></div><div style=3D""><span style=3D"font-size:=
12.8px">=C2=A0Active Devices : 3</span></div><div style=3D""><span style=3D=
"font-size:12.8px">Working Devices : 3</span></div><div style=3D""><span st=
yle=3D"font-size:12.8px">=C2=A0Failed Devices : 1</span></div><div style=3D=
""><span style=3D"font-size:12.8px">=C2=A0 Spare Devices : 0</span></div><d=
iv style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0C=
hecksum : 1a57db60 - correct</span></div><div style=3D""><span style=3D"fon=
t-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 164275</span></di=
v><div style=3D""><span style=3D"font-size:12.8px"><br></span></div><div st=
yle=3D""><span style=3D"font-size:12.8px"><br></span></div><div style=3D"">=
<span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 Number =C2=A0 Major =
=C2=A0 Minor =C2=A0 RaidDevice State</span></div><div style=3D""><span styl=
e=3D"font-size:12.8px">this =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =
=C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0acti=
ve sync =C2=A0 /dev/sda1</span></div><div style=3D""><span style=3D"font-si=
ze:12.8px"><br></span></div><div style=3D""><span style=3D"font-size:12.8px=
">=C2=A0 =C2=A00 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =
=C2=A0 /dev/sda1</span></div><div style=3D""><span style=3D"font-size:12.8p=
x">=C2=A0 =C2=A01 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 17 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=
=A0 =C2=A02 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0faulty removed</span>=
</div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A03 =C2=
=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33 =C2=A0 =C2=A0 =
=C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sdc1</span></div=
><div style=3D""><span style=3D"font-size:12.8px">/dev/sdb1:</span></div><d=
iv style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 Magic : a92b4efc</span></div><div style=3D""><span style=3D"font-siz=
e:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 00.90.00</span></div><div s=
tyle=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21</span></div><div style=
=3D""><span style=3D"font-size:12.8px">=C2=A0 Creation Time : Mon Apr 23 19=
:55:36 2012</span></div><div style=3D""><span style=3D"font-size:12.8px">=
=C2=A0 =C2=A0 =C2=A0Raid Level : raid1</span></div><div style=3D""><span st=
yle=3D"font-size:12.8px">=C2=A0 Used Dev Size : 20980800 (20.01 GiB 21.48 G=
B)</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=
=A0 =C2=A0Array Size : 20980800 (20.01 GiB 21.48 GB)</span></div><div style=
=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0Raid Devices : 4</span>=
</div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 Total Devices=
 : 3</span></div><div style=3D""><span style=3D"font-size:12.8px">Preferred=
 Minor : 0</span></div><div style=3D""><span style=3D"font-size:12.8px"><br=
></span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=
=A0 Update Time : Mon Jun 27 21:12:23 2016</span></div><div style=3D""><spa=
n style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : cle=
an</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0Activ=
e Devices : 3</span></div><div style=3D""><span style=3D"font-size:12.8px">=
Working Devices : 3</span></div><div style=3D""><span style=3D"font-size:12=
.8px">=C2=A0Failed Devices : 1</span></div><div style=3D""><span style=3D"f=
ont-size:12.8px">=C2=A0 Spare Devices : 0</span></div><div style=3D""><span=
 style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 1a57db72 =
- correct</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 164275</span></div><div style=3D"">=
<span style=3D"font-size:12.8px"><br></span></div><div style=3D""><span sty=
le=3D"font-size:12.8px"><br></span></div><div style=3D""><span style=3D"fon=
t-size:12.8px">=C2=A0 =C2=A0 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0=
 RaidDevice State</span></div><div style=3D""><span style=3D"font-size:12.8=
px">this =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 17 =C2=
=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sdb1<=
/span></div><div style=3D""><span style=3D"font-size:12.8px"><br></span></d=
iv><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A00 =C2=A0 =
=C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sda1</span></div=
><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A01 =C2=A0 =C2=
=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 17 =C2=A0 =C2=A0 =C2=A0 =
=C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sdb1</span></div><div s=
tyle=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A02 =C2=A0 =C2=A0 2 =
=C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =
=C2=A02 =C2=A0 =C2=A0 =C2=A0faulty removed</span></div><div style=3D""><spa=
n style=3D"font-size:12.8px">=C2=A0 =C2=A03 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =
=C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0=
 =C2=A0active sync =C2=A0 /dev/sdc1</span></div><div style=3D""><span style=
=3D"font-size:12.8px">/dev/sdc1:</span></div><div style=3D""><span style=3D=
"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc</spa=
n></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Version : 00.90.00</span></div><div style=3D""><span style=3D"fo=
nt-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 7d247a6e:7b=
5d46c8:f52d9c89:db304b21</span></div><div style=3D""><span style=3D"font-si=
ze:12.8px">=C2=A0 Creation Time : Mon Apr 23 19:55:36 2012</span></div><div=
 style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0Raid Level=
 : raid1</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=
=A0 Used Dev Size : 20980800 (20.01 GiB 21.48 GB)</span></div><div style=3D=
""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0Array Size : 209808=
00 (20.01 GiB 21.48 GB)</span></div><div style=3D""><span style=3D"font-siz=
e:12.8px">=C2=A0 =C2=A0Raid Devices : 4</span></div><div style=3D""><span s=
tyle=3D"font-size:12.8px">=C2=A0 Total Devices : 3</span></div><div style=
=3D""><span style=3D"font-size:12.8px">Preferred Minor : 0</span></div><div=
 style=3D""><span style=3D"font-size:12.8px"><br></span></div><div style=3D=
""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 Update Time : Mon Jun 27 =
21:12:23 2016</span></div><div style=3D""><span style=3D"font-size:12.8px">=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean</span></div><div style=3D"=
"><span style=3D"font-size:12.8px">=C2=A0Active Devices : 3</span></div><di=
v style=3D""><span style=3D"font-size:12.8px">Working Devices : 3</span></d=
iv><div style=3D""><span style=3D"font-size:12.8px">=C2=A0Failed Devices : =
1</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 Spare=
 Devices : 0</span></div><div style=3D""><span style=3D"font-size:12.8px">=
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 1a57db86 - correct</span></div><div s=
tyle=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0Events : 164275</span></div><div style=3D""><span style=3D"font-size:12.=
8px"><br></span></div><div style=3D""><span style=3D"font-size:12.8px"><br>=
</span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0=
 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State</span></di=
v><div style=3D""><span style=3D"font-size:12.8px">this =C2=A0 =C2=A0 3 =C2=
=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =
=C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/sdc1</span></div><div style=3D"=
"><span style=3D"font-size:12.8px"><br></span></div><div style=3D""><span s=
tyle=3D"font-size:12.8px">=C2=A0 =C2=A00 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=
=A0 =C2=A0active sync =C2=A0 /dev/sda1</span></div><div style=3D""><span st=
yle=3D"font-size:12.8px">=C2=A0 =C2=A01 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=
=A0 8 =C2=A0 =C2=A0 =C2=A0 17 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =
=C2=A0active sync =C2=A0 /dev/sdb1</span></div><div style=3D""><span style=
=3D"font-size:12.8px">=C2=A0 =C2=A02 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =
=C2=A0faulty removed</span></div><div style=3D""><span style=3D"font-size:1=
2.8px">=C2=A0 =C2=A03 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =
=C2=A0 33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdc1</span></div><div style=3D"font-size:12.8px"><br></div></div><=
div style=3D"font-size:12.8px">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D</div><div style=3D""><div style=3D""><span style=
=3D"font-size:12.8px">fdisk -l</span><br></div><div style=3D""><span style=
=3D"font-size:12.8px"><br></span></div><div style=3D""><span style=3D"font-=
size:12.8px">WARNING: GPT (GUID Partition Table) detected on &#39;/dev/sda&=
#39;! The util fdisk doesn&#39;t support GPT. Use GNU Parted.</span></div><=
div style=3D""><span style=3D"font-size:12.8px"><br></span></div><div style=
=3D""><span style=3D"font-size:12.8px"><br></span></div><div style=3D""><sp=
an style=3D"font-size:12.8px">Disk /dev/sda: 3000.5 GB, 3000592982016 bytes=
</span></div><div style=3D""><span style=3D"font-size:12.8px">255 heads, 63=
 sectors/track, 364801 cylinders</span></div><div style=3D""><span style=3D=
"font-size:12.8px">Units =3D cylinders of 16065 * 512 =3D 8225280 bytes</sp=
an></div><div style=3D""><span style=3D"font-size:12.8px">Disk identifier: =
0x03afffbe</span></div><div style=3D""><span style=3D"font-size:12.8px"><br=
></span></div><div style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=
=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=A0 End =
=C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System</span></div><div style=3D=
""><span style=3D"font-size:12.8px">/dev/sda1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0267350 =C2=A02147483647+ =C2=A0e=
e =C2=A0EFI GPT</span></div><div style=3D""><span style=3D"font-size:12.8px=
"><br></span></div><div style=3D""><span style=3D"font-size:12.8px">WARNING=
: GPT (GUID Partition Table) detected on &#39;/dev/sdb&#39;! The util fdisk=
 doesn&#39;t support GPT. Use GNU Parted.</span></div><div style=3D""><span=
 style=3D"font-size:12.8px"><br></span></div><div style=3D""><span style=3D=
"font-size:12.8px"><br></span></div><div style=3D""><span style=3D"font-siz=
e:12.8px">Disk /dev/sdb: 3000.5 GB, 3000592982016 bytes</span></div><div st=
yle=3D""><span style=3D"font-size:12.8px">255 heads, 63 sectors/track, 3648=
01 cylinders</span></div><div style=3D""><span style=3D"font-size:12.8px">U=
nits =3D cylinders of 16065 * 512 =3D 8225280 bytes</span></div><div style=
=3D""><span style=3D"font-size:12.8px">Disk identifier: 0x142a889c</span></=
div><div style=3D""><span style=3D"font-size:12.8px"><br></span></div><div =
style=3D""><span style=3D"font-size:12.8px">=C2=A0 =C2=A0Device Boot =C2=A0=
 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blo=
cks =C2=A0 Id =C2=A0System</span></div><div style=3D""><span style=3D"font-=
size:12.8px">/dev/sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =
=C2=A0 =C2=A0 =C2=A0267350 =C2=A02147483647+ =C2=A0ee =C2=A0EFI GPT</span><=
/div><div style=3D""><span style=3D"font-size:12.8px"><br></span></div><div=
 style=3D""><span style=3D"font-size:12.8px">WARNING: GPT (GUID Partition T=
able) detected on &#39;/dev/sdc&#39;! The util fdisk doesn&#39;t support GP=
T. Use GNU Parted.</span></div><div style=3D""><span style=3D"font-size:12.=
8px"><br></span></div><div style=3D""><span style=3D"font-size:12.8px"><br>=
</span></div><div style=3D""><span style=3D"font-size:12.8px">Disk /dev/sdc=
: 3000.5 GB, 3000592982016 bytes</span></div><div style=3D""><span style=3D=
"font-size:12.8px">255 heads, 63 sectors/track, 364801 cylinders</span></di=
v><div style=3D""><span style=3D"font-size:12.8px">Units =3D cylinders of 1=
6065 * 512 =3D 8225280 bytes</span></div><div style=3D""><span style=3D"fon=
t-size:12.8px">Disk identifier: 0x3daebd50</span></div><div style=3D""><spa=
n style=3D"font-size:12.8px"><br></span></div><div style=3D""><span style=
=3D"font-size:12.8px">=C2=A0 =C2=A0Device Boot =C2=A0 =C2=A0 =C2=A0Start =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0=
System</span></div><div style=3D""><span style=3D"font-size:12.8px">/dev/sd=
c1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A02=
67350 =C2=A02147483647+ =C2=A0ee =C2=A0EFI GPT</span></div><div style=3D"">=
<span style=3D"font-size:12.8px"><br></span></div><div style=3D""><span sty=
le=3D"font-size:12.8px">Disk /dev/md0: 21.4 GB, 21484339200 bytes</span></d=
iv><div style=3D""><span style=3D"font-size:12.8px">2 heads, 4 sectors/trac=
k, 5245200 cylinders</span></div><div style=3D""><span style=3D"font-size:1=
2.8px">Units =3D cylinders of 8 * 512 =3D 4096 bytes</span></div><div style=
=3D""><span style=3D"font-size:12.8px">Disk identifier: 0x00000000</span></=
div><div style=3D""><span style=3D"font-size:12.8px"><br></span></div><div =
style=3D""><span style=3D"font-size:12.8px">Disk /dev/md0 doesn&#39;t conta=
in a valid partition table</span></div></div><div style=3D"font-size:12.8px=
"><br></div></div></div>

--94eb2c13f53047b6f10537500c68--


--===============2994197344977923620==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2994197344977923620==--

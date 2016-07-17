From: Stewart Ives <ivessm@softecusa.com>
Subject: Re: Recover filenames from failed RAID0
Date: Sun, 17 Jul 2016 18:56:25 -0400
Message-ID: <CAKnfFb2R4cGWjPBBz2q3qv6ny+4dr0K=RFrVYgrAJXBkQ-cwwQ@mail.gmail.com>
References: <CAAVC+N5m74MyDqZamHgy71vRMhcEY8w_OkiG-GMQKU=JG-QkxA@mail.gmail.com>
	<CAAVC+N78o675MpkJN=VO_zZhh7ePer1zU-ePLJi4eNH04ih3mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6215187354937173538=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAVC+N78o675MpkJN=VO_zZhh7ePer1zU-ePLJi4eNH04ih3mw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michel Dubois <michel.dubois.mtl@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ming Lei <ming.lei@canonical.com>, NeilBrown <neilb@suse.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@redhat.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, Lars Ellenberg <lars.ellenberg@linbit.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: dm-devel.ids

--===============6215187354937173538==
Content-Type: multipart/alternative; boundary=001a114c6d8c39507d0537dcc5ad

--001a114c6d8c39507d0537dcc5ad
Content-Type: text/plain; charset=UTF-8

Michael,

I'll preface my reply with the statement that I am far from an expert at
this but I can read and understand the descriptions of the different RAID
levels and it seems to me with a RAID0 you are SOL if you lose a device in
the array. Just by the very nature of the RAID0 configuration there is
absolutely NO redundancy. The only reason anyone would configure such a
system is for SPEED and the only data that should be permitted on a RAID0
array is temp or working data that is recoverable by other means in the
event of a failure. I know of many Videographers that use a SSD RAID0 array
for working on their current project but they also copy that array out
about every hour for backup.

I pose only one question to you. Did you have a backup?

Good luck.

-stew


>>
>> Stewart M. Ives
>> SofTEC USA
>> 1717 Bridge St
>> New Cumberland, PA 17070 USA
>>
>> Tel: 717-910-4600
>> Fax: 888-371-6022
>> Skype: softecusa-ivessm
>> EMail: ivessm@softecusa.com
>> WebSite: www.softecusa.com
>>

On Sun, Jul 17, 2016 at 3:10 PM, Michel Dubois <michel.dubois.mtl@gmail.com>
wrote:

> Dear linux-raid mailing list,
>
> I have a RAID0 array of four 3TB disks that failed on the "third" disk.
>
> I am aware of the non-redundancy of RAID0 but I would like to recover
> the filenames from that RAID0. If I could recover some data it would
> be a bonus.
>
> Below you'll find the outputs of the following commands
>  mdadm --examine /dev/sd[abcd]1
>  fdisk -l
>
> where sda1, sdb1, sdc1 and sdd1 should be the 4 RAID devices.
>
> What could be my next step?
>
> I thank you for your time
>
> Michel Dubois
>
> ======================
> mdadm --examine /dev/sd[abcd]1
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
>   Creation Time : Mon Apr 23 19:55:36 2012
>      Raid Level : raid1
>   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
>      Array Size : 20980800 (20.01 GiB 21.48 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>
>     Update Time : Mon Jun 27 21:12:23 2016
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 1a57db60 - correct
>          Events : 164275
>
>
>       Number   Major   Minor   RaidDevice State
> this     0       8        1        0      active sync   /dev/sda1
>
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       33        3      active sync   /dev/sdc1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
>   Creation Time : Mon Apr 23 19:55:36 2012
>      Raid Level : raid1
>   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
>      Array Size : 20980800 (20.01 GiB 21.48 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>
>     Update Time : Mon Jun 27 21:12:23 2016
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 1a57db72 - correct
>          Events : 164275
>
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       17        1      active sync   /dev/sdb1
>
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       33        3      active sync   /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
>   Creation Time : Mon Apr 23 19:55:36 2012
>      Raid Level : raid1
>   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
>      Array Size : 20980800 (20.01 GiB 21.48 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>
>     Update Time : Mon Jun 27 21:12:23 2016
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 1a57db86 - correct
>          Events : 164275
>
>
>       Number   Major   Minor   RaidDevice State
> this     3       8       33        3      active sync   /dev/sdc1
>
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       33        3      active sync   /dev/sdc1
>
> ======================
> fdisk -l
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util
> fdisk doesn't support GPT. Use GNU Parted.
>
>
> Disk /dev/sda: 3000.5 GB, 3000592982016 bytes
> 255 heads, 63 sectors/track, 364801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x03afffbe
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1      267350  2147483647+  ee  EFI GPT
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util
> fdisk doesn't support GPT. Use GNU Parted.
>
>
> Disk /dev/sdb: 3000.5 GB, 3000592982016 bytes
> 255 heads, 63 sectors/track, 364801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x142a889c
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1      267350  2147483647+  ee  EFI GPT
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util
> fdisk doesn't support GPT. Use GNU Parted.
>
>
> Disk /dev/sdc: 3000.5 GB, 3000592982016 bytes
> 255 heads, 63 sectors/track, 364801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x3daebd50
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1      267350  2147483647+  ee  EFI GPT
>
> Disk /dev/md0: 21.4 GB, 21484339200 bytes
> 2 heads, 4 sectors/track, 5245200 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/md0 doesn't contain a valid partition table
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--001a114c6d8c39507d0537dcc5ad
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Michael,<input name=3D"virtru-metadata" type=3D"hidden" va=
lue=3D"{&quot;email-policy&quot;:{&quot;state&quot;:&quot;closed&quot;,&quo=
t;expirationUnit&quot;:&quot;days&quot;,&quot;disableCopyPaste&quot;:false,=
&quot;disablePrint&quot;:false,&quot;disableForwarding&quot;:false,&quot;ex=
pires&quot;:false,&quot;isManaged&quot;:false},&quot;attachments&quot;:{}}"=
><div><br></div><div>I&#39;ll preface my reply with the statement that I am=
 far from an expert at this but I can read and understand the descriptions =
of the different RAID levels and it seems to me with a RAID0 you are SOL if=
 you lose a device in the array. Just by the very nature of the RAID0 confi=
guration there is absolutely NO redundancy. The only reason anyone would co=
nfigure such a system is for SPEED and the only data that should be permitt=
ed on a RAID0 array is temp or working data that is recoverable by other me=
ans in the event of a failure. I know of many Videographers that use a SSD =
RAID0 array for working on their current project but they also copy that ar=
ray out about every hour for backup.</div><div><br></div><div>I pose only o=
ne question to you. Did you have a backup?</div><div><br></div><div>Good lu=
ck.</div><div><br></div><div>-stew</div><div><br></div></div><div class=3D"=
gmail_extra"><br clear=3D"all"><div><div class=3D"gmail_signature" data-sma=
rtmail=3D"gmail_signature"><div dir=3D"ltr"><div><font size=3D"2">&gt;&gt;
 <br>
&gt;&gt; Stewart M.=20
Ives
 <br>
&gt;&gt; SofTEC=20
USA
 <br>
&gt;&gt; 1717 Bridge=20
St
 <br>
&gt;&gt; New Cumberland, PA=20
17070 USA<br>
&gt;&gt;
 <br>
&gt;&gt; Tel:=20
717-910-4600
 <br>
&gt;&gt; Fax: 888-371-6022<br>&gt;&gt; Skype: softecusa-ivessm<br>
&gt;&gt; EMail:=20
<a href=3D"mailto:ivessm@softecusa.com" target=3D"_blank">ivessm@softecusa.=
com</a>
 <br>
&gt;&gt; WebSite: <a href=3D"http://www.softecusa.com/" target=3D"_blank">w=
ww.softecusa.com</a>
 <br>
&gt;&gt;
 </font><div></div><div></div><div></div></div></div></div></div>
<br><div class=3D"gmail_quote">On Sun, Jul 17, 2016 at 3:10 PM, Michel Dubo=
is <span dir=3D"ltr">&lt;<a href=3D"mailto:michel.dubois.mtl@gmail.com" tar=
get=3D"_blank">michel.dubois.mtl@gmail.com</a>&gt;</span> wrote:<br><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex">Dear linux-raid mailing list,<br>
<br>
I have a RAID0 array of four 3TB disks that failed on the &quot;third&quot;=
 disk.<br>
<br>
I am aware of the non-redundancy of RAID0 but I would like to recover<br>
the filenames from that RAID0. If I could recover some data it would<br>
be a bonus.<br>
<br>
Below you&#39;ll find the outputs of the following commands<br>
=C2=A0mdadm --examine /dev/sd[abcd]1<br>
=C2=A0fdisk -l<br>
<br>
where sda1, sdb1, sdc1 and sdd1 should be the 4 RAID devices.<br>
<br>
What could be my next step?<br>
<br>
I thank you for your time<br>
<br>
Michel Dubois<br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
mdadm --examine /dev/sd[abcd]1<br>
/dev/sda1:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 00.90.00<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 7d247a6e:7b5d46c8:f52d9c89:=
db304b21<br>
=C2=A0 Creation Time : Mon Apr 23 19:55:36 2012<br>
=C2=A0 =C2=A0 =C2=A0Raid Level : raid1<br>
=C2=A0 Used Dev Size : 20980800 (20.01 GiB 21.48 GB)<br>
=C2=A0 =C2=A0 =C2=A0Array Size : 20980800 (20.01 GiB 21.48 GB)<br>
=C2=A0 =C2=A0Raid Devices : 4<br>
=C2=A0 Total Devices : 3<br>
Preferred Minor : 0<br>
<br>
=C2=A0 =C2=A0 Update Time : Mon Jun 27 21:12:23 2016<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean<br>
=C2=A0Active Devices : 3<br>
Working Devices : 3<br>
=C2=A0Failed Devices : 1<br>
=C2=A0 Spare Devices : 0<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 1a57db60 - correct<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 164275<br>
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 Number=C2=A0 =C2=A0Major=C2=A0 =C2=A0Minor=C2=A0 =C2=
=A0RaidDevice State<br>
this=C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 1=C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 active sync=C2=A0=
 =C2=A0/dev/sda1<br>
<br>
=C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sda1<br>
=C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A017=C2=A0 =C2=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sdb1<br>
=C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 2=C2=A0 =C2=A0 =C2=A0 faulty=
 removed<br>
=C2=A0 =C2=A03=C2=A0 =C2=A0 =C2=A03=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A033=C2=A0 =C2=A0 =C2=A0 =C2=A0 3=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sdc1<br>
/dev/sdb1:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 00.90.00<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 7d247a6e:7b5d46c8:f52d9c89:=
db304b21<br>
=C2=A0 Creation Time : Mon Apr 23 19:55:36 2012<br>
=C2=A0 =C2=A0 =C2=A0Raid Level : raid1<br>
=C2=A0 Used Dev Size : 20980800 (20.01 GiB 21.48 GB)<br>
=C2=A0 =C2=A0 =C2=A0Array Size : 20980800 (20.01 GiB 21.48 GB)<br>
=C2=A0 =C2=A0Raid Devices : 4<br>
=C2=A0 Total Devices : 3<br>
Preferred Minor : 0<br>
<br>
=C2=A0 =C2=A0 Update Time : Mon Jun 27 21:12:23 2016<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean<br>
=C2=A0Active Devices : 3<br>
Working Devices : 3<br>
=C2=A0Failed Devices : 1<br>
=C2=A0 Spare Devices : 0<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 1a57db72 - correct<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 164275<br>
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 Number=C2=A0 =C2=A0Major=C2=A0 =C2=A0Minor=C2=A0 =C2=
=A0RaidDevice State<br>
this=C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =
=C2=A017=C2=A0 =C2=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 active sync=C2=A0=
 =C2=A0/dev/sdb1<br>
<br>
=C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sda1<br>
=C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A017=C2=A0 =C2=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sdb1<br>
=C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 2=C2=A0 =C2=A0 =C2=A0 faulty=
 removed<br>
=C2=A0 =C2=A03=C2=A0 =C2=A0 =C2=A03=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A033=C2=A0 =C2=A0 =C2=A0 =C2=A0 3=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sdc1<br>
/dev/sdc1:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 00.90.00<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 7d247a6e:7b5d46c8:f52d9c89:=
db304b21<br>
=C2=A0 Creation Time : Mon Apr 23 19:55:36 2012<br>
=C2=A0 =C2=A0 =C2=A0Raid Level : raid1<br>
=C2=A0 Used Dev Size : 20980800 (20.01 GiB 21.48 GB)<br>
=C2=A0 =C2=A0 =C2=A0Array Size : 20980800 (20.01 GiB 21.48 GB)<br>
=C2=A0 =C2=A0Raid Devices : 4<br>
=C2=A0 Total Devices : 3<br>
Preferred Minor : 0<br>
<br>
=C2=A0 =C2=A0 Update Time : Mon Jun 27 21:12:23 2016<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean<br>
=C2=A0Active Devices : 3<br>
Working Devices : 3<br>
=C2=A0Failed Devices : 1<br>
=C2=A0 Spare Devices : 0<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 1a57db86 - correct<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 164275<br>
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 Number=C2=A0 =C2=A0Major=C2=A0 =C2=A0Minor=C2=A0 =C2=
=A0RaidDevice State<br>
this=C2=A0 =C2=A0 =C2=A03=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =
=C2=A033=C2=A0 =C2=A0 =C2=A0 =C2=A0 3=C2=A0 =C2=A0 =C2=A0 active sync=C2=A0=
 =C2=A0/dev/sdc1<br>
<br>
=C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sda1<br>
=C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A017=C2=A0 =C2=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sdb1<br>
=C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 2=C2=A0 =C2=A0 =C2=A0 faulty=
 removed<br>
=C2=A0 =C2=A03=C2=A0 =C2=A0 =C2=A03=C2=A0 =C2=A0 =C2=A0 =C2=A08=C2=A0 =C2=
=A0 =C2=A0 =C2=A033=C2=A0 =C2=A0 =C2=A0 =C2=A0 3=C2=A0 =C2=A0 =C2=A0 active=
 sync=C2=A0 =C2=A0/dev/sdc1<br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
fdisk -l<br>
<br>
WARNING: GPT (GUID Partition Table) detected on &#39;/dev/sda&#39;! The uti=
l<br>
fdisk doesn&#39;t support GPT. Use GNU Parted.<br>
<br>
<br>
Disk /dev/sda: 3000.5 GB, 3000592982016 bytes<br>
255 heads, 63 sectors/track, 364801 cylinders<br>
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes<br>
Disk identifier: 0x03afffbe<br>
<br>
=C2=A0 =C2=A0Device Boot=C2=A0 =C2=A0 =C2=A0 Start=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0End=C2=A0 =C2=A0 =C2=A0 Blocks=C2=A0 =C2=A0Id=C2=A0 System<br>
/dev/sda1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=
=A0 =C2=A0 267350=C2=A0 2147483647+=C2=A0 ee=C2=A0 EFI GPT<br>
<br>
WARNING: GPT (GUID Partition Table) detected on &#39;/dev/sdb&#39;! The uti=
l<br>
fdisk doesn&#39;t support GPT. Use GNU Parted.<br>
<br>
<br>
Disk /dev/sdb: 3000.5 GB, 3000592982016 bytes<br>
255 heads, 63 sectors/track, 364801 cylinders<br>
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes<br>
Disk identifier: 0x142a889c<br>
<br>
=C2=A0 =C2=A0Device Boot=C2=A0 =C2=A0 =C2=A0 Start=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0End=C2=A0 =C2=A0 =C2=A0 Blocks=C2=A0 =C2=A0Id=C2=A0 System<br>
/dev/sdb1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=
=A0 =C2=A0 267350=C2=A0 2147483647+=C2=A0 ee=C2=A0 EFI GPT<br>
<br>
WARNING: GPT (GUID Partition Table) detected on &#39;/dev/sdc&#39;! The uti=
l<br>
fdisk doesn&#39;t support GPT. Use GNU Parted.<br>
<br>
<br>
Disk /dev/sdc: 3000.5 GB, 3000592982016 bytes<br>
255 heads, 63 sectors/track, 364801 cylinders<br>
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes<br>
Disk identifier: 0x3daebd50<br>
<br>
=C2=A0 =C2=A0Device Boot=C2=A0 =C2=A0 =C2=A0 Start=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0End=C2=A0 =C2=A0 =C2=A0 Blocks=C2=A0 =C2=A0Id=C2=A0 System<br>
/dev/sdc1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01=C2=A0 =C2=
=A0 =C2=A0 267350=C2=A0 2147483647+=C2=A0 ee=C2=A0 EFI GPT<br>
<br>
Disk /dev/md0: 21.4 GB, 21484339200 bytes<br>
2 heads, 4 sectors/track, 5245200 cylinders<br>
Units =3D cylinders of 8 * 512 =3D 4096 bytes<br>
Disk identifier: 0x00000000<br>
<br>
Disk /dev/md0 doesn&#39;t contain a valid partition table<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-raid&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at=C2=A0 <a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" rel=3D"noreferrer" target=3D"_blank">http://vger.kernel.org/majord=
omo-info.html</a><br>
</blockquote></div><br></div>

--001a114c6d8c39507d0537dcc5ad--


--===============6215187354937173538==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6215187354937173538==--

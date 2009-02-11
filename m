From: Alireza Nematollahi <alirezan@sfu.ca>
Subject: Re: Stopped disk causes LVM to go crazy
Date: Wed, 11 Feb 2009 10:45:15 -0800 (PST)
Message-ID: <798685706.2823991234377915224.JavaMail.root@jaguar7.sfu.ca>
References: <940984053.2821991234377736540.JavaMail.root@jaguar7.sfu.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1986200279=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940984053.2821991234377736540.JavaMail.root@jaguar7.sfu.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: bmr@redhat.com
List-Id: dm-devel.ids

--===============1986200279==
Content-Type: multipart/alternative;
	boundary="----=_Part_102887_1663654178.1234377915223"

------=_Part_102887_1663654178.1234377915223
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

hi. Thanks for your reply. Well, I had tried that before, but no luck. I tried it again, and still no luck: 
> vgchange -an disk2 
0 logical volume(s) in volume group "disk2" now active 
> sdparm -C stop /dev/sdb 
> lvscan 
end_request: I/O error, dev sdb, sector 0 
printk: 72 messages suppressed. 
Buffer I/O error on device sdb, logical block 0 
Buffer I/O error on device sdb, logical block 1 
Buffer I/O error on device sdb, logical block 2 
Buffer I/O error on device sdb, logical block 3 
end_request: I/O error, dev sdb, sector 0 
Buffer I/O error on device sdb, logical block 0 
end_request: I/O error, dev sdb, sector 287277824 
/dev/sdb: read failed after 0 of 4096 at 0: Input/output error 
end_request: I/O error, dev sdb, sector 0 
/dev/sdb: read failed after 0 of 4096 at 147086245888: Input/oend_request: I/O error, dev sdb, sector 287274137 
utput error 
/dev/sdb: read failed after 0 of 4096 at 0: Inputend_request: I/O error, dev sdb, sector 287258265 
/output error 
/dev/sdb1: read failed after 0 of 512 at 812646end_request: I/O error, dev sdb, sector 287258029 
4: Input/output error 
/dev/sdb1: read failed after 0 of 2048 end_request: I/O error, dev sdb, sector 281410605 
at 0: Input/output error 
/dev/sdb2: read failed after 0 of 20end_request: I/O error, dev sdb, sector 281410367 
48 at 2993881088: Input/output error 
/dev/sdb2: read failed aend_request: I/O error, dev sdb, sector 63 
fter 0 of 2048 at 0: Input/output error 
/dev/sdb4: read failed after 0 of 1024 at 144082075648: Input/output error 
/dev/sdb4: read failed after 0 of 2048 at 0: Input/output error 
ACTIVE '/dev/disk1/blah' [10.00 GB] inherit 
ACTIVE '/dev/disk1/blah' [100.00 MB] inherit 
ACTIVE '/dev/disk1/blah' [10.00 GB] inherit 
ACTIVE '/dev/disk1/blah' [100.00 MB] inherit 
ACTIVE '/dev/disk1/blah' [10.00 GB] inherit 
ACTIVE '/dev/disk1/blah' [100.00 MB] inherit 

I'm using older LVM version: 
> lvscan --version 
LVM version: 2.02.25 (2007-04 27) 
Library version: 1.02.19 (2007-04-27) 
Driver version: 4.11.0 

Any ideas? 

Thanks 

----- Original Message ----- 
From: "Bryn M. Reeves" <bmr@redhat.com> 
To: "device-mapper development" <dm-devel@redhat.com> 
Sent: Wednesday, February 11, 2009 2:39:20 AM GMT -08:00 US/Canada Pacific 
Subject: Re: [dm-devel] Stopped disk causes LVM to go crazy 

Alireza Nematollahi wrote: 
> hi guys, 
> 
> I have a system with two SATA disks and I have LVM on the disks. I 
> use sdparm (sdparm -C stop /dev/sdb) to spin-down one of them. It 
> works fine and I can hear the disk spinning down and all...But when 
> I run any LVM command, say lvscan or whatever, I get lots of error 
> messages: 

What did you expect? :) 

If the volume group is active when you remove/spin down the disks LVM 
has no way of knowing that you wanted to do that. To the software, it 
just looks like a drive has failed or gone away while it was in use. 

<snip> 

> /dev/sdb2: read failed after 0 of 4096 at 2993881088: Input/output 
> error /dev/sdb2: read failed after 0 of 4096 at 0: Input/output 
> error /dev/sdb4: read failed after 0 of 1024 at 144082075648: 
> Input/output error /dev/sdb4: read failed after 0 of 2048 at 0: 

> Input/output error Even when I physically remove the disk it still 
> happens. Is there any way I can stop LVM from querying both disks 
> or at least to stop displaying the error messages? 

Tell LVM to stop using the disk first. See the man page for vgchange 
for full details but you want to run: 

vgchange -an <volume group> 

To deactivate the volume group *before* you start removing devices 
that it is using. 

Regards, 
Bryn. 

-- 
dm-devel mailing list 
dm-devel@redhat.com 
https://www.redhat.com/mailman/listinfo/dm-devel 

------=_Part_102887_1663654178.1234377915223
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D'text/css'>p { margin: 0; }</style></head><body><=
div style=3D'font-family: Times New Roman; font-size: 12pt; color: #000000'=
>hi. Thanks for your reply. Well, I had tried that before, but no luck. I t=
ried it again, and still no luck:<br>&gt; vgchange -an disk2<br>&nbsp; 0 lo=
gical volume(s) in volume group "disk2" now active<br>&gt; sdparm -C stop /=
dev/sdb<br>&gt; lvscan<br>end_request: I/O error, dev sdb, sector 0<br>prin=
tk: 72 messages suppressed.<br>Buffer I/O error on device sdb, logical bloc=
k 0<br>Buffer I/O error on device sdb, logical block 1<br>Buffer I/O error =
on device sdb, logical block 2<br>Buffer I/O error on device sdb, logical b=
lock 3<br>end_request: I/O error, dev sdb, sector 0<br>Buffer I/O error on =
device sdb, logical block 0<br>&nbsp; end_request: I/O error, dev sdb, sect=
or 287277824<br>/dev/sdb: read failed after 0 of 4096 at 0: Input/output er=
ror<br>end_request: I/O error, dev sdb, sector 0<br>&nbsp; /dev/sdb: read f=
ailed after 0 of 4096 at 147086245888: Input/oend_request: I/O error, dev s=
db, sector 287274137<br>utput error<br>&nbsp; /dev/sdb: read failed after 0=
 of 4096 at 0: Inputend_request: I/O error, dev sdb, sector 287258265<br>/o=
utput error<br>&nbsp; /dev/sdb1: read failed after 0 of 512 at 812646end_re=
quest: I/O error, dev sdb, sector 287258029<br>4: Input/output error<br>&nb=
sp; /dev/sdb1: read failed after 0 of 2048 end_request: I/O error, dev sdb,=
 sector 281410605<br>at 0: Input/output error<br>&nbsp; /dev/sdb2: read fai=
led after 0 of 20end_request: I/O error, dev sdb, sector 281410367<br>48 at=
 2993881088: Input/output error<br>&nbsp; /dev/sdb2: read failed aend_reque=
st: I/O error, dev sdb, sector 63<br>fter 0 of 2048 at 0: Input/output erro=
r<br>&nbsp; /dev/sdb4: read failed after 0 of 1024 at 144082075648: Input/o=
utput error<br>&nbsp; /dev/sdb4: read failed after 0 of 2048 at 0: Input/ou=
tput error<br>&nbsp; ACTIVE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; '/dev/disk1/blah' [10.00 GB] inherit<br>&nbsp; ACTIVE&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '/dev/disk1=
/blah' [100.00 MB] inherit<br>&nbsp; ACTIVE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '/dev/disk1/blah' [10.00 GB] inherit<br>=
&nbsp; ACTIVE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; '/dev/disk1/blah' [100.00 MB] inherit<br>&nbsp; ACTIVE&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '/dev/disk1/blah' [10.00=
 GB] inherit<br>&nbsp; ACTIVE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; '/dev/disk1/blah' [100.00 MB] inherit<br><br>I'm using=
 older LVM version:<br>&gt; lvscan --version<br>&nbsp; LVM version:&nbsp;&n=
bsp;&nbsp;&nbsp; 2.02.25 (2007-04 27)<br>&nbsp; Library version: 1.02.19 (2=
007-04-27)<br>&nbsp; Driver version:&nbsp; 4.11.0<br><br>Any ideas?<br><br>=
Thanks<br><br>----- Original Message -----<br>From: "Bryn M. Reeves" &lt;bm=
r@redhat.com&gt;<br>To: "device-mapper development" &lt;dm-devel@redhat.com=
&gt;<br>Sent: Wednesday, February 11, 2009 2:39:20 AM GMT -08:00 US/Canada =
Pacific<br>Subject: Re: [dm-devel] Stopped disk causes LVM to go crazy<br><=
br>Alireza Nematollahi wrote:<br>&gt; hi guys,<br>&gt; <br>&gt; I have a sy=
stem with two SATA disks and I have LVM on the disks. I<br>&gt; use sdparm =
(sdparm -C stop /dev/sdb) to spin-down one of them. It<br>&gt; works fine a=
nd I can hear the disk spinning down and all...But when<br>&gt; I run any L=
VM command, say lvscan or whatever, I get lots of error<br>&gt; messages:<b=
r><br>What did you expect? :)<br><br>If the volume group is active when you=
 remove/spin down the disks LVM <br>has no way of knowing that you wanted t=
o do that. To the software, it <br>just looks like a drive has failed or go=
ne away while it was in use.<br><br>&lt;snip&gt;<br><br>&gt; /dev/sdb2: rea=
d failed after 0 of 4096 at 2993881088: Input/output<br>&gt; error /dev/sdb=
2: read failed after 0 of 4096 at 0: Input/output<br>&gt; error /dev/sdb4: =
read failed after 0 of 1024 at 144082075648:<br>&gt; Input/output error /de=
v/sdb4: read failed after 0 of 2048 at 0:<br><br>&gt; Input/output error Ev=
en when I physically remove the disk it still<br>&gt; happens. Is there any=
 way I can stop LVM from querying both disks<br>&gt; or at least to stop di=
splaying the error messages?<br><br>Tell LVM to stop using the disk first. =
See the man page for vgchange <br>for full details but you want to run:<br>=
<br>vgchange -an &lt;volume group&gt;<br><br>To deactivate the volume group=
 *before* you start removing devices <br>that it is using.<br><br>Regards,<=
br>Bryn.<br><br>--<br>dm-devel mailing list<br>dm-devel@redhat.com<br>https=
://www.redhat.com/mailman/listinfo/dm-devel<br></div></body></html>
------=_Part_102887_1663654178.1234377915223--


--===============1986200279==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1986200279==--

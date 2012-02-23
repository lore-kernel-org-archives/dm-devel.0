From: devin <devin@pabstatencio.com>
Subject: Mulipath / DM-Multipath / Hitachi iSCSI SAN
Date: Thu, 23 Feb 2012 16:12:41 -0700
Message-ID: <e871a80faf8782f7feac16c23fc6d037@pabstatencio.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2354705010851979656=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2354705010851979656==
Content-Type: multipart/alternative;
	boundary="=_d31b096a459e5c01b00c2fd92955bd7f"

--=_d31b096a459e5c01b00c2fd92955bd7f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

 

Dear Users - 

I am running a Hitachi AMS2500 with 10GB iSCSI SAN,
and I am running RedHat Enterprise 5.7 x86_64bit. I installed Multipath
and I am seeing strange issues with the box. Basically what appears to
be happening is some of my LUNS seem to go into an enabled/enabled
status and I/O just queue's up and then eventually times out. I am not
sure why this is happening, it is almost like a LUN goes offline for a
bit and then I/O back's up and causes major issues. I noticed in the


/var/log/messages 

Feb 23 17:59:55 ash-db-3 multipathd: mpath22: load
table [0 2147483648 multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1
70:0 1000 69:240 1000 round-robin 0 2 1 70:32 1000 70:16 1000] 
Feb 23
17:59:55 ash-db-3 multipathd: dm-51: add map (uevent) 
Feb 23 17:59:55
ash-db-3 multipathd: dm-51: devmap already registered 
Feb 23 18:01:51
ash-db-3 kernel: sd 6:0:0:16: timing out command, waited 7s
Feb 23
18:01:51 ash-db-3 multipathd: sdbs: hds prio: SCSI error 
Feb 23
18:01:55 ash-db-3 multipathd: mpath17: load table [0 2147483648
multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1 68:96 1000 68:80
1000 round-robin 0 2 1 68:48 1000 68:64 1000] 
Feb 23 18:02:09 ash-db-3
multipathd: dm-37: add map (uevent) 
Feb 23 18:02:09 ash-db-3
multipathd: dm-37: devmap already registered 

Also if i just Grep for
"timing out" i get: 

Feb 23 17:09:21 ash-db-3 kernel: sd 6:0:0:2:
timing out command, waited 7s
Feb 23 17:11:33 ash-db-3 kernel: sd
8:0:0:10: timing out command, waited 7s
Feb 23 17:18:46 ash-db-3 kernel:
sd 7:0:0:15: timing out command, waited 7s
Feb 23 17:22:44 ash-db-3
kernel: sd 8:0:0:2: timing out command, waited 7s
Feb 23 17:27:54
ash-db-3 kernel: sd 6:0:0:10: timing out command, waited 7s
Feb 23
17:34:42 ash-db-3 kernel: sd 8:0:0:2: timing out command, waited 7s
Feb
23 17:35:12 ash-db-3 kernel: sd 8:0:0:17: timing out command, waited
7s
Feb 23 17:37:01 ash-db-3 kernel: sd 6:0:0:2: timing out command,
waited 7s
Feb 23 17:37:17 ash-db-3 kernel: sd 6:0:0:5: timing out
command, waited 7s
Feb 23 17:39:15 ash-db-3 kernel: sd 6:0:0:16: timing
out command, waited 7s
Feb 23 17:44:11 ash-db-3 kernel: sd 6:0:0:2:
timing out command, waited 7s
Feb 23 17:46:36 ash-db-3 kernel: sd
8:0:0:2: timing out command, waited 7s
Feb 23 17:48:30 ash-db-3 kernel:
sd 6:0:0:7: timing out command, waited 7s
Feb 23 17:51:42 ash-db-3
kernel: sd 6:0:0:16: timing out command, waited 7s
Feb 23 17:56:53
ash-db-3 kernel: sd 6:0:0:15: timing out command, waited 7s
Feb 23
17:59:08 ash-db-3 kernel: sd 6:0:0:2: timing out command, waited 7s
Feb
23 17:59:36 ash-db-3 kernel: sd 6:0:0:23: timing out command, waited
7s
Feb 23 18:01:51 ash-db-3 kernel: sd 6:0:0:16: timing out command,
waited 7s 

then when I look at "multipath -ll" i see for instance:


mpath12 (360060e80100b05f00530286700000008) dm-7
HITACHI,DF600F
size=1.0T features='1 queue_if_no_path' hwhandler='0'
wp=rw
|-+- policy='round-robin 0' prio=1 status=enabled
| |- 8:0:0:2 sdo
8:224 active ready running
| `- 6:0:0:2 sdm 8:192 active ready
running
`-+- policy='round-robin 0' prio=0 status=enabled
 |- 7:0:0:2
sdl 8:176 active ready running
 `- 5:0:0:2 sdn 8:208 active ready
running
mpath5 (360060e80100b05f0053028670000000f) dm-29
HITACHI,DF600F
size=1.0T features='1 queue_if_no_path' hwhandler='0'
wp=rw
|-+- policy='round-robin 0' prio=1 status=active
| |- 5:0:0:9 sdaq
66:160 active ready running
| `- 7:0:0:9 sdao 66:128 active ready
running
`-+- policy='round-robin 0' prio=0 status=enabled
 |- 6:0:0:9
sdan 66:112 active ready running
 `- 8:0:0:9 sdap 66:144 active ready
running 

So I wonder if somehow I am getting bit by the "1
queue_if_no_path", however not sure why some LUNS are alwasy
ready/enabled, and then some go enabled/enabled. If anyone can provide
assistance I would be forever grateful!! 

Thanks Much. 

Devin Acosta 


--=_d31b096a459e5c01b00c2fd92955bd7f
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html><body>
<p>&nbsp;</p>
<p>Dear Users -</p>
<p>I am running a Hitachi AMS2500 with 10GB iSCSI SAN, and I am running Red=
Hat Enterprise 5.7 x86_64bit. I installed Multipath and I am seeing strange=
 issues with the box. Basically what appears to be happening is some of my =
LUNS seem to go into an enabled/enabled status and I/O just queue's up and =
then eventually times out. I am not sure why this is happening, it is almos=
t like a LUN goes offline for a bit and then I/O back's up and causes major=
 issues. I noticed in the</p>
<p>/var/log/messages</p>
<p>Feb 23 17:59:55 ash-db-3 multipathd: mpath22: load table [0 2147483648 m=
ultipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1 70:0 1000 69:240 1000 r=
ound-robin 0 2 1 70:32 1000 70:16 1000] <br />Feb 23 17:59:55 ash-db-3 mult=
ipathd: dm-51: add map (uevent) <br />Feb 23 17:59:55 ash-db-3 multipathd: =
dm-51: devmap already registered <br />Feb 23 18:01:51 ash-db-3 kernel: sd =
6:0:0:16: timing out command, waited 7s<br />Feb 23 18:01:51 ash-db-3 multi=
pathd: sdbs: hds prio: SCSI error <br />Feb 23 18:01:55 ash-db-3 multipathd=
: mpath17: load table [0 2147483648 multipath 1 queue_if_no_path 0 2 1 roun=
d-robin 0 2 1 68:96 1000 68:80 1000 round-robin 0 2 1 68:48 1000 68:64 1000=
] <br />Feb 23 18:02:09 ash-db-3 multipathd: dm-37: add map (uevent) <br />=
Feb 23 18:02:09 ash-db-3 multipathd: dm-37: devmap already registered</p>
<p>Also if i just Grep for "timing out" i get:</p>
<p>Feb 23 17:09:21 ash-db-3 kernel: sd 6:0:0:2: timing out command, waited =
7s<br />Feb 23 17:11:33 ash-db-3 kernel: sd 8:0:0:10: timing out command, w=
aited 7s<br />Feb 23 17:18:46 ash-db-3 kernel: sd 7:0:0:15: timing out comm=
and, waited 7s<br />Feb 23 17:22:44 ash-db-3 kernel: sd 8:0:0:2: timing out=
 command, waited 7s<br />Feb 23 17:27:54 ash-db-3 kernel: sd 6:0:0:10: timi=
ng out command, waited 7s<br />Feb 23 17:34:42 ash-db-3 kernel: sd 8:0:0:2:=
 timing out command, waited 7s<br />Feb 23 17:35:12 ash-db-3 kernel: sd 8:0=
:0:17: timing out command, waited 7s<br />Feb 23 17:37:01 ash-db-3 kernel: =
sd 6:0:0:2: timing out command, waited 7s<br />Feb 23 17:37:17 ash-db-3 ker=
nel: sd 6:0:0:5: timing out command, waited 7s<br />Feb 23 17:39:15 ash-db-=
3 kernel: sd 6:0:0:16: timing out command, waited 7s<br />Feb 23 17:44:11 a=
sh-db-3 kernel: sd 6:0:0:2: timing out command, waited 7s<br />Feb 23 17:46=
:36 ash-db-3 kernel: sd 8:0:0:2: timing out command, waited 7s<br />Feb 23 =
17:48:30 ash-db-3 kernel: sd 6:0:0:7: timing out command, waited 7s<br />Fe=
b 23 17:51:42 ash-db-3 kernel: sd 6:0:0:16: timing out command, waited 7s<b=
r />Feb 23 17:56:53 ash-db-3 kernel: sd 6:0:0:15: timing out command, waite=
d 7s<br />Feb 23 17:59:08 ash-db-3 kernel: sd 6:0:0:2: timing out command, =
waited 7s<br />Feb 23 17:59:36 ash-db-3 kernel: sd 6:0:0:23: timing out com=
mand, waited 7s<br />Feb 23 18:01:51 ash-db-3 kernel: sd 6:0:0:16: timing o=
ut command, waited 7s</p>
<p>then when I look at "multipath -ll" i see for instance: </p>
<p>mpath12 (360060e80100b05f00530286700000008) dm-7 HITACHI,DF600F<br />siz=
e=3D1.0T features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw<br />|-+- =
policy=3D'round-robin 0' prio=3D1 status=3Denabled<br />| |- 8:0:0:2&nbsp; =
sdo&nbsp; 8:224&nbsp; active ready&nbsp; running<br />| `- 6:0:0:2&nbsp; sd=
m&nbsp; 8:192&nbsp; active ready&nbsp; running<br />`-+- policy=3D'round-ro=
bin 0' prio=3D0 status=3Denabled<br />&nbsp; |- 7:0:0:2&nbsp; sdl&nbsp; 8:1=
76&nbsp; active ready&nbsp; running<br />&nbsp; `- 5:0:0:2&nbsp; sdn&nbsp; =
8:208&nbsp; active ready&nbsp; running<br />mpath5 (360060e80100b05f0053028=
670000000f) dm-29 HITACHI,DF600F<br />size=3D1.0T features=3D'1 queue_if_no=
_path' hwhandler=3D'0' wp=3Drw<br />|-+- policy=3D'round-robin 0' prio=3D1 =
status=3Dactive<br />| |- 5:0:0:9&nbsp; sdaq 66:160 active ready&nbsp; runn=
ing<br />| `- 7:0:0:9&nbsp; sdao 66:128 active ready&nbsp; running<br />`-+=
- policy=3D'round-robin 0' prio=3D0 status=3Denabled<br />&nbsp; |- 6:0:0:9=
&nbsp; sdan 66:112 active ready&nbsp; running<br />&nbsp; `- 8:0:0:9&nbsp; =
sdap 66:144 active ready&nbsp; running</p>
<p>&nbsp;</p>
<p>So I wonder if somehow I am getting bit by the "1 queue_if_no_path", how=
ever not sure why some LUNS are alwasy ready/enabled, and then some go enab=
led/enabled. If anyone can provide assistance I would be forever grateful!!=
</p>
<p>Thanks Much.</p>
<p>&nbsp;</p>
<p>Devin Acosta</p>
<div>&nbsp;</div>
</body></html>

--=_d31b096a459e5c01b00c2fd92955bd7f--


--===============2354705010851979656==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2354705010851979656==--

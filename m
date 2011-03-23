From: =?KOI8-R?B?89TF0MHOIOajxM/Sz9c=?= <stepan.fedorov@clodo.ru>
Subject: dm-ioband max-bw and min-bw
Date: Wed, 23 Mar 2011 16:44:47 +0300
Message-ID: <AANLkTikQDe-fbSD+nvQ44OSGFY1_80eSG8ZA-Oiw0O5Z@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3334011876251752521=="
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

--===============3334011876251752521==
Content-Type: multipart/alternative; boundary=90e6ba4fc14a6e788a049f269098

--90e6ba4fc14a6e788a049f269098
Content-Type: text/plain; charset=ISO-8859-1

Hello!

I have some questions about dm-ioband module.

My m-ioband patch version is 1.14.0 on SLES11SP1 2.6.32.29-0.3-xen kernel.

/dev/mapper/1id-22-109 is a multipath device. In normal case, block device
performance test shows 500-600Mb/sec on this device.

Next i do next commands:

echo "0 $(blockdev --getsize /dev/mapper/1id-22-109) ioband
/dev/mapper/1id-22-109 0 0 0 none range-bw 0 :10000:50000" |dmsetup create
iob-22-109

in /dev/mapper i see iob-22-109 device. OK.

My block device performance test shows on this device about 50Mb/sec.

dmsetup table shows me:
iob-22-109: 0 10485760 ioband 253:5 0 4 192 none range-bw 12288 :10000:50000
for this device.

All this is OK, and next i want to change somthing. I do:
dmsetup message iob-22-109 0 max-bw 70000

My block device performance test shows now on this device about
500-600Mb/sec, and dmsetup table shows:
iob-22-109: 0 10485760 ioband 253:5 0 4 192 none range-bw 12288 :10000:0

As you can see - maximum bandwidth value, resets to zero after setting it to
70Mb by "dmsetup message ..." command.

If next i change min-bw by same way - it also rests to zero instead right
value.

My question: is this a bug in some software, or just a result of something
wrong in my actions?

Thank you!

--90e6ba4fc14a6e788a049f269098
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello!<div><br></div><div>I have some questions about dm-ioband module.</di=
v><div><br></div><div>My m-ioband patch version is 1.14.0 on SLES11SP1=A02.=
6.32.29-0.3-xen kernel.</div><div><br></div><div>/dev/mapper/1id-22-109 is =
a multipath device. In normal case, block device performance test shows 500=
-600Mb/sec on this device.</div>
<div><br></div><div>Next i do next commands:</div><div><br></div><div>echo =
&quot;0 $(blockdev --getsize /dev/mapper/1id-22-109) ioband /dev/mapper/1id=
-22-109 0 0 0 none range-bw 0 :10000:50000&quot; |dmsetup create iob-22-109=
</div>
<div><br></div><div>in /dev/mapper i see iob-22-109 device. OK.</div><div><=
br></div><div>My=A0block device performance test shows on this device about=
 50Mb/sec.</div><div><br></div><div>dmsetup table shows me:</div><div>iob-2=
2-109: 0 10485760 ioband 253:5 0 4 192 none range-bw 12288 :10000:50000</di=
v>
<div>for this device.</div><div><br></div><div>All this is OK, and next i w=
ant to change somthing. I=A0do:</div><div>dmsetup message iob-22-109 0 max-=
bw 70000</div><div><br></div><div>My block device performance test shows no=
w on this device about 500-600Mb/sec, and dmsetup table shows:</div>
<div>iob-22-109: 0 10485760 ioband 253:5 0 4 192 none range-bw 12288 :10000=
:0</div><div><br></div><div>As you can see - maximum bandwidth value, reset=
s to zero after setting it to 70Mb by &quot;dmsetup message ...&quot; comma=
nd.</div>
<div><br></div><div>If next i change min-bw by same way - it also rests to =
zero instead right value.</div><div><br></div><div>My question: is this a b=
ug in some software, or just a result of something wrong in my actions?</di=
v>
<div><br></div><div>Thank you!</div><div><br></div>

--90e6ba4fc14a6e788a049f269098--


--===============3334011876251752521==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3334011876251752521==--

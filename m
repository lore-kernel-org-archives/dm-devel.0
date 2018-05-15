From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Incorrect results for device mapper statistics
Date: Mon, 14 May 2018 17:55:28 -0700
Message-ID: <CAN-y+E+Gxkw=bzvrAxHfBL_XrVmJtKfG2PcuUMBguDvSZhNmpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3714717871850536274=="
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

--===============3714717871850536274==
Content-Type: multipart/alternative; boundary="000000000000015af9056c340fc7"

--000000000000015af9056c340fc7
Content-Type: text/plain; charset="UTF-8"

Referring to this:
https://www.kernel.org/doc/Documentation/device-mapper/statistics.txt

Basically it seems like a discard takes a certain amount of time, and the
discard can span multiple statistic areas. Each area then claims it took
that total amount of time for the discard, making the accounting of
statistics incorrect. I think a solution would be to divide the amount of
time by the number of areas, and attribute that to the individual area's
stats. It wouldn't be perfect, but it would be much closer to accurate.

root@cloudthree:~# dmsetup create testing --table "0 100000 linear
/dev/mapper/local-nvme 0"

root@cloudthree:~# stat /dev/mapper/testing
  File: /dev/mapper/testing -> ../dm-13

root@cloudthree:~# grep dm-13 /proc/diskstats
 253      13 dm-13 56 0 1312 0 0 0 0 0 0 0 0

root@cloudthree:~# dmstats create --areas 10 testing
testing: Created new region with 10 area(s) as region ID 0

root@cloudthree:~# blkdiscard /dev/dm-13

root@cloudthree:~# dmstats print --regionid 0 testing
0+10000 26 0 1072 0 1 1 10000 40 0 40 40 0 40
10000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40
20000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40
30000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40
40000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40
50000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40
60000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40
70000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40
80000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40
90000+10000 30 0 240 8 1 1 10000 40 0 48 48 8 40

root@cloudthree:~# grep dm-13 /proc/diskstats
 253      13 dm-13 112 0 2624 8 1 0 100000 40 0 48 48

The entire device has the correct stats, but the each area has the total
time spent doing the discard for all areas.

Assuming https://github.com/torvalds/linux/blob/master/drivers/md/dm-stats.c
is responsible for this, my guess is it maybe cannot account for this...
and that things like discards and flushes are dealt with elsewhere. If I
had a feature request, it would be for separate (correct) stats for
discards.

--000000000000015af9056c340fc7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Referring to this: <a href=3D"https://www.kernel.org/=
doc/Documentation/device-mapper/statistics.txt">https://www.kernel.org/doc/=
Documentation/device-mapper/statistics.txt</a><br></div><div><br></div><div=
>Basically it seems like a discard takes a certain amount of time, and the =
discard can span multiple statistic areas. Each area then claims it took th=
at total amount of time for the discard, making the accounting of statistic=
s incorrect. I think a solution would be to divide the amount of time by th=
e number of areas, and attribute that to the individual area&#39;s stats. I=
t wouldn&#39;t be perfect, but it would be much closer to accurate.</div><d=
iv><br></div><div><div>root@cloudthree:~# dmsetup create testing --table &q=
uot;0 100000 linear /dev/mapper/local-nvme 0&quot;</div><div><br></div><div=
>root@cloudthree:~# stat /dev/mapper/testing</div><div>=C2=A0 File: /dev/ma=
pper/testing -&gt; ../dm-13</div><div><br></div><div>root@cloudthree:~# gre=
p dm-13 /proc/diskstats</div><div>=C2=A0253=C2=A0 =C2=A0 =C2=A0 13 dm-13 56=
 0 1312 0 0 0 0 0 0 0 0</div><div><br></div><div>root@cloudthree:~# dmstats=
 create --areas 10 testing</div><div>testing: Created new region with 10 ar=
ea(s) as region ID 0</div><div><br></div><div>root@cloudthree:~# blkdiscard=
 /dev/dm-13</div><div><br></div><div>root@cloudthree:~# dmstats print --reg=
ionid 0 testing</div><div>0+10000 26 0 1072 0 1 1 10000 40 0 40 40 0 40</di=
v><div>10000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40</div><div>20000+10000 =
0 0 0 0 1 1 10000 40 0 40 40 0 40</div><div>30000+10000 0 0 0 0 1 1 10000 4=
0 0 40 40 0 40</div><div>40000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40</div=
><div>50000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40</div><div>60000+10000 0=
 0 0 0 1 1 10000 40 0 40 40 0 40</div><div>70000+10000 0 0 0 0 1 1 10000 40=
 0 40 40 0 40</div><div>80000+10000 0 0 0 0 1 1 10000 40 0 40 40 0 40</div>=
<div>90000+10000 30 0 240 8 1 1 10000 40 0 48 48 8 40</div><div><br></div><=
div>root@cloudthree:~# grep dm-13 /proc/diskstats</div><div>=C2=A0253=C2=A0=
 =C2=A0 =C2=A0 13 dm-13 112 0 2624 8 1 0 100000 40 0 48 48</div></div><div>=
<br></div><div>The entire device has the correct stats, but the each area h=
as the total time spent doing the discard for all areas.</div><div><br></di=
v><div>Assuming=C2=A0<a href=3D"https://github.com/torvalds/linux/blob/mast=
er/drivers/md/dm-stats.c">https://github.com/torvalds/linux/blob/master/dri=
vers/md/dm-stats.c</a> is responsible for this, my guess is it maybe cannot=
 account for this... and that things like discards and flushes are dealt wi=
th elsewhere. If I had a feature request, it would be for separate (correct=
) stats for discards.</div></div>

--000000000000015af9056c340fc7--


--===============3714717871850536274==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3714717871850536274==--

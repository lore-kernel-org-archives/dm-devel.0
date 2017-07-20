From: muneendra kumar <muneendra737@gmail.com>
Subject: multipath dm_request_fn(in dm.c) is not getting called
Date: Thu, 20 Jul 2017 19:36:23 +0530
Message-ID: <CAAhcyzmrph9eKW1F9aF+qC0WzBY70Cd9bT1jC-xvBsi-a3+qdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1235400830591876815=="
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

--===============1235400830591876815==
Content-Type: multipart/alternative; boundary="94eb2c0ddb0af886c00554c04035"

--94eb2c0ddb0af886c00554c04035
Content-Type: text/plain; charset="UTF-8"

Hi,

We are testing the multipath behavior on centos7.3 and linux version Linux
EC056108 3.10.

We have two paths connected to dm-1(sda and sdb).

We are using fio tool to read  data from /dev/dm-1 and we are seeing data
on both paths(sda and sdb)

Below is the fio  command which we are using

./fio --filename=/dev/dm-2 --direct=1 --rw=randrw --refill_buffers
--norandommap --randrepeat=0 --ioengine=libaio --bs=512k --rwmixread=100
--iodepth=16 --numjobs=16 --runtime=60 --group_reporting --name=4ktest
--size=500m



Test Case: Dropping all the requests on sdb .



Observation: When we drop frames on sdb we observe  that on both sda and
sdb there is no data flow.

HBA is taking around 30 secs to report the io failure then followed by
failover.

During this 30 secs time we are not seeing any data on sda and even
dm_request_fn(in dm.c) is not getting called which internally pushes the
queue request to sda/sdb.

Theoretically data should flow on sda as we are dropping data only on  sdb.



Any inputs here will help me to understand the concept better.



Regards,

Muneendra.

--94eb2c0ddb0af886c00554c04035
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><p class=3D"MsoNormal">Hi,<span></span></p>

<p class=3D"MsoNormal">We are testing the multipath behavior on centos7.3 a=
nd linux
version Linux EC056108 3.10.<span></span></p>

<p class=3D"MsoNormal">We have two paths connected to dm-1(sda and sdb).<sp=
an></span></p>

<p class=3D"MsoNormal">We are using fio tool to read =C2=A0data from /dev/d=
m-1 and
we are seeing data on both paths(sda and sdb)<span></span></p>

<p class=3D"MsoNormal">Below is the fio=C2=A0 command which we are using<sp=
an></span></p>

<p class=3D"MsoNormal">./fio --filename=3D/dev/dm-2 --direct=3D1 --rw=3Dran=
drw
--refill_buffers --norandommap --randrepeat=3D0 --ioengine=3Dlibaio --bs=3D=
512k
--rwmixread=3D100 --iodepth=3D16 --numjobs=3D16 --runtime=3D60 --group_repo=
rting
--name=3D4ktest --size=3D500m<span></span></p>

<p class=3D"MsoNormal"><span>=C2=A0</span></p>

<p class=3D"MsoNormal">Test Case: Dropping all the requests on sdb .<span><=
/span></p>

<p class=3D"MsoNormal"><span>=C2=A0</span></p>

<p class=3D"MsoNormal">Observation: When we drop frames on sdb we observe
=C2=A0that on both sda and sdb there is no data flow.<span></span></p>

<p class=3D"MsoNormal">HBA is taking around 30 secs to report the io failur=
e then
followed by failover.<span></span></p>

<p class=3D"MsoNormal">During this 30 secs time we are not seeing any data =
on sda
and even dm_request_fn(in dm.c) is not getting called which internally push=
es
the queue request to sda/sdb.<span></span></p>

<p class=3D"MsoNormal">Theoretically data should flow on sda as we are drop=
ping
data only on =C2=A0sdb.<span></span></p>

<p class=3D"MsoNormal"><span>=C2=A0</span></p>

<p class=3D"MsoNormal">Any inputs here will help me to understand the conce=
pt
better.<span></span></p>

<p class=3D"MsoNormal"><span>=C2=A0</span></p>

<p class=3D"MsoNormal">Regards,<span></span></p>

<p class=3D"MsoNormal">Muneendra.<span></span></p></div>

--94eb2c0ddb0af886c00554c04035--


--===============1235400830591876815==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1235400830591876815==--

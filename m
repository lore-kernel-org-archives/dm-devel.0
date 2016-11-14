From: Alexander Pashaliyski <al.pashaliyski@gmail.com>
Subject: dm-cache issue
Date: Mon, 14 Nov 2016 17:02:47 +0200
Message-ID: <CAJV2nOTJoWWc=N80e6WCpZUh6ZRxvCW8Wt=aZWTyYSKso+kQ5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4549331263041435075=="
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

--===============4549331263041435075==
Content-Type: multipart/alternative; boundary=001a114682f00ed9b10541442223

--001a114682f00ed9b10541442223
Content-Type: text/plain; charset=UTF-8

Hi guys,


I am in a process of evaluating dm-cache for our backup system.

Currently I have an issue when restart the backup server. The server is
booting for hours, because of IO load. It seems is triggered a flush from
SSD disk (that is used for a cache device) to the raid controllers (they
are with slow SATA disks).
I have 10 cached logical volumes in *writethrough mode*, each with 2T of
data over 2 raid controllers. I use a single SSD disk for the cache.
The backup system is with lvm2-2.02.164-1 & kernel 4.4.30.


Do you have any ideas why such flush is triggered? In writethrough cache
mode we shouldn't have dirty blocks in the cache.


Thanks,
Alex

--001a114682f00ed9b10541442223
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi guys,<br><br><br>I am in a process of evaluating d=
m-cache for our backup system.<br><br>Currently I have an issue when restar=
t the backup server. The server is booting for hours, because of IO load. I=
t seems is triggered a flush from SSD disk (that is used for a cache device=
) to the raid controllers (they are with slow SATA disks).<br>I have 10 cac=
hed logical volumes in <b>writethrough mode</b>, each with 2T of data over =
2 raid controllers. I use a single SSD disk for the cache.<br></div>The bac=
kup system is with lvm2-2.02.164-1 &amp; kernel 4.4.30.<br><div><br><br>Do =
you have any ideas why such flush is triggered? In writethrough cache mode =
we shouldn&#39;t have dirty blocks in the cache.<br>=C2=A0<br><br>Thanks,<b=
r>Alex<br><br></div></div>

--001a114682f00ed9b10541442223--


--===============4549331263041435075==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4549331263041435075==--

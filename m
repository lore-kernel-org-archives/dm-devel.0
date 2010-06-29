From: Jia Rao <rickenrao@gmail.com>
Subject: Problem using dm-ioband
Date: Tue, 29 Jun 2010 00:29:49 -0400
Message-ID: <AANLkTikvRCSPikO83WENQ62rm7lTPO-ki-vneqXqmeXL@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8022403614373430455=="
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

--===============8022403614373430455==
Content-Type: multipart/alternative; boundary=001636c5c06d154537048a23b0d6

--001636c5c06d154537048a23b0d6
Content-Type: text/plain; charset=ISO-8859-1

Hi, all,

I am trying to use dm-ioband to control the per process IO bandwidth. I had
some problems create the ioband device mapper on my disk. The following is
the system info

OS: CentOS kernel 2.6.32.15
dm-ioand: v1.14.0


I followed the dm-ioand installation instructions to create ioband1:

echo "0 $(blockdev --getsize /dev/sdb) ioband /dev/sdb 1 0 0 none weight
0:100" | dmsetup create ioband1

There was an error: device-mapper: reload ioctl failed: Invalid argument
I umounted the partition first, still got the same error.

One thing I want to mention is that, /dev/sdb is a device from a iSCSI
protocol from a storage server.
Does it matter?

I also tried to create ioband1 on local partitions, same error.

Any ideas?

Thanks in advance.

--001636c5c06d154537048a23b0d6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi, all,<div><br></div><div>I am trying to use dm-ioband to control the per=
 process IO bandwidth. I had some problems create the ioband device mapper =
on my disk. The following is the system info</div><div><br></div><div>OS: C=
entOS kernel 2.6.32.15</div>
<div>dm-ioand: v1.14.0</div><div><br></div><div><br></div><div>I followed t=
he dm-ioand installation instructions to create ioband1:</div><div><br></di=
v><div><div>echo &quot;0 $(blockdev --getsize /dev/sdb) ioband /dev/sdb 1 0=
 0 none weight 0:100&quot; | dmsetup create ioband1</div>
</div><div><br></div><div>There was an error:=A0device-mapper: reload ioctl=
 failed: Invalid argument</div><div>I umounted the partition first, still g=
ot the same error.</div><div><br></div><div>One thing I want to mention is =
that, /dev/sdb is a device from a iSCSI protocol from a storage server.</di=
v>
<div>Does it matter?</div><div><br></div><div>I also tried to create ioband=
1 on local partitions, same error.</div><div><br></div><div>Any ideas?</div=
><div><br></div><div>Thanks in advance.</div><div><br></div><div><br></div>

--001636c5c06d154537048a23b0d6--


--===============8022403614373430455==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8022403614373430455==--

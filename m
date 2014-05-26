From: =?UTF-8?B?0KDQuNGI0LDRgiDQotC10YDQtdCz0YPQu9C+0LI=?=
	<rtereguloff@gmail.com>
Subject: Problem with overlay free space
Date: Mon, 26 May 2014 17:41:24 +0600
Message-ID: <CAOamaRSTTx=rcLxJZMKBqmDDt6oiceT8zXAkZHp_xwickBz7uA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0760950283149299900=="
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

--===============0760950283149299900==
Content-Type: multipart/alternative; boundary=089e013d11a24c414504fa4c1042

--089e013d11a24c414504fa4c1042
Content-Type: text/plain; charset=UTF-8

Hello to everyone.
I have configured flash disk with linux, with ext3fs.img and configured
device-mapper overlay file system. I have a problem: when I write some
files on it, and even if I then delete this files, system still do not free
blocks, (df -h show everything ok, but dmsetup status shows another
situation) and space on snapshot is ending, because of it system is going
down with errors (device-mapper: snapshots: Invalidating snapshot: Unable
to allocate exceptin, buffer i/o error on device dm-0 overlay and ext3-fs
error (device dm-0)). Can you help me with that?

--089e013d11a24c414504fa4c1042
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><font><font>Hello to everyone.</font></font><div><font><fo=
nt>I have configured flash disk with linux, with ext3fs.img and configured =
device-mapper overlay file system. I have a problem: when I write some file=
s on it, and even if I then delete this files, system still do not free blo=
cks, (df -h show everything ok, but dmsetup status shows another situation)=
 and space on snapshot is ending, because of it system is going down with e=
rrors (device-mapper: snapshots: Invalidating snapshot: Unable to allocate =
exceptin,=C2=A0</font></font>buffer i/o error on device dm-0 overlay and=C2=
=A0ext3-fs error (device dm-0)). Can you help me with that?</div>

</div>

--089e013d11a24c414504fa4c1042--


--===============0760950283149299900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0760950283149299900==--

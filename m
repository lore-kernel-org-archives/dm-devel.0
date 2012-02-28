From: "**me**" <sam.wanshan@gmail.com>
Subject: How to distinguish active and standby path?
Date: Tue, 28 Feb 2012 15:16:46 +0800
Message-ID: <CALAUA6x8ntCaWP9XBva9sN97thTehZmu4Dq3cjgshJ-xffwD5Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1579318759220177756=="
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
To: christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1579318759220177756==
Content-Type: multipart/alternative; boundary=f46d0418266287bc9b04ba01029c

--f46d0418266287bc9b04ba01029c
Content-Type: text/plain; charset=ISO-8859-1

Hi Christophe,

  We're using your multipath tools to access an Active-Standby
storage(Oracle SS7420 if you're concerned.)

  There're 4 path's to a LUN, 2 active and 2 standby.
  But we can't distinguish them from 'multipath -ll'.

  for example:
-------------------------------------------------------------------------
chuli3v0 (3600144f0ad85965d00004f446c610001) dm-34 SUN,ZFS Storage 7420
[size=4.0T][features=0][hwhandler=0][rw]
\_ round-robin 0 [prio=1][enabled]
 \_ 8:0:2:2  sdbd 67:112  [active][ready]
\_ round-robin 0 [prio=1][enabled]
 \_ 6:0:3:2  sdt  65:48   [active][ready]
\_ round-robin 0 [prio=1][enabled]
 \_ 8:0:0:2  sdbv 68:144  [active][ready]
\_ round-robin 0 [prio=1][enabled]
 \_ 6:0:2:2  sdcn 69:176  [active][ready]
-----------------------------------------------------------------------

  All 4 path's are same.
  We're using redhat 5.5 and multipath 0.4.7

  Is there any way to distinguish them?

  Thanks and regards

Sam

--f46d0418266287bc9b04ba01029c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,<br><br>=A0 We&#39;re using your multipath tools to access an=
 Active-Standby storage(Oracle SS7420 if you&#39;re concerned.)<br><br>=A0 =
There&#39;re 4 path&#39;s to a LUN, 2 active and 2 standby.<br>=A0 But we c=
an&#39;t distinguish them from &#39;multipath -ll&#39;.<br>
<br>=A0 for example:<br>---------------------------------------------------=
----------------------<br>chuli3v0 (3600144f0ad85965d00004f446c610001) dm-3=
4 SUN,ZFS Storage 7420<br>[size=3D4.0T][features=3D0][hwhandler=3D0][rw]<br=
>\_ round-robin 0 [prio=3D1][enabled]<br>
=A0\_ 8:0:2:2=A0 sdbd 67:112=A0 [active][ready]<br>\_ round-robin 0 [prio=
=3D1][enabled]<br>=A0\_ 6:0:3:2=A0 sdt=A0 65:48=A0=A0 [active][ready]<br>\_=
 round-robin 0 [prio=3D1][enabled]<br>=A0\_ 8:0:0:2=A0 sdbv 68:144=A0 [acti=
ve][ready]<br>\_ round-robin 0 [prio=3D1][enabled]<br>
=A0\_ 6:0:2:2=A0 sdcn 69:176=A0 [active][ready]<br>------------------------=
-----------------------------------------------<br><br>=A0 All 4 path&#39;s=
 are same.<br>=A0 We&#39;re using redhat 5.5 and multipath 0.4.7<br><br>=A0=
 Is there any way to distinguish them?<br>
<br>=A0 Thanks and regards<br><br>Sam<br>

--f46d0418266287bc9b04ba01029c--


--===============1579318759220177756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1579318759220177756==--

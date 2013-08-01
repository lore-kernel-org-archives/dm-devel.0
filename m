From: John Strange <johnstra10@gmail.com>
Subject: Extending DM w/ new target type
Date: Thu, 1 Aug 2013 11:04:37 -0600
Message-ID: <CAH1aXXYQVnYndk7S6-6TM9hiuTE2xpN+4Qt8BA_36PvrQVQSsw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3664482094823221403=="
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

--===============3664482094823221403==
Content-Type: multipart/alternative; boundary=089e013cb6e44bb23304e2e5d631

--089e013cb6e44bb23304e2e5d631
Content-Type: text/plain; charset=ISO-8859-1

two questions:

1. I'd like to use DM with a new target type.  I'm porting our virtualized
storage solution from Windows.  I've been able to register my target and
get callbacks working, but in looking at the dm-raid code, I'm concerned
with how tightly coupled it is with the routines in md.c (multiple devices
implementation).  Is there an expectation that a DM target use the md_xxxx
routines?

2. I used dmsetup to create a mapping for a device that my target
controls.  Is there a way to make the underlying device (e.g. /dev/sdb) not
visible to the system?  I'm paranoid about external accesses to a LUN that
I'm using.

-john

--089e013cb6e44bb23304e2e5d631
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>two questions:<br><br></div>1. I&#39;d like=
 to use DM with a new target type.=A0 I&#39;m porting our virtualized stora=
ge solution from Windows.=A0 I&#39;ve been able to register my target and g=
et callbacks working, but in looking at the dm-raid code, I&#39;m concerned=
 with how tightly coupled it is with the routines in md.c (multiple devices=
 implementation).=A0 Is there an expectation that a DM target use the md_xx=
xx routines?<br>
<br></div>2. I used dmsetup to create a mapping for a device that my target=
 controls.=A0 Is there a way to make the underlying device (e.g. /dev/sdb) =
not visible to the system?=A0 I&#39;m paranoid about external accesses to a=
 LUN that I&#39;m using.<br>
<br></div>-john<br></div>

--089e013cb6e44bb23304e2e5d631--


--===============3664482094823221403==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3664482094823221403==--

From: "Darryl Dixon" <esrever_otua@pythonhacker.is-a-geek.net>
Subject: Multipath on root
Date: Fri, 8 Sep 2006 15:31:49 +1200 (NZST)
Message-ID: <15021.203.97.62.217.1157686309.squirrel@pythonhacker.is-a-geek.net>
Reply-To: esrever_otua@pythonhacker.is-a-geek.net,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi All,

I write as I have some questions about dm-multipath, and there seems to b=
e
a dearth of good documentation available. To make things worse the
official Wiki even contains self-conflicting information (compare:
http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=3DFAQ """supports r=
oot
FS on multipathed SAN""" vs
http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=3DUsageFile """DM-M=
P
cannot be run on either the root or boot device.""").
I figured what better place to get answers than from the experts involved
in actually developing the system :)

What I would please like to get a clear understanding of is:

1) What are the software components and dependencies involved in the bare
necessities of making dm-multipath work? I've reviewed the architectural
diagrams (which are quite good), but am looking more specifically for
answers to things like 'is there actually a hard technical necessity for
udev in order to actually make dm-multipath to work, or is its presence
more an artifact of the assumptions built-in to overall design of the
system?'

2) Why exactly can't dm-multipath be used to multipath a root filesystem?
What are the dependencies that can't be met by initrd? Why is dm-multipat=
h
different in this regard to any other block driver, eg md or LVM?
OR
2) What exactly, specifically is required in order to have root on a
multipath device? A high-level overview would probably be more useful tha=
n
nitty-gritty of what entry to put in what file, at this point.

I'm guessing that a solid answer to (1) above will probably answer (2) in
the process.

The reason for the request is that the seemingly desirable and obvious
option of booting from a SAN on Linux is pretty much worthless if
multipathing can't be used for root - your system is less safe than
booting from some mirrored internal disks...

Thanks in advance for any and all assistance and answers on this,

Darryl Dixon
http://www.winterhouseconsulting.com

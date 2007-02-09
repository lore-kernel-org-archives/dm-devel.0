From: David =?UTF-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>
Subject: Bug#409875: [Pkg-cryptsetup-devel] Bug#409875: cannot setup device-mapper      mapping ontop of /dev/md* device
Date: Fri, 9 Feb 2007 13:00:53 +0100 (CET)
Message-ID: <22484.145.64.134.242.1171022453.squirrel@www.hardeman.nu>
References: <20070206220221.GL1316@doriath.informatik.uni-erlangen.de>
    <20070206234626.GA26196@hardeman.nu>
    <20070206235151.GM1316@doriath.informatik.uni-erlangen.de>
    <20070207212457.GA12135@hardeman.nu>
    <20070207213127.GA32661@doriath.informatik.uni-erlangen.de>
    <32476.145.64.134.242.1170938284.squirrel@www.hardeman.nu>
    <20070208185253.GK32661@doriath.informatik.uni-erlangen.de>
    <20070208213609.GA6406@hardeman.nu>
    <20070208215149.GL32661@doriath.informatik.uni-erlangen.de>
    <20070208224333.GC9849@hardeman.nu>
    <20070209104537.GA18085@bee.dooz.org>
Reply-To: David =?UTF-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>,
	409875@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.409875.B409875.117102252330559@bugs.debian.org>
In-Reply-To: <20070209104537.GA18085@bee.dooz.org>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Loic Minier <lool+alioth@via.ecp.fr>
Cc: dm-devel@redhat.com, Johannes Schlumberger <asso@doriath.informatik.uni-erlangen.de>, waldi@debian.org, 409875@bugs.debian.org, pkg-lvm-maintainers@lists.alioth.debian.org, agk@redhat.com, debian-devel@lists.debian.org
List-Id: dm-devel.ids

On Fri, February 9, 2007 11:45, Loic Minier said:
> On Thu, Feb 08, 2007, David H=E4rdeman wrote:
>> dmsetup / cryptsetup both fail to create a mapping on top of a raid
>> device (/dev/md0 in this case).
>
>  I don't know where the error lies, but I created two loop devices loop=
0
>  and loop1, added them to a new RAID 1 md0 device, and ran cryptsetup o=
n
>  the resulting md0 successfully.

Ditto. I've succesfully setup a crypto mapping on a raid1 device under
qemu, which leads me to believe that it is something specific to Johannes
setup.

So I'm hoping that someone will come up with some suggestions on how to
troubleshoot it further on his machine.

(This is my last cross-post on this subject, I promise, please keep
further discussions to the bug report address only -
409875@bugs.debian.org)

--=20
David H=E4rdeman



--=20
To UNSUBSCRIBE, email to debian-bugs-dist-REQUEST@lists.debian.org
with a subject of "unsubscribe". Trouble? Contact listmaster@lists.debian=
.org

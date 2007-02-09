From: =?UTF-8?Q?Lo=C3=AFc?= Minier <lool+alioth@via.ecp.fr>
Subject: Bug#409875: cannot setup device-mapper mapping ontop of /dev/md* device
Date: Fri, 9 Feb 2007 11:45:37 +0100
Message-ID: <20070209104537.GA18085@bee.dooz.org>
References: <20070206220221.GL1316@doriath.informatik.uni-erlangen.de> <20070206234626.GA26196@hardeman.nu> <20070206235151.GM1316@doriath.informatik.uni-erlangen.de> <20070207212457.GA12135@hardeman.nu> <20070207213127.GA32661@doriath.informatik.uni-erlangen.de> <32476.145.64.134.242.1170938284.squirrel@www.hardeman.nu> <20070208185253.GK32661@doriath.informatik.uni-erlangen.de> <20070208213609.GA6406@hardeman.nu> <20070208215149.GL32661@doriath.informatik.uni-erlangen.de> <20070208224333.GC9849@hardeman.nu>
Reply-To: =?UTF-8?Q?Lo=C3=AFc?= Minier <lool+alioth@via.ecp.fr>,
	409875@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.409875.B409875.117101794423027@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <20070208224333.GC9849@hardeman.nu>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: dm-devel@redhat.com
Cc: Johannes Schlumberger <asso@doriath.informatik.uni-erlangen.de>, 409875@bugs.debian.org, agk@redhat.com, waldi@debian.org, pkg-lvm-maintainers@lists.alioth.debian.org
List-Id: dm-devel.ids

On Thu, Feb 08, 2007, David H=E4rdeman wrote:
> dmsetup / cryptsetup both fail to create a mapping on top of a raid=20
> device (/dev/md0 in this case).

 I don't know where the error lies, but I created two loop devices loop0
 and loop1, added them to a new RAID 1 md0 device, and ran cryptsetup on
 the resulting md0 successfully.

 bee:~# dmsetup  ls
 ...
 crypt0  (253, 6)

 bee:~# dmsetup table crypt0
 0 65408 crypt aes-cbc-plain
 42cfa211018ea492fdee45ac637b7972a0ad687380f9a6d0484900ad8cca2d8f 0 9:0
 0

 bee:~# mdadm --detail /dev/md0
 ...
    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1

--=20
Lo=EFc Minier <lool@dooz.org>

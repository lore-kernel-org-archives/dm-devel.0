From: Henrique de Moraes Holschuh <hmh@debian.org>
Subject: Bug#409875: [Pkg-cryptsetup-devel] Bug#409875: cannot setup device-mapper mapping ontop of /dev/md* device
Date: Fri, 9 Feb 2007 12:33:36 -0200
Message-ID: <20070209143336.GF26414@khazad-dum.debian.net>
References: <20070206235151.GM1316@doriath.informatik.uni-erlangen.de> <20070207212457.GA12135@hardeman.nu> <20070207213127.GA32661@doriath.informatik.uni-erlangen.de> <32476.145.64.134.242.1170938284.squirrel@www.hardeman.nu> <20070208185253.GK32661@doriath.informatik.uni-erlangen.de> <20070208213609.GA6406@hardeman.nu> <20070208215149.GL32661@doriath.informatik.uni-erlangen.de> <20070208224333.GC9849@hardeman.nu> <20070209104537.GA18085@bee.dooz.org> <22484.145.64.134.242.1171022453.squirrel@www.hardeman.nu>
Reply-To: Henrique de Moraes Holschuh <hmh@debian.org>,
	409875@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.409875.B409875.11710316265260@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <22484.145.64.134.242.1171022453.squirrel@www.hardeman.nu>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: David =?UTF-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Loic Minier <lool+alioth@via.ecp.fr>, dm-devel@redhat.com, Johannes Schlumberger <asso@doriath.informatik.uni-erlangen.de>, waldi@debian.org, 409875@bugs.debian.org, pkg-lvm-maintainers@lists.alioth.debian.org, agk@redhat.com, debian-devel@lists.debian.org
List-Id: dm-devel.ids

On Fri, 09 Feb 2007, David H=E4rdeman wrote:
> > On Thu, Feb 08, 2007, David H=E4rdeman wrote:
> >> dmsetup / cryptsetup both fail to create a mapping on top of a raid
> >> device (/dev/md0 in this case).
> >
> >  I don't know where the error lies, but I created two loop devices lo=
op0
> >  and loop1, added them to a new RAID 1 md0 device, and ran cryptsetup=
 on
> >  the resulting md0 successfully.
>=20
> Ditto. I've succesfully setup a crypto mapping on a raid1 device under
> qemu, which leads me to believe that it is something specific to Johann=
es
> setup.

Warning: It is not safe on all kernels out there, due to kernel bugs.  Se=
e
recent flow of patches from the md maintainer in LKML.  I don't know if t=
hey
all landed on 2.6.16.y and 2.6.19.y and 2.6.20 yet.

--=20
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

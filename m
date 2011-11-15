From: Milan Broz <mbroz@redhat.com>
Subject: Bug#648367: [dm-devel] Bug#648367: device-mapper devices such as dm-crypt always have rotational=1; should inherit "rotational" setting from underlying devices
Date: Tue, 15 Nov 2011 18:05:31 +0100
Message-ID: <4EC29BDB.8090803@redhat.com>
References: <20111110195943.12083.93273.reportbug@leaf> <1321232729.3059.42.camel@deadeye> <20111114022644.GB30421@leaf> <4EC215FA.1090303@redhat.com> <20111115164151.GA24015@leaf>
Reply-To: Milan Broz <mbroz@redhat.com>, 648367@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.648367.B648367.132137674014933@bugs.debian.org>
In-Reply-To: <20111115164151.GA24015@leaf>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Josh Triplett <josh@joshtriplett.org>
Cc: device-mapper development <dm-devel@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, 648367@bugs.debian.org
List-Id: dm-devel.ids

On 11/15/2011 05:41 PM, Josh Triplett wrote:
> I didn't know about that command; very nice, thanks!  lsblk confirms
> that on my system, the physical disk has rotational=3D0 but the dm-cryp=
t
> and LVM devices have rotational=3D1:
>=20
> NAME                   ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCH=
ED
> sda                            0    512      0     512     512    0 cfq
> =E2=94=9C=E2=94=80sda1                         0    512      0     512 =
    512    0 cfq
> =E2=94=94=E2=94=80sda2                         0    512      0     512 =
    512    0 cfq
>   =E2=94=94=E2=94=80sda2_crypt (dm-0)          0    512      0     512 =
    512    1=20
>     =E2=94=9C=E2=94=80leaf-swap (dm-1)         0    512      0     512 =
    512    1=20
>     =E2=94=94=E2=94=80leaf-root (dm-2)         0    512      0     512 =
    512    1=20
>=20
> Does that help?

Thanks.

As noted on that bug earlier, it is already fixed in 3.2-rc1
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommit=
diff;h=3D4693c9668fdcec229825b3763876b4744f9e6d5e

(I thought it is fixed long time ago!)

There is no problem in DM layer with this (dmcrypt does not have own io s=
cheduler)
but perhaps FS can use this flag for some optimization tuning, dunno.

Milan

From: Josh Triplett <josh@joshtriplett.org>
Subject: Bug#648367: [dm-devel] Bug#648367: device-mapper devices such as dm-crypt always have rotational=1; should inherit "rotational" setting from underlying devices
Date: Tue, 15 Nov 2011 08:41:52 -0800
Message-ID: <20111115164151.GA24015@leaf>
References: <20111110195943.12083.93273.reportbug@leaf>
 <1321232729.3059.42.camel@deadeye>
 <20111114022644.GB30421@leaf>
 <4EC215FA.1090303@redhat.com>
Reply-To: Josh Triplett <josh@joshtriplett.org>, 648367@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.648367.B648367.13213753218075@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <4EC215FA.1090303@redhat.com>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, 648367@bugs.debian.org
List-Id: dm-devel.ids

On Tue, Nov 15, 2011 at 08:34:18AM +0100, Milan Broz wrote:
> On 11/14/2011 03:26 AM, Josh Triplett wrote:
> > OK, I suppose I don't actually care what rotational shows for a
> > device-mapper device backed by rotating media.  The case I care about=
:
> > when the underlying media has rotational=3D0, the dm device definitel=
y
> > shouldn't have rotational=3D1.
>=20
> Rotational flag is inherited in DM core, nothing dm-crypt specific.
> And it works (for several kernel releases already):
>=20
>=20
> create test scsi disk (also with discards)
> # modprobe scsi_debug dev_size_mb=3D16 sector_size=3D512 num_tgts=3D1 l=
bpu=3D1
> # grep scsi_debug /sys/block/*/device/model              =20
> /sys/block/sdj/device/model:scsi_debug=20
>=20
> Map some crypt device over it
> # echo "password" | cryptsetup create sdj_crypt /dev/sdj
>=20
> And now see inherited ROTA flag (it is /sys rotational)
>=20
> # lsblk -t /dev/sdj
> NAME               ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED R=
Q-SIZE
> sdj                        0    512  32768     512     512    0 cfq    =
   128
> `-sdj_crypt (dm-0)         0    512  32768     512     512    0        =
   128
>=20
>=20
> Please paste lsblk -t output tree if you think there is a bug, do not b=
lindly
> check all dm-X devices queues.

I didn't know about that command; very nice, thanks!  lsblk confirms
that on my system, the physical disk has rotational=3D0 but the dm-crypt
and LVM devices have rotational=3D1:

NAME                   ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED
sda                            0    512      0     512     512    0 cfq
=E2=94=9C=E2=94=80sda1                         0    512      0     512   =
  512    0 cfq
=E2=94=94=E2=94=80sda2                         0    512      0     512   =
  512    0 cfq
  =E2=94=94=E2=94=80sda2_crypt (dm-0)          0    512      0     512   =
  512    1=20
    =E2=94=9C=E2=94=80leaf-swap (dm-1)         0    512      0     512   =
  512    1=20
    =E2=94=94=E2=94=80leaf-root (dm-2)         0    512      0     512   =
  512    1=20

Does that help?

- Josh Triplett

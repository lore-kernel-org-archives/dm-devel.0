From: Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
 read-write for read-only mappings
Date: Tue, 15 Feb 2011 16:20:33 +0100
Message-ID: <20110215152033.GK3160@htj.dyndns.org>
References: <4D5A6EF4.3030905@redhat.com>
 <20110215124629.GF5825@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110215124629.GF5825@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hello,

On Tue, Feb 15, 2011 at 12:46:29PM +0000, Alasdair G Kergon wrote:
> On Tue, Feb 15, 2011 at 01:17:56PM +0100, Milan Broz wrote:
> >         fd =3D open(device, O_RDWR | flags);
> >         if (fd =3D=3D -1 && errno =3D=3D EROFS) {
> >                 *readonly =3D 1;
> >                 fd =3D open(device, O_RDONLY | flags);
> >         }
>=20
> Would it be reasonable for your patch to return EROFS rather than
> EACCES?
>=20
> man 2 open:
>        int open(const char *pathname, int flags, mode_t mode);
>=20
>        EROFS  pathname  refers  to a file on a read-only file system =
and write
>               access was requested.
>=20
>        EACCES The requested access to the file is not allowed, or sea=
rch  per=E2=80=90
>               mission  is denied for one of the directories in the pa=
th prefix
>               of pathname, or the file did not exist yet and write  a=
ccess  to
>               the  parent  directory  is  not allowed.  (See also pat=
h_resolu=E2=80=90
>               tion(7).)

Hmmm... but -EACCES is the correct one here.  The device node itself
is rejecting RW access.  There's no FS which is enforcing RO.  But if
the userland is already expecting that, dm can simply change the error
code, no?

Thanks.

--=20
tejun

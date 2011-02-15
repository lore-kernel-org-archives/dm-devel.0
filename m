From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
	read-write for read-only mappings
Date: Tue, 15 Feb 2011 12:46:29 +0000
Message-ID: <20110215124629.GF5825@agk-dp.fab.redhat.com>
References: <4D5A6EF4.3030905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5A6EF4.3030905@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 15, 2011 at 01:17:56PM +0100, Milan Broz wrote:
>         fd =3D open(device, O_RDWR | flags);
>         if (fd =3D=3D -1 && errno =3D=3D EROFS) {
>                 *readonly =3D 1;
>                 fd =3D open(device, O_RDONLY | flags);
>         }

Would it be reasonable for your patch to return EROFS rather than
EACCES?

man 2 open:
       int open(const char *pathname, int flags, mode_t mode);

       EROFS  pathname  refers  to a file on a read-only file system an=
d write
              access was requested.

       EACCES The requested access to the file is not allowed, or searc=
h  per=E2=80=90
              mission  is denied for one of the directories in the path=
 prefix
              of pathname, or the file did not exist yet and write  acc=
ess  to
              the  parent  directory  is  not allowed.  (See also path_=
resolu=E2=80=90
              tion(7).)

Alasdair

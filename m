From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH UPDATED 1/5] mtd: fix bdev exclusive open bugs in
 block2mtd::add_device()
Date: Sat, 13 Nov 2010 13:14:25 +0200
Message-ID: <1289646865.2218.27.camel@localhost>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
	 <1288628129-12811-2-git-send-email-tj@kernel.org>
	 <4CDE6FAA.9030605@kernel.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <4CDE6FAA.9030605@kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-mtd@lists.infradead.org
List-Id: dm-devel.ids

On Sat, 2010-11-13 at 11:59 +0100, Tejun Heo wrote:
> There are two bdev exclusive open bugs.
>=20
> * open_bdev_exclusive() must not be called with NULL holder.  Use dev
>   as the holder.
>=20
> * open_by_devnum() doesn't open the bdev exclusively but
>   block2mtd_free_device() always assumes it.  Explicitly claim the
>   bdev.
>=20
> The latter is rather clumsy but will be simplified with future
> blkdev_get/put() cleanups.
>=20
> - Updated to use local variable @mode to cache FMODE_* masks as
>   suggested by Artem Bityutskiy.

Do you want this patch to go in via Jens' tree with the rest of the
series, or as an independent patch via the mtd tree?

Anyway,

Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Thanks!

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)

--
To unsubscribe from this list: send the line "unsubscribe reiserfs-deve=
l" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

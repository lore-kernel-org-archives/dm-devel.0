From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 1/5] mtd: fix bdev exclusive open bugs in
 block2mtd::add_device()
Date: Sat, 13 Nov 2010 12:38:55 +0200
Message-ID: <1289644735.2218.8.camel@localhost>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
	 <1288628129-12811-2-git-send-email-tj@kernel.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1288628129-12811-2-git-send-email-tj@kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-mtd@lists.infradead.org
List-Id: dm-devel.ids

Hi,

On Mon, 2010-11-01 at 17:15 +0100, Tejun Heo wrote:
> +			if (!IS_ERR(bdev)) {
> +				int ret;
> +				ret =3D bd_claim(bdev, dev);
> +				if (ret) {
> +					blkdev_put(bdev,
> +						   FMODE_READ | FMODE_WRITE);

Would be a bit cleaner to define ea temporary variable:

fmode_t mode =3D FMODE_READ | FMODE_WRITE;

Would you to re-send with this little change please?

And ideally, 2 independent patches would be nicer because you fix 2
independent issues.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)

--
To unsubscribe from this list: send the line "unsubscribe reiserfs-deve=
l" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

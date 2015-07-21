From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH] block: add a bi_error field to struct bio
Date: Tue, 21 Jul 2015 10:19:08 +0200
Message-ID: <55AE007C.9030807@suse.de>
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437398977-8492-2-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On 07/20/2015 03:29 PM, Christoph Hellwig wrote:
> Currently we have two different ways to signal an I/O error on a BIO:
>=20
>  (1) by clearing the BIO_UPTODATE flag
>  (2) by returning a Linux errno value to the bi_end_io callback
>=20
> The first one has the drawback of only communicating a single possibl=
e
> error (-EIO), and the second one has the drawback of not beeing persi=
stent
> when bios are queued up, and are not passed along from child to paren=
t
> bio in the ever more popular chaining scenario.  Having both mechanis=
ms
> available has the additional drawback of utterly confusing driver aut=
hors
> and introducing bugs where various I/O submitters only deal with one =
of
> them, and the others have to add boilerplate code to deal with both k=
inds
> of error returns.
>=20
> So add a new bi_error field to store an errno value directly in struc=
t
> bio and remove the existing mechanisms to clean all this up.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
Very good improvement.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

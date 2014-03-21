From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for open firmware
 SSDs
Date: Fri, 21 Mar 2014 11:09:42 -0400
Message-ID: <20140321150942.GA29731@redhat.com>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
 <1395383538-18019-2-git-send-email-m@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1395383538-18019-2-git-send-email-m@bjorling.me>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Cc: agk@redhat.com, dm-devel@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Mar 21 2014 at  2:32am -0400,
Matias Bj=F8rling <m@bjorling.me> wrote:

> LightNVM implements the internal logic of an SSD within the host syst=
em.
> This includes logic such as translation tables for logical to physica=
l
> address translation, garbage collection and wear-leveling.
>=20
> It is designed to be used either standalone or with a LightNVM
> compatible firmware. If used standalone, NVM memory can be simulated
> by passing timings to the dm target table. If used with a LightNVM
> compatible device, the device will be queued upon initialized for the
> relevant values.
>=20
> The last part is still in progress and a fully working prototype will=
 be
> presented in upcoming patches.
>=20
> Contributions to make this possible by the following people:
>=20
> Aviad Zuck <aviadzuc@tau.ac.il>
> Jesper Madsen <jmad@itu.dk>
>=20
> Signed-off-by: Matias Bjorling <m@bjorling.me>
=2E..
> diff --git a/drivers/md/lightnvm/core.c b/drivers/md/lightnvm/core.c
> new file mode 100644
> index 0000000..113fde9
> --- /dev/null
> +++ b/drivers/md/lightnvm/core.c
> @@ -0,0 +1,705 @@
> +#include "lightnvm.h"
> +
> +/* alloc pbd, but also decorate it with bio */
> +static struct per_bio_data *alloc_init_pbd(struct nvmd *nvmd, struct=
 bio *bio)
> +{
> +	struct per_bio_data *pb =3D mempool_alloc(nvmd->per_bio_pool, GFP_N=
OIO);
> +
> +	if (!pb) {
> +		DMERR("Couldn't allocate per_bio_data");
> +		return NULL;
> +	}
> +
> +	pb->bi_end_io =3D bio->bi_end_io;
> +	pb->bi_private =3D bio->bi_private;
> +
> +	bio->bi_private =3D pb;
> +
> +	return pb;
> +}
> +
> +static void free_pbd(struct nvmd *nvmd, struct per_bio_data *pb)
> +{
> +	mempool_free(pb, nvmd->per_bio_pool);
> +}
> +
> +/* bio to be stripped from the pbd structure */
> +static void exit_pbd(struct per_bio_data *pb, struct bio *bio)
> +{
> +	bio->bi_private =3D pb->bi_private;
> +	bio->bi_end_io =3D pb->bi_end_io;
> +}
> +

Hi Matias,

This looks like it'll be very interesting!  But I won't have time to do
a proper review of this code for ~1.5 weeks (traveling early next week
and then need to finish some high priority work on dm-thin once I'm
back).

But a couple quick things I noticed:

1) you don't need to roll your own per-bio-data allocation code any
more.  The core block layer provides per_bio_data now.

And the DM targets have been converted to make use of it.  See callers
of dm_per_bio_data() and how the associated targets set
ti->per_bio_data_size

2) Also, if you're chaining bi_end_io (like it appears you're doing)
you'll definitely need to call atomic_inc(&bio->bi_remaining); after yo=
u
restore bio->bi_end_io.  This is a new requirement of the 3.14 kernel
(due to the block core's immutable biovec changes).

Please sort these issues out, re-test on 3.14, and post v2, thanks!
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

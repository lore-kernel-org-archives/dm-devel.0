From: Matias Bjorling <m@bjorling.me>
Subject: Re: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for open firmware
 SSDs
Date: Fri, 21 Mar 2014 08:26:51 -0700
Message-ID: <532C5A3B.9020005@bjorling.me>
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <1395383538-18019-2-git-send-email-m@bjorling.me> <20140321150942.GA29731@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140321150942.GA29731@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: agk@redhat.com, dm-devel@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 03/21/2014 08:09 AM, Mike Snitzer wrote:
> On Fri, Mar 21 2014 at  2:32am -0400,
> Matias Bj=F8rling <m@bjorling.me> wrote:
>=20
>> LightNVM implements the internal logic of an SSD within the host sys=
tem.
>> This includes logic such as translation tables for logical to physic=
al
>> address translation, garbage collection and wear-leveling.
>>
>> It is designed to be used either standalone or with a LightNVM
>> compatible firmware. If used standalone, NVM memory can be simulated
>> by passing timings to the dm target table. If used with a LightNVM
>> compatible device, the device will be queued upon initialized for th=
e
>> relevant values.
>>
>> The last part is still in progress and a fully working prototype wil=
l be
>> presented in upcoming patches.
>>
>> Contributions to make this possible by the following people:
>>
>> Aviad Zuck <aviadzuc@tau.ac.il>
>> Jesper Madsen <jmad@itu.dk>
>>
>> Signed-off-by: Matias Bjorling <m@bjorling.me>
> ...
>> diff --git a/drivers/md/lightnvm/core.c b/drivers/md/lightnvm/core.c
>> new file mode 100644
>> index 0000000..113fde9
>> --- /dev/null
>> +++ b/drivers/md/lightnvm/core.c
>> @@ -0,0 +1,705 @@
>> +#include "lightnvm.h"
>> +
>> +/* alloc pbd, but also decorate it with bio */
>> +static struct per_bio_data *alloc_init_pbd(struct nvmd *nvmd, struc=
t bio *bio)
>> +{
>> +	struct per_bio_data *pb =3D mempool_alloc(nvmd->per_bio_pool, GFP_=
NOIO);
>> +
>> +	if (!pb) {
>> +		DMERR("Couldn't allocate per_bio_data");
>> +		return NULL;
>> +	}
>> +
>> +	pb->bi_end_io =3D bio->bi_end_io;
>> +	pb->bi_private =3D bio->bi_private;
>> +
>> +	bio->bi_private =3D pb;
>> +
>> +	return pb;
>> +}
>> +
>> +static void free_pbd(struct nvmd *nvmd, struct per_bio_data *pb)
>> +{
>> +	mempool_free(pb, nvmd->per_bio_pool);
>> +}
>> +
>> +/* bio to be stripped from the pbd structure */
>> +static void exit_pbd(struct per_bio_data *pb, struct bio *bio)
>> +{
>> +	bio->bi_private =3D pb->bi_private;
>> +	bio->bi_end_io =3D pb->bi_end_io;
>> +}
>> +
>=20
> Hi Matias,
>=20
> This looks like it'll be very interesting!  But I won't have time to =
do
> a proper review of this code for ~1.5 weeks (traveling early next wee=
k
> and then need to finish some high priority work on dm-thin once I'm
> back).

That's great.

>=20
> But a couple quick things I noticed:
>=20
> 1) you don't need to roll your own per-bio-data allocation code any
> more.  The core block layer provides per_bio_data now.
>=20
> And the DM targets have been converted to make use of it.  See caller=
s
> of dm_per_bio_data() and how the associated targets set
> ti->per_bio_data_size
>=20
> 2) Also, if you're chaining bi_end_io (like it appears you're doing)
> you'll definitely need to call atomic_inc(&bio->bi_remaining); after =
you
> restore bio->bi_end_io.  This is a new requirement of the 3.14 kernel
> (due to the block core's immutable biovec changes).
>=20
> Please sort these issues out, re-test on 3.14, and post v2, thanks!
> Mike
>=20

Thanks. I'll get it fixed and rebasedk/tested on 3.14.

Matias

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Faccini, Bruno" <bruno.faccini@intel.com>
Subject: Re: [PATCH] md: submit MMP reads REQ_SYNC to bypass
 RAID5 cache
Date: Tue, 4 Nov 2014 08:21:10 +0000
Message-ID: <5C63781B-C556-4104-934A-8083976A4373@intel.com>
References: <CAOdCWHxeE47jwjJvyWOoHdjZ4LaDFQiZZbGpqdLZzd+PjzpyRw@mail.gmail.com>
	<20141104090436.355a8fb1@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141104090436.355a8fb1@notabene.brown>
Content-Language: en-US
Content-ID: <A7CECF5FD1F677448E731CF98482064F@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: James Simmons <uja.ornl@gmail.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Dilger,
	Andreas" <andreas.dilger@intel.com>
List-Id: dm-devel.ids

Hello Neil,
Thanks for your quick answer and pointing us to the reconstruct case we nee=
d to handle!
If I correctly understand you, we need to also clear the UPTODATE flag for =
all the other blocks sharing the same parity information, right ?
Concerning your remark about using a block device like a semaphore not bein=
g 100% safe, my understanding is that this can be achieved by the appropria=
te MMP feature algorithm=85
Bruno.

Le Nov 3, 2014 =E0 23:04, NeilBrown <neilb@suse.de> a =E9crit :

> On Mon, 3 Nov 2014 14:01:10 -0700 James Simmons <uja.ornl@gmail.com> wrot=
e:
> =

>> Hello.
>> =

>>   This is a patch against the latest kernel source which is based on
>> a patch used by Lustre. The below describes what we are trying to
>> achieve. I like to get a feedback if this is the right approach.
>> =

>> ----------------------------------------------------------------------
>> =

>> The ext4 MMP block reads always need to get fresh data from the
>> underlying disk.  Otherwise, if a remote node is updating the MMP
>> block and the reads are fetched from the MD RAID5 stripe cache,
>> it is possible that the local node will incorrectly decide the
>> remote node has died and allow the filesystem to be mounted on
>> two nodes at the same time.
> =

> It is preferred for patches to be inline, rather than as attachments, as =
it
> makes it easier to comment on them....
> =

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9c66e59..11b749c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2678,6 +2678,9 @@ static int add_stripe_bio(struct stripe_head *sh, s=
truct bio *bi, int dd_idx, in
> 		}
> 		if (sector >=3D sh->dev[dd_idx].sector + STRIPE_SECTORS)
> 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
> +	} else if (bi->bi_rw & REQ_NOCACHE) {
> +		/* force to read from underlying disk if requested */
> +		clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
> 	}
> =

> 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> =

> =

> This doesn't provide a useful guarantee.  If the device that stores that
> block has failed, the md/raid5 will read all other devices to recover the
> block.
> If that recently happened and you just clear the UPTODATE bit on the bloc=
k,
> md/raid5 will recover the data from all the other blocks, without reading
> them.
> =

> But considering this at a higher level: if two different nodes try to
> assemble the same RAID5 array then you already potentially have a problem.
> You really want some sensible cluster co-ordinator and let it make these
> decisions.   Hoping the a block device can be a reliable semaphore seems =
...
> misguided.
> =

> NeilBrown

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, =

92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

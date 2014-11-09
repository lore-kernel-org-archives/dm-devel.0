From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH] Suspend all active bios when the pool is
 suspended (was: staged dm_internal_{suspend,
 resume} related changes for wider review)
Date: Sat, 8 Nov 2014 20:17:25 -0500
Message-ID: <CAMM=eLf31KfyreOiRWeQQopo+gJbeJV1KAdSX=qff7EFts-UNw@mail.gmail.com>
References: <20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105162912.GA17625@redhat.com>
	<alpine.LRH.2.02.1411071047430.21255@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411071804030.8597@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1411071804030.8597@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: ejt@redhat.com, "Bryn M. Reeves" <breeves@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 7, 2014 at 6:16 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Fri, 7 Nov 2014, Mikulas Patocka wrote:
>
>> For reasons 1 and 2, I wouldn't really deal with "thin" targets at all -
>> they may be created or deleted independent on pool status. Instead, we
>> should block all active bios inside the pool - the bios are already
>> registered in dm_deferred_set or in the prison, so all you need to do is
>> to set a flag pool's presuspend method that causes all new bios to be
>> queues and the wait until the prison is empty and the counters in
>> deferred_set reach zero.
>
> Here I'm sending a proof-of-concept patch that makes it possible to
> prevent bios from coming into the thin pool when the pool is suspended. It
> doesn't modify any generic dm code.
>
> This patch may not be perfect (I don't know all bio paths in dm-thin in
> detail, so I may have missed something), but it shows that it is possible
> to suspend all bios without modifying the common dm code. I hope Joe
> reviewes it and possibly fixes it.
>
> The patch is for 3.18-rc3, it needs other thin patches, the full patch
> series is at
> http://people.redhat.com/~mpatocka/patches/kernel/dm-thin-suspend/series.html
>
> Mikulas
>
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/md/dm-bio-prison.c |   29 +++++++++++++++++++++++++++
>  drivers/md/dm-bio-prison.h |    3 ++
>  drivers/md/dm-thin.c       |   47 +++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 75 insertions(+), 4 deletions(-)
>
> Index: linux-2.6/drivers/md/dm-thin.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-thin.c 2014-11-08 00:02:42.000000000 +0100
> +++ linux-2.6/drivers/md/dm-thin.c      2014-11-08 00:02:42.000000000 +0100
> @@ -194,6 +194,8 @@ struct pool {
>         struct dm_thin_new_mapping *next_mapping;
>         mempool_t *mapping_pool;
>
> +       atomic_t suspended;
> +
>         process_bio_fn process_bio;
>         process_bio_fn process_discard;
>

I'm not seeing how using an unprotected atomic_t is thread-safe
considering both the thin-pool and thin targets will be accessing it
concurrently.

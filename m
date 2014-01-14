From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/6] dm-snapshot: use bufio prefetch
Date: Tue, 14 Jan 2014 11:58:40 -0500
Message-ID: <20140114165840.GA10687@redhat.com>
References: <alpine.LRH.2.02.1401131911570.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131912480.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131913090.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131913420.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131914080.30362@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401131914270.30362@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401131914270.30362@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 13 2014 at  7:14pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> This patch modifies dm-snapshot so that it prefetches the buffers when
> loading the exceptions.
> 
> The number of buffers read ahead is specified in the DM_PREFETCH_CHUNKS
> macro.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-snap-persistent.c |   22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> Index: linux-3.13-rc7/drivers/md/dm-snap-persistent.c
> ===================================================================
> --- linux-3.13-rc7.orig/drivers/md/dm-snap-persistent.c	2014-01-14 00:54:52.000000000 +0100
> +++ linux-3.13-rc7/drivers/md/dm-snap-persistent.c	2014-01-14 00:56:39.000000000 +0100
> @@ -18,6 +18,8 @@
>  #define DM_MSG_PREFIX "persistent snapshot"
>  #define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
>  
> +#define DM_PREFETCH_CHUNKS		12
> +
>  /*-----------------------------------------------------------------
>   * Persistent snapshots, by persistent we mean that the snapshot
>   * will survive a reboot.
...
> @@ -504,6 +507,8 @@ static int read_exceptions(struct pstore
>  	if (IS_ERR(client))
>  		return PTR_ERR(client);
>  
> +	dm_bufio_set_minimum_buffers(client, DM_PREFETCH_CHUNKS + 1);
> +

Why the +1?  I'd prefer that be managed in dm-bufio rather than relying
on all callers to know to add +1.

Can you supply a followup patch that cleans this up in bufio and remove
the +1 in the above dm_bufio_set_minimum_buffers call?

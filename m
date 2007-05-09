From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Date: Tue, 8 May 2007 17:41:59 -0700
Message-ID: <20070508174159.7d78a275.akpm@linux-foundation.org>
References: <20070508194845.GC24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070508194845.GC24114@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

On Tue, 8 May 2007 20:48:45 +0100
Alasdair G Kergon <agk@redhat.com> wrote:

> +#define BIO_LIST_INIT { .head = NULL, .tail = NULL }
> +
> +#define BIO_LIST(bl) \
> +	struct bio_list bl = BIO_LIST_INIT

BIO_LIST is a strange name for something which initialises storage.

>  static inline void bio_list_init(struct bio_list *bl)
>  {
>  	bl->head = bl->tail = NULL;
>  }
>  
> +#define bio_list_for_each(bio, bl) \
> +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
> +	     bio = bio->bi_next)
> +

I have this vague memory from a long time ago that one particular CPU type
wants to go oops when prefetching from an invalid address.

Maybe that went away for some reason - we'd have hit it again if it was
real.

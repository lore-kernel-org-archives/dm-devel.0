From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Bcache v14 PATCH] fix compiler error
Date: Mon, 23 Jul 2012 14:12:12 -0700
Message-ID: <20120723211212.GA29052@google.com>
References: <1abe2159-2201-46c4-9c60-afc4f358ff6a@mail.eladian.com>
 <0d1ae163-7cde-4a78-852a-04fba827249f@mail.eladian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0d1ae163-7cde-4a78-852a-04fba827249f@mail.eladian.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Wisehart <daniel.wisehart@eladian.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 19, 2012 at 04:53:26PM -0400, Daniel Wisehart wrote:
> Hello Kent, 
> 
> This patch keeps gcc 4.7.0 happy.  The static function dump_bset() could be moved, but that would have made a bigger patch.  :-)

Thanks! dump_bset() does need to be moved so it's available if DEBUG or
EDEBUG are on, but thanks for pointing it out :)

> 
> Thanks,
> Daniel
> 
> 
> 
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index 3c9c24d..4dc0ba5 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -83,6 +83,8 @@ struct keyprint_hack bch_pbtree(const struct btree *b)
>  
>  #ifdef CONFIG_BCACHE_DEBUG
>  
> +static void dump_bset(struct btree *b, struct bset *i);
> +
>  void bch_btree_verify(struct btree *b, struct bset *new)
>  {
>         struct btree *v = b->c->verify_data;
> 
> 
> This communication is restricted - please see http://www.eladian.com for further information.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

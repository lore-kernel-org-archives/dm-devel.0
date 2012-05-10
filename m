From: Joe Perches <joe@perches.com>
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Date: Thu, 10 May 2012 11:49:47 -0700
Message-ID: <1336675787.22495.29.camel@joe2Laptop>
References: <cover.1336619038.git.koverstreet@google.com>
	 <1188908028.170.1336674698865.JavaMail.mail@webmail09>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1188908028.170.1336674698865.JavaMail.mail@webmail09>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tejun@google.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, 2012-05-09 at 23:10 -0400, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
[]
> +
> +void btree_read_done(struct closure *cl)
> +{
[]
> +	if (b->written < btree_blocks(b))
> +		bset_init_next(b);
> +
> +	if (0) {
> +err:		set_btree_node_io_error(b);
> +		cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
> +				err, PTR_BUCKET_NR(b->c, &b->key, 0),
> +				index(i, b), i->keys);
> +	}

Hi Kent

trivia:  This if (0) is an exceedingly ugly style.

I'd much prefer:

	if (foo)
		bar();

	goto exit;

err:
	set_btree_node_io_error(b);
	cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
			err, PTR_BUCKET_NR(b->c, &b->key, 0),
			index(i, b), i->keys);

exit:
	etc...

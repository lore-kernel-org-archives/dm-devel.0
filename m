Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3342BC6FD1C
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679686460;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/PPkn84CwB2IZpoIyMFxjFrexft+GW+0pJketpAC6vs=;
	b=jKduZ6inSL6JEmkkXFN8sNE4xtElOjNCmdUp01emfLR8ekEE7gtfW75buQDtY6IzkWSs2P
	OkRIie0IINREphSiQr5PZ/QtMbYUPT3/TKACLgDYld2uXrT7CtTg+Pw9rS0m9GJ7JlXiqe
	KxZdrhsa0AGQjcLecamA1Z5r1aru2Ds=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-4ve6t5TMMwGoYPGDlBzlNw-1; Fri, 24 Mar 2023 15:34:17 -0400
X-MC-Unique: 4ve6t5TMMwGoYPGDlBzlNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A8A285A5A3;
	Fri, 24 Mar 2023 19:34:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A8F61415117;
	Fri, 24 Mar 2023 19:34:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B46A21946A5E;
	Fri, 24 Mar 2023 19:34:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B47F1946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 19:34:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C3C31401307; Fri, 24 Mar 2023 19:34:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2413C1402C0A
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 19:34:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D58563813F59
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 19:34:06 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-V7nVW4XsMZ2laTgG55Zj3g-1; Fri, 24 Mar 2023 15:34:04 -0400
X-MC-Unique: V7nVW4XsMZ2laTgG55Zj3g-1
Received: by mail-pl1-f171.google.com with SMTP id k2so2774233pll.8
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 12:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679686443; x=1682278443;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=tYrfAQikbBmkLE7eU5XiXBh3MQ6TnxCe16WKSEluc3w=;
 b=nbdjbqUVNQUZvqiNGHhUuVlzW2/rD9ZpNRoLdjxOWIZKVOG9eHW3q4baUT2posHS2t
 WeAfYV/XfS/Max8qfrGB+2E47WnTTkTbe5SPnRizJp6tKrVsERwPZy4AKmiiAPhQ/MFo
 656BYN4f1jlUFcB0DKQ1mRc6yyIMB76bvhqsngikA2hzcbTpzE67DaOkveWB1a8Jda2w
 rcJNujnmOljw1zejXenaPHvnECtRGZ/JapG4Z9WOV8HveIJZ1H9bA+OoUKhpp6CV5CVf
 1cJlbf9cHt2IEIqkTtEfHP2ZXYZItqyexSkiCs3NrwS44YBucHobJ3Bgmt+QOGExQwVQ
 abiw==
X-Gm-Message-State: AO0yUKVNvzYvvp1r8FSXEaZNHCyeaQEykF4f6FDREyuRjI3wB6PVKCx1
 PFDfHW9H/HCePD2phb62bPKS5w==
X-Google-Smtp-Source: AK7set8YGYKAmMwEkZNOvgX1mYxJ077W31nLG9NORYPv3TdPjKxZaFqN8bvsHIKCn/brw5jfKGoxqg==
X-Received: by 2002:a05:6a20:914b:b0:dc:e387:566b with SMTP id
 x11-20020a056a20914b00b000dce387566bmr3332058pzc.1.1679686443371; 
 Fri, 24 Mar 2023 12:34:03 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 v19-20020aa78513000000b0062a575b1497sm2767740pfn.26.2023.03.24.12.34.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Mar 2023 12:34:02 -0700 (PDT)
Message-ID: <a1b8ceb8-0a67-86a1-2222-1625f6ebbe33@kernel.dk>
Date: Fri, 24 Mar 2023 13:34:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com
References: <20230324175656.85082-1-snitzer@kernel.org>
 <20230324175656.85082-4-snitzer@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230324175656.85082-4-snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [dm-6.4 PATCH v2 3/9] dm bufio: improve concurrent
 IO performance
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 nhuck@google.com, linux-block@vger.kernel.org, ejt@redhat.com,
 mpatocka@redhat.com, luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Just some random drive-by comments.

> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 1de1bdcda1ce..a58f8ac3ba75 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> +static void lru_destroy(struct lru *lru)
> +{
> +	BUG_ON(lru->cursor);
> +	BUG_ON(!list_empty(&lru->iterators));
> +}

Ehm no, WARN_ON_ONCE() for these presumably.

> +/*
> + * Insert a new entry into the lru.
> + */
> +static void lru_insert(struct lru *lru, struct lru_entry *le)
> +{
> +	/*
> +	 * Don't be tempted to set to 1, makes the lru aspect
> +	 * perform poorly.
> +	 */
> +	atomic_set(&le->referenced, 0);
> +
> +	if (lru->cursor)
> +		list_add_tail(&le->list, lru->cursor);
> +
> +	else {
> +		INIT_LIST_HEAD(&le->list);
> +		lru->cursor = &le->list;
> +	}

Extra empty line, and missing braces on the first line.

> +static inline struct lru_entry *to_le(struct list_head *l)
> +{
> +	return container_of(l, struct lru_entry, list);
> +}

Useless helper.

> +/*
> + * Remove an lru_iter from the list of cursors in the lru.
> + */
> +static void lru_iter_end(struct lru_iter *it)
> +{
> +	list_del(&it->list);
> +}

Ditto

> +/*
> + * Remove a specific entry from the lru.
> + */
> +static void lru_remove(struct lru *lru, struct lru_entry *le)
> +{
> +	lru_iter_invalidate(lru, le);
> +	if (lru->count == 1)
> +		lru->cursor = NULL;
> +	else {
> +		if (lru->cursor == &le->list)
> +			lru->cursor = lru->cursor->next;
> +		list_del(&le->list);
> +	}
> +	lru->count--;
> +}

Style again, be consistent with braces.

> +static struct lru_entry *lru_evict(struct lru *lru, le_predicate pred, void *context)
> +{
> +	unsigned long tested = 0;
> +	struct list_head *h = lru->cursor;
> +	struct lru_entry *le;
> +
> +	if (!h)
> +		return NULL;
> +	/*
> +	 * In the worst case we have to loop around twice. Once to clear
> +	 * the reference flags, and then again to discover the predicate
> +	 * fails for all entries.
> +	 */
> +	while (tested < lru->count) {
> +		le = container_of(h, struct lru_entry, list);
> +
> +		if (atomic_read(&le->referenced))
> +			atomic_set(&le->referenced, 0);
> +		else {
> +			tested++;
> +			switch (pred(le, context)) {
> +			case ER_EVICT:
> +				/*
> +				 * Adjust the cursor, so we start the next
> +				 * search from here.
> +				 */
> +				lru->cursor = le->list.next;
> +				lru_remove(lru, le);
> +				return le;
> +
> +			case ER_DONT_EVICT:
> +				break;
> +
> +			case ER_STOP:
> +				lru->cursor = le->list.next;
> +				return NULL;
> +			}
> +		}

Again bad bracing.

> @@ -116,9 +366,579 @@ struct dm_buffer {
>  #endif
>  };
>  
> +/*--------------------------------------------------------------*/
> +
> +/*
> + * The buffer cache manages buffers, particularly:
> + *  - inc/dec of holder count
> + *  - setting the last_accessed field
> + *  - maintains clean/dirty state along with lru
> + *  - selecting buffers that match predicates
> + *
> + * It does *not* handle:
> + *  - allocation/freeing of buffers.
> + *  - IO
> + *  - Eviction or cache sizing.
> + *
> + * cache_get() and cache_put() are threadsafe, you do not need to
> + * protect these calls with a surrounding mutex.  All the other
> + * methods are not threadsafe; they do use locking primitives, but
> + * only enough to ensure get/put are threadsafe.
> + */
> +
> +#define NR_LOCKS 64
> +#define LOCKS_MASK (NR_LOCKS - 1)
> +
> +struct tree_lock {
> +	struct rw_semaphore lock;
> +} ____cacheline_aligned_in_smp;
> +
> +struct dm_buffer_cache {
> +	/*
> +	 * We spread entries across multiple trees to reduce contention
> +	 * on the locks.
> +	 */
> +	struct tree_lock locks[NR_LOCKS];
> +	struct rb_root roots[NR_LOCKS];
> +	struct lru lru[LIST_SIZE];
> +};

This:

struct foo_tree {
	struct rw_semaphore lock;
	struct rb_root root;
	struct lru lru;
} ____cacheline_aligned_in_smp;

would be a lot better.

And where does this NR_LOCKS come from? Don't make up magic values out
of thin air. Should this be per-cpu? per-node? N per node? I'll bet you
that 64 is way too much for most use cases, and too little for others.

> +static bool cache_insert(struct dm_buffer_cache *bc, struct dm_buffer *b)
> +{
> +	bool r;
> +
> +	BUG_ON(b->list_mode >= LIST_SIZE);
> +
> +	cache_write_lock(bc, b->block);
> +	BUG_ON(atomic_read(&b->hold_count) != 1);
> +	r = __cache_insert(&bc->roots[cache_index(b->block)], b);
> +	if (r)
> +		lru_insert(&bc->lru[b->list_mode], &b->lru);
> +	cache_write_unlock(bc, b->block);
> +
> +	return r;
> +}

Again, not BUG_ON's.

> +/*
> + * Removes buffer from cache, ownership of the buffer passes back to the caller.
> + * Fails if the hold_count is not one (ie. the caller holds the only reference).
> + *
> + * Not threadsafe.
> + */
> +static bool cache_remove(struct dm_buffer_cache *bc, struct dm_buffer *b)
> +{
> +	bool r;
> +
> +	cache_write_lock(bc, b->block);
> +
> +	if (atomic_read(&b->hold_count) != 1)
> +		r = false;
> +
> +	else {
> +		r = true;
> +		rb_erase(&b->node, &bc->roots[cache_index(b->block)]);
> +		lru_remove(&bc->lru[b->list_mode], &b->lru);
> +	}
> +
> +	cache_write_unlock(bc, b->block);
> +
> +	return r;
> +}

Braces again.

> +static struct dm_buffer *__find_next(struct rb_root *root, sector_t block)
> +{
> +	struct rb_node *n = root->rb_node;
> +	struct dm_buffer *b;
> +	struct dm_buffer *best = NULL;
> +
> +	while (n) {
> +		b = container_of(n, struct dm_buffer, node);
> +
> +		if (b->block == block)
> +			return b;
> +
> +		if (block <= b->block) {
> +			n = n->rb_left;
> +			best = b;
> +		} else
> +			n = n->rb_right;
> +	}

And again.

> @@ -1141,7 +1904,6 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
>  	}
>  
>  	*bp = b;
> -
>  	return b->data;
>  }
>  

Unrelated change. There are a bunch of these.

I stopped reading here, the patch is just too long. Surely this could be
split up?

 1 file changed, 1292 insertions(+), 477 deletions(-)

That's not a patch, that's a patch series.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


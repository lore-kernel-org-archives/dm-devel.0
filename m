Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F97C6FD1D
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 08:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679558516;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=8WkRCVEbusb/mOGd1JHkGZhuDME3ST/b5i/NWzNvrlw=;
	b=PDzWJmLfaYPiwsTAiJC7I/bqtELi3n7kmaUhMgRIADViwyJPppk0axVN4xAylUwo14/QFG
	bxTEEf1h4MZNRiN10HsJeMjUi7MwrTq5HCHSogiAw4avWuGA9PS1G5BRzr5vyyxPOAjxw9
	cY/+hGESFlY+opZfzSGs1xJq2fg1gNs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-yuCMxyX7OxmWfTDPNkzbrA-1; Thu, 23 Mar 2023 04:01:52 -0400
X-MC-Unique: yuCMxyX7OxmWfTDPNkzbrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2C751C0514D;
	Thu, 23 Mar 2023 08:01:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5FF140C6E67;
	Thu, 23 Mar 2023 08:01:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B72BD1946589;
	Thu, 23 Mar 2023 08:01:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DC6F1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 07:51:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1A7821121318; Thu, 23 Mar 2023 07:51:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F5861121314
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 07:51:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE995885620
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 07:51:51 +0000 (UTC)
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-Y0bUEFKQNtOFjotRbrWFqw-1; Thu, 23 Mar 2023 03:51:50 -0400
X-MC-Unique: Y0bUEFKQNtOFjotRbrWFqw-1
Received: by mail-yw1-f199.google.com with SMTP id
 00721157ae682-541888850d4so215454107b3.21
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 00:51:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679557909;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=+M7vpjUlP8WI+QC6FUHVHCdO413eBZw6kVe9kqqy+B8=;
 b=js7XiICkw2SmkEa1QgrKD84IaLziWLTYXAaReUVXDg7Cak7sutpwH08aFQM2xRei01
 L3HU1p4MjeqAfZAWLF0uNd6dwn0KsM5qgInLZJzWaoAKQeWQTNxo9QmIZmDdx5c9cENd
 hDr81LGzl0MpfCnPy4bxs/PyhGDr1zaPXUNNX139khnqYNQ+A+IVg0GDXWA2OJqr9ARu
 dpqUO+3pX7RH49H7ZtexfoG0wnkjw7xWwrXwZc3/3eCNZ6q2ELehPaLGmdWRwkO3fE7M
 flDBETjvBSPCU1NMhfch52WmDTAzB5NCULhIv5+fP4hq+ehYdzz6FnUyBS6CUOJFOnVw
 dPBg==
X-Gm-Message-State: AAQBX9dil9fyVW+fSmR9uz8mzO078qi6Q6YM0YnHoZkAsmQs7dNqDK2c
 Yc9DeoH81Gd6ZYDIOTnLZFJ8tHZ4DbGk85NClwgHgjtR9wo+yDiohjVwU47/zMBEFyNFuvelnYb
 TWRaztXkr7RCm51Hd5tiGOO/C/2coB0Y=
X-Received: by 2002:a81:b601:0:b0:544:94fe:4244 with SMTP id
 u1-20020a81b601000000b0054494fe4244mr1390138ywh.10.1679557909010; 
 Thu, 23 Mar 2023 00:51:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZhQq/wr+T6SnjBu/MOJV4sZINXtWrFRWm0r+7ma7wjIUOEA00riXzHvhehH2IWY4wt3lt/j8t/z5M/uNKf61s=
X-Received: by 2002:a81:b601:0:b0:544:94fe:4244 with SMTP id
 u1-20020a81b601000000b0054494fe4244mr1390122ywh.10.1679557908401; Thu, 23 Mar
 2023 00:51:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230322181845.29848-1-snitzer@kernel.org>
 <20230322181845.29848-6-snitzer@kernel.org>
In-Reply-To: <20230322181845.29848-6-snitzer@kernel.org>
From: Joe Thornber <thornber@redhat.com>
Date: Thu, 23 Mar 2023 07:51:37 +0000
Message-ID: <CAJ0trDbFi0U+nJMkqi8Z9WDwWoAUO0qFMRyY5d7qxUU4mwpgzQ@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 23 Mar 2023 08:01:48 +0000
Subject: Re: [dm-devel] [dm-6.4 PATCH 5/8] dm bufio: improve concurrent IO
 performance
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
Cc: keescook@chromium.org, heinzm@redhat.com, ejt@redhat.com, nhuck@google.com,
 ebiggers@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============7729970695029172636=="

--===============7729970695029172636==
Content-Type: multipart/alternative; boundary="00000000000082a23b05f78c8ce8"

--00000000000082a23b05f78c8ce8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Mike,

I'm Nacking this patch here.  You've taken the comment from my latest
patch, and attached it to something else.  I don't know if you've taken an
older patch and updated it, or taken the latest patch and downgraded it.

For instance the latest patch uses the name 'struct dm_buffer_cache', but
it looks like you've renamed to 'struct buffer_cache' and then posted
another patch in the series that renames back to dm_buffer_cache.

I also see the comment change:

original "A refcount_t for hold_count does not work." which has changed to
"NOTE: attempting to use refcount_t instead of atomic_t caused crashes!".
Talk about over dramatisation (If the hold_count is incorrect we detect and
BUG).

I can't stand by my code if I don't know what's being sent up in my name.

Please use the patchset from this branch:
https://github.com/jthornber/linux/tree/2023-03-21-thin-concurrency-8

- Joe



On Wed, Mar 22, 2023 at 6:19=E2=80=AFPM Mike Snitzer <snitzer@kernel.org> w=
rote:

> From: Joe Thornber <ejt@redhat.com>
>
> When multiple threads perform IO to a thin device, the underlying
> dm_bufio object can become a bottleneck; slowing down access to btree
> nodes that store the thin metadata. Prior to this commit, each bufio
> instance had a single mutex that was taken for every bufio operation.
>
> This commit concentrates on improving the common case: in which a user
> of dm_bufio wishes to access, but not modify, a buffer which is already
> within the dm_bufio cache.
>
> Implementation::
>
>   The code has been refactored; pulling out an 'lru' abstraction and a
>   'buffer cache' abstraction.
>
>  LRU:
>   A clock algorithm is used in the LRU abstraction.  This avoids
>   relinking list nodes, which would require a write lock protecting
>   it.
>
>   None of the lru methods are threadsafe; locking must be done at a
>   higher level.
>
>  Buffer cache:
>   The buffer cache is responsible for managing the holder count,
>   tracking clean/dirty state, and choosing buffers via predicates.
>   Higher level code is responsible for allocation of buffers, IO and
>   eviction/cache sizing.
>
>   The buffer cache has thread safe methods for acquiring a reference
>   to an existing buffer. All other methods in buffer cache are _not_
>   threadsafe, and only contain enough locking to guarantee the safe
>   methods.
>
>   Rather than a single mutex, sharded rw_semaphores are used to allow
>   concurrent threads to 'get' buffers. Each rw_semaphore protects its
>   own rbtree of buffer entries.
>
> Testing::
>
>   Some of the low level functions have been unit tested using dm-unit:
>     https://github.com/jthornber/dm-unit/blob/main/src/tests/bufio.rs
>
>   Higher level concurrency and IO is tested via a test only target
>   found here:
>
> https://github.com/jthornber/linux/blob/2023-02-28-thin-concurrency-7/dri=
vers/md/dm-bufio-test.c
>
>   The associated userland side of these tests is here:
>
> https://github.com/jthornber/dmtest-python/blob/main/src/dmtest/bufio/buf=
io_tests.py
>
>   In addition the full dmtest suite of tests (dm-thin, dm-cache, etc)
>   has been run (~450 tests).
>
> Performance::
>
>   Most bufio operations have unchanged performance. But if multiple
>   threads are attempting to get buffers concurrently, and these
>   buffers are already in the cache then there's a big speed up. Eg,
>   one test has 16 'hotspot' threads simulating btree lookups while
>   another thread dirties the whole device. In this case the hotspot
>   threads acquire the buffers about 25 times faster.
>
> Signed-off-by: Joe Thornber <ejt@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm-bufio.c | 1769 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 1292 insertions(+), 477 deletions(-)
>
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 1de1bdcda1ce..56ef160331ce 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -66,6 +66,247 @@
>  #define LIST_DIRTY     1
>  #define LIST_SIZE      2
>
> +/*--------------------------------------------------------------*/
> +
> +/*
> + * Rather than use an LRU list, we use a clock algorithm where entries
> + * are held in a circular list.  When an entry is 'hit' a reference bit
> + * is set.  The least recently used entry is approximated by running a
> + * cursor around the list selecting unreferenced entries. Referenced
> + * entries have their reference bit cleared as the cursor passes them.
> + */
> +struct lru_entry {
> +       struct list_head list;
> +       atomic_t referenced;
> +};
> +
> +struct lru_iter {
> +       struct lru *lru;
> +       struct list_head list;
> +       struct lru_entry *stop;
> +       struct lru_entry *e;
> +};
> +
> +struct lru {
> +       struct list_head *cursor;
> +       unsigned long count;
> +
> +       struct list_head iterators;
> +};
> +
> +/*--------------*/
> +
> +static void lru_init(struct lru *lru)
> +{
> +       lru->cursor =3D NULL;
> +       lru->count =3D 0;
> +       INIT_LIST_HEAD(&lru->iterators);
> +}
> +
> +static void lru_destroy(struct lru *lru)
> +{
> +       BUG_ON(lru->cursor);
> +       BUG_ON(!list_empty(&lru->iterators));
> +}
> +
> +static inline unsigned int lru_count(struct lru *lru)
> +{
> +       return lru->count;
> +}
> +
> +/*
> + * Insert a new entry into the lru.
> + */
> +static void lru_insert(struct lru *lru, struct lru_entry *le)
> +{
> +       /*
> +        * Don't be tempted to set to 1, makes the lru aspect
> +        * perform poorly.
> +        */
> +       atomic_set(&le->referenced, 0);
> +
> +       if (lru->cursor)
> +               list_add_tail(&le->list, lru->cursor);
> +
> +       else {
> +               INIT_LIST_HEAD(&le->list);
> +               lru->cursor =3D &le->list;
> +       }
> +       lru->count++;
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Convert a list_head pointer to an lru_entry pointer.
> + */
> +static inline struct lru_entry *to_le(struct list_head *l)
> +{
> +       return container_of(l, struct lru_entry, list);
> +}
> +
> +/*
> + * Initialize an lru_iter and add it to the list of cursors in the lru.
> + */
> +static void lru_iter_begin(struct lru *lru, struct lru_iter *it)
> +{
> +       it->lru =3D lru;
> +       it->stop =3D lru->cursor ? to_le(lru->cursor->prev) : NULL;
> +       it->e =3D lru->cursor ? to_le(lru->cursor) : NULL;
> +       list_add(&it->list, &lru->iterators);
> +}
> +
> +/*
> + * Remove an lru_iter from the list of cursors in the lru.
> + */
> +static void lru_iter_end(struct lru_iter *it)
> +{
> +       list_del(&it->list);
> +}
> +
> +/* Predicate function type to be used with lru_iter_next */
> +typedef bool (*iter_predicate)(struct lru_entry *le, void *context);
> +
> +/*
> + * Advance the cursor to the next entry that passes the
> + * predicate, and return that entry.  Returns NULL if the
> + * iteration is complete.
> + */
> +static struct lru_entry *lru_iter_next(struct lru_iter *it,
> +                                      iter_predicate pred, void *context=
)
> +{
> +       struct lru_entry *e;
> +
> +       while (it->e) {
> +               e =3D it->e;
> +
> +               /* advance the cursor */
> +               if (it->e =3D=3D it->stop)
> +                       it->e =3D NULL;
> +               else
> +                       it->e =3D to_le(it->e->list.next);
> +
> +               if (pred(e, context))
> +                       return e;
> +       }
> +
> +       return NULL;
> +}
> +
> +/*
> + * Invalidate a specific lru_entry and update all cursors in
> + * the lru accordingly.
> + */
> +static void lru_iter_invalidate(struct lru *lru, struct lru_entry *e)
> +{
> +       struct lru_iter *it;
> +
> +       list_for_each_entry(it, &lru->iterators, list) {
> +               /* Move c->e forwards if necc. */
> +               if (it->e =3D=3D e) {
> +                       it->e =3D to_le(it->e->list.next);
> +                       if (it->e =3D=3D e)
> +                               it->e =3D NULL;
> +               }
> +
> +               /* Move it->stop backwards if necc. */
> +               if (it->stop =3D=3D e) {
> +                       it->stop =3D to_le(it->stop->list.prev);
> +                       if (it->stop =3D=3D e)
> +                               it->stop =3D NULL;
> +               }
> +       }
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Remove a specific entry from the lru.
> + */
> +static void lru_remove(struct lru *lru, struct lru_entry *le)
> +{
> +       lru_iter_invalidate(lru, le);
> +       if (lru->count =3D=3D 1)
> +               lru->cursor =3D NULL;
> +       else {
> +               if (lru->cursor =3D=3D &le->list)
> +                       lru->cursor =3D lru->cursor->next;
> +               list_del(&le->list);
> +       }
> +       lru->count--;
> +}
> +
> +/*
> + * Mark as referenced.
> + */
> +static inline void lru_reference(struct lru_entry *le)
> +{
> +       atomic_set(&le->referenced, 1);
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Remove the least recently used entry (approx), that passes the
> predicate.
> + * Returns NULL on failure.
> + */
> +enum evict_result {
> +       ER_EVICT,
> +       ER_DONT_EVICT,
> +       ER_STOP, /* stop looking for something to evict */
> +};
> +
> +typedef enum evict_result (*le_predicate)(struct lru_entry *le, void
> *context);
> +
> +static struct lru_entry *lru_evict(struct lru *lru, le_predicate pred,
> void *context)
> +{
> +       unsigned int tested =3D 0;
> +       struct list_head *h =3D lru->cursor;
> +       struct lru_entry *le;
> +
> +       if (!h)
> +               return NULL;
> +       /*
> +        * In the worst case we have to loop around twice. Once to clear
> +        * the reference flags, and then again to discover the predicate
> +        * fails for all entries.
> +        */
> +       while (tested < lru->count) {
> +               le =3D container_of(h, struct lru_entry, list);
> +
> +               if (atomic_read(&le->referenced))
> +                       atomic_set(&le->referenced, 0);
> +               else {
> +                       tested++;
> +                       switch (pred(le, context)) {
> +                       case ER_EVICT:
> +                               /*
> +                                * Adjust the cursor, so we start the nex=
t
> +                                * search from here.
> +                                */
> +                               lru->cursor =3D le->list.next;
> +                               lru_remove(lru, le);
> +                               return le;
> +
> +                       case ER_DONT_EVICT:
> +                               break;
> +
> +                       case ER_STOP:
> +                               lru->cursor =3D le->list.next;
> +                               return NULL;
> +                       }
> +               }
> +
> +               h =3D h->next;
> +
> +               cond_resched();
> +       }
> +
> +       return NULL;
> +}
> +
> +/*--------------------------------------------------------------*/
> +
>  /*
>   * Buffer state bits.
>   */
> @@ -86,28 +327,37 @@ enum data_mode {
>  };
>
>  struct dm_buffer {
> +       /* protected by the locks in buffer_cache */
>         struct rb_node node;
> -       struct list_head lru_list;
> -       struct list_head global_list;
>
> +       /* immutable, so don't need protecting */
>         sector_t block;
>         void *data;
>         unsigned char data_mode;                /* DATA_MODE_* */
>
> -       unsigned int accessed;
> -       unsigned int hold_count;
> +       /*
> +        * These two fields are used in isolation, so do not need
> +        * a surrounding lock. NOTE: attempting to use refcount_t
> +        * instead of atomic_t caused crashes!
> +        */
> +       atomic_t hold_count;
>         unsigned long last_accessed;
>
> +       /*
> +        * Everything else is protected by the mutex in
> +        * dm_bufio_client
> +        */
> +       unsigned long state;
> +       struct lru_entry lru;
>         unsigned char list_mode;                /* LIST_* */
>         blk_status_t read_error;
>         blk_status_t write_error;
> -       unsigned long state;
>         unsigned int dirty_start;
>         unsigned int dirty_end;
>         unsigned int write_start;
>         unsigned int write_end;
> -       struct dm_bufio_client *c;
>         struct list_head write_list;
> +       struct dm_bufio_client *c;
>         void (*end_io)(struct dm_buffer *b, blk_status_t bs);
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>  #define MAX_STACK 10
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
> +       struct rw_semaphore lock;
> +} ____cacheline_aligned_in_smp;
> +
> +struct buffer_cache {
> +       /*
> +        * We spread entries across multiple trees to reduce contention
> +        * on the locks.
> +        */
> +       struct tree_lock locks[NR_LOCKS];
> +       struct rb_root roots[NR_LOCKS];
> +       struct lru lru[LIST_SIZE];
> +};
> +
> +/*
> + * We want to scatter the buffers across the different rbtrees
> + * to improve concurrency, but we also want to encourage the
> + * lock_history optimisation (below). Scattering runs of 16
> + * buffers seems to be a good compromise.
> + */
> +static inline unsigned int cache_index(sector_t block)
> +{
> +       return block & LOCKS_MASK;
> +}
> +
> +static inline void cache_read_lock(struct buffer_cache *bc, sector_t
> block)
> +{
> +       down_read(&bc->locks[cache_index(block)].lock);
> +}
> +
> +static inline void cache_read_unlock(struct buffer_cache *bc, sector_t
> block)
> +{
> +       up_read(&bc->locks[cache_index(block)].lock);
> +}
> +
> +static inline void cache_write_lock(struct buffer_cache *bc, sector_t
> block)
> +{
> +       down_write(&bc->locks[cache_index(block)].lock);
> +}
> +
> +static inline void cache_write_unlock(struct buffer_cache *bc, sector_t
> block)
> +{
> +       up_write(&bc->locks[cache_index(block)].lock);
> +}
> +
> +/*
> + * Sometimes we want to repeatedly get and drop locks as part of an
> iteration.
> + * This struct helps avoid redundant drop and gets of the same lock.
> + */
> +struct lock_history {
> +       struct buffer_cache *cache;
> +       bool write;
> +       unsigned int previous;
> +};
> +
> +static void lh_init(struct lock_history *lh, struct buffer_cache *cache,
> bool write)
> +{
> +       lh->cache =3D cache;
> +       lh->write =3D write;
> +       lh->previous =3D NR_LOCKS;  /* indicates no previous */
> +}
> +
> +static void __lh_lock(struct lock_history *lh, unsigned int index)
> +{
> +       if (lh->write)
> +               down_write(&lh->cache->locks[index].lock);
> +       else
> +               down_read(&lh->cache->locks[index].lock);
> +}
> +
> +static void __lh_unlock(struct lock_history *lh, unsigned int index)
> +{
> +       if (lh->write)
> +               up_write(&lh->cache->locks[index].lock);
> +       else
> +               up_read(&lh->cache->locks[index].lock);
> +}
> +
> +/*
> + * Make sure you call this since it will unlock the final lock.
> + */
> +static void lh_exit(struct lock_history *lh)
> +{
> +       if (lh->previous !=3D NR_LOCKS) {
> +               __lh_unlock(lh, lh->previous);
> +               lh->previous =3D NR_LOCKS;
> +       }
> +}
> +
> +/*
> + * Named 'next' because there is no corresponding
> + * 'up/unlock' call since it's done automatically.
> + */
> +static void lh_next(struct lock_history *lh, sector_t b)
> +{
> +       unsigned int index =3D cache_index(b);
> +
> +       if (lh->previous !=3D NR_LOCKS) {
> +               if (lh->previous !=3D index) {
> +                       __lh_unlock(lh, lh->previous);
> +                       __lh_lock(lh, index);
> +                       lh->previous =3D index;
> +               }
> +       } else {
> +               __lh_lock(lh, index);
> +               lh->previous =3D index;
> +       }
> +}
> +
> +static struct dm_buffer *le_to_buffer(struct lru_entry *le)
> +{
> +       return container_of(le, struct dm_buffer, lru);
> +}
> +
> +static struct dm_buffer *list_to_buffer(struct list_head *l)
> +{
> +       struct lru_entry *le =3D list_entry(l, struct lru_entry, list);
> +
> +       if (!le)
> +               return NULL;
> +
> +       return le_to_buffer(le);
> +}
> +
> +static void cache_init(struct buffer_cache *bc)
> +{
> +       unsigned int i;
> +
> +       for (i =3D 0; i < NR_LOCKS; i++) {
> +               init_rwsem(&bc->locks[i].lock);
> +               bc->roots[i] =3D RB_ROOT;
> +       }
> +
> +       lru_init(&bc->lru[LIST_CLEAN]);
> +       lru_init(&bc->lru[LIST_DIRTY]);
> +}
> +
> +static void cache_destroy(struct buffer_cache *bc)
> +{
> +       unsigned int i;
> +
> +       for (i =3D 0; i < NR_LOCKS; i++)
> +               BUG_ON(!RB_EMPTY_ROOT(&bc->roots[i]));
> +
> +       lru_destroy(&bc->lru[LIST_CLEAN]);
> +       lru_destroy(&bc->lru[LIST_DIRTY]);
> +}
> +
> +/*
> + * not threadsafe, or racey depending how you look at it
> + */
> +static unsigned long cache_count(struct buffer_cache *bc, int list_mode)
> +{
> +       return lru_count(&bc->lru[list_mode]);
> +}
> +
> +/*--------------*/
> +
> +/*
> + * not threadsafe
> + */
> +static unsigned long cache_total(struct buffer_cache *bc)
> +{
> +       return lru_count(&bc->lru[LIST_CLEAN]) +
> +               lru_count(&bc->lru[LIST_DIRTY]);
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Gets a specific buffer, indexed by block.
> + * If the buffer is found then its holder count will be incremented and
> + * lru_reference will be called.
> + *
> + * threadsafe
> + */
> +static struct dm_buffer *__cache_get(const struct rb_root *root, sector_=
t
> block)
> +{
> +       struct rb_node *n =3D root->rb_node;
> +       struct dm_buffer *b;
> +
> +       while (n) {
> +               b =3D container_of(n, struct dm_buffer, node);
> +
> +               if (b->block =3D=3D block)
> +                       return b;
> +
> +               n =3D block < b->block ? n->rb_left : n->rb_right;
> +       }
> +
> +       return NULL;
> +}
> +
> +static void __cache_inc_buffer(struct dm_buffer *b)
> +{
> +       atomic_inc(&b->hold_count);
> +       WRITE_ONCE(b->last_accessed, jiffies);
> +}
> +
> +static struct dm_buffer *cache_get(struct buffer_cache *bc, sector_t
> block)
> +{
> +       struct dm_buffer *b;
> +
> +       cache_read_lock(bc, block);
> +       b =3D __cache_get(&bc->roots[cache_index(block)], block);
> +       if (b) {
> +               lru_reference(&b->lru);
> +               __cache_inc_buffer(b);
> +       }
> +       cache_read_unlock(bc, block);
> +
> +       return b;
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Returns true if the hold count hits zero.
> + * threadsafe
> + */
> +static bool cache_put(struct buffer_cache *bc, struct dm_buffer *b)
> +{
> +       bool r;
> +
> +       cache_read_lock(bc, b->block);
> +       BUG_ON(!atomic_read(&b->hold_count));
> +       r =3D atomic_dec_and_test(&b->hold_count);
> +       cache_read_unlock(bc, b->block);
> +
> +       return r;
> +}
> +
> +/*--------------*/
> +
> +typedef enum evict_result (*b_predicate)(struct dm_buffer *, void *);
> +
> +/*
> + * Evicts a buffer based on a predicate.  The oldest buffer that
> + * matches the predicate will be selected.  In addition to the
> + * predicate the hold_count of the selected buffer will be zero.
> + */
> +struct evict_wrapper {
> +       struct lock_history *lh;
> +       b_predicate pred;
> +       void *context;
> +};
> +
> +/*
> + * Wraps the buffer predicate turning it into an lru predicate.  Adds
> + * extra test for hold_count.
> + */
> +static enum evict_result __evict_pred(struct lru_entry *le, void *contex=
t)
> +{
> +       struct evict_wrapper *w =3D context;
> +       struct dm_buffer *b =3D le_to_buffer(le);
> +
> +       lh_next(w->lh, b->block);
> +
> +       if (atomic_read(&b->hold_count))
> +               return ER_DONT_EVICT;
> +
> +       return w->pred(b, w->context);
> +}
> +
> +static struct dm_buffer *__cache_evict(struct buffer_cache *bc, int
> list_mode,
> +                                      b_predicate pred, void *context,
> +                                      struct lock_history *lh)
> +{
> +       struct evict_wrapper w =3D {.lh =3D lh, .pred =3D pred, .context =
=3D
> context};
> +       struct lru_entry *le;
> +       struct dm_buffer *b;
> +
> +       le =3D lru_evict(&bc->lru[list_mode], __evict_pred, &w);
> +       if (!le)
> +               return NULL;
> +
> +       b =3D le_to_buffer(le);
> +       /* __evict_pred will have locked the appropriate tree. */
> +       rb_erase(&b->node, &bc->roots[cache_index(b->block)]);
> +
> +       return b;
> +}
> +
> +static struct dm_buffer *cache_evict(struct buffer_cache *bc, int
> list_mode,
> +                                    b_predicate pred, void *context)
> +{
> +       struct dm_buffer *b;
> +       struct lock_history lh;
> +
> +       lh_init(&lh, bc, true);
> +       b =3D __cache_evict(bc, list_mode, pred, context, &lh);
> +       lh_exit(&lh);
> +
> +       return b;
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Mark a buffer as clean or dirty. Not threadsafe.
> + */
> +static void cache_mark(struct buffer_cache *bc, struct dm_buffer *b, int
> list_mode)
> +{
> +       cache_write_lock(bc, b->block);
> +       if (list_mode !=3D b->list_mode) {
> +               lru_remove(&bc->lru[b->list_mode], &b->lru);
> +               b->list_mode =3D list_mode;
> +               lru_insert(&bc->lru[b->list_mode], &b->lru);
> +       }
> +       cache_write_unlock(bc, b->block);
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Runs through the lru associated with 'old_mode', if the predicate
> matches then
> + * it moves them to 'new_mode'.  Not threadsafe.
> + */
> +static void __cache_mark_many(struct buffer_cache *bc, int old_mode, int
> new_mode,
> +                             b_predicate pred, void *context, struct
> lock_history *lh)
> +{
> +       struct lru_entry *le;
> +       struct dm_buffer *b;
> +       struct evict_wrapper w =3D {.lh =3D lh, .pred =3D pred, .context =
=3D
> context};
> +
> +       while (true) {
> +               le =3D lru_evict(&bc->lru[old_mode], __evict_pred, &w);
> +               if (!le)
> +                       break;
> +
> +               b =3D le_to_buffer(le);
> +               b->list_mode =3D new_mode;
> +               lru_insert(&bc->lru[b->list_mode], &b->lru);
> +       }
> +}
> +
> +static void cache_mark_many(struct buffer_cache *bc, int old_mode, int
> new_mode,
> +                           b_predicate pred, void *context)
> +{
> +       struct lock_history lh;
> +
> +       lh_init(&lh, bc, true);
> +       __cache_mark_many(bc, old_mode, new_mode, pred, context, &lh);
> +       lh_exit(&lh);
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Iterates through all clean or dirty entries calling a function for ea=
ch
> + * entry.  The callback may terminate the iteration early.  Not
> threadsafe.
> + */
> +
> +/*
> + * Iterator functions should return one of these actions to indicate
> + * how the iteration should proceed.
> + */
> +enum it_action {
> +       IT_NEXT,
> +       IT_COMPLETE,
> +};
> +
> +typedef enum it_action (*iter_fn)(struct dm_buffer *b, void *context);
> +
> +static void __cache_iterate(struct buffer_cache *bc, int list_mode,
> +                           iter_fn fn, void *context, struct lock_histor=
y
> *lh)
> +{
> +       struct lru *lru =3D &bc->lru[list_mode];
> +       struct lru_entry *le, *first;
> +
> +       if (!lru->cursor)
> +               return;
> +
> +       first =3D le =3D to_le(lru->cursor);
> +       do {
> +               struct dm_buffer *b =3D le_to_buffer(le);
> +
> +               lh_next(lh, b->block);
> +
> +               switch (fn(b, context)) {
> +               case IT_NEXT:
> +                       break;
> +
> +               case IT_COMPLETE:
> +                       return;
> +               }
> +               cond_resched();
> +
> +               le =3D to_le(le->list.next);
> +       } while (le !=3D first);
> +}
> +
> +static void cache_iterate(struct buffer_cache *bc, int list_mode,
> +                         iter_fn fn, void *context)
> +{
> +       struct lock_history lh;
> +
> +       lh_init(&lh, bc, false);
> +       __cache_iterate(bc, list_mode, fn, context, &lh);
> +       lh_exit(&lh);
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Passes ownership of the buffer to the cache. Returns false if the
> + * buffer was already present (in which case ownership does not pass).
> + * eg, a race with another thread.
> + *
> + * Holder count should be 1 on insertion.
> + *
> + * Not threadsafe.
> + */
> +static bool __cache_insert(struct rb_root *root, struct dm_buffer *b)
> +{
> +       struct rb_node **new =3D &root->rb_node, *parent =3D NULL;
> +       struct dm_buffer *found;
> +
> +       while (*new) {
> +               found =3D container_of(*new, struct dm_buffer, node);
> +
> +               if (found->block =3D=3D b->block)
> +                       return false;
> +
> +               parent =3D *new;
> +               new =3D b->block < found->block ?
> +                       &found->node.rb_left : &found->node.rb_right;
> +       }
> +
> +       rb_link_node(&b->node, parent, new);
> +       rb_insert_color(&b->node, root);
> +
> +       return true;
> +}
> +
> +static bool cache_insert(struct buffer_cache *bc, struct dm_buffer *b)
> +{
> +       bool r;
> +
> +       BUG_ON(b->list_mode >=3D LIST_SIZE);
> +
> +       cache_write_lock(bc, b->block);
> +       BUG_ON(atomic_read(&b->hold_count) !=3D 1);
> +       r =3D __cache_insert(&bc->roots[cache_index(b->block)], b);
> +       if (r)
> +               lru_insert(&bc->lru[b->list_mode], &b->lru);
> +       cache_write_unlock(bc, b->block);
> +
> +       return r;
> +}
> +
> +/*--------------*/
> +
> +/*
> + * Removes buffer from cache, ownership of the buffer passes back to the
> caller.
> + * Fails if the hold_count is not one (ie. the caller holds the only
> reference).
> + *
> + * Not threadsafe.
> + */
> +static bool cache_remove(struct buffer_cache *bc, struct dm_buffer *b)
> +{
> +       bool r;
> +
> +       cache_write_lock(bc, b->block);
> +
> +       if (atomic_read(&b->hold_count) !=3D 1)
> +               r =3D false;
> +
> +       else {
> +               r =3D true;
> +               rb_erase(&b->node, &bc->roots[cache_index(b->block)]);
> +               lru_remove(&bc->lru[b->list_mode], &b->lru);
> +       }
> +
> +       cache_write_unlock(bc, b->block);
> +
> +       return r;
> +}
> +
> +/*--------------*/
> +
> +typedef void (*b_release)(struct dm_buffer *);
> +
> +static struct dm_buffer *__find_next(struct rb_root *root, sector_t bloc=
k)
> +{
> +       struct rb_node *n =3D root->rb_node;
> +       struct dm_buffer *b;
> +       struct dm_buffer *best =3D NULL;
> +
> +       while (n) {
> +               b =3D container_of(n, struct dm_buffer, node);
> +
> +               if (b->block =3D=3D block)
> +                       return b;
> +
> +               if (block <=3D b->block) {
> +                       n =3D n->rb_left;
> +                       best =3D b;
> +               } else
> +                       n =3D n->rb_right;
> +       }
> +
> +       return best;
> +}
> +
> +static void __remove_range(struct buffer_cache *bc,
> +                          struct rb_root *root,
> +                          sector_t begin, sector_t end,
> +                          b_predicate pred, b_release release)
> +{
> +       struct dm_buffer *b;
> +
> +       while (true) {
> +               cond_resched();
> +
> +               b =3D __find_next(root, begin);
> +               if (!b || (b->block >=3D end))
> +                       break;
> +
> +               begin =3D b->block + 1;
> +
> +               if (atomic_read(&b->hold_count))
> +                       continue;
> +
> +               if (pred(b, NULL) =3D=3D ER_EVICT) {
> +                       rb_erase(&b->node, root);
> +                       lru_remove(&bc->lru[b->list_mode], &b->lru);
> +                       release(b);
> +               }
> +       }
> +}
> +
> +static void cache_remove_range(struct buffer_cache *bc,
> +                              sector_t begin, sector_t end,
> +                              b_predicate pred, b_release release)
> +{
> +       unsigned int i;
> +
> +       for (i =3D 0; i < NR_LOCKS; i++) {
> +               down_write(&bc->locks[i].lock);
> +               __remove_range(bc, &bc->roots[i], begin, end, pred,
> release);
> +               up_write(&bc->locks[i].lock);
> +       }
> +}
> +
> +/*----------------------------------------------------------------*/
> +
>  /*
>   * Linking of buffers:
> - *     All buffers are linked to buffer_tree with their node field.
> + *     All buffers are linked to buffer_cache with their node field.
>   *
>   *     Clean buffers that are not being written (B_WRITING not set)
>   *     are linked to lru[LIST_CLEAN] with their lru_list field.
> @@ -136,9 +956,6 @@ struct dm_bufio_client {
>         spinlock_t spinlock;
>         bool no_sleep;
>
> -       struct list_head lru[LIST_SIZE];
> -       unsigned long n_buffers[LIST_SIZE];
> -
>         struct block_device *bdev;
>         unsigned int block_size;
>         s8 sectors_per_block_bits;
> @@ -153,7 +970,7 @@ struct dm_bufio_client {
>
>         unsigned int minimum_buffers;
>
> -       struct rb_root buffer_tree;
> +       struct buffer_cache cache;
>         wait_queue_head_t free_buffer_wait;
>
>         sector_t start;
> @@ -165,6 +982,11 @@ struct dm_bufio_client {
>         struct shrinker shrinker;
>         struct work_struct shrink_work;
>         atomic_long_t need_shrink;
> +
> +       /*
> +        * Used by global_cleanup to sort the clients list.
> +        */
> +       unsigned long oldest_buffer;
>  };
>
>  static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
> @@ -181,14 +1003,6 @@ static void dm_bufio_lock(struct dm_bufio_client *c=
)
>                 mutex_lock_nested(&c->lock, dm_bufio_in_request());
>  }
>
> -static int dm_bufio_trylock(struct dm_bufio_client *c)
> -{
> -       if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
> -               return spin_trylock_bh(&c->spinlock);
> -       else
> -               return mutex_trylock(&c->lock);
> -}
> -
>  static void dm_bufio_unlock(struct dm_bufio_client *c)
>  {
>         if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
> @@ -217,10 +1031,6 @@ static unsigned long dm_bufio_cache_size_latch;
>
>  static DEFINE_SPINLOCK(global_spinlock);
>
> -static LIST_HEAD(global_queue);
> -
> -static unsigned long global_num;
> -
>  /*
>   * Buffers are freed after this timeout
>   */
> @@ -254,7 +1064,6 @@ static struct workqueue_struct *dm_bufio_wq;
>  static struct delayed_work dm_bufio_cleanup_old_work;
>  static struct work_struct dm_bufio_replacement_work;
>
> -
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>  static void buffer_record_stack(struct dm_buffer *b)
>  {
> @@ -262,78 +1071,6 @@ static void buffer_record_stack(struct dm_buffer *b=
)
>  }
>  #endif
>
> -/*
> - *----------------------------------------------------------------
> - * A red/black tree acts as an index for all the buffers.
> - *----------------------------------------------------------------
> - */
> -static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t bloc=
k)
> -{
> -       struct rb_node *n =3D c->buffer_tree.rb_node;
> -       struct dm_buffer *b;
> -
> -       while (n) {
> -               b =3D container_of(n, struct dm_buffer, node);
> -
> -               if (b->block =3D=3D block)
> -                       return b;
> -
> -               n =3D block < b->block ? n->rb_left : n->rb_right;
> -       }
> -
> -       return NULL;
> -}
> -
> -static struct dm_buffer *__find_next(struct dm_bufio_client *c, sector_t
> block)
> -{
> -       struct rb_node *n =3D c->buffer_tree.rb_node;
> -       struct dm_buffer *b;
> -       struct dm_buffer *best =3D NULL;
> -
> -       while (n) {
> -               b =3D container_of(n, struct dm_buffer, node);
> -
> -               if (b->block =3D=3D block)
> -                       return b;
> -
> -               if (block <=3D b->block) {
> -                       n =3D n->rb_left;
> -                       best =3D b;
> -               } else {
> -                       n =3D n->rb_right;
> -               }
> -       }
> -
> -       return best;
> -}
> -
> -static void __insert(struct dm_bufio_client *c, struct dm_buffer *b)
> -{
> -       struct rb_node **new =3D &c->buffer_tree.rb_node, *parent =3D NUL=
L;
> -       struct dm_buffer *found;
> -
> -       while (*new) {
> -               found =3D container_of(*new, struct dm_buffer, node);
> -
> -               if (found->block =3D=3D b->block) {
> -                       BUG_ON(found !=3D b);
> -                       return;
> -               }
> -
> -               parent =3D *new;
> -               new =3D b->block < found->block ?
> -                       &found->node.rb_left : &found->node.rb_right;
> -       }
> -
> -       rb_link_node(&b->node, parent, new);
> -       rb_insert_color(&b->node, &c->buffer_tree);
> -}
> -
> -static void __remove(struct dm_bufio_client *c, struct dm_buffer *b)
> -{
> -       rb_erase(&b->node, &c->buffer_tree);
> -}
> -
>  /*----------------------------------------------------------------*/
>
>  static void adjust_total_allocated(struct dm_buffer *b, bool unlink)
> @@ -361,16 +1098,9 @@ static void adjust_total_allocated(struct dm_buffer
> *b, bool unlink)
>         if (dm_bufio_current_allocated > dm_bufio_peak_allocated)
>                 dm_bufio_peak_allocated =3D dm_bufio_current_allocated;
>
> -       b->accessed =3D 1;
> -
>         if (!unlink) {
> -               list_add(&b->global_list, &global_queue);
> -               global_num++;
>                 if (dm_bufio_current_allocated > dm_bufio_cache_size)
>                         queue_work(dm_bufio_wq,
> &dm_bufio_replacement_work);
> -       } else {
> -               list_del(&b->global_list);
> -               global_num--;
>         }
>
>         spin_unlock(&global_spinlock);
> @@ -486,8 +1216,9 @@ static void free_buffer_data(struct dm_bufio_client
> *c,
>   */
>  static struct dm_buffer *alloc_buffer(struct dm_bufio_client *c, gfp_t
> gfp_mask)
>  {
> -       struct dm_buffer *b =3D kmem_cache_alloc(c->slab_buffer, gfp_mask=
);
> +       struct dm_buffer *b;
>
> +       b =3D kmem_cache_alloc(c->slab_buffer, gfp_mask);
>         if (!b)
>                 return NULL;
>
> @@ -498,6 +1229,7 @@ static struct dm_buffer *alloc_buffer(struct
> dm_bufio_client *c, gfp_t gfp_mask)
>                 kmem_cache_free(c->slab_buffer, b);
>                 return NULL;
>         }
> +       adjust_total_allocated(b, false);
>
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>         b->stack_len =3D 0;
> @@ -512,61 +1244,11 @@ static void free_buffer(struct dm_buffer *b)
>  {
>         struct dm_bufio_client *c =3D b->c;
>
> +       adjust_total_allocated(b, true);
>         free_buffer_data(c, b->data, b->data_mode);
>         kmem_cache_free(c->slab_buffer, b);
>  }
>
> -/*
> - * Link buffer to the buffer tree and clean or dirty queue.
> - */
> -static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty=
)
> -{
> -       struct dm_bufio_client *c =3D b->c;
> -
> -       c->n_buffers[dirty]++;
> -       b->block =3D block;
> -       b->list_mode =3D dirty;
> -       list_add(&b->lru_list, &c->lru[dirty]);
> -       __insert(b->c, b);
> -       b->last_accessed =3D jiffies;
> -
> -       adjust_total_allocated(b, false);
> -}
> -
> -/*
> - * Unlink buffer from the buffer tree and dirty or clean queue.
> - */
> -static void __unlink_buffer(struct dm_buffer *b)
> -{
> -       struct dm_bufio_client *c =3D b->c;
> -
> -       BUG_ON(!c->n_buffers[b->list_mode]);
> -
> -       c->n_buffers[b->list_mode]--;
> -       __remove(b->c, b);
> -       list_del(&b->lru_list);
> -
> -       adjust_total_allocated(b, true);
> -}
> -
> -/*
> - * Place the buffer to the head of dirty or clean LRU queue.
> - */
> -static void __relink_lru(struct dm_buffer *b, int dirty)
> -{
> -       struct dm_bufio_client *c =3D b->c;
> -
> -       b->accessed =3D 1;
> -
> -       BUG_ON(!c->n_buffers[b->list_mode]);
> -
> -       c->n_buffers[b->list_mode]--;
> -       c->n_buffers[dirty]++;
> -       b->list_mode =3D dirty;
> -       list_move(&b->lru_list, &c->lru[dirty]);
> -       b->last_accessed =3D jiffies;
> -}
> -
>  /*
>
> *------------------------------------------------------------------------=
--
>   * Submit I/O on the buffer.
> @@ -806,7 +1488,7 @@ static void __flush_write_list(struct list_head
> *write_list)
>   */
>  static void __make_buffer_clean(struct dm_buffer *b)
>  {
> -       BUG_ON(b->hold_count);
> +       BUG_ON(atomic_read(&b->hold_count));
>
>         /* smp_load_acquire() pairs with read_endio()'s
> smp_mb__before_atomic() */
>         if (!smp_load_acquire(&b->state))       /* fast case */
> @@ -817,6 +1499,26 @@ static void __make_buffer_clean(struct dm_buffer *b=
)
>         wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
>  }
>
> +static enum evict_result is_clean(struct dm_buffer *b, void *context)
> +{
> +       struct dm_bufio_client *c =3D context;
> +
> +       BUG_ON(test_bit(B_WRITING, &b->state));
> +       BUG_ON(test_bit(B_DIRTY, &b->state));
> +
> +       if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep &&
> +           unlikely(test_bit(B_READING, &b->state)))
> +               return ER_DONT_EVICT;
> +
> +       return ER_EVICT;
> +}
> +
> +static enum evict_result is_dirty(struct dm_buffer *b, void *context)
> +{
> +       BUG_ON(test_bit(B_READING, &b->state));
> +       return ER_EVICT;
> +}
> +
>  /*
>   * Find some buffer that is not held by anybody, clean it, unlink it and
>   * return it.
> @@ -825,34 +1527,20 @@ static struct dm_buffer
> *__get_unclaimed_buffer(struct dm_bufio_client *c)
>  {
>         struct dm_buffer *b;
>
> -       list_for_each_entry_reverse(b, &c->lru[LIST_CLEAN], lru_list) {
> -               BUG_ON(test_bit(B_WRITING, &b->state));
> -               BUG_ON(test_bit(B_DIRTY, &b->state));
> -
> -               if (static_branch_unlikely(&no_sleep_enabled) &&
> c->no_sleep &&
> -                   unlikely(test_bit_acquire(B_READING, &b->state)))
> -                       continue;
> -
> -               if (!b->hold_count) {
> -                       __make_buffer_clean(b);
> -                       __unlink_buffer(b);
> -                       return b;
> -               }
> -               cond_resched();
> +       b =3D cache_evict(&c->cache, LIST_CLEAN, is_clean, c);
> +       if (b) {
> +               /* this also waits for pending reads */
> +               __make_buffer_clean(b);
> +               return b;
>         }
>
>         if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
>                 return NULL;
>
> -       list_for_each_entry_reverse(b, &c->lru[LIST_DIRTY], lru_list) {
> -               BUG_ON(test_bit(B_READING, &b->state));
> -
> -               if (!b->hold_count) {
> -                       __make_buffer_clean(b);
> -                       __unlink_buffer(b);
> -                       return b;
> -               }
> -               cond_resched();
> +       b =3D cache_evict(&c->cache, LIST_DIRTY, is_dirty, NULL);
> +       if (b) {
> +               __make_buffer_clean(b);
> +               return b;
>         }
>
>         return NULL;
> @@ -873,7 +1561,12 @@ static void __wait_for_free_buffer(struct
> dm_bufio_client *c)
>         set_current_state(TASK_UNINTERRUPTIBLE);
>         dm_bufio_unlock(c);
>
> -       io_schedule();
> +       /*
> +        * It's possible to miss a wake up event since we don't always
> +        * hold c->lock when wake_up is called.  So we have a timeout her=
e,
> +        * just in case.
> +        */
> +       io_schedule_timeout(5 * HZ);
>
>         remove_wait_queue(&c->free_buffer_wait, &wait);
>
> @@ -931,9 +1624,8 @@ static struct dm_buffer
> *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>                 }
>
>                 if (!list_empty(&c->reserved_buffers)) {
> -                       b =3D list_entry(c->reserved_buffers.next,
> -                                      struct dm_buffer, lru_list);
> -                       list_del(&b->lru_list);
> +                       b =3D list_to_buffer(c->reserved_buffers.next);
> +                       list_del(&b->lru.list);
>                         c->need_reserved_buffers++;
>
>                         return b;
> @@ -967,36 +1659,55 @@ static void __free_buffer_wake(struct dm_buffer *b=
)
>  {
>         struct dm_bufio_client *c =3D b->c;
>
> +       b->block =3D -1;
>         if (!c->need_reserved_buffers)
>                 free_buffer(b);
>         else {
> -               list_add(&b->lru_list, &c->reserved_buffers);
> +               list_add(&b->lru.list, &c->reserved_buffers);
>                 c->need_reserved_buffers--;
>         }
>
>         wake_up(&c->free_buffer_wait);
>  }
>
> +static enum evict_result cleaned(struct dm_buffer *b, void *context)
> +{
> +       BUG_ON(test_bit(B_READING, &b->state));
> +
> +       if (test_bit(B_DIRTY, &b->state) || test_bit(B_WRITING, &b->state=
))
> +               return ER_DONT_EVICT;
> +       else
> +               return ER_EVICT;
> +}
> +
> +static void __move_clean_buffers(struct dm_bufio_client *c)
> +{
> +       cache_mark_many(&c->cache, LIST_DIRTY, LIST_CLEAN, cleaned, NULL)=
;
> +}
> +
> +struct write_context {
> +       int no_wait;
> +       struct list_head *write_list;
> +};
> +
> +static enum it_action write_one(struct dm_buffer *b, void *context)
> +{
> +       struct write_context *wc =3D context;
> +
> +       if (wc->no_wait && test_bit(B_WRITING, &b->state))
> +               return IT_COMPLETE;
> +
> +       __write_dirty_buffer(b, wc->write_list);
> +       return IT_NEXT;
> +}
> +
>  static void __write_dirty_buffers_async(struct dm_bufio_client *c, int
> no_wait,
>                                         struct list_head *write_list)
>  {
> -       struct dm_buffer *b, *tmp;
> +       struct write_context wc =3D {.no_wait =3D no_wait, .write_list =
=3D
> write_list};
>
> -       list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_DIRTY],
> lru_list) {
> -               BUG_ON(test_bit(B_READING, &b->state));
> -
> -               if (!test_bit(B_DIRTY, &b->state) &&
> -                   !test_bit(B_WRITING, &b->state)) {
> -                       __relink_lru(b, LIST_CLEAN);
> -                       continue;
> -               }
> -
> -               if (no_wait && test_bit(B_WRITING, &b->state))
> -                       return;
> -
> -               __write_dirty_buffer(b, write_list);
> -               cond_resched();
> -       }
> +       __move_clean_buffers(c);
> +       cache_iterate(&c->cache, LIST_DIRTY, write_one, &wc);
>  }
>
>  /*
> @@ -1007,7 +1718,8 @@ static void __write_dirty_buffers_async(struct
> dm_bufio_client *c, int no_wait,
>  static void __check_watermark(struct dm_bufio_client *c,
>                               struct list_head *write_list)
>  {
> -       if (c->n_buffers[LIST_DIRTY] > c->n_buffers[LIST_CLEAN] *
> DM_BUFIO_WRITEBACK_RATIO)
> +       if (cache_count(&c->cache, LIST_DIRTY) >
> +               cache_count(&c->cache, LIST_CLEAN) *
> DM_BUFIO_WRITEBACK_RATIO)
>                 __write_dirty_buffers_async(c, 1, write_list);
>  }
>
> @@ -1017,20 +1729,30 @@ static void __check_watermark(struct
> dm_bufio_client *c,
>   *--------------------------------------------------------------
>   */
>
> +static void cache_put_and_wake(struct dm_bufio_client *c, struct
> dm_buffer *b)
> +{
> +       /*
> +        * Relying on waitqueue_active() is racey, but we sleep
> +        * with schedule_timeout anyway.
> +        */
> +       if (cache_put(&c->cache, b) &&
> +           unlikely(waitqueue_active(&c->free_buffer_wait)))
> +               wake_up(&c->free_buffer_wait);
> +}
> +
> +/*
> + * This assumes you have already checked the cache to see if the buffer
> + * is already present (it will recheck after dropping the lock for
> allocation).
> + */
>  static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t
> block,
>                                      enum new_flag nf, int *need_submit,
>                                      struct list_head *write_list)
>  {
>         struct dm_buffer *b, *new_b =3D NULL;
> -
>         *need_submit =3D 0;
>
> -       b =3D __find(c, block);
> -       if (b)
> -               goto found_buffer;
> -
> -       if (nf =3D=3D NF_GET)
> -               return NULL;
> +       /* This can't be called with NF_GET */
> +       BUG_ON(nf =3D=3D NF_GET);
>
>         new_b =3D __alloc_buffer_wait(c, nf);
>         if (!new_b)
> @@ -1040,7 +1762,7 @@ static struct dm_buffer *__bufio_new(struct
> dm_bufio_client *c, sector_t block,
>          * We've had a period where the mutex was unlocked, so need to
>          * recheck the buffer tree.
>          */
> -       b =3D __find(c, block);
> +       b =3D cache_get(&c->cache, block);
>         if (b) {
>                 __free_buffer_wake(new_b);
>                 goto found_buffer;
> @@ -1049,24 +1771,35 @@ static struct dm_buffer *__bufio_new(struct
> dm_bufio_client *c, sector_t block,
>         __check_watermark(c, write_list);
>
>         b =3D new_b;
> -       b->hold_count =3D 1;
> +       atomic_set(&b->hold_count, 1);
> +       WRITE_ONCE(b->last_accessed, jiffies);
> +       b->block =3D block;
>         b->read_error =3D 0;
>         b->write_error =3D 0;
> -       __link_buffer(b, block, LIST_CLEAN);
> +       b->list_mode =3D LIST_CLEAN;
>
> -       if (nf =3D=3D NF_FRESH) {
> +       if (nf =3D=3D NF_FRESH)
>                 b->state =3D 0;
> -               return b;
> +       else {
> +               b->state =3D 1 << B_READING;
> +               *need_submit =3D 1;
>         }
>
> -       b->state =3D 1 << B_READING;
> -       *need_submit =3D 1;
> +       /*
> +        * We mustn't insert into the cache until the B_READING state
> +        * is set.  Otherwise another thread could get it and use
> +        * it before it had been read.
> +        */
> +       cache_insert(&c->cache, b);
>
>         return b;
>
>  found_buffer:
> -       if (nf =3D=3D NF_PREFETCH)
> +       if (nf =3D=3D NF_PREFETCH) {
> +               cache_put_and_wake(c, b);
>                 return NULL;
> +       }
> +
>         /*
>          * Note: it is essential that we don't wait for the buffer to be
>          * read if dm_bufio_get function is used. Both dm_bufio_get and
> @@ -1074,12 +1807,11 @@ static struct dm_buffer *__bufio_new(struct
> dm_bufio_client *c, sector_t block,
>          * If the user called both dm_bufio_prefetch and dm_bufio_get on
>          * the same buffer, it would deadlock if we waited.
>          */
> -       if (nf =3D=3D NF_GET && unlikely(test_bit_acquire(B_READING,
> &b->state)))
> +       if (nf =3D=3D NF_GET && unlikely(test_bit_acquire(B_READING,
> &b->state))) {
> +               cache_put_and_wake(c, b);
>                 return NULL;
> +       }
>
> -       b->hold_count++;
> -       __relink_lru(b, test_bit(B_DIRTY, &b->state) ||
> -                    test_bit(B_WRITING, &b->state));
>         return b;
>  }
>
> @@ -1109,18 +1841,49 @@ static void read_endio(struct dm_buffer *b,
> blk_status_t status)
>  static void *new_read(struct dm_bufio_client *c, sector_t block,
>                       enum new_flag nf, struct dm_buffer **bp)
>  {
> -       int need_submit;
> +       int need_submit =3D 0;
>         struct dm_buffer *b;
>
>         LIST_HEAD(write_list);
> +       *bp =3D NULL;
> +
> +       /*
> +        * Fast path, hopefully the block is already in the cache.  No ne=
ed
> +        * to get the client lock for this.
> +        */
> +       b =3D cache_get(&c->cache, block);
> +       if (b) {
> +               if (nf =3D=3D NF_PREFETCH) {
> +                       cache_put_and_wake(c, b);
> +                       return NULL;
> +               }
> +
> +               /*
> +                * Note: it is essential that we don't wait for the buffe=
r
> to be
> +                * read if dm_bufio_get function is used. Both
> dm_bufio_get and
> +                * dm_bufio_prefetch can be used in the driver request
> routine.
> +                * If the user called both dm_bufio_prefetch and
> dm_bufio_get on
> +                * the same buffer, it would deadlock if we waited.
> +                */
> +               if (nf =3D=3D NF_GET && unlikely(test_bit_acquire(B_READI=
NG,
> &b->state))) {
> +                       cache_put_and_wake(c, b);
> +                       return NULL;
> +               }
> +       }
> +
> +       if (!b) {
> +               if (nf =3D=3D NF_GET)
> +                       return NULL;
> +
> +               dm_bufio_lock(c);
> +               b =3D __bufio_new(c, block, nf, &need_submit, &write_list=
);
> +               dm_bufio_unlock(c);
> +       }
>
> -       dm_bufio_lock(c);
> -       b =3D __bufio_new(c, block, nf, &need_submit, &write_list);
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
> -       if (b && b->hold_count =3D=3D 1)
> +       if (b && (atomic_read(&b->hold_count) =3D=3D 1))
>                 buffer_record_stack(b);
>  #endif
> -       dm_bufio_unlock(c);
>
>         __flush_write_list(&write_list);
>
> @@ -1141,7 +1904,6 @@ static void *new_read(struct dm_bufio_client *c,
> sector_t block,
>         }
>
>         *bp =3D b;
> -
>         return b->data;
>  }
>
> @@ -1156,7 +1918,6 @@ void *dm_bufio_read(struct dm_bufio_client *c,
> sector_t block,
>                     struct dm_buffer **bp)
>  {
>         BUG_ON(dm_bufio_in_request());
> -
>         return new_read(c, block, NF_READ, bp);
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_read);
> @@ -1165,7 +1926,6 @@ void *dm_bufio_new(struct dm_bufio_client *c,
> sector_t block,
>                    struct dm_buffer **bp)
>  {
>         BUG_ON(dm_bufio_in_request());
> -
>         return new_read(c, block, NF_FRESH, bp);
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_new);
> @@ -1180,12 +1940,19 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
>         BUG_ON(dm_bufio_in_request());
>
>         blk_start_plug(&plug);
> -       dm_bufio_lock(c);
>
>         for (; n_blocks--; block++) {
>                 int need_submit;
>                 struct dm_buffer *b;
>
> +               b =3D cache_get(&c->cache, block);
> +               if (b) {
> +                       /* already in cache */
> +                       cache_put_and_wake(c, b);
> +                       continue;
> +               }
> +
> +               dm_bufio_lock(c);
>                 b =3D __bufio_new(c, block, NF_PREFETCH, &need_submit,
>                                 &write_list);
>                 if (unlikely(!list_empty(&write_list))) {
> @@ -1195,6 +1962,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
>                         blk_start_plug(&plug);
>                         dm_bufio_lock(c);
>                 }
> +
>                 if (unlikely(b !=3D NULL)) {
>                         dm_bufio_unlock(c);
>
> @@ -1208,10 +1976,9 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
>                                 goto flush_plug;
>                         dm_bufio_lock(c);
>                 }
> +               dm_bufio_unlock(c);
>         }
>
> -       dm_bufio_unlock(c);
> -
>  flush_plug:
>         blk_finish_plug(&plug);
>  }
> @@ -1221,29 +1988,28 @@ void dm_bufio_release(struct dm_buffer *b)
>  {
>         struct dm_bufio_client *c =3D b->c;
>
> -       dm_bufio_lock(c);
> +       /*
> +        * If there were errors on the buffer, and the buffer is not
> +        * to be written, free the buffer. There is no point in caching
> +        * invalid buffer.
> +        */
> +       if ((b->read_error || b->write_error) &&
> +           !test_bit_acquire(B_READING, &b->state) &&
> +           !test_bit(B_WRITING, &b->state) &&
> +           !test_bit(B_DIRTY, &b->state)) {
> +               dm_bufio_lock(c);
>
> -       BUG_ON(!b->hold_count);
> -
> -       b->hold_count--;
> -       if (!b->hold_count) {
> -               wake_up(&c->free_buffer_wait);
> -
> -               /*
> -                * If there were errors on the buffer, and the buffer is
> not
> -                * to be written, free the buffer. There is no point in
> caching
> -                * invalid buffer.
> -                */
> -               if ((b->read_error || b->write_error) &&
> -                   !test_bit_acquire(B_READING, &b->state) &&
> -                   !test_bit(B_WRITING, &b->state) &&
> -                   !test_bit(B_DIRTY, &b->state)) {
> -                       __unlink_buffer(b);
> +               /* cache remove can fail if there are other holders */
> +               if (cache_remove(&c->cache, b)) {
>                         __free_buffer_wake(b);
> +                       dm_bufio_unlock(c);
> +                       return;
>                 }
> +
> +               dm_bufio_unlock(c);
>         }
>
> -       dm_bufio_unlock(c);
> +       cache_put_and_wake(c, b);
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_release);
>
> @@ -1262,7 +2028,7 @@ void dm_bufio_mark_partial_buffer_dirty(struct
> dm_buffer *b,
>         if (!test_and_set_bit(B_DIRTY, &b->state)) {
>                 b->dirty_start =3D start;
>                 b->dirty_end =3D end;
> -               __relink_lru(b, LIST_DIRTY);
> +               cache_mark(&c->cache, b, LIST_DIRTY);
>         } else {
>                 if (start < b->dirty_start)
>                         b->dirty_start =3D start;
> @@ -1300,11 +2066,19 @@
> EXPORT_SYMBOL_GPL(dm_bufio_write_dirty_buffers_async);
>   *
>   * Finally, we flush hardware disk cache.
>   */
> +static bool is_writing(struct lru_entry *e, void *context)
> +{
> +       struct dm_buffer *b =3D le_to_buffer(e);
> +
> +       return test_bit(B_WRITING, &b->state);
> +}
> +
>  int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
>  {
>         int a, f;
> -       unsigned long buffers_processed =3D 0;
> -       struct dm_buffer *b, *tmp;
> +       unsigned long nr_buffers;
> +       struct lru_entry *e;
> +       struct lru_iter it;
>
>         LIST_HEAD(write_list);
>
> @@ -1314,52 +2088,32 @@ int dm_bufio_write_dirty_buffers(struct
> dm_bufio_client *c)
>         __flush_write_list(&write_list);
>         dm_bufio_lock(c);
>
> -again:
> -       list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_DIRTY],
> lru_list) {
> -               int dropped_lock =3D 0;
> -
> -               if (buffers_processed < c->n_buffers[LIST_DIRTY])
> -                       buffers_processed++;
> +       nr_buffers =3D cache_count(&c->cache, LIST_DIRTY);
> +       lru_iter_begin(&c->cache.lru[LIST_DIRTY], &it);
> +       while ((e =3D lru_iter_next(&it, is_writing, c))) {
> +               struct dm_buffer *b =3D le_to_buffer(e);
> +               __cache_inc_buffer(b);
>
>                 BUG_ON(test_bit(B_READING, &b->state));
>
> -               if (test_bit(B_WRITING, &b->state)) {
> -                       if (buffers_processed < c->n_buffers[LIST_DIRTY])=
 {
> -                               dropped_lock =3D 1;
> -                               b->hold_count++;
> -                               dm_bufio_unlock(c);
> -                               wait_on_bit_io(&b->state, B_WRITING,
> -                                              TASK_UNINTERRUPTIBLE);
> -                               dm_bufio_lock(c);
> -                               b->hold_count--;
> -                       } else
> -                               wait_on_bit_io(&b->state, B_WRITING,
> -                                              TASK_UNINTERRUPTIBLE);
> -               }
> +               if (nr_buffers) {
> +                       nr_buffers--;
> +                       dm_bufio_unlock(c);
> +                       wait_on_bit_io(&b->state, B_WRITING,
> TASK_UNINTERRUPTIBLE);
> +                       dm_bufio_lock(c);
> +               } else
> +                       wait_on_bit_io(&b->state, B_WRITING,
> TASK_UNINTERRUPTIBLE);
>
> -               if (!test_bit(B_DIRTY, &b->state) &&
> -                   !test_bit(B_WRITING, &b->state))
> -                       __relink_lru(b, LIST_CLEAN);
> +               if (!test_bit(B_DIRTY, &b->state) && !test_bit(B_WRITING,
> &b->state))
> +                       cache_mark(&c->cache, b, LIST_CLEAN);
> +
> +               cache_put_and_wake(c, b);
>
>                 cond_resched();
> -
> -               /*
> -                * If we dropped the lock, the list is no longer
> consistent,
> -                * so we must restart the search.
> -                *
> -                * In the most common case, the buffer just processed is
> -                * relinked to the clean list, so we won't loop scanning
> the
> -                * same buffer again and again.
> -                *
> -                * This may livelock if there is another thread
> simultaneously
> -                * dirtying buffers, so we count the number of buffers
> walked
> -                * and if it exceeds the total number of buffers, it mean=
s
> that
> -                * someone is doing some writes simultaneously with us.  =
In
> -                * this case, stop, dropping the lock.
> -                */
> -               if (dropped_lock)
> -                       goto again;
>         }
> +
> +       lru_iter_end(&it);
> +
>         wake_up(&c->free_buffer_wait);
>         dm_bufio_unlock(c);
>
> @@ -1418,12 +2172,22 @@ int dm_bufio_issue_discard(struct dm_bufio_client
> *c, sector_t block, sector_t c
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);
>
> -static void forget_buffer_locked(struct dm_buffer *b)
> +static bool forget_buffer(struct dm_bufio_client *c, sector_t block)
>  {
> -       if (likely(!b->hold_count) &&
> likely(!smp_load_acquire(&b->state))) {
> -               __unlink_buffer(b);
> -               __free_buffer_wake(b);
> +       struct dm_buffer *b;
> +
> +       b =3D cache_get(&c->cache, block);
> +       if (b) {
> +               if (likely(!smp_load_acquire(&b->state))) {
> +                       if (cache_remove(&c->cache, b))
> +                               __free_buffer_wake(b);
> +                       else
> +                               cache_put_and_wake(c, b);
> +               } else
> +                       cache_put_and_wake(c, b);
>         }
> +
> +       return b ? true : false;
>  }
>
>  /*
> @@ -1434,38 +2198,22 @@ static void forget_buffer_locked(struct dm_buffer
> *b)
>   */
>  void dm_bufio_forget(struct dm_bufio_client *c, sector_t block)
>  {
> -       struct dm_buffer *b;
> -
>         dm_bufio_lock(c);
> -
> -       b =3D __find(c, block);
> -       if (b)
> -               forget_buffer_locked(b);
> -
> +       forget_buffer(c, block);
>         dm_bufio_unlock(c);
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_forget);
>
> +static enum evict_result idle(struct dm_buffer *b, void *context)
> +{
> +       return b->state ? ER_DONT_EVICT : ER_EVICT;
> +}
> +
>  void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block,
> sector_t n_blocks)
>  {
> -       struct dm_buffer *b;
> -       sector_t end_block =3D block + n_blocks;
> -
> -       while (block < end_block) {
> -               dm_bufio_lock(c);
> -
> -               b =3D __find_next(c, block);
> -               if (b) {
> -                       block =3D b->block + 1;
> -                       forget_buffer_locked(b);
> -               }
> -
> -               dm_bufio_unlock(c);
> -
> -               if (!b)
> -                       break;
> -       }
> -
> +       dm_bufio_lock(c);
> +       cache_remove_range(&c->cache, block, block + n_blocks, idle,
> __free_buffer_wake);
> +       dm_bufio_unlock(c);
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_forget_buffers);
>
> @@ -1527,11 +2275,26 @@ struct dm_bufio_client *dm_bufio_get_client(struc=
t
> dm_buffer *b)
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_get_client);
>
> +static enum it_action warn_leak(struct dm_buffer *b, void *context)
> +{
> +       bool *warned =3D context;
> +
> +       WARN_ON(!(*warned));
> +       *warned =3D true;
> +       DMERR("leaked buffer %llx, hold count %u, list %d",
> +             (unsigned long long)b->block, atomic_read(&b->hold_count),
> b->list_mode);
> +#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
> +       stack_trace_print(b->stack_entries, b->stack_len, 1);
> +       /* mark unclaimed to avoid BUG_ON below */
> +       atomic_set(&b->hold_count, 0);
> +#endif
> +       return IT_NEXT;
> +}
> +
>  static void drop_buffers(struct dm_bufio_client *c)
>  {
> -       struct dm_buffer *b;
>         int i;
> -       bool warned =3D false;
> +       struct dm_buffer *b;
>
>         BUG_ON(dm_bufio_in_request());
>
> @@ -1545,18 +2308,11 @@ static void drop_buffers(struct dm_bufio_client *=
c)
>         while ((b =3D __get_unclaimed_buffer(c)))
>                 __free_buffer_wake(b);
>
> -       for (i =3D 0; i < LIST_SIZE; i++)
> -               list_for_each_entry(b, &c->lru[i], lru_list) {
> -                       WARN_ON(!warned);
> -                       warned =3D true;
> -                       DMERR("leaked buffer %llx, hold count %u, list %d=
",
> -                             (unsigned long long)b->block, b->hold_count=
,
> i);
> -#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
> -                       stack_trace_print(b->stack_entries, b->stack_len,
> 1);
> -                       /* mark unclaimed to avoid BUG_ON below */
> -                       b->hold_count =3D 0;
> -#endif
> -               }
> +       for (i =3D 0; i < LIST_SIZE; i++) {
> +               bool warned =3D false;
> +
> +               cache_iterate(&c->cache, i, warn_leak, &warned);
> +       }
>
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>         while ((b =3D __get_unclaimed_buffer(c)))
> @@ -1564,39 +2320,11 @@ static void drop_buffers(struct dm_bufio_client *=
c)
>  #endif
>
>         for (i =3D 0; i < LIST_SIZE; i++)
> -               BUG_ON(!list_empty(&c->lru[i]));
> +               BUG_ON(cache_count(&c->cache, i));
>
>         dm_bufio_unlock(c);
>  }
>
> -/*
> - * We may not be able to evict this buffer if IO pending or the client
> - * is still using it.  Caller is expected to know buffer is too old.
> - *
> - * And if GFP_NOFS is used, we must not do any I/O because we hold
> - * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
> - * rerouted to different bufio client.
> - */
> -static bool __try_evict_buffer(struct dm_buffer *b, gfp_t gfp)
> -{
> -       if (!(gfp & __GFP_FS) ||
> -           (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)=
)
> {
> -               if (test_bit_acquire(B_READING, &b->state) ||
> -                   test_bit(B_WRITING, &b->state) ||
> -                   test_bit(B_DIRTY, &b->state))
> -                       return false;
> -       }
> -
> -       if (b->hold_count)
> -               return false;
> -
> -       __make_buffer_clean(b);
> -       __unlink_buffer(b);
> -       __free_buffer_wake(b);
> -
> -       return true;
> -}
> -
>  static unsigned long get_retain_buffers(struct dm_bufio_client *c)
>  {
>         unsigned long retain_bytes =3D READ_ONCE(dm_bufio_retain_bytes);
> @@ -1612,22 +2340,30 @@ static unsigned long get_retain_buffers(struct
> dm_bufio_client *c)
>  static void __scan(struct dm_bufio_client *c)
>  {
>         int l;
> -       struct dm_buffer *b, *tmp;
> +       struct dm_buffer *b;
>         unsigned long freed =3D 0;
> -       unsigned long count =3D c->n_buffers[LIST_CLEAN] +
> -                             c->n_buffers[LIST_DIRTY];
>         unsigned long retain_target =3D get_retain_buffers(c);
> +       unsigned long count =3D cache_total(&c->cache);
>
>         for (l =3D 0; l < LIST_SIZE; l++) {
> -               list_for_each_entry_safe_reverse(b, tmp, &c->lru[l],
> lru_list) {
> +               while (true) {
>                         if (count - freed <=3D retain_target)
>                                 atomic_long_set(&c->need_shrink, 0);
> +
>                         if (!atomic_long_read(&c->need_shrink))
> -                               return;
> -                       if (__try_evict_buffer(b, GFP_KERNEL)) {
> -                               atomic_long_dec(&c->need_shrink);
> -                               freed++;
> -                       }
> +                               break;
> +
> +                       b =3D cache_evict(&c->cache, l,
> +                                       l =3D=3D LIST_CLEAN ? is_clean :
> is_dirty, c);
> +                       if (!b)
> +                               break;
> +
> +                       BUG_ON(b->list_mode !=3D l);
> +                       __make_buffer_clean(b);
> +                       __free_buffer_wake(b);
> +
> +                       atomic_long_dec(&c->need_shrink);
> +                       freed++;
>                         cond_resched();
>                 }
>         }
> @@ -1656,8 +2392,7 @@ static unsigned long dm_bufio_shrink_scan(struct
> shrinker *shrink, struct shrink
>  static unsigned long dm_bufio_shrink_count(struct shrinker *shrink,
> struct shrink_control *sc)
>  {
>         struct dm_bufio_client *c =3D container_of(shrink, struct
> dm_bufio_client, shrinker);
> -       unsigned long count =3D READ_ONCE(c->n_buffers[LIST_CLEAN]) +
> -                             READ_ONCE(c->n_buffers[LIST_DIRTY]);
> +       unsigned long count =3D cache_total(&c->cache);
>         unsigned long retain_target =3D get_retain_buffers(c);
>         unsigned long queued_for_cleanup =3D
> atomic_long_read(&c->need_shrink);
>
> @@ -1685,7 +2420,6 @@ struct dm_bufio_client
> *dm_bufio_client_create(struct block_device *bdev, unsign
>  {
>         int r;
>         struct dm_bufio_client *c;
> -       unsigned int i;
>         char slab_name[27];
>
>         if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
> @@ -1699,7 +2433,7 @@ struct dm_bufio_client
> *dm_bufio_client_create(struct block_device *bdev, unsign
>                 r =3D -ENOMEM;
>                 goto bad_client;
>         }
> -       c->buffer_tree =3D RB_ROOT;
> +       cache_init(&c->cache);
>
>         c->bdev =3D bdev;
>         c->block_size =3D block_size;
> @@ -1716,11 +2450,6 @@ struct dm_bufio_client
> *dm_bufio_client_create(struct block_device *bdev, unsign
>                 static_branch_inc(&no_sleep_enabled);
>         }
>
> -       for (i =3D 0; i < LIST_SIZE; i++) {
> -               INIT_LIST_HEAD(&c->lru[i]);
> -               c->n_buffers[i] =3D 0;
> -       }
> -
>         mutex_init(&c->lock);
>         spin_lock_init(&c->spinlock);
>         INIT_LIST_HEAD(&c->reserved_buffers);
> @@ -1792,9 +2521,9 @@ struct dm_bufio_client
> *dm_bufio_client_create(struct block_device *bdev, unsign
>
>  bad:
>         while (!list_empty(&c->reserved_buffers)) {
> -               struct dm_buffer *b =3D list_entry(c->reserved_buffers.ne=
xt,
> -                                                struct dm_buffer,
> lru_list);
> -               list_del(&b->lru_list);
> +               struct dm_buffer *b =3D
> list_to_buffer(c->reserved_buffers.next);
> +
> +               list_del(&b->lru.list);
>                 free_buffer(b);
>         }
>         kmem_cache_destroy(c->slab_cache);
> @@ -1831,23 +2560,23 @@ void dm_bufio_client_destroy(struct
> dm_bufio_client *c)
>
>         mutex_unlock(&dm_bufio_clients_lock);
>
> -       BUG_ON(!RB_EMPTY_ROOT(&c->buffer_tree));
>         BUG_ON(c->need_reserved_buffers);
>
>         while (!list_empty(&c->reserved_buffers)) {
> -               struct dm_buffer *b =3D list_entry(c->reserved_buffers.ne=
xt,
> -                                                struct dm_buffer,
> lru_list);
> -               list_del(&b->lru_list);
> +               struct dm_buffer *b =3D
> list_to_buffer(c->reserved_buffers.next);
> +
> +               list_del(&b->lru.list);
>                 free_buffer(b);
>         }
>
>         for (i =3D 0; i < LIST_SIZE; i++)
> -               if (c->n_buffers[i])
> -                       DMERR("leaked buffer count %d: %ld", i,
> c->n_buffers[i]);
> +               if (cache_count(&c->cache, i))
> +                       DMERR("leaked buffer count %d: %lu", i,
> cache_count(&c->cache, i));
>
>         for (i =3D 0; i < LIST_SIZE; i++)
> -               BUG_ON(c->n_buffers[i]);
> +               BUG_ON(cache_count(&c->cache, i));
>
> +       cache_destroy(&c->cache);
>         kmem_cache_destroy(c->slab_cache);
>         kmem_cache_destroy(c->slab_buffer);
>         dm_io_client_destroy(c->dm_io);
> @@ -1864,6 +2593,8 @@ void dm_bufio_set_sector_offset(struct
> dm_bufio_client *c, sector_t start)
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_set_sector_offset);
>
> +/*--------------------------------------------------------------*/
> +
>  static unsigned int get_max_age_hz(void)
>  {
>         unsigned int max_age =3D READ_ONCE(dm_bufio_max_age);
> @@ -1876,13 +2607,74 @@ static unsigned int get_max_age_hz(void)
>
>  static bool older_than(struct dm_buffer *b, unsigned long age_hz)
>  {
> -       return time_after_eq(jiffies, b->last_accessed + age_hz);
> +       return time_after_eq(jiffies, READ_ONCE(b->last_accessed) +
> age_hz);
>  }
>
> -static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long
> age_hz)
> +struct evict_params {
> +       gfp_t gfp;
> +       unsigned long age_hz;
> +
> +       /*
> +        * This gets updated with the largest last_accessed (ie. most
> +        * recently used) of the evicted buffers.  It will not be
> reinitialised
> +        * by __evict_many(), so you can use it across multiple
> invocations.
> +        */
> +       unsigned long last_accessed;
> +};
> +
> +/*
> + * We may not be able to evict this buffer if IO pending or the client
> + * is still using it.
> + *
> + * And if GFP_NOFS is used, we must not do any I/O because we hold
> + * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
> + * rerouted to different bufio client.
> + */
> +static enum evict_result select_for_evict(struct dm_buffer *b, void
> *context)
> +{
> +       struct evict_params *params =3D context;
> +
> +       if (!(params->gfp & __GFP_FS) ||
> +           (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)=
)
> {
> +               if (test_bit_acquire(B_READING, &b->state) ||
> +                   test_bit(B_WRITING, &b->state) ||
> +                   test_bit(B_DIRTY, &b->state))
> +                       return ER_DONT_EVICT;
> +       }
> +
> +       return older_than(b, params->age_hz) ? ER_EVICT : ER_STOP;
> +}
> +
> +static unsigned int __evict_many(struct dm_bufio_client *c,
> +                                struct evict_params *params,
> +                                int list_mode, unsigned int max_count)
> +{
> +       unsigned int count;
> +       unsigned long last_accessed;
> +       struct dm_buffer *b;
> +
> +       for (count =3D 0; count < max_count; count++) {
> +               b =3D cache_evict(&c->cache, list_mode, select_for_evict,
> params);
> +               if (!b)
> +                       break;
> +
> +               last_accessed =3D READ_ONCE(b->last_accessed);
> +               if (time_after_eq(params->last_accessed, last_accessed))
> +                       params->last_accessed =3D last_accessed;
> +
> +               __make_buffer_clean(b);
> +               __free_buffer_wake(b);
> +
> +               cond_resched();
> +       }
> +
> +       return count;
> +}
> +
> +static void evict_old_buffers(struct dm_bufio_client *c, unsigned long
> age_hz)
>  {
> -       struct dm_buffer *b, *tmp;
> -       unsigned long retain_target =3D get_retain_buffers(c);
> +       struct evict_params params =3D {.gfp =3D 0, .age_hz =3D age_hz,
> .last_accessed =3D 0};
> +       unsigned long retain =3D get_retain_buffers(c);
>         unsigned long count;
>         LIST_HEAD(write_list);
>
> @@ -1895,91 +2687,13 @@ static void __evict_old_buffers(struct
> dm_bufio_client *c, unsigned long age_hz)
>                 dm_bufio_lock(c);
>         }
>
> -       count =3D c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
> -       list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_CLEAN],
> lru_list) {
> -               if (count <=3D retain_target)
> -                       break;
> -
> -               if (!older_than(b, age_hz))
> -                       break;
> -
> -               if (__try_evict_buffer(b, 0))
> -                       count--;
> -
> -               cond_resched();
> -       }
> +       count =3D cache_total(&c->cache);
> +       if (count > retain)
> +               __evict_many(c, &params, LIST_CLEAN, count - retain);
>
>         dm_bufio_unlock(c);
>  }
>
> -static void do_global_cleanup(struct work_struct *w)
> -{
> -       struct dm_bufio_client *locked_client =3D NULL;
> -       struct dm_bufio_client *current_client;
> -       struct dm_buffer *b;
> -       unsigned int spinlock_hold_count;
> -       unsigned long threshold =3D dm_bufio_cache_size -
> -               dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
> -       unsigned long loops =3D global_num * 2;
> -
> -       mutex_lock(&dm_bufio_clients_lock);
> -
> -       while (1) {
> -               cond_resched();
> -
> -               spin_lock(&global_spinlock);
> -               if (unlikely(dm_bufio_current_allocated <=3D threshold))
> -                       break;
> -
> -               spinlock_hold_count =3D 0;
> -get_next:
> -               if (!loops--)
> -                       break;
> -               if (unlikely(list_empty(&global_queue)))
> -                       break;
> -               b =3D list_entry(global_queue.prev, struct dm_buffer,
> global_list);
> -
> -               if (b->accessed) {
> -                       b->accessed =3D 0;
> -                       list_move(&b->global_list, &global_queue);
> -                       if (likely(++spinlock_hold_count < 16))
> -                               goto get_next;
> -                       spin_unlock(&global_spinlock);
> -                       continue;
> -               }
> -
> -               current_client =3D b->c;
> -               if (unlikely(current_client !=3D locked_client)) {
> -                       if (locked_client)
> -                               dm_bufio_unlock(locked_client);
> -
> -                       if (!dm_bufio_trylock(current_client)) {
> -                               spin_unlock(&global_spinlock);
> -                               dm_bufio_lock(current_client);
> -                               locked_client =3D current_client;
> -                               continue;
> -                       }
> -
> -                       locked_client =3D current_client;
> -               }
> -
> -               spin_unlock(&global_spinlock);
> -
> -               if (unlikely(!__try_evict_buffer(b, GFP_KERNEL))) {
> -                       spin_lock(&global_spinlock);
> -                       list_move(&b->global_list, &global_queue);
> -                       spin_unlock(&global_spinlock);
> -               }
> -       }
> -
> -       spin_unlock(&global_spinlock);
> -
> -       if (locked_client)
> -               dm_bufio_unlock(locked_client);
> -
> -       mutex_unlock(&dm_bufio_clients_lock);
> -}
> -
>  static void cleanup_old_buffers(void)
>  {
>         unsigned long max_age_hz =3D get_max_age_hz();
> @@ -1990,7 +2704,7 @@ static void cleanup_old_buffers(void)
>         __cache_size_refresh();
>
>         list_for_each_entry(c, &dm_bufio_all_clients, client_list)
> -               __evict_old_buffers(c, max_age_hz);
> +               evict_old_buffers(c, max_age_hz);
>
>         mutex_unlock(&dm_bufio_clients_lock);
>  }
> @@ -2003,6 +2717,107 @@ static void work_fn(struct work_struct *w)
>                            DM_BUFIO_WORK_TIMER_SECS * HZ);
>  }
>
> +/*--------------------------------------------------------------*/
> +
> +/*
> + * Global cleanup tries to evict the oldest buffers from across _all_
> + * the clients.  It does this by repeatedly evicting a few buffers from
> + * the client that holds the oldest buffer.  It's approximate, but
> hopefully
> + * good enough.
> + */
> +static struct dm_bufio_client *__pop_client(void)
> +{
> +       struct list_head *h;
> +
> +       if (list_empty(&dm_bufio_all_clients))
> +               return NULL;
> +
> +       h =3D dm_bufio_all_clients.next;
> +       list_del(h);
> +       return container_of(h, struct dm_bufio_client, client_list);
> +}
> +
> +/*
> + * Inserts the client in the global client list based on its
> + * 'oldest_buffer' field.
> + */
> +static void __insert_client(struct dm_bufio_client *new_client)
> +{
> +       struct dm_bufio_client *c;
> +       struct list_head *h =3D dm_bufio_all_clients.next;
> +
> +       while (h !=3D &dm_bufio_all_clients) {
> +               c =3D container_of(h, struct dm_bufio_client, client_list=
);
> +               if (time_after_eq(c->oldest_buffer,
> new_client->oldest_buffer))
> +                       break;
> +               h =3D h->next;
> +       }
> +
> +       list_add_tail(&new_client->client_list, h);
> +}
> +
> +static unsigned int __evict_a_few(unsigned int nr_buffers)
> +{
> +       unsigned int count;
> +       struct dm_bufio_client *c;
> +       struct evict_params params =3D {
> +               .gfp =3D GFP_KERNEL,
> +               .age_hz =3D 0,
> +               /* set to jiffies in case there are no buffers in this
> client */
> +               .last_accessed =3D jiffies
> +       };
> +
> +       c =3D __pop_client();
> +       if (!c)
> +               return 0;
> +
> +       dm_bufio_lock(c);
> +       count =3D __evict_many(c, &params, LIST_CLEAN, nr_buffers);
> +       dm_bufio_unlock(c);
> +
> +       if (count)
> +               c->oldest_buffer =3D params.last_accessed;
> +       __insert_client(c);
> +
> +       return count;
> +}
> +
> +static void check_watermarks(void)
> +{
> +       LIST_HEAD(write_list);
> +       struct dm_bufio_client *c;
> +
> +       mutex_lock(&dm_bufio_clients_lock);
> +       list_for_each_entry(c, &dm_bufio_all_clients, client_list) {
> +               dm_bufio_lock(c);
> +               __check_watermark(c, &write_list);
> +               dm_bufio_unlock(c);
> +       }
> +       mutex_unlock(&dm_bufio_clients_lock);
> +
> +       __flush_write_list(&write_list);
> +}
> +
> +static void evict_old(void)
> +{
> +       unsigned long threshold =3D dm_bufio_cache_size -
> +               dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
> +
> +       mutex_lock(&dm_bufio_clients_lock);
> +       while (dm_bufio_current_allocated > threshold) {
> +               if (!__evict_a_few(64))
> +                       break;
> +               cond_resched();
> +       }
> +       mutex_unlock(&dm_bufio_clients_lock);
> +}
> +
> +static void do_global_cleanup(struct work_struct *w)
> +{
> +       check_watermarks();
> +       evict_old();
> +}
> +
>  /*
>   *--------------------------------------------------------------
>   * Module setup
> --
> 2.40.0
>
>

--00000000000082a23b05f78c8ce8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Mike,<div><br></div><div>I&#39;m Nacking this patch here.=
=C2=A0 You&#39;ve taken the comment from my latest patch, and attached it t=
o something else.=C2=A0 I don&#39;t know if you&#39;ve taken an older patch=
 and updated it, or taken the latest patch and downgraded it.</div><div><br=
></div><div>For instance the latest patch uses the name &#39;struct dm_buff=
er_cache&#39;, but it looks like you&#39;ve renamed to &#39;struct buffer_c=
ache&#39; and then posted another patch in the series that renames back to =
dm_buffer_cache.</div><div><br></div><div>I also see the comment change:</d=
iv><div><br></div><div>original &quot;A refcount_t for hold_count does not =
work.&quot; which has changed to &quot;NOTE: attempting to use refcount_t i=
nstead of atomic_t caused crashes!&quot;.=C2=A0 Talk about over dramatisati=
on (If the hold_count is incorrect we detect and BUG).</div><div><br></div>=
<div>I can&#39;t stand by my code if I don&#39;t know what&#39;s being sent=
 up in my name.</div><div><br></div><div>Please use the patchset from this =
branch:=C2=A0<a href=3D"https://github.com/jthornber/linux/tree/2023-03-21-=
thin-concurrency-8">https://github.com/jthornber/linux/tree/2023-03-21-thin=
-concurrency-8</a></div><div><br></div><div>- Joe</div><div><br></div><div>=
<br></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gm=
ail_attr">On Wed, Mar 22, 2023 at 6:19=E2=80=AFPM Mike Snitzer &lt;<a href=
=3D"mailto:snitzer@kernel.org">snitzer@kernel.org</a>&gt; wrote:<br></div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex">From: Joe Thornber &lt;<a =
href=3D"mailto:ejt@redhat.com" target=3D"_blank">ejt@redhat.com</a>&gt;<br>
<br>
When multiple threads perform IO to a thin device, the underlying<br>
dm_bufio object can become a bottleneck; slowing down access to btree<br>
nodes that store the thin metadata. Prior to this commit, each bufio<br>
instance had a single mutex that was taken for every bufio operation.<br>
<br>
This commit concentrates on improving the common case: in which a user<br>
of dm_bufio wishes to access, but not modify, a buffer which is already<br>
within the dm_bufio cache.<br>
<br>
Implementation::<br>
<br>
=C2=A0 The code has been refactored; pulling out an &#39;lru&#39; abstracti=
on and a<br>
=C2=A0 &#39;buffer cache&#39; abstraction.<br>
<br>
=C2=A0LRU:<br>
=C2=A0 A clock algorithm is used in the LRU abstraction.=C2=A0 This avoids<=
br>
=C2=A0 relinking list nodes, which would require a write lock protecting<br=
>
=C2=A0 it.<br>
<br>
=C2=A0 None of the lru methods are threadsafe; locking must be done at a<br=
>
=C2=A0 higher level.<br>
<br>
=C2=A0Buffer cache:<br>
=C2=A0 The buffer cache is responsible for managing the holder count,<br>
=C2=A0 tracking clean/dirty state, and choosing buffers via predicates.<br>
=C2=A0 Higher level code is responsible for allocation of buffers, IO and<b=
r>
=C2=A0 eviction/cache sizing.<br>
<br>
=C2=A0 The buffer cache has thread safe methods for acquiring a reference<b=
r>
=C2=A0 to an existing buffer. All other methods in buffer cache are _not_<b=
r>
=C2=A0 threadsafe, and only contain enough locking to guarantee the safe<br=
>
=C2=A0 methods.<br>
<br>
=C2=A0 Rather than a single mutex, sharded rw_semaphores are used to allow<=
br>
=C2=A0 concurrent threads to &#39;get&#39; buffers. Each rw_semaphore prote=
cts its<br>
=C2=A0 own rbtree of buffer entries.<br>
<br>
Testing::<br>
<br>
=C2=A0 Some of the low level functions have been unit tested using dm-unit:=
<br>
=C2=A0 =C2=A0 <a href=3D"https://github.com/jthornber/dm-unit/blob/main/src=
/tests/bufio.rs" rel=3D"noreferrer" target=3D"_blank">https://github.com/jt=
hornber/dm-unit/blob/main/src/tests/bufio.rs</a><br>
<br>
=C2=A0 Higher level concurrency and IO is tested via a test only target<br>
=C2=A0 found here:<br>
=C2=A0 =C2=A0 <a href=3D"https://github.com/jthornber/linux/blob/2023-02-28=
-thin-concurrency-7/drivers/md/dm-bufio-test.c" rel=3D"noreferrer" target=
=3D"_blank">https://github.com/jthornber/linux/blob/2023-02-28-thin-concurr=
ency-7/drivers/md/dm-bufio-test.c</a><br>
<br>
=C2=A0 The associated userland side of these tests is here:<br>
=C2=A0 =C2=A0 <a href=3D"https://github.com/jthornber/dmtest-python/blob/ma=
in/src/dmtest/bufio/bufio_tests.py" rel=3D"noreferrer" target=3D"_blank">ht=
tps://github.com/jthornber/dmtest-python/blob/main/src/dmtest/bufio/bufio_t=
ests.py</a><br>
<br>
=C2=A0 In addition the full dmtest suite of tests (dm-thin, dm-cache, etc)<=
br>
=C2=A0 has been run (~450 tests).<br>
<br>
Performance::<br>
<br>
=C2=A0 Most bufio operations have unchanged performance. But if multiple<br=
>
=C2=A0 threads are attempting to get buffers concurrently, and these<br>
=C2=A0 buffers are already in the cache then there&#39;s a big speed up. Eg=
,<br>
=C2=A0 one test has 16 &#39;hotspot&#39; threads simulating btree lookups w=
hile<br>
=C2=A0 another thread dirties the whole device. In this case the hotspot<br=
>
=C2=A0 threads acquire the buffers about 25 times faster.<br>
<br>
Signed-off-by: Joe Thornber &lt;<a href=3D"mailto:ejt@redhat.com" target=3D=
"_blank">ejt@redhat.com</a>&gt;<br>
Signed-off-by: Mike Snitzer &lt;<a href=3D"mailto:snitzer@kernel.org" targe=
t=3D"_blank">snitzer@kernel.org</a>&gt;<br>
---<br>
=C2=A0drivers/md/dm-bufio.c | 1769 ++++++++++++++++++++++++++++++----------=
-<br>
=C2=A01 file changed, 1292 insertions(+), 477 deletions(-)<br>
<br>
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c<br>
index 1de1bdcda1ce..56ef160331ce 100644<br>
--- a/drivers/md/dm-bufio.c<br>
+++ b/drivers/md/dm-bufio.c<br>
@@ -66,6 +66,247 @@<br>
=C2=A0#define LIST_DIRTY=C2=A0 =C2=A0 =C2=A01<br>
=C2=A0#define LIST_SIZE=C2=A0 =C2=A0 =C2=A0 2<br>
<br>
+/*--------------------------------------------------------------*/<br>
+<br>
+/*<br>
+ * Rather than use an LRU list, we use a clock algorithm where entries<br>
+ * are held in a circular list.=C2=A0 When an entry is &#39;hit&#39; a ref=
erence bit<br>
+ * is set.=C2=A0 The least recently used entry is approximated by running =
a<br>
+ * cursor around the list selecting unreferenced entries. Referenced<br>
+ * entries have their reference bit cleared as the cursor passes them.<br>
+ */<br>
+struct lru_entry {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head list;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_t referenced;<br>
+};<br>
+<br>
+struct lru_iter {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru *lru;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head list;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *stop;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *e;<br>
+};<br>
+<br>
+struct lru {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head *cursor;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long count;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head iterators;<br>
+};<br>
+<br>
+/*--------------*/<br>
+<br>
+static void lru_init(struct lru *lru)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru-&gt;cursor =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru-&gt;count =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&amp;lru-&gt;iterators);<br>
+}<br>
+<br>
+static void lru_destroy(struct lru *lru)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(lru-&gt;cursor);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!list_empty(&amp;lru-&gt;iterators));<br=
>
+}<br>
+<br>
+static inline unsigned int lru_count(struct lru *lru)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return lru-&gt;count;<br>
+}<br>
+<br>
+/*<br>
+ * Insert a new entry into the lru.<br>
+ */<br>
+static void lru_insert(struct lru *lru, struct lru_entry *le)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Don&#39;t be tempted to set to 1, makes the =
lru aspect<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * perform poorly.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_set(&amp;le-&gt;referenced, 0);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (lru-&gt;cursor)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_add_tail(&amp;=
le-&gt;list, lru-&gt;cursor);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&amp=
;le-&gt;list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru-&gt;cursor =3D =
&amp;le-&gt;list;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru-&gt;count++;<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Convert a list_head pointer to an lru_entry pointer.<br>
+ */<br>
+static inline struct lru_entry *to_le(struct list_head *l)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return container_of(l, struct lru_entry, list);=
<br>
+}<br>
+<br>
+/*<br>
+ * Initialize an lru_iter and add it to the list of cursors in the lru.<br=
>
+ */<br>
+static void lru_iter_begin(struct lru *lru, struct lru_iter *it)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0it-&gt;lru =3D lru;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0it-&gt;stop =3D lru-&gt;cursor ? to_le(lru-&gt;=
cursor-&gt;prev) : NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0it-&gt;e =3D lru-&gt;cursor ? to_le(lru-&gt;cur=
sor) : NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_add(&amp;it-&gt;list, &amp;lru-&gt;iterato=
rs);<br>
+}<br>
+<br>
+/*<br>
+ * Remove an lru_iter from the list of cursors in the lru.<br>
+ */<br>
+static void lru_iter_end(struct lru_iter *it)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;it-&gt;list);<br>
+}<br>
+<br>
+/* Predicate function type to be used with lru_iter_next */<br>
+typedef bool (*iter_predicate)(struct lru_entry *le, void *context);<br>
+<br>
+/*<br>
+ * Advance the cursor to the next entry that passes the<br>
+ * predicate, and return that entry.=C2=A0 Returns NULL if the<br>
+ * iteration is complete.<br>
+ */<br>
+static struct lru_entry *lru_iter_next(struct lru_iter *it,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iter_predicate =
pred, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *e;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (it-&gt;e) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0e =3D it-&gt;e;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* advance the curs=
or */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (it-&gt;e =3D=3D=
 it-&gt;stop)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0it-&gt;e =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0it-&gt;e =3D to_le(it-&gt;e-&gt;list.next);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pred(e, context=
))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return e;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+}<br>
+<br>
+/*<br>
+ * Invalidate a specific lru_entry and update all cursors in<br>
+ * the lru accordingly.<br>
+ */<br>
+static void lru_iter_invalidate(struct lru *lru, struct lru_entry *e)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_iter *it;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry(it, &amp;lru-&gt;iterators,=
 list) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Move c-&gt;e for=
wards if necc. */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (it-&gt;e =3D=3D=
 e) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0it-&gt;e =3D to_le(it-&gt;e-&gt;list.next);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (it-&gt;e =3D=3D e)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0it-&gt;e =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Move it-&gt;stop=
 backwards if necc. */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (it-&gt;stop =3D=
=3D e) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0it-&gt;stop =3D to_le(it-&gt;stop-&gt;list.prev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (it-&gt;stop =3D=3D e)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0it-&gt;stop =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Remove a specific entry from the lru.<br>
+ */<br>
+static void lru_remove(struct lru *lru, struct lru_entry *le)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru_iter_invalidate(lru, le);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (lru-&gt;count =3D=3D 1)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru-&gt;cursor =3D =
NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (lru-&gt;cursor =
=3D=3D &amp;le-&gt;list)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0lru-&gt;cursor =3D lru-&gt;cursor-&gt;next;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;le-&g=
t;list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru-&gt;count--;<br>
+}<br>
+<br>
+/*<br>
+ * Mark as referenced.<br>
+ */<br>
+static inline void lru_reference(struct lru_entry *le)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_set(&amp;le-&gt;referenced, 1);<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Remove the least recently used entry (approx), that passes the predicat=
e.<br>
+ * Returns NULL on failure.<br>
+ */<br>
+enum evict_result {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ER_EVICT,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ER_DONT_EVICT,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ER_STOP, /* stop looking for something to evict=
 */<br>
+};<br>
+<br>
+typedef enum evict_result (*le_predicate)(struct lru_entry *le, void *cont=
ext);<br>
+<br>
+static struct lru_entry *lru_evict(struct lru *lru, le_predicate pred, voi=
d *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int tested =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head *h =3D lru-&gt;cursor;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *le;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!h)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * In the worst case we have to loop around twi=
ce. Once to clear<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * the reference flags, and then again to disco=
ver the predicate<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * fails for all entries.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (tested &lt; lru-&gt;count) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0le =3D container_of=
(h, struct lru_entry, list);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_read(&am=
p;le-&gt;referenced))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0atomic_set(&amp;le-&gt;referenced, 0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0tested++;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0switch (pred(le, context)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0case ER_EVICT:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Adjust the cursor, so we start the=
 next<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * search from here.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru-&gt;cursor =3D le-&gt;list.next;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru_remove(lru, le);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return le;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0case ER_DONT_EVICT:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0case ER_STOP:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru-&gt;cursor =3D le-&gt;list.next;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0h =3D h-&gt;next;<b=
r>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+}<br>
+<br>
+/*--------------------------------------------------------------*/<br>
+<br>
=C2=A0/*<br>
=C2=A0 * Buffer state bits.<br>
=C2=A0 */<br>
@@ -86,28 +327,37 @@ enum data_mode {<br>
=C2=A0};<br>
<br>
=C2=A0struct dm_buffer {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* protected by the locks in buffer_cache */<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct rb_node node;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head lru_list;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head global_list;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* immutable, so don&#39;t need protecting */<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sector_t block;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 void *data;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char data_mode;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* DATA_MODE_* */<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int accessed;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int hold_count;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * These two fields are used in isolation, so d=
o not need<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * a surrounding lock. NOTE: attempting to use =
refcount_t<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * instead of atomic_t caused crashes!<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_t hold_count;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long last_accessed;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Everything else is protected by the mutex in=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * dm_bufio_client<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long state;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry lru;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned char list_mode;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* LIST_* */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 blk_status_t read_error;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 blk_status_t write_error;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long state;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dirty_start;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dirty_end;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int write_start;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int write_end;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct list_head write_list;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 void (*end_io)(struct dm_buffer *b, blk_status_=
t bs);<br>
=C2=A0#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING<br>
=C2=A0#define MAX_STACK 10<br>
@@ -116,9 +366,579 @@ struct dm_buffer {<br>
=C2=A0#endif<br>
=C2=A0};<br>
<br>
+/*--------------------------------------------------------------*/<br>
+<br>
+/*<br>
+ * The buffer cache manages buffers, particularly:<br>
+ *=C2=A0 - inc/dec of holder count<br>
+ *=C2=A0 - setting the last_accessed field<br>
+ *=C2=A0 - maintains clean/dirty state along with lru<br>
+ *=C2=A0 - selecting buffers that match predicates<br>
+ *<br>
+ * It does *not* handle:<br>
+ *=C2=A0 - allocation/freeing of buffers.<br>
+ *=C2=A0 - IO<br>
+ *=C2=A0 - Eviction or cache sizing.<br>
+ *<br>
+ * cache_get() and cache_put() are threadsafe, you do not need to<br>
+ * protect these calls with a surrounding mutex.=C2=A0 All the other<br>
+ * methods are not threadsafe; they do use locking primitives, but<br>
+ * only enough to ensure get/put are threadsafe.<br>
+ */<br>
+<br>
+#define NR_LOCKS 64<br>
+#define LOCKS_MASK (NR_LOCKS - 1)<br>
+<br>
+struct tree_lock {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rw_semaphore lock;<br>
+} ____cacheline_aligned_in_smp;<br>
+<br>
+struct buffer_cache {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * We spread entries across multiple trees to r=
educe contention<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * on the locks.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tree_lock locks[NR_LOCKS];<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_root roots[NR_LOCKS];<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru lru[LIST_SIZE];<br>
+};<br>
+<br>
+/*<br>
+ * We want to scatter the buffers across the different rbtrees<br>
+ * to improve concurrency, but we also want to encourage the<br>
+ * lock_history optimisation (below). Scattering runs of 16<br>
+ * buffers seems to be a good compromise.<br>
+ */<br>
+static inline unsigned int cache_index(sector_t block)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return block &amp; LOCKS_MASK;<br>
+}<br>
+<br>
+static inline void cache_read_lock(struct buffer_cache *bc, sector_t block=
)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0down_read(&amp;bc-&gt;locks[cache_index(block)]=
.lock);<br>
+}<br>
+<br>
+static inline void cache_read_unlock(struct buffer_cache *bc, sector_t blo=
ck)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0up_read(&amp;bc-&gt;locks[cache_index(block)].l=
ock);<br>
+}<br>
+<br>
+static inline void cache_write_lock(struct buffer_cache *bc, sector_t bloc=
k)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0down_write(&amp;bc-&gt;locks[cache_index(block)=
].lock);<br>
+}<br>
+<br>
+static inline void cache_write_unlock(struct buffer_cache *bc, sector_t bl=
ock)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0up_write(&amp;bc-&gt;locks[cache_index(block)].=
lock);<br>
+}<br>
+<br>
+/*<br>
+ * Sometimes we want to repeatedly get and drop locks as part of an iterat=
ion.<br>
+ * This struct helps avoid redundant drop and gets of the same lock.<br>
+ */<br>
+struct lock_history {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct buffer_cache *cache;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool write;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int previous;<br>
+};<br>
+<br>
+static void lh_init(struct lock_history *lh, struct buffer_cache *cache, b=
ool write)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh-&gt;cache =3D cache;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh-&gt;write =3D write;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh-&gt;previous =3D NR_LOCKS;=C2=A0 /* indicate=
s no previous */<br>
+}<br>
+<br>
+static void __lh_lock(struct lock_history *lh, unsigned int index)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (lh-&gt;write)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0down_write(&amp;lh-=
&gt;cache-&gt;locks[index].lock);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0down_read(&amp;lh-&=
gt;cache-&gt;locks[index].lock);<br>
+}<br>
+<br>
+static void __lh_unlock(struct lock_history *lh, unsigned int index)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (lh-&gt;write)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0up_write(&amp;lh-&g=
t;cache-&gt;locks[index].lock);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0up_read(&amp;lh-&gt=
;cache-&gt;locks[index].lock);<br>
+}<br>
+<br>
+/*<br>
+ * Make sure you call this since it will unlock the final lock.<br>
+ */<br>
+static void lh_exit(struct lock_history *lh)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (lh-&gt;previous !=3D NR_LOCKS) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__lh_unlock(lh, lh-=
&gt;previous);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lh-&gt;previous =3D=
 NR_LOCKS;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+/*<br>
+ * Named &#39;next&#39; because there is no corresponding<br>
+ * &#39;up/unlock&#39; call since it&#39;s done automatically.<br>
+ */<br>
+static void lh_next(struct lock_history *lh, sector_t b)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int index =3D cache_index(b);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (lh-&gt;previous !=3D NR_LOCKS) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (lh-&gt;previous=
 !=3D index) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__lh_unlock(lh, lh-&gt;previous);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__lh_lock(lh, index);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0lh-&gt;previous =3D index;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__lh_lock(lh, index=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lh-&gt;previous =3D=
 index;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+static struct dm_buffer *le_to_buffer(struct lru_entry *le)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return container_of(le, struct dm_buffer, lru);=
<br>
+}<br>
+<br>
+static struct dm_buffer *list_to_buffer(struct list_head *l)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *le =3D list_entry(l, struct l=
ru_entry, list);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!le)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return le_to_buffer(le);<br>
+}<br>
+<br>
+static void cache_init(struct buffer_cache *bc)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int i;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; NR_LOCKS; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0init_rwsem(&amp;bc-=
&gt;locks[i].lock);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bc-&gt;roots[i] =3D=
 RB_ROOT;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru_init(&amp;bc-&gt;lru[LIST_CLEAN]);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru_init(&amp;bc-&gt;lru[LIST_DIRTY]);<br>
+}<br>
+<br>
+static void cache_destroy(struct buffer_cache *bc)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int i;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; NR_LOCKS; i++)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!RB_EMPTY_RO=
OT(&amp;bc-&gt;roots[i]));<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru_destroy(&amp;bc-&gt;lru[LIST_CLEAN]);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru_destroy(&amp;bc-&gt;lru[LIST_DIRTY]);<br>
+}<br>
+<br>
+/*<br>
+ * not threadsafe, or racey depending how you look at it<br>
+ */<br>
+static unsigned long cache_count(struct buffer_cache *bc, int list_mode)<b=
r>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return lru_count(&amp;bc-&gt;lru[list_mode]);<b=
r>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * not threadsafe<br>
+ */<br>
+static unsigned long cache_total(struct buffer_cache *bc)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return lru_count(&amp;bc-&gt;lru[LIST_CLEAN]) +=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru_count(&amp;bc-&=
gt;lru[LIST_DIRTY]);<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Gets a specific buffer, indexed by block.<br>
+ * If the buffer is found then its holder count will be incremented and<br=
>
+ * lru_reference will be called.<br>
+ *<br>
+ * threadsafe<br>
+ */<br>
+static struct dm_buffer *__cache_get(const struct rb_root *root, sector_t =
block)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_node *n =3D root-&gt;rb_node;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (n) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D container_of(=
n, struct dm_buffer, node);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (b-&gt;block =3D=
=3D block)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return b;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0n =3D block &lt; b-=
&gt;block ? n-&gt;rb_left : n-&gt;rb_right;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+}<br>
+<br>
+static void __cache_inc_buffer(struct dm_buffer *b)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_inc(&amp;b-&gt;hold_count);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0WRITE_ONCE(b-&gt;last_accessed, jiffies);<br>
+}<br>
+<br>
+static struct dm_buffer *cache_get(struct buffer_cache *bc, sector_t block=
)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_read_lock(bc, block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __cache_get(&amp;bc-&gt;roots[cache_index=
(block)], block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru_reference(&amp;=
b-&gt;lru);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__cache_inc_buffer(=
b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_read_unlock(bc, block);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return b;<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Returns true if the hold count hits zero.<br>
+ * threadsafe<br>
+ */<br>
+static bool cache_put(struct buffer_cache *bc, struct dm_buffer *b)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool r;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_read_lock(bc, b-&gt;block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!atomic_read(&amp;b-&gt;hold_count));<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D atomic_dec_and_test(&amp;b-&gt;hold_count=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_read_unlock(bc, b-&gt;block);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+typedef enum evict_result (*b_predicate)(struct dm_buffer *, void *);<br>
+<br>
+/*<br>
+ * Evicts a buffer based on a predicate.=C2=A0 The oldest buffer that<br>
+ * matches the predicate will be selected.=C2=A0 In addition to the<br>
+ * predicate the hold_count of the selected buffer will be zero.<br>
+ */<br>
+struct evict_wrapper {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lock_history *lh;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b_predicate pred;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0void *context;<br>
+};<br>
+<br>
+/*<br>
+ * Wraps the buffer predicate turning it into an lru predicate.=C2=A0 Adds=
<br>
+ * extra test for hold_count.<br>
+ */<br>
+static enum evict_result __evict_pred(struct lru_entry *le, void *context)=
<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct evict_wrapper *w =3D context;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b =3D le_to_buffer(le);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh_next(w-&gt;lh, b-&gt;block);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_read(&amp;b-&gt;hold_count))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ER_DONT_EVIC=
T;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return w-&gt;pred(b, w-&gt;context);<br>
+}<br>
+<br>
+static struct dm_buffer *__cache_evict(struct buffer_cache *bc, int list_m=
ode,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b_predicate pre=
d, void *context,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct lock_his=
tory *lh)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct evict_wrapper w =3D {.lh =3D lh, .pred =
=3D pred, .context =3D context};<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *le;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0le =3D lru_evict(&amp;bc-&gt;lru[list_mode], __=
evict_pred, &amp;w);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!le)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D le_to_buffer(le);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* __evict_pred will have locked the appropriat=
e tree. */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0rb_erase(&amp;b-&gt;node, &amp;bc-&gt;roots[cac=
he_index(b-&gt;block)]);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return b;<br>
+}<br>
+<br>
+static struct dm_buffer *cache_evict(struct buffer_cache *bc, int list_mod=
e,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b_predicate pred, void=
 *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lock_history lh;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh_init(&amp;lh, bc, true);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __cache_evict(bc, list_mode, pred, contex=
t, &amp;lh);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh_exit(&amp;lh);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return b;<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Mark a buffer as clean or dirty. Not threadsafe.<br>
+ */<br>
+static void cache_mark(struct buffer_cache *bc, struct dm_buffer *b, int l=
ist_mode)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_write_lock(bc, b-&gt;block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (list_mode !=3D b-&gt;list_mode) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru_remove(&amp;bc-=
&gt;lru[b-&gt;list_mode], &amp;b-&gt;lru);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;list_mode =3D=
 list_mode;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru_insert(&amp;bc-=
&gt;lru[b-&gt;list_mode], &amp;b-&gt;lru);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_write_unlock(bc, b-&gt;block);<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Runs through the lru associated with &#39;old_mode&#39;, if the predica=
te matches then<br>
+ * it moves them to &#39;new_mode&#39;.=C2=A0 Not threadsafe.<br>
+ */<br>
+static void __cache_mark_many(struct buffer_cache *bc, int old_mode, int n=
ew_mode,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b_predicate pred, void *context, struct lock=
_history *lh)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *le;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct evict_wrapper w =3D {.lh =3D lh, .pred =
=3D pred, .context =3D context};<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (true) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0le =3D lru_evict(&a=
mp;bc-&gt;lru[old_mode], __evict_pred, &amp;w);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!le)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D le_to_buffer(=
le);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;list_mode =3D=
 new_mode;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru_insert(&amp;bc-=
&gt;lru[b-&gt;list_mode], &amp;b-&gt;lru);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+static void cache_mark_many(struct buffer_cache *bc, int old_mode, int new=
_mode,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0b_predicate pred, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lock_history lh;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh_init(&amp;lh, bc, true);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0__cache_mark_many(bc, old_mode, new_mode, pred,=
 context, &amp;lh);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh_exit(&amp;lh);<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Iterates through all clean or dirty entries calling a function for each=
<br>
+ * entry.=C2=A0 The callback may terminate the iteration early.=C2=A0 Not =
threadsafe.<br>
+ */<br>
+<br>
+/*<br>
+ * Iterator functions should return one of these actions to indicate<br>
+ * how the iteration should proceed.<br>
+ */<br>
+enum it_action {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0IT_NEXT,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0IT_COMPLETE,<br>
+};<br>
+<br>
+typedef enum it_action (*iter_fn)(struct dm_buffer *b, void *context);<br>
+<br>
+static void __cache_iterate(struct buffer_cache *bc, int list_mode,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0iter_fn fn, void *context, struct lock_history *lh)=
<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru *lru =3D &amp;bc-&gt;lru[list_mode];=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *le, *first;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!lru-&gt;cursor)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0first =3D le =3D to_le(lru-&gt;cursor);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0do {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b=
 =3D le_to_buffer(le);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lh_next(lh, b-&gt;b=
lock);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (fn(b, conte=
xt)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case IT_NEXT:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case IT_COMPLETE:<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0le =3D to_le(le-&gt=
;list.next);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0} while (le !=3D first);<br>
+}<br>
+<br>
+static void cache_iterate(struct buffer_cache *bc, int list_mode,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0iter_fn fn, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lock_history lh;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh_init(&amp;lh, bc, false);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0__cache_iterate(bc, list_mode, fn, context, &am=
p;lh);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lh_exit(&amp;lh);<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Passes ownership of the buffer to the cache. Returns false if the<br>
+ * buffer was already present (in which case ownership does not pass).<br>
+ * eg, a race with another thread.<br>
+ *<br>
+ * Holder count should be 1 on insertion.<br>
+ *<br>
+ * Not threadsafe.<br>
+ */<br>
+static bool __cache_insert(struct rb_root *root, struct dm_buffer *b)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_node **new =3D &amp;root-&gt;rb_node,=
 *parent =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *found;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (*new) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0found =3D container=
_of(*new, struct dm_buffer, node);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (found-&gt;block=
 =3D=3D b-&gt;block)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return false;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0parent =3D *new;<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0new =3D b-&gt;block=
 &lt; found-&gt;block ?<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0&amp;found-&gt;node.rb_left : &amp;found-&gt;node.rb_right;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0rb_link_node(&amp;b-&gt;node, parent, new);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0rb_insert_color(&amp;b-&gt;node, root);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+}<br>
+<br>
+static bool cache_insert(struct buffer_cache *bc, struct dm_buffer *b)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool r;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(b-&gt;list_mode &gt;=3D LIST_SIZE);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_write_lock(bc, b-&gt;block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(atomic_read(&amp;b-&gt;hold_count) !=3D =
1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D __cache_insert(&amp;bc-&gt;roots[cache_in=
dex(b-&gt;block)], b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (r)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru_insert(&amp;bc-=
&gt;lru[b-&gt;list_mode], &amp;b-&gt;lru);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_write_unlock(bc, b-&gt;block);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+/*<br>
+ * Removes buffer from cache, ownership of the buffer passes back to the c=
aller.<br>
+ * Fails if the hold_count is not one (ie. the caller holds the only refer=
ence).<br>
+ *<br>
+ * Not threadsafe.<br>
+ */<br>
+static bool cache_remove(struct buffer_cache *bc, struct dm_buffer *b)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool r;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_write_lock(bc, b-&gt;block);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_read(&amp;b-&gt;hold_count) !=3D 1)<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D false;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rb_erase(&amp;b-&gt=
;node, &amp;bc-&gt;roots[cache_index(b-&gt;block)]);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lru_remove(&amp;bc-=
&gt;lru[b-&gt;list_mode], &amp;b-&gt;lru);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_write_unlock(bc, b-&gt;block);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
+}<br>
+<br>
+/*--------------*/<br>
+<br>
+typedef void (*b_release)(struct dm_buffer *);<br>
+<br>
+static struct dm_buffer *__find_next(struct rb_root *root, sector_t block)=
<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_node *n =3D root-&gt;rb_node;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *best =3D NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (n) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D container_of(=
n, struct dm_buffer, node);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (b-&gt;block =3D=
=3D block)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return b;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (block &lt;=3D b=
-&gt;block) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0n =3D n-&gt;rb_left;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0best =3D b;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0n =3D n-&gt;rb_right;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return best;<br>
+}<br>
+<br>
+static void __remove_range(struct buffer_cache *bc,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 struct rb_root *root,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 sector_t begin, sector_t end,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 b_predicate pred, b_release release)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (true) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __find_next(r=
oot, begin);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!b || (b-&gt;bl=
ock &gt;=3D end))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0begin =3D b-&gt;blo=
ck + 1;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_read(&am=
p;b-&gt;hold_count))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pred(b, NULL) =
=3D=3D ER_EVICT) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0rb_erase(&amp;b-&gt;node, root);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0lru_remove(&amp;bc-&gt;lru[b-&gt;list_mode], &amp;b-&gt;lru);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0release(b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+static void cache_remove_range(struct buffer_cache *bc,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sector_t begin, sector_t end,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b_predicate pred, b_release release)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int i;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; NR_LOCKS; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0down_write(&amp;bc-=
&gt;locks[i].lock);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__remove_range(bc, =
&amp;bc-&gt;roots[i], begin, end, pred, release);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0up_write(&amp;bc-&g=
t;locks[i].lock);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+/*----------------------------------------------------------------*/<br>
+<br>
=C2=A0/*<br>
=C2=A0 * Linking of buffers:<br>
- *=C2=A0 =C2=A0 =C2=A0All buffers are linked to buffer_tree with their nod=
e field.<br>
+ *=C2=A0 =C2=A0 =C2=A0All buffers are linked to buffer_cache with their no=
de field.<br>
=C2=A0 *<br>
=C2=A0 *=C2=A0 =C2=A0 =C2=A0Clean buffers that are not being written (B_WRI=
TING not set)<br>
=C2=A0 *=C2=A0 =C2=A0 =C2=A0are linked to lru[LIST_CLEAN] with their lru_li=
st field.<br>
@@ -136,9 +956,6 @@ struct dm_bufio_client {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 spinlock_t spinlock;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 bool no_sleep;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head lru[LIST_SIZE];<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long n_buffers[LIST_SIZE];<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct block_device *bdev;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int block_size;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 s8 sectors_per_block_bits;<br>
@@ -153,7 +970,7 @@ struct dm_bufio_client {<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int minimum_buffers;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_root buffer_tree;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct buffer_cache cache;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_queue_head_t free_buffer_wait;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sector_t start;<br>
@@ -165,6 +982,11 @@ struct dm_bufio_client {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct shrinker shrinker;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct work_struct shrink_work;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_long_t need_shrink;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Used by global_cleanup to sort the clients l=
ist.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long oldest_buffer;<br>
=C2=A0};<br>
<br>
=C2=A0static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);<br>
@@ -181,14 +1003,6 @@ static void dm_bufio_lock(struct dm_bufio_client *c)<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_lock_nested(&=
amp;c-&gt;lock, dm_bufio_in_request());<br>
=C2=A0}<br>
<br>
-static int dm_bufio_trylock(struct dm_bufio_client *c)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (static_branch_unlikely(&amp;no_sleep_enable=
d) &amp;&amp; c-&gt;no_sleep)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return spin_trylock=
_bh(&amp;c-&gt;spinlock);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return mutex_tryloc=
k(&amp;c-&gt;lock);<br>
-}<br>
-<br>
=C2=A0static void dm_bufio_unlock(struct dm_bufio_client *c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (static_branch_unlikely(&amp;no_sleep_enable=
d) &amp;&amp; c-&gt;no_sleep)<br>
@@ -217,10 +1031,6 @@ static unsigned long dm_bufio_cache_size_latch;<br>
<br>
=C2=A0static DEFINE_SPINLOCK(global_spinlock);<br>
<br>
-static LIST_HEAD(global_queue);<br>
-<br>
-static unsigned long global_num;<br>
-<br>
=C2=A0/*<br>
=C2=A0 * Buffers are freed after this timeout<br>
=C2=A0 */<br>
@@ -254,7 +1064,6 @@ static struct workqueue_struct *dm_bufio_wq;<br>
=C2=A0static struct delayed_work dm_bufio_cleanup_old_work;<br>
=C2=A0static struct work_struct dm_bufio_replacement_work;<br>
<br>
-<br>
=C2=A0#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING<br>
=C2=A0static void buffer_record_stack(struct dm_buffer *b)<br>
=C2=A0{<br>
@@ -262,78 +1071,6 @@ static void buffer_record_stack(struct dm_buffer *b)<=
br>
=C2=A0}<br>
=C2=A0#endif<br>
<br>
-/*<br>
- *----------------------------------------------------------------<br>
- * A red/black tree acts as an index for all the buffers.<br>
- *----------------------------------------------------------------<br>
- */<br>
-static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t block)=
<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_node *n =3D c-&gt;buffer_tree.rb_node=
;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0while (n) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D container_of(=
n, struct dm_buffer, node);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (b-&gt;block =3D=
=3D block)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return b;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0n =3D block &lt; b-=
&gt;block ? n-&gt;rb_left : n-&gt;rb_right;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
-}<br>
-<br>
-static struct dm_buffer *__find_next(struct dm_bufio_client *c, sector_t b=
lock)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_node *n =3D c-&gt;buffer_tree.rb_node=
;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *best =3D NULL;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0while (n) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D container_of(=
n, struct dm_buffer, node);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (b-&gt;block =3D=
=3D block)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return b;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (block &lt;=3D b=
-&gt;block) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0n =3D n-&gt;rb_left;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0best =3D b;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0n =3D n-&gt;rb_right;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return best;<br>
-}<br>
-<br>
-static void __insert(struct dm_bufio_client *c, struct dm_buffer *b)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_node **new =3D &amp;c-&gt;buffer_tree=
.rb_node, *parent =3D NULL;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *found;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0while (*new) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0found =3D container=
_of(*new, struct dm_buffer, node);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (found-&gt;block=
 =3D=3D b-&gt;block) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0BUG_ON(found !=3D b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0parent =3D *new;<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0new =3D b-&gt;block=
 &lt; found-&gt;block ?<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0&amp;found-&gt;node.rb_left : &amp;found-&gt;node.rb_right;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0rb_link_node(&amp;b-&gt;node, parent, new);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0rb_insert_color(&amp;b-&gt;node, &amp;c-&gt;buf=
fer_tree);<br>
-}<br>
-<br>
-static void __remove(struct dm_bufio_client *c, struct dm_buffer *b)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0rb_erase(&amp;b-&gt;node, &amp;c-&gt;buffer_tre=
e);<br>
-}<br>
-<br>
=C2=A0/*----------------------------------------------------------------*/<=
br>
<br>
=C2=A0static void adjust_total_allocated(struct dm_buffer *b, bool unlink)<=
br>
@@ -361,16 +1098,9 @@ static void adjust_total_allocated(struct dm_buffer *=
b, bool unlink)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_bufio_current_allocated &gt; dm_bufio_pe=
ak_allocated)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_peak_alloc=
ated =3D dm_bufio_current_allocated;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;accessed =3D 1;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!unlink) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_add(&amp;b-&gt=
;global_list, &amp;global_queue);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0global_num++;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_bufio_curren=
t_allocated &gt; dm_bufio_cache_size)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 queue_work(dm_bufio_wq, &amp;dm_bufio_replacement_work);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;b-&gt=
;global_list);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0global_num--;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&amp;global_spinlock);<br>
@@ -486,8 +1216,9 @@ static void free_buffer_data(struct dm_bufio_client *c=
,<br>
=C2=A0 */<br>
=C2=A0static struct dm_buffer *alloc_buffer(struct dm_bufio_client *c, gfp_=
t gfp_mask)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b =3D kmem_cache_alloc(c-&gt;=
slab_buffer, gfp_mask);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D kmem_cache_alloc(c-&gt;slab_buffer, gfp_m=
ask);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!b)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
<br>
@@ -498,6 +1229,7 @@ static struct dm_buffer *alloc_buffer(struct dm_bufio_=
client *c, gfp_t gfp_mask)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kmem_cache_free(c-&=
gt;slab_buffer, b);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0adjust_total_allocated(b, false);<br>
<br>
=C2=A0#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 b-&gt;stack_len =3D 0;<br>
@@ -512,61 +1244,11 @@ static void free_buffer(struct dm_buffer *b)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_bufio_client *c =3D b-&gt;c;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0adjust_total_allocated(b, true);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 free_buffer_data(c, b-&gt;data, b-&gt;data_mode=
);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 kmem_cache_free(c-&gt;slab_buffer, b);<br>
=C2=A0}<br>
<br>
-/*<br>
- * Link buffer to the buffer tree and clean or dirty queue.<br>
- */<br>
-static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty)<=
br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c =3D b-&gt;c;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;n_buffers[dirty]++;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;block =3D block;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;list_mode =3D dirty;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0list_add(&amp;b-&gt;lru_list, &amp;c-&gt;lru[di=
rty]);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0__insert(b-&gt;c, b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;last_accessed =3D jiffies;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0adjust_total_allocated(b, false);<br>
-}<br>
-<br>
-/*<br>
- * Unlink buffer from the buffer tree and dirty or clean queue.<br>
- */<br>
-static void __unlink_buffer(struct dm_buffer *b)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c =3D b-&gt;c;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!c-&gt;n_buffers[b-&gt;list_mode]);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;n_buffers[b-&gt;list_mode]--;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0__remove(b-&gt;c, b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;b-&gt;lru_list);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0adjust_total_allocated(b, true);<br>
-}<br>
-<br>
-/*<br>
- * Place the buffer to the head of dirty or clean LRU queue.<br>
- */<br>
-static void __relink_lru(struct dm_buffer *b, int dirty)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c =3D b-&gt;c;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;accessed =3D 1;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!c-&gt;n_buffers[b-&gt;list_mode]);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;n_buffers[b-&gt;list_mode]--;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;n_buffers[dirty]++;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;list_mode =3D dirty;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0list_move(&amp;b-&gt;lru_list, &amp;c-&gt;lru[d=
irty]);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;last_accessed =3D jiffies;<br>
-}<br>
-<br>
=C2=A0/*<br>
=C2=A0 *-------------------------------------------------------------------=
-------<br>
=C2=A0 * Submit I/O on the buffer.<br>
@@ -806,7 +1488,7 @@ static void __flush_write_list(struct list_head *write=
_list)<br>
=C2=A0 */<br>
=C2=A0static void __make_buffer_clean(struct dm_buffer *b)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(b-&gt;hold_count);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(atomic_read(&amp;b-&gt;hold_count));<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* smp_load_acquire() pairs with read_endio()&#=
39;s smp_mb__before_atomic() */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!smp_load_acquire(&amp;b-&gt;state))=C2=A0 =
=C2=A0 =C2=A0 =C2=A0/* fast case */<br>
@@ -817,6 +1499,26 @@ static void __make_buffer_clean(struct dm_buffer *b)<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_on_bit_io(&amp;b-&gt;state, B_WRITING, TAS=
K_UNINTERRUPTIBLE);<br>
=C2=A0}<br>
<br>
+static enum evict_result is_clean(struct dm_buffer *b, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c =3D context;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_bit(B_WRITING, &amp;b-&gt;state));<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_bit(B_DIRTY, &amp;b-&gt;state));<br=
>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (static_branch_unlikely(&amp;no_sleep_enable=
d) &amp;&amp; c-&gt;no_sleep &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unlikely(test_bit(B_READING, &amp=
;b-&gt;state)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ER_DONT_EVIC=
T;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ER_EVICT;<br>
+}<br>
+<br>
+static enum evict_result is_dirty(struct dm_buffer *b, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_bit(B_READING, &amp;b-&gt;state));<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ER_EVICT;<br>
+}<br>
+<br>
=C2=A0/*<br>
=C2=A0 * Find some buffer that is not held by anybody, clean it, unlink it =
and<br>
=C2=A0 * return it.<br>
@@ -825,34 +1527,20 @@ static struct dm_buffer *__get_unclaimed_buffer(stru=
ct dm_bufio_client *c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_buffer *b;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_reverse(b, &amp;c-&gt;lru[L=
IST_CLEAN], lru_list) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_bit(B_W=
RITING, &amp;b-&gt;state));<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_bit(B_D=
IRTY, &amp;b-&gt;state));<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (static_branch_u=
nlikely(&amp;no_sleep_enabled) &amp;&amp; c-&gt;no_sleep &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unlik=
ely(test_bit_acquire(B_READING, &amp;b-&gt;state)))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!b-&gt;hold_cou=
nt) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__make_buffer_clean(b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__unlink_buffer(b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return b;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D cache_evict(&amp;c-&gt;cache, LIST_CLEAN,=
 is_clean, c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* this also waits =
for pending reads */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__make_buffer_clean=
(b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return b;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (static_branch_unlikely(&amp;no_sleep_enable=
d) &amp;&amp; c-&gt;no_sleep)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_reverse(b, &amp;c-&gt;lru[L=
IST_DIRTY], lru_list) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_bit(B_R=
EADING, &amp;b-&gt;state));<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!b-&gt;hold_cou=
nt) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__make_buffer_clean(b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__unlink_buffer(b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return b;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D cache_evict(&amp;c-&gt;cache, LIST_DIRTY,=
 is_dirty, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__make_buffer_clean=
(b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return b;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
@@ -873,7 +1561,12 @@ static void __wait_for_free_buffer(struct dm_bufio_cl=
ient *c)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 set_current_state(TASK_UNINTERRUPTIBLE);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_unlock(c);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0io_schedule();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * It&#39;s possible to miss a wake up event si=
nce we don&#39;t always<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * hold c-&gt;lock when wake_up is called.=C2=
=A0 So we have a timeout here,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * just in case.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0io_schedule_timeout(5 * HZ);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 remove_wait_queue(&amp;c-&gt;free_buffer_wait, =
&amp;wait);<br>
<br>
@@ -931,9 +1624,8 @@ static struct dm_buffer *__alloc_buffer_wait_no_callba=
ck(struct dm_bufio_client<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!list_empty(&am=
p;c-&gt;reserved_buffers)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0b =3D list_entry(c-&gt;reserved_buffers.next,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_buffe=
r, lru_list);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0list_del(&amp;b-&gt;lru_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0b =3D list_to_buffer(c-&gt;reserved_buffers.next);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0list_del(&amp;b-&gt;lru.list);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 c-&gt;need_reserved_buffers++;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return b;<br>
@@ -967,36 +1659,55 @@ static void __free_buffer_wake(struct dm_buffer *b)<=
br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_bufio_client *c =3D b-&gt;c;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;block =3D -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!c-&gt;need_reserved_buffers)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_buffer(b);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_add(&amp;b-&gt=
;lru_list, &amp;c-&gt;reserved_buffers);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_add(&amp;b-&gt=
;lru.list, &amp;c-&gt;reserved_buffers);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;need_reserved=
_buffers--;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&amp;c-&gt;free_buffer_wait);<br>
=C2=A0}<br>
<br>
+static enum evict_result cleaned(struct dm_buffer *b, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_bit(B_READING, &amp;b-&gt;state));<=
br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_bit(B_DIRTY, &amp;b-&gt;state) || test=
_bit(B_WRITING, &amp;b-&gt;state))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ER_DONT_EVIC=
T;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ER_EVICT;<br=
>
+}<br>
+<br>
+static void __move_clean_buffers(struct dm_bufio_client *c)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_mark_many(&amp;c-&gt;cache, LIST_DIRTY, L=
IST_CLEAN, cleaned, NULL);<br>
+}<br>
+<br>
+struct write_context {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int no_wait;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head *write_list;<br>
+};<br>
+<br>
+static enum it_action write_one(struct dm_buffer *b, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct write_context *wc =3D context;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (wc-&gt;no_wait &amp;&amp; test_bit(B_WRITIN=
G, &amp;b-&gt;state))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return IT_COMPLETE;=
<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0__write_dirty_buffer(b, wc-&gt;write_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return IT_NEXT;<br>
+}<br>
+<br>
=C2=A0static void __write_dirty_buffers_async(struct dm_bufio_client *c, in=
t no_wait,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct l=
ist_head *write_list)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b, *tmp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct write_context wc =3D {.no_wait =3D no_wa=
it, .write_list =3D write_list};<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_safe_reverse(b, tmp, &amp;c=
-&gt;lru[LIST_DIRTY], lru_list) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(test_bit(B_R=
EADING, &amp;b-&gt;state));<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!test_bit(B_DIR=
TY, &amp;b-&gt;state) &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test=
_bit(B_WRITING, &amp;b-&gt;state)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__relink_lru(b, LIST_CLEAN);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (no_wait &amp;&a=
mp; test_bit(B_WRITING, &amp;b-&gt;state))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__write_dirty_buffe=
r(b, write_list);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0__move_clean_buffers(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_iterate(&amp;c-&gt;cache, LIST_DIRTY, wri=
te_one, &amp;wc);<br>
=C2=A0}<br>
<br>
=C2=A0/*<br>
@@ -1007,7 +1718,8 @@ static void __write_dirty_buffers_async(struct dm_buf=
io_client *c, int no_wait,<br>
=C2=A0static void __check_watermark(struct dm_bufio_client *c,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct list_head *write_list)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (c-&gt;n_buffers[LIST_DIRTY] &gt; c-&gt;n_bu=
ffers[LIST_CLEAN] * DM_BUFIO_WRITEBACK_RATIO)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (cache_count(&amp;c-&gt;cache, LIST_DIRTY) &=
gt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_count(&amp;c-=
&gt;cache, LIST_CLEAN) * DM_BUFIO_WRITEBACK_RATIO)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __write_dirty_buffe=
rs_async(c, 1, write_list);<br>
=C2=A0}<br>
<br>
@@ -1017,20 +1729,30 @@ static void __check_watermark(struct dm_bufio_clien=
t *c,<br>
=C2=A0 *--------------------------------------------------------------<br>
=C2=A0 */<br>
<br>
+static void cache_put_and_wake(struct dm_bufio_client *c, struct dm_buffer=
 *b)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Relying on waitqueue_active() is racey, but =
we sleep<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * with schedule_timeout anyway.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (cache_put(&amp;c-&gt;cache, b) &amp;&amp;<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unlikely(waitqueue_active(&amp;c-=
&gt;free_buffer_wait)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wake_up(&amp;c-&gt;=
free_buffer_wait);<br>
+}<br>
+<br>
+/*<br>
+ * This assumes you have already checked the cache to see if the buffer<br=
>
+ * is already present (it will recheck after dropping the lock for allocat=
ion).<br>
+ */<br>
=C2=A0static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, secto=
r_t block,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0enum new_flag nf=
, int *need_submit,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head=
 *write_list)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_buffer *b, *new_b =3D NULL;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *need_submit =3D 0;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __find(c, block);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto found_buffer;<=
br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_GET)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* This can&#39;t be called with NF_GET */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(nf =3D=3D NF_GET);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 new_b =3D __alloc_buffer_wait(c, nf);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!new_b)<br>
@@ -1040,7 +1762,7 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_=
client *c, sector_t block,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* We&#39;ve had a period where the mutex =
was unlocked, so need to<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* recheck the buffer tree.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __find(c, block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D cache_get(&amp;c-&gt;cache, block);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (b) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __free_buffer_wake(=
new_b);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto found_buffer;<=
br>
@@ -1049,24 +1771,35 @@ static struct dm_buffer *__bufio_new(struct dm_bufi=
o_client *c, sector_t block,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __check_watermark(c, write_list);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 b =3D new_b;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;hold_count =3D 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_set(&amp;b-&gt;hold_count, 1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0WRITE_ONCE(b-&gt;last_accessed, jiffies);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;block =3D block;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 b-&gt;read_error =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 b-&gt;write_error =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0__link_buffer(b, block, LIST_CLEAN);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;list_mode =3D LIST_CLEAN;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_FRESH) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_FRESH)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b-&gt;state =3D 0;<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return b;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;state =3D 1 &=
lt;&lt; B_READING;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*need_submit =3D 1;=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;state =3D 1 &lt;&lt; B_READING;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0*need_submit =3D 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * We mustn&#39;t insert into the cache until t=
he B_READING state<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * is set.=C2=A0 Otherwise another thread could=
 get it and use<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * it before it had been read.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_insert(&amp;c-&gt;cache, b);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return b;<br>
<br>
=C2=A0found_buffer:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_PREFETCH)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_PREFETCH) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_put_and_wake(=
c, b);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Note: it is essential that we don&#39;t=
 wait for the buffer to be<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* read if dm_bufio_get function is used. =
Both dm_bufio_get and<br>
@@ -1074,12 +1807,11 @@ static struct dm_buffer *__bufio_new(struct dm_bufi=
o_client *c, sector_t block,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If the user called both dm_bufio_prefet=
ch and dm_bufio_get on<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* the same buffer, it would deadlock if w=
e waited.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_GET &amp;&amp; unlikely(test_b=
it_acquire(B_READING, &amp;b-&gt;state)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_GET &amp;&amp; unlikely(test_b=
it_acquire(B_READING, &amp;b-&gt;state))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_put_and_wake(=
c, b);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;hold_count++;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0__relink_lru(b, test_bit(B_DIRTY, &amp;b-&gt;st=
ate) ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 test=
_bit(B_WRITING, &amp;b-&gt;state));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return b;<br>
=C2=A0}<br>
<br>
@@ -1109,18 +1841,49 @@ static void read_endio(struct dm_buffer *b, blk_sta=
tus_t status)<br>
=C2=A0static void *new_read(struct dm_bufio_client *c, sector_t block,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 enum new_flag nf, struct dm_buffer **bp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int need_submit;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int need_submit =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_buffer *b;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 LIST_HEAD(write_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0*bp =3D NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Fast path, hopefully the block is already in=
 the cache.=C2=A0 No need<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * to get the client lock for this.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D cache_get(&amp;c-&gt;cache, block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_PR=
EFETCH) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0cache_put_and_wake(c, b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Note: it is esse=
ntial that we don&#39;t wait for the buffer to be<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * read if dm_bufio=
_get function is used. Both dm_bufio_get and<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * dm_bufio_prefetc=
h can be used in the driver request routine.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If the user call=
ed both dm_bufio_prefetch and dm_bufio_get on<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * the same buffer,=
 it would deadlock if we waited.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_GE=
T &amp;&amp; unlikely(test_bit_acquire(B_READING, &amp;b-&gt;state))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0cache_put_and_wake(c, b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!b) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (nf =3D=3D NF_GE=
T)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __bufio_new(c=
, block, nf, &amp;need_submit, &amp;write_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __bufio_new(c, block, nf, &amp;need_submi=
t, &amp;write_list);<br>
=C2=A0#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b &amp;&amp; b-&gt;hold_count =3D=3D 1)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b &amp;&amp; (atomic_read(&amp;b-&gt;hold_c=
ount) =3D=3D 1))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 buffer_record_stack=
(b);<br>
=C2=A0#endif<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __flush_write_list(&amp;write_list);<br>
<br>
@@ -1141,7 +1904,6 @@ static void *new_read(struct dm_bufio_client *c, sect=
or_t block,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *bp =3D b;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return b-&gt;data;<br>
=C2=A0}<br>
<br>
@@ -1156,7 +1918,6 @@ void *dm_bufio_read(struct dm_bufio_client *c, sector=
_t block,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struc=
t dm_buffer **bp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(dm_bufio_in_request());<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return new_read(c, block, NF_READ, bp);<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bufio_read);<br>
@@ -1165,7 +1926,6 @@ void *dm_bufio_new(struct dm_bufio_client *c, sector_=
t block,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct=
 dm_buffer **bp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(dm_bufio_in_request());<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return new_read(c, block, NF_FRESH, bp);<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bufio_new);<br>
@@ -1180,12 +1940,19 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(dm_bufio_in_request());<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 blk_start_plug(&amp;plug);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (; n_blocks--; block++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int need_submit;<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_buffer *b=
;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D cache_get(&am=
p;c-&gt;cache, block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (b) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/* already in cache */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0cache_put_and_wake(c, b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b =3D __bufio_new(c=
, block, NF_PREFETCH, &amp;need_submit,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;write_list);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(!list_=
empty(&amp;write_list))) {<br>
@@ -1195,6 +1962,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 blk_start_plug(&amp;plug);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dm_bufio_lock(c);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(b !=3D=
 NULL)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dm_bufio_unlock(c);<br>
<br>
@@ -1208,10 +1976,9 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto flush_plug;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dm_bufio_lock(c);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);<br>
-<br>
=C2=A0flush_plug:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 blk_finish_plug(&amp;plug);<br>
=C2=A0}<br>
@@ -1221,29 +1988,28 @@ void dm_bufio_release(struct dm_buffer *b)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_bufio_client *c =3D b-&gt;c;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If there were errors on the buffer, and the =
buffer is not<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * to be written, free the buffer. There is no =
point in caching<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * invalid buffer.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((b-&gt;read_error || b-&gt;write_error) &am=
p;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test_bit_acquire(B_READING, &amp=
;b-&gt;state) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test_bit(B_WRITING, &amp;b-&gt;s=
tate) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test_bit(B_DIRTY, &amp;b-&gt;sta=
te)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<b=
r>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!b-&gt;hold_count);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;hold_count--;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!b-&gt;hold_count) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wake_up(&amp;c-&gt;=
free_buffer_wait);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If there were er=
rors on the buffer, and the buffer is not<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * to be written, f=
ree the buffer. There is no point in caching<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * invalid buffer.<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((b-&gt;read_err=
or || b-&gt;write_error) &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test=
_bit_acquire(B_READING, &amp;b-&gt;state) &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test=
_bit(B_WRITING, &amp;b-&gt;state) &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test=
_bit(B_DIRTY, &amp;b-&gt;state)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__unlink_buffer(b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* cache remove can=
 fail if there are other holders */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cache_remove(&a=
mp;c-&gt;cache, b)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __free_buffer_wake(b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dm_bufio_unlock(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_put_and_wake(c, b);<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bufio_release);<br>
<br>
@@ -1262,7 +2028,7 @@ void dm_bufio_mark_partial_buffer_dirty(struct dm_buf=
fer *b,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!test_and_set_bit(B_DIRTY, &amp;b-&gt;state=
)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b-&gt;dirty_start =
=3D start;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 b-&gt;dirty_end =3D=
 end;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__relink_lru(b, LIS=
T_DIRTY);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_mark(&amp;c-&=
gt;cache, b, LIST_DIRTY);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (start &lt; b-&g=
t;dirty_start)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 b-&gt;dirty_start =3D start;<br>
@@ -1300,11 +2066,19 @@ EXPORT_SYMBOL_GPL(dm_bufio_write_dirty_buffers_asyn=
c);<br>
=C2=A0 *<br>
=C2=A0 * Finally, we flush hardware disk cache.<br>
=C2=A0 */<br>
+static bool is_writing(struct lru_entry *e, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b =3D le_to_buffer(e);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return test_bit(B_WRITING, &amp;b-&gt;state);<b=
r>
+}<br>
+<br>
=C2=A0int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int a, f;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long buffers_processed =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b, *tmp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long nr_buffers;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_entry *e;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct lru_iter it;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 LIST_HEAD(write_list);<br>
<br>
@@ -1314,52 +2088,32 @@ int dm_bufio_write_dirty_buffers(struct dm_bufio_cl=
ient *c)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __flush_write_list(&amp;write_list);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_lock(c);<br>
<br>
-again:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_safe_reverse(b, tmp, &amp;c=
-&gt;lru[LIST_DIRTY], lru_list) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int dropped_lock =
=3D 0;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (buffers_process=
ed &lt; c-&gt;n_buffers[LIST_DIRTY])<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0buffers_processed++;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0nr_buffers =3D cache_count(&amp;c-&gt;cache, LI=
ST_DIRTY);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru_iter_begin(&amp;c-&gt;cache.lru[LIST_DIRTY]=
, &amp;it);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while ((e =3D lru_iter_next(&amp;it, is_writing=
, c))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b=
 =3D le_to_buffer(e);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__cache_inc_buffer(=
b);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(test_bit(B_R=
EADING, &amp;b-&gt;state));<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_bit(B_WRIT=
ING, &amp;b-&gt;state)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (buffers_processed &lt; c-&gt;n_buffers[LIST_DIRTY]) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dropped_lock =3D 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;hold_count++;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait_on_bit_io(&amp;b-&gt;state, B_WR=
ITING,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 TASK_UNINTERRUPTIBLE);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b-&gt;hold_count--;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0} else<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait_on_bit_io(&amp;b-&gt;state, B_WR=
ITING,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 TASK_UNINTERRUPTIBLE);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (nr_buffers) {<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0nr_buffers--;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dm_bufio_unlock(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0wait_on_bit_io(&amp;b-&gt;state, B_WRITING, TASK_UNINTERRUPTIBLE)=
;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dm_bufio_lock(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0wait_on_bit_io(&amp;b-&gt;state, B_WRITING, TASK_UNINTERRUPTIBLE)=
;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!test_bit(B_DIR=
TY, &amp;b-&gt;state) &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!test=
_bit(B_WRITING, &amp;b-&gt;state))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__relink_lru(b, LIST_CLEAN);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!test_bit(B_DIR=
TY, &amp;b-&gt;state) &amp;&amp; !test_bit(B_WRITING, &amp;b-&gt;state))<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0cache_mark(&amp;c-&gt;cache, b, LIST_CLEAN);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_put_and_wake(=
c, b);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cond_resched();<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If we dropped th=
e lock, the list is no longer consistent,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * so we must resta=
rt the search.<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * In the most comm=
on case, the buffer just processed is<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * relinked to the =
clean list, so we won&#39;t loop scanning the<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * same buffer agai=
n and again.<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * This may liveloc=
k if there is another thread simultaneously<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * dirtying buffers=
, so we count the number of buffers walked<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * and if it exceed=
s the total number of buffers, it means that<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * someone is doing=
 some writes simultaneously with us.=C2=A0 In<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * this case, stop,=
 dropping the lock.<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dropped_lock)<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto again;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0lru_iter_end(&amp;it);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&amp;c-&gt;free_buffer_wait);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_unlock(c);<br>
<br>
@@ -1418,12 +2172,22 @@ int dm_bufio_issue_discard(struct dm_bufio_client *=
c, sector_t block, sector_t c<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);<br>
<br>
-static void forget_buffer_locked(struct dm_buffer *b)<br>
+static bool forget_buffer(struct dm_bufio_client *c, sector_t block)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(!b-&gt;hold_count) &amp;&amp; likely=
(!smp_load_acquire(&amp;b-&gt;state))) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__unlink_buffer(b);=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__free_buffer_wake(=
b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D cache_get(&amp;c-&gt;cache, block);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(!smp_loa=
d_acquire(&amp;b-&gt;state))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (cache_remove(&amp;c-&gt;cache, b))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__free_buffer_wake(b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_put_and_wake(c, b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0cache_put_and_wake(c, b);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return b ? true : false;<br>
=C2=A0}<br>
<br>
=C2=A0/*<br>
@@ -1434,38 +2198,22 @@ static void forget_buffer_locked(struct dm_buffer *=
b)<br>
=C2=A0 */<br>
=C2=A0void dm_bufio_forget(struct dm_bufio_client *c, sector_t block)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_lock(c);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __find(c, block);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0forget_buffer_locke=
d(b);<br>
-<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0forget_buffer(c, block);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_unlock(c);<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bufio_forget);<br>
<br>
+static enum evict_result idle(struct dm_buffer *b, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return b-&gt;state ? ER_DONT_EVICT : ER_EVICT;<=
br>
+}<br>
+<br>
=C2=A0void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t bloc=
k, sector_t n_blocks)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sector_t end_block =3D block + n_blocks;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0while (block &lt; end_block) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<b=
r>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D __find_next(c=
, block);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (b) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0block =3D b-&gt;block + 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0forget_buffer_locked(b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);=
<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!b)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_remove_range(&amp;c-&gt;cache, block, blo=
ck + n_blocks, idle, __free_buffer_wake);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bufio_forget_buffers);<br>
<br>
@@ -1527,11 +2275,26 @@ struct dm_bufio_client *dm_bufio_get_client(struct =
dm_buffer *b)<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bufio_get_client);<br>
<br>
+static enum it_action warn_leak(struct dm_buffer *b, void *context)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool *warned =3D context;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0WARN_ON(!(*warned));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0*warned =3D true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0DMERR(&quot;leaked buffer %llx, hold count %u, =
list %d&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(unsigned long long)b-&gt;=
block, atomic_read(&amp;b-&gt;hold_count), b-&gt;list_mode);<br>
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0stack_trace_print(b-&gt;stack_entries, b-&gt;st=
ack_len, 1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* mark unclaimed to avoid BUG_ON below */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_set(&amp;b-&gt;hold_count, 0);<br>
+#endif<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return IT_NEXT;<br>
+}<br>
+<br>
=C2=A0static void drop_buffers(struct dm_bufio_client *c)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0bool warned =3D false;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(dm_bufio_in_request());<br>
<br>
@@ -1545,18 +2308,11 @@ static void drop_buffers(struct dm_bufio_client *c)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while ((b =3D __get_unclaimed_buffer(c)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __free_buffer_wake(=
b);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; LIST_SIZE; i++)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry=
(b, &amp;c-&gt;lru[i], lru_list) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0WARN_ON(!warned);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0warned =3D true;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0DMERR(&quot;leaked buffer %llx, hold count %u, list %d&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(unsigned long long)b-&gt;block, b-&gt;hold_=
count, i);<br>
-#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0stack_trace_print(b-&gt;stack_entries, b-&gt;stack_len, 1);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/* mark unclaimed to avoid BUG_ON below */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0b-&gt;hold_count =3D 0;<br>
-#endif<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; LIST_SIZE; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool warned =3D fal=
se;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cache_iterate(&amp;=
c-&gt;cache, i, warn_leak, &amp;warned);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while ((b =3D __get_unclaimed_buffer(c)))<br>
@@ -1564,39 +2320,11 @@ static void drop_buffers(struct dm_bufio_client *c)=
<br>
=C2=A0#endif<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; LIST_SIZE; i++)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!list_empty(=
&amp;c-&gt;lru[i]));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(cache_count(=
&amp;c-&gt;cache, i));<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_unlock(c);<br>
=C2=A0}<br>
<br>
-/*<br>
- * We may not be able to evict this buffer if IO pending or the client<br>
- * is still using it.=C2=A0 Caller is expected to know buffer is too old.<=
br>
- *<br>
- * And if GFP_NOFS is used, we must not do any I/O because we hold<br>
- * dm_bufio_clients_lock and we would risk deadlock if the I/O gets<br>
- * rerouted to different bufio client.<br>
- */<br>
-static bool __try_evict_buffer(struct dm_buffer *b, gfp_t gfp)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(gfp &amp; __GFP_FS) ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(static_branch_unlikely(&amp;no_s=
leep_enabled) &amp;&amp; b-&gt;c-&gt;no_sleep)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_bit_acquir=
e(B_READING, &amp;b-&gt;state) ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0test_=
bit(B_WRITING, &amp;b-&gt;state) ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0test_=
bit(B_DIRTY, &amp;b-&gt;state))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return false;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (b-&gt;hold_count)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0__make_buffer_clean(b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0__unlink_buffer(b);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0__free_buffer_wake(b);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
-}<br>
-<br>
=C2=A0static unsigned long get_retain_buffers(struct dm_bufio_client *c)<br=
>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long retain_bytes =3D READ_ONCE(dm_buf=
io_retain_bytes);<br>
@@ -1612,22 +2340,30 @@ static unsigned long get_retain_buffers(struct dm_b=
ufio_client *c)<br>
=C2=A0static void __scan(struct dm_bufio_client *c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int l;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b, *tmp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long freed =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long count =3D c-&gt;n_buffers[LIST_CL=
EAN] +<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;n_buffers[LIST_DIRTY];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long retain_target =3D get_retain_buff=
ers(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long count =3D cache_total(&amp;c-&gt;=
cache);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (l =3D 0; l &lt; LIST_SIZE; l++) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry=
_safe_reverse(b, tmp, &amp;c-&gt;lru[l], lru_list) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0while (true) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (count - freed &lt;=3D retain_target)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_long_set(&amp;c-&gt;need_shri=
nk, 0);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!atomic_long_read(&amp;c-&gt;need_shrink))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (__try_evict_buffer(b, GFP_KERNEL)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_long_dec(&amp;c-&gt;need_shrin=
k);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0freed++;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0b =3D cache_evict(&amp;c-&gt;cache, l,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0l =3D=3D =
LIST_CLEAN ? is_clean : is_dirty, c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (!b)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0BUG_ON(b-&gt;list_mode !=3D l);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__make_buffer_clean(b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__free_buffer_wake(b);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0atomic_long_dec(&amp;c-&gt;need_shrink);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0freed++;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cond_resched();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
@@ -1656,8 +2392,7 @@ static unsigned long dm_bufio_shrink_scan(struct shri=
nker *shrink, struct shrink<br>
=C2=A0static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, s=
truct shrink_control *sc)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_bufio_client *c =3D container_of(shri=
nk, struct dm_bufio_client, shrinker);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long count =3D READ_ONCE(c-&gt;n_buffe=
rs[LIST_CLEAN]) +<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0READ_ONCE(c-&gt;n_buffers[LIST_DIRTY]);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long count =3D cache_total(&amp;c-&gt;=
cache);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long retain_target =3D get_retain_buff=
ers(c);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long queued_for_cleanup =3D atomic_lon=
g_read(&amp;c-&gt;need_shrink);<br>
<br>
@@ -1685,7 +2420,6 @@ struct dm_bufio_client *dm_bufio_client_create(struct=
 block_device *bdev, unsign<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_bufio_client *c;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char slab_name[27];<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!block_size || block_size &amp; ((1 &lt;&lt=
; SECTOR_SHIFT) - 1)) {<br>
@@ -1699,7 +2433,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct=
 block_device *bdev, unsign<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -ENOMEM;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto bad_client;<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;buffer_tree =3D RB_ROOT;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_init(&amp;c-&gt;cache);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;bdev =3D bdev;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 c-&gt;block_size =3D block_size;<br>
@@ -1716,11 +2450,6 @@ struct dm_bufio_client *dm_bufio_client_create(struc=
t block_device *bdev, unsign<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 static_branch_inc(&=
amp;no_sleep_enabled);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; LIST_SIZE; i++) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&amp=
;c-&gt;lru[i]);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;n_buffers[i] =
=3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_init(&amp;c-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_init(&amp;c-&gt;spinlock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&amp;c-&gt;reserved_buffers);<br=
>
@@ -1792,9 +2521,9 @@ struct dm_bufio_client *dm_bufio_client_create(struct=
 block_device *bdev, unsign<br>
<br>
=C2=A0bad:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while (!list_empty(&amp;c-&gt;reserved_buffers)=
) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b=
 =3D list_entry(c-&gt;reserved_buffers.next,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 struct dm_buffer, lru_list);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;b-&gt=
;lru_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b=
 =3D list_to_buffer(c-&gt;reserved_buffers.next);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;b-&gt=
;lru.list);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_buffer(b);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 kmem_cache_destroy(c-&gt;slab_cache);<br>
@@ -1831,23 +2560,23 @@ void dm_bufio_client_destroy(struct dm_bufio_client=
 *c)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&amp;dm_bufio_clients_lock);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!RB_EMPTY_ROOT(&amp;c-&gt;buffer_tree));=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(c-&gt;need_reserved_buffers);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while (!list_empty(&amp;c-&gt;reserved_buffers)=
) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b=
 =3D list_entry(c-&gt;reserved_buffers.next,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 struct dm_buffer, lru_list);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;b-&gt=
;lru_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b=
 =3D list_to_buffer(c-&gt;reserved_buffers.next);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&amp;b-&gt=
;lru.list);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_buffer(b);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; LIST_SIZE; i++)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (c-&gt;n_buffers=
[i])<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0DMERR(&quot;leaked buffer count %d: %ld&quot;, i, c-&gt;n_buffers=
[i]);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cache_count(&am=
p;c-&gt;cache, i))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0DMERR(&quot;leaked buffer count %d: %lu&quot;, i, cache_count(&am=
p;c-&gt;cache, i));<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; LIST_SIZE; i++)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(c-&gt;n_buff=
ers[i]);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(cache_count(=
&amp;c-&gt;cache, i));<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cache_destroy(&amp;c-&gt;cache);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 kmem_cache_destroy(c-&gt;slab_cache);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 kmem_cache_destroy(c-&gt;slab_buffer);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_io_client_destroy(c-&gt;dm_io);<br>
@@ -1864,6 +2593,8 @@ void dm_bufio_set_sector_offset(struct dm_bufio_clien=
t *c, sector_t start)<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_GPL(dm_bufio_set_sector_offset);<br>
<br>
+/*--------------------------------------------------------------*/<br>
+<br>
=C2=A0static unsigned int get_max_age_hz(void)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int max_age =3D READ_ONCE(dm_bufio_max=
_age);<br>
@@ -1876,13 +2607,74 @@ static unsigned int get_max_age_hz(void)<br>
<br>
=C2=A0static bool older_than(struct dm_buffer *b, unsigned long age_hz)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return time_after_eq(jiffies, b-&gt;last_access=
ed + age_hz);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return time_after_eq(jiffies, READ_ONCE(b-&gt;l=
ast_accessed) + age_hz);<br>
=C2=A0}<br>
<br>
-static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long a=
ge_hz)<br>
+struct evict_params {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0gfp_t gfp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long age_hz;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * This gets updated with the largest last_acce=
ssed (ie. most<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * recently used) of the evicted buffers.=C2=A0=
 It will not be reinitialised<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * by __evict_many(), so you can use it across =
multiple invocations.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long last_accessed;<br>
+};<br>
+<br>
+/*<br>
+ * We may not be able to evict this buffer if IO pending or the client<br>
+ * is still using it.<br>
+ *<br>
+ * And if GFP_NOFS is used, we must not do any I/O because we hold<br>
+ * dm_bufio_clients_lock and we would risk deadlock if the I/O gets<br>
+ * rerouted to different bufio client.<br>
+ */<br>
+static enum evict_result select_for_evict(struct dm_buffer *b, void *conte=
xt)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct evict_params *params =3D context;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(params-&gt;gfp &amp; __GFP_FS) ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(static_branch_unlikely(&amp;no_s=
leep_enabled) &amp;&amp; b-&gt;c-&gt;no_sleep)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_bit_acquir=
e(B_READING, &amp;b-&gt;state) ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0test_=
bit(B_WRITING, &amp;b-&gt;state) ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0test_=
bit(B_DIRTY, &amp;b-&gt;state))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return ER_DONT_EVICT;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return older_than(b, params-&gt;age_hz) ? ER_EV=
ICT : ER_STOP;<br>
+}<br>
+<br>
+static unsigned int __evict_many(struct dm_bufio_client *c,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct evict_params *params,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int list_mode, unsigned int max_coun=
t)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int count;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long last_accessed;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (count =3D 0; count &lt; max_count; count++=
) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D cache_evict(&=
amp;c-&gt;cache, list_mode, select_for_evict, params);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!b)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0last_accessed =3D R=
EAD_ONCE(b-&gt;last_accessed);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (time_after_eq(p=
arams-&gt;last_accessed, last_accessed))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0params-&gt;last_accessed =3D last_accessed;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__make_buffer_clean=
(b);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__free_buffer_wake(=
b);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return count;<br>
+}<br>
+<br>
+static void evict_old_buffers(struct dm_bufio_client *c, unsigned long age=
_hz)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b, *tmp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long retain_target =3D get_retain_buff=
ers(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct evict_params params =3D {.gfp =3D 0, .ag=
e_hz =3D age_hz, .last_accessed =3D 0};<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long retain =3D get_retain_buffers(c);=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long count;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 LIST_HEAD(write_list);<br>
<br>
@@ -1895,91 +2687,13 @@ static void __evict_old_buffers(struct dm_bufio_cli=
ent *c, unsigned long age_hz)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_lock(c);<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D c-&gt;n_buffers[LIST_CLEAN] + c-&gt;n=
_buffers[LIST_DIRTY];<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_safe_reverse(b, tmp, &amp;c=
-&gt;lru[LIST_CLEAN], lru_list) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (count &lt;=3D r=
etain_target)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!older_than(b, =
age_hz))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (__try_evict_buf=
fer(b, 0))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0count--;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D cache_total(&amp;c-&gt;cache);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (count &gt; retain)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__evict_many(c, &am=
p;params, LIST_CLEAN, count - retain);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_bufio_unlock(c);<br>
=C2=A0}<br>
<br>
-static void do_global_cleanup(struct work_struct *w)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *locked_client =3D NULL;=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *current_client;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_buffer *b;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int spinlock_hold_count;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long threshold =3D dm_bufio_cache_size=
 -<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_cache_size=
 / DM_BUFIO_LOW_WATERMARK_RATIO;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long loops =3D global_num * 2;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&amp;dm_bufio_clients_lock);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0while (1) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&amp;glob=
al_spinlock);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(dm_buf=
io_current_allocated &lt;=3D threshold))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spinlock_hold_count=
 =3D 0;<br>
-get_next:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!loops--)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(list_e=
mpty(&amp;global_queue)))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D list_entry(gl=
obal_queue.prev, struct dm_buffer, global_list);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (b-&gt;accessed)=
 {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0b-&gt;accessed =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0list_move(&amp;b-&gt;global_list, &amp;global_queue);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (likely(++spinlock_hold_count &lt; 16))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto get_next;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0spin_unlock(&amp;global_spinlock);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0current_client =3D =
b-&gt;c;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(curren=
t_client !=3D locked_client)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (locked_client)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(locked_client);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (!dm_bufio_trylock(current_client)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&amp;global_spinlock);<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(current_client);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0locked_client =3D current_client;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0locked_client =3D current_client;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&amp;gl=
obal_spinlock);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!__try=
_evict_buffer(b, GFP_KERNEL))) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0spin_lock(&amp;global_spinlock);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0list_move(&amp;b-&gt;global_list, &amp;global_queue);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0spin_unlock(&amp;global_spinlock);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&amp;global_spinlock);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (locked_client)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(loc=
ked_client);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&amp;dm_bufio_clients_lock);<br>
-}<br>
-<br>
=C2=A0static void cleanup_old_buffers(void)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long max_age_hz =3D get_max_age_hz();<=
br>
@@ -1990,7 +2704,7 @@ static void cleanup_old_buffers(void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __cache_size_refresh();<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(c, &amp;dm_bufio_all_client=
s, client_list)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__evict_old_buffers=
(c, max_age_hz);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0evict_old_buffers(c=
, max_age_hz);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&amp;dm_bufio_clients_lock);<br>
=C2=A0}<br>
@@ -2003,6 +2717,107 @@ static void work_fn(struct work_struct *w)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0DM_BUFIO_WORK_TIMER_SECS * HZ);<br>
=C2=A0}<br>
<br>
+/*--------------------------------------------------------------*/<br>
+<br>
+/*<br>
+ * Global cleanup tries to evict the oldest buffers from across _all_<br>
+ * the clients.=C2=A0 It does this by repeatedly evicting a few buffers fr=
om<br>
+ * the client that holds the oldest buffer.=C2=A0 It&#39;s approximate, bu=
t hopefully<br>
+ * good enough.<br>
+ */<br>
+static struct dm_bufio_client *__pop_client(void)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head *h;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (list_empty(&amp;dm_bufio_all_clients))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0h =3D dm_bufio_all_clients.next;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(h);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return container_of(h, struct dm_bufio_client, =
client_list);<br>
+}<br>
+<br>
+/*<br>
+ * Inserts the client in the global client list based on its<br>
+ * &#39;oldest_buffer&#39; field.<br>
+ */<br>
+static void __insert_client(struct dm_bufio_client *new_client)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head *h =3D dm_bufio_all_clients.ne=
xt;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (h !=3D &amp;dm_bufio_all_clients) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c =3D container_of(=
h, struct dm_bufio_client, client_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (time_after_eq(c=
-&gt;oldest_buffer, new_client-&gt;oldest_buffer))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0h =3D h-&gt;next;<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_add_tail(&amp;new_client-&gt;client_list, =
h);<br>
+}<br>
+<br>
+static unsigned int __evict_a_few(unsigned int nr_buffers)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int count;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct evict_params params =3D {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.gfp =3D GFP_KERNEL=
,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.age_hz =3D 0,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* set to jiffies i=
n case there are no buffers in this client */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.last_accessed =3D =
jiffies<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0};<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0c =3D __pop_client();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!c)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D __evict_many(c, &amp;params, LIST_CLE=
AN, nr_buffers);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (count)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;oldest_buffer=
 =3D params.last_accessed;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0__insert_client(c);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return count;<br>
+}<br>
+<br>
+static void check_watermarks(void)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0LIST_HEAD(write_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct dm_bufio_client *c;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&amp;dm_bufio_clients_lock);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry(c, &amp;dm_bufio_all_client=
s, client_list) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_lock(c);<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__check_watermark(c=
, &amp;write_list);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_unlock(c);=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&amp;dm_bufio_clients_lock);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0__flush_write_list(&amp;write_list);<br>
+}<br>
+<br>
+static void evict_old(void)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long threshold =3D dm_bufio_cache_size=
 -<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dm_bufio_cache_size=
 / DM_BUFIO_LOW_WATERMARK_RATIO;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&amp;dm_bufio_clients_lock);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (dm_bufio_current_allocated &gt; threshol=
d) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!__evict_a_few(=
64))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cond_resched();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&amp;dm_bufio_clients_lock);<br>
+}<br>
+<br>
+static void do_global_cleanup(struct work_struct *w)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0check_watermarks();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0evict_old();<br>
+}<br>
+<br>
=C2=A0/*<br>
=C2=A0 *--------------------------------------------------------------<br>
=C2=A0 * Module setup<br>
-- <br>
2.40.0<br>
<br>
</blockquote></div>

--00000000000082a23b05f78c8ce8--

--===============7729970695029172636==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7729970695029172636==--


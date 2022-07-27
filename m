Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2ABC04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658935707;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xpFJ5LRHYdrtn8IN6U7+p6Iaq/OkNmy7jfqh3VHjb9k=;
	b=N9P+qKjgPqeJY4Xylzlwul3e9dB80ZY3exNV3L0ThSU0vYvVj0oVXQdpOoBlgsJZAKjEcd
	kMVA0C+gDANShqfyYIlBU3Zp3Gw1q8aW4/8zh46eGl/aBniqJzC4ehHDAvthXHhmQ0j3jf
	9vYDVW0/Fr8jj6X3J0h6O3oYGMwVv7o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-PHMjTP4AOzu_k1QaIKl_2A-1; Wed, 27 Jul 2022 11:28:24 -0400
X-MC-Unique: PHMjTP4AOzu_k1QaIKl_2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52B923C11E65;
	Wed, 27 Jul 2022 15:28:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECD0C909FE;
	Wed, 27 Jul 2022 15:28:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9AE061945DA7;
	Wed, 27 Jul 2022 15:28:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13CB01945DA2
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 15:25:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A9CA1112131E; Wed, 27 Jul 2022 15:25:35 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C14D1121314;
 Wed, 27 Jul 2022 15:25:35 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26RFPZOI029465; Wed, 27 Jul 2022 11:25:35 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26RFPZXd029461; Wed, 27 Jul 2022 11:25:35 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 27 Jul 2022 11:25:35 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@kernel.org>
In-Reply-To: <20220726160959.89247-3-snitzer@kernel.org>
Message-ID: <alpine.LRH.2.02.2207271055510.28280@file01.intranet.prod.int.rdu2.redhat.com>
References: <20220726160959.89247-1-snitzer@kernel.org>
 <20220726160959.89247-3-snitzer@kernel.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 2/6] dm bufio: Add
 DM_BUFIO_CLIENT_NO_SLEEP flag
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I'd like to ask - why not use dm_bufio_trylock from an interrupt context?

I would just add a new function "dm_bufio_get_trylock" that is equivalent 
to "dm_bufio_get", except that it uses dm_bufio_trylock - and if it fails, 
fallback to process context.

I think using dm_bufio_trylock would be less hacky than introducing a 
new dm_bufio flag that changes mutex to spinlock.

Mikulas



On Tue, 26 Jul 2022, Mike Snitzer wrote:

> From: Nathan Huckleberry <nhuck@google.com>
> 
> Add an optional flag that ensures dm_bufio_client does not sleep
> (primary focus is to service dm_bufio_get without sleeping). This
> allows the dm-bufio cache to be queried from interrupt context.
> 
> To ensure that dm-bufio does not sleep, dm-bufio must use a spinlock
> instead of a mutex. Additionally, to avoid deadlocks, special care
> must be taken so that dm-bufio does not sleep while holding the
> spinlock.
> 
> But again: the scope of this no_sleep is initially confined to
> dm_bufio_get, so __alloc_buffer_wait_no_callback is _not_ changed to
> avoid sleeping because __bufio_new avoids allocation for NF_GET.
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm-bufio.c    | 22 +++++++++++++++++++---
>  include/linux/dm-bufio.h |  5 +++++
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index ad5603eb12e3..486179d1831c 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -81,6 +81,8 @@
>   */
>  struct dm_bufio_client {
>  	struct mutex lock;
> +	spinlock_t spinlock;
> +	unsigned long spinlock_flags;
>  
>  	struct list_head lru[LIST_SIZE];
>  	unsigned long n_buffers[LIST_SIZE];
> @@ -90,6 +92,7 @@ struct dm_bufio_client {
>  	s8 sectors_per_block_bits;
>  	void (*alloc_callback)(struct dm_buffer *);
>  	void (*write_callback)(struct dm_buffer *);
> +	bool no_sleep;
>  
>  	struct kmem_cache *slab_buffer;
>  	struct kmem_cache *slab_cache;
> @@ -167,17 +170,26 @@ struct dm_buffer {
>  
>  static void dm_bufio_lock(struct dm_bufio_client *c)
>  {
> -	mutex_lock_nested(&c->lock, dm_bufio_in_request());
> +	if (c->no_sleep)
> +		spin_lock_irqsave_nested(&c->spinlock, c->spinlock_flags, dm_bufio_in_request());
> +	else
> +		mutex_lock_nested(&c->lock, dm_bufio_in_request());
>  }
>  
>  static int dm_bufio_trylock(struct dm_bufio_client *c)
>  {
> -	return mutex_trylock(&c->lock);
> +	if (c->no_sleep)
> +		return spin_trylock_irqsave(&c->spinlock, c->spinlock_flags);
> +	else
> +		return mutex_trylock(&c->lock);
>  }
>  
>  static void dm_bufio_unlock(struct dm_bufio_client *c)
>  {
> -	mutex_unlock(&c->lock);
> +	if (c->no_sleep)
> +		spin_unlock_irqrestore(&c->spinlock, c->spinlock_flags);
> +	else
> +		mutex_unlock(&c->lock);
>  }
>  
>  /*----------------------------------------------------------------*/
> @@ -1748,12 +1760,16 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
>  	c->alloc_callback = alloc_callback;
>  	c->write_callback = write_callback;
>  
> +	if (flags & DM_BUFIO_CLIENT_NO_SLEEP)
> +		c->no_sleep = true;
> +
>  	for (i = 0; i < LIST_SIZE; i++) {
>  		INIT_LIST_HEAD(&c->lru[i]);
>  		c->n_buffers[i] = 0;
>  	}
>  
>  	mutex_init(&c->lock);
> +	spin_lock_init(&c->spinlock);
>  	INIT_LIST_HEAD(&c->reserved_buffers);
>  	c->need_reserved_buffers = reserved_buffers;
>  
> diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
> index e21480715255..15d9e15ca830 100644
> --- a/include/linux/dm-bufio.h
> +++ b/include/linux/dm-bufio.h
> @@ -17,6 +17,11 @@
>  struct dm_bufio_client;
>  struct dm_buffer;
>  
> +/*
> + * Flags for dm_bufio_client_create
> + */
> +#define DM_BUFIO_CLIENT_NO_SLEEP 0x1
> +
>  /*
>   * Create a buffered IO cache on a given device
>   */
> -- 
> 2.32.1 (Apple Git-133)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794964400;
	b=2qdWKiMFJsdzUdD1TgabaUyhXHm3W0Ca69VZ8KvfMo2NTqzW8whyjFNE9k0qMDOmJxaE
	 rqkXR2Yo1pzyQsChH8O28ff9UpJh7p3e84tEaDBplp7hK7s2ATLXg1SjLJdtwhECyNlGc
	 ZlnMvxwecKAY5ASYuyz6sHG+OdMSPC614JkjnbcJodXF+hPjgGI2EtgsRS7E71p7UtrZd
	 UHq493+MDp34xeNIdpkDIecQN4T3cfvcbs8z+xpeu9A7Id/V8S9mfVmpzzuN947vTmiwg
	 n78R/4rO0dPbLFo3bI0ZYKUnnKYC/7OzuNmvIdgtaDapXCdOh4Lyi2Pa8AE2pjMQE1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794964400;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition;
	bh=6Jm2TEBzuQEKaVRaqhRBt9CBjZhRxG28eL5kOv7JvVM=;
	b=Iwp97aLpp0+BhzQ1a0hRcU3zB+czyfG7WO390h/+hYfKywBHSo9W48OC4wJ6p7l2z0AW
	 bZKN948NeBSaFBknw67SGqLUqOiS7ylV0PQYsVpJ3oycNbNZrcga/GGAc4/cuF3peTuOr
	 JdQbV7usCHuK1cabSlxE+tjVY32M8D3W/3HqzEi+Z8qJ5rs6JI8FMNvcJtD+I29CH48O1
	 gIOfj3CUrki9h7hYvKjaErkzBOaUvJW/nnIqb5hySB2dnyv2g/VXtX2TuvLAFnEJFwaD6
	 KxIYZAQF+Ci7cSyQhIiO3+Vk0pyBgdUT7SGbnA+WQ85c8k/a/ODzVNIaorFVGxtfBjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YRJbtn3u;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2210B606A32A
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 01:13:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2210B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YRJbtn3u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794964399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Jm2TEBzuQEKaVRaqhRBt9CBjZhRxG28eL5kOv7JvVM=;
	b=YRJbtn3uHV9v43Br9JXYQ6M4rnOvIgvMt7883ojNRsvEKWvfCmEYiySOwdZixAp/Zi1WOS
	qGzYF28H72wGoYElGcY7WY7BDOnVrQyPNjfsui56kFXsFoy4+AFypgj69oTvmg9LNTYP7B
	vYb3S7/Y9vDKCZ+qIUtM2jYeMPS+3m4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-949TjlytMDm11fAPbdXP5g-1; Tue,
 17 Nov 2026 20:13:16 -0500
X-MC-Unique: 949TjlytMDm11fAPbdXP5g-1
X-Mimecast-MFC-AGG-ID: 949TjlytMDm11fAPbdXP5g_1794964395
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4C7F195608E;
	Wed, 18 Nov 2026 01:13:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 503891801977;
	Wed, 18 Nov 2026 01:13:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AI1DD3A3971584
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 17 Nov 2026 20:13:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AI1DC193971583;
	Tue, 17 Nov 2026 20:13:12 -0500
Date: Tue, 17 Nov 2026 20:13:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dm thin: free thins with kfree_rcu() instead of
 waiting in thin_dtr()
Message-ID: <avz7qDWd2g-uubmL@redhat.com>
References: <20261116-bug-dm-thin-rcu-gp-v1-0-14ed3567da3e@linux.dev>
 <20261116-bug-dm-thin-rcu-gp-v1-2-14ed3567da3e@linux.dev>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261116-bug-dm-thin-rcu-gp-v1-2-14ed3567da3e@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 5orV8v7KWG8OB5bUtbkO4GVaK4Pdx0zNPZNyYywv2FM_1794964395
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 16, 2026 at 12:12:04AM -0500, Qiliang Yuan wrote:
> get_first_thin() and get_next_thin() find a thin on pool->active_thins
> under rcu_read_lock() and take a reference on it. thin_dtr() removes the
> thin from the list and waits for a grace period before dropping its own
> reference, so that no walker takes one after the last is gone.
> 
> Removing a thin device thus waits for a full grace period in thin_dtr(),
> before it waits for the references that are still held.
> 
> Take the references with refcount_inc_not_zero() and skip the thins
> whose last reference is gone, so that thin_dtr() only waits for the
> references already taken. Free the thin with kfree_rcu(), as
> requeue_bios() and error_retry_list_with_code() may still look at it
> under rcu_read_lock().
> 
> Removing 100 thin devices of an idle pool with dmsetup remove takes per
> device (mean of five rounds, min-max of the rounds in parentheses). The
> queue freeze in del_gendisk() waits for a grace period of its own, which
> the one in thin_dtr() used to overlap, so only part of it is saved:
> 
>   before (ms)        after (ms)         change
>   16.9 (15.8-17.3)   14.4 (13.8-15.3)     -15%
> 
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>

So, this isn't directly a problem with your patch, but in reviewing it,
I noticed a bug in the interaction between thin_dtr() and
get_next_thin(). thin_dtr() can take tc off the active_thins list, while
it's being held by a worker. The refcount keeps it from being deleted.
But once tc is removed from the list, there's nothing that guarantees
that tc->list.next is still meaningful. If "dmsetup remove" is called on
the thin device that is next in the active_thins list, that thin_dtr()
call can free the thin pointed to by the original tc->list.next pointer.
So when the original thin_dtr() calls get_next_thin(), it will access
freed memory.

I think the solution is for thin_dtr to mark tc as dead somehow, instead
of removing it from active_thins where we currently do. Once the
refcount drops to 0, we can remove it, wait for a grace period, and free
it.

Or am I missing something subtle that keeps this issue from happening?

-Ben

> ---
>  drivers/md/dm-thin.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index d5ff937eeacba..8386215101eb2 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -360,6 +360,7 @@ struct thin_c {
>  	 */
>  	refcount_t refcount;
>  	struct completion can_destroy;
> +	struct rcu_head rcu;
>  };
>  
>  /*----------------------------------------------------------------*/
> @@ -2317,25 +2318,29 @@ static void process_thin_deferred_cells(struct thin_c *tc)
>  	} while (!list_empty(&cells));
>  }
>  
> -static void thin_get(struct thin_c *tc);
> +static bool thin_tryget(struct thin_c *tc);
>  static void thin_put(struct thin_c *tc);
>  
>  /*
>   * We can't hold rcu_read_lock() around code that can block.  So we
>   * find a thin with the rcu lock held; bump a refcount; then drop
> - * the lock.
> + * the lock.  Skip the thins whose refcount thin_dtr() already dropped
> + * to zero.
>   */
>  static struct thin_c *get_first_thin(struct pool *pool)
>  {
> -	struct thin_c *tc = NULL;
> +	struct thin_c *tc;
>  
>  	rcu_read_lock();
> -	tc = list_first_or_null_rcu(&pool->active_thins, struct thin_c, list);
> -	if (tc)
> -		thin_get(tc);
> +	list_for_each_entry_rcu(tc, &pool->active_thins, list) {
> +		if (thin_tryget(tc)) {
> +			rcu_read_unlock();
> +			return tc;
> +		}
> +	}
>  	rcu_read_unlock();
>  
> -	return tc;
> +	return NULL;
>  }
>  
>  static struct thin_c *get_next_thin(struct pool *pool, struct thin_c *tc)
> @@ -2344,7 +2349,8 @@ static struct thin_c *get_next_thin(struct pool *pool, struct thin_c *tc)
>  
>  	rcu_read_lock();
>  	list_for_each_entry_continue_rcu(tc, &pool->active_thins, list) {
> -		thin_get(tc);
> +		if (!thin_tryget(tc))
> +			continue;
>  		thin_put(old_tc);
>  		rcu_read_unlock();
>  		return tc;
> @@ -4128,9 +4134,9 @@ static struct target_type pool_target = {
>   * Thin target methods
>   *--------------------------------------------------------------
>   */
> -static void thin_get(struct thin_c *tc)
> +static bool thin_tryget(struct thin_c *tc)
>  {
> -	refcount_inc(&tc->refcount);
> +	return refcount_inc_not_zero(&tc->refcount);
>  }
>  
>  static void thin_put(struct thin_c *tc)
> @@ -4146,7 +4152,6 @@ static void thin_dtr(struct dm_target *ti)
>  	spin_lock_irq(&tc->pool->lock);
>  	list_del_rcu(&tc->list);
>  	spin_unlock_irq(&tc->pool->lock);
> -	synchronize_rcu();
>  
>  	thin_put(tc);
>  	wait_for_completion(&tc->can_destroy);
> @@ -4158,7 +4163,8 @@ static void thin_dtr(struct dm_target *ti)
>  	dm_put_device(ti, tc->pool_dev);
>  	if (tc->origin_dev)
>  		dm_put_device(ti, tc->origin_dev);
> -	kfree(tc);
> +	/* Let RCU readers of active_thins finish with tc before freeing it */
> +	kfree_rcu(tc, rcu);
>  
>  	mutex_unlock(&dm_thin_pool_table.mutex);
>  }
> 
> -- 
> 2.43.0


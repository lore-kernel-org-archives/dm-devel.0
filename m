Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C947814A08E
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941756; cv=none; b=MxE95AxNMqgNAeyIhObQ/WJ1/kb1LpepPrnq6fZsggGiO4AUUt1fmtzIfxsmF8Nk/vKg4c40ivtuyVdWlL7KGMIZUaEUvpo3+TXNpaEnQrlu049Gv0xe5NrurEDdqXRDGNKFFSI4fLsbE3yp5lc8+KVMhk3bsSO1/V6NzTDdRPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941756; c=relaxed/simple;
	bh=BZl/NiYvWA9CjOxhfKlAma01RuJ6pcL4di44gnxRUeg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lcG802Gtyr4hq6MtmZpTxVV+Ue+Z5UuPbnepZyaOymba+CcW8/PLx0Kum7vvcsnUJV42hKjbXSPBIK/uZZNRUBHzWsoIqFh2FPErdf6UFaZkm9BZfHB2DKuaBeVrkicKgHkUjvASAvPrRQ9oBK+FU9v6xeIG8xyVDOVTqXHPNJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKAs+QM2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKAs+QM2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731941752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sVwNv3KX/BBQdbq9SseK69NqC8cWHYqfNv6TFNnYaDQ=;
	b=MKAs+QM2PaDyvI6znCAi0u52Ys9ww7dgV/HMVOxSkS9ziDWio6yyJ8Lr/6l+qa8i0iWXL9
	AHqupb32Sf2dJU0hdbzQtS8a6MwMUl05Oof0fgU93V+WnJgX8n74DrXU4KK3xlDSvwleBn
	ht9Vrsft2RbDMo9TD1tmaZXCeaq9g5w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-eXXFgjaXOCylxvVcVOqkoA-1; Mon,
 18 Nov 2024 09:55:47 -0500
X-MC-Unique: eXXFgjaXOCylxvVcVOqkoA-1
X-Mimecast-MFC-AGG-ID: eXXFgjaXOCylxvVcVOqkoA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 621711936121;
	Mon, 18 Nov 2024 14:55:46 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8388719560A3;
	Mon, 18 Nov 2024 14:55:44 +0000 (UTC)
Date: Mon, 18 Nov 2024 15:55:41 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Meir Elisha <meir.elisha@volumez.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Joe Thornber <ejt@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] md/persistent-data: Set tm hash size via a
 module_param
In-Reply-To: <420a99f1-c076-4a91-8b5f-80ac9be27c7c@volumez.com>
Message-ID: <9318c514-e110-464c-3d95-feb288130c51@redhat.com>
References: <20241014134944.1264991-1-meir.elisha@volumez.com> <420a99f1-c076-4a91-8b5f-80ac9be27c7c@volumez.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lAK8rCo08e7TXmXRu2SO4A017Kgza8LvIj2AwhspvW0_1731941746
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 18 Nov 2024, Meir Elisha wrote:

> > diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
> > index c7ba4e6cbbc7..8d486b1e6693 100644
> > --- a/drivers/md/persistent-data/dm-transaction-manager.c
> > +++ b/drivers/md/persistent-data/dm-transaction-manager.c
> > @@ -10,6 +10,7 @@
> >  #include "dm-space-map-metadata.h"
> >  #include "dm-persistent-data-internal.h"
> >  
> > +#include <linux/moduleparam.h>
> >  #include <linux/export.h>
> >  #include <linux/mutex.h>
> >  #include <linux/hash.h>
> > @@ -84,8 +85,35 @@ struct shadow_info {
> >  /*
> >   * It would be nice if we scaled with the size of transaction.
> >   */
> > -#define DM_HASH_SIZE 256
> > -#define DM_HASH_MASK (DM_HASH_SIZE - 1)
> > +static uint tm_hash_table_size = 256;
> > +
> > +static int param_set_hash_size(const char *val, const struct kernel_param *kp)
> > +{
> > +	unsigned int num;
> > +	int ret;
> > +
> > +	if (!val)
> > +		return -EINVAL;
> > +
> > +	ret = kstrtouint(val, 0, &num);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Hash size must be a power of 2 */
> > +	if (!(num && !(num & (num - 1))))
> > +		return -EINVAL;
> > +
> > +	*((unsigned int *)kp->arg) = num;
> > +	return 0;
> > +}
> > +
> > +static const struct kernel_param_ops tm_hash_table_size_ops = {
> > +	.set = param_set_hash_size,
> > +	.get = param_get_uint
> > +};
> > +
> > +module_param_cb(tm_hash_table_size, &tm_hash_table_size_ops, &tm_hash_table_size, 0644);
> > +MODULE_PARM_DESC(tm_hash_table_size, "transaction manager hash size");
> >  
> >  struct dm_transaction_manager {
> >  	int is_clone;
> > @@ -95,8 +123,9 @@ struct dm_transaction_manager {
> >  	struct dm_space_map *sm;
> >  
> >  	spinlock_t lock;
> > -	struct hlist_head buckets[DM_HASH_SIZE];
> > -
> > +	struct hlist_head *buckets;
> > +	uint hash_size;
> > +	uint hash_mask;
> >  	struct prefetch_set prefetches;
> >  };
> >  
> > @@ -105,7 +134,7 @@ struct dm_transaction_manager {
> >  static int is_shadow(struct dm_transaction_manager *tm, dm_block_t b)
> >  {
> >  	int r = 0;
> > -	unsigned int bucket = dm_hash_block(b, DM_HASH_MASK);
> > +	unsigned int bucket = dm_hash_block(b, tm->hash_mask);
> >  	struct shadow_info *si;
> >  
> >  	spin_lock(&tm->lock);
> > @@ -131,7 +160,7 @@ static void insert_shadow(struct dm_transaction_manager *tm, dm_block_t b)
> >  	si = kmalloc(sizeof(*si), GFP_NOIO);
> >  	if (si) {
> >  		si->where = b;
> > -		bucket = dm_hash_block(b, DM_HASH_MASK);
> > +		bucket = dm_hash_block(b, tm->hash_mask);
> >  		spin_lock(&tm->lock);
> >  		hlist_add_head(&si->hlist, tm->buckets + bucket);
> >  		spin_unlock(&tm->lock);
> > @@ -146,7 +175,7 @@ static void wipe_shadow_table(struct dm_transaction_manager *tm)
> >  	int i;
> >  
> >  	spin_lock(&tm->lock);
> > -	for (i = 0; i < DM_HASH_SIZE; i++) {
> > +	for (i = 0; i < tm->hash_size; i++) {
> >  		bucket = tm->buckets + i;
> >  		hlist_for_each_entry_safe(si, tmp, bucket, hlist)
> >  			kfree(si);
> > @@ -169,13 +198,19 @@ static struct dm_transaction_manager *dm_tm_create(struct dm_block_manager *bm,
> >  	if (!tm)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > +	tm->hash_size = tm_hash_table_size;
> > +	tm->buckets = kmalloc_array(tm->hash_size, sizeof(*tm->buckets), GFP_KERNEL);
> > +	if (!tm->buckets)
> > +		return ERR_PTR(-ENOMEM);
> > +
> >  	tm->is_clone = 0;
> >  	tm->real = NULL;
> >  	tm->bm = bm;
> >  	tm->sm = sm;
> > +	tm->hash_mask = tm->hash_size - 1;
> >  
> >  	spin_lock_init(&tm->lock);
> > -	for (i = 0; i < DM_HASH_SIZE; i++)
> > +	for (i = 0; i < tm->hash_size; i++)
> >  		INIT_HLIST_HEAD(tm->buckets + i);
> >  
> >  	prefetch_init(&tm->prefetches);
> 
> Hi all,
> 
> I wanted to follow up on this patch. 
> Could you please review it when you have a chance?
> If you need any additional information or have concerns, let me know.
> Thanks for your time.

Hi

I discussed it with Joe. We concluded that the patch is not much useful, 
because few users will know about this option and few users will change it 
if they hit bad performance.

Joe will be reworking the code so that it will use rb-trees instead of 
linked lists when there will be hash collision, this could improve 
performance without adding a tunable variable.

Mikulas


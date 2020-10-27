Return-Path: <SRS0=VcJp=EE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA05C2D0A3
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:08:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 353AE20780
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 353AE20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-7Uu1NkKpOdC26tUD_ejNOw-1; Thu, 29 Oct 2020 05:08:02 -0400
X-MC-Unique: 7Uu1NkKpOdC26tUD_ejNOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F07664149;
	Thu, 29 Oct 2020 09:07:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 605D25D9EF;
	Thu, 29 Oct 2020 09:07:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3704D5811A;
	Thu, 29 Oct 2020 09:07:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09RNwwXQ017950 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 19:58:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CBCE9B17D9; Tue, 27 Oct 2020 23:58:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C56DAB0790
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 23:58:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFD031021E18
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 23:58:56 +0000 (UTC)
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
	[209.85.210.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-289-ES9Pew6NPIWiRXhvg85fHA-1; Tue, 27 Oct 2020 19:58:54 -0400
X-MC-Unique: ES9Pew6NPIWiRXhvg85fHA-1
Received: by mail-pf1-f193.google.com with SMTP id e15so1861520pfh.6
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 16:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=prJFM1A+LaL7bE5goJtHOCXfaaN+QkoPscl96s9VWu8=;
	b=Y3xy5eqEsyUsbwJ4LFpu2Zw8yEnoHmVgsUJBhNruDwDJ3zbJANfI49JKhCOOrnViDY
	R649lc5y0/92b+nXbntbM9qY8xFdPIotZnD2PuosNxmyLI1CYudztOrrpIetxXELO/YE
	UT7DKizDTb6Bxs38ScHdDker11RcqkypALGjMf75r+PRqPzFZEQNzTdJjCzjsUGpLzUd
	4bScuBl5Aet0KOu2B2Mx756HH5JqB1UofEdzFtj69aCMPQwESej2XOtyMhyJAMPgtkX0
	P/NFNmONvaQrbzwfQ0rAoKGEkMxahfywerq2iMMtEyvRmudYF6ye+/jot/itWvacF06P
	/wyA==
X-Gm-Message-State: AOAM530XFA/kaS9t/lgYH1qs+VQSRhPSYq7t9RdwkRfZW8odas9TKgrD
	Qfz5iNba6V1MUFYqXRJunVss8g==
X-Google-Smtp-Source: ABdhPJzBLdCE6b8oewLm8yf9VFb0H6DzJhNaHPs823K64gcgA13cRHpU09Ini5JvdgSrL94mLKCNzQ==
X-Received: by 2002:a62:3:0:b029:160:d92:2680 with SMTP id
	3-20020a6200030000b02901600d922680mr4534880pfa.44.1603843132907;
	Tue, 27 Oct 2020 16:58:52 -0700 (PDT)
Received: from google.com (154.137.233.35.bc.googleusercontent.com.
	[35.233.137.154])
	by smtp.gmail.com with ESMTPSA id t6sm3505178pfl.50.2020.10.27.16.58.52
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 27 Oct 2020 16:58:52 -0700 (PDT)
Date: Tue, 27 Oct 2020 23:58:47 +0000
From: Satya Tangirala <satyat@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <20201027235847.GA913775@google.com>
References: <20201015214632.41951-1-satyat@google.com>
	<20201015214632.41951-4-satyat@google.com>
	<20201027213151.GC2416412@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20201027213151.GC2416412@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 29 Oct 2020 05:07:36 -0400
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 3/4] dm: add support for passing through
 inline crypto support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 27, 2020 at 02:31:51PM -0700, Eric Biggers wrote:
> On Thu, Oct 15, 2020 at 09:46:31PM +0000, Satya Tangirala wrote:
> > Update the device-mapper core to support exposing the inline crypto
> > support of the underlying device(s) through the device-mapper device.
> > 
> > This works by creating a "passthrough keyslot manager" for the dm
> > device, which declares support for encryption settings which all
> > underlying devices support.  When a supported setting is used, the bio
> > cloning code handles cloning the crypto context to the bios for all the
> > underlying devices.  When an unsupported setting is used, the blk-crypto
> > fallback is used as usual.
> > 
> > Crypto support on each underlying device is ignored unless the
> > corresponding dm target opts into exposing it.  This is needed because
> > for inline crypto to semantically operate on the original bio, the data
> > must not be transformed by the dm target.  Thus, targets like dm-linear
> > can expose crypto support of the underlying device, but targets like
> > dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)
> > 
> > When a key is evicted from the dm device, it is evicted from all
> > underlying devices.
> > 
> > A DM device's table can only be changed if the "new" inline encryption
> > capabilities are a superset of the "old" inline encryption capabilities.
> > Attempts to make changes to the table that result in some inline encryption
> > capability becoming no longer supported will be rejected.
> > 
> > Co-developed-by: Eric Biggers <ebiggers@google.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Signed-off-by: Satya Tangirala <satyat@google.com>
> > ---
> >  block/blk-crypto.c              |   1 +
> >  block/keyslot-manager.c         |  89 +++++++++++++
> >  drivers/md/dm-ioctl.c           |   8 ++
> >  drivers/md/dm.c                 | 217 +++++++++++++++++++++++++++++++-
> >  drivers/md/dm.h                 |  19 +++
> >  include/linux/device-mapper.h   |   6 +
> >  include/linux/keyslot-manager.h |  17 +++
> >  7 files changed, 356 insertions(+), 1 deletion(-)
> 
> I'm having a hard time understanding what's going on in this patch now.  Besides
> the simplifications I'm suggesting in other comments below, you should consider
> splitting this into more than one patch.  The block layer changes could be a
> separate patch, as could the key eviction support.
> 
Sure - I'll also add more details on the patch in the commit message.
> > 
> > diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> > index 5da43f0973b4..c2be8f15006c 100644
> > --- a/block/blk-crypto.c
> > +++ b/block/blk-crypto.c
> > @@ -409,3 +409,4 @@ int blk_crypto_evict_key(struct request_queue *q,
> >  	 */
> >  	return blk_crypto_fallback_evict_key(key);
> >  }
> > +EXPORT_SYMBOL_GPL(blk_crypto_evict_key);
> > diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
> > index 5ad476dafeab..e16e4a074765 100644
> > --- a/block/keyslot-manager.c
> > +++ b/block/keyslot-manager.c
> > @@ -416,6 +416,95 @@ void blk_ksm_unregister(struct request_queue *q)
> >  {
> >  	q->ksm = NULL;
> >  }
> > +EXPORT_SYMBOL_GPL(blk_ksm_unregister);
> 
> blk_ksm_unregister() doesn't seem to be necessary, since it just sets a pointer
> to NULL, which the callers could easily do themselves.
> 
> > +/**
> > + * blk_ksm_intersect_modes() - restrict supported modes by child device
> > + * @parent: The keyslot manager for parent device
> > + * @child: The keyslot manager for child device, or NULL
> > + *
> > + * Clear any crypto mode support bits in @parent that aren't set in @child.
> > + * If @child is NULL, then all parent bits are cleared.
> > + *
> > + * Only use this when setting up the keyslot manager for a layered device,
> > + * before it's been exposed yet.
> > + */
> > +void blk_ksm_intersect_modes(struct blk_keyslot_manager *parent,
> > +			     const struct blk_keyslot_manager *child)
> > +{
> > +	if (child) {
> > +		unsigned int i;
> > +
> > +		parent->max_dun_bytes_supported =
> > +			min(parent->max_dun_bytes_supported,
> > +			    child->max_dun_bytes_supported);
> > +		for (i = 0; i < ARRAY_SIZE(child->crypto_modes_supported);
> > +		     i++) {
> > +			parent->crypto_modes_supported[i] &=
> > +				child->crypto_modes_supported[i];
> > +		}
> > +	} else {
> > +		parent->max_dun_bytes_supported = 0;
> > +		memset(parent->crypto_modes_supported, 0,
> > +		       sizeof(parent->crypto_modes_supported));
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(blk_ksm_intersect_modes);
> > +
> > +/**
> > + * blk_ksm_is_superset() - Check if a KSM supports a superset of crypto modes
> > + *			   and DUN bytes that another KSM supports.
> > + * @ksm_superset: The KSM that we want to verify is a superset
> > + * @ksm_subset: The KSM that we want to verify is a subset
> > + *
> > + * Return: True if @ksm_superset supports a superset of the crypto modes and DUN
> > + *	   bytes that @ksm_subset supports.
> > + */
> > +bool blk_ksm_is_superset(struct blk_keyslot_manager *ksm_superset,
> > +			 struct blk_keyslot_manager *ksm_subset)
> 
> blk_ksm_is_superset() is confusing because it actually does "superset or the
> same", not just "superset".  That *is* the mathematical definition of superset,
> but it may not be what people expect when they read this...  Is there a better
> name, or can the comment properly explain it?
> 
A better name still eludes me, but I'll definitely at least comment it better
if I still can't think of a better name.
> > +/**
> > + * blk_ksm_update_capabilities() - Update the restrictions of a KSM to those of
> > + *				   another KSM
> > + * @target_ksm: The KSM whose restrictions to update.
> > + * @reference_ksm: The KSM to whose restrictions this function will update
> > + *		   @target_ksm's restrictions to,
> > + */
> > +void blk_ksm_update_capabilities(struct blk_keyslot_manager *target_ksm,
> > +				 struct blk_keyslot_manager *reference_ksm)
> > +{
> > +	memcpy(target_ksm->crypto_modes_supported,
> > +	       reference_ksm->crypto_modes_supported,
> > +	       sizeof(target_ksm->crypto_modes_supported));
> > +
> > +	target_ksm->max_dun_bytes_supported =
> > +				reference_ksm->max_dun_bytes_supported;
> > +}
> > +EXPORT_SYMBOL_GPL(blk_ksm_update_capabilities);
> 
> Wouldn't it be easier to replace the original blk_keyslot_manager, rather than
> modify it?  Then blk_ksm_update_capabilities() wouldn't be needed.
> 
I didn't want to replace the original blk_keyslot_manager because it's
possible that e.g. fscrypt is checking for crypto capabilities support
via blk_ksm_crypto_cfg_supported() when DM wants to replace the
blk_keyslot_manager. DM would have to free the memory used by the
blk_keyslot_manager, but blk_ksm_crypto_cfg_supported() might still
be trying to access that memory. I did it this way to avoid having to
add refcounts or something else to the blk_keyslot_manager...(And I
didn't bother adding any synchronization code since the capabilities
only ever expand, and never contract).
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index cd0478d44058..2b3efa9f9fae 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -1358,6 +1358,10 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
> >  		goto err_unlock_md_type;
> >  	}
> >  
> > +	r = dm_verify_inline_encryption(md, t);
> > +	if (r)
> > +		goto err_unlock_md_type;
> > +
> >  	if (dm_get_md_type(md) == DM_TYPE_NONE) {
> >  		/* Initial table load: acquire type of table. */
> >  		dm_set_md_type(md, dm_table_get_type(t));
> > @@ -2114,6 +2118,10 @@ int __init dm_early_create(struct dm_ioctl *dmi,
> >  	if (r)
> >  		goto err_destroy_table;
> >  
> > +	r = dm_verify_inline_encryption(md, t);
> > +	if (r)
> > +		goto err_destroy_table;
> > +
> >  	md->type = dm_table_get_type(t);
> >  	/* setup md->queue to reflect md's type (may block) */
> >  	r = dm_setup_md_queue(md, t);
> 
> Both table_load() and dm_early_create() call dm_setup_md_queue().  Wouldn't it
> be simpler to handle inline encryption in dm_setup_md_queue(), instead of doing
> it in both table_load() and dm_early_create()?
> 
table_load() only calls dm_setup_md_queue() on initial table load (when
the md_type is DM_TYPE_NONE), so I can't call
dm_verify_inline_encryption() in only dm_setup_md_queue(), because
dm_verify_inline_encryption() needs to run on every table load.
> > +/*
> > + * Constructs and returns a keyslot manager that represents the crypto
> > + * capabilities of the devices described by the dm_table. However, if the
> > + * constructed keyslot manager does not support a superset of the crypto
> > + * capabilities supported by the currect keyslot manager of the mapped_device,
> > + * it returns an error instead, since we don't support restricting crypto
> > + * capabilities on table changes.
> > + */
> > +static struct blk_keyslot_manager *
> > +dm_init_inline_encryption(struct mapped_device *md, struct dm_table *t)
> > +{
> > +	struct blk_keyslot_manager *ksm;
> > +	struct dm_target *ti;
> > +	unsigned int i;
> > +
> > +	ksm = kmalloc(sizeof(*ksm), GFP_KERNEL);
> > +	if (!ksm)
> > +		return ERR_PTR(-EINVAL);
> 
> ENOMEM, not EINVAL.
> 
Ahhh :(
> > +	blk_ksm_init_passthrough(ksm);
> > +	ksm->ksm_ll_ops = dm_ksm_ll_ops;
> > +	ksm->max_dun_bytes_supported = UINT_MAX;
> > +	memset(ksm->crypto_modes_supported, 0xFF,
> > +	       sizeof(ksm->crypto_modes_supported));
> > +	ksm->priv = md;
> > +
> > +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> > +		ti = dm_table_get_target(t, i);
> > +
> > +		if (!ti->may_passthrough_inline_crypto) {
> > +			blk_ksm_intersect_modes(ksm, NULL);
> > +			break;
> > +		}
> > +		if (!ti->type->iterate_devices)
> > +			continue;
> > +		ti->type->iterate_devices(ti, device_intersect_crypto_modes,
> > +					  ksm);
> > +	}
> > +
> > +	if (!blk_ksm_is_superset(ksm, md->queue->ksm)) {
> > +		DMWARN("Inline encryption capabilities of new DM table were more restrictive than the old table's. This is not supported!");
> > +		blk_ksm_destroy(ksm);
> > +		return ERR_PTR(-EOPNOTSUPP);
> 
> Missing kfree(ksm).
> 
Ah I totally forgot blk_ksm_destroy() doesn't free the memory used by
the ksm (not anymore at least, I'm getting confused by the numerous
revisions that code went through) - I'll need to fix that everywhere.
> Also it looks like other code is using EINVAL for a bad dm table.
> 
> > +	}
> > +
> > +	return ksm;
> 
> How about returning NULL if no crypto modes are actually supported?
> 
> > +/**
> > + * dm_verify_inline_encryption() - Verifies that the current keyslot manager of
> > + *				   the mapped_device can be replaced by the
> > + *				   keyslot manager of a given dm_table.
> > + * @md: The mapped_device
> > + * @t: The dm_table
> > + *
> > + * In particular, this function checks that the keyslot manager that will be
> > + * constructed for the dm_table will support a superset of the capabilities that
> > + * the current keyslot manager of the mapped_device supports.
> > + *
> > + * Return: 0 if the table's keyslot_manager can replace the current keyslot
> > + *	   manager of the mapped_device. Negative value otherwise.
> > + */
> > +int dm_verify_inline_encryption(struct mapped_device *md, struct dm_table *t)
> > +{
> > +	struct blk_keyslot_manager *ksm = dm_init_inline_encryption(md, t);
> > +
> > +	if (IS_ERR(ksm))
> > +		return PTR_ERR(ksm);
> > +	blk_ksm_destroy(ksm);
> > +
> > +	return 0;
> > +}
> 
> This function seems redundant with dm_init_inline_encryption().  Wouldn't it be
> simpler to do:
> 
> - dm_setup_md_queue() and dm_swap_table() call dm_init_inline_encryption() after
>   dm_calculate_queue_limits().
> 
> - ksm gets passed to dm_table_set_restrictions(), which calls
>   dm_update_keyslot_manager() (maybe rename to dm_update_inline_encryption()?)
>   to actually set q->ksm.
> 
> That way, the crypto capabilities would be handled similarly to how the
> queue_limits are already handled.
> 
If we call it from dm_swap_table(), we could have it pass the returned
ksm to __bind(), either as a new argument, or by adding the ksm to the
queue_limits (I'll have to check if that's ok/a good idea in the first
place), and __bind() could send the argument to
dm_table_set_restrictions()

But the real issue is, I think we should check whether a new table is
valid (from the ksm capabilities support perspective) at the time that
table is loaded (as opposed to only checking it when DM attempts to swap
it in, which might be a lot later, when the user resumes the device) - so
I can't only call it from dm_setup_md_queue(), and I'd have to call it
from table_load() anyway. And the returned ksm that table_load() obtains
from dm_init_inline_encryption() can't really be used - because
1) the ksm constructed at dm_swap_table() might actually support more
capabilities than the ksm constructed in table_load(), because
underlying devices might get resumed, and have new tables swapped in,
and might support more capabilities than before
2) a subsequent dm_swap_table() call could fail for whatever reason, and
we'll need to revert to the current ksm.

What I'm doing right now is simply freeing the ksm returned by
dm_init_inline_encryption() whenever it's called from table_load()
(and I'm trying to make that process a little nicer by wrapping it in a
function called dm_verify_inline_encryption()) - so if we're going to
have to call dm_init_inline_encryption() and then freeing the returned
ksm in table_load(), I think it might be better to continue to have
dm_verify_inline_encryption(), unless you'd prefer just open coding the
function directly.
> > +static void dm_update_keyslot_manager(struct mapped_device *md,
> > +				      struct blk_keyslot_manager *ksm)
> > +{
> > +	bool ksm_is_empty = true;
> > +	int i;
> > +
> > +	/*
> > +	 * If the new KSM doesn't actually support any crypto modes, we may as
> > +	 * well set a NULL ksm.
> > +	 */
> > +	ksm_is_empty = true;
> > +	for (i = 0; i < ARRAY_SIZE(ksm->crypto_modes_supported); i++) {
> > +		if (ksm->crypto_modes_supported[i]) {
> > +			ksm_is_empty = false;
> > +			break;
> > +		}
> > +	}
> 
> dm_init_inline_encryption() seems like a better place for this "are no modes
> supported" logic.
> 
Alright :)
> > +	if (ksm_is_empty) {
> > +		blk_ksm_destroy(ksm);
> > +
> > +		/* At this point, md->queue->ksm must also be NULL, since we're
> > +		 * guaranteed that ksm is a superset of md->queue->ksm, and we
> > +		 * never set md->queue->ksm to a non-null empty ksm.
> > +		 */
> > +		if (WARN_ON(md->queue->ksm))
> > +			blk_ksm_register(NULL, md->queue);
> > +		return;
> > +	}
> > +
> > +	/* Make the ksm less restrictive */
> > +	if (!md->queue->ksm) {
> > +		blk_ksm_register(ksm, md->queue);
> > +	} else {
> > +		blk_ksm_update_capabilities(md->queue->ksm, ksm);
> > +		blk_ksm_destroy(ksm);
> > +	}
> > +}
> 
> Wouldn't it be simpler to just destroy (and free) the existing
> blk_keyslot_manager (if any), then set the new one (if it's not NULL)?
>
Yeah, I really wanted to do that too, but as I addressed above, I don't
think it's that straightforward :(
> > +static void dm_destroy_inline_encryption(struct mapped_device *md)
> > +{
> > +	if (!md->queue->ksm)
> > +		return;
> > +	blk_ksm_destroy(md->queue->ksm);
> 
> Missing kfree().
>
Thanks, will address this everywhere I call blk_ksm_destroy().
> > +	blk_ksm_unregister(md->queue);
> > +}
> > +
> > +#else /* CONFIG_BLK_INLINE_ENCRYPTION */
> > +
> > +static inline struct blk_keyslot_manager *
> > +dm_init_inline_encryption(struct mapped_device *md, struct dm_table *t)
> > +{
> > +	return NULL;
> > +}
> 
> Seems it would be simpler for these functions to take a request_queue instead of
> a mapped_device.
> 
> >  /*
> >   * Returns old map, which caller must destroy.
> >   */
> > @@ -1959,6 +2164,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
> >  	struct request_queue *q = md->queue;
> >  	bool request_based = dm_table_request_based(t);
> >  	sector_t size;
> > +	struct blk_keyslot_manager *ksm;
> >  	int ret;
> >  
> >  	lockdep_assert_held(&md->suspend_lock);
> > @@ -1994,12 +2200,21 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
> >  		md->immutable_target = dm_table_get_immutable_target(t);
> >  	}
> >  
> > +	ksm = dm_init_inline_encryption(md, t);
> > +	if (IS_ERR(ksm)) {
> > +		old_map = ERR_PTR(PTR_ERR(ksm));
> > +		goto out;
> > +	}
> 
> It seems too late to fail here, since the mapped_device already started being
> updated.  What I suggested above would address this.
>
Alright, I'll move the call to dm_init_inline_encryption() earlier, into
dm_swap_table().
> > +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> > +
> >  /**
> >   * struct blk_ksm_ll_ops - functions to manage keyslots in hardware
> >   * @keyslot_program:	Program the specified key into the specified slot in the
> > @@ -106,6 +108,21 @@ void blk_ksm_reprogram_all_keys(struct blk_keyslot_manager *ksm);
> >  
> >  void blk_ksm_destroy(struct blk_keyslot_manager *ksm);
> >  
> > +void blk_ksm_intersect_modes(struct blk_keyslot_manager *parent,
> > +			     const struct blk_keyslot_manager *child);
> > +
> >  void blk_ksm_init_passthrough(struct blk_keyslot_manager *ksm);
> >  
> > +bool blk_ksm_is_superset(struct blk_keyslot_manager *ksm_superset,
> > +			 struct blk_keyslot_manager *ksm_subset);
> > +
> > +void blk_ksm_update_capabilities(struct blk_keyslot_manager *target_ksm,
> > +				 struct blk_keyslot_manager *reference_ksm);
> > +
> > +#else /* CONFIG_BLK_INLINE_ENCRYPTION */
> > +
> > +static inline void blk_ksm_destroy(struct blk_keyslot_manager *ksm) { }
> > +
> > +#endif /* CONFIG_BLK_INLINE_ENCRYPTION */
> 
> Is the blk_ksm_destroy() stub really needed?
>
I'm calling blk_ksm_destroy() from __bind() wihout any ifdefs, so I
think it's necessary - I'll check again just in case.
> - Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=VcJp=EE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EDEC2D0A3
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:07:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9946E20709
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9946E20709
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-rGSFRqFbMFmPS2MdDrOOdw-1; Thu, 29 Oct 2020 05:07:44 -0400
X-MC-Unique: rGSFRqFbMFmPS2MdDrOOdw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F51964150;
	Thu, 29 Oct 2020 09:07:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFA895C1C4;
	Thu, 29 Oct 2020 09:07:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 51A885810D;
	Thu, 29 Oct 2020 09:07:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09T4iNSn018129 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Oct 2020 00:44:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 03DCE200C0FE; Thu, 29 Oct 2020 04:44:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2FEB2086F75
	for <dm-devel@redhat.com>; Thu, 29 Oct 2020 04:44:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A7AC8007A4
	for <dm-devel@redhat.com>; Thu, 29 Oct 2020 04:44:20 +0000 (UTC)
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
	[209.85.210.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-292-0A-eHYi_NeqN7ehFpjzfLQ-1; Thu, 29 Oct 2020 00:44:17 -0400
X-MC-Unique: 0A-eHYi_NeqN7ehFpjzfLQ-1
Received: by mail-pf1-f196.google.com with SMTP id w65so1335226pfd.3
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 21:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=5PUPJSFf1IHcZvLW1PVN03VSxogpm/JCbVbKtw2WvTQ=;
	b=bpj2E0NniTeLM7Olbt9JCaFuWhadLWmEAvnV83oRRFoGpkXr5l3DYTgDZNzYd1SX9W
	K6wo4Zas30644EQJqNoWk7OrmWyR13QZSDEikQxTxrAGhzuy66sisQMbTJQVlYl2y5ex
	A+ZjkVA4kLKYfnb/4YHv0BTyxgjK9CoR/wexH7FoMmaPt2mM/BKGtuvslBa2var6b5wG
	c+oBgj7a3NjpOL82eV/MiGD+X9lKp97PtljejV6jlu3OSysPG9UFa4lg3QbxiZroiVuz
	F47gm+R6I6nbsrR8UPErO+25yDEGz6DAgf3GWB/rAYTN9hhgfakaNnf056xvQaiTiWDf
	12pA==
X-Gm-Message-State: AOAM531paSHBYJba5sFuye3OehDn1LyaLZ9hEHFzg3GRWUZAaC8lxVzP
	ktr76V4dhf92LBNR+ZuiKSxYTA==
X-Google-Smtp-Source: ABdhPJxP/4Lslk0J56gDWC/rXpJ7gxkisuXPlEZzc78Q1+QkPcuVmuv2E+JEfkdlfp3DBTnt2C6xJA==
X-Received: by 2002:a63:2051:: with SMTP id r17mr2420937pgm.191.1603946655635; 
	Wed, 28 Oct 2020 21:44:15 -0700 (PDT)
Received: from google.com (154.137.233.35.bc.googleusercontent.com.
	[35.233.137.154])
	by smtp.gmail.com with ESMTPSA id t13sm1265110pfc.1.2020.10.28.21.44.14
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 28 Oct 2020 21:44:14 -0700 (PDT)
Date: Thu, 29 Oct 2020 04:44:10 +0000
From: Satya Tangirala <satyat@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <20201029044410.GA1162579@google.com>
References: <20201015214632.41951-1-satyat@google.com>
	<20201015214632.41951-4-satyat@google.com>
	<20201027213151.GC2416412@gmail.com>
	<20201027235847.GA913775@google.com>
	<20201028001731.GA2578048@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20201028001731.GA2578048@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 27, 2020 at 05:17:31PM -0700, Eric Biggers wrote:
> On Tue, Oct 27, 2020 at 11:58:47PM +0000, Satya Tangirala wrote:
> > > > +/**
> > > > + * blk_ksm_update_capabilities() - Update the restrictions of a KSM to those of
> > > > + *				   another KSM
> > > > + * @target_ksm: The KSM whose restrictions to update.
> > > > + * @reference_ksm: The KSM to whose restrictions this function will update
> > > > + *		   @target_ksm's restrictions to,
> > > > + */
> > > > +void blk_ksm_update_capabilities(struct blk_keyslot_manager *target_ksm,
> > > > +				 struct blk_keyslot_manager *reference_ksm)
> > > > +{
> > > > +	memcpy(target_ksm->crypto_modes_supported,
> > > > +	       reference_ksm->crypto_modes_supported,
> > > > +	       sizeof(target_ksm->crypto_modes_supported));
> > > > +
> > > > +	target_ksm->max_dun_bytes_supported =
> > > > +				reference_ksm->max_dun_bytes_supported;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(blk_ksm_update_capabilities);
> > > 
> > > Wouldn't it be easier to replace the original blk_keyslot_manager, rather than
> > > modify it?  Then blk_ksm_update_capabilities() wouldn't be needed.
> > > 
> > I didn't want to replace the original blk_keyslot_manager because it's
> > possible that e.g. fscrypt is checking for crypto capabilities support
> > via blk_ksm_crypto_cfg_supported() when DM wants to replace the
> > blk_keyslot_manager. DM would have to free the memory used by the
> > blk_keyslot_manager, but blk_ksm_crypto_cfg_supported() might still
> > be trying to access that memory. I did it this way to avoid having to
> > add refcounts or something else to the blk_keyslot_manager...(And I
> > didn't bother adding any synchronization code since the capabilities
> > only ever expand, and never contract).
> 
> Are you sure that's possible?  That would imply that there is no synchronization
> between limits/capabilities in the request_queue being changed and the
> request_queue being used.  That's already buggy.  Maybe it's the sort of thing
> that is gotten away with in practice, in which case avoiding a free() would
> indeed be a good idea, but it's worth explicitly clarifying whether all this
> code is indeed racy by design...
> 
I tried checking if the two code regions are reachable at the same time
(by adding some hacky code in the middle of
blk_ksm_crypto_cfg_supported() to loop indefinitely until a certain flag
is set at the end of dm_update_keyslot_manager(), which is right after
where we'd free the old ksm when the table is swapped), and it turns out
the two regions really *can* run at the same time. Otoh, I'd imagine
dm_stop_queue() might synchronize the limits in the request_queue(), but
that's only called on request based DM devices...tl;dr I don't know if
changing limits in the request_queue is racy, but checking for crypto
capabilities is.

In case you're interested, here's the hack I used to test that

diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
index e16e4a074765..918bdd58e6b2 100644
--- a/block/keyslot-manager.c
+++ b/block/keyslot-manager.c
@@ -34,6 +34,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/wait.h>
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 
 struct blk_ksm_keyslot {
 	atomic_t slot_refs;
@@ -284,6 +285,7 @@ void blk_ksm_put_slot(struct blk_ksm_keyslot *slot)
 	}
 }
 
+volatile int my_inline_var = 0;
 /**
  * blk_ksm_crypto_cfg_supported() - Find out if a crypto configuration is
  *				    supported by a ksm.
@@ -297,8 +299,18 @@ void blk_ksm_put_slot(struct blk_ksm_keyslot *slot)
 bool blk_ksm_crypto_cfg_supported(struct blk_keyslot_manager *ksm,
 				  const struct blk_crypto_config *cfg)
 {
+	int mtmp = 0;
+
 	if (!ksm)
 		return false;
+	if (my_inline_var == 0)
+		my_inline_var = 1;
+	while (my_inline_var != 3) {
+		if (mtmp % 10 == 0)
+			printk("In blk_ksm_crypto supported! %d", my_inline_var);
+		mtmp++;
+		msleep(500);
+	}
 	if (!(ksm->crypto_modes_supported[cfg->crypto_mode] &
 	      cfg->data_unit_size))
 		return false;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cb1191d6e945..c6733de1388c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2141,6 +2141,14 @@ static int loop_add(struct loop_device **l, int i)
 	if (!disk)
 		goto out_free_queue;
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	blk_ksm_init_passthrough(&lo->ksm);
+	lo->ksm.max_dun_bytes_supported = 16;
+	lo->ksm.crypto_modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] = 0xFFFFFFFF;
+	lo->ksm.crypto_modes_supported[BLK_ENCRYPTION_MODE_ADIANTUM] = 0xFFFFFFFF;
+	blk_ksm_register(&lo->ksm, lo->lo_queue);
+#endif
+
 	/*
 	 * Disable partition scanning by default. The in-kernel partition
 	 * scanning can be requested individually per-device during its
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index af75a5ee4094..4fc9aa9cab94 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -12,6 +12,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/keyslot-manager.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
@@ -62,6 +63,9 @@ struct loop_device {
 	struct request_queue	*lo_queue;
 	struct blk_mq_tag_set	tag_set;
 	struct gendisk		*lo_disk;
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	struct blk_keyslot_manager	ksm;
+#endif
 };
 
 struct loop_cmd {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 22bb2c90583d..165521d1ade2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2087,7 +2087,7 @@ int dm_verify_inline_encryption(struct mapped_device *md, struct dm_table *t)
 
 	return 0;
 }
-
+extern volatile int my_inline_var;
 static void dm_update_keyslot_manager(struct mapped_device *md,
 				      struct blk_keyslot_manager *ksm)
 {
@@ -2125,6 +2125,11 @@ static void dm_update_keyslot_manager(struct mapped_device *md,
 		blk_ksm_update_capabilities(md->queue->ksm, ksm);
 		blk_ksm_destroy(ksm);
 	}
+	printk("update KSM!");
+	if (my_inline_var == 2) {
+		printk("Update to 3 in ksm update");
+		my_inline_var = 3;
+	}
 }
 
 static void dm_destroy_inline_encryption(struct mapped_device *md)
@@ -2213,6 +2218,11 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		goto out;
 	}
 
+	if (my_inline_var == 1) {
+		printk("Update to 2 in bind");
+		my_inline_var = 2;
+	}
+
 	dm_update_keyslot_manager(md, ksm);
 
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));

Using that patch, I
1) set up a loopback device on a file
2) set up a dm-linear device (dm-0) on that loopback device
3) suspended dm-0
4) loaded a new table to dm-0 (I just used the same table as the existing
   table)
5) tried to read an encrypted file from dm-0 in the background (which
   promptly started printing out "In blk_ksm_crypto supported! 1" every
   5s)
6) resumed dm-0, which causes the "new" table to be swapped in, and sets
   my_inline_var to 3, which eventually results in the read in step 5
   to run to completion.

> > > > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > > > index cd0478d44058..2b3efa9f9fae 100644
> > > > --- a/drivers/md/dm-ioctl.c
> > > > +++ b/drivers/md/dm-ioctl.c
> > > > @@ -1358,6 +1358,10 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
> > > >  		goto err_unlock_md_type;
> > > >  	}
> > > >  
> > > > +	r = dm_verify_inline_encryption(md, t);
> > > > +	if (r)
> > > > +		goto err_unlock_md_type;
> > > > +
> > > >  	if (dm_get_md_type(md) == DM_TYPE_NONE) {
> > > >  		/* Initial table load: acquire type of table. */
> > > >  		dm_set_md_type(md, dm_table_get_type(t));
> > > > @@ -2114,6 +2118,10 @@ int __init dm_early_create(struct dm_ioctl *dmi,
> > > >  	if (r)
> > > >  		goto err_destroy_table;
> > > >  
> > > > +	r = dm_verify_inline_encryption(md, t);
> > > > +	if (r)
> > > > +		goto err_destroy_table;
> > > > +
> > > >  	md->type = dm_table_get_type(t);
> > > >  	/* setup md->queue to reflect md's type (may block) */
> > > >  	r = dm_setup_md_queue(md, t);
> > > 
> > > Both table_load() and dm_early_create() call dm_setup_md_queue().  Wouldn't it
> > > be simpler to handle inline encryption in dm_setup_md_queue(), instead of doing
> > > it in both table_load() and dm_early_create()?
> > > 
> > table_load() only calls dm_setup_md_queue() on initial table load (when
> > the md_type is DM_TYPE_NONE), so I can't call
> > dm_verify_inline_encryption() in only dm_setup_md_queue(), because
> > dm_verify_inline_encryption() needs to run on every table load.
> 
> Where do all the other limitations and capabilities of the request_queue get
> updated on non-initial table loads, then?
> 
I don't think they get updated on non-initial table loads at all - they
only get updated on table swaps. Integrity is, however, an exception -
it gets updated on table loads, and verified on table swaps (and if
verification fails during the swap, it removes the integrity profile
entirely).
> > > > +/**
> > > > + * dm_verify_inline_encryption() - Verifies that the current keyslot manager of
> > > > + *				   the mapped_device can be replaced by the
> > > > + *				   keyslot manager of a given dm_table.
> > > > + * @md: The mapped_device
> > > > + * @t: The dm_table
> > > > + *
> > > > + * In particular, this function checks that the keyslot manager that will be
> > > > + * constructed for the dm_table will support a superset of the capabilities that
> > > > + * the current keyslot manager of the mapped_device supports.
> > > > + *
> > > > + * Return: 0 if the table's keyslot_manager can replace the current keyslot
> > > > + *	   manager of the mapped_device. Negative value otherwise.
> > > > + */
> > > > +int dm_verify_inline_encryption(struct mapped_device *md, struct dm_table *t)
> > > > +{
> > > > +	struct blk_keyslot_manager *ksm = dm_init_inline_encryption(md, t);
> > > > +
> > > > +	if (IS_ERR(ksm))
> > > > +		return PTR_ERR(ksm);
> > > > +	blk_ksm_destroy(ksm);
> > > > +
> > > > +	return 0;
> > > > +}
> > > 
> > > This function seems redundant with dm_init_inline_encryption().  Wouldn't it be
> > > simpler to do:
> > > 
> > > - dm_setup_md_queue() and dm_swap_table() call dm_init_inline_encryption() after
> > >   dm_calculate_queue_limits().
> > > 
> > > - ksm gets passed to dm_table_set_restrictions(), which calls
> > >   dm_update_keyslot_manager() (maybe rename to dm_update_inline_encryption()?)
> > >   to actually set q->ksm.
> > > 
> > > That way, the crypto capabilities would be handled similarly to how the
> > > queue_limits are already handled.
> > > 
> > If we call it from dm_swap_table(), we could have it pass the returned
> > ksm to __bind(), either as a new argument, or by adding the ksm to the
> > queue_limits (I'll have to check if that's ok/a good idea in the first
> > place), and __bind() could send the argument to
> > dm_table_set_restrictions()
> > 
> > But the real issue is, I think we should check whether a new table is
> > valid (from the ksm capabilities support perspective) at the time that
> > table is loaded (as opposed to only checking it when DM attempts to swap
> > it in, which might be a lot later, when the user resumes the device) - so
> > I can't only call it from dm_setup_md_queue(), and I'd have to call it
> > from table_load() anyway. And the returned ksm that table_load() obtains
> > from dm_init_inline_encryption() can't really be used - because
> > 1) the ksm constructed at dm_swap_table() might actually support more
> > capabilities than the ksm constructed in table_load(), because
> > underlying devices might get resumed, and have new tables swapped in,
> > and might support more capabilities than before
> > 2) a subsequent dm_swap_table() call could fail for whatever reason, and
> > we'll need to revert to the current ksm.
> > 
> > What I'm doing right now is simply freeing the ksm returned by
> > dm_init_inline_encryption() whenever it's called from table_load()
> > (and I'm trying to make that process a little nicer by wrapping it in a
> > function called dm_verify_inline_encryption()) - so if we're going to
> > have to call dm_init_inline_encryption() and then freeing the returned
> > ksm in table_load(), I think it might be better to continue to have
> > dm_verify_inline_encryption(), unless you'd prefer just open coding the
> > function directly.
> 
> I don't understand why this needs to be so complicated.  Doesn't the dm layer
> have the same problem for all the other queue limits and capabilities?  What
> makes inline encryption different?
> 
It's this complicated only because I wanted to verify whether the inline
crypto capabilities of the new table are acceptable at table load time,
rather than throwing an error only at table swap time. If we decide
it's alright to throw an error only at table swap time, then
dm_verify_inline_encryption() can go away completely, and we won't need
the code in table_load() and dm_early_create() that calls that
function.
> - Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


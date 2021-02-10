Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C66C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 20:18:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFA4364EE7
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 20:18:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFA4364EE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-tGGul1_DOiOxRYNdojfOvg-1; Wed, 10 Feb 2021 15:17:58 -0500
X-MC-Unique: tGGul1_DOiOxRYNdojfOvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9D3D79EC9;
	Wed, 10 Feb 2021 20:17:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A762D5D9D0;
	Wed, 10 Feb 2021 20:17:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 491444E58E;
	Wed, 10 Feb 2021 20:17:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AKHoNv011099 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 15:17:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 42881F00CB; Wed, 10 Feb 2021 20:17:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D638EAF98
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 20:17:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9C6E858F18
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 20:17:47 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-246-cohp_MsOP0Cxge6nxnt9mQ-1;
	Wed, 10 Feb 2021 15:17:33 -0500
X-MC-Unique: cohp_MsOP0Cxge6nxnt9mQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFADF64EDA;
	Wed, 10 Feb 2021 20:17:31 +0000 (UTC)
Date: Wed, 10 Feb 2021 12:17:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Satya Tangirala <satyat@google.com>
Message-ID: <YCQ/WjAsVA2gdb7d@gmail.com>
References: <20210201051019.1174983-1-satyat@google.com>
	<20210201051019.1174983-4-satyat@google.com>
MIME-Version: 1.0
In-Reply-To: <20210201051019.1174983-4-satyat@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 3/5] dm: add support for passing through
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

On Mon, Feb 01, 2021 at 05:10:17AM +0000, Satya Tangirala wrote:
> Update the device-mapper core to support exposing the inline crypto
> support of the underlying device(s) through the device-mapper device.
> 
> This works by creating a "passthrough keyslot manager" for the dm
> device, which declares support for encryption settings which all
> underlying devices support.  When a supported setting is used, the bio
> cloning code handles cloning the crypto context to the bios for all the
> underlying devices.  When an unsupported setting is used, the blk-crypto
> fallback is used as usual.
> 
> Crypto support on each underlying device is ignored unless the
> corresponding dm target opts into exposing it.  This is needed because
> for inline crypto to semantically operate on the original bio, the data
> must not be transformed by the dm target.  Thus, targets like dm-linear
> can expose crypto support of the underlying device, but targets like
> dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)
> 
> A DM device's table can only be changed if the "new" inline encryption
> capabilities are a (*not* necessarily strict) superset of the "old" inline
> encryption capabilities.  Attempts to make changes to the table that result
> in some inline encryption capability becoming no longer supported will be
> rejected.
> 
> For the sake of clarity, key eviction from underlying devices will be
> handled in a future patch.
> 
> Co-developed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>

I don't see any obvious issues with this latest version.  I assume you've tested
it on real hardware?

If it's needed despite my Co-developed-by, feel free to add:

Reviewed-by: Eric Biggers <ebiggers@google.com>

A few nits about comments, in case you resend:

> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 086d293c2b03..bf3e66f39a4a 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -13,6 +13,7 @@
>  #include <linux/ktime.h>
>  #include <linux/genhd.h>
>  #include <linux/blk-mq.h>
> +#include <linux/keyslot-manager.h>
>  
>  #include <trace/events/block.h>
>  
> @@ -162,6 +163,10 @@ struct dm_table {
>  	void *event_context;
>  
>  	struct dm_md_mempools *mempools;
> +
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	struct blk_keyslot_manager *ksm;
> +#endif
>  };

It might be helpful if there was a brief comment here that explained that this
field is only set temporarily while the table is being set up, and it gets set
to NULL after the capabilities have been transferred to the request_queue.
I.e., it's not something that stays around here while the dm device is active.

> +/*
> + * Constructs and returns a keyslot manager that represents the crypto
> + * capabilities of the devices described by the dm_table. However, if the
> + * constructed keyslot manager does not support a superset of the crypto
> + * capabilities supported by the current keyslot manager of the mapped_device,
> + * it returns an error instead, since we don't support restricting crypto
> + * capabilities on table changes. Finally, if the constructed keyslot manager
> + * doesn't actually support any crypto modes at all, it just returns NULL.
> + */
> +static int
> +dm_table_construct_keyslot_manager(struct dm_table *t)

This doesn't "return" the keyslot manager anymore, but rather assigns it to
t->ksm.  It would also be helpful if the comment explicitly mentioned that the
goal is to find the capabilities that all the devices have in common.

E.g. "Initializes t->ksm with a keyslot manager that represents the common set
of crypto capabilities of the devices described by the dm_table.".

> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 61a66fb8ebb3..d2142f5a82a7 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -257,6 +257,12 @@ struct target_type {
>  #define DM_TARGET_NOWAIT		0x00000080
>  #define dm_target_supports_nowait(type) ((type)->features & DM_TARGET_NOWAIT)
>  
> +/*
> + *
> + */
> +#define DM_TARGET_PASSES_CRYPTO		0x00000100
> +#define dm_target_passes_crypto(type) ((type)->features & DM_TARGET_PASSES_CRYPTO)

The above comment isn't very useful :-)

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D7B2C678D5
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678200460;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q2WjCWsb4IPbXs/R0AUg2l/08O1RDrYDm31+PMaDIXU=;
	b=VyM3wr6xgfVTEqm70ClFpsXd+kbzEg0UspycNIdgczeKm7FZXsh9/0dHPiDH4pEC5ir2VM
	ZYNwsZI3Fd4oWQxUnB1Cr1xYxDE3mMok3IkxhKIgbtPi82R5f6C/5JbKae7oeF2xHDTI0r
	w3bzv4/JqT05lObowpiPlN/mmjZv61c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-NQNGHiCaOlKvPZYRAhuWFg-1; Tue, 07 Mar 2023 09:47:38 -0500
X-MC-Unique: NQNGHiCaOlKvPZYRAhuWFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EF9A3850545;
	Tue,  7 Mar 2023 14:47:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A13082026D4B;
	Tue,  7 Mar 2023 14:47:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 82D8B19465A4;
	Tue,  7 Mar 2023 14:47:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 208651946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 14:47:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E658843FBD; Tue,  7 Mar 2023 14:47:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE98518EC6
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 14:47:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF13B3C1069C
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 14:47:33 +0000 (UTC)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com
 [209.85.219.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-iEsfV6hjNAGPm15pdUny7A-1; Tue, 07 Mar 2023 09:47:32 -0500
X-MC-Unique: iEsfV6hjNAGPm15pdUny7A-1
Received: by mail-qv1-f49.google.com with SMTP id f1so8992851qvx.13
 for <dm-devel@redhat.com>; Tue, 07 Mar 2023 06:47:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678200451;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=rY7eFn4Q8qgMCl47mDyX/pwuMgXfXqOkKnGRS5ZOYfI=;
 b=LKbz4db26RjGL3TpaR0TEhKRKCs9GXeFqRBxnm0Y+8lrC6awRtMvZHrDTNeaZHZxXn
 O3OakZK8u/ByxX+XUiKFFWKqJ5WOyMj8sjYM+Jq0bH/cnd3ggePMIkIPsQZ4bz9JWMUW
 GsrtgZFhWRaDK7hAM24oolqpchwE93/XcpAD+M+LC8uYkp8bKRS+RXDRR3GmofH7N5Ot
 SdDFaWT1326nvRqukIPMz6uB7K9kaXfRs68tLDkTZ2jvS5Wl5ThYNj5xj9QhPRiZhcau
 HQyfTMuL4Pvrp74+gSD6jqaJfOnWaYRHz8UCGkc7VbmyMakDHbiZ6+Kwxc/sUByVVOKd
 hUPg==
X-Gm-Message-State: AO0yUKXuGufxrj2kt8UYc9QNdddUy/KhTkZggfmb5vedq6YXL0P/lgol
 Ed8+JUbBdwa6+Brf5Zpl4twzEOE=
X-Google-Smtp-Source: AK7set/OnKd4+iM4tpEYcp68JftoiqCoTezpQd8iSBuvpEHUCdOGLTJ16HgT2GvkXb9Ez8q6pVEgmg==
X-Received: by 2002:a05:6214:2681:b0:56e:a9c6:d2c6 with SMTP id
 gm1-20020a056214268100b0056ea9c6d2c6mr25249935qvb.6.1678200451250; 
 Tue, 07 Mar 2023 06:47:31 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 x21-20020a05620a01f500b0071eddd3bebbsm9578852qkn.81.2023.03.07.06.47.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Mar 2023 06:47:30 -0800 (PST)
Date: Tue, 7 Mar 2023 09:47:29 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Hou Tao <houtao@huaweicloud.com>
Message-ID: <ZAdOgUdqwLpUyPlc@redhat.com>
References: <20230306134930.2878660-1-houtao@huaweicloud.com>
 <ZAY/o9ew9AtrCLE5@redhat.com>
 <e9b61952-98a8-6e3b-2d85-6aaf07208a7b@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <e9b61952-98a8-6e3b-2d85-6aaf07208a7b@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] dm crypt: initialize tasklet in crypt_io_init()
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
Cc: houtao1@huawei.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 mpatocka@redhat.com, Ignat Korchagin <ignat@cloudflare.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 06 2023 at  9:12P -0500,
Hou Tao <houtao@huaweicloud.com> wrote:

> Hi,
> 
> On 3/7/2023 3:31 AM, Mike Snitzer wrote:
> > On Mon, Mar 06 2023 at  8:49P -0500,
> > Hou Tao <houtao@huaweicloud.com> wrote:
> >
> >> From: Hou Tao <houtao1@huawei.com>
> >>
> >> When neither no_read_workqueue nor no_write_workqueue are enabled,
> >> tasklet_trylock() in crypt_dec_pending() may still return false due to
> >> an uninitialized state, and dm-crypt will do io completion in io_queue
> >> instead of current context unnecessarily.
> > Have you actually experienced this?
>
> Yes. I had written a bpftrace script to check the completion context of
> blkdev_bio_end_io_simple() when doing direct io read on dm-crypt device. The
> expected context should be unbound workers of crypt_queue, but sometimes the
> context is the bound worker of io_queue.

OK, thanks for clarifying.  Curious to know the circumstance (I
thought per-bio-data is zero'd -- but it may be I'm mistaken).

I won't be marking this commit for stable@ but if others feel
differently please let me know and I'll do so. (We can always propose
it to stable@, after the fact, even if the commit header doesn't Cc
stable@)

> >> Fix it by initializing io->tasklet in crypt_io_init().
> > Really would rather avoid always calling tasklet_init(). But I can
> > optimize it away with a later patch.
>
> My first though was "io->tasklet.state = 0", but it may be fragile because it
> operated on the internal status of tasklet, so I switch to tasklet_init().

Yes, I looked into it and came up with the same hack.. and I too felt
it was too fragile due to open-coding direct access to the tasklet's
members.

I have a patch I just staged that staged that uses jump_labels to
optimize this code.  If you might review/test/verify it works well for
you that'd be appreciated:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=ae75a25bd83f7c541240449d2fff3a44433e506b

It builds on your patch, which I added a comment to:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=d9fe0a98a2e0a1cf585e8a6555afb33be968bd13

From: Mike Snitzer <snitzer@kernel.org>
Date: Mon, 6 Mar 2023 15:58:33 -0500
Subject: [PATCH] dm crypt: conditionally enable code needed for tasklet usecases

Use jump_label to limit the need for branching, and tasklet_init(),
unless either of the optional "no_read_workqueue" and/or
"no_write_workqueue" features are used.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-crypt.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 641457e72603..2d0309ca07f5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -40,6 +40,7 @@
 #include <keys/user-type.h>
 #include <keys/encrypted-type.h>
 #include <keys/trusted-type.h>
+#include <linux/jump_label.h>
 
 #include <linux/device-mapper.h>
 
@@ -85,6 +86,8 @@ struct dm_crypt_io {
 	struct rb_node rb_node;
 } CRYPTO_MINALIGN_ATTR;
 
+static DEFINE_STATIC_KEY_FALSE(use_tasklet_enabled);
+
 struct dm_crypt_request {
 	struct convert_context *ctx;
 	struct scatterlist sg_in[4];
@@ -1730,12 +1733,15 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->sector = sector;
 	io->error = 0;
 	io->ctx.r.req = NULL;
-	/*
-	 * tasklet_init() here to ensure crypt_dec_pending()'s
-	 * tasklet_trylock() doesn't incorrectly return false
-	 * even when tasklet isn't in use.
-	 */
-	tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
+	if (static_branch_unlikely(&use_tasklet_enabled)) {
+		/*
+		 * tasklet_init() here to ensure crypt_dec_pending()'s
+		 * tasklet_trylock() doesn't incorrectly return false
+		 * even when tasklet isn't in use.
+		 */
+		tasklet_init(&io->tasklet, kcryptd_crypt_tasklet,
+			     (unsigned long)&io->work);
+	}
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
 	atomic_set(&io->io_pending, 0);
@@ -1775,6 +1781,10 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 		kfree(io->integrity_metadata);
 
 	base_bio->bi_status = error;
+	if (!static_branch_unlikely(&use_tasklet_enabled)) {
+		bio_endio(base_bio);
+		return;
+	}
 
 	/*
 	 * If we are running this function from our tasklet,
@@ -2232,8 +2242,9 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 
-	if ((bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
-	    (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
+	if (static_branch_unlikely(&use_tasklet_enabled) &&
+	    ((bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
+	     (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)))) {
 		/*
 		 * in_hardirq(): Crypto API's skcipher_walk_first() refuses to work in hard IRQ context.
 		 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
@@ -2746,6 +2757,10 @@ static void crypt_dtr(struct dm_target *ti)
 	crypt_calculate_pages_per_client();
 	spin_unlock(&dm_crypt_clients_lock);
 
+	if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags) ||
+	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
+		static_branch_dec(&use_tasklet_enabled);
+
 	dm_audit_log_dtr(DM_MSG_PREFIX, ti, 1);
 }
 
@@ -3375,6 +3390,10 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->limit_swap_bios = true;
 	ti->accounts_remapped_io = true;
 
+	if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags) ||
+	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
+		static_branch_inc(&use_tasklet_enabled);
+
 	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
 	return 0;
 
-- 
2.37.1 (Apple Git-137.1)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=kuEZ=GQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A656DC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 19:19:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC7C3217BA
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 19:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC7C3217BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-0gOD8iE2NDKYJL6Gt-Q5pw-1; Wed, 13 Jan 2021 14:18:59 -0500
X-MC-Unique: 0gOD8iE2NDKYJL6Gt-Q5pw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 440B61034B05;
	Wed, 13 Jan 2021 19:18:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0E085D9F4;
	Wed, 13 Jan 2021 19:18:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 122B85002C;
	Wed, 13 Jan 2021 19:18:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10DJF5hD016728 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Jan 2021 14:15:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AC097101B73B; Wed, 13 Jan 2021 19:15:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8007101B733
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 19:15:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D69B101042D
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 19:15:02 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-94-4b4w8RbJP1CSKgCbdRFKyQ-1; Wed, 13 Jan 2021 14:15:00 -0500
X-MC-Unique: 4b4w8RbJP1CSKgCbdRFKyQ-1
Received: by mail-pj1-f46.google.com with SMTP id j13so1802322pjz.3
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:14:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
	:mime-version:content-transfer-encoding;
	bh=QV7CCVnr0hRxwERgOubKWnTd8AO41CRti7z6Nf1xz20=;
	b=bG5AgbIywxFOidv89XD/Fo9mQWX52X9nrMpZhWq4CR+6TDkm16wgbP5kk61JhhDaYk
	TJrWtrVMZ8gevmg2TNE8JHRQ8wnZxWx5dozYqQip/Lyhf8Colwkh0i1KrnabXWBTOuw2
	Ymlw468lgKzMtVtrvYL5nj3ryyOK4Cnw0UMnKNkqF+FX3VRZQXZ5RKTBNgJFutwHuOvO
	TEoi02PZQapUpAfmPjTUoDboa8eH9es15qJowxt3rckBsn4o0idd+dFueQvXskR1Vnp1
	9KKsLFCKRi10s+GLFAznfLOf8Wf1bdfV3KNuUgQjLptJ3hBh4otZ0wTrGOJ8B78169Vc
	uQjw==
X-Gm-Message-State: AOAM532Thdy8poB/diEk8lCAozSLvDDUpqJtL3GfBfdkAM8NEEvGS+of
	x5jnByS6M70onTPeeIhywqRbuA==
X-Google-Smtp-Source: ABdhPJyK7Q/nG/8kEXLMTMhhEOT2nDYHx7gK6IRp52RYkswXs9uEmohuDcpHAkG/orAIZHMEqjhuZQ==
X-Received: by 2002:a17:90a:ae13:: with SMTP id
	t19mr836640pjq.52.1610565298698; 
	Wed, 13 Jan 2021 11:14:58 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223]) by smtp.gmail.com with ESMTPSA id
	z125sm3262354pfz.121.2021.01.13.11.14.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 13 Jan 2021 11:14:58 -0800 (PST)
Date: Wed, 13 Jan 2021 11:14:58 -0800 (PST)
X-Google-Original-Date: Wed, 13 Jan 2021 11:14:56 PST (-0800)
In-Reply-To: <ecb35731d19b41984dd7157d48661f5297a1b668.1609119545.git.akailash@google.com>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: kernel-team@android.com
Message-ID: <mhng-81f035b4-1104-44e8-9099-4a99972512b3@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	David Anderson <dvander@google.com>,
	Akilesh Kailash <akailash@google.com>, kernel-team@android.com,
	agk@redhat.com
Subject: Re: [dm-devel] [PATCH] dm-snapshot: Flush merged data before
	committing metadata
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Sun, 27 Dec 2020 23:14:07 PST (-0800), kernel-team@android.com wrote:
> If the origin device has a volatile write-back
> cache and the following events occur:
>
> 1: After finishing merge operation of one set of exceptions,
>    merge_callback() is invoked.
> 2: Update the metadata in COW device tracking the merge completion.
>    This update to COW device is flushed cleanly.
> 3: System crashes and the origin device's cache where the recent
>    merge was completed has not been flushed.
>
> During the next cycle when we read the metadata from the COW device,
> we will skip reading those metadata whose merge was completed in
> step (1). This will lead to data loss/corruption.
>
> To address this, flush the origin device post merge IO before
> updating the metadata.

This is essentially the same as the flushes added in 8b3fd1f53af3 ("dm clone:
Flush destination device before committing metadata") and 694cfe7f31db ("dm
thin: Flush data device before committing metadata"), but for dm-snap.  Looks
like this bug has been around since before the git tree, so I'm not sure what
the right thing to do with a Fixes tag is.

> Signed-off-by: Akilesh Kailash <akailash@google.com>
> ---
>  drivers/md/dm-snap.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index 4668b2cd98f4..11890db71f3f 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -141,6 +141,11 @@ struct dm_snapshot {
>  	 * for them to be committed.
>  	 */
>  	struct bio_list bios_queued_during_merge;
> +
> +	/*
> +	 * Flush data after merge.
> +	 */
> +	struct bio flush_bio;
>  };
>
>  /*
> @@ -1121,6 +1126,17 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
>
>  static void error_bios(struct bio *bio);
>
> +static int flush_data(struct dm_snapshot *s)
> +{
> +	struct bio *flush_bio = &s->flush_bio;
> +
> +	bio_reset(flush_bio);
> +	bio_set_dev(flush_bio, s->origin->bdev);
> +	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
> +
> +	return submit_bio_wait(flush_bio);
> +}
> +
>  static void merge_callback(int read_err, unsigned long write_err, void *context)
>  {
>  	struct dm_snapshot *s = context;
> @@ -1134,6 +1150,11 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
>  		goto shut;
>  	}
>
> +	if (flush_data(s) < 0) {
> +		DMERR("Flush after merge failed: shutting down merge");
> +		goto shut;
> +	}
> +
>  	if (s->store->type->commit_merge(s->store,
>  					 s->num_merging_chunks) < 0) {
>  		DMERR("Write error in exception store: shutting down merge");
> @@ -1318,6 +1339,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	s->first_merging_chunk = 0;
>  	s->num_merging_chunks = 0;
>  	bio_list_init(&s->bios_queued_during_merge);
> +	bio_init(&s->flush_bio, NULL, 0);

There's no bio_uninit() in the error handling code here, but there aren't any
in any of the other cleanup blocks either.  The bio_uninit() call won't do
anything here, as it does nothing for empty BIOs, so I guess it just doesn't
matter.

>  	/* Allocate hash table for COW data */
>  	if (init_hash_tables(s)) {
> @@ -1504,6 +1526,8 @@ static void snapshot_dtr(struct dm_target *ti)
>
>  	dm_exception_store_destroy(s->store);
>
> +	bio_uninit(&s->flush_bio);
> +
>  	dm_put_device(ti, s->cow);
>
>  	dm_put_device(ti, s->origin);

Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


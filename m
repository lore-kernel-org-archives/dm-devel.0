Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2B2C433E6
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:22:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5B0E523A9A
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:22:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B0E523A9A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-0kUyBI93OTOAfjIKU5tXnw-1; Fri, 22 Jan 2021 10:22:22 -0500
X-MC-Unique: 0kUyBI93OTOAfjIKU5tXnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97D0410054FF;
	Fri, 22 Jan 2021 15:22:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 786D75D6CF;
	Fri, 22 Jan 2021 15:22:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4CBC24BB7B;
	Fri, 22 Jan 2021 15:22:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MFMFoN028260 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 10:22:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1DD5110E60D8; Fri, 22 Jan 2021 15:22:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 193E010E60E0
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:22:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9283187504D
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:22:12 +0000 (UTC)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
	[209.85.128.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-498-JD4s2puCM_2qoblxlwxeLA-1; Fri, 22 Jan 2021 10:22:10 -0500
X-MC-Unique: JD4s2puCM_2qoblxlwxeLA-1
Received: by mail-wm1-f49.google.com with SMTP id e15so4669979wme.0
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 07:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=lOrYyrPHTDmlXZluAfnPR6agdhIvdZdPjBYpdH81YI4=;
	b=bjYBZwwKpwddHzrJ0f7zqxeauyoyob8Ve03oL07DK1gJaYndfG5c6IljFgb58R2HF7
	1xB3rbgxlJ2LCs5QQLXkmA7WYMVEOIN5aw0DuObxfNE6hfdhUL8o4XdKYVjkCxxJyVSa
	q8QkGvSvr2uqXMNXs6HsHXtREU87V18QOMXSxAHYjMLVnGBoblgIiHknYHCK4b5OhdUB
	j4MuZUvI5JUTwMdlTtJCOu3p4DFJ5lepqekvTicleODwJM9aU0wRZu6M6vswGoeSKQQF
	hH+3fOhmOe+BCrRN3AdOY/0tTAG4f636bjt0vDiEphcpAw83ucgw9SM8z15oIHnP8ift
	vzdg==
X-Gm-Message-State: AOAM533Z6SiA9WVMUx02cwb2zAnLc2fD4zu+1zaQj23G05z4y9Ln72RC
	I584NTQGridMejyRJyVcEU9JIg==
X-Google-Smtp-Source: ABdhPJybGyjlYGawF9ROG2rEF3eKOgPfz9MG5sTHJMneH/9krnjomg4EAHCeMEcA8xea3K+knzEv/A==
X-Received: by 2002:a1c:6109:: with SMTP id v9mr4497969wmb.144.1611328929212; 
	Fri, 22 Jan 2021 07:22:09 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	z1sm12660938wru.70.2021.01.22.07.22.07
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 22 Jan 2021 07:22:08 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Fri, 22 Jan 2021 17:22:04 +0200
Message-Id: <20210122152204.24738-2-ntsironis@arrikto.com>
In-Reply-To: <20210122152204.24738-1-ntsironis@arrikto.com>
References: <20210122152204.24738-1-ntsironis@arrikto.com>
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
Cc: ejt@redhat.com, ntsironis@arrikto.com
Subject: [dm-devel] [PATCH 1/1] dm era: Reinitialize bitset cache before
	digesting a new writeset
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In case of devices with at most 64 blocks, the digestion of consecutive
eras uses the writeset of the first era as the writeset of all eras to
digest, leading to lost writes. That is, we lose the information about
what blocks were written during the affected eras.

The digestion code uses a dm_disk_bitset object to access the archived
writesets. This structure includes a one word (64-bit) cache to reduce
the number of array lookups.

This structure is initialized only once, in metadata_digest_start(),
when we kick off digestion.

But, when we insert a new writeset into the writeset tree, before the
digestion of the previous writeset is done, or equivalently when there
are multiple writesets in the writeset tree to digest, then all these
writesets are digested using the same cache and the cache is not
re-initialized when moving from one writeset to the next.

For devices with more than 64 blocks, i.e., the size of the cache, the
cache is indirectly invalidated when we move to a next set of blocks, so
we avoid the bug.

But for devices with at most 64 blocks we end up using the same cached
data for digesting all archived writesets, i.e., the cache is loaded
when digesting the first writeset and it never gets reloaded, until the
digestion is done.

As a result, the writeset of the first era to digest is used as the
writeset of all the following archived eras, leading to lost writes.

Fix this by reinitializing the dm_disk_bitset structure, and thus
invalidating the cache, every time the digestion code starts digesting a
new writeset.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index b24e3839bb3a..951e6df409d4 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -746,6 +746,12 @@ static int metadata_digest_lookup_writeset(struct era_metadata *md,
 	ws_unpack(&disk, &d->writeset);
 	d->value = cpu_to_le32(key);
 
+	/*
+	 * We initialise another bitset info to avoid any caching side effects
+	 * with the previous one.
+	 */
+	dm_disk_bitset_init(md->tm, &d->info);
+
 	d->nr_bits = min(d->writeset.nr_bits, md->nr_blocks);
 	d->current_bit = 0;
 	d->step = metadata_digest_transcribe_writeset;
@@ -759,12 +765,6 @@ static int metadata_digest_start(struct era_metadata *md, struct digest *d)
 		return 0;
 
 	memset(d, 0, sizeof(*d));
-
-	/*
-	 * We initialise another bitset info to avoid any caching side
-	 * effects with the previous one.
-	 */
-	dm_disk_bitset_init(md->tm, &d->info);
 	d->step = metadata_digest_lookup_writeset;
 
 	return 0;
-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


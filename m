Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02635C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532969;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eyDnQBeg85TFQfxTIKFLqxOg5BlkLOx0OEjR8otTYI8=;
	b=aKyf7KimnkVItmyIV7TeWlVjVajFTD/yJfhVQxLuZoWLC0DMbRvryqzBvfhcwNt5N0XrZ0
	nNTxbr7Tcv1CkpbxQEHlGOeaiPoAmIWYpHeNxSB6hOLUQ0MTSXcfLpA01oLgqehDL2f3a7
	wAWIieMrelJD7w+IyLcA6WgEJBtUjdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-oF5MIT9sM3OP1KNYna1o-A-1; Thu, 10 Feb 2022 17:42:46 -0500
X-MC-Unique: oF5MIT9sM3OP1KNYna1o-A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35B2864145;
	Thu, 10 Feb 2022 22:42:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C2784696D;
	Thu, 10 Feb 2022 22:42:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA5014A7CA;
	Thu, 10 Feb 2022 22:42:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcp3b014845 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 70875492D51; Thu, 10 Feb 2022 22:38:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CEEB492D47
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 593051C05157
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:51 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-638-MaI3DOEKNriyyZI7Wq8RWg-1; Thu, 10 Feb 2022 17:38:50 -0500
X-MC-Unique: MaI3DOEKNriyyZI7Wq8RWg-1
Received: by mail-qk1-f200.google.com with SMTP id
	d11-20020a37680b000000b0047d87e46f4aso4556697qkc.11
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=QSJblWqLgyZmlZxEVd+22+iLGNHpkwCdE5Y4iGn/nKk=;
	b=KCKTCWLEXnQMuARY/mKovKvjGafbAJZ1xhzPwReQuChihovGHhM3GCbsO9qUoADGY9
	hkCCEH+FzuhZkEjTdICGnjHtXoCT9gNlU/Q/2kYRjxBJ22LdshGxgi14Se6jSMLRJrr3
	IpoWRKYPyNkUQEi2CvRd0jF6nmeGxbxlZ5dQW1qt+5aPLIuNhVmjRTJ0VD8qND5sM8ZN
	8tFijYKv7Icxi/5BeWDuvSR7x7zpYfF1T9HNEMsuQqHWImEFj7jML/9oa3e9JU6hN1k0
	QMm4qgG44DXltuYUqStM/5/jXcgPgdfV2aAZD4gSwzrCBOuawV5I4JQ4S968jCYx70CV
	qoGw==
X-Gm-Message-State: AOAM530JTbShADMwL8wXhzN4wuiy/umzbVtk5TYXzntZnQ1Vwsw6PSDj
	MY3FiQpDktIZ4wtbRpOEHUzGxUbTxIMF34OcowPGZQMc3HqpsBW/970TioI0R8QlVm24hF4qBAw
	eJs1wX0WLYnnRuA7Yba0Lr/Cko9YO00FMDjTwDRROn5WZzD82fr4zpu1CJjCWBP96LA==
X-Received: by 2002:a05:622a:411:: with SMTP id
	n17mr6496120qtx.466.1644532729551; 
	Thu, 10 Feb 2022 14:38:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzT+PtvXuOy9fF5SaJVeCa3zFUy2819JDuwEm2PCy3GAfUwDOgDHA08+EaJap4V4vdpA0o8KQ==
X-Received: by 2002:a05:622a:411:: with SMTP id
	n17mr6496110qtx.466.1644532729298; 
	Thu, 10 Feb 2022 14:38:49 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	j11sm11447294qtx.67.2022.02.10.14.38.48
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:48 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:29 -0500
Message-Id: <20220210223832.99412-12-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 11/14] dm crypt: use dm_submit_bio_remap
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a5006cb6ee8a..9ea197de08c2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1855,7 +1855,7 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 		return 1;
 	}
 
-	submit_bio_noacct(clone);
+	dm_submit_bio_remap(io->base_bio, clone);
 	return 0;
 }
 
@@ -1881,7 +1881,7 @@ static void kcryptd_io_write(struct dm_crypt_io *io)
 {
 	struct bio *clone = io->ctx.bio_out;
 
-	submit_bio_noacct(clone);
+	dm_submit_bio_remap(io->base_bio, clone);
 }
 
 #define crypt_io_from_node(node) rb_entry((node), struct dm_crypt_io, rb_node)
@@ -1960,7 +1960,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 
 	if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||
 	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
-		submit_bio_noacct(clone);
+		dm_submit_bio_remap(io->base_bio, clone);
 		return;
 	}
 
@@ -3363,6 +3363,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
+	ti->accounts_remapped_io = true;
 
 	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
 	return 0;
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


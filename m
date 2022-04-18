Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CAFC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-kaSAp3_fPYehPsDW23Pn_w-1; Sun, 17 Apr 2022 22:27:59 -0400
X-MC-Unique: kaSAp3_fPYehPsDW23Pn_w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7702D299E74B;
	Mon, 18 Apr 2022 02:27:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C674416363;
	Mon, 18 Apr 2022 02:27:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 09D0A19451F1;
	Mon, 18 Apr 2022 02:27:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 60C2019466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 49977416363; Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4638F401E9A
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CBEF803D7C
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:54 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-AeBIvqsuMeCBw_cTK-jXLQ-6; Sun, 17 Apr 2022 22:27:52 -0400
X-MC-Unique: AeBIvqsuMeCBw_cTK-jXLQ-6
Received: by mail-qk1-f169.google.com with SMTP id c1so10333853qkf.13
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=dQ9JsuvkqaeV0u/P5qcjq2a/yhHZyU2CtqcgbhCt5mY=;
 b=tE1lClaeURYcqYLXWWZq1ajyhyEYLpxcQ28K/+SYF4VVCAIzPW8cJ4B/T76ffrgDtw
 X4fblqc9pCb4TpgtWCYDBQlDj71HrD/9cKbrpa+cqj5FLI+t9vnL+jU7i4PE4LrSoc+Q
 8FlscdmjlPTqtkv0x24S6mdiWBTzn582T6XArmwd1jZp/OGYBuBjcHaFz5UZ+pWUV+YR
 YyE57DkTg8SRUdaBQknZcPV/vbce2vszI8RbCntYwddooc+s41qFohSGJPStZ3TNOnaJ
 g1VmnRyX2gKXUl85thG6CHo5CnBMXXAH1lYgsBJ84gP2HgZzx1ATXsHUVm56pAvOomuO
 wrPA==
X-Gm-Message-State: AOAM530o97av6KwbwM0JhsEytz5eEjY1wjah7kp7QXwMQeVncfO8N/eL
 fAEX8phLzBpCc2xVmEYj7V/paMS5kTQPxRZcOvMgPfnRoh5zhRXOLGMDS6X+FmAr3gUk+2I0VU+
 OslyEIxMfn2kkpV8QSynT76vRlQPDPh0/5NqlzlIfNgu0mSn49N4NZBPktn7oUZUbmzA=
X-Google-Smtp-Source: ABdhPJy4lWMi6x4Gm27iaHO2SeoroM82SqmhnueY7DHUihF9VERAz4+33ZiY57dAqljYYJjWheFAzg==
X-Received: by 2002:a05:620a:2804:b0:67d:1e7b:b528 with SMTP id
 f4-20020a05620a280400b0067d1e7bb528mr5418927qkp.193.1650248872075; 
 Sun, 17 Apr 2022 19:27:52 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 c28-20020a05620a269c00b0069e8a1950fdsm1822261qkp.22.2022.04.17.19.27.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:51 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:26 -0400
Message-Id: <20220418022733.56168-15-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [dm-5.19 PATCH 14/21] dm: pass dm_io instance to
 dm_io_acct directly
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
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3742127568998941160=="

--===============3742127568998941160==
Content-Type: application/octet-stream; x-default=true

From: Ming Lei <ming.lei@redhat.com>

All the other 4 parameters are retrieved from the 'dm_io' instance, so
it's not necessary to pass all four to dm_io_acct().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9012cd1eff1f..f100ced29e0d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -502,9 +502,12 @@ static bool bio_is_flush_with_data(struct bio *bio)
 	return ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size);
 }
 
-static void dm_io_acct(bool end, struct mapped_device *md, struct bio *bio,
-		       unsigned long start_time, struct dm_stats_aux *stats_aux)
+static void dm_io_acct(struct dm_io *io, bool end)
 {
+	struct dm_stats_aux *stats_aux = &io->stats_aux;
+	unsigned long start_time = io->start_time;
+	struct mapped_device *md = io->md;
+	struct bio *bio = io->orig_bio;
 	bool is_flush_with_data;
 	unsigned int bi_size;
 
@@ -533,7 +536,7 @@ static void dm_io_acct(bool end, struct mapped_device *md, struct bio *bio,
 
 static void __dm_start_io_acct(struct dm_io *io)
 {
-	dm_io_acct(false, io->md, io->orig_bio, io->start_time, &io->stats_aux);
+	dm_io_acct(io, false);
 }
 
 static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
@@ -560,7 +563,7 @@ static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
 
 static void dm_end_io_acct(struct dm_io *io)
 {
-	dm_io_acct(true, io->md, io->orig_bio, io->start_time, &io->stats_aux);
+	dm_io_acct(io, true);
 }
 
 static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
-- 
2.15.0


--===============3742127568998941160==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3742127568998941160==--


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0B60C00140
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658851817;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I6VLEdCNWZo+iwD5MexpfKdtulM0XT90ONnAmD/FWAg=;
	b=CSfmb/9mnmNIDUshp4h5zdBY2I8hpET0RcxHpHn8aBiJaYeSUrsetAO1WhZnWU59SLvMD9
	WdOPwhQSIltlaJaGj9FTsjqVE26lfiquaG1rksOyF3lJqXJUUKe8+og6Sgm/L791HDHEEc
	/O739snoTBtJW0Fmq9QL+f3r6cQkp+4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-QqswTRaVOQqjKwqMA95FSQ-1; Tue, 26 Jul 2022 12:10:15 -0400
X-MC-Unique: QqswTRaVOQqjKwqMA95FSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AE1B1019C8F;
	Tue, 26 Jul 2022 16:10:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 69D402166B26;
	Tue, 26 Jul 2022 16:10:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2735E1945DB1;
	Tue, 26 Jul 2022 16:10:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD7281947053
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 16:10:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE21E40357BA; Tue, 26 Jul 2022 16:10:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9FFF40C128A
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0EB9804197
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:09 +0000 (UTC)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-G7c4n42MNfWVMawn4rUunw-1; Tue, 26 Jul 2022 12:10:07 -0400
X-MC-Unique: G7c4n42MNfWVMawn4rUunw-1
Received: by mail-qk1-f172.google.com with SMTP id f14so11346853qkm.0
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 09:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=YkgkA2+j0E5LsjaFVlZALOdG0CjEFLTXs98W8Zo/tZU=;
 b=1vvwoBfsUYxbKCDIk0M6YCqAZWzjobr0kgqRq76u2JFuSHG1AlODMTC6BaMfgRenJw
 BIVDGXBnM53t2DIDq5wh0rCAsF7qZ3iSq+8nCgiGF9SCbJEbpatdSSCmNYVu/BRoo1Dx
 Y6W19vbwTl7Uclhx9NNdSlt/fmdwFoISgLLJo4kZZf/ckm2oFzf5jwlAzlweBPSaFaT8
 OJJ4oSZy6LQFgxChGO3S3nSalPp6QLETXB37xnbpiLGqV5YheHi1OJVKl9APv54rr7rk
 +48pVaGdDMZcKffMHYi77k+kjbh+XqsV3J7oqLhnN4/cNZNAsV9Z9FhSUWd2yIv0xdPe
 o7ng==
X-Gm-Message-State: AJIora8FeBDfRDvviFvb3lapd1XS4V4og4MmvdiXzWZB1Cp5D/fJC4eT
 zlLTr2iIDWqfraPT730wTAW74NQ=
X-Google-Smtp-Source: AGRyM1sjQeG7eIkusXe8fGvaf3TqtNgbevqNNLNMLqb4iRoybl89PNKGeJFmNjnlRa0950UNx4TI4g==
X-Received: by 2002:a05:620a:4116:b0:6b6:31e:b7ed with SMTP id
 j22-20020a05620a411600b006b6031eb7edmr13705750qko.529.1658851806856; 
 Tue, 26 Jul 2022 09:10:06 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 h22-20020ac87156000000b0031ef622a6a2sm9086723qtp.17.2022.07.26.09.10.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 09:10:06 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Nathan Huckleberry <nhuck@google.com>, Eric Biggers <ebiggers@kernel.org>
Date: Tue, 26 Jul 2022 12:09:57 -0400
Message-Id: <20220726160959.89247-5-snitzer@kernel.org>
In-Reply-To: <20220726160959.89247-1-snitzer@kernel.org>
References: <20220726160959.89247-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 4/6] dm verity: allow optional args to alter
 primary args handling
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
Cc: dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 6d891d0978a2 ("dm verity: Add optional "try_verify_in_tasklet"
feature") imposed that CRYPTO_ALG_ASYNC mask be used even if the
optional "try_verify_in_tasklet" feature was not specified. This was
because verity_parse_opt_args() was called after handling the primary
args (due to it having data dependencies on having first parsed all
primary args).

Enhance verity_ctr() so that simple optional args, that don't have a
data dependency on primary args parsing, can alter how the primary
args are handled. In practice this means verity_parse_opt_args() gets
called twice. First with the new 'only_modifier_opts' arg set to true,
then again with it set to false _after_ parsing all primary args.

This allows the v->use_tasklet flag to be properly set and then used
when verity_ctr() parses the primary args and then calls
crypto_alloc_ahash().

Fixes: 6d891d0978a2 ("dm verity: Add optional "try_verify_in_tasklet" feature")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-verity-target.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 3b566077a74e..054095c2052b 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1022,7 +1022,8 @@ static int verity_parse_verity_mode(struct dm_verity *v, const char *arg_name)
 }
 
 static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
-				 struct dm_verity_sig_opts *verify_args)
+				 struct dm_verity_sig_opts *verify_args,
+				 bool only_modifier_opts)
 {
 	int r;
 	unsigned argc;
@@ -1045,6 +1046,8 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		argc--;
 
 		if (verity_is_verity_mode(arg_name)) {
+			if (only_modifier_opts)
+				continue;
 			r = verity_parse_verity_mode(v, arg_name);
 			if (r) {
 				ti->error = "Conflicting error handling parameters";
@@ -1053,6 +1056,8 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_IGN_ZEROES)) {
+			if (only_modifier_opts)
+				continue;
 			r = verity_alloc_zero_digest(v);
 			if (r) {
 				ti->error = "Cannot allocate zero digest";
@@ -1061,6 +1066,8 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_AT_MOST_ONCE)) {
+			if (only_modifier_opts)
+				continue;
 			r = verity_alloc_most_once(v);
 			if (r)
 				return r;
@@ -1071,12 +1078,16 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 			continue;
 
 		} else if (verity_is_fec_opt_arg(arg_name)) {
+			if (only_modifier_opts)
+				continue;
 			r = verity_fec_parse_opt_args(as, v, &argc, arg_name);
 			if (r)
 				return r;
 			continue;
 
 		} else if (verity_verify_is_sig_opt_arg(arg_name)) {
+			if (only_modifier_opts)
+				continue;
 			r = verity_verify_sig_parse_opt_args(as, v,
 							     verify_args,
 							     &argc, arg_name);
@@ -1143,6 +1154,15 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
+	/* Parse optional parameters that modify primary args */
+	if (argc > 10) {
+		as.argc = argc - 10;
+		as.argv = argv + 10;
+		r = verity_parse_opt_args(&as, v, &verify_args, true);
+		if (r < 0)
+			goto bad;
+	}
+
 	if (sscanf(argv[0], "%u%c", &num, &dummy) != 1 ||
 	    num > 1) {
 		ti->error = "Invalid version";
@@ -1214,11 +1234,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	/*
-	 * FIXME: CRYPTO_ALG_ASYNC should be conditional on v->use_tasklet
-	 * but verity_parse_opt_args() happens below and has data dep on tfm.
-	 */
-	v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);
+	v->tfm = crypto_alloc_ahash(v->alg_name, 0,
+				    v->use_tasklet ? CRYPTO_ALG_ASYNC : 0);
 	if (IS_ERR(v->tfm)) {
 		ti->error = "Cannot initialize hash function";
 		r = PTR_ERR(v->tfm);
@@ -1280,8 +1297,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (argc) {
 		as.argc = argc;
 		as.argv = argv;
-
-		r = verity_parse_opt_args(&as, v, &verify_args);
+		r = verity_parse_opt_args(&as, v, &verify_args, false);
 		if (r < 0)
 			goto bad;
 	}
-- 
2.32.1 (Apple Git-133)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


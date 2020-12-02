Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9B2C4361A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:18:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 575F120658
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 575F120658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538--dUZTUkXPPWliwuP1SBeug-1; Thu, 03 Dec 2020 11:18:08 -0500
X-MC-Unique: -dUZTUkXPPWliwuP1SBeug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 827E4800D53;
	Thu,  3 Dec 2020 16:18:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 191B75C1B4;
	Thu,  3 Dec 2020 16:18:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 901F64BB7B;
	Thu,  3 Dec 2020 16:18:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2IFVkI020830 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 13:15:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9FD6A2026D13; Wed,  2 Dec 2020 18:15:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AAB52026D47
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 18:15:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BB11811E86
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 18:15:29 +0000 (UTC)
Received: from a2.mail.mailgun.net (a2.mail.mailgun.net [198.61.254.61])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-100-309SmAhONUCrwm6vcUA98w-1; Wed, 02 Dec 2020 13:15:27 -0500
X-MC-Unique: 309SmAhONUCrwm6vcUA98w-1
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJmZGZhMyIsICJkbS1kZXZlbEByZWRoYXQuY29tIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
	(ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
	by smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
	5fc7d75d2ef3e1355fe61ea9 (version=TLS1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 18:05:17
	GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
	id 82333C433C6; Wed,  2 Dec 2020 18:05:17 +0000 (UTC)
Received: from rsiddoji1 (unknown [123.201.165.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested) (Authenticated sender: rsiddoji)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id C2CABC433ED;
	Wed,  2 Dec 2020 18:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C2CABC433ED
From: "Ravi Kumar Siddojigari" <rsiddoji@codeaurora.org>
To: <linux-block@vger.kernel.org>, <dm-devel@redhat.com>
References: 
In-Reply-To: 
Date: Wed, 2 Dec 2020 23:35:11 +0530
Organization: The Qualcomm Innovation Center,
	Inc. is a member of the Code Aurora Forum,
	\na Linux Foundation Collaborative Project
Message-ID: <000001d6c8d5$b03e7200$10bb5600$@codeaurora.org>
MIME-Version: 1.0
Thread-Index: AQH+wGaSVHC4B8VH2eGDagahwX5nL6mUKdpA
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
X-Mailman-Approved-At: Thu, 03 Dec 2020 11:17:59 -0500
Subject: Re: [dm-devel] [PATCH] dm verity: correcting logic used with
	corrupted_errs counter
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
Content-Language: en-us
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Sorry,  Resending the patch for comments with  dm-devel added .

-----Original Message-----
From: Ravi Kumar Siddojigari <rsiddoji@codeaurora.org> 
Sent: Friday, November 20, 2020 6:37 PM
To: 'linux-block@vger.kernel.org' <linux-block@vger.kernel.org>
Cc: 'dm-devel@redhat.com' <dm-devel@redhat.com>
Subject: RE: [PATCH] dm verity: correcting logic used with corrupted_errs
counter

One more question  :
	Current code has DM_VERITY_MAX_CORRUPTED_ERRS  set to 100  can we
reduce this ? or is there any  data that made us to keep this 100 ?
Regards,
Ravi

-----Original Message-----
From: Ravi Kumar Siddojigari <rsiddoji@codeaurora.org> 
Sent: Wednesday, November 18, 2020 6:17 PM
To: 'linux-block@vger.kernel.org' <linux-block@vger.kernel.org>
Subject: [PATCH] dm verity: correcting logic used with corrupted_errs
counter

In verity_handle_err we see that the "corrupted_errs"  is never going to be
more than one as the code will fall through "out" label and hit
panic/kernel_restart on the first error  which is not as expected.. 
Following patch will make sure that corrupted_errs are incremented and only
panic/kernel_restart once it reached DM_VERITY_MAX_CORRUPTED_ERRS.

Signed-off-by: Ravi Kumar Siddojigari <rsiddoji@codeaurora.org>
---
 drivers/md/dm-verity-target.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index f74982dcbea0..d86900a2a8d7 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -221,8 +221,10 @@ static int verity_handle_err(struct dm_verity *v, enum
verity_block_type type,
 	/* Corruption should be visible in device status in all modes */
 	v->hash_failed = 1;
 
-	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
+	if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS) {
+		DMERR("%s: reached maximum errors", v->data_dev->name);
 		goto out;
+	}
 
 	v->corrupted_errs++;
 
@@ -240,13 +242,13 @@ static int verity_handle_err(struct dm_verity *v, enum
verity_block_type type,
 	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
 		    type_str, block);
 
-	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS)
-		DMERR("%s: reached maximum errors", v->data_dev->name);
 
 	snprintf(verity_env, DM_VERITY_ENV_LENGTH, "%s=%d,%llu",
 		DM_VERITY_ENV_VAR_NAME, type, block);
 
 	kobject_uevent_env(&disk_to_dev(dm_disk(md))->kobj, KOBJ_CHANGE,
envp);
+	/* DM_VERITY_MAX_CORRUPTED_ERRS limit not reached yet */
+		return 0;
 
 out:
 	if (v->mode == DM_VERITY_MODE_LOGGING)
--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a
Linux Foundation Collaborative Project


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


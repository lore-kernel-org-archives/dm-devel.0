Return-Path: <SRS0=jm7j=OZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8088DC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B9A376138B
	for <dm-devel@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B9A376138B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-f7_dMEfDOnOdEa8nxuBdRg-1; Tue, 05 Oct 2021 01:25:56 -0400
X-MC-Unique: f7_dMEfDOnOdEa8nxuBdRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 922161084683;
	Tue,  5 Oct 2021 05:25:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2458560C05;
	Tue,  5 Oct 2021 05:25:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3053A1800B9C;
	Tue,  5 Oct 2021 05:25:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 194K7Dnf012794 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Oct 2021 16:07:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7F6AB200DA45; Mon,  4 Oct 2021 20:07:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77A272144B4F
	for <dm-devel@redhat.com>; Mon,  4 Oct 2021 20:06:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B17A899ED9
	for <dm-devel@redhat.com>; Mon,  4 Oct 2021 20:06:48 +0000 (UTC)
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com
	[209.85.161.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-543-TReOZfpQODuQF7CbeF4faw-1; Mon, 04 Oct 2021 16:06:44 -0400
X-MC-Unique: TReOZfpQODuQF7CbeF4faw-1
Received: by mail-oo1-f42.google.com with SMTP id
	y16-20020a4ade10000000b002b5dd6f4c8dso5735297oot.12
	for <dm-devel@redhat.com>; Mon, 04 Oct 2021 13:06:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=66dX0OvQYrrj3UairmmHI6a5MNBzAVnr6VxC1SQ5QfI=;
	b=Wf92oR7dxBBVcTpH+euw1nwsf8jVV6d4n0pz9LeRitelr3JQlzoszNb0Nt8D27kqkq
	ZV2SxSKdfizl7cb4z6JdcHYL6QqfayzU2SFOw2bdUTZ0eA1bEx2gRCVMzrATPOIlJBkh
	Rmf1gv/4344wsTyjf388sPlmASFKkJgYSZWTEEd0UgU7KOnyC39BZxBYVYXCmlgO8E6f
	X+hDOFmAd9A7ZUdtsIAGRPeTYOAmaszZAkSfafJ3s3noBEyMbaszbXgwQpEFuR2hMjPs
	qRsrf2VuPsOPeL0AKoSHEm4kuC1qkGOXOalqw2+B3/t9UD5lh4qCP1G9Pgycwqp6+a1t
	digQ==
X-Gm-Message-State: AOAM531FcEpZNuW4pI1XLRdHLiYE7xJyJnW2tM0io3LTSBMdn0s1WzWe
	LPm0HGVJr5q6d5k/eRMRCH8yNOlVH8fwBw==
X-Google-Smtp-Source: ABdhPJx2saE+pGtwu/Iro6kkqVG924H8S/kYPTHwf52PCKYl3E66oJ+Kn3xmvP+nZXyiDYjnVM38sA==
X-Received: by 2002:a4a:7059:: with SMTP id b25mr10598983oof.54.1633378003899; 
	Mon, 04 Oct 2021 13:06:43 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net.
	[24.9.64.241])
	by smtp.gmail.com with ESMTPSA id e12sm3123842otq.4.2021.10.04.13.06.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 04 Oct 2021 13:06:43 -0700 (PDT)
From: Shuah Khan <skhan@linuxfoundation.org>
To: agk@redhat.com, snitzer@redhat.com
Date: Mon,  4 Oct 2021 14:06:41 -0600
Message-Id: <20211004200641.378496-1-skhan@linuxfoundation.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 05 Oct 2021 01:25:45 -0400
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [dm-devel] [PATCH] dm: change dm_get_target_type() to check for
	module load error
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_get_target_type() doesn't check error return from request_module().
Change to check for error and return NULL instead of trying to get
target type again which would fail.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/md/dm-target.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 64dd0b34fcf4..0789e9f91d3a 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -41,17 +41,22 @@ static struct target_type *get_target_type(const char *name)
 	return tt;
 }
 
-static void load_module(const char *name)
+static int load_module(const char *name)
 {
-	request_module("dm-%s", name);
+	return request_module("dm-%s", name);
 }
 
 struct target_type *dm_get_target_type(const char *name)
 {
 	struct target_type *tt = get_target_type(name);
+	int ret;
 
 	if (!tt) {
-		load_module(name);
+		ret = load_module(name);
+		if (ret < 0) {
+			pr_err("Module %s load failed %d\n", name, ret);
+			return NULL;
+		}
 		tt = get_target_type(name);
 	}
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


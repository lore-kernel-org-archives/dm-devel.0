Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7A0C43219
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667492275;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vcyOpczhLwQrQirlYOClr01xDXUyNNpyqsGe8SVqOUQ=;
	b=MRrX3nYDWVW1eg8sPlDXA95kiEMmF8ScR8fbRRXAKuoqMUa7iKn2m/AAJ9rZ/eM7zeysES
	T9KpL8hqELfnPeAqNqesCfjttsDLAUGt0Yk4Rk7Q8ys7IyIw+MqkDzRdvP2eU62ZSspyTS
	gxsRaeGUW95SsyiNrEqt6c7IpU7miYc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-u6gmf1PeNpatnmAyiMKI6w-1; Thu, 03 Nov 2022 12:17:52 -0400
X-MC-Unique: u6gmf1PeNpatnmAyiMKI6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B46E2823803;
	Thu,  3 Nov 2022 16:17:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A72940C6EC3;
	Thu,  3 Nov 2022 16:17:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF21919465A4;
	Thu,  3 Nov 2022 16:17:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 241781946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 16:17:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 07133492B21; Thu,  3 Nov 2022 16:17:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 004B4492B06
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:17:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D93DE85CEEF
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:17:48 +0000 (UTC)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-ojFb_Z3mOkar33d-9jOMHA-1; Thu, 03 Nov 2022 12:17:42 -0400
X-MC-Unique: ojFb_Z3mOkar33d-9jOMHA-1
Received: by mail-wr1-f43.google.com with SMTP id k8so3568532wrh.1;
 Thu, 03 Nov 2022 09:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=50MnSxq0WFz+zM3sEBHfxo4b95NR6z4DyzeRd5QcA+U=;
 b=yXXxqpSWYvCDx8k/WYLFWorCqbxmdkerMWgBu4vJra2t48H8Ea2wi6OWv3Atk3+th0
 AdD6kSWbUkjmWzF8XCMtNB7BFm2O8PzefjgxIjVPtpmiFDZsHVRVl4LSeMwvPDsYR86V
 GA8MLF4Xeq8b8BBA11whE4VsMFbyMH8aDZad42NmA2J5soSOC1Gv3PVVO9Aj1fDKHn9C
 lmmgfFLJziuJMwxQxj/RhsWHO2qNXGwCHWaVJffcPbWDRFAA6cxo+FDpc3CQr40wyzgt
 icoiG5FQjANHpi3ZVHJ2gZDolykGNfl2qYPQqZ96U1jW6Rl7d/7AHyGJXF5F+FFcpjCW
 oEoA==
X-Gm-Message-State: ACrzQf0Rj55G7PquOphLbTjQ1vn3AzrK6horbRZKMINKz9NIizkpIzPB
 MyMQQPnDc+FPUzU8kytwnw==
X-Google-Smtp-Source: AMsMyM7ZM6TvmIrmRAZ5k1SYQwgD26tKwc4LNikRTvHduoeSQmU607ktl2gQAUCcaHYxv6qCUfFViw==
X-Received: by 2002:adf:cf0a:0:b0:236:8ead:6b31 with SMTP id
 o10-20020adfcf0a000000b002368ead6b31mr19771610wrj.333.1667492261610; 
 Thu, 03 Nov 2022 09:17:41 -0700 (PDT)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 l6-20020a5d5266000000b00236a16c00ffsm1283095wrc.43.2022.11.03.09.17.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 09:17:41 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu,  3 Nov 2022 17:17:29 +0100
Message-Id: <20221103161730.93378-3-xose.vazquez@gmail.com>
In-Reply-To: <20221103161730.93378-1-xose.vazquez@gmail.com>
References: <20221103161730.93378-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 2/3] multipath-tools: add PowerMax NVMe to hwtable
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

No official config, just a "multipath -ll" output:
https://bugzilla.redhat.com/1686708#c0

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7ae7dbf8..3c4f866a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -339,6 +339,12 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 6,
 	},
+	{
+		/* PowerMax NVMe */
+		.vendor        = "NVME",
+		.product       = "EMC PowerMax",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	{
 		/* DGC CLARiiON CX/AX / VNX and Unity */
 		.vendor        = "^DGC",
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


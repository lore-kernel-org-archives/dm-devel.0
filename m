Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD19C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jul 2022 19:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657825558;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PfG+JztybRXgmV/0FYzxtbV2ZNFb99jXPBG9Di68efU=;
	b=UBFW1rVb9P4VgNpPvWXNzFhDg6OkcuWv3bA4XwYHNWYZyxE6g8Ll83UQ3+Sbx3YeK2ALbp
	2WNe5E5e9Wj2kVgxQHpSvZgiXxtjAXbr9u7fFlO4Nvofmh0k4X9RCW277eTIRUpC1YDv+7
	C6xOVa5G6j9g9b9sJk7na43SwciZSmQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-tZn2e7EYOpOb2Qae_yuooQ-1; Thu, 14 Jul 2022 15:05:54 -0400
X-MC-Unique: tZn2e7EYOpOb2Qae_yuooQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 868E5294EDD2;
	Thu, 14 Jul 2022 19:05:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 705D2C27DB3;
	Thu, 14 Jul 2022 19:05:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 41BE0194706C;
	Thu, 14 Jul 2022 19:05:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E2A21947042
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 19:05:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 009A02026D07; Thu, 14 Jul 2022 19:05:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EFB772026D64
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 19:05:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2782185A794
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 19:05:50 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-aeqK6PAnN1eZr_bzKRX8hQ-1; Thu, 14 Jul 2022 15:05:46 -0400
X-MC-Unique: aeqK6PAnN1eZr_bzKRX8hQ-1
Received: by mail-wr1-f42.google.com with SMTP id r2so2776649wrs.3;
 Thu, 14 Jul 2022 12:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=15XmlKXkEy/jbj8rVftST29cIEYHtkvSRDGPj+FPPKk=;
 b=ccJwdJG831tzQ9Jcp2iFOaxsviqc/R49dqULrDsS8+LSiLmpgsUjPwOHY8oxcW+vhv
 FQCGdQthggZggtaWizaSw6Mfqfd9Gc/CshjOp/C1/G2dV4mPB3VyncspXy5SC9/Y3aqj
 SU3QgaI9FJztjOUL1uUma+d7I5T+IIyCKpaWiEwozb1OaKKCSoDzZXelaS7gvuyo7Feq
 M2R11h24ljzUt9Pc5mLpFeOQhceJf8hyT1lmgO65hBT8D8BSDQrnV6Pbzk0CQ5QLDkOU
 Fp3GwqMlGAIs3f0Xf8So/GSi6g0TSje8m4hUXMaKox5LpgEtB25wA1CYzbxg75kth5FK
 WkUA==
X-Gm-Message-State: AJIora95frB20S0xEgq5MM67oAwvd+TXzwcA4woVcXtC/MU48ACTEl78
 ChTUyllTAxbwrUjj+4THuw==
X-Google-Smtp-Source: AGRyM1vb9Qu2OiNFUk/+veUubaAm/zyKNPtFtsSXThrn8B9+xmb58QpXbznWKSKD0kU6WINqy6A9kw==
X-Received: by 2002:adf:fb03:0:b0:21d:70cb:d6b5 with SMTP id
 c3-20020adffb03000000b0021d70cbd6b5mr9341395wrr.548.1657825545060; 
 Thu, 14 Jul 2022 12:05:45 -0700 (PDT)
Received: from localhost (127.red-81-44-149.dynamicip.rima-tde.net.
 [81.44.149.127]) by smtp.gmail.com with ESMTPSA id
 f7-20020a05600c154700b003a2fcc32031sm6607789wmg.3.2022.07.14.12.05.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Jul 2022 12:05:44 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 14 Jul 2022 21:05:40 +0200
Message-Id: <20220714190540.117283-3-xose.vazquez@gmail.com>
In-Reply-To: <20220714190540.117283-1-xose.vazquez@gmail.com>
References: <20220714190540.117283-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH 2/2] multipath-tools: delete README.alua
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.alua | 24 ------------------------
 1 file changed, 24 deletions(-)
 delete mode 100644 README.alua

diff --git a/README.alua b/README.alua
deleted file mode 100644
index 5d2b1c64..00000000
--- a/README.alua
+++ /dev/null
@@ -1,24 +0,0 @@
-This is a rough guide, consult your storage device manufacturer documentation.
-
-ALUA is supported in some devices, but usually it's disabled by default.
-To enable ALUA, the following options should be changed:
-
-- EMC CLARiiON/VNX:
-   "Failover Mode" should be changed to "4" or "Active-Active mode(ALUA)-failover mode 4"
-
-- HPE 3PAR, Primera, and Alletra 9000:
-   "Host:" should be changed to "Generic-ALUA Persona 2 (UARepLun, SESLun, ALUA)".
-
-- Promise VTrak/Vess:
-   "LUN Affinity" and "ALUA" should be changed to "Enable", "Redundancy Type"
-   must be "Active-Active".
-
-- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM arrays:
-   "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".
-
-- NetApp ONTAP:
-   To check ALUA state: "igroup show -v <igroup_name>", and to enable ALUA:
-   "igroup set <igroup_name> alua yes".
-
-- Huawei OceanStor:
-   "Host Access Mode" should be changed to "Asymmetric".
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


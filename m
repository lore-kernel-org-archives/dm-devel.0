Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2303C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 22:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658527295;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mOFFJjfumhlz6rGn6cd5XuvGEuaSEKXHAnHg+bBo+UM=;
	b=WCkK0/uOCGckgI+tGhxJ/nHpGj4BtnclNbZzgR7hd/zMzMhpWi03YsVwixozmtJs69SPZ1
	X6LvImb0es633+JsQvPcofkht9OZJwwN8nHcjt/+baQcKSFXJZdCSseqW/EYHa4QeB8fkz
	iKKigfkwLGWO1iCgfnRVHLwBfjzg8HM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-FuYOtT1cMF-H-Ba2l7pouA-1; Fri, 22 Jul 2022 18:01:32 -0400
X-MC-Unique: FuYOtT1cMF-H-Ba2l7pouA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B73285A58F;
	Fri, 22 Jul 2022 22:01:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0201F111E3FA;
	Fri, 22 Jul 2022 22:01:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9BCA21947053;
	Fri, 22 Jul 2022 22:01:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 752A21947053
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 22:01:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC50C14152FA; Fri, 22 Jul 2022 22:01:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E3FC1415139
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 22:01:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DEBE80B91C
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 22:01:21 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-FCYQZ5VuOX6lgq_MQDqERg-1; Fri, 22 Jul 2022 18:01:17 -0400
X-MC-Unique: FCYQZ5VuOX6lgq_MQDqERg-1
Received: by mail-wr1-f47.google.com with SMTP id g2so155011wru.3;
 Fri, 22 Jul 2022 15:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=bRZtCuHXZQLxq6DAYd9UB1HiOJN395UR/uoKObgQkvI=;
 b=kXy1zW9H79Sd3urXf/niBT1XpWmIbnNwfxmriwr6uFCsDW7ZIoyrryLj5vu82i1D6q
 2/mKZSjQK2nV4x+D2RM5+dvqC5iv6H6rAsDbqvqAYmNrmzEKU1ObS8KcMnJzE0IvcfRb
 5WLeuHaCiqYLk0QZ5ZC01RIPPbiu67x9qu+j63szj2XNgnOvxunoKGJUqSP2wQNpjc8G
 rsORY5mgUMMzAf9xQ2q1kfNEFKUERbuk3GPWVbyIyKv6i0hKe9UIPjcw5xmjhFA6NV+K
 P9U5y98vutJoOQ3y63+omubvqR+hKTm5JQ95s2SzPOES3TDZIDIxXf+3n3JeuCWtUH/d
 o5mg==
X-Gm-Message-State: AJIora9aJNeSoOQtM+PVN1enk5PWEiVT/EUlNROvjvRafA5dlCOz/G6z
 GLJTVCKVQ1dwW7cs7BE5OA==
X-Google-Smtp-Source: AGRyM1sqI4JJ6BY3+qocQdSisUvtjVH3+VKdkkQmUn259Pfed0iE5XsXgutIAC5zSdGJ2kYLMoluyg==
X-Received: by 2002:adf:de0a:0:b0:21e:45b0:e917 with SMTP id
 b10-20020adfde0a000000b0021e45b0e917mr1190726wrm.434.1658527276044; 
 Fri, 22 Jul 2022 15:01:16 -0700 (PDT)
Received: from localhost (51.red-81-44-172.dynamicip.rima-tde.net.
 [81.44.172.51]) by smtp.gmail.com with ESMTPSA id
 n21-20020a05600c4f9500b003a2f2bb72d5sm13564044wmq.45.2022.07.22.15.01.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Jul 2022 15:01:15 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 23 Jul 2022 00:01:13 +0200
Message-Id: <20220722220114.3848-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH] multipath-tools: correct CLARiiON info from
 multipath.conf man page
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Yanfei Chen <vincent.chen1@dell.com>, DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove "Unity" from emc prio and hardware_handler, because
Unity does not support PNR mode, just ALUA (page 113 and 153):
https://www.delltechnologies.com/asset/en-us/products/storage/technical-support/docu5128.pdf
And add PNR info.

Cc: Yanfei Chen <vincent.chen1@dell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index d5506d99..8cc1be13 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -306,7 +306,7 @@ generate the path priority. This prioritizer accepts the optional prio_arg
 .I emc
 (Hardware-dependent)
 Generate the path priority for DGC class arrays as CLARiiON CX/AX and
-EMC VNX and Unity families.
+EMC VNX families with Failover Mode 1 (Passive Not Ready(PNR)).
 .TP
 .I alua
 (Hardware-dependent)
@@ -1562,8 +1562,8 @@ The following hardware handler are implemented:
 .TP 12
 .I 1 emc
 (Hardware-dependent)
-Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX and Unity
-families.
+Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families
+with Failover Mode 1 (Passive Not Ready(PNR)).
 .TP
 .I 1 rdac
 (Hardware-dependent)
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


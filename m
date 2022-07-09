Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28EECC43334
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jul 2022 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657408052;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kW68Nfvw4jtk/w8K6CkFmhlI1BGkVGTfpCsdwAjXd+8=;
	b=MXkYrWaomUJeIjunZ0qtJ9hcdEfGwifQADsi+BUvT2im43iJGaOzyaV7TWPwdH41ioyTl4
	1IHnS0zEsHf1vumpEn2EDbsUGzos7OBpIICu8YakzhuxDU168E2+z3+cy47kSE46ERx/AO
	LbFFtCqe2BmqTpYjjwKtVvZh9tTwzqA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-laoQ6U_rMLG4ZnQzRasoPg-1; Sat, 09 Jul 2022 19:07:25 -0400
X-MC-Unique: laoQ6U_rMLG4ZnQzRasoPg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DE901C0513F;
	Sat,  9 Jul 2022 23:07:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D44F492C3B;
	Sat,  9 Jul 2022 23:07:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0BD231947040;
	Sat,  9 Jul 2022 23:07:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D91319466DF
 for <dm-devel@listman.corp.redhat.com>; Sat,  9 Jul 2022 23:07:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F23721121319; Sat,  9 Jul 2022 23:07:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EDCA21121315
 for <dm-devel@redhat.com>; Sat,  9 Jul 2022 23:07:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2BA7800DAA
 for <dm-devel@redhat.com>; Sat,  9 Jul 2022 23:07:22 +0000 (UTC)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-n_AH6Ho8NLq6YLFqsdctaA-1; Sat, 09 Jul 2022 19:07:19 -0400
X-MC-Unique: n_AH6Ho8NLq6YLFqsdctaA-1
Received: by mail-wr1-f48.google.com with SMTP id z12so2649269wrq.7;
 Sat, 09 Jul 2022 16:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=hWz0Izy6OK0V6Jvj/WpN6nOZpEDfCTDL60YKcLkqd4Q=;
 b=w1NZ7uz2B1QAZZQrOpy6i7QUDwNm8jtAedMx8q0WxQWshpI1BLoplxbLm8n2AAR1xa
 MaZoxXP7kANCXZtzV8UiqU4D23b7W3skArSr46mZfn0O+y5bzEwsz5eVIfno7v8sw6mK
 QKJ6K3hEVrUCJe0MKTJFTLt2+mZEtwji1VItACNkR88gCYC27zq5nDJ3YyNrlcE49gTe
 m4tF/rwDqzRxhPReE14oG5Kf6ycCtCy9174auQfdP2EdNGFiI7a4SWor/hOYVehdE7tu
 mx7VH947TlrOXZDwVWfzKMTuGNcPxoPysUl8tLc1tt15+4+VXpMJ/6l6BkQvmtl+TH4C
 HUew==
X-Gm-Message-State: AJIora9nKs1Qwcavnr4WIIVbfPvzlRgWVLL5l7tqbDogkNpnDXfFpLOE
 EKL5qMXQz5pBiBcot4w38g==
X-Google-Smtp-Source: AGRyM1vGPSrg6uMkx7mfMd+Ffb+vSDQ5IALtbRDpLLC0kFcinV01EbBQu7jOswel2GbSUY9aumxemQ==
X-Received: by 2002:adf:d1c2:0:b0:21d:865e:406c with SMTP id
 b2-20020adfd1c2000000b0021d865e406cmr9620067wrd.483.1657408031610; 
 Sat, 09 Jul 2022 16:07:11 -0700 (PDT)
Received: from localhost (58.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.58]) by smtp.gmail.com with ESMTPSA id
 f3-20020a1cc903000000b003a2d87aea57sm5941740wmb.10.2022.07.09.16.07.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 09 Jul 2022 16:07:11 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 10 Jul 2022 01:07:07 +0200
Message-Id: <20220709230709.35516-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 0/2] update hwtable
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
Cc: Zou Ming <zouming.zouming@huawei.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, chengjike.cheng@huawei.com,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>, sunao.sun@huawei.com,
 jiangtao62@huawei.com, Zhouweigang <zhouweigang09@huawei.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Xose Vazquez Perez (2):
  multipath-tools: update Huawei OceanStor NVMe vendor id
  multipath-tools: update "Generic NVMe" vendor regex in hwtable

 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Cc: <chengjike.cheng@huawei.com>
Cc: <sunao.sun@huawei.com>
Cc: <jiangtao62@huawei.com>
Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


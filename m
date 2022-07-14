Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF19CC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jul 2022 19:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657825553;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mFq8JcgnYrukwSghPYRbvoObGp5z8CR2kcm13MkfIdQ=;
	b=VXYF3PYU8jH6BiCjjHtl9GUqIp72qTdnGV9pQOJPjUnmhqTIUx8i6A5bIvZZwICMZJVGmk
	eA+nP8JEqq7IHYL6LdsxBrhEkJLUktpib42ZduhLdm4oxXam5gNN7XFsF8x9IfNLowqaH+
	yFKYkkfRj4O73sUPzncYZKbjVhsqNLc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-TuJYF60OPlKagyodMq3Tvg-1; Thu, 14 Jul 2022 15:05:49 -0400
X-MC-Unique: TuJYF60OPlKagyodMq3Tvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD8AD811E75;
	Thu, 14 Jul 2022 19:05:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D2FD140EBE3;
	Thu, 14 Jul 2022 19:05:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EE70194706C;
	Thu, 14 Jul 2022 19:05:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5DBD41947042
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 19:05:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B55B18ECB; Thu, 14 Jul 2022 19:05:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46FF318EB5
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 19:05:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B37D801231
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 19:05:46 +0000 (UTC)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-3jsUcMoGN2icmHwGLnNPbg-1; Thu, 14 Jul 2022 15:05:44 -0400
X-MC-Unique: 3jsUcMoGN2icmHwGLnNPbg-1
Received: by mail-wm1-f42.google.com with SMTP id p4so1619423wms.0;
 Thu, 14 Jul 2022 12:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=VmAAKtt2Gt9Ug8jERRit6rnYgy9UKXQC2LFe4KY94gw=;
 b=QX/Sz+VZ3lMyAOdbWkPZumSAkhEL6x7SZbBq8dLBx42r3uhUq4kqdVDHlNg5CulgYk
 69Dc34JmY0RedUI/tl/9axkAbNyrhoch4aF4TrcLPhaLE8AQsj/ltbmdVd87w2pVWpSo
 aBZD55t0SA4ePevX9LEJjnkk7EM/2LlCFrTDhQSYvkMhJn3mba9QN1VAXVQWDvAyfSYS
 tAROSYKHa8VhJOJ8J2O45rt+FG304DKjYvJwA5XCr0ccctu567GNS7UL5dqXm8LLhau9
 /lN+9MI3ByB0eQx6mbNIO+hBzRb/JW7aA0UatdsLt2M0bCqVxv87SLvGy4bW0RlaHpjn
 SqZg==
X-Gm-Message-State: AJIora8cqk8Ir65u7DuKZtC2pqOR1i0M9CQLefccHkxmU8ZUO35OTlqw
 CKD+nAF8dAgDy9z8GnFsrcTgf+rFoA==
X-Google-Smtp-Source: AGRyM1urqzkDfxyZBRXz8hJeRcVqCHEGhORaZNBl6+KbtTmPhn9pbfeEWEIP1F6pVWX/74DW5PfPGQ==
X-Received: by 2002:a1c:545c:0:b0:3a2:e395:21fc with SMTP id
 p28-20020a1c545c000000b003a2e39521fcmr16265104wmi.125.1657825542750; 
 Thu, 14 Jul 2022 12:05:42 -0700 (PDT)
Received: from localhost (127.red-81-44-149.dynamicip.rima-tde.net.
 [81.44.149.127]) by smtp.gmail.com with ESMTPSA id
 az29-20020a05600c601d00b003a03e63e428sm7612192wmb.36.2022.07.14.12.05.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Jul 2022 12:05:42 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 14 Jul 2022 21:05:38 +0200
Message-Id: <20220714190540.117283-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 0/2] multipath-tools: update docs
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Xose Vazquez Perez (2):
  multipath-tools: update devel repo info in README.md
  multipath-tools: delete README.alua

 README.alua | 24 ------------------------
 README.md   | 10 +++-------
 2 files changed, 3 insertions(+), 31 deletions(-)
 delete mode 100644 README.alua

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


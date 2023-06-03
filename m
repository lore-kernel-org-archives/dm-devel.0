Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE10C7EE24
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 20:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685823378;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RS8Xv91/QZIRrSG7jqj3g0Z08IqD8OfaI0QLBRq4KME=;
	b=aA8GM69chQZJhV/6C6QrmYiS6WmBJr+K89RnC2FetK/KV8cf0JSQcVeYl/lyIbLbtW/dhO
	BHmHD2yuS6pb/HCtxIcyJoyfGpUOJMBFlm6O/p3Jr9Ox0c5iIUlEfWIX4+Hc/sDVSaJ18U
	/PuOrCZ3nw3l94ykLz+mh5BnDxL8nus=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-7h3Ny0gbP4isDO5X7nYqJw-1; Sat, 03 Jun 2023 16:16:17 -0400
X-MC-Unique: 7h3Ny0gbP4isDO5X7nYqJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C76B85A5AA;
	Sat,  3 Jun 2023 20:16:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A9032026D49;
	Sat,  3 Jun 2023 20:16:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 252AF19465A0;
	Sat,  3 Jun 2023 20:16:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 90C8F1946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 20:16:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 70FB440C6CCC; Sat,  3 Jun 2023 20:16:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6987F40C6EC4
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:11 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EE9F3802278
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 20:16:11 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-8TvQ_2MUOaCxntT6ltFQJg-1; Sat, 03 Jun 2023 16:16:07 -0400
X-MC-Unique: 8TvQ_2MUOaCxntT6ltFQJg-1
Received: by mail-pj1-f46.google.com with SMTP id
 98e67ed59e1d1-256e1d87998so2830201a91.3; 
 Sat, 03 Jun 2023 13:16:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685823366; x=1688415366;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=t/RhT6metLrp+ds7LCGxqXYqhQlQZ5qHcKgxrBMCXnY=;
 b=YnpgwVmCycsVIDhS/Byg2An7A0ff7taLh10mgdbdKuVviRhs1HAwsKb8Dj9FmEJL4r
 QsdUn7CA6lVcB7CVhRpGuSFbwf30XY7vngc97F4OTlUsdLiuYv7c8sGwNSYtQaU/vgxS
 cjlWJ7Ae99CYolAO8TYhH+PjPViDLK6QmneTXBYOphJZYSR5UhoCgIvqn7aKwVYnWeR0
 Nz69WYn63v1UxYG2lAMirvmgCHKAL3OOCt2/ClcqcEdiaNEVf+VVjeBwdph/PL6nuVfG
 mRKlu2/9KSDM8NOwqioCViho5MixNTLpLKK7t2wOMv5Uap8nVuWQWEcl2Z+2p509dHSD
 VhYQ==
X-Gm-Message-State: AC+VfDz++t8I2q1YIY5reEjhuCE62dhpiQd1NYWz6XDqe45CqxXuQV4c
 hjsdU1rk01sEQNCNGyWPfKImjROt8Wy3Sw==
X-Google-Smtp-Source: ACHHUZ4eGZOOtkk2IxrdjzfQqI8oWBtxgGF8oUbH7xMjjMVsm7FDPCZXmEFLeAg8ysxZiqqNgN0yag==
X-Received: by 2002:a17:90b:b0d:b0:256:8fae:4d50 with SMTP id
 bf13-20020a17090b0b0d00b002568fae4d50mr3590460pjb.21.1685823365977; 
 Sat, 03 Jun 2023 13:16:05 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 u7-20020a17090a1d4700b00250bf8495b3sm5001691pju.39.2023.06.03.13.16.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 03 Jun 2023 13:16:05 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sat,  3 Jun 2023 13:15:21 -0700
Message-Id: <20230603201525.9409-1-eatnumber1@gmail.com>
In-Reply-To: <ZHs2BHGBrJ-YGd-v@debian.me>
References: <ZHs2BHGBrJ-YGd-v@debian.me>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH] Improve the dm-integrity documentation.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks for taking a look. Here's the multi-patch series plus the changes
you suggested.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


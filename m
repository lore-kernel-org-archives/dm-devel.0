Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25411C43334
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178896;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TeRFNLXvx/2nxkFoYs3HlFmXlPsEInobf3kVNZcE6tU=;
	b=LgtaBSX5vzD9lB5Y7GuLoaHKbmpB4hx3lAKrOqEf+d3qkOano8ADYP5t+KkiZir/whOYZ8
	8bwap/Vmc/y7cFZW6qO7JeD71IW0kumK5Z9hiR6fZlRHdiGbKrobOtBsFjU4bmApEs0NMy
	REZ8qp/gOnICxMWHjIe4ejHRLYJ9aMs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-CMlRIzgIOmGGJB5_TBVJvw-1; Thu, 07 Jul 2022 03:28:06 -0400
X-MC-Unique: CMlRIzgIOmGGJB5_TBVJvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FEF5811E81;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DAE7404C31E;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 607D619451EF;
	Thu,  7 Jul 2022 07:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B9C86194707A
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 04:26:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2BE12166B29; Sat,  2 Jul 2022 04:26:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AECC52166B26
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 04:26:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9382385A580
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 04:26:22 +0000 (UTC)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-8qBxGiIBOpe2H8SsR4jwUQ-1; Sat, 02 Jul 2022 00:26:20 -0400
X-MC-Unique: 8qBxGiIBOpe2H8SsR4jwUQ-1
Received: by mail-pj1-f43.google.com with SMTP id
 h15-20020a17090a648f00b001ef3c529d77so7042990pjj.2; 
 Fri, 01 Jul 2022 21:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=8dpcDlwR6UgAXLxdxQBFPJ8Kqg1ETqhfqVNIp7mcNZk=;
 b=0s+iqyHQrUHMmiRvwuG6WD9qp/B7kHmgec19rZ0+imSoGLrv3ufG84hnAzjMF23QPc
 63f64qTTITK9cU07WNY/WGcP2qnOOnlPrlmcazUSofct5v4xMjaZupf+jgH82P1+mNQA
 +APqwge5B/C2BKc/c4blTfIFWlvQVnT1eqBHnbNIYq3Xr272xOPkRytzsBs3FTyi9z4O
 1+BAdovhZGskHUn7HmBvEc3mxKuPTHkFXE8wStollPXN87VDBW21AsmEveAFBf/+7cwC
 jg6I5yAMn6UszPdhXMfrM+bLOfnnYE/71pdqpyiUBSHORFMT/6gjqX09Kc4alYsDS8Fg
 fe7g==
X-Gm-Message-State: AJIora+0VIkIpqtB13wU25gTbQeeZrtoPn8dptk7Y+ky/Y1QT2rQ5S46
 Ax3MRipHnDpKwdJ6ktMMywg=
X-Google-Smtp-Source: AGRyM1vsbc5MSeVulXe3sQnjanmzmFEPLLYT6pcFzsHsCiy0YajshHAxqtqNJ9FHkhsvi2+1XZXLww==
X-Received: by 2002:a17:90a:6fc5:b0:1ec:87db:b9f6 with SMTP id
 e63-20020a17090a6fc500b001ec87dbb9f6mr20617032pjk.104.1656735979173; 
 Fri, 01 Jul 2022 21:26:19 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
 by smtp.gmail.com with ESMTPSA id
 u9-20020a1709026e0900b0015e8d4eb2cdsm12305552plk.279.2022.07.01.21.26.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Jul 2022 21:26:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 7A5F01038DE; Sat,  2 Jul 2022 11:23:53 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: linux-doc@vger.kernel.org
Date: Sat,  2 Jul 2022 11:23:50 +0700
Message-Id: <20220702042350.23187-3-bagasdotme@gmail.com>
In-Reply-To: <20220702042350.23187-1-bagasdotme@gmail.com>
References: <20220702042350.23187-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: [dm-devel] [PATCH 2/2] Documentation: dm writecache: Render status
 list as list
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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Bagas Sanjaya <bagasdotme@gmail.com>,
 Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Colin Ian King <colin.king@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The status list isn't rendered as list, but rather as normal paragraph,
because there is missing blank line between "Status:" line and the list.

Fix the issue by adding the blank line separator.

Fixes: 48debafe4f2fea ("dm: add writecache target")
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Colin Ian King <colin.king@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: dm-devel@redhat.com
Cc: stable@vger.kernel.org # v4.19+
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/device-mapper/writecache.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/writecache.rst b/Documentation/admin-guide/device-mapper/writecache.rst
index 6bf78b0446acba..2104812f028129 100644
--- a/Documentation/admin-guide/device-mapper/writecache.rst
+++ b/Documentation/admin-guide/device-mapper/writecache.rst
@@ -75,6 +75,7 @@ Constructor parameters:
 		the origin volume in the last n milliseconds
 
 Status:
+
 1. error indicator - 0 if there was no error, otherwise error number
 2. the number of blocks
 3. the number of free blocks
-- 
An old man doll... just what I always wanted! - Clara

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


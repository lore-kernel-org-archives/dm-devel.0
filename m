Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C64C43334
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178889;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fD697oDOQVev8jPniQJr/U7tK2pryg5ATo4Ok+RJMTc=;
	b=ga3bhMy7tU7XPLj8Yi2/XiV20Z9/ZPRuVfWm+laxnMCLXUA+46WewW3fTrsYZLfARzk/h+
	zQk8dS/Y5hWqsjGg1jrzUgUrNLZlDfFL0pXhQtzr1wrHAbl1cWhEsqNS9Ajy/NpEHITUTc
	b+zbSng8IpXLsstELtUrPMTw01hHp5s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-vCD_RteyPr6QR_lDvI0wbw-1; Thu, 07 Jul 2022 03:28:08 -0400
X-MC-Unique: vCD_RteyPr6QR_lDvI0wbw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6ED968339C3;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D7612166B26;
	Thu,  7 Jul 2022 07:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8A3801947B84;
	Thu,  7 Jul 2022 07:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B4FDF1947070
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 04:26:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 71C272166B2B; Sat,  2 Jul 2022 04:26:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D7A82166B26
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 04:26:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 570981C05ED0
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 04:26:24 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-LQrw3wx2M7CJrBjsk54fQA-1; Sat, 02 Jul 2022 00:26:20 -0400
X-MC-Unique: LQrw3wx2M7CJrBjsk54fQA-1
Received: by mail-pf1-f173.google.com with SMTP id 65so4155901pfw.11;
 Fri, 01 Jul 2022 21:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=TnI/7Ov6YbpdQeEP05xUeEXN9eI+0MLVjCVd9MAZtjk=;
 b=HAcugM8lnGIYsGB6mVjNNrfxc7+vFLJIoz+Di0r4SQNp96JI1aT7UgH5iEo68lDsPy
 Mx4HlXiD+p/pwbK+2tN3tot0dKz4Vfgeu8zNtFOtlU5+4nNfkAUK8xQLPkvW5f70RkT+
 9WX0qU6fQkDGtzIVwexdhIE3TH72e0fLicgq27kKc+qMlA2wtuFcncZoHCGFJX0ktRmG
 puW28yLnazv9SBoKncIsAnOljgfwWGXrf4Akw1w9Ry97YiCWfjOMCSoP6HEqLraPbiK8
 QCGPFQ79Ipvb4eyrjEFeB3R9goPfeADkse7hbbDAjn+XpIG4qMApz6nVPPwM7Izmg2wk
 93vQ==
X-Gm-Message-State: AJIora+stLn+sEzJFmOLxAYh6WcJdKvI0e0jPsk5kJGr/R7eZjVDyaYO
 oTzwsjoMAmj+FB45mMBUv6mYy/DQGgo0BA==
X-Google-Smtp-Source: AGRyM1sXOzvQDqtyzNo8A329BwQufwl42WeRYAYt/7k+ikN5zVMCZpb+DhGacMMhTAHQ8qQXOwVzUg==
X-Received: by 2002:a63:2ccd:0:b0:411:54ac:5c7e with SMTP id
 s196-20020a632ccd000000b0041154ac5c7emr15067038pgs.561.1656735978328; 
 Fri, 01 Jul 2022 21:26:18 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
 by smtp.gmail.com with ESMTPSA id
 j17-20020a056a00175100b00522c0600de9sm16380010pfc.198.2022.07.01.21.26.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Jul 2022 21:26:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 98456103921; Sat,  2 Jul 2022 11:23:53 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: linux-doc@vger.kernel.org
Date: Sat,  2 Jul 2022 11:23:49 +0700
Message-Id: <20220702042350.23187-2-bagasdotme@gmail.com>
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
Subject: [dm-devel] [PATCH 1/2] Documentation: dm writecache: Add missing
 blank line before optional parameters
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
 kernel test robot <lkp@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Bagas Sanjaya <bagasdotme@gmail.com>,
 Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Colin Ian King <colin.king@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

kernel test robot reported htmldocs warning which first happened 1 year ago:

Documentation/admin-guide/device-mapper/writecache.rst:23: WARNING: Unexpected indentation.

The warning above is due to missing blank line between numbered list (at
n. 5) and optional parameters list (as definition list).

Add the blank line to suppress the warning.

Link: https://lore.kernel.org/linux-doc/202207020824.oMJMSB8R-lkp@intel.com/
Fixes: d284f8248c72d0 ("dm writecache: support optional offset for start of device")
Reported-by: kernel test robot <lkp@intel.com>
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
index 10429779a91abc..6bf78b0446acba 100644
--- a/Documentation/admin-guide/device-mapper/writecache.rst
+++ b/Documentation/admin-guide/device-mapper/writecache.rst
@@ -20,6 +20,7 @@ Constructor parameters:
    size)
 5. the number of optional parameters (the parameters with an argument
    count as two)
+
 	start_sector n		(default: 0)
 		offset from the start of cache device in 512-byte sectors
 	high_watermark n	(default: 50)
-- 
An old man doll... just what I always wanted! - Clara

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


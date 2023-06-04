Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C942C7EE23
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 19:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685905604;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+feFU2su6mHRMsAe06MmZ7jiFN1PAniNeOO/1kqCgek=;
	b=ZyKgaxF0POS9hF6i+dTGiHX+tyVKVRE4mLKtBHsEcCiGigzvtpkh143tFeEmgrjpZuPIFU
	nXW8cLEb7Vkow+ktRaGPuCs0IvnjSQMIrpUiwHAaih2vxTiKWs9BygtO14JAoPNwpRxEz8
	SuKeSHEv7qSbhC62hcrnBiLQerZNTOk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-HxNkEGQYMgaiRNq7XkDdzw-1; Sun, 04 Jun 2023 15:06:41 -0400
X-MC-Unique: HxNkEGQYMgaiRNq7XkDdzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FD19800159;
	Sun,  4 Jun 2023 19:06:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F14622026D49;
	Sun,  4 Jun 2023 19:06:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B43B19465A0;
	Sun,  4 Jun 2023 19:06:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8DE151946595
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 19:06:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 331BF1121315; Sun,  4 Jun 2023 19:06:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B9771121314
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:35 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 108263806063
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:35 +0000 (UTC)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-TIYV3QfJNrm28qVWaW9u8A-1; Sun, 04 Jun 2023 15:06:33 -0400
X-MC-Unique: TIYV3QfJNrm28qVWaW9u8A-1
Received: by mail-pf1-f179.google.com with SMTP id
 d2e1a72fcca58-652a6bf4e6aso1612022b3a.2; 
 Sun, 04 Jun 2023 12:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685905592; x=1688497592;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=XbUejC7VSiKPBbjbIMnLeib6LPFan0YFbSc0p4xM48s=;
 b=JQGXFGnxME+3mpGOAfi2tBgYox++VZCyRiv0S38CZTljSWeb9tARjYe1fzlpOCVboo
 UZ9Zgd1Lg01q+BDgI4PtVZuLjs+tKOL/WeBY6wDkk+RoRZWfo5obQJqEL8G4qhoaL6v3
 7W+nmUwppWljTDzUM3QqTm3PdnCDPqH+5Ys+2XKne1fWSMieEJaNPVZ2yEEXLZBSpO4e
 pDI/QbSG6DR9Jz4HvonyiIfu9n7PMwYdu95NA0nh/huaO7SrH29jd+0P0wjsqyBPuGQJ
 a9ZHqtG+qmqWzX02QNZHopB9hNf1pF9wMPZO7KDMVZSXzKKeahG/EePU5Zl9hLpXb0gl
 Hgag==
X-Gm-Message-State: AC+VfDyA1sMVA8zDOPPRi1ybjNryDISGtK9Kr1FTxsEXitBy+Q1sZhFh
 7KJ/qSLDfem+/3T+WuU71YtxPuk9dmYm2g==
X-Google-Smtp-Source: ACHHUZ54Dervt6Wvl7x+XZV5YlVrYo/Ef4fUT5zcf7MFzSkijq+30vW7FyPQvyJHFujKhbOAk/lkAg==
X-Received: by 2002:a05:6a20:8e19:b0:116:df6e:c84c with SMTP id
 y25-20020a056a208e1900b00116df6ec84cmr46292pzj.45.1685905591450; 
 Sun, 04 Jun 2023 12:06:31 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 m8-20020a170902db0800b001a6ed2d0ef8sm4979072plx.273.2023.06.04.12.06.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 12:06:30 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sun,  4 Jun 2023 12:06:00 -0700
Message-Id: <20230604190604.4800-1-eatnumber1@gmail.com>
In-Reply-To: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v3 0/4] Improve the dm-integrity documentation.
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
Cc: Russell Harmon <eatnumber1@gmail.com>, dm-devel@redhat.com,
 mpatocka@redhat.com, snitzer@redhat.com, linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Version 3, thanks Bagas for working with me.

Russell Harmon (4):
  Fix minor grammatical error in dm-integrity.rst.
  Documents the meaning of "buffer" in dm-integrity.
  Document dm-integrity default values.
  Document an example of how the tunables relate in dm-integrity.

 .../device-mapper/dm-integrity.rst            | 43 ++++++++++++-------
 1 file changed, 27 insertions(+), 16 deletions(-)

-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


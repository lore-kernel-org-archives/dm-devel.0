Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0699C6FA83
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664304178;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IquaP6aGppMWyMGAHo8vbJJUcvvGS8/LkJsM8fTLkfg=;
	b=GjQpFA2v29ZiRk8TwiZBeL6CGZRw8fVl3lKguljhFAfgot72RZdL/PhJduozlhqsOxYmLE
	9584FWKZ4ztx94GfZbQELVSPRYMDPg7csRYV5Nb8npkQDi57BEVvUn4B8q6n1Jf2F+Gpc6
	GM0RG8yn4RFiWgHhl/duAvwMHcCWyU4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-i-pcecZFMUKfeqyCxUaKjw-1; Tue, 27 Sep 2022 14:42:57 -0400
X-MC-Unique: i-pcecZFMUKfeqyCxUaKjw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E010185A7A9;
	Tue, 27 Sep 2022 18:42:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E2B02027061;
	Tue, 27 Sep 2022 18:42:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F8DC19465B1;
	Tue, 27 Sep 2022 18:42:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AA29D1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 18:42:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B5F22027061; Tue, 27 Sep 2022 18:42:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 438932027062
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 18:42:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22C693C106BD
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 18:42:50 +0000 (UTC)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com
 [209.85.208.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-659-naEdVXktM86SPsmoM7vHaA-1; Tue, 27 Sep 2022 14:42:48 -0400
X-MC-Unique: naEdVXktM86SPsmoM7vHaA-1
Received: by mail-ed1-f52.google.com with SMTP id z2so14420452edi.1
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 11:42:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=/b06rCBbcsHpN3rm/cDNv4yuexmTc2b5TSCfsbU8b2M=;
 b=4CKavQALC7qv+qLujpExV8FoMF27oPQw6GiBaK8k9o10U5VLV/9xnn8/tP8GNHk20U
 pi/Q5SMIYLHb76RH8h2GDwz7BNm+RWirEKqr5V0QVhSiyWLSmHWU2hFqVTk++xNrZE0/
 cONZ//szZIaoobp5fRxqqwMMJRSgVYeTvL//l0NrI9UXZXzzNhsbHel3P6BmXeYFtaYz
 8UfcqqiS5QBWZwxUf85ZVjt2lXPsc/rxLGJWUu4as7qADkLM8w7lZfF3aQFsy6w8IPPl
 TiV9/hTesDBKxXXQ4ZNkUroiVV2E3QgF/jCtVJlm4voFSinwlGwS6LMW6gQGG+VyGbR6
 ww4Q==
X-Gm-Message-State: ACrzQf35VVyp8zbgPFfgQa4bIEgZhVTC3act06WOzKHQq5hL7uzNiENB
 xZkpIjUNia/J6uXfv/yR+3gH7FGknu4=
X-Google-Smtp-Source: AMsMyM4h8JNGQtMRAkHq28DwXA99TUlmsI2X4wR6i6DOn79QEpH0fuORFUy7d9IynMGPCi8jbkwXBg==
X-Received: by 2002:a50:cdd8:0:b0:457:269a:decf with SMTP id
 h24-20020a50cdd8000000b00457269adecfmr14645212edj.359.1664304165989; 
 Tue, 27 Sep 2022 11:42:45 -0700 (PDT)
Received: from sauvignon.mazyland.net (85-70-151-113.rcd.o2.cz.
 [85.70.151.113]) by smtp.gmail.com with ESMTPSA id
 la25-20020a170907781900b007829fb46a0esm1189403ejc.142.2022.09.27.11.42.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 11:42:45 -0700 (PDT)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@redhat.com
Date: Tue, 27 Sep 2022 20:42:26 +0200
Message-Id: <20220927184227.2001196-1-gmazyland@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH] dm-verity: Add documentation for
 try_verify_in_tasklet option.
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
Cc: snitzer@kernel.org, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add documentation for try_verify_in_tasklet feature implemented
in patch 5721d4e5a9cdb148f681a004ae5748890a0e2d90.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/admin-guide/device-mapper/verity.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 1a6b91368e59..a65c1602cb23 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -141,6 +141,10 @@ root_hash_sig_key_desc <key_description>
     also gain new certificates at run time if they are signed by a certificate
     already in the secondary trusted keyring.
 
+try_verify_in_tasklet
+    If verity hashes are in cache, verify data blocks in kernel tasklet instead
+    of workqueue. This option can reduce IO latency.
+
 Theory of operation
 ===================
 
-- 
2.37.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


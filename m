Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EED8C7EE2E
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 19:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685905615;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d1y9FBS1cyOmL/Miu33/ho8IMBorm0qdYIuiModiKz8=;
	b=hEKF/LlsyGuh7iRFxpzCHj2HryHG11JACNNKObFLM77Kc792seyy/yY5vh8oQvgm8henRf
	ki3aWPjAqwcBNY4PPxLPNCH5C0DgEl2wb8ORJl92mdkMMpCYcnNQfJdgTj7xCvPpheHqfm
	YpMWX90z4Y7uHhlwvjCpXHeZ/rgD+n8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-nUgRxgJLOUmwFD2jcZrtzg-1; Sun, 04 Jun 2023 15:06:52 -0400
X-MC-Unique: nUgRxgJLOUmwFD2jcZrtzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C740802A55;
	Sun,  4 Jun 2023 19:06:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B78B2026D49;
	Sun,  4 Jun 2023 19:06:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F15E619465A0;
	Sun,  4 Jun 2023 19:06:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2097019465A0
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 19:06:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F35FEC154D9; Sun,  4 Jun 2023 19:06:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB6ECC154D7
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:47 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF9E3101A52C
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 19:06:47 +0000 (UTC)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com
 [209.85.167.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-3kAS9ozYPvy1kWhKSlPQFw-1; Sun, 04 Jun 2023 15:06:46 -0400
X-MC-Unique: 3kAS9ozYPvy1kWhKSlPQFw-1
Received: by mail-oi1-f170.google.com with SMTP id
 5614622812f47-39a97058691so1243094b6e.2; 
 Sun, 04 Jun 2023 12:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685905605; x=1688497605;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=gxCtGKB4/odZJcA7XOpbwNyB264buEilxJGo+B0loX0=;
 b=eMkLq9YzIvlvNH9TI3/70sTQsLLL1FBaErjb/QvSgekAfRjZUU1zxhPiZNf11QoJLu
 bFlXRtUCvpxZzDikCLlyTEQ+z11/3k7lsobtNIOMegbGmzEsWjx2owZcjz7CSmFcFQSF
 E04hJKXHNhXhjLJB3ldKIxFSGDoEj8LSFyuq+AErTqknc9897J++szgpLtboLkrsGiNp
 CNme+NrYVHXG7Tp3y1tjLiSNIay5usgPU7fayTEAx2Zr4Kd8FyV6FY14+IIgWc6bUIh/
 Dry5oV2NL1QUCByXtgW6/32cOXoX4GzLcY0Ek+yELoioinQ3SchzH8NwGcaf+5XhNYUy
 ow5A==
X-Gm-Message-State: AC+VfDwXuq1yYUKp/AuXYje5VLZXRzEivs5TUVJYWq0nkZxthABRCLuz
 YpyMPJd35xefal1jLH4D/mk=
X-Google-Smtp-Source: ACHHUZ6ssUXm3UcAeNUYG9nhiMci3N0tZ8dME7Nxi/34YBG3u2FiT/w1W4ogjgwvVjSTmURMis1QwA==
X-Received: by 2002:a05:6808:298f:b0:398:ad87:2dab with SMTP id
 ex15-20020a056808298f00b00398ad872dabmr5904321oib.5.1685905604851; 
 Sun, 04 Jun 2023 12:06:44 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 m8-20020a170902db0800b001a6ed2d0ef8sm4979072plx.273.2023.06.04.12.06.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 12:06:44 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sun,  4 Jun 2023 12:06:02 -0700
Message-Id: <20230604190604.4800-3-eatnumber1@gmail.com>
In-Reply-To: <20230604190604.4800-1-eatnumber1@gmail.com>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v3 2/4] Documents the meaning of "buffer" in
 dm-integrity.
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

"Buffers" are buffers of the metadata/checksum area of dm-integrity.
They are always at most as large as a single metadata area on-disk, but
may be smaller.

Signed-off-by: Russell Harmon <eatnumber1@gmail.com>
---
 .../admin-guide/device-mapper/dm-integrity.rst      | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index b2a698e955a3..31f514675809 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -38,6 +38,15 @@ the device. But it will only format the device if the superblock contains
 zeroes. If the superblock is neither valid nor zeroed, the dm-integrity
 target can't be loaded.
 
+Accesses to the on-disk metadata area containing checksums (aka tags) are
+buffered using dm-bufio. When an access to any given metadata area
+occurs, each unique metadata area gets its own buffer(s). The buffer size
+is capped at the size of the metadata area, but may be smaller, thereby
+requiring multiple buffers to represent the full metadata area. A smaller
+buffer size will produce a smaller resulting read/write operation to the
+metadata area for small reads/writes. The metadata is still read even in
+a full write to the data covered by a single buffer.
+
 To use the target for the first time:
 
 1. overwrite the superblock with zeroes
@@ -106,10 +115,6 @@ buffer_sectors:number
 	The number of sectors in one buffer. The value is rounded down to
 	a power of two.
 
-	The tag area is accessed using buffers, the buffer size is
-	configurable. The large buffer size means that the I/O size will
-	be larger, but there could be less I/Os issued.
-
 journal_watermark:number
 	The journal watermark in percents. When the size of the journal
 	exceeds this watermark, the thread that flushes the journal will
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


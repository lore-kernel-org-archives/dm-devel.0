Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D5AC7EE24
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 05:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685941774;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d1y9FBS1cyOmL/Miu33/ho8IMBorm0qdYIuiModiKz8=;
	b=VFwB0DBiSKrQBD6Io8IOUt57xHGKYVdqoeIATw0r6TCIOMggfXgoJIcIWEoFGNP9hzJI0N
	wZFhTgUKR6kbIP8eZnyySXqOd0DJcg4oSgu7DDrJe0XZkhyzfdb7zRy4laCNeIZobSyRkE
	etBod8va6sf2G5cgNSu2h51ufa5QCHI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-u2sLsSWBN-CgWsO-E9bKzQ-1; Mon, 05 Jun 2023 01:09:31 -0400
X-MC-Unique: u2sLsSWBN-CgWsO-E9bKzQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7CB4101AA6E;
	Mon,  5 Jun 2023 05:09:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3C6BC154DA;
	Mon,  5 Jun 2023 05:09:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6CFCE19465A0;
	Mon,  5 Jun 2023 05:09:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF6511946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 05:09:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD69748205F; Mon,  5 Jun 2023 05:09:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A59BF4026E2
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:09:28 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87EE885A5BF
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:09:28 +0000 (UTC)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-X2xMlA15MDywp4Tv73xGLg-1; Mon, 05 Jun 2023 01:09:24 -0400
X-MC-Unique: X2xMlA15MDywp4Tv73xGLg-1
Received: by mail-il1-f173.google.com with SMTP id
 e9e14a558f8ab-33d0b7114a9so22227485ab.2; 
 Sun, 04 Jun 2023 22:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685941763; x=1688533763;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=gxCtGKB4/odZJcA7XOpbwNyB264buEilxJGo+B0loX0=;
 b=Xs+Kw3OGGmZEvlSZNScpW+pASw91ECK2cIFVLXgVq5+f7WVYNNWE9aAOOE49S1M3UD
 7BVvfF1Ber6BNogISGPrVXH2wb6PmiuNkzO26opDgXu5KNB3fjx5DE9h5EY5AV55VvX1
 qTbvUTohHNupB9N55lLWOvK+2laHKAVAcnqJNVb93guli33o6atJvuxxHS4K4rv4OPN2
 Y+7vxTC+yGuuIOrQeMEonVUmazraZ0UyFR+VsvoK+yc6OG77WPHhK6HlJPq4O4X+UUIa
 Iklo3wGlVqbFPzOIfO8YuUdFOZoHnrENcFeL6X3qwuMXwN1xRPvMxuEwuRSG0Vr5JD4O
 dZTg==
X-Gm-Message-State: AC+VfDyCxG2xsggXG2pcoqWm2VWHSWDV6FNxMeEO+JjpSnnRizRTgMaX
 wD0qJa7iKyS8upgArqG12TI=
X-Google-Smtp-Source: ACHHUZ60cJPCU5c2Z31OTJ0Ltf0fy4A4LvBh+XDacnGy9xXs5a9nqxcHEjW8sk1BcPEujSTDrlHz1g==
X-Received: by 2002:a92:cc11:0:b0:331:105c:81f9 with SMTP id
 s17-20020a92cc11000000b00331105c81f9mr19454579ilp.29.1685941762771; 
 Sun, 04 Jun 2023 22:09:22 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
 by smtp.gmail.com with ESMTPSA id
 fe16-20020a056a002f1000b0064d48d98260sm4329175pfb.156.2023.06.04.22.09.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 22:09:22 -0700 (PDT)
From: Russell Harmon <eatnumber1@gmail.com>
To: bagasdotme@gmail.com
Date: Sun,  4 Jun 2023 22:08:51 -0700
Message-Id: <20230605050853.6240-3-eatnumber1@gmail.com>
In-Reply-To: <20230605050853.6240-1-eatnumber1@gmail.com>
References: <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230605050853.6240-1-eatnumber1@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v4 2/4] Documentation: dm-integrity: Document the
 meaning of "buffer".
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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


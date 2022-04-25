Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A86C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 25 Apr 2022 12:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650891216;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pxJUvTIzeAlceDKagYMVM8V6SZKWhVUx9mL86mkyfi0=;
	b=VJ3LZMVVBJls07uUPZxRWD5RCLL/OTN/on4y0X4CvpxKGEnqLCAFdxmgdNtvR2AuJLUY83
	M3kA7gQeFBWxl926SSvYYcMueMCoxm/Ibx044+rJJRJa+jxNaLvCI8mjqAFkkGKkiAgCdC
	/MR99zj6yJy1YCbmIFX3LLW/2UHsSb4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-8KpoblrFM7mqcawA2BGK3g-1; Mon, 25 Apr 2022 08:53:33 -0400
X-MC-Unique: 8KpoblrFM7mqcawA2BGK3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A954C185A79C;
	Mon, 25 Apr 2022 12:53:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5ABF0401A994;
	Mon, 25 Apr 2022 12:53:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1016F1947BBF;
	Mon, 25 Apr 2022 12:53:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 144931947BBF
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 12:53:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 046D040F9D45; Mon, 25 Apr 2022 12:53:30 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F06BE40F9D43;
 Mon, 25 Apr 2022 12:53:29 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 23PCrT3U004328; Mon, 25 Apr 2022 08:53:29 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 23PCrTiG004325; Mon, 25 Apr 2022 08:53:29 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 25 Apr 2022 08:53:29 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204241654220.17244@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2204250851320.1699@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2204241654220.17244@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v2] dm-crypt: make printing of the key
 constant-time
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
Cc: dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is the second version of this patch. It casts the value to unsigned 
before doing the shift, because right shift of a negative number is not 
defined.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

The device mapper dm-crypt target is using scnprintf("%02x", cc->key[i]) to
report the current key to userspace. However, this is not constant-time
operation and it may leak information about the key via timing, via cache
access patterns or via the branch predictor.

This patch changes it to use "%c" instead. We introduce a function
hex2asc. hex2asc converts a number in the range 0 ... 15 to an ascii
character and it is coded in such a way that it contains no branches and
no memory accesses.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc; stable@vger.kernel.org

---
 drivers/md/dm-crypt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2022-04-25 14:41:15.000000000 +0200
+++ linux-2.6/drivers/md/dm-crypt.c	2022-04-25 14:42:06.000000000 +0200
@@ -3439,6 +3439,11 @@ static int crypt_map(struct dm_target *t
 	return DM_MAPIO_SUBMITTED;
 }
 
+static char hex2asc(unsigned char c)
+{
+	return c + '0' + ((unsigned)(9 - c) >> 4 & 0x27);
+}
+
 static void crypt_status(struct dm_target *ti, status_type_t type,
 			 unsigned status_flags, char *result, unsigned maxlen)
 {
@@ -3459,7 +3464,7 @@ static void crypt_status(struct dm_targe
 				DMEMIT(":%u:%s", cc->key_size, cc->key_string);
 			else
 				for (i = 0; i < cc->key_size; i++)
-					DMEMIT("%02x", cc->key[i]);
+					DMEMIT("%c%c", hex2asc(cc->key[i] >> 4), hex2asc(cc->key[i] & 0xf));
 		} else
 			DMEMIT("-");
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D687BEB64DC
	for <dm-devel@archiver.kernel.org>; Mon,  3 Jul 2023 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688397188;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3ZtkAWlCP6CMNbQEuoLk1Q/LKNKqmAQcONWVxVVEzIo=;
	b=TaQxrBQT10FncSgXKlGdzb3YPSdCZeYoGC69A3DoSkaZh2xOy7BsSCexJbQif83LGgtkzD
	8vzuoeldrwcWIKxKy1n5W15IubwTk/oB+gej+9rW7tyKJSGpP4vdbc0kAOCNWyAvDLhh9m
	ivFZE2fHr0zGg4yNohtUh4UaBSzohwM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19--kTu26c3MnG28FfvG_GLEg-1; Mon, 03 Jul 2023 11:13:05 -0400
X-MC-Unique: -kTu26c3MnG28FfvG_GLEg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A24851C09048;
	Mon,  3 Jul 2023 15:13:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C30CC492B02;
	Mon,  3 Jul 2023 15:12:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 71C921946588;
	Mon,  3 Jul 2023 15:12:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A64E1946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  3 Jul 2023 15:12:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED00240C2070; Mon,  3 Jul 2023 15:12:57 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5C6F40C2063;
 Mon,  3 Jul 2023 15:12:57 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id C4D2A30C0457; Mon,  3 Jul 2023 15:12:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 C0CC13FB76; Mon,  3 Jul 2023 17:12:39 +0200 (CEST)
Date: Mon, 3 Jul 2023 17:12:39 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <372fae19-65df-9ba7-8df7-c8b9a43358cf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH] dm-integrity: fix double free on memory
 allocation failure
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I found a bug in one of the patches that I submitted. Here I'm submitting 
the fix. Please send it to Linus before 6.5 is released.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

If the statement "recalc_tags = kvmalloc(recalc_tags_size, GFP_NOIO);"
fails, we call "vfree(recalc_buffer)" and we jump to the label "oom".

If the condition "recalc_sectors >= 1U << ic->sb->log2_sectors_per_block"
is false, we jump to the label "free_ret" and call "vfree(recalc_buffer)"
again, on an already released memory block.

This commit fixes the bug by setting "recalc_buffer = NULL" after freeing
it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: da8b4fc1f63a ("dm integrity: only allocate recalculate buffer when needed")

---
 drivers/md/dm-integrity.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -2691,6 +2691,7 @@ oom:
 	recalc_tags = kvmalloc(recalc_tags_size, GFP_NOIO);
 	if (!recalc_tags) {
 		vfree(recalc_buffer);
+		recalc_buffer = NULL;
 		goto oom;
 	}
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


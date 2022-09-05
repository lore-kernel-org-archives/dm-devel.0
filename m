Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D61FECAAD3
	for <dm-devel@archiver.kernel.org>; Mon,  5 Sep 2022 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662391309;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q6l2ZDPCcPSxqOcM+mjdNfoSnb35Ex8irHTIy/pV/GE=;
	b=QBFokF0Y2xaRd0LxM1DDoE+JPr4pD+r48xgWkNGhp2JBRdvE/vwSUA0J5sxT9Qofq3v83A
	+Ae9YZuToegCqoaMB4WJNNbdU+INrTmjhlfYN4JuqhS2Wty9pBqsjMqbmn6BSuEfKCrtDP
	66TzSlew9bxl2NGO7W34ZAQvlXo7Roo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-SZ4nPMPBPs6OuZdD51Ua1A-1; Mon, 05 Sep 2022 11:21:45 -0400
X-MC-Unique: SZ4nPMPBPs6OuZdD51Ua1A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF99D811E80;
	Mon,  5 Sep 2022 15:21:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 589CD492C3B;
	Mon,  5 Sep 2022 15:21:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 365CA1946A48;
	Mon,  5 Sep 2022 15:21:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D5081946A47
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Sep 2022 15:21:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 70AD8945D7; Mon,  5 Sep 2022 15:21:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67355945D0;
 Mon,  5 Sep 2022 15:21:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 285FLeLL008673; Mon, 5 Sep 2022 11:21:40 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 285FLeVv008669; Mon, 5 Sep 2022 11:21:40 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 5 Sep 2022 11:21:40 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2209051120510.8614@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 1/2] mm: export is_vmalloc_or_module_addr
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Export is_vmalloc_or_module_addr - we will need it in device mapper to
determine if the error string is statically or dynamically allocated.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-dm/mm/vmalloc.c
===================================================================
--- linux-dm.orig/mm/vmalloc.c	2022-09-05 13:29:57.000000000 +0200
+++ linux-dm/mm/vmalloc.c	2022-09-05 14:30:51.000000000 +0200
@@ -637,6 +637,7 @@ int is_vmalloc_or_module_addr(const void
 #endif
 	return is_vmalloc_addr(x);
 }
+EXPORT_SYMBOL(is_vmalloc_or_module_addr);
 
 /*
  * Walk a vmap address to the struct page it maps. Huge vmap mappings will
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


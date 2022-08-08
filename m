Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED63C00140
	for <dm-devel@archiver.kernel.org>; Mon,  8 Aug 2022 14:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659970232;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b0yl3YOijP0jbrwYyhg1LCPC48+yrj+zpgfXGgz2rB8=;
	b=XuvgSKipD9P3oRLKe0HSyShMa4HXQkYsEZDCo2SoEgKTqw/9rg/4MeRqw6gmGzqGTLIaUW
	sHQGQ6CgmyQsp2Ma2M30J3JCUItCfUFVvqMv6PK59BsLP37LOu6ncu88RxK6+Gu9xJnCzY
	9zVgZamkbjcWcAKZe7scMgbjy/rP9n0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-BumYQrQGMiSJv-HovEViLQ-1; Mon, 08 Aug 2022 10:50:29 -0400
X-MC-Unique: BumYQrQGMiSJv-HovEViLQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D20185A587;
	Mon,  8 Aug 2022 14:50:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B488400F36;
	Mon,  8 Aug 2022 14:50:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9B061946A4F;
	Mon,  8 Aug 2022 14:50:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3087E1946A49
 for <dm-devel@listman.corp.redhat.com>; Mon,  8 Aug 2022 14:50:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E40209458A; Mon,  8 Aug 2022 14:50:14 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BAD2E18ECC;
 Mon,  8 Aug 2022 14:50:13 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 278EoDG2013274; Mon, 8 Aug 2022 10:50:13 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 278EoAkb013269; Mon, 8 Aug 2022 10:50:12 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 8 Aug 2022 10:50:10 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com
In-Reply-To: <202208050301.roHRxc6O-lkp@intel.com>
Message-ID: <alpine.LRH.2.02.2208081034050.8160@file01.intranet.prod.int.rdu2.redhat.com>
References: <202208050301.roHRxc6O-lkp@intel.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH] dm-writecache: drop the lock on an 'impossible'
 path
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
Cc: kbuild@lists.01.org, kbuild-all@lists.01.org, lkp@intel.com,
 Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Fri, 5 Aug 2022, Dan Carpenter wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1
> commit: df699cc16ea5ef93a917676dcdd4376e02860ad5 dm writecache: report invalid return from writecache_map helpers
> config: arc-randconfig-m041-20220804 (https://download.01.org/0day-ci/archive/20220805/202208050301.roHRxc6O-lkp@intel.com/config)
> compiler: arc-elf-gcc (GCC) 12.1.0
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> drivers/md/dm-writecache.c:1554 writecache_map() warn: inconsistent returns '&wc->lock'.

Hi

Here I'm sending a patch for this warning.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

There's a smatch warning "inconsistent returns '&wc->lock'" in
dm-writecache. The reason for the warning is that the function
writecache_map doesn't drop the lock on the impossible path. This patch
adds wc_unlock after the BUG statement (so that it will be compiled-away
anyway) to fix the warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -1598,7 +1598,8 @@ done:
 
 	default:
 		BUG();
-		return -1;
+		wc_unlock(wc);
+		return DM_MAPIO_KILL;
 	}
 }
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


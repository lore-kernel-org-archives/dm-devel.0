Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A037C6379F
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 12:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676464990;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ei7ULUguaHXrySCtjX18ho57SmOd9W1SNu+MpbPiSQ8=;
	b=dGPCfoVHnHDcSGQ1sboSYn0u2b1nyezAU4b3GdFEXE6oR4aBCJCjnHsWdXog95mJSPRxoR
	zbA55ptiK2jYILMUWQYiBNPoTaYzw00Fsjhk0rPVE5vsY9YeolvXsCAsuIp9v4QhQ+OZ4Q
	jpNMFop+UFRjpw8aC1KcP036k005/b4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-ru0sv2BmNCKZYoSXy9a3PQ-1; Wed, 15 Feb 2023 07:41:26 -0500
X-MC-Unique: ru0sv2BmNCKZYoSXy9a3PQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F00E38173CB;
	Wed, 15 Feb 2023 12:41:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7E0184035705;
	Wed, 15 Feb 2023 12:41:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 584121946588;
	Wed, 15 Feb 2023 12:41:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 83CA31946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 12:23:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 749A6492C3C; Wed, 15 Feb 2023 12:23:38 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E0C7492B0E;
 Wed, 15 Feb 2023 12:23:38 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 31FCNcAQ007819; Wed, 15 Feb 2023 07:23:38 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 31FCNbeX007815; Wed, 15 Feb 2023 07:23:37 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 15 Feb 2023 07:23:37 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Yang Shi <shy828301@gmail.com>
In-Reply-To: <20230214190221.1156876-1-shy828301@gmail.com>
Message-ID: <alpine.LRH.2.21.2302150716120.5940@file01.intranet.prod.int.rdu2.redhat.com>
References: <20230214190221.1156876-1-shy828301@gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [v2 PATCH 0/5] Introduce mempool pages bulk
 allocator and use it in dm-crypt
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
Cc: snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 akpm@linux-foundation.org, mgorman@techsingularity.net, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 14 Feb 2023, Yang Shi wrote:

> 
> Changelog:
> RFC -> v2:
>   * Added callback variant for page bulk allocator and mempool bulk allocator
>     per Mel Gorman.
>   * Used the callback version in dm-crypt driver.
>   * Some code cleanup and refactor to reduce duplicate code.
> 
> rfc: https://lore.kernel.org/linux-mm/20221005180341.1738796-1-shy828301@gmail.com/

Hi

This seems like unneeded complication to me. We have alloc_pages(), it can 
allocate multiple pages efficiently, so why not use it?

I suggest to modify crypt_alloc_buffer() to use alloc_pages() and if 
alloc_pages() fails (either because the system is low on memory or because 
memory is too fragmented), fall back to the existing code that does 
mempool_alloc().

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


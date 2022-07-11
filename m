Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8D4C43334
	for <dm-devel@archiver.kernel.org>; Mon, 11 Jul 2022 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657571404;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RGPa2gi+vma2xtYyDThJbjC74pgQzw7rEpwQe+b/L+M=;
	b=NBMukToojZ5rbNQyTqaVJWI7jGSHIyZb4h14ETf9toIsOD2me8HsU+Uj83xgxRGlOInWcY
	5d1L23fcPh0ezSfEUQg5tpxmKmkRFNXAmqJNVBn4A//Bsno8D5V3gQKNQ2bze4phuMJOvF
	UN/XEVPZ22AHhog517AwmaHypy7j2l0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-RVD16FDXP0q9u_uOYMT4Zw-1; Mon, 11 Jul 2022 16:29:55 -0400
X-MC-Unique: RVD16FDXP0q9u_uOYMT4Zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B868A2803025;
	Mon, 11 Jul 2022 20:29:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B60521121314;
	Mon, 11 Jul 2022 20:29:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 16F6E194705C;
	Mon, 11 Jul 2022 20:29:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00AD7194705C
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Jul 2022 20:29:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C35862166B2A; Mon, 11 Jul 2022 20:29:46 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 810D92166B26;
 Mon, 11 Jul 2022 20:29:46 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26BKTkAL005368; Mon, 11 Jul 2022 16:29:46 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26BKTjIX005364; Mon, 11 Jul 2022 16:29:45 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 11 Jul 2022 16:29:45 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Yu Kuai <yukuai1@huaweicloud.com>, Mike Snitzer <msnitzer@redhat.com>
In-Reply-To: <20220706093146.1961598-1-yukuai1@huaweicloud.com>
Message-ID: <alpine.LRH.2.02.2207111627260.5249@file01.intranet.prod.int.rdu2.redhat.com>
References: <20220706093146.1961598-1-yukuai1@huaweicloud.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] dm writecache: fix inaccurate reads/writes
 stats
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
Cc: yukuai3@huawei.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 agk@redhat.com, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 6 Jul 2022, Yu Kuai wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Test procedures:
> 
> 1) format a dm writecache device with 4k blocksize.
> 2) flush cache.
> 3) cache 1G data through write.
> 4) clear stats.
> 5) read 2G data with bs=1m.
> 6) read stats.
> 
> Expected result:
> cache hit ratio is 50%.
> 
> Test result:
> stats: 0, 1011345, 749201, 0, 263168, 262144, 0, 0, 0, 0, 0, 0, 0, 0
> ratio is 99% (262144/263168)

Hi

Here I'm providing patches that change the dm-writecache counting from 
requests to blocks.

Mike, you can queue them for the next merge window.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA02C001DE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Aug 2023 10:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691662040;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oXZaQ7v9PsvSPP9eoT0AfxDesRGn8M7RXAhfjrpkuUs=;
	b=GUZm/cwSoWkjQ3fSgu29N6vDzG1EMIyA31QgjWC7hKAAjOSqCCytGNNOQc9g1i1no7Upx2
	NBIrmYBIf4YveG9nPLTMpyp7wKEOoBVU8m2Ekr4AAgKqtE10QqE4RvW7Y8u3pVjOXc4Zl9
	Z93V8ROHyvFPZr/lpf1OaJUix5Jg6p0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-dY5Ilrz3MVm_17CAKunAIg-1; Thu, 10 Aug 2023 06:07:16 -0400
X-MC-Unique: dY5Ilrz3MVm_17CAKunAIg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E74BD101B42B;
	Thu, 10 Aug 2023 10:07:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5424C401E9C;
	Thu, 10 Aug 2023 10:07:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 122BE1946589;
	Thu, 10 Aug 2023 10:07:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D4721946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 10 Aug 2023 10:07:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 587561121315; Thu, 10 Aug 2023 10:07:08 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 465011121314;
 Thu, 10 Aug 2023 10:07:08 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 979E530B9C07; Thu, 10 Aug 2023 10:07:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 860CE3F7CF; Thu, 10 Aug 2023 12:07:07 +0200 (CEST)
Date: Thu, 10 Aug 2023 12:07:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <2dacc73-854-e71c-1746-99b017401c9a@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH v3 0/4] brd discard patches
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
Cc: linux-block@vger.kernel.org, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Christoph Hellwig <hch@infradead.org>, Li Nan <linan666@huaweicloud.com>,
 dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

Here I'm submitting the ramdisk discard patches for the next merge window. 
If you want to make some more changes, please let me now.

Changes since version 2:
There are no functional changes, I only moved the switch statement 
conversion to a separate patch, so that it's easier to review.

Patch 1: introduce a switch statement in brd_submit_bio
Patch 2: extend the rcu regions to cover read and write
Patch 3: enable discard
Patch 4: implement write zeroes

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


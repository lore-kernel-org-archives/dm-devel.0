Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D760C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646062753;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NMEBeu8Pjo9603ZQIjy3wtX8M9TWno77A2ZxWOi++HM=;
	b=QLdfJHDgXGI7RJMVsPJjWAd1gl3hLZ0AzRWThGQitLwtP/LBnRFpRB2+akYSxf8h29Inl/
	IZmtXTQDOrybKd9J5hLQAPBEtJZ621TpERj9mOKQuY9KylTwkvcPjPoMLQrSYhEBt1vBRw
	+CUdU6lATiTMifRhPvISmcsI37tEwu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-zdw0XhmQP-ezn9VW5T1O6Q-1; Mon, 28 Feb 2022 10:39:08 -0500
X-MC-Unique: zdw0XhmQP-ezn9VW5T1O6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 272F88031E1;
	Mon, 28 Feb 2022 15:39:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76A41866D8;
	Mon, 28 Feb 2022 15:39:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D037546F98;
	Mon, 28 Feb 2022 15:39:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21SFbIYV017790 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 10:37:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 600162026D07; Mon, 28 Feb 2022 15:37:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ABCD2026D6B
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 15:37:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5824E38035C3
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 15:37:12 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
	[209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-215-ElX9sE8SPCi8TeD9YfITvQ-1; Mon, 28 Feb 2022 10:37:10 -0500
X-MC-Unique: ElX9sE8SPCi8TeD9YfITvQ-1
Received: by mail-qk1-f197.google.com with SMTP id
	7-20020a05620a048700b00648b76040f6so11382901qkr.9
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 07:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=sjaDo6eH0eoLXgxKuxNLQJ5iIU1H/s1UNhZXUOMXefw=;
	b=o9Bnu05Gc7WaNiCFI6MbKTurdbR7S0/vAJqID9ohGE+e1jExutcCmh90YDqFz5Oqdg
	9TG5wqT05IJJJLEq3uvnfKzPrZbijx+HVh4Nn2rZCEsd30+PRqETbcyATcT4zDlTndPh
	dVL++GITu5yM/JY5oluR9JUI6u9y7YQ3eoTaWt7CGF+HMnwR6cIJN46HxWF2bXVpVm8t
	axv0Y/TDnqPh93Q9mtwX0IZTeTuD2QcUlYi4Q2DHM0gHS7djpuMpv+PtUo5PViMhqcwW
	TDRd/dSiWbVajrwbpDQ2r90q4hV4ft3jl04SSwRzuvcNIz9ZgDBqFLRV3Gmiy2dP27e2
	AVRQ==
X-Gm-Message-State: AOAM530GNr1Az84XGuLisTsLnRHJzIz/fetp5WQrVfp4UQpzhLybRxYh
	NJmFWU1GZme+VbTWYDVm8vH+nOg0f9uVQtLDoZXXXJ1kaTWEZZce8+RsjEAal2BBUo8eXhPySus
	nEjeAQkksz88KpQ==
X-Received: by 2002:ac8:7246:0:b0:2dd:fe3e:127b with SMTP id
	l6-20020ac87246000000b002ddfe3e127bmr16601973qtp.422.1646062630013;
	Mon, 28 Feb 2022 07:37:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzn/cCGVmfqNHDbkHXVL0z8ShMNzhgpVyqE+nUbBRTdBv3C2n8VqHaCM0EjnzinnO+n7dFj4g==
X-Received: by 2002:ac8:7246:0:b0:2dd:fe3e:127b with SMTP id
	l6-20020ac87246000000b002ddfe3e127bmr16601958qtp.422.1646062629796;
	Mon, 28 Feb 2022 07:37:09 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	v1-20020a05622a130100b002de7e96aa7asm7106012qtk.79.2022.02.28.07.37.09
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 28 Feb 2022 07:37:09 -0800 (PST)
Date: Mon, 28 Feb 2022 10:37:08 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Luo Meng <luomeng12@huawei.com>
Message-ID: <YhzsJKjj4VK1wK/W@redhat.com>
References: <20220228141354.1091687-1-luomeng12@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20220228141354.1091687-1-luomeng12@huawei.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: yukuai3@huawei.com, dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] Revert "dm space maps: don't reset space map
 allocation cursor when committing"
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 28 2022 at  9:13P -0500,
Luo Meng <luomeng12@huawei.com> wrote:

> This reverts commit 5faafc77f7de69147d1e818026b9a0cbf036a7b2.
> 
> This commit 5faafc77f7de ("dm space maps: don't reset space map allocation
> cursor when committing") change the way to find free block.
> 
> But when use ramdisk(not support discard) for thin-pool,and storage
> over-commitment. Then constantly create and delete file, can find block
> in thin-pool, but can't find block in ramdisk.
> 
> So need revert this patch.
> 
> Fixes: 5faafc77f7de ("dm space maps: don't reset space map allocation cursor when committing")
> Signed-off-by: Luo Meng <luomeng12@huawei.com>

What you're saying doesn't make any sense.  Especially when you
consider this last part of the commit message:
"Fix these issues by leaving the cursor alone, only resetting when the
 search hits the end of the metadata device."

If you've found that the cursor isn't being reset to the beginning
once the search hits the end of the metadata device, then that needs
fixing... but a revert of the  commit in question isn't appropriate.

BTW, it shouldn't matter whether or not the underlying ramdisk supports
discards.  The thin-pool controls the allocation of underlying storage.

So all said:

Nacked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


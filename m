Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD5FC77B7E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685642048;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F3D6XV6zlRGKA0NHeGQkeFss1u5yapknkHudoMWxwag=;
	b=DMto2jSgdteHsRn+hnjMjeoLO+77YdDEUokiRliYXy5YyT5G8kmpUHIOl+dgat2TT+qHSU
	OjF6MtiaCiwwhZ+KS9tZytbg9cFcRuGSmSUkskJ4YGT5LQzwyXDciIat3Em/s/O+ymYym4
	EHE13ksKzKR9zVl73qIEnC7vFIT2sX0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-EyBdUSieMVunAx01zqn5Zg-1; Thu, 01 Jun 2023 13:54:05 -0400
X-MC-Unique: EyBdUSieMVunAx01zqn5Zg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8307B8032EF;
	Thu,  1 Jun 2023 17:54:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 533A49E78;
	Thu,  1 Jun 2023 17:54:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F3CE1946595;
	Thu,  1 Jun 2023 17:54:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 752AE194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 17:54:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 26E19C154D9; Thu,  1 Jun 2023 17:54:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F514C154D7
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 17:54:00 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63C5B101A53A
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 17:53:59 +0000 (UTC)
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com
 [91.218.175.20]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-7ZkbHiiLMeui2wzciiTX5g-1; Thu, 01 Jun 2023 13:53:57 -0400
X-MC-Unique: 7ZkbHiiLMeui2wzciiTX5g-1
Date: Thu, 1 Jun 2023 13:53:51 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZHjbL1o1KZt1385/@moria.home.lan>
References: <alpine.LRH.2.21.2305300803220.12797@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2305300803220.12797@file01.intranet.prod.int.rdu2.redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] bcachefs: fix NULL pointer dereference in
 try_alloc_bucket
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
Cc: linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 30, 2023 at 08:15:41AM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 29 May 2023, Mikulas Patocka wrote:
> 
> > The oops happens in set_btree_iter_dontneed and it is caused by the fact 
> > that iter->path is NULL. The code in try_alloc_bucket is buggy because it 
> > sets "struct btree_iter iter = { NULL };" and then jumps to the "err" 
> > label that tries to dereference values in "iter".
> 
> Here I'm sending a patch for it.
> 
> 
> 
> +		set_btree_iter_dontneed(&iter);
>  	bch2_trans_iter_exit(trans, &iter);

I need to look at this code a bit more, perhaps we'll want to move the
check into set_btree_iter_dontneed(), since iter_exit() is safe to call
on an uninitialized-but-zeroed iterator

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


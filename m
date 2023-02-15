Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51758C6379F
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 08:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676536033;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fGZCVK34/UHA8RK7wL5vIx6JBCNMOY194+JTptsFOL8=;
	b=efTbvSldX+GYn2sJpgsaN/JPtPoXiNmzZI4e8uFTFU+zDAUXf9tX1YNNH9pvGnnKPgiHkS
	q59CqLT4ItavoZTGIYyyiYy0lt2BA0PHJhcY79BKTVMi7NL+95nlK01hnnrukpxMZIM+ac
	636BolW0FScOjkqEoAQgemzfXTTsiMU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-_SFfWfklO9qWDxfxV4n3Yw-1; Thu, 16 Feb 2023 03:27:09 -0500
X-MC-Unique: _SFfWfklO9qWDxfxV4n3Yw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 723CF29ABA20;
	Thu, 16 Feb 2023 08:27:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B314401014C;
	Thu, 16 Feb 2023 08:27:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7DD11946589;
	Thu, 16 Feb 2023 08:27:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D46BD1946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 20:00:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B469B40CF8EA; Wed, 15 Feb 2023 20:00:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACE6F4010E86
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 20:00:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90C7580280C
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 20:00:37 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-349-TQg2KuPIOvGG1F-Krd2sww-1; Wed, 15 Feb 2023 15:00:30 -0500
X-MC-Unique: TQg2KuPIOvGG1F-Krd2sww-1
Received: by mail-pl1-f172.google.com with SMTP id be8so21379366plb.7;
 Wed, 15 Feb 2023 12:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=dFrWO0f7yzYN0JfWwtvFw3Ysd86ppP1HxQirWGWfkGU=;
 b=Hw48HJPBKvdBiYlIdGeTml6AO3wk2LVuN4/QokzSo4gqxqutx0MJpjlSNkaYQiKSTP
 9SnsmDvez4IaLQ15iMMhCDH3qafhTYvFXEAwW7nkPemsSh8oAkw0sdUvTYUBsLMvTIB3
 0NICp246lJROkrpgi55pgDoNSgQm9NGiJ6UuhxCYnYRLZ/HbhX/RLXwtAQKxT+lvnFxE
 anviEH784zSqgBOYxHCpjpu6m4o3Jhvbm6hLZGo9a3a8hsK2E9SAhw+VgXeVUz8cRGkH
 5kIbzzUfidWKrRcpb8LN9IvfgFmWM/PZ9lTX6nUQ/sv6uPTHRjMRorfwYedzQIKzWqua
 SJ0A==
X-Gm-Message-State: AO0yUKU45DK6dEwF2tIboL8VmZfxdHUfcHnXaPlTM0HfgJFhVHqnq54H
 NiCz2gJXgF5xQKXBto6Ds+OQMPPg52qApdyz7dSVYPTX
X-Google-Smtp-Source: AK7set9bs5Zg8Yirc4qUbLHYhiamHtAx2jf0H+f1/8yBTmxsP26MbB8uiOOGpaGbls5Iz91VFs683r7GA3VbOXJNbLQ=
X-Received: by 2002:a17:90b:1e4c:b0:230:b973:a726 with SMTP id
 pi12-20020a17090b1e4c00b00230b973a726mr138046pjb.23.1676491221040; Wed, 15
 Feb 2023 12:00:21 -0800 (PST)
MIME-Version: 1.0
References: <20230214190221.1156876-1-shy828301@gmail.com>
 <alpine.LRH.2.21.2302150716120.5940@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.21.2302150716120.5940@file01.intranet.prod.int.rdu2.redhat.com>
From: Yang Shi <shy828301@gmail.com>
Date: Wed, 15 Feb 2023 12:00:09 -0800
Message-ID: <CAHbLzkr4RrKpR1pGZxs7JdB=R539SiNgO2+Fr7X-rVKcBh5tQQ@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Thu, 16 Feb 2023 08:27:05 +0000
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

On Wed, Feb 15, 2023 at 4:23 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Tue, 14 Feb 2023, Yang Shi wrote:
>
> >
> > Changelog:
> > RFC -> v2:
> >   * Added callback variant for page bulk allocator and mempool bulk allocator
> >     per Mel Gorman.
> >   * Used the callback version in dm-crypt driver.
> >   * Some code cleanup and refactor to reduce duplicate code.
> >
> > rfc: https://lore.kernel.org/linux-mm/20221005180341.1738796-1-shy828301@gmail.com/
>
> Hi
>
> This seems like unneeded complication to me. We have alloc_pages(), it can
> allocate multiple pages efficiently, so why not use it?

The alloc_pages() allocates *contiguous* pages, but dm-crypt doesn't
need contiguous pages at all. This may incur unnecessary compaction
overhead to the dm-crypt layer when memory is fragmented. The bulk
allocator is a good fit to this usecase, which allocates multiple
order-0 pages.

In addition, filesystem writeback doesn't guarantee power-of-2 pages
every time IIUC. But alloc_pages() just can allocate power-of-2 pages.

>
> I suggest to modify crypt_alloc_buffer() to use alloc_pages() and if
> alloc_pages() fails (either because the system is low on memory or because
> memory is too fragmented), fall back to the existing code that does
> mempool_alloc().

My PoC patches just did this way, but called bulk allocator. There may
be other potential mepool users as I listed in this cover letter,
which may get benefits from bulk allocator. So introducing a new bulk
mempool API seems better for long run although we just have one user
for now. And it makes other uses easier to gain the benefit by just
calling the new API.

>
> Mikulas
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


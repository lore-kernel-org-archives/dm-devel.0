Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A06C3A59D
	for <dm-devel@archiver.kernel.org>; Mon, 24 Oct 2022 06:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666593963;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p0PpS+aX8paWMQ1PQksx84zg9gLO+rSSCzDydkbvpoE=;
	b=J2/GU3+8PABvx0onSESrhcRtd9toG+S7EDsYGasolr/yUAeqgLWnzMXE3Cz2gaG938NrVJ
	w4OdKXreEBrypBx6j+avdl432coHmEoRTaG7v9wmXmXeTpVw1VDE7fRn21sFyGvRRrIWNp
	DObKiwmZUG88S2jGw0fUyXzQl/Vd2Zc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-mB3hGgDANwyOAB-PlPh9pA-1; Mon, 24 Oct 2022 02:45:59 -0400
X-MC-Unique: mB3hGgDANwyOAB-PlPh9pA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38B62101A52A;
	Mon, 24 Oct 2022 06:45:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DDB2C40C2064;
	Mon, 24 Oct 2022 06:45:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9D09E1946589;
	Mon, 24 Oct 2022 06:45:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D4081946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 21:04:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6A43E40C2086; Fri, 21 Oct 2022 21:04:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62CB240C2065
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 21:04:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 485103811F2A
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 21:04:51 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10--S4uW7oaMQux3t0x_rNNJQ-1; Fri, 21 Oct 2022 17:04:48 -0400
X-MC-Unique: -S4uW7oaMQux3t0x_rNNJQ-1
Received: by mail-pl1-f180.google.com with SMTP id 10so3481339pli.0;
 Fri, 21 Oct 2022 14:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=ufCCYZYJTmJF/KoW5M3amrstoH4BcMXNIbfmJhiw4Bg=;
 b=Q9q7rmUZhoyTJmGmphgh4J+0H8Nhz4+ohbT2hgM1wB0s8zBU3i52M09rEdsHUyshtN
 3uq10xIaD1Kv/nevbRctq/oYrWOQbe3KySQv0wAsw8oKICey7uGKTRcdqYcJiEdwe4gW
 mS5JB/zRt9OYRX92WON+TWoYtmsVNeNlaUW/HnbjNyheItYSigXvO/n/7BCF1XtrIi+d
 uWMymz7HsV600/sbBwALrEAXUs7JdBrExUU8dOW3JkS74HuRCX0CgEwxXnee5yVYsT5T
 VBMev6A4NqhAbd0FxCuDNRnGl06J8C9HGjLeO/llNxOpiqLdXGCHqmtBGsLYbdfTrghA
 jE/Q==
X-Gm-Message-State: ACrzQf2Mq/sSkJa5zLZP6nELAuscTp/2fKu7dKMvBo+xBsIQaIbPmds3
 jujInztJ+YO+gQbJsjW7pfyhxIwhKl2KgRmFTgPln4UN
X-Google-Smtp-Source: AMsMyM5tsrngLoCck9omAqu1bf1kz4Ah2EpMQMR6bhFE6MpEItn2IXmD213rWwn/DZs1vJCr8D+09/EppIvZSTFyUfI=
X-Received: by 2002:a17:902:d512:b0:181:f1f4:fcb4 with SMTP id
 b18-20020a170902d51200b00181f1f4fcb4mr21208456plg.102.1666386287303; Fri, 21
 Oct 2022 14:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <20221005180341.1738796-1-shy828301@gmail.com>
 <20221005180341.1738796-3-shy828301@gmail.com>
 <20221013123830.opbulq4qad56kuev@techsingularity.net>
 <CAHbLzkpc+CAfsYe6gXjh=-3MxMH_aWhPMYhic7ddFZgWttOhng@mail.gmail.com>
 <20221017094132.vnanndrwa2yn7qcw@techsingularity.net>
 <CAHbLzkpmbmtOdOsud-VG+wyk18wFAFnan8T55XxxwkHrnhLCmw@mail.gmail.com>
 <20221021091911.ak3a7a3wr3qcbe3b@techsingularity.net>
In-Reply-To: <20221021091911.ak3a7a3wr3qcbe3b@techsingularity.net>
From: Yang Shi <shy828301@gmail.com>
Date: Fri, 21 Oct 2022 14:04:34 -0700
Message-ID: <CAHbLzkpAX3CGRGsxj4CTsj=atXqPakJe7TSxVvp3KnKmygk=3g@mail.gmail.com>
To: Mel Gorman <mgorman@techsingularity.net>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 24 Oct 2022 06:45:52 +0000
Subject: Re: [dm-devel] [PATCH 2/4] mm: mempool: introduce page bulk
 allocator
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
 akpm@linux-foundation.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 21, 2022 at 2:19 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Tue, Oct 18, 2022 at 11:01:31AM -0700, Yang Shi wrote:
> > > > Yeah, I didn't think of a better way to pass the pages to dm-crypt.
> > > >
> > > > >
> > > > > How about this
> > > > >
> > > > > 1. Add a callback to __alloc_pages_bulk() that takes a page as a
> > > > >    parameter like bulk_add_page() or whatever.
> > > > >
> > > > > 2. For page_list == NULL && page_array == NULL, the callback is used
> > > > >
> > > > > 3. Add alloc_pages_bulk_cb() that passes in the name of a callback
> > > > >    function
> > > > >
> > > > > 4. In the dm-crypt case, use the callback to pass the page to bio_add_page
> > > > >    for the new page allocated.
> > > >
> > > > Thank you so much for the suggestion. But I have a hard time
> > > > understanding how these work together. Do you mean call bio_add_page()
> > > > in the callback? But bio_add_page() needs other parameters. Or I
> > > > misunderstood you?
> > > >
> > >
> > > I expected dm-crypt to define the callback. Using bio_add_page
> > > directly would not work as the bulk allocator has no idea what to pass
> > > bio_add_page. dm-crypt would likely need to create both a callback and an
> > > opaque data structure passed as (void *) to track "clone" and "len"
> >
> > I see. Yeah, we have to pass the "clone" and "len" to the callback via
> > pool_data. It should not be hard since dm-crypt already uses
> > crypt_config to maintain a counter for allocated pages, we should just
> > need to pass the struct to the callback as a parameter.
> >
> > But I'm wondering whether this is worth it or not? Will it make the
> > code harder to follow?
> >
>
> A little because a callback is involved but it's not the only place in the
> kernel where a callback is used like this and a comment should suffice. It
> should be faster than list manipulation if nothing else. Mostly, I'm wary
> of adding the first user of the list interface for the bulk allocator that
> does not even want a list. If there isn't a user of the list interface
> that *requires* it, the support will simply be deleted as dead code.

Thanks, I see your point. Will work on the new version to implement
the callback approach.

>
> --
> Mel Gorman
> SUSE Labs

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


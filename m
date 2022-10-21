Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D3DC38A2D
	for <dm-devel@archiver.kernel.org>; Mon, 24 Oct 2022 06:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666593964;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DDzhMp8zl/nt5941NlSn1bJZLiEGlm3pJeF4By4nqko=;
	b=huTQYN/pls1GT49jZSH6erHLGdfXZUL2MxUlC0CjpfbO582xDiJlkWrd/vYThL+Q4cxXD7
	6Rc++/DGIwyeZuOh6nph5qpQmt5Fp9jtNT86Z7vlJAfmgtI1EvcyBaEYIWAeppfc73g5QY
	ThzyT3uaAFlCyfHCAHdQcXVbBAdU/Qo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-onm2eZf4M-uZtfiwFQE9Ww-1; Mon, 24 Oct 2022 02:46:00 -0400
X-MC-Unique: onm2eZf4M-uZtfiwFQE9Ww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3896929AA3BC;
	Mon, 24 Oct 2022 06:45:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E34014152E1;
	Mon, 24 Oct 2022 06:45:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F3B419465A3;
	Mon, 24 Oct 2022 06:45:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 581CB1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 09:28:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 305252024CBF; Fri, 21 Oct 2022 09:28:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 28F032024CBB
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 09:28:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09968101A528
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 09:28:16 +0000 (UTC)
Received: from outbound-smtp11.blacknight.com
 (outbound-smtp11.blacknight.com [46.22.139.106]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-p3ZP64Y4Mdy-TQUjbac7TQ-1; Fri, 21 Oct 2022 05:28:13 -0400
X-MC-Unique: p3ZP64Y4Mdy-TQUjbac7TQ-1
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
 by outbound-smtp11.blacknight.com (Postfix) with ESMTPS id 6C2C01C4271
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 10:19:13 +0100 (IST)
Received: (qmail 8314 invoked from network); 21 Oct 2022 09:19:13 -0000
Received: from unknown (HELO techsingularity.net)
 (mgorman@techsingularity.net@[84.203.198.246])
 by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated);
 21 Oct 2022 09:19:13 -0000
Date: Fri, 21 Oct 2022 10:19:11 +0100
From: Mel Gorman <mgorman@techsingularity.net>
To: Yang Shi <shy828301@gmail.com>
Message-ID: <20221021091911.ak3a7a3wr3qcbe3b@techsingularity.net>
References: <20221005180341.1738796-1-shy828301@gmail.com>
 <20221005180341.1738796-3-shy828301@gmail.com>
 <20221013123830.opbulq4qad56kuev@techsingularity.net>
 <CAHbLzkpc+CAfsYe6gXjh=-3MxMH_aWhPMYhic7ddFZgWttOhng@mail.gmail.com>
 <20221017094132.vnanndrwa2yn7qcw@techsingularity.net>
 <CAHbLzkpmbmtOdOsud-VG+wyk18wFAFnan8T55XxxwkHrnhLCmw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHbLzkpmbmtOdOsud-VG+wyk18wFAFnan8T55XxxwkHrnhLCmw@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18, 2022 at 11:01:31AM -0700, Yang Shi wrote:
> > > Yeah, I didn't think of a better way to pass the pages to dm-crypt.
> > >
> > > >
> > > > How about this
> > > >
> > > > 1. Add a callback to __alloc_pages_bulk() that takes a page as a
> > > >    parameter like bulk_add_page() or whatever.
> > > >
> > > > 2. For page_list == NULL && page_array == NULL, the callback is used
> > > >
> > > > 3. Add alloc_pages_bulk_cb() that passes in the name of a callback
> > > >    function
> > > >
> > > > 4. In the dm-crypt case, use the callback to pass the page to bio_add_page
> > > >    for the new page allocated.
> > >
> > > Thank you so much for the suggestion. But I have a hard time
> > > understanding how these work together. Do you mean call bio_add_page()
> > > in the callback? But bio_add_page() needs other parameters. Or I
> > > misunderstood you?
> > >
> >
> > I expected dm-crypt to define the callback. Using bio_add_page
> > directly would not work as the bulk allocator has no idea what to pass
> > bio_add_page. dm-crypt would likely need to create both a callback and an
> > opaque data structure passed as (void *) to track "clone" and "len"
> 
> I see. Yeah, we have to pass the "clone" and "len" to the callback via
> pool_data. It should not be hard since dm-crypt already uses
> crypt_config to maintain a counter for allocated pages, we should just
> need to pass the struct to the callback as a parameter.
> 
> But I'm wondering whether this is worth it or not? Will it make the
> code harder to follow?
> 

A little because a callback is involved but it's not the only place in the
kernel where a callback is used like this and a comment should suffice. It
should be faster than list manipulation if nothing else. Mostly, I'm wary
of adding the first user of the list interface for the bulk allocator that
does not even want a list. If there isn't a user of the list interface
that *requires* it, the support will simply be deleted as dead code.

-- 
Mel Gorman
SUSE Labs

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


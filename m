Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C7F6C6FD1C
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 09:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679565107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AfgTw7xlkQ1UMJoXimVLZh9eqZn3P1GpFgz75g6FLZ8=;
	b=RK0aLMYCm7LYJr7aRli1aUKnMVURZJAfQWCNj5cC9JJ0nUjOZSYjqjh5ZjGZe/e5gGLDoG
	PX/6nCEk319swXExbCeh8ooRs6Eup9q1NatEr+XYgLNrVL6BCOuAIXjfP8boUbRIOOjFkz
	ULF63VO7Mdm9G1OnwB3l3hGUoR809I4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-IKN9vAuEPTqYEykiBCzeyQ-1; Thu, 23 Mar 2023 05:51:43 -0400
X-MC-Unique: IKN9vAuEPTqYEykiBCzeyQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9ACFB3815EF3;
	Thu, 23 Mar 2023 09:51:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3A2440D7;
	Thu, 23 Mar 2023 09:51:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 267091946589;
	Thu, 23 Mar 2023 09:51:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 869D81946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 09:51:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 74F692027041; Thu, 23 Mar 2023 09:51:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D5A32027040
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 09:51:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11CF887B2A1
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 09:51:39 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-7NEZthUjMKODLd5JkNnVYA-1; Thu, 23 Mar 2023 05:51:37 -0400
X-MC-Unique: 7NEZthUjMKODLd5JkNnVYA-1
Received: by mail-qt1-f177.google.com with SMTP id r5so25855607qtp.4
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 02:51:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679565097;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=UVQ7hU8Br7Tu2Xt0SbRBGd3dDM668bx3RDEdIY6km44=;
 b=pnCQ5IvRp6vX7KPCdZG8TERYAuvv0pg1leHaB5fpWyTorOghpXbo/o0WmVS4+iCjhm
 RPcB8UekS3xdF7rqewbutoOfYkLRVyYN4oSgfEU93Uvz6qNuLgSX+v+dl9PDsgPHtnLo
 3pC6saOMVfM3XBj+JI+EnUfeCqhzwbHZCIPQ88wN86tgMdzCMC7D/YfcF2JvLP8gpps9
 aAMCfibdBRMZssiC6MwYxI0CG9qZgp40ikN9C+/s8AS/bwPZg0Cy3x2knhWgThXWwYd1
 331eDF4KkIyRxUCkLQxqqCWwQQLn/sSQ0N8R5KG/N65fjGQ3574eokVi2vM6KbefJT9D
 4PgA==
X-Gm-Message-State: AO0yUKXfO46CHgM84nq1JikpXjUetNE25mQbAacWe1hCuYUZrxXXlSjZ
 KUJVXaGIvAIfbfiNrRPQ3/MVDco=
X-Google-Smtp-Source: AK7set9tR8LMemJ5hgwR6gF5syLw5Hw31f9FphLEj9jHVkTXH9ZdND3KVQ/kL4BZGbbRAwh79OHJmQ==
X-Received: by 2002:ac8:5813:0:b0:3d6:dca:f0df with SMTP id
 g19-20020ac85813000000b003d60dcaf0dfmr11043048qtg.66.1679565096373; 
 Thu, 23 Mar 2023 02:51:36 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 q21-20020a05620a0c9500b007422fa6376bsm12849785qki.77.2023.03.23.02.51.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Mar 2023 02:51:35 -0700 (PDT)
Date: Thu, 23 Mar 2023 05:51:34 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Joe Thornber <thornber@redhat.com>
Message-ID: <ZBwhJmxVVupuou4h@redhat.com>
References: <20230322181845.29848-1-snitzer@kernel.org>
 <20230322181845.29848-6-snitzer@kernel.org>
 <CAJ0trDbFi0U+nJMkqi8Z9WDwWoAUO0qFMRyY5d7qxUU4mwpgzQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ0trDbFi0U+nJMkqi8Z9WDwWoAUO0qFMRyY5d7qxUU4mwpgzQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [dm-6.4 PATCH 5/8] dm bufio: improve concurrent IO
 performance
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
Cc: keescook@chromium.org, heinzm@redhat.com, ejt@redhat.com, nhuck@google.com,
 ebiggers@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 23 2023 at  3:51P -0400,
Joe Thornber <thornber@redhat.com> wrote:

> Mike,
> 
> I'm Nacking this patch here.  You've taken the comment from my latest
> patch, and attached it to something else.  I don't know if you've taken an
> older patch and updated it, or taken the latest patch and downgraded it.

I lean on git to tell me if code is identical.

Since we're now clearly keeping score here. I used git to compare what
I had here (with various small whitespace tweaks and other nits):
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=2023-03-01-thin-concurrency-8

with your -8 code:
https://github.com/jthornber/linux/tree/2023-03-21-thin-concurrency-8

I had to deal with the problem that you didn't use my tree you rebased
so I had to reconcile not losing my handful of fluff.

I leaned on the fact that your -7 and -8 were identical in code:
git diff ejt/2023-02-28-thin-concurrency-7 ejt/2023-03-21-thin-concurrency-8 -- drivers/md/dm-bufio.c

I could've just generated my fluff and folded it into your new clean
-8.  But I went the other way around, instead I picked up your other
incremental changes from -7 and folded them into what I had. No real
reason, that's just how I did it.

> For instance the latest patch uses the name 'struct dm_buffer_cache', but
> it looks like you've renamed to 'struct buffer_cache' and then posted
> another patch in the series that renames back to dm_buffer_cache.

Right, I was cherry-picking your incremantal changes your staged in -7
before your clean patch rollup in your -8. How the struct rename
occurred to the code didn't much matter to me, so long as the change
was made.  But yeah I should've just folded it.  Not a big deal.

> I also see the comment change:
> 
> original "A refcount_t for hold_count does not work." which has changed to
> "NOTE: attempting to use refcount_t instead of atomic_t caused crashes!".
> Talk about over dramatisation (If the hold_count is incorrect we detect and
> BUG).

Yes, but I was aiming to leave breadcrumbs if/when someone might think
to retry using refcount_t to see why it "does not work". I was trying
to save future me or you or someone else some time. By making it
clear: there will be dragons.

But in doing so I unwittingly already unleashed different dragons ;)

> I can't stand by my code if I don't know what's being sent up in my name.
>
> Please use the patchset from this branch:
> https://github.com/jthornber/linux/tree/2023-03-21-thin-concurrency-8

We've resolved this now interactively in chat, but I had to reply on
dm-devel to let others know.  Again, on a code level what I posted to
dm-devel reflects what was staged in 2023-03-21-thin-concurrency-8:

For me this yields my fluff I was referring to above:
git diff ejt/2023-03-21-thin-concurrency-8 dm/dm-6.4 -- drivers/md/dm-bufio.c

Biggest difference being dm_buffer struct member reordering (which I
had discussed with you).

For the benefit of others, I since dropped patch 1 and patch 2
(max_discard_granularity and bio-prison-v1 patch) but pulled them to
the HEAD of this new development branch (that has extra debugging):
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-6.4

I'll go back to bed now, hopefully you'll have this discard issue
fixed in a couple hours when I return (as we discussed). ;)

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


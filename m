Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F15A7C19F21
	for <dm-devel@archiver.kernel.org>; Thu,  4 Aug 2022 20:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659644554;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OzPhSXRH5rbhvnKZWTv4jnGhTYrO5CE2Jq5vQfYEgKo=;
	b=GByWOCLTOpZR1yJaPNYkwf35h8KdTa0AGBlOPUNCqEaNJZn32hiaRSWQZmJUt3wuOSlUcs
	OdBLpHGy/YRLURJAj8JYiL9qInjweebIoKTCcjSuhMmojXysX+qUITd0Mo+qaLkFHwNOzk
	HyiHGimPLpTlmpabDDGvgViihoiaO0U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-C5hbW1bNOPGOEQlNOoJ6og-1; Thu, 04 Aug 2022 16:22:31 -0400
X-MC-Unique: C5hbW1bNOPGOEQlNOoJ6og-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3446A2804002;
	Thu,  4 Aug 2022 20:22:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93E1B1121315;
	Thu,  4 Aug 2022 20:22:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 646891946A62;
	Thu,  4 Aug 2022 20:22:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8006C1946A5F
 for <dm-devel@listman.corp.redhat.com>; Thu,  4 Aug 2022 20:22:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7271940C1288; Thu,  4 Aug 2022 20:22:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E3824010E37
 for <dm-devel@redhat.com>; Thu,  4 Aug 2022 20:22:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53732801585
 for <dm-devel@redhat.com>; Thu,  4 Aug 2022 20:22:26 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-DQkGJFERPl2vBb1avP8XZQ-1; Thu, 04 Aug 2022 16:22:25 -0400
X-MC-Unique: DQkGJFERPl2vBb1avP8XZQ-1
Received: by mail-qk1-f200.google.com with SMTP id
 q20-20020a05620a0d9400b006b6540e8d79so415445qkl.14
 for <dm-devel@redhat.com>; Thu, 04 Aug 2022 13:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=s1I8tAb6W2pw17Tsnep/5BDHiAi73WiVLdCb8RbVhWI=;
 b=EHDvPTMTgfgFWDCxTfIuJZDM/37MV566lMeI6gAVwWyLRhxxGvA0Jaa8mtJikdrQO9
 3FHnCsRL0NHrg5OXxQepDG7xqbKl4l8Z6tpf/PY5Bj+jDfSJvK6zxRbyFFoi8joeZRbK
 YkgI9egUwom/nqDxs1DQAKca5CdsaaMUfhwUkqEi+pDeEoETJd9HvluF6VnfCRUb4LEr
 1xnrpEOhXxoAobfOuryH2T5PJqoa9WeHW/6l9mqoB4kw1U7Sak+qRlUyF3vXstKXguUD
 ahk5rdw0Zj6qUzmoSwMEaac7thVOsHvDrSvIMuAlvWQVVm/rhgerKAXI1aFrEszpqm/3
 Tfcw==
X-Gm-Message-State: ACgBeo3Ah7YHSE9aqBpkCM/FtB5KzhO0WkuOSAEjqh1ytkMO/O3MYFDY
 wSY/F3mib7lgQPCYfEC+d5xaqrvTaHGa8tS7RFdVyOYXVfQoehwNv79j92dToV/2wAXWhdD/PYi
 lUOyrpB7OV5xO8w==
X-Received: by 2002:a05:622a:170c:b0:31e:fd23:fd01 with SMTP id
 h12-20020a05622a170c00b0031efd23fd01mr3002380qtk.40.1659644544641; 
 Thu, 04 Aug 2022 13:22:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7XyVq/X09kN/Lsso8Vg84RzcDmmtjl4wONOpxUl1nCJFdyvy5dsa2yYqmGzCBQxECU6nAq0g==
X-Received: by 2002:a05:622a:170c:b0:31e:fd23:fd01 with SMTP id
 h12-20020a05622a170c00b0031efd23fd01mr3002366qtk.40.1659644544367; 
 Thu, 04 Aug 2022 13:22:24 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 p123-20020a37bf81000000b006af3f3b385csm1235482qkf.98.2022.08.04.13.22.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Aug 2022 13:22:23 -0700 (PDT)
Date: Thu, 4 Aug 2022 16:22:22 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Nathan Huckleberry <nhuck@google.com>
Message-ID: <Yuwqfmj4p6+pWV0i@redhat.com>
References: <YuqffhXctdt9vM0i@redhat.com>
 <20220803182905.3279728-1-nhuck@google.com>
MIME-Version: 1.0
In-Reply-To: <20220803182905.3279728-1-nhuck@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] Fixes 6890e9b8c7d0a1062bbf4f854b6be3723836ad9a
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>,
 Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 03 2022 at  2:29P -0400,
Nathan Huckleberry <nhuck@google.com> wrote:

> The previous patch had a bug when hash verification failed in the
> tasklet.  This happened because the tasklet has already advanced the
> bvec_iter when it falls back to the work-queue implementation.  When the
> work-queue job begins running, it attempts to restart verifiying at
> block i, but the bvec_iter is at block i+1.
> 
> This causes several failures, the most noticeable is that there are not
> enough bytes in the bvec_iter to finish verification.  Since there are
> not enough bytes to finish, the work queue gets stuck in an infinite
> loop in verity_for_io_block.
> 
> To fix this, we can make a local copy of the bvec_iter struct in
> verity_verify_io.  This requires that we restart verification from the
> first block when deferring to a work-queue rather than starting from the
> last block verified in the tasklet.
> 
> This patch also fixes what appears to be a memory leak when FEC is
> enabled.  The call to verity_fec_init_io should only be made if we are
> in a work-queue since a tasklet does not use FEC and is unable to free
> the memory.
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Thanks for the detailed header, helped me appreciate the details of
your incremental fixes. I folded your fixes in to the original commit
that adds the "try_verify_in_tasklet" feature. I also layered on some
verity_verify_io() optimizations in new commits. Lastly, I added the
use of WQ_HIGHPRI if "try_verify_in_tasklet" feature is used.

The end result passes Milan's testsuite with and without --use-tasklets.

I've staged the changes in linux-next, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

There is a chance I'll send another 6.0 pull request to Linus with
these changes tomorrow. We've done quite a bit of work here (_before_
the 6.0 merge window opened) so I do think it'd be best to get these
changes upstream sooner rather than later.

If anyone disagrees with sending these changes upstream now please
speak-up!

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F42C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 18:47:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-ISsXnamWOEm6Q_Bb-l-4Ag-1; Tue, 03 May 2022 14:47:40 -0400
X-MC-Unique: ISsXnamWOEm6Q_Bb-l-4Ag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 882F18E72CF;
	Tue,  3 May 2022 18:47:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 441F940CFD19;
	Tue,  3 May 2022 18:47:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E066E1947049;
	Tue,  3 May 2022 18:47:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1C231947043
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 18:47:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B159315385B5; Tue,  3 May 2022 18:47:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACA76153CE2E
 for <dm-devel@redhat.com>; Tue,  3 May 2022 18:47:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B40394A910
 for <dm-devel@redhat.com>; Tue,  3 May 2022 18:47:35 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-vMmTzB9VPYmaD4hfWsDLbA-1; Tue, 03 May 2022 14:47:33 -0400
X-MC-Unique: vMmTzB9VPYmaD4hfWsDLbA-1
Received: by mail-pg1-f180.google.com with SMTP id k14so14728919pga.0
 for <dm-devel@redhat.com>; Tue, 03 May 2022 11:47:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+o3H2wSew0BRA4vqTAN2Yx+wDwTltnzrE6YOchX4Xao=;
 b=I3qOfttbxZ3DzQBeHUsvlQEoH4KcV0ZBzviDQRVskGA1twumpRNp2gEGiqXmGczM7Q
 oy58S66N126zjeXQxvKNMTMFr6avkQbwDrGltSQH37ZM6dfR/CjH/vJKrk4BxDisnjkq
 +A8V3S5MNxgdR5+BjYLb2vVowRchqAQeFySh0Coq9PP+gdybqgUc9gJP16lOSldH6UuV
 gUEe/71OAtaFsHhSnl4ASfIg1/N/DIMTHf83n3w1jQDJPYiyCpNqD+uvgxUAQDX8ZvT1
 IAXHiIdcZn+qfxLn/WgixyMkXyY2cBcW2Iot3kVfe2B6wUXhk1QKwajTNH3AJzKmKtbS
 nWzw==
X-Gm-Message-State: AOAM533Ewlz7tom8tg1AczB+Y9CR+D7ScYKn5Nz3EVWxHm8RtoO0wGVj
 x6cJD+PSKOCKYPPk8Ze36ji7/bTZjjsVTGY=
X-Google-Smtp-Source: ABdhPJwYXB+4mnODVKNOGfQ4/JnFfiz9n96ZB2gWIV2EhSPXMJ6znu5z3zyH2qA0O9C2o/JyHrUUvA==
X-Received: by 2002:a05:6214:f6f:b0:45a:8bcf:8274 with SMTP id
 iy15-20020a0562140f6f00b0045a8bcf8274mr9082718qvb.14.1651602737583; 
 Tue, 03 May 2022 11:32:17 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 v185-20020a372fc2000000b0069fc13ce252sm6430137qkh.131.2022.05.03.11.32.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 May 2022 11:32:17 -0700 (PDT)
Date: Tue, 3 May 2022 14:32:15 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <YnF1L4opPwLvBTLJ@redhat.com>
References: <alpine.LRH.2.02.2204211407220.761@file01.intranet.prod.int.rdu2.redhat.com>
 <YmeUXC3DZGLPJlWw@kroah.com>
 <alpine.LRH.2.02.2204281155460.5963@file01.intranet.prod.int.rdu2.redhat.com>
 <Ymuj0Y2A6WHOi05c@kroah.com>
MIME-Version: 1.0
In-Reply-To: <Ymuj0Y2A6WHOi05c@kroah.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v5.10] dm: fix mempool NULL pointer race when
 completing IO
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 29 2022 at  4:37P -0400,
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Apr 28, 2022 at 12:22:26PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 26 Apr 2022, Greg Kroah-Hartman wrote:
> > 
> > > On Thu, Apr 21, 2022 at 02:08:30PM -0400, Mikulas Patocka wrote:
> > > > Hi
> > > 
> > > Not really needed in a changelog text :)
> > > 
> > > > This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
> > > > race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
> > > > and dm_wait_for_bios_completion") for the kernel 5.10.
> > > 
> > > Can you just make these 2 different patches?
> > > 
> > > > 
> > > > The bugs fixed by these patches can cause random crashing when reloading
> > > > dm table, so it is eligible for stable backport.
> > > > 
> > > > This patch is different from the upstream patches because the code
> > > > diverged significantly.
> > > > 
> > > 
> > > This change is _VERY_ different.  I would need acks from the maintainers
> > > of this code before I could accept this, along with a much more detailed
> > > description of why the original commits will not work here as well.
> > > 
> > > Same for the other backports.
> > 
> > Regarding backporting of 9f6dc633:
> > 
> > My reasoning was that introducing "md->pending_io" in the backported 
> > stable kernels is useless - it will just degrade performance by consuming 
> > one more cache line per I/O without providing any gain.
> > 
> > In the upstream kernels, Mike needs that "md->pending_io" variable for 
> > other reasons (the I/O accounting was reworked there in order to avoid 
> > some spikes with dm-crypt), but there is no need for it in the stable 
> > kernels.
> > 
> > In order to fix that race condition, all we need to do is to make sure 
> > that dm_stats_account_io is called before bio_end_io_acct - and the patch 
> > does that - it swaps them.
> > 
> > Do you still insist that this useless percpu variable must be added to the 
> > stable kernels? If you do, I can make it, but I think it's better to just 
> > swap those two functions.
> 
> I am no insisting on anything, I want the dm maintainers to agree that
> this change is acceptable to take as it is not what is in Linus's tree.
> Every time we take a "not upstream" commit, the odds are 90% that it
> ends up being wrong, so I need extra review and assurances that it is
> acceptable before I can apply it.

FYI, I've reviewed Mikulas's latest stable backport patches (not yet
posted) and provided by Reviewed-by.  So once you see them you can
trust I've looked at the changes and am fine with you picking them up.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


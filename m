Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDFEC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 05:52:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-QLaG_a1ZPaOXrxmBU-PNOw-1; Thu, 31 Mar 2022 01:52:33 -0400
X-MC-Unique: QLaG_a1ZPaOXrxmBU-PNOw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75C24805A30;
	Thu, 31 Mar 2022 05:52:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64DA4401E71;
	Thu, 31 Mar 2022 05:52:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 29BAE1947BBB;
	Thu, 31 Mar 2022 05:52:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EA29F19451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 05:52:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D06372026D6B; Thu, 31 Mar 2022 05:52:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CBE5A2027EB5
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 05:52:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 070DA3C01C11
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 05:52:26 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-1FaytRCKN9aFwOE9RFx-fw-1; Thu, 31 Mar 2022 01:52:18 -0400
X-MC-Unique: 1FaytRCKN9aFwOE9RFx-fw-1
Received: by mail-pl1-f172.google.com with SMTP id m18so17576271plx.3
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 22:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1zTaM71SVPE6S3OdGd9sJCQOVirmJSKeBEVVvpHLP9M=;
 b=nGvnCIL7aHWkZxJbdFTP/bx1uIN6K2FwUp+hxapcnpjHSlSUFKPFwaoc3Ni29l6wVr
 x18sCMrOzkG5oXgNJV7wPvxBaqDD1FUAytYyNFMRyp+G8cSJbqLyI7fvpuER9k3DsQxB
 6ByeL6ggMSMkI0E3KZOQTl2imEGFdiYaOPB46Q3zWBp28Ybbj37g2qXXm3Tmha0rzICn
 AXFpx5vwDJUBZpatYtO6BqQtb6MzjBH6DWXGGWE9JkaAmgwntl++9daUhqLaKSnTRHbe
 SyY63E01qHzmX9oCCm37cQlElh/6Rhp4JDieIK7VmjgAMXFW44WViEzGiwn2hHjRtjik
 Xojw==
X-Gm-Message-State: AOAM533affUNGFNJHUm6m4AnFd23dm50VdASfXRrG4l8isndTeo0MnsW
 uMR1jLWUg5ucZIi9dW/Q8ts=
X-Google-Smtp-Source: ABdhPJwOVwiZOY/QFsDtfI9b4cYAc4VtjeuKnSwxfInHXclMB0xLovIV+ITp1QjLG9anTmxDT1jafQ==
X-Received: by 2002:a17:903:1249:b0:154:c472:de76 with SMTP id
 u9-20020a170903124900b00154c472de76mr38213570plh.81.1648705936249; 
 Wed, 30 Mar 2022 22:52:16 -0700 (PDT)
Received: from fedora (136-24-99-118.cab.webpass.net. [136.24.99.118])
 by smtp.gmail.com with ESMTPSA id
 pc13-20020a17090b3b8d00b001c775679f58sm8649714pjb.37.2022.03.30.22.52.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 22:52:15 -0700 (PDT)
Date: Wed, 30 Mar 2022 22:52:13 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YkVBjUy9GeSMbh5Q@fedora>
References: <YkSK6mU1fja2OykG@redhat.com> <YkRM7Iyp8m6A1BCl@fedora>
 <YkUwmyrIqnRGIOHm@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YkUwmyrIqnRGIOHm@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] can we reduce bio_set_dev overhead due to
 bio_associate_blkg?
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
Cc: tj@kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

On Wed, Mar 30, 2022 at 09:39:55PM -0700, Christoph Hellwig wrote:
> On Wed, Mar 30, 2022 at 08:28:28AM -0400, Dennis Zhou wrote:
> > I think cloning is a special case that I might have gotten wrong. If
> > there is a bio_set_dev() call after each clone(), then the
> > bio_clone_blkg_association() is excess work. We'd need to audit how
> > bio_alloc_clone() is being used to be safe. Alternatively, we could opt
> > for a bio_alloc_clone_noblkg(), but that's a little bit uglier.
> 
> As of Linux 5.18, the cloning interfaces have changed and take
> a block devie that the clone is intended to be used for, and bio_set_dev
> is mostly (there is a few more sports to be cleaned up in
> dm/md/bcache/btrfs) only used for remapping to a new device.
> 

I took a quick look. It seems with the new interface,
bio_clone_blkg_association() is unnecessary given the correct
association should be derived from the bio_alloc*() calls with the
passed in bdev. Also, blkcg_bio_issue_init() in clone seems wrong.

Maybe the right thing to do here for md-linear and btrfs (what I've
looked at) is to delay cloning until the map occurs and the right device
is already in hand?

> That being said I've eyed the code in bio_associate_blkg a bit and
> I've been wondering about some of how it is implemented as well.
> 

I'm sure stuff has evolved since I've last been involved, but here is a
brief explanation of the initial story. I suspect most of it holds true.
Apologies if this isn't helpful.

For others, a blkcg is a block cgroup. A blkcg_gq, blkg for short, is
the marrying of a blkcg and a request_queue. It takes a reference on
both so IO associated with the cgroup is tracked to the appropriate
cgroup and prevents the request_queue from going away. Punted IOs go
here and writeback is managed here as well. On the hot path, this is the
tagging that blk-rq-qos stuff might depend on.

The lookup itself is handled by blkg_lookup() which is a radix tree
lookup of the request_queue. There is also a last hint which helps.
blkg's are percpu-refcounted.

In terms of lifetimes and pinning. child_blkcg pins parent_blkcgs in a
tree hierarchy up to the root_blkcg. blkgs pin the blkcg it's associated
to, the request_queue, and the blkg_parent (parent_blkcg and
request_queue). They die in hierarchical order, alive until all children
have passed.

If there's anything else I can try to help answer please let me know.

> Is recursive throttling really a thing?  i.e. we can have cgroup
> policies on the upper (e.g. dm) device and then again on the lower
> (e.g. nvme device)?  I think the code currently supports that, and
> if we want to keep that I don't really see much of a way to avoid
> the lookup, but maybe we cn make it faster.

I'm not sure. I've primarily dealt with physical devices. However, I'm
sure there are more complex setups that use it. Is it a good idea is
probably debatable.

Backing up though, I feel like the abstraction naturally alludes to this
multiple association because you don't necessarily know when you hit
physical devices until you finally submit through.

Thanks,
Dennis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


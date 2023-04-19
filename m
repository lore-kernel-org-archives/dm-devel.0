Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF87C6FD18
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 23:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681946494;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SIAuKr9KQQQc2LXNVu5UpOmNFKGWG3sXqIvZckCAbxU=;
	b=a0rmRemHQu+lLyj8zeyRzK66+JyCx14GCsonjW8OCDTeFUEeqm6MRmVW2dKHP73UyZnKZ2
	aE4D564GW8BWjyo8p1UC8ZexkF1IxW/KpP+OmMwTIZFvGGT4ovocdZcKGbYnrinFU06BrR
	wuNo6aix3c+fnhov7hd+XACnnz+n3PI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-WUReHGdcPMyusEIqCbeCEg-1; Wed, 19 Apr 2023 19:21:30 -0400
X-MC-Unique: WUReHGdcPMyusEIqCbeCEg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97E94811E7C;
	Wed, 19 Apr 2023 23:21:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 792392166B33;
	Wed, 19 Apr 2023 23:21:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 33FFF19465B9;
	Wed, 19 Apr 2023 23:21:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 74C6019465B5
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 23:21:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 46E231410F1C; Wed, 19 Apr 2023 23:21:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EE9E140EBF4
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 23:21:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 241BD85A588
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 23:21:25 +0000 (UTC)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-XzN1GEdbPUS0gM9eEkZNCQ-1; Wed, 19 Apr 2023 19:21:23 -0400
X-MC-Unique: XzN1GEdbPUS0gM9eEkZNCQ-1
Received: by mail-pg1-f175.google.com with SMTP id
 41be03b00d2f7-517ab9a4a13so304492a12.1
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 16:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681946482; x=1684538482;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=O4EzLlnke++OBfC+QU/8848E+9V2OKTR6syW6axwlV8=;
 b=HCW8dEfwzsVvB260yrmABwXNzt4Iy9cDRo1AMhFNYgvj9XOnFL2j9u+49ypbkO46Bi
 K37FhRuqh37oId3134auPx2e4jhN90/a4rw98jBfIxmkQbU1UN8hSv9U5D0cgc7UgTfb
 0WX2dLOUtHVtqyjeXln20pntmPEgiQJbpHojdyiNDJaRYyoUB1L5EH+V+nZLNAUYYSrN
 F1XrZOU42xSUO1d3MWK8C7XqkS9m5i/010xShFyW34QswRFZCVzds7hQb8q9aLrHA3GS
 DCJ+wVyoN9RsMX2TZhEUWo9q7wiQ5gJHEaYUetod5tRr007PzssZtnrH1vch8/YgTmOw
 DMqw==
X-Gm-Message-State: AAQBX9dXWaVDm7vKCnZKQpow52fcWxye1eQmunBwk9SWyMB3l4gwtfI0
 5WJA0c9QmqpxhN/gg+V7XTPWyg==
X-Google-Smtp-Source: AKy350Z4u0R970I4rdGzZzRQmNJeDe7b2z6B1qSAUlPIrkwDXPChvEc+qQO8pUmxrKDtn7iIylQMpQ==
X-Received: by 2002:a17:902:b089:b0:19d:611:2815 with SMTP id
 p9-20020a170902b08900b0019d06112815mr6659257plr.42.1681946481873; 
 Wed, 19 Apr 2023 16:21:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au.
 [49.180.41.174]) by smtp.gmail.com with ESMTPSA id
 ja13-20020a170902efcd00b0019682e27995sm6226725plb.223.2023.04.19.16.21.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Apr 2023 16:21:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
 (envelope-from <david@fromorbit.com>)
 id 1ppH70-005RJM-QK; Thu, 20 Apr 2023 09:21:18 +1000
Date: Thu, 20 Apr 2023 09:21:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <20230419232118.GL447837@dread.disaster.area>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-2-sarthakkukreti@chromium.org>
 <20230419153611.GE360885@frogsfrogsfrogs>
 <ZEAUHnWqt9cIiJRb@redhat.com>
 <20230419172602.GE360881@frogsfrogsfrogs>
MIME-Version: 1.0
In-Reply-To: <20230419172602.GE360881@frogsfrogsfrogs>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 1/4] block: Introduce provisioning
 primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 19, 2023 at 10:26:02AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 19, 2023 at 12:17:34PM -0400, Mike Snitzer wrote:
> > (And obviously needs fixing independent of this patchset)
> > 
> > Shouldn't mkfs first check that the underlying storage supports
> > REQ_OP_PROVISION by verifying
> > /sys/block/<dev>/queue/provision_max_bytes exists and is not 0?
> > (Just saying, we need to add new features more defensively.. you just
> > made the case based on this scenario's implications alone)
> 
> Not for fallocate -- for regular files, there's no way to check if the
> filesystem actually supports the operation requested other than to try
> it and see if it succeeds.  We probably should've defined a DRY_RUN flag
> for that purpose back when it was introduced.

That ignores the fact that fallocate() was never intended to
guarantee it will work in all contexts - it's an advisory interface
at it's most basic level. If the call succeeds, then great, it does
what is says on the box, but if it fails then it should have no
visible effect on user data at all and the application still needs
to perform whatever modification it needed done in some other way.

IOWs, calling it one a block device without first checking if the
block device supports that fallocate operation is exactly how it is
supposed to be used. If the kernel can't handle this gracefully
without corrupting data, then that's a kernel bug and not an
application problem.

> For fallocate calls to block devices, yes, the program can check the
> queue limits in sysfs if fstat says the supplied path is a block device,
> but I don't know that most programs are that thorough.  The fallocate(1)
> CLI program does not check.

Right. fallocate() was intended to just do the right thing without
the application having to jump thrown an unknown number of hoops to
determine if fallocate() can be used or not in the context it is
executing in.  The kernel implementation is supposed to abstract all that
context-dependent behaviour away from the application; all the
application has to do is implement the fallocate() fast path and a
single generic "do the right thing the slow way" fallback when the
fallocate() method it called is not supported...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


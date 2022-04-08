Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A521EC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  8 Apr 2022 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649432587;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=40+j8uuxPRj3aEmMaj4vERynzfromKV/1/SEdvpFiWk=;
	b=OIQnKZFHS/wbJeSyMPCGtzqOhKlbqLJ6/NyP0HY2CqlitWOngcAwnPyFZSQX2kC1QYDe1z
	GONy8tJTMniSa0rsbaJF69oAYKdL6Wjk2hWm5lrVYdcOLuHhxpYbkTMWJH717fhNfdp9Lg
	sDcxn7pL5MDgHeFQYaCAdp2EuAsE3jw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-JzBr0NLwNAODfa726UUt2A-1; Fri, 08 Apr 2022 11:43:04 -0400
X-MC-Unique: JzBr0NLwNAODfa726UUt2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 815488061CE;
	Fri,  8 Apr 2022 15:42:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA941C2811F;
	Fri,  8 Apr 2022 15:42:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 72CE31940348;
	Fri,  8 Apr 2022 15:42:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E2901940347
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Apr 2022 15:42:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58588C2811F; Fri,  8 Apr 2022 15:42:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 54747C15D58
 for <dm-devel@redhat.com>; Fri,  8 Apr 2022 15:42:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A1A03800A00
 for <dm-devel@redhat.com>; Fri,  8 Apr 2022 15:42:55 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-EKv3bspINECMsNeFJbQTEA-1; Fri, 08 Apr 2022 11:42:54 -0400
X-MC-Unique: EKv3bspINECMsNeFJbQTEA-1
Received: by mail-qv1-f71.google.com with SMTP id
 b9-20020a0cfe69000000b00443cff31dfaso9703028qvv.5
 for <dm-devel@redhat.com>; Fri, 08 Apr 2022 08:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uh9C/0cIrjIkPvPWnpHllBVIfwXhKDgyixfW2DYR0Ew=;
 b=GJfs4N6ycJQXbcG5VNBGDHJgxAJjXEH3ZIQeBT9bV8lEYumZqhpGLtWgfwEPam7ubB
 Q14MuA6aSk4C7Fj3DjE5NIc+PhPVJNTLF/8/cu4XX/bNoOtiO110Fu5COO8yvc2zIIlN
 8NBCr6UGnyqwKl8CaqvsDGtr782OG+96UQbooeTjF5/wOWBuf1vX9T/6ikwnGJ5Tzith
 h3YJmqt4FZcS3GaIRqTrJDeyf/sHgO+rAJ0MJ7jj5TdkA/v1QHf3IpraZWg1KSmHm2f0
 +MltQMdT1pd1GM48xOlYZMzOefnsWZtLPiTo3in+ASEGpnsxl4hJYBg4BQX7KyASIVdJ
 GZug==
X-Gm-Message-State: AOAM530HlHqukBqSpHDAQDGV1ZDJI/R2fDM4uqeiA4cs4FMI8j8zU4N6
 Rm/VsHB1tA/an55Ow9+2vcOy5yja2v31uUUK9BFBfz4anS54OooRQyADNTRXhopj91ug3usyRDG
 4V8mX+/NPZ1PRcQ==
X-Received: by 2002:ac8:5b86:0:b0:2e2:72c:9e06 with SMTP id
 a6-20020ac85b86000000b002e2072c9e06mr16437922qta.113.1649432573614; 
 Fri, 08 Apr 2022 08:42:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUfLlWE2Smd+oFO5ffih62dgSw8HBW5GxPWKP/2qDKZQAiBqeEt3sbfXtDD+mcuNQwhgeoNw==
X-Received: by 2002:ac8:5b86:0:b0:2e2:72c:9e06 with SMTP id
 a6-20020ac85b86000000b002e2072c9e06mr16437906qta.113.1649432573399; 
 Fri, 08 Apr 2022 08:42:53 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 a21-20020a376615000000b0069a110a481dsm2597335qkc.41.2022.04.08.08.42.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 08 Apr 2022 08:42:52 -0700 (PDT)
Date: Fri, 8 Apr 2022 11:42:51 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YlBX+ytxxeSj2neQ@redhat.com>
References: <YkSK6mU1fja2OykG@redhat.com> <YkRM7Iyp8m6A1BCl@fedora>
 <YkUwmyrIqnRGIOHm@infradead.org> <YkVBjUy9GeSMbh5Q@fedora>
 <YkVxLN9p0t6DI5ie@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YkVxLN9p0t6DI5ie@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Cc: axboe@kernel.dk, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
 Dennis Zhou <dennis@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 31 2022 at  5:15P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Mar 30, 2022 at 10:52:13PM -0700, Dennis Zhou wrote:
> > I took a quick look. It seems with the new interface,
> > bio_clone_blkg_association() is unnecessary given the correct
> > association should be derived from the bio_alloc*() calls with the
> > passed in bdev. Also, blkcg_bio_issue_init() in clone seems wrong.
> 
> Yes, I think you are right.
> 
> > Maybe the right thing to do here for md-linear and btrfs (what I've
> > looked at) is to delay cloning until the map occurs and the right device
> > is already in hand?
> 
> That would in general be the preferred option where possible.

Delaying cloning until remap is a problem for DM given the target_type
->map interface for all DM targets assumes the passed bio is already a
clone that needs to be remapped accordingly.

I think we can achieve the goal of efficient cloning/remapping for
both usecases simply by splitting out the bio_set_dev() and leaving it
to the caller to pick which interface to use (e.g. clone vs
clone_and_remap).

Christoph is this something you're open to doing as continuation of
your bio alloc/clone related audit/changes?  Or would you prefer
someone else deal with it?  I could take a closer look next week if
needed.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=xRQ1=F3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBFDC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 17:01:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 54D542229C
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 17:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54D542229C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-wfElJHVAMICTM7cPhBkXGA-1; Wed, 23 Dec 2020 12:01:21 -0500
X-MC-Unique: wfElJHVAMICTM7cPhBkXGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3750108E1A1;
	Wed, 23 Dec 2020 17:01:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C0E35D9C6;
	Wed, 23 Dec 2020 17:01:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 18037180954D;
	Wed, 23 Dec 2020 17:01:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNGxnVj009834 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 11:59:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CB348A7FA3; Wed, 23 Dec 2020 16:59:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C5A2694637
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 16:59:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D878811E76
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 16:59:47 +0000 (UTC)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
	[209.85.216.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-399-NAD6HZMoN6CSk4xA9uiLpA-1; Wed, 23 Dec 2020 11:59:43 -0500
X-MC-Unique: NAD6HZMoN6CSk4xA9uiLpA-1
Received: by mail-pj1-f43.google.com with SMTP id iq13so74349pjb.3;
	Wed, 23 Dec 2020 08:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=C5J0im/g/lziWkOXhLJMkLHB39Y3IwOJRzVpXSFIMwo=;
	b=l2oOxyEriND2xhJxUkklbEAWGNl0Xp2UGv1hRteohxffj5xYr/cz7tb5zg1L4mBA35
	6BSE0Jr1+/s/OTLmRhJBda7tC5hH9ROH6MA5g3bC4mALkAvfKolyiirZiV1MV86TcWaM
	1dxqX9cxTDw7s9dazSFzD89guR7q3+r5oSxk2wF3BlrC6Gq4f3AYlfjbCvVG6IS44HhI
	2f+x1pvXfyg1izbUDRQdbe20g/Fr1UDOOwrMEWkKnhC3tqZvjLe4IXvQC7JYG6M8uw0P
	LIEsX2SNdSNx1uUoKS8qgCJPIn81gWEjtUSbrJVuV2ZEtcG3H1oyx3W6/g5HKg3SrC+P
	8wuw==
X-Gm-Message-State: AOAM5332llC1r6d6w/oXGZm4MoVWCoMjczcWybeB0vGD3TyOBq0dD+DN
	Qdwn0f0JvpjD3lGq0TVnHzc=
X-Google-Smtp-Source: ABdhPJzqv31c8q2ac9TtdhmNSe0N38boCxuCdDiKIhDRPStVefyp5/WAIeJm9xrsMsbN4NqKKvm8qw==
X-Received: by 2002:a17:902:523:b029:dc:1aa4:28e7 with SMTP id
	32-20020a1709020523b02900dc1aa428e7mr26256507plf.4.1608742781850;
	Wed, 23 Dec 2020 08:59:41 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	b10sm24081106pgh.15.2020.12.23.08.59.39
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 23 Dec 2020 08:59:40 -0800 (PST)
To: Christoph Hellwig <hch@infradead.org>, Palmer Dabbelt <palmer@dabbelt.com>
References: <20201222143616.GB12885@redhat.com>
	<mhng-26d96d8e-77aa-415b-a8ee-518a0e91b6ef@palmerdabbelt-glaptop>
	<20201223074850.GA15369@infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <8f09b196-0977-3b81-2bfe-4a97b1e0e3aa@acm.org>
Date: Wed, 23 Dec 2020 08:59:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201223074850.GA15369@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, linux-doc@vger.kernel.org, shuah@kernel.org,
	corbet@lwn.net, linux-kernel@vger.kernel.org,
	josef@toxicpanda.com, linux-raid@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com,
	michael.christie@oracle.com, linux-kselftest@vger.kernel.org,
	kernel-team@android.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
 BIOs to userspace
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/22/20 11:48 PM, Christoph Hellwig wrote:
> FYI, a few years ago I spent some time helping a customer to prepare
> their block device in userspace using fuse code for upstreaming, but
> at some point they abandoned the project.  But if for some reason we
> don't want to use nbd I think a driver using the fuse infrastructure
> would be the next logical choice.

Hi Christoph,

Thanks for having shared this information. Since I'm not familiar with the
FUSE code: does this mean translating block device accesses into FUSE_READ
and FUSE_WRITE messages? Does the FUSE kernel code only support exchanging
such messages between kernel and user space via the read() and write()
system calls? I'm asking this since there is already an interface in the
Linux kernel for implementing block devices in user space that uses another
approach, namely a ring buffer for messages and data that is shared between
kernel and user space (documented in Documentation/target/tcmu-design.rst).
Is one system call per read and per write operation fast enough for all
block-device-in-user-space implementations?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


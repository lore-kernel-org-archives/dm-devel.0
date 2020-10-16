Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EE9C433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:21:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB2F720848
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:21:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB2F720848
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-70gSclp7OiqreVmHO9F3gQ-1; Fri, 16 Oct 2020 06:20:57 -0400
X-MC-Unique: 70gSclp7OiqreVmHO9F3gQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB5F7803F78;
	Fri, 16 Oct 2020 10:20:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE0F65D9DD;
	Fri, 16 Oct 2020 10:20:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A634C44A65;
	Fri, 16 Oct 2020 10:20:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09G8dY9f004613 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 04:39:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F60E201155A; Fri, 16 Oct 2020 08:39:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A75B201154F
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 08:39:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46DFE102F1E1
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 08:39:32 +0000 (UTC)
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com
	[209.85.216.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-432-__AvAC63MiOiP_xGLm9u0A-1; Fri, 16 Oct 2020 04:39:29 -0400
X-MC-Unique: __AvAC63MiOiP_xGLm9u0A-1
Received: by mail-pj1-f66.google.com with SMTP id p21so999484pju.0
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 01:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=oOQoOAZUDHpcUncJgxnxM2Jw3xEiUcKHa7EZVIA2/KY=;
	b=oo0bOboxhlBei+Q2UOgymIpjD8fGp7aMULC/AG2Lc9cZHS/01dCAaJTb/G/KH2iFCk
	5S2pUHNu/aQ5yQNQVRT7bPCFcCoR+9fkNPjbNN4YGbfnCmkc9KDbiclLoMQllthKUsqu
	xy5jbuh/QF5YeQ+UkaFxVhcmJUPnXVz4pFglTurFa6ISIxqwe1ZBQwUWxB/QSnCVfVAF
	uceHl3R008mlPAZQsfLYoWjDSfSZ2bHbrttVzE8fv+FHWAxhPYjTOcJoPX35lDkx1Y6z
	W+RwbHXk6frgUCLxsSH/dHbWafMHzCBQR7Shqkue/x3qZjnNxnFF8wwMdKt2BsVr6TCH
	Pj/w==
X-Gm-Message-State: AOAM532/pq1tUeg7UWoWEskKnZAsBvgDGkIjwKUCJzqL0IXnSa1ASvNy
	Nw0GPP/+538PHC620MJWJUWF5g==
X-Google-Smtp-Source: ABdhPJzCXwVXYAwp16Dlkk8/x6p+3Cy3jEcFR6m+PNEsA7BzP+RsUV77M3ev3md1fXDOhCjEfftfrA==
X-Received: by 2002:a17:902:684b:b029:d5:a3a0:3b47 with SMTP id
	f11-20020a170902684bb02900d5a3a03b47mr2976376pln.76.1602837568269;
	Fri, 16 Oct 2020 01:39:28 -0700 (PDT)
Received: from google.com (154.137.233.35.bc.googleusercontent.com.
	[35.233.137.154]) by smtp.gmail.com with ESMTPSA id
	js21sm2038954pjb.14.2020.10.16.01.39.27
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 16 Oct 2020 01:39:27 -0700 (PDT)
Date: Fri, 16 Oct 2020 08:39:23 +0000
From: Satya Tangirala <satyat@google.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20201016083923.GA134672@google.com>
References: <20201015214632.41951-1-satyat@google.com>
	<20201015214632.41951-3-satyat@google.com>
	<20201016071941.GA14885@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20201016071941.GA14885@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 16 Oct 2020 06:18:45 -0400
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Eric Biggers <ebiggers@google.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/4] block: add private field to struct
	keyslot_manager
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 08:19:41AM +0100, Christoph Hellwig wrote:
> On Thu, Oct 15, 2020 at 09:46:30PM +0000, Satya Tangirala wrote:
> > Add a (void *) pointer to struct keyslot_manager that the owner of the
> > struct can use for any purpose it wants.
> > 
> > Right now, the struct keyslot_manager is expected to be embedded directly
> > into other structs (and the owner of the keyslot_manager would use
> > container_of() to access any other data the owner needs). However, this
> > might take up more space than is acceptable, and it would be better to be
> > able to add only a pointer to a struct keyslot_manager into other structs
> > rather than embed the entire struct directly. But container_of() can't be
> > used when only the pointer to the keyslot_manager is embded. The primary
> > motivation of this patch is to get around that issue.
> 
> No, please don't bloat the structure.  If some weird caller doesn't
> like the embedding it can create a container structure with the
> blk_keyslot_manager structure and a backpointer.
Ah, ok. Thanks!

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=Iac5=NL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 886C0C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 23:51:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DBCB61186
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 23:51:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1DBCB61186
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-7XLelO_dO4q6n5v7bbiLxQ-1; Fri, 20 Aug 2021 19:51:44 -0400
X-MC-Unique: 7XLelO_dO4q6n5v7bbiLxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 240DA593A8;
	Fri, 20 Aug 2021 23:51:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C368C5C3E0;
	Fri, 20 Aug 2021 23:51:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 965D9181A0F7;
	Fri, 20 Aug 2021 23:51:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KNkjnm002748 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 19:46:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DD92320B4A58; Fri, 20 Aug 2021 23:46:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7E4720B4A53
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 23:46:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BC798001EA
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 23:46:42 +0000 (UTC)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
	[209.85.215.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-56-B-15kPZqOJePqcL2emAWUg-1; Fri, 20 Aug 2021 19:46:40 -0400
X-MC-Unique: B-15kPZqOJePqcL2emAWUg-1
Received: by mail-pg1-f175.google.com with SMTP id w8so10753365pgf.5
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 16:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=eHMEwcWn5S7G+chbvcpQTCNCdRCcbE/CWjRPjJXaV5I=;
	b=dsELatKUhIXmyiU49vuNWmOVzesL1GCxE/MntAL4+E798q3tWS2Tca1KMD82Oo2AQx
	9WVMk8PlmRcTes8gsgDcrKnDWuX7Wj83VT7T+yZcgyHl5atXylLf0Kc130AzYX45VTPl
	dJqHivnleLrpUKQn9c3xRf57+1bUL8tOagwU/UdyklmCBu30GbO9cWWVL6QVf2cKzQ1G
	Dj3jpdi1INpwD9Qv0YE1xZzkm0zNi9TYfrcawRsgYJSqASGUUIy5l8eaj4UiRNU1V83A
	emhZ4xnK3AvzM8A8o9GU6HaM0VTPw7TdrGP7t6Jq2EXw9GJRPc0I23D2YAlLCPPSQ1jH
	2Ewg==
X-Gm-Message-State: AOAM532SWZJUs82Q8BF8CUvSuE/7lksmhDWTcXH09X2Gz64Bm7I14BU9
	pikJP53TNsaNqjXF82aQSWE10lyJ6aQ+XteJ/cesAA==
X-Google-Smtp-Source: ABdhPJzS5HGT6xJgqFrmEph3uz/ZG7OFdXOcKr3T36oL70Xxr6i57XBJUHqsj1rzOh9dfprsZA/boIS7GPxjc7UyUjw=
X-Received: by 2002:a62:3342:0:b029:3b7:6395:a93 with SMTP id
	z63-20020a6233420000b02903b763950a93mr21855818pfz.71.1629503199185;
	Fri, 20 Aug 2021 16:46:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-8-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-8-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 16:46:27 -0700
Message-ID: <CAPcyv4ic+LDagR8uF18tO3cCb6t=YTZNkAOK=vnsnERqY6Ze_g@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 7/9] dm: Introduce ->rmap() to find
	bdev offset
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Pmem device could be a target of mapped device.  In order to find out
> the global location on a mapped device, we introduce this to translate
> offset from target device to mapped device.
>
> Currently, we implement it on linear target, which is easy to do the
> translation.  Other targets will be supported in the future.  However,
> some targets may not support it because of the non-linear mapping.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  block/genhd.c                 | 56 +++++++++++++++++++++++++++++++++++
>  drivers/md/dm-linear.c        | 20 +++++++++++++
>  include/linux/device-mapper.h |  5 ++++
>  include/linux/genhd.h         |  1 +
>  4 files changed, 82 insertions(+)

This might be where dax-device support needs to part ways with the block layer.

As Christoph has mentioned before the long term goal for dax-devices
(direct mapped byte-addressable media) is to have filesystems mount on
them directly and abandon block-layer entanglements. This patch goes
the opposite direct and adds more block layer infrastructure to
support a dax-device need. Now, I'm not opposed to this moving
forward, but I'm not sure block and DM maintainers will be excited
about this additional maintenance burden.

At the same time a lot of effort has been poured into dax-reflink and
I want that support to move forward. So, my proposal while we figure
out what to do about device-mapper rmap is to have
fs_dax_register_holder() fail on device-mapper dax-devices until we
get wider agreement amongst all involved that this is an additional
burden worth carrying. In the meantime XFS on PMEM will see
fs_dax_register_holder() succeed and DAX reflink support can be gated
on whether the dax-device allowed the notify failure handler to be
registered.

Now, there may be room to allow reflink on device-mapper-dax for
CONFIG_MEMORY_FAILURE=n builds, but that would collide with future
work to use notify_failure for more than memory_failure, but also
NVDIMM_REVALIDATE_POISON, and surprise memory-device-remove events.

The code in this patch looks ok to me, just not the direction the
dax-device layer was looking to go. It might be time to revive the
discussions around support for concatenation and striping in the pmem
driver itself, especially as the CXL label specification is already
adding support for physically discontiguous namespaces.

At a minimum if the patch set is organized to support XFS-reflink on
PMEM-DAX and later XFS-reflink on DM-DAX some progress can be made
without waiting for the whole set to be accepted.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


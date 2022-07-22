Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24ECC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 19:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658517790;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Yagbyfu7Li9yejU76VbU05nrAiaXllpZjUX3OPWGgyA=;
	b=SVtoruD1ezis3n4jqhq/ELNVX6IYDbNJMIQBbfMmG/7pCMjbGJ8Ag4Ajq4S/isueyk8cbP
	B3M4mJDZL2gUleh/nYUBSiLs92aySd+YKB01IZudcGGfuWQHviFmIX5nmdRdhz+m597qzZ
	ebKv5JN4j7d2JelAkMhrkEWI04iRHF8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-HJTcrwGhPYStLrFvJpEDLA-1; Fri, 22 Jul 2022 15:23:07 -0400
X-MC-Unique: HJTcrwGhPYStLrFvJpEDLA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D614618A64EA;
	Fri, 22 Jul 2022 19:23:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1601403D0CA;
	Fri, 22 Jul 2022 19:23:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BA291947053;
	Fri, 22 Jul 2022 19:23:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B88B194704D
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 19:23:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57D632026985; Fri, 22 Jul 2022 19:23:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 542ED2026D64
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 19:23:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 394308037B5
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 19:23:01 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-TiKXAXc7MZCvPhk6o7xAcQ-1; Fri, 22 Jul 2022 15:22:52 -0400
X-MC-Unique: TiKXAXc7MZCvPhk6o7xAcQ-1
Received: by mail-qv1-f69.google.com with SMTP id
 l6-20020a0ce846000000b00473fbfc0e87so3564527qvo.19
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 12:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wsh9gHnFD7MLxVkBk6yNiB+SM7yQbuZrHrswiiBqrkU=;
 b=NS0Vb6h95j9NbgW5VKcfCiA/C4f5v/SFlrb2uJTLikGtxFElW0aX9G0bAkKfK/iRPJ
 Z420w39gV3ZO/tbTtALGu1PeKJo+Le5Yt+xn+dQKOb/7iFMgaJ7c6HX0tO5Rbg2EdfH8
 pCcvZWU+BgYTpFT6vBRx7lrTYvXFJlnDZTz6FFYgHlk+A94LmJVDNk6MdFVq1uGAxxoF
 mrEFVGXI9aKmAiArcxukSQJ0DEQZauuC0Mvfz9U4TIMCK+Y7s2mFqBXoKpfQzoGf8YK/
 k1kwbh43p8AG7FAt5QOzuVbed3fPO1KKrs4AYxUXRAORP7E32R309qZDbDvxdhVk9c4A
 qAPA==
X-Gm-Message-State: AJIora/nEvGTBamf9Sz2zcykaX0OPULTaI8J4CkkFVlmd9SfiUdSPSUj
 2mpKihQa0fSlBcPLqig89JX2n9rqO5l6071pySG1Z6dvxxaNEk/mZcP/HXqUrURhWmVsS8FX8jk
 H/ow0DZAF/zM5Zw==
X-Received: by 2002:ac8:7e91:0:b0:31f:869:1720 with SMTP id
 w17-20020ac87e91000000b0031f08691720mr1472806qtj.37.1658517771788; 
 Fri, 22 Jul 2022 12:22:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tPmEve1MzE7ZG3fM6etiP0EO7G1aZ+L4ocn/EQD8L8dTmedato1ewcXwMPGgkDM6Pkqct61g==
X-Received: by 2002:ac8:7e91:0:b0:31f:869:1720 with SMTP id
 w17-20020ac87e91000000b0031f08691720mr1472788qtj.37.1658517771550; 
 Fri, 22 Jul 2022 12:22:51 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 i10-20020a05622a08ca00b0031e9fa40c2esm3293707qte.27.2022.07.22.12.22.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Jul 2022 12:22:51 -0700 (PDT)
Date: Fri, 22 Jul 2022 15:22:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <Ytr5Cg68fZjFhXNs@redhat.com>
References: <20220717224508.10404-1-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220717224508.10404-1-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v2 0/4] dm pr_ops fixes
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
Cc: hch@infradead.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jul 17 2022 at  6:45P -0400,
Mike Christie <michael.christie@oracle.com> wrote:

> The following patches were made over Linus's tree and fix a couple bugs
> in the pr_ops code when a reservation type other than one of the All
> Registrants types is used. They were tested with the Windows failover
> cluster verification tests and libiscsi's PGR tests.
> 
> The current dm pr_ops code works well for All Registrants because any
> registered path is the reservation holder. Commands like reserve and
> release can go down any path and the behavior is the same. The problems
> these patches fix is when only one path is the holder as is the case
> for the other reservation types which is used by Window Failover Cluster
> and Linux Cluster (tools like pacemaker + scsi/multipath_fence agents).
> For example for Registrants Only the path that got the RESERVE command is
> the reservation holder. The RELEASE must be sent down that path to release
> the reservation.
> 
> With our current design we send down non-registration PR commands down
> whatever path we are currenly using, and then later PR commands end
> up on different paths. To continue the current design where dm's pr_ops
> are just passing through requests, and to avoid adding PR state to dm
> these patches modify pr_reserve/release to work similar to pr_register
> where we loop over all paths or at least loop over all paths until we
> find the path we are looking for.
> 
> v2:
> - Added info about testing.
> - Added patch for pr_preempt.

I picked this set up for 5.20 and staged in linux-next.

I tweaked the patch headers a bit while proof-reading and
understanding the scope of the changes.

I noticed that dm_pr_clear is the only remaining dm_pr_* method that
is using dm_{prepare,unprepare}_ioctl. I assume that'll be fine, but
the one gap it leaves is handling for the possibility that the DM
device is suspended.  Shouldn't dm_call_pr() be enhanced to check:
if (dm_suspended_md(md)) ?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


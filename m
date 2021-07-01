Return-Path: <SRS0=hnI9=LZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E9AC11F64
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:15:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DBAA6140B
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DBAA6140B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1625138104;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XJpMDJwZh2rtQCe8IUYzoADi0K9hjcLij92bShk/gD4=;
	b=Cbo60GJGMVq4JWc7FxJ/cLgDsLHVxFOYBp7BcPqYkp0sccPtg/GHKrlCCBC7C8eyF+8//c
	hIc+qL4l1XbGBBuRLm8e/sFwXVLf25GTGRo3jRPenA9lUvKJBKT+otILXboYuxfKgBD77F
	8MZHCjxEvAhwxbaNXbba2APyksr/sLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-73zNm6TSOEOkwBYFkotmHA-1; Thu, 01 Jul 2021 07:15:03 -0400
X-MC-Unique: 73zNm6TSOEOkwBYFkotmHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E0E28015D0;
	Thu,  1 Jul 2021 11:14:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 332075DF35;
	Thu,  1 Jul 2021 11:14:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F5304A712;
	Thu,  1 Jul 2021 11:14:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 161B7Ba0016919 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 1 Jul 2021 07:07:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 246EE20D69B4; Thu,  1 Jul 2021 11:07:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F25720D69B7
	for <dm-devel@redhat.com>; Thu,  1 Jul 2021 11:07:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C00C18A6534
	for <dm-devel@redhat.com>; Thu,  1 Jul 2021 11:07:04 +0000 (UTC)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
	[209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-448-E-raoBumMga9-lrg6yXojw-1; Thu, 01 Jul 2021 07:07:02 -0400
X-MC-Unique: E-raoBumMga9-lrg6yXojw-1
Received: by mail-pj1-f71.google.com with SMTP id
	r2-20020a17090a9402b0290172349acde4so3093433pjo.9
	for <dm-devel@redhat.com>; Thu, 01 Jul 2021 04:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=qWy1faEU2+6xPaNpOXpQc2Lrpi6aPT/25xHf/Z6cpbw=;
	b=pslxnMg4WH+4NDwwZ5xMlcgFZXZM7b+JKfniUp68YPjb6rtA/VRMuOPmO99fjEcC29
	0y0f1bdYjHN+uD9OHYIM/W1GsQGg9Re81/boydEMxaIhtrxCVLTlvZ3qmOlheVHhzia7
	auEKn5IlWpvL0mc/8L/xTMhHuFWbgIjZRd22OxA3SksVBp/JJKLW7Yvy2b/Ho8R3RLLG
	5VRhHYZ4Qd120RMYhd3QX0qVU6QB4Kg9bOttN5eehqp6m8qg1Zqrr+A4LBc3c91uLdx1
	zlO9N9VumSf1A0yEuAuVl+676zDZqgeYgs20L810Zac4vz1ZmR4mMvRFziGIozXszfUk
	xobQ==
X-Gm-Message-State: AOAM533DIT8F+pwxRqr37ZZGh6UJKLS+c4W1aU060BKKKW1t0xpBWGde
	ffbn12IPfdLdJIY1UwBpcdeIVJ0DSIS+R7iWAhAhdL9HI3a8rtzIM+34K2DZD01dmwM6VtilzPi
	euhyBui9xga/SeJIuhAWHheOxApKwlIQ=
X-Received: by 2002:a62:ee16:0:b029:2fe:ffcf:775a with SMTP id
	e22-20020a62ee160000b02902feffcf775amr40043873pfi.59.1625137621553;
	Thu, 01 Jul 2021 04:07:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1kVwoyjnIR3qRD8QsEf+6pzFR5H2YZPuZNpfADIZAAKDrY4X0nTDNbSb/S3TOhjXbj1hLppeJRJPQxzNCLxU=
X-Received: by 2002:a62:ee16:0:b029:2fe:ffcf:775a with SMTP id
	e22-20020a62ee160000b02902feffcf775amr40043852pfi.59.1625137621231;
	Thu, 01 Jul 2021 04:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210628151558.2289-1-mwilck@suse.com>
	<20210628151558.2289-4-mwilck@suse.com>
	<20210701075629.GA25768@lst.de>
In-Reply-To: <20210701075629.GA25768@lst.de>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 1 Jul 2021 13:06:50 +0200
Message-ID: <CABgObfYi6TooJM1cCCQrj2pdzz+VHtC+-w1KTycvsSiC+koNVQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>,
	Daniel Wagner <dwagner@suse.de>, Ewan Milne <emilne@redhat.com>,
	linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nils Koenig <nkoenig@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Martin Wilck <mwilck@suse.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add
 CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 1, 2021 at 9:56 AM Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jun 28, 2021 at 05:15:58PM +0200, mwilck@suse.com wrote:
> > The qemu "pr-helper" was specifically invented for it. I
> > believe that this is the most important real-world scenario for sending
> > SG_IO ioctls to device-mapper devices.
>
> pr-helper obviously does not SG_IO on dm-multipath as that simply does
> not work.

Right, for the specific case of persistent reservation ioctls, SG_IO is
sent manually to each path via libmpathpersist.

Failover for SG_IO is needed for general-purpose commands (ranging
from INQUIRY/READ CAPACITY to READ/WRITE). The reason to use
SG_IO instead of syscalls is mostly to preserve sense data; QEMU does
have code to convert errno to sense data, but it's fickle. If QEMU can use
sense data directly, it's easier to forward conditions that the guest can
resolve itself (for example unit attentions) and to let the guest operate
at a lower level (e.g. host-managed ZBC can be forwarded and they just
work).

Of course, all this works only for SCSI. As NVMe becomes more common,
and Linux exposes more functionality to userspace with a fabric-neutral
API, QEMU's SBC emulation can start using that functionality and provide
low-level passthrough functionality no matter if the host is using SCSI
or NVMe. Again, the main obstacle for this is sense data; for example,
the SCSI subsystem rightfully eats unit attentions and converts them to
uevents if you go through read/write requests instead of SG_IO.

> More importantly - if you want to use persistent reservations use the
> kernel ioctls for that.  These work on SCSI, NVMe and device mapper
> without any extra magic.

If they provide functionality equivalent to libmpathpersist without having
to do the DM_TABLE_STATUS, I will certainly consider switching! The
only possible issue could be the lost unit attentions.

Paolo

> Failing over SG_IO does not make sense.  It is an interface specically
> designed to leave all error handling to the userspace program using it,
> and we should not change that for one specific error case.  If you
> want the kernel to handle errors for you, use the proper interfaces.
> In this case this is the persistent reservation ioctls.  If they miss
> some features that qemu needs we should add those.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


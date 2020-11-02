Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FE0C00A89
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 19:59:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B7CEC208B6
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 19:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BZJNDJQw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7CEC208B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604347185;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K3SSl8Q7VqIn2/cTHQ/67COkkv8NORMDiDRm2RK/w0E=;
	b=BZJNDJQwT5Sp2ubpX7Rwqd2A0HYkJ4jGMVrZwWCAmwMqTBvd9SeGfy6t0zHQ+trektVVIW
	fmnZFxZkFgaOwKR14nmR6nw4WD+3/W8bp1kgh+WQW956mr/ypfDxn9KXvV8Ga5rV9dbyEr
	oqc9ZqeTj3WDLbKjJ9pUjMYQgE3r+Xs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-19KbxptaOgicOO_opXKg-A-1; Mon, 02 Nov 2020 14:59:43 -0500
X-MC-Unique: 19KbxptaOgicOO_opXKg-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 049EC809DD7;
	Mon,  2 Nov 2020 19:59:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D0DC21E8B;
	Mon,  2 Nov 2020 19:59:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 122A6181A06B;
	Mon,  2 Nov 2020 19:59:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A2Jxa2h003281 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 2 Nov 2020 14:59:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B24BA5DA6B; Mon,  2 Nov 2020 19:59:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A7B95D9DD;
	Mon,  2 Nov 2020 19:59:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A2JxUQb011461; 
	Mon, 2 Nov 2020 13:59:30 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A2JxT6W011460;
	Mon, 2 Nov 2020 13:59:29 -0600
Date: Mon, 2 Nov 2020 13:59:29 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201102195929.GS3384@octiron.msp.redhat.com>
References: <20201027224536.11662-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201027224536.11662-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Leonardo Arena <rnalrd@alpinelinux.org>
Subject: Re: [dm-devel] [PATCH 0/5] Fixes for musl libc / alpine
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 27, 2020 at 11:45:31PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

for the set.

> 
> Hi Christophe, Ben, all,
> 
> this series of patches fixes the compilation and unit-test
> problems of latest upstream with musl libc.
> 
> Regards,
> Martin
> 
> Martin Wilck (5):
>   libmultipath: make sure __GLIBC_PREREQ() is defined
>   multipath-tools: fix -Wformat errors with musl libc
>   libmultipath: always use glibc basename()
>   libmultipath tests: fix strerror() difference between musl and glibc
>   multipath-tools tests: fix for busybox
> 
>  libmultipath/util.c | 19 +++++++++++++++++--
>  libmultipath/util.h |  3 +++
>  multipathd/waiter.c |  2 +-
>  tests/Makefile      |  4 ++--
>  tests/alias.c       |  2 +-
>  tests/test-log.c    |  5 ++++-
>  6 files changed, 28 insertions(+), 7 deletions(-)
> 
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


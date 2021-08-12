Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C49C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 20:42:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 46A24610CC
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 20:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 46A24610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1628800965;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+M4Cj0U6cpSX62xmPfYCggLSarjjByG0dS/Ng4CZI7o=;
	b=b63r+84IUgl54094GBKyrbfvov1J0BopkAiBJON/2fvJoRIQ6wD1r3cO8Yq8wTkT8HxUQb
	Z75Ujc6DYTuSvfoaZwZ97e0RdrjFiofFWBHzLUfvoPtKW6RcGByt21DivxbOFe+FFo/TaO
	DzOxWkAWzqc1H35N3LksBByDmDFd9fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-I7rv35yFOOmIW19hUFukHA-1; Thu, 12 Aug 2021 16:42:43 -0400
X-MC-Unique: I7rv35yFOOmIW19hUFukHA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBB661853025;
	Thu, 12 Aug 2021 20:42:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A106604CC;
	Thu, 12 Aug 2021 20:42:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B236C181A1CE;
	Thu, 12 Aug 2021 20:42:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CKc4jd018422 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 16:38:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3C5145C25A; Thu, 12 Aug 2021 20:38:04 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBBA85C3DF;
	Thu, 12 Aug 2021 20:37:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 17CKbufA014004; Thu, 12 Aug 2021 16:37:56 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 17CKbtss014001; Thu, 12 Aug 2021 16:37:55 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 12 Aug 2021 16:37:55 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Arne Welzel <arne.welzel@corelight.com>
In-Reply-To: <39101295-ed12-33c1-ce1-86a649f5582@corelight.com>
Message-ID: <alpine.LRH.2.02.2108121637020.13935@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210808134205.1981531-1-arne.welzel@corelight.com>
	<alpine.LRH.2.02.2108101420250.26585@file01.intranet.prod.int.rdu2.redhat.com>
	<39101295-ed12-33c1-ce1-86a649f5582@corelight.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: dm-crypt@saout.de, dm-devel@redhat.com, DJ Gregor <dj@corelight.com>,
	agk@redhat.com, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH] dm crypt: Avoid percpu_counter spinlock
 contention in crypt_page_alloc()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 12 Aug 2021, Arne Welzel wrote:

> Mikulas,
> 
> On Tue, 10 Aug 2021, Mikulas Patocka wrote:
> 
> > Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
> >
> 
> thank you for the review. After looking at the submitted patch again,
> seems more proper to use >= as the condition:
> 
> > > + if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) > dm_crypt_pages_per_client) &&
>                                                                         ^^
>                                                                         >=
> Would it be okay if I resend the patch with this changed and add your
> Reviewed-by still? Would also fix some wording in the description and
> dedent the perf report output somewhat.
> 
> Thanks,
>    Arne

OK - you can resend the patch with my "Reviewed-by".

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


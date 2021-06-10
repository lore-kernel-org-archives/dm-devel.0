Return-Path: <SRS0=JBvk=LE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7BCC47094
	for <dm-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:21:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1DB0613F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:21:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1DB0613F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623324090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V3rwOhlbrfYso78GM3Xoc9Q47RU+ft6Ly292EBaoFbA=;
	b=dszE5cXmPyFhnIbJrX4NTpWrctCDC5bFPG+Znlo5MKW9kWHDfb5DrSgUpBZgexehMlcGRN
	UM843Wj+yKuoGi+jhFtcPH525ns64rE9egNjFmXNPM27CL9chCaC4V5Y/7CWK67BOn9cY2
	Aa8UPbjT5RUrvneB8lRbIF6UA3GCqmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-_nFa8gdZNeqlfCd3ECOLEg-1; Thu, 10 Jun 2021 07:21:29 -0400
X-MC-Unique: _nFa8gdZNeqlfCd3ECOLEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D26EC740A;
	Thu, 10 Jun 2021 11:21:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70358687C0;
	Thu, 10 Jun 2021 11:21:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DFBD46F82;
	Thu, 10 Jun 2021 11:21:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15ABLI4w021545 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Jun 2021 07:21:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C4F141037E8B; Thu, 10 Jun 2021 11:21:18 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D75510016FB;
	Thu, 10 Jun 2021 11:21:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 15ABLFCP007526; Thu, 10 Jun 2021 07:21:15 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 15ABLDTw007522; Thu, 10 Jun 2021 07:21:15 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 10 Jun 2021 07:21:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <YMGzJLG6KtBkxE4y@infradead.org>
Message-ID: <alpine.LRH.2.02.2106100718170.7254@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2106090930400.3736@file01.intranet.prod.int.rdu2.redhat.com>
	<YMGzJLG6KtBkxE4y@infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Joe Thornber <thornber@redhat.com>,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm-writecache: avoid kcopyd and use
 open-coded variant instead
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 10 Jun 2021, Christoph Hellwig wrote:

> On Wed, Jun 09, 2021 at 09:38:38AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > This is the second version of the patch that avoids kcopyd. It sorts the 
> > requests according to sector number when writing to the slow device. But 
> > still, kcopyd is faster in my tests.
> 
> So kcopyd is faster but you replace it by an open coded version?
> Why?

I thought that the open-coded version would perform better. This is just a 
test patch, I do not intend to push upstream. I tested it on IDE disk and 
SATA300 ssd. I am interested to see how it will perform on NVME ssd.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


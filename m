Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA02C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 13:57:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2DB1964DEB
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 13:57:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DB1964DEB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611928668;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qpbbDXHSRAnoU9Q9Tf0lg3wh6pt+RrdJKEx7TqKQYWU=;
	b=GDkKkg2W2Ts4teCjhutfd8fkbXrnggmdlL7CciJ0RmYaPesJKquodrHamDSnxoE4SK5/Zw
	tlkF877ht6rIbAEf7ixy+QETpL0KIFzA6RdqGYH8ApqbG/jGTsD4dl8ueV69NwRvDHPNx3
	9e4IzGhNK1hATpxymKpOYU48zEX9nyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-m09wdAXnOx6tZlb-W8o_NA-1; Fri, 29 Jan 2021 08:57:45 -0500
X-MC-Unique: m09wdAXnOx6tZlb-W8o_NA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AE8A802B40;
	Fri, 29 Jan 2021 13:57:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 985655D9C0;
	Fri, 29 Jan 2021 13:57:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE51F50037;
	Fri, 29 Jan 2021 13:57:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10TDvWvV026099 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 08:57:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A51345D9C9; Fri, 29 Jan 2021 13:57:32 +0000 (UTC)
Received: from agk.fab.redhat.com (agk-dp.fab.redhat.com [10.33.15.10])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B42155D9C0;
	Fri, 29 Jan 2021 13:57:26 +0000 (UTC)
Received: from agk by agk.fab.redhat.com with local (Exim 4.34)
	id 1l5UH7-00074g-BI; Fri, 29 Jan 2021 13:57:25 +0000
Date: Fri, 29 Jan 2021 13:57:25 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Coly Li <colyli@suse.de>
Message-ID: <20210129135725.GA27059@agk.fab.redhat.com>
Mail-Followup-To: Coly Li <colyli@suse.de>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
References: <41f1923b-8f45-ff49-e0d9-06bc5a4a6fad@suse.de>
Mime-Version: 1.0
In-Reply-To: <41f1923b-8f45-ff49-e0d9-06bc5a4a6fad@suse.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales,
	number 03798903. Registered Office: Amberley Place,
	107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] dm thin-volume hung as swap: bug or as-design ?
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

On Fri, Jan 29, 2021 at 06:40:06PM +0800, Coly Li wrote:
> Recently I receive a report that whole system hung and no response after
> a while with I/O load. The special configuration is the dm thin-pool
> volume is used as the swap partition of the system.
> My questions are,
> - Can a thin-pool volume be used as swap device?

Yes in principle, but it won't get much testing as it's not 
necessarily a particularly sensible configuration.
- You'd normally prefer fully-pre-allocated disk space for swap
  and turn off the zeroing.

Is there some use-case where it does make more sense?

> - The above description is a bug, or an already know issue which should
> be avoided ?
 
Bug.

Alasdair

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


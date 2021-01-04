Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001CCC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:05:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8465522482
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8465522482
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609779922;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UQmIp4wtKb3G/RTXnZGalBruVCSY81JcrIN/nQvvChs=;
	b=KT1+6nGn4bHXpBobrYsYDU3yN/gP5cU8EFLtsE9v8HnbS8SrQem2NVnNRhM/dJNcgg7hDJ
	evSK7Wx/vRaAU8+Fmjl8xYJhIHc9sN2AdrAetCJh1KkmcBswBxGcWjb+rAzCppoJgohgpo
	PSqK0Qxkc7T8G2NBg5X8kpAcvP34aLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-8GRJfgegMTGeipJzDmhAVg-1; Mon, 04 Jan 2021 12:05:20 -0500
X-MC-Unique: 8GRJfgegMTGeipJzDmhAVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE927800D62;
	Mon,  4 Jan 2021 17:05:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B63E5D9C6;
	Mon,  4 Jan 2021 17:05:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5181F180954D;
	Mon,  4 Jan 2021 17:05:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104H59Yt011949 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 12:05:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 29BBA5D756; Mon,  4 Jan 2021 17:05:09 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A3595D751;
	Mon,  4 Jan 2021 17:05:02 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 104H51GA002921; Mon, 4 Jan 2021 12:05:01 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 104H4xUR002896; Mon, 4 Jan 2021 12:04:59 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Mon, 4 Jan 2021 12:04:59 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Ignat Korchagin <ignat@cloudflare.com>
In-Reply-To: <20210104145948.1857-1-ignat@cloudflare.com>
Message-ID: <alpine.LRH.2.02.2101041204010.2157@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210104145948.1857-1-ignat@cloudflare.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, herbert@gondor.apana.org.au, snitzer@redhat.com,
	kernel-team@cloudflare.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, nobuto.murata@canonical.com,
	ebiggers@kernel.org, clm@fb.com, dm-devel@redhat.com,
	linux-btrfs@vger.kernel.org, dsterba@suse.com,
	josef@toxicpanda.com, mail@maciej.szmigiero.name, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 0/2] dm crypt: some fixes to support
 dm-crypt running in softirq context
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 4 Jan 2021, Ignat Korchagin wrote:

> Changes from v1:
>   * 0001: handle memory allocation failure for GFP_ATOMIC
> 
> Changes from v2:
>   * reordered patches
>   * 0002: crypt_convert will be retried from a workqueue, when a crypto request
>     allocation fails with GFP_ATOMIC instead of just returning an IO error to
>     the user
> 
> Ignat Korchagin (2):
>   dm crypt: do not wait for backlogged crypto request completion in
>     softirq
>   dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq
> 
>  drivers/md/dm-crypt.c | 138 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 123 insertions(+), 15 deletions(-)
> 
> -- 
> 2.20.1
> 

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


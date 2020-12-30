Return-Path: <SRS0=/4vF=GC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE0CC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 12:24:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7354E22209
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 12:24:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7354E22209
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-j1nmnCyqOkK0znhZfFfNJA-1; Wed, 30 Dec 2020 07:24:15 -0500
X-MC-Unique: j1nmnCyqOkK0znhZfFfNJA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72826100C661;
	Wed, 30 Dec 2020 12:24:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D90D5F7D8;
	Wed, 30 Dec 2020 12:24:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 890A71809CA1;
	Wed, 30 Dec 2020 12:24:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BUCLH4r031650 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Dec 2020 07:21:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6F3331111A65; Wed, 30 Dec 2020 12:21:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AB931111A64
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 12:21:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43B4F101A53F
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 12:21:13 +0000 (UTC)
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-587-CC8-LW8zPJ-TBmGAVHWSGQ-1; Wed, 30 Dec 2020 07:21:11 -0500
X-MC-Unique: CC8-LW8zPJ-TBmGAVHWSGQ-1
Received: from host86-158-105-41.range86-158.btcentralplus.com
	([86.158.105.41] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1kuZla-0001U5-DV; Wed, 30 Dec 2020 11:35:46 +0000
To: John Stoffel <john@stoffel.org>, dannyshih <dannyshih@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
	<1609233522-25837-2-git-send-email-dannyshih@synology.com>
	<24555.49943.411197.147225@quad.stoffel.home>
From: antlists <antlists@youngman.org.uk>
Message-ID: <d841085f-5fd7-bd5c-a40b-fbb953c80598@youngman.org.uk>
Date: Wed, 30 Dec 2020 11:35:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <24555.49943.411197.147225@quad.stoffel.home>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, snitzer@redhat.com,
	linux-block@vger.kernel.org, song@kernel.org,
	dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 1/4] block: introduce
	submit_bio_noacct_add_head
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 30/12/2020 00:00, John Stoffel wrote:
> dannyshih> From: Danny Shih<dannyshih@synology.com>
> dannyshih> Porvide a way for stacking block device to re-submit the bio
> dannyshih> which sholud be handled firstly.
> 
> You're spelling needs to be fixed in these messages.

   ^^^^^^

It is traditional, when correcting someone else's spelling, to make one 
of your own ... :-)

Sorry, but if we're being pedantic for furriners, it behoves us to be 
correct ourselves :-)

Cheers,
Wol

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


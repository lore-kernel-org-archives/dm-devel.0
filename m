Return-Path: <SRS0=/4vF=GC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54861C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 16:53:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 77E7C207B0
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 16:53:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77E7C207B0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=stoffel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-WCwjusWnNXKXn1EKI3of3w-1; Wed, 30 Dec 2020 11:53:46 -0500
X-MC-Unique: WCwjusWnNXKXn1EKI3of3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBEE810054FF;
	Wed, 30 Dec 2020 16:53:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 65E6360C0F;
	Wed, 30 Dec 2020 16:53:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 803F05002C;
	Wed, 30 Dec 2020 16:53:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BUGrWdo015828 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Dec 2020 11:53:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 66FF32026D76; Wed, 30 Dec 2020 16:53:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 627FD2026D49
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 16:53:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA12C185A794
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 16:53:28 +0000 (UTC)
Received: from mail.stoffel.org (li1843-175.members.linode.com
	[172.104.24.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-85-xaigOtxVMrWIp_8o5SpFag-1; Wed, 30 Dec 2020 11:53:24 -0500
X-MC-Unique: xaigOtxVMrWIp_8o5SpFag-1
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com
	[68.116.170.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
	SHA256) (No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 512A125F8F;
	Wed, 30 Dec 2020 11:53:23 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id AE2BDA6ACD; Wed, 30 Dec 2020 11:53:22 -0500 (EST)
MIME-Version: 1.0
Message-ID: <24556.45186.659863.688675@quad.stoffel.home>
Date: Wed, 30 Dec 2020 11:53:22 -0500
From: "John Stoffel" <john@stoffel.org>
To: antlists <antlists@youngman.org.uk>
In-Reply-To: <d841085f-5fd7-bd5c-a40b-fbb953c80598@youngman.org.uk>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
	<1609233522-25837-2-git-send-email-dannyshih@synology.com>
	<24555.49943.411197.147225@quad.stoffel.home>
	<d841085f-5fd7-bd5c-a40b-fbb953c80598@youngman.org.uk>
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
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, snitzer@redhat.com,
	John Stoffel <john@stoffel.org>, linux-block@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com,
	dannyshih <dannyshih@synology.com>, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>>>> "antlists" == antlists  <antlists@youngman.org.uk> writes:

antlists> On 30/12/2020 00:00, John Stoffel wrote:
dannyshih> From: Danny Shih<dannyshih@synology.com>
dannyshih> Porvide a way for stacking block device to re-submit the bio
dannyshih> which sholud be handled firstly.
>> 
>> You're spelling needs to be fixed in these messages.

antlists>    ^^^^^^

antlists> It is traditional, when correcting someone else's spelling,
antlists> to make one of your own ... :-)

LOL!  Yes, touche!  I'm completely abashed.  

antlists> Sorry, but if we're being pedantic for furriners, it behoves
antlists> us to be correct ourselves :-)

It does for sure, thanks for the nudge.  

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


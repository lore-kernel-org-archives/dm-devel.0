Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3110C433E6
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0164A2068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0164A2068D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269--SeFXPr_M6KNIaupIRIMmA-1; Mon, 04 Jan 2021 14:03:22 -0500
X-MC-Unique: -SeFXPr_M6KNIaupIRIMmA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA585800D53;
	Mon,  4 Jan 2021 19:03:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8CC31002388;
	Mon,  4 Jan 2021 19:03:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 410AE4A7C6;
	Mon,  4 Jan 2021 19:03:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNLKJUO004993 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 16:20:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 47BCC1134CC8; Wed, 23 Dec 2020 21:20:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4280D1134CCC
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:20:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1261A80018D
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:20:17 +0000 (UTC)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-245-q0ekWOggPOGGPCj2vh2H8Q-1; Wed, 23 Dec 2020 16:20:14 -0500
X-MC-Unique: q0ekWOggPOGGPCj2vh2H8Q-1
Received: from MUA by vps-vb.mhejs.net with esmtps
	(TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim 4.93.0.4)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1ksBXv-0005iQ-Eq; Wed, 23 Dec 2020 22:19:47 +0100
To: Ignat Korchagin <ignat@cloudflare.com>
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
	<74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
	<CALrw=nHiSPxVxxuA1fekwDOqBZX0BGe8_3DTN7TNkrVD2q8rxg@mail.gmail.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <fc27dc51-65a7-f2fa-6b29-01a1d5eaec6c@maciej.szmigiero.name>
Date: Wed, 23 Dec 2020 22:19:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALrw=nHiSPxVxxuA1fekwDOqBZX0BGe8_3DTN7TNkrVD2q8rxg@mail.gmail.com>
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>,
	kernel-team <kernel-team@cloudflare.com>, dm-crypt@saout.de,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Nobuto Murata <nobuto.murata@canonical.com>,
	Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
	device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, Alasdair G Kergon <agk@redhat.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [dm-devel] dm-crypt with no_read_workqueue and
 no_write_workqueue + btrfs scrub = BUG()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 23.12.2020 22:09, Ignat Korchagin wrote:
(..)
> I've been looking into this for the last couple of days because of
> other reports [1].
> Just finished testing a possible solution. Will submit soon.

Thanks for looking into it.

By the way, on a bare metal I am actually hitting a different problem
(scheduling while atomic) when scrubbing a btrfs filesystem, just as one
of your users from that GitHub report had [1].

I've pasted that backtrace in my original Dec 14 message.

Thanks,
Maciej

[1]: https://github.com/cloudflare/linux/issues/1#issuecomment-736734243

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


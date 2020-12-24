Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A04DC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3FB5F206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FB5F206A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-6uZ0zM1ZOyCGAjaeEumkkw-1; Mon, 04 Jan 2021 14:03:45 -0500
X-MC-Unique: 6uZ0zM1ZOyCGAjaeEumkkw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5FF9107AD43;
	Mon,  4 Jan 2021 19:03:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C111D27C2E;
	Mon,  4 Jan 2021 19:03:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91AF11809CAD;
	Mon,  4 Jan 2021 19:03:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BOIrmL9031922 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Dec 2020 13:53:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CE802166B2B; Thu, 24 Dec 2020 18:53:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 181E22166B29
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 18:53:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A738D800B3B
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 18:53:45 +0000 (UTC)
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-498-x8INx1EpPFiqmlp7E_G8uQ-1; Thu, 24 Dec 2020 13:53:43 -0500
X-MC-Unique: x8INx1EpPFiqmlp7E_G8uQ-1
Received: from MUA by vps-vb.mhejs.net with esmtps
	(TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim 4.93.0.4)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1ksVjV-0003Ga-OE; Thu, 24 Dec 2020 19:53:05 +0100
To: Ignat Korchagin <ignat@cloudflare.com>
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
	<74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
	<20201223205642.GA19817@gondor.apana.org.au>
	<CALrw=nFRLxpG+Qzy=wki1m6HnQUqPK9CQFGEEnB1tjSF0ex4UQ@mail.gmail.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <f3b3c90e-90e6-9228-f2e5-172997eebf85@maciej.szmigiero.name>
Date: Thu, 24 Dec 2020 19:52:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALrw=nFRLxpG+Qzy=wki1m6HnQUqPK9CQFGEEnB1tjSF0ex4UQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 24.12.2020 19:46, Ignat Korchagin wrote:
> On Wed, Dec 23, 2020 at 8:57 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> On Wed, Dec 23, 2020 at 04:37:34PM +0100, Maciej S. Szmigiero wrote:
>>>
>>> It looks like to me that the skcipher API might not be safe to
>>> call from a softirq context, after all.
>>
>> skcipher is safe to use in a softirq.  The problem is only in
>> dm-crypt where it tries to allocate memory with GFP_NOIO.
> 
> Hm.. After eliminating the GFP_NOIO (as well as some other sleeping
> paths) from dm-crypt softirq code I still hit an occasional crash in
> my extreme setup (QEMU with 1 CPU and cryptd_max_cpu_qlen set to 1)
> (decoded with stacktrace_decode.sh):
(..)
> This happens when running dm-crypt with no_read_workqueues on top of
> an emulated NVME in QEMU (NVME driver "completes" IO in IRQ context).
> Somehow sending decryption requests to cryptd in some fashion in
> softirq context corrupts the crypto queue it seems.

You can try compiling your test kernel with KASAN, as it often
immediately points out where the memory starts to get corrupted
(if that's the bug).

Enabling other "checking" kernel debug options might help debugging
the root case of this, too.

> Regards,
> Ignat

Thanks,
Maciej

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


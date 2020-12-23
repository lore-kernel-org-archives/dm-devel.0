Return-Path: <SRS0=xRQ1=F3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD986C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 20:57:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A8741223E4
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 20:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8741223E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-n2Q9-i9eNHemNbHrUetwdQ-1; Wed, 23 Dec 2020 15:57:25 -0500
X-MC-Unique: n2Q9-i9eNHemNbHrUetwdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA7E6800D62;
	Wed, 23 Dec 2020 20:57:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9998C10023AD;
	Wed, 23 Dec 2020 20:57:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 395E24BB7B;
	Wed, 23 Dec 2020 20:57:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNKvChI002807 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 15:57:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AA6681972B; Wed, 23 Dec 2020 20:57:12 +0000 (UTC)
Received: from fornost.hmeau.com (vpn2-54-202.bne.redhat.com [10.64.54.202])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81C3B19714;
	Wed, 23 Dec 2020 20:57:04 +0000 (UTC)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
	id 1ksBBa-0002fP-D7; Thu, 24 Dec 2020 07:56:43 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation);
	Thu, 24 Dec 2020 07:56:42 +1100
Date: Thu, 24 Dec 2020 07:56:42 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <20201223205642.GA19817@gondor.apana.org.au>
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
	<74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
MIME-Version: 1.0
In-Reply-To: <74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, snitzer@redhat.com, kernel-team@cloudflare.com,
	dm-crypt@saout.de, linux-kernel@vger.kernel.org,
	nobuto.murata@canonical.com, ebiggers@kernel.org,
	Chris Mason <clm@fb.com>, dm-devel@redhat.com,
	mpatocka@redhat.com, linux-btrfs@vger.kernel.org,
	Ignat Korchagin <ignat@cloudflare.com>, David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, agk@redhat.com,
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 23, 2020 at 04:37:34PM +0100, Maciej S. Szmigiero wrote:
> 
> It looks like to me that the skcipher API might not be safe to
> call from a softirq context, after all.

skcipher is safe to use in a softirq.  The problem is only in
dm-crypt where it tries to allocate memory with GFP_NOIO.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


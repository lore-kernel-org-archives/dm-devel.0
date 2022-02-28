Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A240C4321E
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 23:27:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-s458ZCLCMp6jayKeryUVrQ-1; Mon, 28 Feb 2022 18:27:07 -0500
X-MC-Unique: s458ZCLCMp6jayKeryUVrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E5B21091DA1;
	Mon, 28 Feb 2022 23:27:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1D32705BB;
	Mon, 28 Feb 2022 23:27:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 28EC94A701;
	Mon, 28 Feb 2022 23:27:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21SNQxXI021170 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 18:27:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ED6994F876; Mon, 28 Feb 2022 23:26:59 +0000 (UTC)
Received: from fornost.hmeau.com (vpn2-54-85.bne.redhat.com [10.64.54.85])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7AD54EC7B
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 23:26:52 +0000 (UTC)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
	id 1nOpPZ-000832-Uq; Tue, 01 Mar 2022 10:26:39 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation);
	Tue, 01 Mar 2022 11:26:37 +1200
Date: Tue, 1 Mar 2022 11:26:37 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Message-ID: <Yh1aLfy/oBawCJIg@gondor.apana.org.au>
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
	<20220219210354.GF59715@dread.disaster.area>
	<CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
	<YhN76/ONC9qgIKQc@silpixa00400314>
	<CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
	<CAHk-=whVT2GcwiJM8m-XzgJj8CjytTHi_pmgmOnSpzvGWzZM1A@mail.gmail.com>
	<Yh0y75aegqS4jIP7@silpixa00400314>
MIME-Version: 1.0
In-Reply-To: <Yh0y75aegqS4jIP7@silpixa00400314>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>,
	qat-linux@intel.com, Linux-Kernal <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Kyle Sanderson <kyle.leet@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 28, 2022 at 08:39:11PM +0000, Giovanni Cabiddu wrote:
>
> The dm-crypt + QAT use-case is already disabled since kernel 5.10 due to
> a different issue.

Indeed, qat has been disabled for dm-crypt since

commit b8aa7dc5c7535f9abfca4bceb0ade9ee10cf5f54
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu Jul 9 23:20:41 2020 -0700

    crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY

So this should no longer be an issue with an up-to-date kernel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


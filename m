Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2937C4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:44:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0995D20732
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:43:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0995D20732
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-oS6G9VzTM9WXzSX0aqiNCw-1; Mon, 26 Oct 2020 14:43:57 -0400
X-MC-Unique: oS6G9VzTM9WXzSX0aqiNCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FC736408E;
	Mon, 26 Oct 2020 18:43:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 156AA55772;
	Mon, 26 Oct 2020 18:43:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A4189181A86E;
	Mon, 26 Oct 2020 18:43:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QIdl4p008648 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 14:39:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 31712114B2FF; Mon, 26 Oct 2020 18:39:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AEC0114B308
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 18:39:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D31198726C6
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 18:39:44 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-486-E42D9qMkPvaVisXxGQJXDA-1;
	Mon, 26 Oct 2020 14:39:40 -0400
X-MC-Unique: E42D9qMkPvaVisXxGQJXDA-1
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net
	[172.10.235.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 3E4152084C;
	Mon, 26 Oct 2020 18:39:38 +0000 (UTC)
Date: Mon, 26 Oct 2020 11:39:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <20201026183936.GJ858@sol.localdomain>
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-4-gilad@benyossef.com>
	<20201026175231.GG858@sol.localdomain>
	<d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
MIME-Version: 1.0
In-Reply-To: <d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH 3/4] dm crypt: switch to EBOIV crypto API
	template
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 26, 2020 at 07:29:57PM +0100, Milan Broz wrote:
> On 26/10/2020 18:52, Eric Biggers wrote:
> > On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
> >> Replace the explicit EBOIV handling in the dm-crypt driver with calls
> >> into the crypto API, which now possesses the capability to perform
> >> this processing within the crypto subsystem.
> >>
> >> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >>
> >> ---
> >>  drivers/md/Kconfig    |  1 +
> >>  drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
> >>  2 files changed, 20 insertions(+), 42 deletions(-)
> >>
> >> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> >> index 30ba3573626c..ca6e56a72281 100644
> >> --- a/drivers/md/Kconfig
> >> +++ b/drivers/md/Kconfig
> >> @@ -273,6 +273,7 @@ config DM_CRYPT
> >>  	select CRYPTO
> >>  	select CRYPTO_CBC
> >>  	select CRYPTO_ESSIV
> >> +	select CRYPTO_EBOIV
> >>  	help
> >>  	  This device-mapper target allows you to create a device that
> >>  	  transparently encrypts the data on it. You'll need to activate
> > 
> > Can CRYPTO_EBOIV please not be selected by default?  If someone really wants
> > Bitlocker compatibility support, they can select this option themselves.
> 
> Please no! Until this move of IV to crypto API, we can rely on
> support in dm-crypt (if it is not supported, it is just a very old kernel).
> (Actually, this was the first thing I checked in this patchset - if it is
> unconditionally enabled for compatibility once dmcrypt is selected.)
> 
> People already use removable devices with BitLocker.
> It was the whole point that it works out-of-the-box without enabling anything.
> 
> If you insist on this to be optional, please better keep this IV inside dmcrypt.
> (EBOIV has no other use than for disk encryption anyway.)
> 
> Or maybe another option would be to introduce option under dm-crypt Kconfig that
> defaults to enabled (like support for foreign/legacy disk encryption schemes) and that
> selects these IVs/modes.
> But requiring some random switch in crypto API will only confuse users.

CONFIG_DM_CRYPT can either select every weird combination of algorithms anyone
can ever be using, or it can select some defaults and require any other needed
algorithms to be explicitly selected.

In reality, dm-crypt has never even selected any particular block ciphers, even
AES.  Nor has it ever selected XTS.  So it's actually always made users (or
kernel distributors) explicitly select algorithms.  Why the Bitlocker support
suddenly different?

I'd think a lot of dm-crypt users don't want to bloat their kernels with random
legacy algorithms.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


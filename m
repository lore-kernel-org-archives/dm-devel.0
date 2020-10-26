Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88FCC4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:00:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3BECF222C8
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 18:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BECF222C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-kTemqf9iO7KwCbKZct42Sg-1; Mon, 26 Oct 2020 13:59:59 -0400
X-MC-Unique: kTemqf9iO7KwCbKZct42Sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72806EC1A1;
	Mon, 26 Oct 2020 17:59:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 714985C1BB;
	Mon, 26 Oct 2020 17:59:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE8E492F2E;
	Mon, 26 Oct 2020 17:59:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QHqjG0004376 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 13:52:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 028FA1140589; Mon, 26 Oct 2020 17:52:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F23511140568
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 17:52:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD9B6185A79C
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 17:52:41 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-335-KkXVREnJPaCN-VDMfcPYlw-1;
	Mon, 26 Oct 2020 13:52:34 -0400
X-MC-Unique: KkXVREnJPaCN-VDMfcPYlw-1
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net
	[172.10.235.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id C592020790;
	Mon, 26 Oct 2020 17:52:32 +0000 (UTC)
Date: Mon, 26 Oct 2020 10:52:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Message-ID: <20201026175231.GG858@sol.localdomain>
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-4-gilad@benyossef.com>
MIME-Version: 1.0
In-Reply-To: <20201026130450.6947-4-gilad@benyossef.com>
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
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 26, 2020 at 03:04:46PM +0200, Gilad Ben-Yossef wrote:
> Replace the explicit EBOIV handling in the dm-crypt driver with calls
> into the crypto API, which now possesses the capability to perform
> this processing within the crypto subsystem.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> 
> ---
>  drivers/md/Kconfig    |  1 +
>  drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
>  2 files changed, 20 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 30ba3573626c..ca6e56a72281 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -273,6 +273,7 @@ config DM_CRYPT
>  	select CRYPTO
>  	select CRYPTO_CBC
>  	select CRYPTO_ESSIV
> +	select CRYPTO_EBOIV
>  	help
>  	  This device-mapper target allows you to create a device that
>  	  transparently encrypts the data on it. You'll need to activate

Can CRYPTO_EBOIV please not be selected by default?  If someone really wants
Bitlocker compatibility support, they can select this option themselves.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


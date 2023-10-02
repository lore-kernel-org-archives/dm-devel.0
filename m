Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E33E784AE
	for <dm-devel@archiver.kernel.org>; Mon,  2 Oct 2023 08:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696235598;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+SxBocEBsaoz/mubcFnxYG8st1KG4wXolpZMJXnTfuM=;
	b=YT/1v8AWn/cNhpG5bKgLrnn+I6lqsY6Asj4lHJ4yyW3/MptD1EfmvBggyqta/azWMAfUxH
	SfRgWQ1V3uledc+EVixePJd3a7akyEPjrEQpQNd/7fmH1/CAI414CwUOiaC5gXcZgQv4qw
	Wj31Nom0W7OKUNRrKy4dvttO8d8ILHU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-P1asysVbP0evfrBhNYGsNA-1; Mon, 02 Oct 2023 04:33:13 -0400
X-MC-Unique: P1asysVbP0evfrBhNYGsNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2E5C101AA68;
	Mon,  2 Oct 2023 08:33:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C5AB51E3;
	Mon,  2 Oct 2023 08:33:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1BB041946597;
	Mon,  2 Oct 2023 08:33:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0C8941946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 Oct 2023 08:33:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE94A215670B; Mon,  2 Oct 2023 08:33:09 +0000 (UTC)
Received: from abb.hmeau.com (unknown [10.67.24.162])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 687882156702
 for <dm-devel@redhat.com>; Mon,  2 Oct 2023 08:33:08 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1qnEMK-002dTQ-Nh; Mon, 02 Oct 2023 16:32:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 02 Oct 2023 16:33:00 +0800
Date: Mon, 2 Oct 2023 16:33:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Message-ID: <ZRqAPN5j4RxH9QW1@gondor.apana.org.au>
References: <4u6ffcrzr5xg6tzoczkfnuqy7v2e3w6243oxdsu3g4uughh6go@6owks5linnxi>
MIME-Version: 1.0
In-Reply-To: <4u6ffcrzr5xg6tzoczkfnuqy7v2e3w6243oxdsu3g4uughh6go@6owks5linnxi>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [bug report] dm-crypt setup failure with
 next-20230929 kernel
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gondor.apana.org.au
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 02, 2023 at 08:08:23AM +0000, Shinichiro Kawasaki wrote:
> Hello there,
> 
> I ran the command below on top of linux-next kernel with the tag next-20230929,
> and observed dm-crypt setup failed.
> 
>   $ sudo cryptsetup open --type=plain --key-file=/dev/zero /dev/nullb0 test
>   device-mapper: reload ioctl on test (253:0) failed: No such file or directory
> 
> Kernel reported an error related to crypto.
> 
>   device-mapper: table: 253:0: crypt: Error allocating crypto tfm (-ENOENT)
>   device-mapper: ioctl: error adding target to table
> 
> The failure was observed with null_blk and SATA HDD. It looks independent of
> block device type.
> 
> I bisected and found that the commit 31865c4c4db2 ("crypto: skcipher - Add
> lskcipher") is the trigger. I reverted the commit from next-20230929 together
> with other four dependent commits below, and observed the failure disappears.
> 
>   705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher")
>   32a8dc4afcfb ("crypto: ecb - Convert from skcipher to lskcipher")
>   3dfe8786b11a ("crypto: testmgr - Add support for lskcipher algorithms")
>   8aee5d4ebd11 ("crypto: lskcipher - Add compatibility wrapper around ECB")
> 
> Is this a known issue?

Thanks for the report.  I'll look into this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


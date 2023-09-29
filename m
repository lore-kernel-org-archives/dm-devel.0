Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72DAE7734B
	for <dm-devel@archiver.kernel.org>; Fri, 29 Sep 2023 22:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696028070;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=avphp/zztv9rZhfgVwgDe5xM+ts4B/sRdEveetCg8os=;
	b=cNnR7aCBAyg2Pha1cycBsUCQdoXmci8Bq8BQaBqMon6Y//gcXbve4O3OtKNr6/uhPauDKN
	T/9jLO8UhehwNMgM6Ry1mdCssD0WVZJT6tJ5ZaN3yGr2ezzcqM1GY/YwERB946+dTMMESC
	tP3DpLdsqWRjllusuzMH5vuM8t/Vjuo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-T43bvInNNYeSQM9NSYmAwQ-1; Fri, 29 Sep 2023 18:54:27 -0400
X-MC-Unique: T43bvInNNYeSQM9NSYmAwQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB3151C0653A;
	Fri, 29 Sep 2023 22:54:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 487AF40C6EBF;
	Fri, 29 Sep 2023 22:54:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E45581946587;
	Fri, 29 Sep 2023 22:54:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9F9B31946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Sep 2023 22:50:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 20BB4C158BA; Fri, 29 Sep 2023 22:50:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 188D9C15BB8
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 22:50:30 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDA318032F6
 for <dm-devel@redhat.com>; Fri, 29 Sep 2023 22:50:29 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-s2GAABZ6MQ-eIs0d6-HSkg-1; Fri, 29 Sep 2023 18:50:28 -0400
X-MC-Unique: s2GAABZ6MQ-eIs0d6-HSkg-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by dfw.source.kernel.org (Postfix) with ESMTP id 3F54261E11;
 Fri, 29 Sep 2023 22:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C37C433C8;
 Fri, 29 Sep 2023 22:43:28 +0000 (UTC)
Date: Fri, 29 Sep 2023 22:43:27 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Yureka <yuka@yuka.dev>
Message-ID: <20230929224327.GA11839@google.com>
References: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
MIME-Version: 1.0
In-Reply-To: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [REGRESSION] dm_crypt essiv ciphers do not use async
 driver mv-aes-cbc anymore
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
Cc: regressions@lists.linux.dev, Boris Brezillon <bbrezillon@kernel.org>,
 Arnaud Ebalard <arno@natisbad.org>, Srujana Challa <schalla@marvell.com>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 linux-crypto@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Yureka,

On Fri, Sep 29, 2023 at 11:08:55PM +0200, Yureka wrote:
> #regzbot introduced: 7bcb2c99f8ed
> 
> I am running the NixOS distribution cross-compiled from x86_64 to a Marvell
> Armada 388 armv7 SoC.
> 
> I am not getting expected speeds when reading/writing on my encrypted hard
> drive with 6.5.5, while it is fast on 5.4.257. Volume is formatted like this:
> `cryptsetup luksFormat -c aes-cbc-essiv:sha256 /dev/sda`.
> 
> Specifically, I tracked this down to the changes to crypto/essiv.c from
> 7bcb2c99f8ed mentioned above. Reverting those changes on top of a 6.5.5 kernel
> provides working (see applicable diff further below).
> 
> I'm *guessing* that this is related to the mv-aes-cbc crypto driver (from the
> marvell-cesa module) being registered as async (according to /proc/crypto),
> and I *suspect* that async drivers are not being used anymore by essiv or
> dm_crypt. Going by the commit description, which sounds more like a refactor,
> this does not seem intentional.

This is actually from commit b8aa7dc5c753 ("crypto: drivers - set the flag
CRYPTO_ALG_ALLOCATES_MEMORY"), which set CRYPTO_ALG_ALLOCATES_MEMORY in
marvell-cesa.  7bcb2c99f8ed is just one of the prerequisite commits.

I understand that the dm-crypt developers did this as an intentional bug fix in
order to prevent dm-crypt from using crypto drivers that are known to cause
deadlocks due to allocating memory during requests.

If you are interested in still being able to use marvell-cesa with dm-crypt, I
believe it would need to be fixed to meet the requirements for not needing
CRYPTO_ALG_ALLOCATES_MEMORY.  I've Cc'ed the maintainers of that driver.

#regzbot introduced: b8aa7dc5c753

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


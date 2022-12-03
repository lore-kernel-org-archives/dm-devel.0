Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F463C352A1
	for <dm-devel@archiver.kernel.org>; Sat,  3 Dec 2022 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670080267;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Sm2RN7yhwWZwaSi8moFD3SM93oLGlOLAXPDycuLGjjs=;
	b=NPViA9TQ9k4zTM9Qkc9VS7eliH2Pm0WaDEjnhjNgmcJtJUkKvAPsEmBIu7QtsXrRovqDtc
	G5B9PaNFbwSJx1ZNN0wb6TchpT9Ae9N5roOg88J37rwCKuNzK2/ETf6m7XO0uc8dLPojQY
	jg1GBG0EO6HeCMKxPE1Pg4vQtUTFnqk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-Okimg6aJNV2ojYX3LObFPw-1; Sat, 03 Dec 2022 10:11:04 -0500
X-MC-Unique: Okimg6aJNV2ojYX3LObFPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 491281C0515A;
	Sat,  3 Dec 2022 15:11:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFC521121330;
	Sat,  3 Dec 2022 15:11:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A24181946588;
	Sat,  3 Dec 2022 15:11:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63D8B1946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Dec 2022 15:11:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4555540C83EC; Sat,  3 Dec 2022 15:11:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DC8240C2088
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 15:11:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 214C13C01E1A
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 15:11:00 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-558-atFOnwXfNpqjp4Y8d-Unug-1; Sat, 03 Dec 2022 10:10:58 -0500
X-MC-Unique: atFOnwXfNpqjp4Y8d-Unug-1
Received: by mail-wr1-f44.google.com with SMTP id o5so12233825wrm.1;
 Sat, 03 Dec 2022 07:10:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:cc:content-language
 :references:to:subject:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=wcx+BfCSph6GYIzhZR+seg9egTxGX17jfZ4NjS1lpec=;
 b=UV8uY3u/yvFMJ3FebVgqhlYaNAKYVXDbhk1b1pl0fpdhuiVhkwqGDUeJ3fOVkJEIPo
 1xlXrEEfqI/fxG1Q97SLH9k3pgojX310dy7PvpXYw8Pa+lLk9mQA1Vtc1yoWSk3ahzBj
 /Pcqk4XzDMn3sDOG6Aw8kjJxZUAoirCcut2sZZgo+7iMjQLFnHEJwDJiXykvDoNMA21H
 ZsdKq+JCgm3ws+y1wyH2EMsvK86hPXWX+PUu9jVkIxdUEwDchk9k6vUitxwE4Vkz7vZ9
 sFydcp/wzK5Li8t9Y92qwlcKH5zjiEfxSfd/wiotk0gYRjg8ly5++BdaQh9MYBZljyMc
 si3w==
X-Gm-Message-State: ANoB5pkKARJXYHoIuE7hNC6WMWMMruBR5fAm/avXW64D+UVMpVojqqNj
 eAu9/lIFM6WR8rUKbsN1SpUEdd7LgQ==
X-Google-Smtp-Source: AA0mqf6Wn9rU+/iEhc3gtYhAQuIv+PJXh+eeB+RFEhq2uBuRN3jMggiAfyIcR4AtNozmSiIvu3xBLw==
X-Received: by 2002:a5d:4b4c:0:b0:242:1d2f:8fd1 with SMTP id
 w12-20020a5d4b4c000000b002421d2f8fd1mr16366571wrs.518.1670080257146; 
 Sat, 03 Dec 2022 07:10:57 -0800 (PST)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 n36-20020a05600c502400b003cf6c2f9513sm12115172wmr.2.2022.12.03.07.10.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 03 Dec 2022 07:10:56 -0800 (PST)
Message-ID: <41d2ff77-05c8-dd18-b24f-e3ec6884dfb2@gmail.com>
Date: Sat, 3 Dec 2022 16:10:56 +0100
MIME-Version: 1.0
To: Benjamin Marzinski <bmarzins@redhat.com>
References: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 1/2] multipath.conf(5): remove io-affinity
 information
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>,
 Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11/30/22 05:56, bmarzins at redhat.com (Benjamin Marzinski) wrote:

> The multpath-tools do not support the io-affinity path selector.  We
> always add a repeat count as the path argument. The io-affinity selector
> doesn't take one. Instead it takes a bitmap of CPUs that a path can run
> on. This isn't something that lends itself to the kind of
> auto-assembling that multipathd does. But even if we did want to try to
> support this path-selector, until we do, we shouldn't be listing it in
> the multipath.conf documentation.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins at redhat.com>

> ---
>   multipath/multipath.conf.5 | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 1fea9d5a..3a45ac89 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -205,10 +205,6 @@ of outstanding I/O to the path and its relative throughput.
>   estimation of future service time based on the history of previous I/O submitted
>   to each path.
>   .TP
> -.I "io-affinity 0"
> -(Since 5.11 kernel) Choose the path for the next bunch of I/O based on a CPU to
> -path mapping the user passes in and what CPU we are executing on.
> -.TP
>   The default is: \fBservice-time 0\fR
>   .RE
>   .

I think the main, and only?, consumer for this path selector is Exadata.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FEE9C38142
	for <dm-devel@archiver.kernel.org>; Mon, 23 Jan 2023 05:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674450673;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oHOyvy5x5EoTpi22W+SLQFHQ8FPwfne6K+uWEU13ltE=;
	b=FZkYIYQiOqDwHXBoPTALggdrkVXLxdFA6n3LuN1qykb1nSJZtzk+SoZzhFcF03MC3PacB3
	0bYseVjgOlDp0yymIBodtk6QRt4nJUKOXaG39iDdjrvNgjK1F1P9hKYx590RDV67FfwBz5
	uTuckj2m+LUsDNs+dyQLy3ozcECuSMI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-kV9WvBrnNGmYUO7jIZYs-w-1; Mon, 23 Jan 2023 00:11:09 -0500
X-MC-Unique: kV9WvBrnNGmYUO7jIZYs-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4AF92999B24;
	Mon, 23 Jan 2023 05:11:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9421C40C1141;
	Mon, 23 Jan 2023 05:11:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6522B1946587;
	Mon, 23 Jan 2023 05:11:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C5A6D1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 Jan 2023 05:11:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B46391121331; Mon, 23 Jan 2023 05:11:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD0361121330
 for <dm-devel@redhat.com>; Mon, 23 Jan 2023 05:11:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CE433C01DF4
 for <dm-devel@redhat.com>; Mon, 23 Jan 2023 05:11:06 +0000 (UTC)
Received: from box.fidei.email (box.fidei.email [71.19.144.250]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-659-2CrirQQeNZOHFbCrJs94Aw-1; Mon,
 23 Jan 2023 00:11:03 -0500
X-MC-Unique: 2CrirQQeNZOHFbCrJs94Aw-1
Received: from authenticated-user (box.fidei.email [71.19.144.250])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
 (No client certificate requested)
 by box.fidei.email (Postfix) with ESMTPSA id 2682F804B6
 for <dm-devel@redhat.com>; Mon, 23 Jan 2023 00:11:02 -0500 (EST)
Message-ID: <210ba58b-a438-d860-9886-dce02b5e605b@dorminy.me>
Date: Mon, 23 Jan 2023 00:11:00 -0500
MIME-Version: 1.0
To: dm-devel@redhat.com
References: <alpine.LRH.2.21.2301221403390.15312@file01.intranet.prod.int.rdu2.redhat.com>
From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <alpine.LRH.2.21.2301221403390.15312@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 3/3] dm-flakey: fix logic when corruping a bio
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 1/22/23 14:03, Mikulas Patocka wrote:
> If "corrupt_bio_byte" is set to corrupt reads and corrupt_bio_flags is
> used, dm-flakey would errorneously return all writes as errors. Likewise,
                        ^erroneously^
> if "corrupt_bio_byte" is set to corrupt writes, dm-flakey would return
> errors for all reads.
> 
> This patch fixes the logic, so that if fc->corrupt_bio_byte is non-zero,
> dm-flakey would not abort reads on writes with an error.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> 
> ---
>   drivers/md/dm-flakey.c |   23 +++++++++++++----------
>   1 file changed, 13 insertions(+), 10 deletions(-)
> 
> Index: bcachefs/drivers/md/dm-flakey.c
> ===================================================================
> --- bcachefs.orig/drivers/md/dm-flakey.c	2023-01-22 17:22:10.000000000 +0100
> +++ bcachefs/drivers/md/dm-flakey.c	2023-01-22 17:22:10.000000000 +0100
> @@ -365,9 +365,11 @@ static int flakey_map(struct dm_target *
>   		/*
>   		 * Corrupt matching writes.
>   		 */
> -		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == WRITE)) {
> -			if (all_corrupt_bio_flags_match(bio, fc))
> -				corrupt_bio_data(bio, fc);
> +		if (fc->corrupt_bio_byte) {
> +			if ((fc->corrupt_bio_rw == WRITE)) {
> +				if (all_corrupt_bio_flags_match(bio, fc))
> +					corrupt_bio_data(bio, fc);
> +			}
>   			goto map_bio;
>   		}
>   
> @@ -393,13 +395,14 @@ static int flakey_end_io(struct dm_targe
>   		return DM_ENDIO_DONE;
>   
>   	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
> -		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
> -		    all_corrupt_bio_flags_match(bio, fc)) {
> -			/*
> -			 * Corrupt successful matching READs while in down state.
> -			 */
> -			corrupt_bio_data(bio, fc);
> -
> +		if (fc->corrupt_bio_byte) {
> +			if ((fc->corrupt_bio_rw == READ) &&
> +			    all_corrupt_bio_flags_match(bio, fc)) {
> +				/*
> +				 * Corrupt successful matching READs while in down state.
> +				 */
> +				corrupt_bio_data(bio, fc);
> +			}
>   		} else if (!test_bit(DROP_WRITES, &fc->flags) &&
>   			   !test_bit(ERROR_WRITES, &fc->flags)) {
>   			/*
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


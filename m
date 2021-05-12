Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BE3C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 12:58:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECCB461104
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 12:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECCB461104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620824301;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KxfWk9YOYQbZauM6nCVzWAAPbrDkrRIPOk9QghzX7SQ=;
	b=Qbv60noSlt9laICCKgU0o0KBVP3VEDnge0PSQqbHUEeRQFpWI6zBCIGhLdUL+kakcJsjlz
	rckvBJkpbzPHqitBEZhlq1uOQP+ELReXR3q/cvutqVr2DlzRNF3V6Ci4gN7kOxl0d9oDJ3
	D27Wqkav6A50EQvGlAWLIshIpVUJ9jM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-Vh-chygMOUC7s9u2GuNzqA-1; Wed, 12 May 2021 08:58:19 -0400
X-MC-Unique: Vh-chygMOUC7s9u2GuNzqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BA1C801107;
	Wed, 12 May 2021 12:58:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE3DF5D9C0;
	Wed, 12 May 2021 12:58:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1D3D61800BB0;
	Wed, 12 May 2021 12:58:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14CCwBEK028311 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 08:58:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 64B0520BA136; Wed, 12 May 2021 12:58:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F3BD20BEDD5
	for <dm-devel@redhat.com>; Wed, 12 May 2021 12:58:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDF2D108BDCB
	for <dm-devel@redhat.com>; Wed, 12 May 2021 12:58:07 +0000 (UTC)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
	[209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-364-WuRdKCZTMSy6cUBtiDMQEQ-1; Wed, 12 May 2021 08:58:04 -0400
X-MC-Unique: WuRdKCZTMSy6cUBtiDMQEQ-1
Received: by mail-wr1-f71.google.com with SMTP id
	h104-20020adf90710000b029010de8455a3aso10092742wrh.12
	for <dm-devel@redhat.com>; Wed, 12 May 2021 05:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=GEmuetu1zzgX4Z5Zaq0BQwSAkqXoUXM7dvSj9S9J3Cc=;
	b=sH3L8xCZIHYKkYg5hrTwec9Xf09V2ag8LjW38DnaQGjqfsXMyLydr3+HTcfWpPfWz0
	cN1DYMczgyGg4dfXhhkFiGtiE2Wo8IL3p+uWmH58Qx6ssSM89F73U/ZeDwSgbyvSwszj
	sgpIlmfR8lsoIH08eGHnbsjvYyzy2J2j8uubNrIt3HqO/fVo+u6E9gNAPhK7kqsl8PGk
	skYYucTYhy1bHUKkboZwbNCG5yUxYXNNWhefyv/KYtpk+N4zsssrwur9SKU/rq23igb+
	dNpkgtxKwDrqg003a7twa6gRo/FnZ0bkrsS9gUrpPUvrDlIxq5qjB+2DmCBBGo+h6vbP
	356Q==
X-Gm-Message-State: AOAM533O5C0TFGWvnwLrdAXhLaQnrecBJ0Bvm9TS822brcxF71Y8EArd
	PqEOltCYBYdvzMsQLXvQvODjUEcJPEXGaV3gj5g9MXfts5lOBdrzzHz/xb5jk5tu2RML+fIT8Qb
	q5mUVGGSxkNQ8Br4=
X-Received: by 2002:a05:600c:35c9:: with SMTP id
	r9mr11247953wmq.56.1620824282970; 
	Wed, 12 May 2021 05:58:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxd2yrvoNbErNiLgtI1mQTu5qEZOBopjXLTm7JhhHlCUxZpDpR/shWRLbCLLqXdXv0hLWiAbw==
X-Received: by 2002:a05:600c:35c9:: with SMTP id
	r9mr11247941wmq.56.1620824282781; 
	Wed, 12 May 2021 05:58:02 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	j13sm37350818wrd.81.2021.05.12.05.58.01
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 12 May 2021 05:58:02 -0700 (PDT)
To: Mike Snitzer <msnitzer@redhat.com>
References: <alpine.LRH.2.02.2105120827200.15893@file01.intranet.prod.int.rdu2.redhat.com>
From: Milan Broz <mbroz@redhat.com>
Message-ID: <dc18c781-a936-9e5c-2430-3795f81de504@redhat.com>
Date: Wed, 12 May 2021 14:58:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2105120827200.15893@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Melvin Vermeeren <vermeeren@vermwa.re>
Subject: Re: [dm-devel] [PATCH] dm-integrity: revert the discard patch
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/05/2021 14:28, Mikulas Patocka wrote:
> Revert the commit 7a5b96b4784454ba258e83dc7469ddbacd3aaac3 ("dm integrity:
> use discard support when recalculating").
> 
> There's a bug that when we write some data beyond the current recalculate
> boundary, the checksum will be rewritten with the discard filler later.
> And the data will no longer have integrity protection.
> 
> There's no easy fix for this case, so we revert the whole patch.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Ack. After some discussion with Mikulas, we concluded that revert is the best option here.

Even with additional flag it would be problematic.

I already mentioned one case (blkid reading non-written area) but from the discussion,
here is another problematic case:

If we use dm-integrity to detect bitrot (random device errors; bit flips etc), dm-integrity
should detect that even for unused sectors.

With the mentioned patch it can happen that such change is undetected.
(Discard filler is not a valid checksum.)

...

> 
> Index: linux-2.6/drivers/md/dm-integrity.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-integrity.c
> +++ linux-2.6/drivers/md/dm-integrity.c
...
> @@ -4579,7 +4570,7 @@ static void dm_integrity_dtr(struct dm_t
>  
>  static struct target_type integrity_target = {
>  	.name			= "integrity",
> -	.version		= {1, 9, 0},
> +	.version		= {1, 8, 0},

Not sure we can do that once it is in mainline.
Maybe safer is to set it to 1.10.0. (Question for Mike perhaps).

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


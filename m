Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77537C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 13:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659014968;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YVtSeJal/cLolTys6wQ4gB/uoUeaHGcyJ5lLI3TWggE=;
	b=YrCjP3PiXY0ev+WpFovwEYJTy77TKOmsSvkyiog5+JAYAY72bpQx3WuFGXnDE9Uj0h7DWC
	LjkTR7ctzLBJG6xi2nj5V84TQvYtvPOq4/9VtU41D4VGTiEvo7XDrBoOIJIorsCQMt/IMk
	5KlP6+n3scJv2+QdCYBJESzpj3JQlIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-LIvs_51rMNmXuMi0Ki0f3Q-1; Thu, 28 Jul 2022 09:29:25 -0400
X-MC-Unique: LIvs_51rMNmXuMi0Ki0f3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55232801755;
	Thu, 28 Jul 2022 13:29:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A73E2166B26;
	Thu, 28 Jul 2022 13:29:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E1A251945DA7;
	Thu, 28 Jul 2022 13:29:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 694EA1945D85
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 13:29:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 480E8492CA2; Thu, 28 Jul 2022 13:29:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43F08492C3B
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 13:29:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CDA4101A596
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 13:29:16 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-bb2Drj0_O3Gf627Aj-KR1g-1; Thu, 28 Jul 2022 09:29:14 -0400
X-MC-Unique: bb2Drj0_O3Gf627Aj-KR1g-1
Received: by mail-pl1-f174.google.com with SMTP id p1so1787389plr.11
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 06:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=KVAZ1OoYcDPkaYDmhjB+rFFypTllysidvXvCw8//pAg=;
 b=qzmhA5NDuuXuRbSupfM0Jmp4cDqSY85NmyNmCTLrRVYLR0ML7TxlzLhsv7FzvW6FPI
 c0A7bFLwAZSQd28NAXQZIgSl3E1bCnRXm9NhYOawVdruHYtZBedZPHJzcOae7SHZo0ln
 kEQPT/JrFv+xfe60XGi74dMuTgUzWGzMWxepr6PdJOOABmP6XUrg0dbV3pxDO9M1URYT
 lEk3fwfx5ZPkiz31vPqXptij4W2dnE31GhEA5YT3Tx6WzeeYCldnjeCeFEHuJbRMZjF6
 /1Bi+ANv8WgW+9yqF57yHNcxrUSr8x0MxGqNfrbk0Kpc5zxAP+3kmeTUuLwi2kBxju0I
 a7CA==
X-Gm-Message-State: AJIora+XKgAUi27T/H8n61Hx8/G4sB3wHzxUAPHrToZ6YIn14Tjyaz6k
 bpXXUtmhmN0DjRpc4QHYydk=
X-Google-Smtp-Source: AGRyM1sVlJ4VxZdri5AJaXpK+abw9sqfSjFByJuWKJUf33Qsr5XtcruBoEo93wrUA8fG42N8cHOiXg==
X-Received: by 2002:a17:902:70c4:b0:16c:5306:9172 with SMTP id
 l4-20020a17090270c400b0016c53069172mr26736583plt.171.1659014952312; 
 Thu, 28 Jul 2022 06:29:12 -0700 (PDT)
Received: from [192.168.3.217] ([98.51.102.78])
 by smtp.gmail.com with ESMTPSA id
 h1-20020aa796c1000000b0052b66304d54sm742466pfq.74.2022.07.28.06.29.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 Jul 2022 06:29:11 -0700 (PDT)
Message-ID: <514f85ce-84fc-1186-7169-a29d7118e8cc@acm.org>
Date: Thu, 28 Jul 2022 06:29:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, damien.lemoal@opensource.wdc.com,
 hch@lst.de, axboe@kernel.dk, snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9@eucas1p2.samsung.com>
 <20220727162245.209794-3-p.raghav@samsung.com>
 <7984b969-9025-6b31-2645-da08daeefafb@acm.org>
 <eed7d9ee-fd7f-e57c-598e-909dbb0d2380@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <eed7d9ee-fd7f-e57c-598e-909dbb0d2380@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v8 02/11] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 7/28/22 05:11, Pankaj Raghav wrote:
> On 2022-07-28 01:16, Bart Van Assche wrote:
>> The bdev_is_zone_start() name seems more clear to me than
>> bdev_is_zone_aligned(). Has there already been a discussion about which
>> name to use for this function?
>>
> The reason I did s/bdev_is_zone_start/bdev_is_zone_aligned is that this
> name makes more sense for also checking if a given size is a multiple of
> zone sectors for e.g., used in PATCH 9:
> 
> -		if (len & (zone_sectors - 1)) {
> +		if (!bdev_is_zone_aligned(bdev, len)) {
> 
> I felt `bdev_is_zone_aligned` fits the use case of checking if the
> sector starts at the start of a zone and also check if a given length of
> sectors also align with the zone sectors. bdev_is_zone_start does not
> make the intention clear for the latter use case IMO.
> 
> But I am fine with going back to bdev_is_zone_start if you and Damien
> feel strongly otherwise.
The "zone start LBA" terminology occurs in ZBC-1, ZBC-2 and ZNS but 
"zone aligned" not. I prefer "zone start" because it is clear, 
unambiguous and because it has the same meaning as in the corresponding 
standards documents. I propose to proceed as follows for checking 
whether a number of LBAs is a multiple of the zone length:
* Either use bdev_is_zone_start() directly.
* Or introduce a synonym for bdev_is_zone_start() with an appropriate 
name, e.g. bdev_is_zone_len_multiple().

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


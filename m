Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE5FC6FA82
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 20:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662152130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=03bhZeDJWvQxBFmvDG65YoUxua0yAXA5zhf4u/J2vRs=;
	b=ZsK0TCgs0daIonYBiteupGd2bIZkZUkosqnbSb+6kgmAa31dtN/HDsQZPQLIXhyBTAvGlr
	Aj5ya+EA5953E5ap3RNxNzTseW2zJthc75sbNqwLJ/eNDOE6qqM1K+pm2162P80sdWAtw6
	5O9PSI2tO8DcPufmD1/DDdIDz9Qcg7o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-0-ZzM2MUNe20l5BD5MYdfw-1; Fri, 02 Sep 2022 16:55:27 -0400
X-MC-Unique: 0-ZzM2MUNe20l5BD5MYdfw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE9CA18A01AD;
	Fri,  2 Sep 2022 20:55:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 554A5492C3B;
	Fri,  2 Sep 2022 20:55:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2FB17194B966;
	Fri,  2 Sep 2022 20:55:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EF8C1946A42
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Sep 2022 20:55:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82F37112131E; Fri,  2 Sep 2022 20:55:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F0E21121314
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 20:55:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 621293810782
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 20:55:22 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-5-uZURZ1IBPZ6jnlNaNs4Zyg-1; Fri, 02 Sep 2022 16:55:21 -0400
X-MC-Unique: uZURZ1IBPZ6jnlNaNs4Zyg-1
Received: by mail-qk1-f200.google.com with SMTP id
 j13-20020a05620a288d00b006be7b2a758fso2861657qkp.1
 for <dm-devel@redhat.com>; Fri, 02 Sep 2022 13:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=e/i1xNela7arfufOlEWSIrFxi0oQo+ouwTHhQRBJeIY=;
 b=5fbtqzjPBaxamX06OP7jpMpeam2UTOrl0gNr1iBVvXZkGExYs0AR8IZu5gWdrWI6de
 SiPHvaE+3xfY5TP8EDYkb8mhVWbOHEFI7xuSbx42ZQ9EOPC6e/CVk5AK505FOiLIzDnL
 XyUYuxEuBiHVFNldZpDw3oMpXl3BpXI7xm2PO/wDcBOPz3BHd2leinIGcXxMWBFQ/PBy
 cl6xmgkGiZospkOP9VwuRZdGgjk2xkQ/7fJC1WaOnNY1W/uPoRHKVrY4vq1GShu/ZJHF
 +UEkcA5rfauLXsaT7Skvg+P+1XLufKgJ0wVe/ko/XkB2GCz6Ye1zkDcGsfRPAPUTi4t7
 ci2w==
X-Gm-Message-State: ACgBeo1RvKr7DAxzFwGhBLu+/V97fuiax0N/vOsite7yS4OjgFRH61aB
 0KNWTVSL65M/EdH+asntKXo/iuTV/5w4LdqUwLTln4hoKxW+yul8E+92oVuLWkUi0DUW/FTMOQE
 XAqbi1JZFE85dlw==
X-Received: by 2002:ac8:574f:0:b0:344:5a94:28fc with SMTP id
 15-20020ac8574f000000b003445a9428fcmr30044830qtx.670.1662152120812; 
 Fri, 02 Sep 2022 13:55:20 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7htZ5gZN01TeQlX/VJoxT2IaqgKvr8JeqKIGVMnyaeNem7TxDPPSJJMlag+j644UTpDAvlmQ==
X-Received: by 2002:ac8:574f:0:b0:344:5a94:28fc with SMTP id
 15-20020ac8574f000000b003445a9428fcmr30044821qtx.670.1662152120587; 
 Fri, 02 Sep 2022 13:55:20 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 fw10-20020a05622a4a8a00b0034361fb2f75sm1584123qtb.22.2022.09.02.13.55.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Sep 2022 13:55:19 -0700 (PDT)
Date: Fri, 2 Sep 2022 16:55:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YxJttvB2Z5I58SQ5@redhat.com>
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de@eucas1p1.samsung.com>
 <20220823121859.163903-14-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220823121859.163903-14-p.raghav@samsung.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v12 13/13] dm: add power-of-2 target for
 zoned devices with non power-of-2 zone sizes
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 23 2022 at  8:18P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> Only zoned devices with power-of-2(po2) number of sectors per zone(zone
> size) were supported in linux but now non power-of-2(npo2) zone sizes
> support has been added to the block layer.
> 
> Filesystems such as F2FS and btrfs have support for zoned devices with
> po2 zone size assumption. Before adding native support for npo2 zone
> sizes, it was suggested to create a dm target for npo2 zone size device to
> appear as a po2 zone size target so that file systems can initially
> work without any explicit changes by using this target.
> 
> The design of this target is very simple: remap the device zone size to
> the zone capacity and change the zone size to be the nearest power of 2
> value.
> 
> For e.g., a device with a zone size/capacity of 3M will have an equivalent
> target layout as follows:
> 
> Device layout :-
> zone capacity = 3M
> zone size = 3M
> 
> |--------------|-------------|
> 0             3M            6M
> 
> Target layout :-
> zone capacity=3M
> zone size = 4M
> 
> |--------------|---|--------------|---|
> 0             3M  4M             7M  8M
> 
> The area between target's zone capacity and zone size will be emulated
> in the target.
> The read IOs that fall in the emulated gap area will return 0 filled
> bio and all the other IOs in that area will result in an error.
> If a read IO span across the emulated area boundary, then the IOs are
> split across them. All other IO operations that span across the emulated
> area boundary will result in an error.
> 
> The target can be easily created as follows:
> dmsetup create <label> --table '0 <size_sects> po2zone /dev/nvme<id>'
> 
> Note that the target does not support partial mapping of the underlying
> device.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Suggested-by: Hannes Reinecke <hare@suse.de>


This target needs more review from those who Suggested-by it.

And the header and docs needs to address:

1) why is a partial mapping of the underlying device disallowed?
2) why is it assumed all IO is read-only? (talk to me and others like
   we don't know the inherent limitations of this class of zoned hw)

On a code level:
1) are you certain you're properly failing all writes?
   - are writes allowed to the "zone capacity area" but _not_
     allowed to the "emulated zone area"? (if yes, _please document_). 
2) yes, you absolutely need to implement the .status target_type hook
   (for both STATUS and TABLE).
3) really not loving the nested return (of DM_MAPIO_SUBMITTED or
   DM_MAPIO_REMAPPED) from methods called from dm_po2z_map().  Would
   prefer to not have to do a depth-first search to see where and when
   dm_po2z_map() returns a DM_MAPIO_XXX unless there is a solid
   justification for it.  To me it just obfuscates the DM interface a
   bit too much. 

Otherwise, pretty clean code and nothing weird going on.

I look forward to seeing your next (final?) revision of this patchset.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


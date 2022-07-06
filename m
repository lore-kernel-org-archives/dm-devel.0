Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE9BC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657111636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bw/H/mYgje+ionWxPSz/hp4xmhh7nAwfc6FSDQ8fGMY=;
	b=SN4DBEm7P0yAAdU2L1GBhqSFfN/XvSARcN/tnn1noYOgKhJYqDavAXQhwKD6f8jrLkxXK5
	uVOY+LFVh4ENaX3S02qiZW4YHX/w+taLCPZM7CcO56frRiVUTgCazuf5aDLepr9fPmJcj7
	Ei/g4ruaysXzfvVGsEfxxeUuoTSxNyM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-opoXC9iyNcC3kjgQs0lvxA-1; Wed, 06 Jul 2022 08:47:13 -0400
X-MC-Unique: opoXC9iyNcC3kjgQs0lvxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A02771C16B4A;
	Wed,  6 Jul 2022 12:47:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BBFD2026D64;
	Wed,  6 Jul 2022 12:47:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA9FD1947063;
	Wed,  6 Jul 2022 12:47:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 444CA194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 12:47:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 25D51492CA2; Wed,  6 Jul 2022 12:47:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22110492C3B
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 12:47:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AB511C16B4E
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 12:47:09 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-uFQcmq5kO_-f1FsaZQi_rw-1; Wed, 06 Jul 2022 08:47:07 -0400
X-MC-Unique: uFQcmq5kO_-f1FsaZQi_rw-1
Received: by mail-pf1-f173.google.com with SMTP id t3so1106358pfq.10
 for <dm-devel@redhat.com>; Wed, 06 Jul 2022 05:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=dWSt263Qaw0m9Glsw02JwFApleRJFRb/cK5wUXMCZwk=;
 b=498aKxJIk0ScCG+4GeY13J17SjFxep/fcW7HCmnN161I53fr6RUp85GzSc07CbO68p
 0K5Lcsk46aWoL2JS1d4Oee9/ZVFavtgHLIrHJfpzYoW+5w5UxvjW1LgjUEc/m0N8Dt5v
 ow+ZWvxJvrKUt+MDZN+2F3iipgtze0zuqKQhYe3O1rf0F2CnBmlFkQTTCF4PEkDz8dwU
 TGe7MDP3f5njKZpBgrZKuJ5X8wV0hXcnXCRvHP0E2ZmVuzFtkw18+g8iIZA5xsi+VkC3
 b3z+Py4o1cQqalc4a0Ia7GfBTDLzcnpaupaa8tMzhV+DrdwMQIuulEKH0di8q4b+NB/L
 s/XQ==
X-Gm-Message-State: AJIora8wmKegww9jiaQE+asxn6ohwvyIBpaKf+XaFZ33xKOkC91Gsf33
 mkdZ9RE2Cv8Y8nSK2cFV56ftxw==
X-Google-Smtp-Source: AGRyM1vbTy3ndf+pSCLNGkm7VeLniHNquKUECZA2Rht1+4+EvHZMthqZzry/qox4vZy8sRhwMJ6GMg==
X-Received: by 2002:aa7:94ad:0:b0:525:265b:991f with SMTP id
 a13-20020aa794ad000000b00525265b991fmr47728895pfl.30.1657111619892; 
 Wed, 06 Jul 2022 05:46:59 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157]) by smtp.gmail.com with ESMTPSA id
 by5-20020a056a00400500b0052521fd6caesm17610237pfb.111.2022.07.06.05.46.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 05:46:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: damien.lemoal@opensource.wdc.com, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
References: <20220706070350.1703384-1-hch@lst.de>
Message-Id: <165711161869.295759.6786523664338969947.b4-ty@kernel.dk>
Date: Wed, 06 Jul 2022 06:46:58 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] clean up zoned device information v2
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 6 Jul 2022 09:03:34 +0200, Christoph Hellwig wrote:
> this cleans up the block layer zoned device information APIs and
> moves all fields currently in the request_queue to the gendisk as
> they aren't relevant for passthrough I/O.
> 
> Changes since v1:
>  - drop the blk-zoned/nvmet code sharing for now
>  - use a helper a little earlier
>  - various spelling fixes
> 
> [...]

Applied, thanks!

[01/16] block: remove a superflous ifdef in blkdev.h
        commit: f1a8bbd1100d9cd117bc8b7fc0903982bbaf474f
[02/16] block: call blk_queue_free_zone_bitmaps from disk_release
        commit: 6cc37a672a1e21245b931722a016b3bd4ae10e2d
[03/16] block: use bdev_is_zoned instead of open coding it
        commit: edd1dbc83b1de3b98590b76e09b86ddf6887fce7
[04/16] block: simplify blk_mq_plug
        commit: 6deacb3bfac2b720e707c566549a7041f17db9c8
[05/16] block: simplify blk_check_zone_append
        commit: 052e545c9276f97e86368579fda32aa1ac017d51
[06/16] block: pass a gendisk to blk_queue_set_zoned
        commit: 6b2bd274744e6454ba7bbbe6a09b44866f2f414a
[07/16] block: pass a gendisk to blk_queue_clear_zone_settings
        commit: b3c72f8138b5f967a9fa527af84b35018897aba3
[08/16] block: pass a gendisk to blk_queue_free_zone_bitmaps
        commit: 5d40066567a73a67ddb656ad118c6cfa1c4a6d71
[09/16] block: remove queue_max_open_zones and queue_max_active_zones
        commit: 1dc0172027b0aa09823b430e395b1116d2745f36
[10/16] block: pass a gendisk to blk_queue_max_open_zones and blk_queue_max_active_zones
        commit: 982977df48179c8c690868f398051074e68eef0f
[11/16] block: replace blkdev_nr_zones with bdev_nr_zones
        commit: b623e347323f6464b20fb0d899a0a73522ed8f6c
[12/16] block: use bdev based helpers in blkdev_zone_mgmt{,all}
        commit: 375c140c199ebd2866f9c50a0b8853ffca3f1b68
[13/16] nvmet:: use bdev based helpers in nvmet_bdev_zone_mgmt_emulate_all
        commit: a239145ad18b59338a2b6c419c1a15a0e52d1315
[14/16] dm-zoned: cleanup dmz_fixup_devices
        commit: fabed68c272389db85655a2933737d602f4008fb
[15/16] block: remove blk_queue_zone_sectors
        commit: de71973c2951cb2ce4b46560f021f03b15906408
[16/16] block: move zone related fields to struct gendisk
        commit: d86e716aa40643e3eb8c69fab3a198146bf76dd6

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


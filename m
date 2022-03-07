Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31472C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 13:43:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-Rxs1cIeaPs6ZCu6Ox_3YAA-1; Mon, 07 Mar 2022 08:43:29 -0500
X-MC-Unique: Rxs1cIeaPs6ZCu6Ox_3YAA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 963CD85A5BC;
	Mon,  7 Mar 2022 13:43:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 36B0D584AC9;
	Mon,  7 Mar 2022 13:43:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD2F01931BEA;
	Mon,  7 Mar 2022 13:43:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F55D1931BE9
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 13:43:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 066612024CAE; Mon,  7 Mar 2022 13:43:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 00E502024CC7
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 13:43:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1854D80281F
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 13:43:04 +0000 (UTC)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-CP3MbO0ZNoyJlULLBFInVg-1; Mon, 07 Mar 2022 08:42:57 -0500
X-MC-Unique: CP3MbO0ZNoyJlULLBFInVg-1
Received: by mail-pg1-f173.google.com with SMTP id t14so13598302pgr.3
 for <dm-devel@redhat.com>; Mon, 07 Mar 2022 05:42:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=dO6x0urderFyV2KEmYHOZGi+h8qzVo3thAZZhX59WVI=;
 b=kbto7gN9dpqzzpIW6DWvzW4nxaLTqlLk3kRrttxJAvtbxNOPOFv6VXqYpBUdjAH3Ge
 d8caWpOdL8fNjAyqvDUkkxFui3KzJl8OJ1noQzm+20p7F/9+zF2YAKuHZJqy7lNp46XX
 /IZY9OwZWPJP4K3jtW7ceIQWozcaJ28Z/P12BLLMoXOn90iLYol//UGiQ7nApkxxisUs
 fHTDeykrWZO6yq++MkPq1HtDoJiu9uoJZ4gEIQk7QUj3FHsC55IN1rpeoommMS1LGnMf
 3tro9CY+T039JR5XUCy/1IQ/au/LLrJpZQh8U8nPoRQsVyQDejRWKlZw2i4Aw+jssc93
 ECqQ==
X-Gm-Message-State: AOAM532wXAxj6Bu/U83c1R4Yi/aUW54tNyRsrvWDZkdK6D8EIIOhBXe4
 NOT+xQuDO7B1pOGYdtpwQ3bgC5B6rXi9GRU8
X-Google-Smtp-Source: ABdhPJw5/FtlFVkWiR7cSvl2rHTtKJ6vmy5dszUzno3/VlrXoUuSSW3LtUf6Iv+dMHFIDtyxNHJnyA==
X-Received: by 2002:a63:6908:0:b0:372:d919:82ed with SMTP id
 e8-20020a636908000000b00372d91982edmr10020149pgc.104.1646660575327; 
 Mon, 07 Mar 2022 05:42:55 -0800 (PST)
Received: from [127.0.1.1] ([198.8.77.157]) by smtp.gmail.com with ESMTPSA id
 78-20020a621451000000b004f6e8a033b5sm6745253pfu.142.2022.03.07.05.42.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Mar 2022 05:42:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20220304180105.409765-1-hch@lst.de>
References: <20220304180105.409765-1-hch@lst.de>
Message-Id: <164666057398.15541.7415780807920631127.b4-ty@kernel.dk>
Date: Mon, 07 Mar 2022 06:42:53 -0700
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] remove bio_devname
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
Cc: linux-raid@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 linux-block@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 linux-ext4@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 4 Mar 2022 19:00:55 +0100, Christoph Hellwig wrote:
> this series removes the bio_devname helper and just switches all users
> to use the %pg format string directly.
> 
> Diffstat
>  block/bio.c               |    6 ------
>  block/blk-core.c          |   25 +++++++------------------
>  drivers/block/pktcdvd.c   |    9 +--------
>  drivers/md/dm-crypt.c     |   10 ++++------
>  drivers/md/dm-integrity.c |    5 ++---
>  drivers/md/md-multipath.c |    9 ++++-----
>  drivers/md/raid1.c        |    5 ++---
>  drivers/md/raid5-ppl.c    |   13 ++++---------
>  fs/ext4/page-io.c         |    5 ++---
>  include/linux/bio.h       |    2 --
>  10 files changed, 26 insertions(+), 63 deletions(-)
> 
> [...]

Applied, thanks!

[01/10] block: fix and cleanup bio_check_ro
        commit: 57e95e4670d1126c103305bcf34a9442f49f6d6a
[02/10] block: remove handle_bad_sector
        commit: ad740780bbc2fe37856f944dbbaff07aac9db9e3
[03/10] pktcdvd: remove a pointless debug check in pkt_submit_bio
        commit: 47c426d5241795cfcd9be748c44d1b2e2987ce70
[04/10] dm-crypt: stop using bio_devname
        commit: 66671719650085f92fd460d2a356c33f9198dd35
[05/10] dm-integrity: stop using bio_devname
        commit: 0a806cfde82fcd1fb856864e33d17c68d1b51dee
[06/10] md-multipath: stop using bio_devname
        commit: ee1925bd834418218c782c94e889f826d40b14d5
[07/10] raid1: stop using bio_devname
        commit: ac483eb375fa4a815a515945a5456086c197430e
[08/10] raid5-ppl: stop using bio_devname
        commit: c7dec4623c9cde20dad8de319d177ed6aa382aaa
[09/10] ext4: stop using bio_devname
        commit: 734294e47a2ec48fd25dcf2d96cdf2c6c6740c00
[10/10] block: remove bio_devname
        commit: 97939610b893de068c82c347d06319cd231a4602

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


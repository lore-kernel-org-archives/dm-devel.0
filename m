Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D9CEB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 07:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686813747;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Bd9XtvfQ9ragwhk98pNtDljjy1PTMwupfQJ2tMREO+g=;
	b=Mak1N67R/h2GyO7/omejIONPKMVT+MJSTCt82wIswZjaYv8kjTBbWLDAcIDxhpGeiWAyIE
	HJY6asvqQ/bLXGRxCa+qjxFeSv1lLcH3OV5LlQaRjzM/NiTaZ6SRfJR0HVb1YGQL86I9dq
	HU++2TGPtESnJebh1YCuVBuSsi7cY5c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-wNBgGMi2ON-MJhu1miK0VQ-1; Thu, 15 Jun 2023 03:22:25 -0400
X-MC-Unique: wNBgGMi2ON-MJhu1miK0VQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FB6329ABA0B;
	Thu, 15 Jun 2023 07:22:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B00940C5C1;
	Thu, 15 Jun 2023 07:22:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C8E691946589;
	Thu, 15 Jun 2023 07:22:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1DF21194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 12:59:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 06685492CAC; Wed, 14 Jun 2023 12:59:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1E1F492CA6
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 12:59:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2E75101A56C
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 12:59:31 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-Z9fnWUWaMeyBqMsYRxXj0w-1; Wed, 14 Jun 2023 08:59:24 -0400
X-MC-Unique: Z9fnWUWaMeyBqMsYRxXj0w-1
Received: by mail-wm1-f53.google.com with SMTP id
 5b1f17b1804b1-3f8d0e814dfso5420595e9.3
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 05:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686747562; x=1689339562;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=CQYW9mOPjib5Verqu2aVkise+ixOk+VQxpJDk3E7TUc=;
 b=QaY79NaC5ThOp8ZCV4+/VMLHpTHPcmqf6hVyZX4Ol2LtZKrWqqmVtxfVzZXotLzSF7
 wrw9Sr1qKtOrJj7XhD2pTJarIA7y580XdJ0HbePJxG2ejvTBn4A4V7xvia2NzTmrx6+j
 dEz69qI1UCZQ7cHB7NnfTfYZdcMV0Sizyhh5CtoipoXRkOnnNqfZwBUTm3HoiL9B5qZF
 u5uUfSdE57LqUaSoE3U8TTGHz5exHZJW/byp5KgFL1g2W5gYiPf3Dja/eaOISrWsIzqY
 R78/3oXcXmBpY3VabcKJB8PGbsI0PidPDyEYyR9T7pmN/csN5IGW/NrFT+hBv1PzKLmL
 agjA==
X-Gm-Message-State: AC+VfDyufyaQqqlpkF4qb1v5N2vyzGBesZOB5YysIU1fHOgfx/w1Y6vY
 NCJCGz/EwEVdb4oc8JEyNLd9NBvmyQJgqWz11q8=
X-Google-Smtp-Source: ACHHUZ6RvA3gssN0MmQl2kmj5S9HyfrKQRSPokhBCDSlpj5iB8JHNDPDGzKVTyTZcnH3uQwnC++aVg==
X-Received: by 2002:a5d:4d4d:0:b0:310:12f1:19e4 with SMTP id
 a13-20020a5d4d4d000000b0031012f119e4mr1698911wru.30.1686747561825; 
 Wed, 14 Jun 2023 05:59:21 -0700 (PDT)
Received: from localhost ([102.36.222.112]) by smtp.gmail.com with ESMTPSA id
 r3-20020a056000014300b00307972e46fasm18111601wrx.107.2023.06.14.05.59.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 14 Jun 2023 05:59:20 -0700 (PDT)
Date: Wed, 14 Jun 2023 15:59:13 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: mpatocka@redhat.com
Message-ID: <91f1ebed-fe93-4cd8-906a-2681313e98f5@moroto.mountain>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 15 Jun 2023 07:22:20 +0000
Subject: [dm-devel] [bug report] dm flakey: clone pages on write bio before
 corrupting them
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linaro.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Mikulas Patocka,

The patch 90ed93c305a0: "dm flakey: clone pages on write bio before
corrupting them" from May 1, 2023, leads to the following Smatch
static checker warning:

	drivers/md/dm.c:1157 clone_endio()
	warn: passing freed memory 'ti'

drivers/md/dm.c
    1105 static void clone_endio(struct bio *bio)
    1106 {
    1107         blk_status_t error = bio->bi_status;
    1108         struct dm_target_io *tio = clone_to_tio(bio);
    1109         struct dm_target *ti = tio->ti;
    1110         dm_endio_fn endio = ti->type->end_io;
    1111         struct dm_io *io = tio->io;
    1112         struct mapped_device *md = io->md;
    1113 
    1114         if (unlikely(error == BLK_STS_TARGET)) {
    1115                 if (bio_op(bio) == REQ_OP_DISCARD &&
    1116                     !bdev_max_discard_sectors(bio->bi_bdev))
    1117                         disable_discard(md);
    1118                 else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
    1119                          !bdev_write_zeroes_sectors(bio->bi_bdev))
    1120                         disable_write_zeroes(md);
    1121         }
    1122 
    1123         if (static_branch_unlikely(&zoned_enabled) &&
    1124             unlikely(bdev_is_zoned(bio->bi_bdev)))
    1125                 dm_zone_endio(io, bio);
    1126 
    1127         if (endio) {
    1128                 int r = endio(ti, bio, &error);

clone_endio() from drivers/md/dm-flakey.c frees "ti".  (Yes, I get
that "flakey" in the filename means it is supposed to crash but
presumably not in this way).

    1129 
    1130                 switch (r) {
    1131                 case DM_ENDIO_REQUEUE:
    1132                         if (static_branch_unlikely(&zoned_enabled)) {
    1133                                 /*
    1134                                  * Requeuing writes to a sequential zone of a zoned
    1135                                  * target will break the sequential write pattern:
    1136                                  * fail such IO.
    1137                                  */
    1138                                 if (WARN_ON_ONCE(dm_is_zone_write(md, bio)))
    1139                                         error = BLK_STS_IOERR;
    1140                                 else
    1141                                         error = BLK_STS_DM_REQUEUE;
    1142                         } else
    1143                                 error = BLK_STS_DM_REQUEUE;
    1144                         fallthrough;
    1145                 case DM_ENDIO_DONE:
    1146                         break;
    1147                 case DM_ENDIO_INCOMPLETE:
    1148                         /* The target will handle the io */
    1149                         return;
    1150                 default:
    1151                         DMCRIT("unimplemented target endio return value: %d", r);
    1152                         BUG();
    1153                 }
    1154         }
    1155 
    1156         if (static_branch_unlikely(&swap_bios_enabled) &&
--> 1157             unlikely(swap_bios_limit(ti, bio)))

Use after free.

    1158                 up(&md->swap_bios_semaphore);
    1159 
    1160         free_tio(bio);
    1161         dm_io_dec_pending(io, error);
    1162 }

regards,
dan carpenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


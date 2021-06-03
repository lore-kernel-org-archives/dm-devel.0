Return-Path: <SRS0=uf5V=K6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,FAKE_REPLY_A1,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B8AC4708F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 06:28:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6CF3B6140F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 06:28:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CF3B6140F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-wkyIo5n9Nn-xafggAsLs-w-1; Fri, 04 Jun 2021 02:27:56 -0400
X-MC-Unique: wkyIo5n9Nn-xafggAsLs-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B86D6D4E6;
	Fri,  4 Jun 2021 06:27:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C95D5D9F2;
	Fri,  4 Jun 2021 06:27:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D740E44A58;
	Fri,  4 Jun 2021 06:27:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 153MHLt7011736 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 18:17:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 39EAE11E5B0; Thu,  3 Jun 2021 22:17:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34FBD10FAA8
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 22:17:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D845085828E
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 22:17:15 +0000 (UTC)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-300-wHbVaGJdM4OoGA_bmyjzOw-1; Thu, 03 Jun 2021 18:17:11 -0400
X-MC-Unique: wHbVaGJdM4OoGA_bmyjzOw-1
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
	by youngberry.canonical.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.93)
	(envelope-from <colin.king@canonical.com>)
	id 1loveH-0002Cx-Vv; Thu, 03 Jun 2021 22:17:10 +0000
To: Damien Le Moal <damien.lemoal@wdc.com>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <7e7530a9-7939-2ad6-bfe1-d3aeeeed1f77@canonical.com>
Date: Thu, 3 Jun 2021 23:17:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Jun 2021 02:21:36 -0400
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] dm: Forbid requeue of writes to zones
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
X-Mimecast-Spam-Score: 1
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Static analysis with Coverity on Linux next has found and issue in
drivers/md/dm.c with the following commit:

commit 2c243153d1d4be4e23735cd10984ac17c7a54531
Author: Damien Le Moal <damien.lemoal@wdc.com>
Date:   Wed May 26 06:24:58 2021 +0900

    dm: Forbid requeue of writes to zones

The analysis is as follows:

 828 static void dec_pending(struct dm_io *io, blk_status_t error)
 829 {
 830        unsigned long flags;
 831        blk_status_t io_error;

    1. var_decl: Declaring variable bio without initializer.

 832        struct bio *bio;
 833        struct mapped_device *md = io->md;
 834
 835        /* Push-back supersedes any I/O errors */

    2. Condition !!error, taking true branch.

 836        if (unlikely(error)) {
 837                spin_lock_irqsave(&io->endio_lock, flags);

    3. Condition io->status == 11 /* (blk_status_t)11 */, taking false
branch.

 838                if (!(io->status == BLK_STS_DM_REQUEUE &&
__noflush_suspending(md)))
 839                        io->status = error;
 840                spin_unlock_irqrestore(&io->endio_lock, flags);
 841        }
 842

    4. Condition atomic_dec_and_test(&io->io_count), taking true branch.

 843        if (atomic_dec_and_test(&io->io_count)) {

    5. Condition io->status == 11 /* (blk_status_t)11 */, taking true
branch.

 844                if (io->status == BLK_STS_DM_REQUEUE) {
 845                        /*
 846                         * Target requested pushing back the I/O.
 847                         */
 848                        spin_lock_irqsave(&md->deferred_lock, flags);

    6. Condition __noflush_suspending(md), taking true branch.

 849                        if (__noflush_suspending(md) &&

Uninitialized pointer read
    7. uninit_use_in_call: Using uninitialized value bio when calling
dm_is_zone_write.

 850                            !WARN_ON_ONCE(dm_is_zone_write(md, bio)))
 851                                /* NOTE early return due to
BLK_STS_DM_REQUEUE below */
 852                                bio_list_add_head(&md->deferred,
io->orig_bio);

The pointer bio is not initialized and yet is being used in the call to
function dm_is_zone_write where pointer bio is being accessed. I'm not
sure what the original intent was, but this looks incorrect.

Colin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


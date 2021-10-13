Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D7CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7901E610F9
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7901E610F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=squashfs.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-CrmT4bPvMcqfb_e1DkcInw-1; Thu, 14 Oct 2021 03:53:13 -0400
X-MC-Unique: CrmT4bPvMcqfb_e1DkcInw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F80E91271;
	Thu, 14 Oct 2021 07:53:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1212960657;
	Thu, 14 Oct 2021 07:53:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DB9D4180598A;
	Thu, 14 Oct 2021 07:53:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DJe06G021866 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 15:40:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AB7432166B25; Wed, 13 Oct 2021 19:40:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5DF32166B2D
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:39:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE80D899EC5
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:39:57 +0000 (UTC)
Received: from p3plwbeout16-06.prod.phx3.secureserver.net
	(p3plsmtp16-06-2.prod.phx3.secureserver.net [173.201.193.64]) (Using
	TLS)
	by relay.mimecast.com with ESMTP id us-mta-321-z45myAJcO_OYnMrTNAGs8Q-1;
	Wed, 13 Oct 2021 15:39:55 -0400
X-MC-Unique: z45myAJcO_OYnMrTNAGs8Q-1
Received: from mailex.mailcore.me ([94.136.40.145]) by :WBEOUT: with ESMTP
	id ak3omLa57Jbs1ak3pmnUu5; Wed, 13 Oct 2021 12:37:09 -0700
X-CMAE-Analysis: v=2.4 cv=EqYXEQQA c=1 sm=1 tr=0 ts=61673565
	a=7e6w4QD8YWtpVJ/7+iiidw==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
	a=ggZhUymU-5wA:10 a=IkcTkHD0fZMA:10 a=8gfv0ekSlNoA:10 a=FXvPX3liAAAA:8
	a=Tqnnkb1RH65CB2acoZsA:9 a=QEXdDO2ut3YA:10 a=SM4aVyO6fsoA:10
	a=UxLD5KG5Eu0A:10 a=OunuuIp3J4_2X_e7vt2U:22 a=fDQtvUcBV1mJc6yKnRhE:22
	a=UObqyxdv-6Yh2QiB9mM_:22
X-SECURESERVER-ACCT: phillip@squashfs.org.uk
X-SID: ak3omLa57Jbs1
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175]
	helo=[192.168.178.33])
	by smtp01.mailcore.me with esmtpa (Exim 4.94.2)
	(envelope-from <phillip@squashfs.org.uk>)
	id 1mak3n-0001YR-Im; Wed, 13 Oct 2021 20:37:07 +0100
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211013051042.1065752-23-hch@lst.de>
From: Phillip Lougher <phillip@squashfs.org.uk>
Message-ID: <cbd3585f-87c6-ab31-2911-4d3550287e22@squashfs.org.uk>
Date: Wed, 13 Oct 2021 20:37:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-23-hch@lst.de>
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated: phillip@squashfs.org.uk
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfDjI5lpVVvOGft3jDxUtXkHyeTmJrFnF05ZC26xyaBmGu+g3IxlmGRKqtL6zLA8psVMMB/MT4J6Y5d+OIlzXEBD3TU/prapn1grgG7Gp4Eo8etN5pfPJ
	g1ZdVow33Dm130HF36Z9XZbHhDiGgv0qClFpTVJbD+sQMst03Jt+jwnonu/TCi80m7d0g93pY2tAJ0mKVy/XLovsOfshLoxOu9hTUJSpQpSZeGNzaBMAXEAc
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 14 Oct 2021 03:53:04 -0400
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org, drbd-dev@lists.linbit.com,
	linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, Kees Cook <keescook@chromium.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 22/29] squashfs: use bdev_nr_sectors instead
 of open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 13/10/2021 06:10, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Phillip Lougher <phillip@squashfs.org.uk>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


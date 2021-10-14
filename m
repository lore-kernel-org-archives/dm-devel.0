Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C336C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 06:33:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A57D961027
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 06:32:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A57D961027
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-5f_Qa_B-PFW0BHuI6_46hA-1; Thu, 14 Oct 2021 02:32:54 -0400
X-MC-Unique: 5f_Qa_B-PFW0BHuI6_46hA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78DFA1006AA2;
	Thu, 14 Oct 2021 06:32:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E5B885F4F5;
	Thu, 14 Oct 2021 06:32:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7B10D4A703;
	Thu, 14 Oct 2021 06:32:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19E6SrAU008529 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 14 Oct 2021 02:28:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 079712026D46; Thu, 14 Oct 2021 06:28:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0373F2026D5D
	for <dm-devel@redhat.com>; Thu, 14 Oct 2021 06:28:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 104A08001EA
	for <dm-devel@redhat.com>; Thu, 14 Oct 2021 06:28:50 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-165-OgfdEXQ3McGppIPXUaZeiw-1;
	Thu, 14 Oct 2021 02:28:48 -0400
X-MC-Unique: OgfdEXQ3McGppIPXUaZeiw-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5DA6768B05; Thu, 14 Oct 2021 08:28:44 +0200 (CEST)
Date: Thu, 14 Oct 2021 08:28:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20211014062844.GA25448@lst.de>
References: <20211013051042.1065752-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211013051042.1065752-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
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
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Anton Altaparmakov <anton@tuxera.com>,
	linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Phillip Lougher <phillip@squashfs.org.uk>, ntfs3@lists.linux.dev,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] don't use ->bd_inode to access the block device size
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 13, 2021 at 07:10:13AM +0200, Christoph Hellwig wrote:
> I wondered about adding a helper for looking at the size in byte units
> to avoid the SECTOR_SHIFT shifts in various places.  But given that
> I could not come up with a good name and block devices fundamentally
> work in sector size granularity I decided against that.

So it seems like the biggest review feedback is that we should have
such a helper.  I think the bdev_size name is the worst as size does
not imply a particular unit.  bdev_nr_bytes is a little better but I'm
not too happy.  Any other suggestions or strong opinions?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=r5Ec=PC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A689EC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:19:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 22E16610D2
	for <dm-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 22E16610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-1JNXezBzN7ypBCkdUAadzw-1; Thu, 14 Oct 2021 11:19:51 -0400
X-MC-Unique: 1JNXezBzN7ypBCkdUAadzw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E512993D;
	Thu, 14 Oct 2021 15:19:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FE8B1981F;
	Thu, 14 Oct 2021 15:19:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 771264EA2A;
	Thu, 14 Oct 2021 15:19:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19EFEZXn028066 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 14 Oct 2021 11:14:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7A4A4404727A; Thu, 14 Oct 2021 15:14:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 768924047272
	for <dm-devel@redhat.com>; Thu, 14 Oct 2021 15:14:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DEC3899EC0
	for <dm-devel@redhat.com>; Thu, 14 Oct 2021 15:14:35 +0000 (UTC)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
	[209.85.214.179]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-463-IUOchsSIPWWzQOv7dhWV0A-1; Thu, 14 Oct 2021 11:14:33 -0400
X-MC-Unique: IUOchsSIPWWzQOv7dhWV0A-1
Received: by mail-pl1-f179.google.com with SMTP id s1so2567131plg.12
	for <dm-devel@redhat.com>; Thu, 14 Oct 2021 08:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=kk58q1N6iOKJV9MmXM4g94KiVUwgBacQdDgb8dq+Hqc=;
	b=24epNHhuSqWMA4/NLJFEaqk/2KENIaLOWSLWpZwKFwiJGqCvSSYu5yMinJnCcoH2xR
	6yWodr/qKq5rHH2DTf2wDu+zMiHS4OCe/1Hr4vvi3V/lrQwbo5ZxUEMCiYkBVMwOQkjs
	t7cGX5xMRbXYVy71CigeEbBl80/9+B/8D8O/pC46bLjQzVnSQjuNWhhevEeiA8zzZvss
	ukMI3s5OOqwI4H2Rdj4nc5gJf+AsBymSpqY6YYr+Rmmp+zWhm+Fd36JMCZc7r9C4qgk8
	6MiJ6dmA2AUIKJrlHRdRS6BhHkAGJmVVgPxPoiUBiciDWePM6VZOsF0K5JNeTwa846Cz
	d8GQ==
X-Gm-Message-State: AOAM532duDEhjkPv5IOFJJ+7+qM0Heyk8AnejECqWEcBiKFORX7Kq6Wq
	/aQQxbFc2juXZu4+Qa8qzOBisVYRKbhZNw==
X-Google-Smtp-Source: ABdhPJz+A28iMSsGMew00w4bTffNulDM4PlP1p1A1+RouZBKHQoPJUsZrDvvxCBzVTavFWwP5kdepA==
X-Received: by 2002:a17:90a:86:: with SMTP id
	a6mr20774739pja.190.1634224472530; 
	Thu, 14 Oct 2021 08:14:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id w4sm2822114pfb.3.2021.10.14.08.14.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 14 Oct 2021 08:14:32 -0700 (PDT)
Date: Thu, 14 Oct 2021 08:14:31 -0700
From: Kees Cook <keescook@chromium.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Message-ID: <202110140813.44C95229@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
	<20211014062844.GA25448@lst.de>
	<3AB8052D-DD45-478B-85F2-BFBEC1C7E9DF@tuxera.com>
	<a5eb3c18-deb2-6539-cc24-57e6d5d3500c@oracle.com>
MIME-Version: 1.0
In-Reply-To: <a5eb3c18-deb2-6539-cc24-57e6d5d3500c@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Anton Altaparmakov <anton@tuxera.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	David Sterba <dsterba@suse.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jens Axboe <axboe@kernel.dk>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, "linux-ntfs-dev@lists.sourceforge.net"
	<linux-ntfs-dev@lists.sourceforge.net>, Jan Kara <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	"ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 14, 2021 at 08:13:59AM -0500, Dave Kleikamp wrote:
> On 10/14/21 4:32AM, Anton Altaparmakov wrote:
> > Hi Christoph,
> > 
> > > On 14 Oct 2021, at 07:28, Christoph Hellwig <hch@lst.de> wrote:
> > > 
> > > On Wed, Oct 13, 2021 at 07:10:13AM +0200, Christoph Hellwig wrote:
> > > > I wondered about adding a helper for looking at the size in byte units
> > > > to avoid the SECTOR_SHIFT shifts in various places.  But given that
> > > > I could not come up with a good name and block devices fundamentally
> > > > work in sector size granularity I decided against that.
> > > 
> > > So it seems like the biggest review feedback is that we should have
> > > such a helper.  I think the bdev_size name is the worst as size does
> > > not imply a particular unit.  bdev_nr_bytes is a little better but I'm
> > > not too happy.  Any other suggestions or strong opinions?
> > 
> > bdev_byte_size() would seem to address your concerns?
> > 
> > bdev_nr_bytes() would work though - it is analogous to bdev_nr_sectors() after all.
> > 
> > No strong opinion here but I do agree with you that bdev_size() is a bad choice for sure.  It is bound to cause bugs down the line when people forget what unit it is in.
> 
> I don't really mind bdev_size since it's analogous to i_size, but
> bdev_nr_bytes seems good to me.

I much prefer bdev_nr_bytes(), as "size" has no units.

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


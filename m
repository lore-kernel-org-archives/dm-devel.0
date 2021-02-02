Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B83C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 01:25:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACC2464EC6
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 01:25:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACC2464EC6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-RHAlT2QGMu2f7q9Z3mq7Zw-1; Mon, 01 Feb 2021 20:25:09 -0500
X-MC-Unique: RHAlT2QGMu2f7q9Z3mq7Zw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21892107ACE3;
	Tue,  2 Feb 2021 01:25:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 399E55D9DD;
	Tue,  2 Feb 2021 01:25:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5CCEA50038;
	Tue,  2 Feb 2021 01:25:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1121OxnR012396 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 20:24:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 97CEC2EF9C; Tue,  2 Feb 2021 01:24:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9276C1DB3B
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 01:24:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62F94811E91
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 01:24:57 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-327-dBOw3dfhOJWidYmU-uyX7g-1;
	Mon, 01 Feb 2021 20:24:53 -0500
X-MC-Unique: dBOw3dfhOJWidYmU-uyX7g-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id 2AD04360C1;
	Tue,  2 Feb 2021 04:24:51 +0300 (MSK)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Tue, 2 Feb 2021 02:24:49 +0100
Date: Tue, 2 Feb 2021 04:24:47 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20210202012447.GB2515@veeam.com>
References: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
	<5c6c936a-f213-eaa3-f4fb-3461a0b4dbe1@acm.org>
	<20210201181835.GA2515@veeam.com>
	<20210201185035.GA9977@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210201185035.GA9977@redhat.com>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265667660
X-Veeam-MMEX: True
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
Cc: Bart Van Assche <bvanassche@acm.org>, Pavel Tide <Pavel.TIde@veeam.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/2] block: blk_interposer v3
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 02/01/2021 21:50, Mike Snitzer wrote:
> On Mon, Feb 01 2021 at  1:18pm -0500,
> Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
> 
> > The 02/01/2021 18:45, Bart Van Assche wrote:
> > > On 1/28/21 9:12 AM, Sergei Shtepa wrote:
> > > > I`m ready to suggest the blk_interposer again.
> > > > blk_interposer allows to intercept bio requests, remap bio to
> > > > another devices or add new bios.
> > > > 
> > > > This version has support from device mapper.
> > > > 
> > > > For the dm-linear device creation command, the `noexcl` parameter
> > > > has been added, which allows to open block devices without
> > > > FMODE_EXCL mode. It allows to create dm-linear device on a block
> > > > device with an already mounted file system.
> > > > The new ioctl DM_DEV_REMAP allows to enable and disable bio
> > > > interception.
> > > > 
> > > > Thus, it is possible to add the dm-device to the block layer stack
> > > > without reconfiguring and rebooting.
> > > 
> > > What functionality does this driver provide that is not yet available in 
> > > a RAID level 1 (mirroring) driver + a custom dm driver? My understanding 
> > > is that there are already two RAID level 1 drivers in the kernel tree 
> > > and that both driver support sending bio's to two different block devices.
> > > 
> > > Thanks,
> > > 
> > > Bart.
> > 
> > Hi Bart.
> > 
> > The proposed patch is not realy aimed at RAID1.
> > 
> > Creating a new dm device in the non-FMODE_EXCL mode and then remaping bio
> > requests from the regular block device to the new DM device using
> > the blk_interposer will allow to use device mapper for regular devices.
> > For dm-linear, there is not much benefit from using blk_interposer.
> > This is a good and illustrative example. Later, using blk-interposer,
> > it will be possible to connect the dm-cache "on the fly" without having
> > to reboot and/or reconfigure.
> > My intention is to let users use dm-snap to create snapshots of any device.
> > blk-interposer will allow to add new features to Device Mapper.
> > 
> > As per Daniel's advice I want to add a documentation, I'm working on it now.
> > The documentation will also contain a description of new features that
> > blk_interposer will add to Device Mapper
> 
> More Documentation is fine, but the code needs to be improved and fully
> formed before you start trying to polish with Documentation --
> definitely don't put time to Documentation that is speculative!
> 
> You'd do well to focus on an implementation that doesn't require an
> extra clone if interposed device will use DM (DM core already handles
> cloning all incoming bios).
> 
> Mike
> 

Hi Mike.

I agree that quality code is more important than documentation.
And I think this code has already solved the problem of a bio extra cloning.

+static void dm_remap_fn(void *context, struct dm_rb_range *node, struct bio *bio)
+{
+	struct mapped_device *md = context;
+
+	/* Set acceptor device. */
+	bio->bi_disk = md->disk;
+
+	/* Remap disks offset */
+	bio->bi_iter.bi_sector -= node->start;
+
+	/*
+	 * bio should be resubmitted.
+	 * We can just add bio to bio_list of the current process.
+	 * current->bio_list must be initialized when this function is called.
+	 * If call submit_bio_noacct(), the bio will be checked twice.
+	 */
+	BUG_ON(!current->bio_list);
+	bio_list_add(&current->bio_list[0], bio);
+}

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


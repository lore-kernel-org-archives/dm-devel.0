Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAFCC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 18:19:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A4B5A64E50
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 18:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4B5A64E50
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-xjF60WvXPSa_CO4NrpwHgg-1; Mon, 01 Feb 2021 13:19:06 -0500
X-MC-Unique: xjF60WvXPSa_CO4NrpwHgg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BC1F59;
	Mon,  1 Feb 2021 18:18:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19DAC10016DB;
	Mon,  1 Feb 2021 18:18:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5E4E180954D;
	Mon,  1 Feb 2021 18:18:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 111IIrnv028912 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 13:18:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0AB92909FE; Mon,  1 Feb 2021 18:18:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0512939CCE
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 18:18:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8494800198
	for <dm-devel@redhat.com>; Mon,  1 Feb 2021 18:18:50 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-510-GiEvBdgONF60XIxe32gZxw-1;
	Mon, 01 Feb 2021 13:18:46 -0500
X-MC-Unique: GiEvBdgONF60XIxe32gZxw-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id 49F224114C;
	Mon,  1 Feb 2021 13:18:42 -0500 (EST)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Mon, 1 Feb 2021 19:18:40 +0100
Date: Mon, 1 Feb 2021 21:18:35 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20210201181835.GA2515@veeam.com>
References: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
	<5c6c936a-f213-eaa3-f4fb-3461a0b4dbe1@acm.org>
MIME-Version: 1.0
In-Reply-To: <5c6c936a-f213-eaa3-f4fb-3461a0b4dbe1@acm.org>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D26566776A
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
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 02/01/2021 18:45, Bart Van Assche wrote:
> On 1/28/21 9:12 AM, Sergei Shtepa wrote:
> > I`m ready to suggest the blk_interposer again.
> > blk_interposer allows to intercept bio requests, remap bio to
> > another devices or add new bios.
> > 
> > This version has support from device mapper.
> > 
> > For the dm-linear device creation command, the `noexcl` parameter
> > has been added, which allows to open block devices without
> > FMODE_EXCL mode. It allows to create dm-linear device on a block
> > device with an already mounted file system.
> > The new ioctl DM_DEV_REMAP allows to enable and disable bio
> > interception.
> > 
> > Thus, it is possible to add the dm-device to the block layer stack
> > without reconfiguring and rebooting.
> 
> What functionality does this driver provide that is not yet available in 
> a RAID level 1 (mirroring) driver + a custom dm driver? My understanding 
> is that there are already two RAID level 1 drivers in the kernel tree 
> and that both driver support sending bio's to two different block devices.
> 
> Thanks,
> 
> Bart.

Hi Bart.

The proposed patch is not realy aimed at RAID1.

Creating a new dm device in the non-FMODE_EXCL mode and then remaping bio
requests from the regular block device to the new DM device using
the blk_interposer will allow to use device mapper for regular devices.
For dm-linear, there is not much benefit from using blk_interposer.
This is a good and illustrative example. Later, using blk-interposer,
it will be possible to connect the dm-cache "on the fly" without having
to reboot and/or reconfigure.
My intention is to let users use dm-snap to create snapshots of any device.
blk-interposer will allow to add new features to Device Mapper.

As per Daniel's advice I want to add a documentation, I'm working on it now.
The documentation will also contain a description of new features that
blk_interposer will add to Device Mapper

Thanks.

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


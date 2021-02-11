Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D274C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 22:51:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 99F5C64D8F
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 22:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99F5C64D8F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quuxlogic.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-ybREau2jNsurGgvRrCZKEA-1; Thu, 11 Feb 2021 17:51:34 -0500
X-MC-Unique: ybREau2jNsurGgvRrCZKEA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F3051005501;
	Thu, 11 Feb 2021 22:51:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D7D75C1BD;
	Thu, 11 Feb 2021 22:51:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 84B1E4E58E;
	Thu, 11 Feb 2021 22:51:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BMpMhi004207 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 17:51:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 50F322166B2E; Thu, 11 Feb 2021 22:51:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BEE42166B2D
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 22:51:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6993A8032E3
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 22:51:19 +0000 (UTC)
Received: from e2i688.smtp2go.com (e2i688.smtp2go.com [103.2.142.176])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-499-lnZkWySsO8y6WUoptg1RqQ-1; Thu, 11 Feb 2021 17:51:17 -0500
X-MC-Unique: lnZkWySsO8y6WUoptg1RqQ-1
Received: from [10.66.228.43] (helo=SmtpCorp)
	by smtpcorp.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92-S2G) (envelope-from <j.schicke@quuxlogic.com>)
	id 1lAKnr-qt4EF8-FT
	for dm-devel@redhat.com; Thu, 11 Feb 2021 22:51:15 +0000
Received: from [10.94.217.231] (helo=eta-carinae)
	by smtpcorp.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92-S2G) (envelope-from <j.schicke@quuxlogic.com>)
	id 1lAKnq-wSEPfi-Cz
	for dm-devel@redhat.com; Thu, 11 Feb 2021 22:51:14 +0000
Date: Thu, 11 Feb 2021 23:51:11 +0100
From: Jens-Wolfhard Schicke-Uffmann <j.schicke@quuxlogic.com>
To: dm-devel@redhat.com
Message-ID: <20210211225111.GA113449@eta-carinae>
MIME-Version: 1.0
User-Agent: Mutt/1.9.3 (2018-01-21)
X-Smtpcorp-Track: 1_jKnqwSEefiCz.JQTMJ3nmzh5uD
Feedback-ID: 183594m:183594a34a5n5:183594sml2ixx3B3
X-Report-Abuse: Please forward a copy of this message, including all headers,
	to <abuse-report@smtp2go.com>
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
Subject: [dm-devel] Cache writethrough mode skips writes to source
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

while debugging an I/O load issue at a client, I came across cases of system
reboots (which apparently included an unclear device shutdown), where a
dm-cache was marked all-dirty, as described e.g. in admin-guide/device-mapper/cache.rst
> The 'dirty' state for a cache block changes far too frequently for us to keep
> updating it on the fly. So we treat it as a hint. In normal operation it will
> be written when the dm device is suspended. If the system crashes all cache
> blocks will be assumed dirty when restarted.

As the caches were in front of a RAID1 they were configured "writethrough" in order
not to reduce data redundancy. As per documentation:
> write through caching that prohibits cache block content from being
> different from origin block content.

While trying to understand caching behavior in more detail, I noticed that in
dm-cache-target.c, map_bio this guarantee seems to be violated

if (passthrough_mode(cache)) {
	if (bio_data_dir(bio) == WRITE) {
		bio_drop_shared_lock(cache, bio);
		atomic_inc(&cache->stats.demotion);
		invalidate_start(cache, cblock, block, bio);
	} else
		remap_to_origin_clear_discard(cache, bio, block);
} else {
	if (bio_data_dir(bio) == WRITE && writethrough_mode(cache) &&
			!is_dirty(cache, cblock)) {
                          // ^----- !!!BUG!!!
		remap_to_origin_and_cache(cache, bio, block, cblock);
		accounted_begin(cache, bio);
	} else
		remap_to_cache_dirty(cache, bio, block, cblock);
}

... in case a writethrough cache ever gets dirty cblocks, which is to say
after an unclean shutdown.

And indeed, a quick comparison of device contents showed a lot of differences
between the cached block device and the source RAID1.


It seems to me that the is_dirty condition can simply be dropped, but the
comment above remap_to_origin_and_cache()
> When running in writethrough mode we need to send writes to clean blocks
suggests there is a reason why it exists.

- Jens

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


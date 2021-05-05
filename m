Return-Path: <SRS0=lnUw=KA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0258DC433ED
	for <dm-devel@archiver.kernel.org>; Wed,  5 May 2021 18:49:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6DDEA613CD
	for <dm-devel@archiver.kernel.org>; Wed,  5 May 2021 18:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DDEA613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620240551;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xNFeqNJ+6U3wusORqCRscg5sKjGJLnX/Lu+xUsVbheM=;
	b=HWJU0ZnTvGwJVW18PXkjhXaYUfH5w62JGlb4WLcsYEZI582akPJ3NZkVJ0+E21QAGISx16
	lKHFtEPx6M5+x4X8BAhopf29MIQ9F1Sbuf0IUjqYGZbDKB2LuiGPjrz1BZr5erCe16Kyhz
	FYgkwlMroYnYyZJ5iMcU+bEOxorUhcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-ieR9grX2PlaIoOLxHTJ3ww-1; Wed, 05 May 2021 14:49:09 -0400
X-MC-Unique: ieR9grX2PlaIoOLxHTJ3ww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06F4610066E7;
	Wed,  5 May 2021 18:49:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 07B256062C;
	Wed,  5 May 2021 18:48:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 072455533F;
	Wed,  5 May 2021 18:48:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 145ImpQH017480 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 5 May 2021 14:48:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CE6332B0A9; Wed,  5 May 2021 18:48:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60CA060875;
	Wed,  5 May 2021 18:48:48 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 145ImlRu031649; Wed, 5 May 2021 14:48:47 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 145ImlWW031646; Wed, 5 May 2021 14:48:47 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 5 May 2021 14:48:47 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Melvin Vermeeren <vermeeren@vermwa.re>
In-Reply-To: <6810395.sd9NxXGo4T@verm-r4e>
Message-ID: <alpine.LRH.2.02.2105051444010.31064@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<6810395.sd9NxXGo4T@verm-r4e>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
	Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm-integrity: if we have discard support,
 use it when recalculating
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Fri, 30 Apr 2021, Melvin Vermeeren wrote:

> Hi again,
> 
> On Wednesday, 28 April 2021 23:00:23 CEST Mikulas Patocka wrote:
> > Here I'm sending version 2 of the patch - it increases version number of
> > the target, so that userspace can test if this feature is present.
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > If we have discard support, we don't have to recalculate hash - we can
> > just fill the metadata with the discard pattern.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> I had a look at this patch. If I understand correctly, this logic only applies 
> to dm-integrity recalculation, so for example from userspace with:
> $ integritysetup --integrity-recalculate --allow-discards open <dev> <name>
> 
> In such a case, it will fill all tag values with discard filler instead of 
> reading from the drive and computing the tags. If that is true I think this is 
> not desired behaviour, consider the following:
> 
> * SSD with existing data /dev/sda1.
> * Device for dm-integrity metadata /dev/vg/is_sda1_meta.
> * $ integritysetup --data-device /dev/sda1 --no-wipe /dev/vg/is_sda1_meta
> * $ integritysetup --data-device /dev/sda1 --integrity-recalculate \
> 	--allow-discards open /dev/vg/is_sda1_meta is_sda1
> 
> In current production version, this causes a full read of the SSD to 
> recalculate integrity tags, which is as expected and works very nicely. With 
> this patch, wouldn't it result in all integrity tags being set to the discard 
> filler? Does this patch assume a device is fully discarded when recalculating?

It doesn't matter if the device is discarded or not. If the metadata 
constains the discard filler, dm-integrity won't check the checksum - so 
the data can contain anything.

> Perhaps I am reading it wrong, I am not familiar with the dm kernel modules.
> 
> 
> Also, a bit unrelated to any of the above. When doing a format operation 
> (without --no-wipe) on a device supporting discard, would it not be possible 
> to format via discards instead of the current data write operations? That 
> would significantly improve speed for SSDs and also reduce wear on the drive.

You don't have to discard the device when initializing it.

The device after discard may contain random pattern (some SSDs really do) 
- so when the metadata contains the discard filler, the data may contain 
anything.

> Thanks,

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


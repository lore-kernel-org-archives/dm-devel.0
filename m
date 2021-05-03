Return-Path: <SRS0=u0Zu=J6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C3AC433B4
	for <dm-devel@archiver.kernel.org>; Mon,  3 May 2021 07:28:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 916CA61244
	for <dm-devel@archiver.kernel.org>; Mon,  3 May 2021 07:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 916CA61244
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-542UxqSkPreHbjOS4BFjhw-1; Mon, 03 May 2021 03:28:17 -0400
X-MC-Unique: 542UxqSkPreHbjOS4BFjhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4DC150203;
	Mon,  3 May 2021 07:28:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91C265B685;
	Mon,  3 May 2021 07:28:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 13CD11800BBE;
	Mon,  3 May 2021 07:28:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1437S6tS018616 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 3 May 2021 03:28:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 342B82EF9C; Mon,  3 May 2021 07:28:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F3202ED9C
	for <dm-devel@redhat.com>; Mon,  3 May 2021 07:28:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9DC51857F27
	for <dm-devel@redhat.com>; Mon,  3 May 2021 07:28:03 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-558-TjT9hCcCMdK5Hk2wc2EfpA-1;
	Mon, 03 May 2021 03:28:00 -0400
X-MC-Unique: TjT9hCcCMdK5Hk2wc2EfpA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 20E4FAFF4;
	Mon,  3 May 2021 07:27:59 +0000 (UTC)
Message-ID: <1d4fa494a307aa2d303e210c69d1f0c0d8675436.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Date: Mon, 03 May 2021 09:27:58 +0200
In-Reply-To: <20210430201542.GA7880@redhat.com>
References: <20210422202130.30906-1-mwilck@suse.com>
	<20210428195457.GA46518@lobo>
	<7124009b-1ea5-61eb-419f-956e659a0996@suse.de>
	<20210430201542.GA7880@redhat.com>
User-Agent: Evolution 3.38.4
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
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm: dm_blk_ioctl(): implement failover for SG_IO on
	dm-multipath
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2021-04-30 at 16:15 -0400, Mike Snitzer wrote:
> 
> If calling sg_io() is an issue then how does Martin's latest
> patchset,
> that exports and calls sg_io direct from DM, work!?

It works by doing sg_io on the _path_ devices. There's no difference
wrt to the current code in this respect. My code just retries on a
different path when one fails.

Hannes' original idea had passed the _dm_ device directly to
scsi_cmd_blk_ioctl().

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


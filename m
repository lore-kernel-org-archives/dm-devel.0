Return-Path: <SRS0=Uigt=FO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E28C4167B
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 17:12:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B20823D3C
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 17:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B20823D3C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-2wnvujZvNACfnaMWYwhj0Q-1; Thu, 10 Dec 2020 12:12:08 -0500
X-MC-Unique: 2wnvujZvNACfnaMWYwhj0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C19F107ACF6;
	Thu, 10 Dec 2020 17:12:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4AEE60BF1;
	Thu, 10 Dec 2020 17:11:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABEEB4BB7B;
	Thu, 10 Dec 2020 17:11:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BAHBu84001512 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Dec 2020 12:11:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5FB74101F0B7; Thu, 10 Dec 2020 17:11:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE8B1031F2A
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 17:11:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1C2B803CE8
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 17:11:53 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-373-ClxfdcUtPZ6IJhwXo3KO1A-1;
	Thu, 10 Dec 2020 12:11:51 -0500
X-MC-Unique: ClxfdcUtPZ6IJhwXo3KO1A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5B6EDAE95;
	Thu, 10 Dec 2020 17:11:50 +0000 (UTC)
Message-ID: <29294c6553c7ec3d31e1bc3b9de524e9c7060f07.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Date: Thu, 10 Dec 2020 18:11:49 +0100
In-Reply-To: <20201210092459.81939-1-hare@suse.de>
References: <20201210092459.81939-1-hare@suse.de>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Dan Ehrenberg <dehrenberg@chromium.org>
Subject: Re: [dm-devel] [PATCH] dm: avoid filesystem lookup in dm_get_dev_t()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2020-12-10 at 10:24 +0100, Hannes Reinecke wrote:
> dm_get_dev_t() is just used to convert an arbitrary 'path' string
> into a dev_t. It doesn't presume that the device is present; that
> check will be done later, as the only caller is dm_get_device(),
> which does a dm_get_table_device() later on, which will properly
> open the device.
> So if the path string already _is_ in major:minor representation
> we can convert it directly, avoiding a recursion into the filesystem
> to lookup the block device.
> This avoids a hang in multipath_message() when the filesystem is
> inaccessible.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Ack, although I believe the scsi/__GENKSYMS__ part doesn't belong here.

Note that this is essentially a revert/fix of 644bda6f3460 ("dm table:
fall back to getting device using name_to_dev_t()"). Added the author
of that patch to CC.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


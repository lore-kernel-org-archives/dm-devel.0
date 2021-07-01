Return-Path: <SRS0=hnI9=LZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C09C11F64
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:35:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3E17A61467
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:35:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E17A61467
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-JDcjCPteNq2IxW2Ng3BRzw-1; Thu, 01 Jul 2021 07:35:01 -0400
X-MC-Unique: JDcjCPteNq2IxW2Ng3BRzw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF36EDF8A4;
	Thu,  1 Jul 2021 11:34:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7976319C45;
	Thu,  1 Jul 2021 11:34:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C4EC04EA29;
	Thu,  1 Jul 2021 11:34:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 161BYrJn019513 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 1 Jul 2021 07:34:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 902F310087FF; Thu,  1 Jul 2021 11:34:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C2AE10087E1
	for <dm-devel@redhat.com>; Thu,  1 Jul 2021 11:34:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96F25108C134
	for <dm-devel@redhat.com>; Thu,  1 Jul 2021 11:34:50 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-591-nIKu5q_wPBe79hXDrIrwDQ-1;
	Thu, 01 Jul 2021 07:34:46 -0400
X-MC-Unique: nIKu5q_wPBe79hXDrIrwDQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 01CD567357; Thu,  1 Jul 2021 13:34:42 +0200 (CEST)
Date: Thu, 1 Jul 2021 13:34:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20210701113442.GA10793@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com>
	<20210628151558.2289-4-mwilck@suse.com>
	<20210701075629.GA25768@lst.de>
	<de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
	Daniel Wagner <dwagner@suse.de>, emilne@redhat.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add
 CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 01, 2021 at 12:35:53PM +0200, Martin Wilck wrote:
> I respectfully disagree. Users of dm-multipath devices expect that IO
> succeeds as long as there's at least one healthy path. This is a
> fundamental property of multipath devices. Whether IO is sent
> "normally" or via SG_IO doesn't make a difference wrt this expectation.

If you have those (pretty reasonable) expections don't use SG_IO.
That is what the regular read/write path is for.  SG_IO gives you
raw access to the SCSI logic unit, and you get to keep the pieces
if anything goes wrong.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


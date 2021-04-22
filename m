Return-Path: <SRS0=6Nrr=JT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F6DC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 20:25:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0042460C3E
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 20:25:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0042460C3E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-r93lLArOOGeH6rh063gnlw-1; Thu, 22 Apr 2021 16:24:58 -0400
X-MC-Unique: r93lLArOOGeH6rh063gnlw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 146C9107ACE3;
	Thu, 22 Apr 2021 20:24:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0B8A369A;
	Thu, 22 Apr 2021 20:24:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09CBC44A58;
	Thu, 22 Apr 2021 20:24:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13MKOoT4031927 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Apr 2021 16:24:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6D9B42213D96; Thu, 22 Apr 2021 20:24:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66F172213DA8
	for <dm-devel@redhat.com>; Thu, 22 Apr 2021 20:24:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E2AB101A52C
	for <dm-devel@redhat.com>; Thu, 22 Apr 2021 20:24:48 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-501-YIpdxpR9O1CbAIKF41F4zA-1;
	Thu, 22 Apr 2021 16:24:43 -0400
X-MC-Unique: YIpdxpR9O1CbAIKF41F4zA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 149F6AEE5;
	Thu, 22 Apr 2021 20:24:42 +0000 (UTC)
Message-ID: <a3e14a692f4237d62d646b84d503f21b6a41ce34.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>
Date: Thu, 22 Apr 2021 22:24:41 +0200
In-Reply-To: <20210422202130.30906-1-mwilck@suse.com>
References: <20210422202130.30906-1-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Benjamin, Paolo, Daniel Wagner <dwagner@suse.de>,
	linux-block@vger.kernel.org, Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [*RFC* PATCH] dm: dm_blk_ioctl(): implement failover
 for SG_IO on dm-multipath
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

I forgot the "RFC" subject prefix. Adding it this way, sorry.

Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


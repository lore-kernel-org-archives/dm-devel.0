Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EE9C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:15:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B2CD61053
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B2CD61053
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-uyKh6eYeOpa0-I6rurgNDg-1; Thu, 04 Nov 2021 03:15:01 -0400
X-MC-Unique: uyKh6eYeOpa0-I6rurgNDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D01DF801B01;
	Thu,  4 Nov 2021 07:14:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B4D779449;
	Thu,  4 Nov 2021 07:14:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EF2F74A703;
	Thu,  4 Nov 2021 07:14:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A47Er9a007651 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 03:14:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BCE961121315; Thu,  4 Nov 2021 07:14:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B88D61121314
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 07:14:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 882C5800B26
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 07:14:49 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-536-CPL5woW0NkWgb5j_eYIWsw-1;
	Thu, 04 Nov 2021 03:14:45 -0400
X-MC-Unique: CPL5woW0NkWgb5j_eYIWsw-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4A62468AA6; Thu,  4 Nov 2021 08:14:40 +0100 (CET)
Date: Thu, 4 Nov 2021 08:14:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20211104071439.GA21927@lst.de>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20211104064634.4481-1-chaitanyak@nvidia.com>
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
Cc: snitzer@redhat.com, ebiggers@google.com, djwong@kernel.org,
	linux-nvme@lists.infradead.org, song@kernel.org,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	adilger.kernel@dilger.ca, hch@lst.de, agk@redhat.com,
	javier@javigon.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, dongli.zhang@oracle.com,
	willy@infradead.org, osandov@fb.com,
	danil.kipnis@cloud.ionos.com, idryomov@gmail.com,
	jinpu.wang@cloud.ionos.com, Chaitanya Kulkarni <kch@nvidia.com>,
	jejb@linux.ibm.com, josef@toxicpanda.com, ming.lei@redhat.com,
	linux-raid@vger.kernel.org, dsterba@suse.com,
	viro@zeniv.linux.org.uk, kbusch@kernel.org, sagi@grimberg.me,
	axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
	martin.petersen@oracle.com, clm@fb.com,
	johannes.thumshirn@wdc.com, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, jefflexu@linux.alibaba.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

What is the actual use case here?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


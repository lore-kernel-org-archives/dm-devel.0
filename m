Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D14C43381
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 13:11:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62BB064E8A
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 13:11:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62BB064E8A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-qUXwxkCwNDONtUQlenpTTA-1; Wed, 10 Feb 2021 08:11:02 -0500
X-MC-Unique: qUXwxkCwNDONtUQlenpTTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 762381020C21;
	Wed, 10 Feb 2021 13:10:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 440F818770;
	Wed, 10 Feb 2021 13:10:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A06FC58074;
	Wed, 10 Feb 2021 13:10:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AD9wMO008800 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 08:09:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5785AAE7B0; Wed, 10 Feb 2021 13:09:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 519D7AE7C4
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 13:09:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32D4A101A53A
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 13:09:56 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-462-BEDJln3qMJ-MOl4kAi50Bw-1;
	Wed, 10 Feb 2021 08:09:49 -0500
X-MC-Unique: BEDJln3qMJ-MOl4kAi50Bw-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A87B6736F; Wed, 10 Feb 2021 14:09:46 +0100 (CET)
Date: Wed, 10 Feb 2021 14:09:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <20210210130945.GA29862@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-12-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <20210208105530.3072869-12-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: y-goto@fujitsu.com, qi.fuli@fujitsu.com, snitzer@redhat.com,
	linux-nvdimm@lists.01.org, rgoldwyn@suse.de,
	darrick.wong@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 11/11] fs/dax: Remove useless functions
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

On Mon, Feb 08, 2021 at 06:55:30PM +0800, Shiyang Ruan wrote:
> Since owner tarcking is triggerred by pmem device, these functions are

s/tarcking/tracking/

> useless.  So remove them.

Note that this patch does not apply for me when applying your two series
on top of 5.11-rc5.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


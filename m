Return-Path: <SRS0=7Rox=LX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478A0C11F66
	for <dm-devel@archiver.kernel.org>; Tue, 29 Jun 2021 11:48:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CFE6161D2A
	for <dm-devel@archiver.kernel.org>; Tue, 29 Jun 2021 11:48:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFE6161D2A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-8KP6XSyNOaaMRuUmR94EjQ-1; Tue, 29 Jun 2021 07:47:58 -0400
X-MC-Unique: 8KP6XSyNOaaMRuUmR94EjQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2FAB18D6A2E;
	Tue, 29 Jun 2021 11:47:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BD2E5C1D0;
	Tue, 29 Jun 2021 11:47:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 72FBC4EA2A;
	Tue, 29 Jun 2021 11:47:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15TBlkPc006682 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Jun 2021 07:47:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 14F5221623B4; Tue, 29 Jun 2021 11:47:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10F6E2138CF0
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 11:47:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECE739676EB
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 11:47:42 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-211-EBt7eFnLMl2hwQ2EGChGAA-1; Tue, 29 Jun 2021 07:47:40 -0400
X-MC-Unique: EBt7eFnLMl2hwQ2EGChGAA-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1lyCCI-0043Q8-DZ; Tue, 29 Jun 2021 11:46:40 +0000
Date: Tue, 29 Jun 2021 12:46:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Message-ID: <YNsIGid6CwtH/h1Z@casper.infradead.org>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
	<20210628000218.387833-6-ruansy.fnst@fujitsu.com>
	<YNm3VeeWuI0m4Vcx@casper.infradead.org>
	<OSBPR01MB292012F7C264076E9AA645C3F4029@OSBPR01MB2920.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <OSBPR01MB292012F7C264076E9AA645C3F4029@OSBPR01MB2920.jpnprd01.prod.outlook.com>
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"darrick.wong@oracle.com" <darrick.wong@oracle.com>,
	"rgoldwyn@suse.de" <rgoldwyn@suse.de>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 5/9] mm: Introduce mf_dax_kill_procs() for
	fsdax case
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

On Tue, Jun 29, 2021 at 07:49:24AM +0000, ruansy.fnst@fujitsu.com wrote:
> > But I think this is unnecessary; why not just pass the PFN into mf_dax_kill_procs?
> 
> Because the mf_dax_kill_procs() is called in filesystem recovery function, which is at the end of the RMAP routine.  And the PFN has been translated to disk offset in pmem driver in order to do RMAP search in filesystem.  So, if we have to pass it, every function in this routine needs to add an argument for this PFN.  I was hoping I can avoid passing PFN through the whole stack with the help of this dax_load_pfn().

OK, I think you need to create:

struct memory_failure {
	phys_addr_t start;
	phys_addr_t end;
	unsigned long flags;
};

(a memory failure might not be an entire page, so working in pfns isn't
the best approach)

Then that can be passed to ->memory_failure() and then deeper to
->notify_failure(), and finally into xfs_corrupt_helper().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


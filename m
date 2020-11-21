Return-Path: <SRS0=TM4A=E3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827F2C6379D
	for <dm-devel@archiver.kernel.org>; Sat, 21 Nov 2020 16:24:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 072BD2145D
	for <dm-devel@archiver.kernel.org>; Sat, 21 Nov 2020 16:24:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 072BD2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-cLK_9oonM1ucqfKQdYARYg-1; Sat, 21 Nov 2020 11:24:35 -0500
X-MC-Unique: cLK_9oonM1ucqfKQdYARYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87D4180EF83;
	Sat, 21 Nov 2020 16:24:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1C5D10013BD;
	Sat, 21 Nov 2020 16:24:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A44B4A7C6;
	Sat, 21 Nov 2020 16:24:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ALGOMEj022236 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 21 Nov 2020 11:24:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1D4911111C6A; Sat, 21 Nov 2020 16:24:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1996B11301DB
	for <dm-devel@redhat.com>; Sat, 21 Nov 2020 16:24:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03D35811E78
	for <dm-devel@redhat.com>; Sat, 21 Nov 2020 16:24:20 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-445-Qr8gjuvfOeCr7_AGyUPW9A-1;
	Sat, 21 Nov 2020 11:24:15 -0500
X-MC-Unique: Qr8gjuvfOeCr7_AGyUPW9A-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 951F467373; Sat, 21 Nov 2020 17:24:11 +0100 (CET)
Date: Sat, 21 Nov 2020 17:24:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Message-ID: <20201121162411.GA18475@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-15-hch@lst.de>
	<20201119120525.GW1981@quack2.suse.cz>
	<20201120090820.GD21715@lst.de>
	<20201120112121.GB15537@quack2.suse.cz>
	<20201120153253.GA18990@lst.de>
	<20201120155956.GB4327@casper.infradead.org>
	<20201120200548.GA27360@quack2.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20201120200548.GA27360@quack2.suse.cz>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>, Josef Bacik <josef@toxicpanda.com>,
	Matthew Wilcox <willy@infradead.org>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	linux-mm@kvack.org, Jan Kara <jack@suse.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 14/20] block: remove the nr_sects field in
 struct hd_struct
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

On Fri, Nov 20, 2020 at 09:05:48PM +0100, Jan Kara wrote:
> The code is already switched to it AFAICT (the lock is really only used in
> the two places that write i_size). But the problem is that in theory two
> i_size_write() calls can race in a way that the resulting stored i_size is a
> mix of two stored sizes. Now I have hard time imagining how this could
> happen for a block device and if two reconfigurations of a block device
> could race like that we'd have a large problems anyway...

Now that you mention it, yes - i_size_write needs to be under i_rwsem
or an equivalent lock.  We could look into using i_rwsem also for block
device, but for now the spinlock seems to be doing fine.  Note that
in current mainline we only have such a lock protecting i_size of the
block_device inode, but none for the size in hd_struct.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


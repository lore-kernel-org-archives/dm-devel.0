Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 125E6C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jan 2022 10:17:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-hC6Vi6gpNeuI0tLfzjYu0w-1; Thu, 20 Jan 2022 05:17:03 -0500
X-MC-Unique: hC6Vi6gpNeuI0tLfzjYu0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C23C651084;
	Thu, 20 Jan 2022 10:16:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDB634F850;
	Thu, 20 Jan 2022 10:16:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C7734CA93;
	Thu, 20 Jan 2022 10:16:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20KAGp2x022401 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 Jan 2022 05:16:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3C93E53B3; Thu, 20 Jan 2022 10:16:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38E9076E9
	for <dm-devel@redhat.com>; Thu, 20 Jan 2022 10:16:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DD3B8FA9A8
	for <dm-devel@redhat.com>; Thu, 20 Jan 2022 10:16:48 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-251-z0Pjpf6IMaey2i4RMdLWrQ-1; Thu, 20 Jan 2022 05:16:44 -0500
X-MC-Unique: z0Pjpf6IMaey2i4RMdLWrQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nAU9n-00AOBe-9r; Thu, 20 Jan 2022 09:55:03 +0000
Date: Thu, 20 Jan 2022 01:55:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <Yekxd1/MboidZo4C@infradead.org>
References: <20220111185930.2601421-1-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220111185930.2601421-1-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
	djwong@kernel.org, david@fromorbit.com,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
	vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	linux-xfs@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 0/7] DAX poison recovery
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 11, 2022 at 11:59:23AM -0700, Jane Chu wrote:
> In v3, dax recovery code path is independent of that of
> normal write. Competing dax recovery threads are serialized,
> racing read threads are guaranteed not overlapping with the
> recovery process.
> 
> In this phase, the recovery granularity is page, future patch
> will explore recovery in finer granularity.

What tree is this against? I can't apply it to either 5.16 or Linus'
current tree.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


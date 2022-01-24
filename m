Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026C9C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 24 Jan 2022 09:57:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-Q7ro4XVvOS-XDBDwyzUvKQ-1; Mon, 24 Jan 2022 04:57:48 -0500
X-MC-Unique: Q7ro4XVvOS-XDBDwyzUvKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6B821083F62;
	Mon, 24 Jan 2022 09:57:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E9631F2F8;
	Mon, 24 Jan 2022 09:57:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52ACD1809CB8;
	Mon, 24 Jan 2022 09:57:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20O9veXC020391 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 Jan 2022 04:57:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E45EF112132D; Mon, 24 Jan 2022 09:57:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E0896112132C
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 09:57:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CDAC1C05AB0
	for <dm-devel@redhat.com>; Mon, 24 Jan 2022 09:57:35 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-356-appCu9ZYNmOoFy2TkwLstw-1; Mon, 24 Jan 2022 04:57:32 -0500
X-MC-Unique: appCu9ZYNmOoFy2TkwLstw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nBvEC-002iR9-UK; Mon, 24 Jan 2022 09:01:32 +0000
Date: Mon, 24 Jan 2022 01:01:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <Ye5q7MSypmwdV4iT@infradead.org>
References: <20220111185930.2601421-1-jane.chu@oracle.com>
	<Yekxd1/MboidZo4C@infradead.org>
	<4e8c454f-ae48-d4a2-27c4-be6ee89fc9b3@oracle.com>
MIME-Version: 1.0
In-Reply-To: <4e8c454f-ae48-d4a2-27c4-be6ee89fc9b3@oracle.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 21, 2022 at 01:33:40AM +0000, Jane Chu wrote:
> > What tree is this against? I can't apply it to either 5.16 or Linus'
> > current tree.
> 
> It was based on your 'dax-block-cleanup' branch a while back.

Do you have a git tree with your patches included available somewhere?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


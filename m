Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3A6C77B75
	for <dm-devel@archiver.kernel.org>; Tue, 18 Apr 2023 04:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681793857;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GT3nnntyeyHIZmUxEZkPNZDEtzUV6Jo+X1mOixxyTnc=;
	b=DMQsvalGi5bwm5EQT7zfqQS2xjylbIkzuomKIUahDouZU5OS7DtjhdLo8VaNaGbDgv3hfy
	k7IjcEXDVJVE8bWXTk1Y9T1j2wKJJFpA699o0ommzFhU7zc1vMrSNbzPXb48wolNyMJaSs
	cxp6x8lp3iFeKXoMJV4q0+9KFrEq2ts=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-cFKhE_DGPBuO6Ifou2RYfg-1; Tue, 18 Apr 2023 00:57:33 -0400
X-MC-Unique: cFKhE_DGPBuO6Ifou2RYfg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEB4385C6E0;
	Tue, 18 Apr 2023 04:57:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DCE86492B0F;
	Tue, 18 Apr 2023 04:57:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 662A5194658C;
	Tue, 18 Apr 2023 04:57:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9D0201946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 04:57:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 726AE40C6E6F; Tue, 18 Apr 2023 04:57:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AF8B40C6E6E
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 04:57:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5397285C6E0
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 04:57:26 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-g3rHtrXoMX-fNLocxNbLdw-1; Tue, 18 Apr 2023 00:57:24 -0400
X-MC-Unique: g3rHtrXoMX-fNLocxNbLdw-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 0906C67373; Tue, 18 Apr 2023 06:57:20 +0200 (CEST)
Date: Tue, 18 Apr 2023 06:57:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <20230418045719.GA29490@lst.de>
References: <alpine.LRH.2.21.2304171433370.17217@file01.intranet.prod.int.rdu2.redhat.com>
 <ZD2e5lw5CqueygSA@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <ZD2e5lw5CqueygSA@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] block: fix a crash when
 bio_for_each_folio_all iterates over an empty bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 17, 2023 at 08:32:54PM +0100, Matthew Wilcox wrote:
> On Mon, Apr 17, 2023 at 03:11:57PM -0400, Mikulas Patocka wrote:
> > If we use bio_for_each_folio_all on an empty bio, it will access the first
> > bio vector unconditionally (it is uninitialized) and it may crash
> > depending on the uninitialized data.
> 
> Wait, how do we have an empty bio in the first place?

flush bios are always empty.  Not sure iterating over them makes much
sense, though.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B26C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 06:26:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-GPG5Rj7APryKbPXDFXqgyQ-1; Wed, 02 Mar 2022 01:26:28 -0500
X-MC-Unique: GPG5Rj7APryKbPXDFXqgyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DCD71006AA5;
	Wed,  2 Mar 2022 06:26:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 698281F2F8;
	Wed,  2 Mar 2022 06:26:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3DFAD44A5D;
	Wed,  2 Mar 2022 06:26:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 22234FG3017843 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 22:04:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B3D041417200; Wed,  2 Mar 2022 03:04:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFF6F1454546
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 03:04:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C0463C021B7
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 03:04:15 +0000 (UTC)
Received: from p3plwbeout12-04.prod.phx3.secureserver.net
	(p3plsmtp12-04-2.prod.phx3.secureserver.net [173.201.192.60]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-526-iTAoIidaOyO-yQT0wTKgig-1; Tue, 01 Mar 2022 22:04:11 -0500
X-MC-Unique: iTAoIidaOyO-yQT0wTKgig-1
Received: from mailex.mailcore.me ([94.136.40.142]) by :WBEOUT: with ESMTP
	id PFEyn4KcwTc4gPFEznCcou; Tue, 01 Mar 2022 20:01:25 -0700
X-CMAE-Analysis: v=2.4 cv=EoMXEQQA c=1 sm=1 tr=0 ts=621ede05
	a=s1hRAmXuQnGNrIj+3lWWVA==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
	a=ggZhUymU-5wA:10 a=IkcTkHD0fZMA:10 a=o8Y5sQTvuykA:10 a=FXvPX3liAAAA:8
	a=lFWsI9-O6uv9ryMHa3YA:9 a=QEXdDO2ut3YA:10 a=SM4aVyO6fsoA:10
	a=OunuuIp3J4_2X_e7vt2U:22 a=fDQtvUcBV1mJc6yKnRhE:22
	a=UObqyxdv-6Yh2QiB9mM_:22
X-SECURESERVER-ACCT: phillip@squashfs.org.uk
X-SID: PFEyn4KcwTc4g
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175]
	helo=[192.168.178.33])
	by smtp11.mailcore.me with esmtpa (Exim 4.94.2)
	(envelope-from <phillip@squashfs.org.uk>)
	id 1nPFEy-0008Mw-0N; Wed, 02 Mar 2022 03:01:24 +0000
Message-ID: <ac281c26-682c-b8b7-88b2-7e1b4669de5d@squashfs.org.uk>
Date: Wed, 2 Mar 2022 03:01:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220301084552.880256-1-hch@lst.de>
	<20220301084552.880256-3-hch@lst.de>
From: Phillip Lougher <phillip@squashfs.org.uk>
In-Reply-To: <20220301084552.880256-3-hch@lst.de>
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated: phillip@squashfs.org.uk
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfCVZgeYvJDmQ3CvF7OrgGtuzbVHdb83R8wJM3yyi6EdnyVwz/dKghEswyruCLON0o/9mwHYjRk5ZY87eEQJI1m9Ql2T0MkEX1V0SNokBnTGXOP5IhU2K
	Uiw8w1m0sl3hxrwlP/tfjoK/9UhHrHfEuaGgjk3EUDESCwmrm19urmUMKfxQs+zVRTdlr36Jzfb0OmJDdmKEJBUSF5XBib3QjMd1l+Nj9LcGsQr1D9Wi6DLB
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Mar 2022 01:25:55 -0500
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/5] squashfs: always use bio_kmalloc in
	squashfs_bio_read
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 01/03/2022 08:45, Christoph Hellwig wrote:
> If a plain kmalloc that is not backed by a mempool is safe here for a
> large read (and the actual page allocations), it must also be for a
> small one, so simplify the code a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Phillip Lougher <phillip@squashfs.org.uk>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


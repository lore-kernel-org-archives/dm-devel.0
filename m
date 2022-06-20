Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BFEC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 20 Jun 2022 07:12:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-pso0iYD2O_-OM2-XCKxGPQ-1; Mon, 20 Jun 2022 03:12:42 -0400
X-MC-Unique: pso0iYD2O_-OM2-XCKxGPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB97E83397C;
	Mon, 20 Jun 2022 07:12:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE4879D5F;
	Mon, 20 Jun 2022 07:12:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CBA57194706D;
	Mon, 20 Jun 2022 07:12:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50A7B1947069
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Jun 2022 07:12:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2F96A2026987; Mon, 20 Jun 2022 07:12:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B59B2026985
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 07:12:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13D131C04B41
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 07:12:36 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-RscCIJuvMwuWd063jWFOCg-1; Mon, 20 Jun 2022 03:12:33 -0400
X-MC-Unique: RscCIJuvMwuWd063jWFOCg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 8F79668AA6; Mon, 20 Jun 2022 09:12:29 +0200 (CEST)
Date: Mon, 20 Jun 2022 09:12:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20220620071229.GB11418@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603114645.GA14309@lst.de>
 <2634b3ae-f63d-c711-36cd-bf8f56ecc43b@oracle.com>
MIME-Version: 1.0
In-Reply-To: <2634b3ae-f63d-c711-36cd-bf8f56ecc43b@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 0/8] Use block pr_ops in LIO
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 03, 2022 at 12:55:33PM -0500, Mike Christie wrote:
> However, for nvme and for the interface we want to provide to userspace,
> do we want to implement an interface like READ_FULL_STATUS and report
> reservations where we report the host/controller/port info? If so, below
> is a patch I started.

If we wire the ops up to the nvme target we'd need that.  But for now
I think the more useful case would be to use nvme as the underlying
devices for the scsi target that already has all the PR infrastructure
and helps to validate the interface.

> Notes:
> 1. I hit some issues with SCSI targets not reporting the IDs sometimes or
> sometimes they report it incorrectly. For nvme, it seems easier. SCSI has 
> to handle a hand full of ways to report the ID where nvme has 2 ways to
> do the host ID.

Yeah.

> 2. I couldn't find a nvme device to test. Qemu and nvmet don't seem to
> support reservations.

Basically any dual ported PCIe SSD should support them, typically those
are the U.2 format factor ones found in servers or enclosures.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869E4C43334
	for <dm-devel@archiver.kernel.org>; Mon, 20 Jun 2022 07:14:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-ugxEtyUWMCq357FDecpqMA-1; Mon, 20 Jun 2022 03:14:50 -0400
X-MC-Unique: ugxEtyUWMCq357FDecpqMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E25329ABA33;
	Mon, 20 Jun 2022 07:14:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D13F1415109;
	Mon, 20 Jun 2022 07:14:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F392D194706D;
	Mon, 20 Jun 2022 07:14:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A96791947069
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Jun 2022 07:14:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 883DE112131B; Mon, 20 Jun 2022 07:14:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 847BC1121314
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 07:14:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DF4885A581
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 07:14:46 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-6asq6i3OMvG269MT0t2iSg-1; Mon, 20 Jun 2022 03:14:36 -0400
X-MC-Unique: 6asq6i3OMvG269MT0t2iSg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 1010868AA6; Mon, 20 Jun 2022 09:14:34 +0200 (CEST)
Date: Mon, 20 Jun 2022 09:14:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20220620071433.GF11418@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-5-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220603065536.5641-5-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 04/11] block: Add PR callouts for read keys
 and reservation
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
 linux-block@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 03, 2022 at 01:55:29AM -0500, Mike Christie wrote:
> Add callouts for reading keys and reservations.
> 
> Note: This only initially adds the struct definitions in the kernel as I'm
> not sure if we wanted to export the interface to userspace yet. We may
> want to refine internally for LIO and when we can enable it for NVMe then
> add the finished interface to userspace.

Yes, this sounds like a good plan.  I can see how they would be useful
for userspace, but I'm also perfectly fine with us not locking ourselves
into an ABI quite yet.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


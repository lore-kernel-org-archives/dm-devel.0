Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E38FC43334
	for <dm-devel@archiver.kernel.org>; Mon, 20 Jun 2022 07:23:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-wIiYF8spOg2SIYFJJM4PDA-1; Mon, 20 Jun 2022 03:23:19 -0400
X-MC-Unique: wIiYF8spOg2SIYFJJM4PDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E2B629ABA3B;
	Mon, 20 Jun 2022 07:23:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD5A32166B26;
	Mon, 20 Jun 2022 07:23:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7667C194706D;
	Mon, 20 Jun 2022 07:23:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D58971947069
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Jun 2022 07:23:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6BB5A112131B; Mon, 20 Jun 2022 07:23:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67AF01121314
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 07:23:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 509D61C18265
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 07:23:16 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-C4iUfHBfOJKF9tLDtcl2wQ-1; Mon, 20 Jun 2022 03:23:14 -0400
X-MC-Unique: C4iUfHBfOJKF9tLDtcl2wQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id D4DB868AA6; Mon, 20 Jun 2022 09:23:10 +0200 (CEST)
Date: Mon, 20 Jun 2022 09:23:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20220620072310.GI11418@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
 <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
 <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
 <6cc818cf-fac4-d485-ea9d-0b8597f24a33@oracle.com>
 <b612013c-46e4-d1c3-81f8-b28a026240e6@suse.de>
MIME-Version: 1.0
In-Reply-To: <b612013c-46e4-d1c3-81f8-b28a026240e6@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 09/11] block,
 nvme: Add error for reservation conflicts.
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
 Keith Busch <kbusch@kernel.org>, hch@lst.de, michael.christie@oracle.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jun 05, 2022 at 11:42:11AM +0200, Hannes Reinecke wrote:
> Well ... we tried to find a generic error for reservation failure, as we 
> thought that reservation failure was too SCSI specific.
> And we wanted the error to describe what the resulting handling should be, 
> not what the cause was. Hence we ended up with BLK_STS_NEXUS.
>
> But turns out that our initial assumption wasn't valid, and that 
> reservations are a general concept. So by all means, rename BLK_STS_NEXUS 
> to BLK_STS_RSV_CONFLICT to make it clear what this error is about.

I think think this is a good ida, but we'll need to involve the
s390 dasd folks.  Maybe do this as a separate prep patch?

While thinking about DASD I think it would benefit from returning
the blk_status_t from ->free_cp insted of the hand crafted conversion
as well.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


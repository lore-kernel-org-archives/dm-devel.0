Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A364C61DA4
	for <dm-devel@archiver.kernel.org>; Wed, 15 Mar 2023 05:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678858862;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WVkUpoRSYUpSIXkbCxr6H4fc3eIEmd7h7hRht+XfQiU=;
	b=QFcb4ONVDxMzD8px7HDmXWjJynUmcQcsPC+8Hvr9+yLcgCef68Z/dSApY/inabUGyV2j/m
	hzDwn/2OXb92r7SD9NCHyvkNNsG34PnwixUP2q0YUM9jeOTwL5xsVdi+XMfSlmlv6q6sK0
	7a2A8dHRA3yDVJKa40fasGzrwonAHhU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-VU0oE-1TOQ2HbnA_LBXdvw-1; Wed, 15 Mar 2023 01:40:58 -0400
X-MC-Unique: VU0oE-1TOQ2HbnA_LBXdvw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CF9A85D53A;
	Wed, 15 Mar 2023 05:40:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC7F647507A;
	Wed, 15 Mar 2023 05:40:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CFEB19465A2;
	Wed, 15 Mar 2023 05:40:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B90F719465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Mar 2023 05:40:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A5963C164E8; Wed, 15 Mar 2023 05:40:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E136C164E7
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 05:40:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86847811E7B
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 05:40:50 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-C5khfX74NMCNy9i19gKv3A-1; Wed, 15 Mar 2023 01:40:47 -0400
X-MC-Unique: C5khfX74NMCNy9i19gKv3A-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id B552268AA6; Wed, 15 Mar 2023 06:40:42 +0100 (CET)
Date: Wed, 15 Mar 2023 06:40:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20230315054042.GA29433@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-8-michael.christie@oracle.com>
 <20230314171538.GG6780@lst.de>
 <c9082d55-7009-279a-fde1-7f774fb7e6e8@oracle.com>
MIME-Version: 1.0
In-Reply-To: <c9082d55-7009-279a-fde1-7f774fb7e6e8@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v4 07/18] nvme: Fix reservation status
 related structs
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, kbusch@kernel.org,
 Christoph Hellwig <hch@lst.de>, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 14, 2023 at 05:23:16PM -0500, Mike Christie wrote:
> We could do separate structs though:

I suspect that's probably better in the long run, as the [0] notation
is on its way out.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


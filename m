Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB97AC7618A
	for <dm-devel@archiver.kernel.org>; Tue, 14 Mar 2023 17:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678814275;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Pm1z+kVqWbjaxGlwDeQFznjeaTJVp/p72ZnOnwk1vd4=;
	b=N7IZ0bh8+zt20sGuAqWEc5b0h+YrxqfZ8Dm7PBJUVeWSGsPGy7imqCnLRYqmEeP4Q5wwQ2
	hQZtAnVYFwvSndV+MBpRQdF/EZZzaXzQ0McDyPfrg/bh5RssDox4iOQMyMTcniiiuaUaIU
	OnjGhu57z38yzFzNw304DDhaEXXCwr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-NzNaCbk7PB6AHVyLqnDy8w-1; Tue, 14 Mar 2023 13:17:51 -0400
X-MC-Unique: NzNaCbk7PB6AHVyLqnDy8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFA1788B77F;
	Tue, 14 Mar 2023 17:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD2A4140EBF4;
	Tue, 14 Mar 2023 17:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B99EA19465A2;
	Tue, 14 Mar 2023 17:17:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2981519465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Mar 2023 17:17:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B95940C6E68; Tue, 14 Mar 2023 17:17:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1400D40C6E67
 for <dm-devel@redhat.com>; Tue, 14 Mar 2023 17:17:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1F0C3815F69
 for <dm-devel@redhat.com>; Tue, 14 Mar 2023 17:17:44 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-z3qlwkXFMS2509iiJuUZyg-1; Tue, 14 Mar 2023 13:17:40 -0400
X-MC-Unique: z3qlwkXFMS2509iiJuUZyg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 0260A68BEB; Tue, 14 Mar 2023 18:10:35 +0100 (CET)
Date: Tue, 14 Mar 2023 18:10:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20230314171034.GA6780@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-2-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20230224174502.321490-2-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v4 01/18] block: Add PR callouts for read
 keys and reservation
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
 bvanassche@acm.org, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, martin.petersen@oracle.com,
 kbusch@kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


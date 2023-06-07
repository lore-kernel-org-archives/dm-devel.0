Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C45FC7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 05:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686116004;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E2hXRsvl6OlWLhRBbQNIhQ7wwj/LTDJp7WOIlYLBL/Q=;
	b=dyDCEdI5nn4Uqmyrci57jyIquj7XnTBTPvjCu4s16nkGOBCeEgtuZgTYmNBi4EGSl1PwTn
	b0IYXrbesW8iKVOAxGIkKRtx+NTurTqT+SqyKL1vX87GeAXCj189aXYpM/vwWodwwXlRaU
	a3kxjeD2QrbW7xXORcUXfO6rCKRxv3w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-5MyXge0wPFi3rBECBeGy6g-1; Wed, 07 Jun 2023 01:33:20 -0400
X-MC-Unique: 5MyXge0wPFi3rBECBeGy6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF86E185A78E;
	Wed,  7 Jun 2023 05:33:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DC6A40336D;
	Wed,  7 Jun 2023 05:33:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0CA3119459F1;
	Wed,  7 Jun 2023 05:33:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 53DE619465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 05:33:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 438B62026D6A; Wed,  7 Jun 2023 05:33:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B6AF2026D49
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 05:33:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFCA93C025D7
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 05:33:14 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-WSW36gM7PDGxmSY_PWAznA-1; Wed, 07 Jun 2023 01:33:13 -0400
X-MC-Unique: WSW36gM7PDGxmSY_PWAznA-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id E78C368AA6; Wed,  7 Jun 2023 07:33:08 +0200 (CEST)
Date: Wed, 7 Jun 2023 07:33:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <20230607053308.GA20390@lst.de>
References: <20230601072829.1258286-1-hch@lst.de> <ZH9alEbuNxHNwYYe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZH9alEbuNxHNwYYe@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] enforce read-only state at the block layer
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> Not sure of a crafty hack to workaround. Hopefully 5 year old lvm2
> remains tightly coupled to kernels of the same vintage and we get
> lucky moving forward.
> 
> So I agree with Linus, worth trying this simple change again and
> seeing if there is fallout. Revert/worry about it again as needed.

I'm actually looking into implementing Linus' suggestion now and
track in the block_device if it has ever been opened for writing.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


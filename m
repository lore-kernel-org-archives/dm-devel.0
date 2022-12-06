Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB14C4708E
	for <dm-devel@archiver.kernel.org>; Tue,  6 Dec 2022 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670338158;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GSspDvZu4ip8lezHJZAq8BxrZQ4qIuP7R0QjwCGd91U=;
	b=VCNf1r9q4bEgt2QkCw2EH7LTINBtBbhFPqWy3m1pLmRHM/HyBntAblmJ7i941HP8j6EbeD
	2xRWrDKy1IxA0RKRHGUqefWLI2EfsBvtgHZifSAv+655BRuJbofrn8NKHOeT2GwXWTK2Wz
	c2g5KLrqdFLTVMlOmhAVjRujmRJ2yIk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-jpYBsXXWMiKNePoDm7ee-Q-1; Tue, 06 Dec 2022 09:49:15 -0500
X-MC-Unique: jpYBsXXWMiKNePoDm7ee-Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED46833A0D;
	Tue,  6 Dec 2022 14:49:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F08644A9254;
	Tue,  6 Dec 2022 14:49:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C0DA61946589;
	Tue,  6 Dec 2022 14:49:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED2421946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 14:49:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DB410492B04; Tue,  6 Dec 2022 14:49:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4C10492B07
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 14:49:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDD19800186
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 14:49:08 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-yhgTdLWAOKWK3vjvvXMGAQ-1; Tue, 06 Dec 2022 09:49:06 -0500
X-MC-Unique: yhgTdLWAOKWK3vjvvXMGAQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 7B3F668B05; Tue,  6 Dec 2022 15:49:02 +0100 (CET)
Date: Tue, 6 Dec 2022 15:49:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Coly Li <colyli@suse.de>
Message-ID: <20221206144902.GA31845@lst.de>
References: <20221206144057.720846-1-hch@lst.de>
 <434E4CE3-EA46-4CD9-9EAF-5C1B99B8A603@suse.de>
MIME-Version: 1.0
In-Reply-To: <434E4CE3-EA46-4CD9-9EAF-5C1B99B8A603@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] block: remove bio_set_op_attrs
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
 snitzer@kernel.org, dm-devel@redhat.com,
 linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>,
 linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 06, 2022 at 10:46:31PM +0800, Coly Li wrote:
> BTW, may I ask why bio_set_op_attrs() is removed. Quite long time ago it was added to avoid open code, and now we remove it to use open coded assignments. What is the motivation for now?

It was added when the flags encoding was a mess.  Now that the RQF_
flags are split out things have become much simpler and we don't need
to hide a simple assignment of a value to a field.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


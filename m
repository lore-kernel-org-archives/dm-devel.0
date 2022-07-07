Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E0A8C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 05:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657171483;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KGf1sgeGQOnkxLEIiS702/i1+t06R0a/Su9DN7b6wCU=;
	b=ZKcDHFFmOx8QPZPZgidD82rMP8h/9dH1NNmYkWtapSKPatH6cMfjxC/RgmH/GV/at0/DZa
	oQr+o2L5ISnz2u+RZLK6BmUT97jf5pzFiYapdxodHrYkHPr66DlaC0nebWnNVP90ayMQLq
	nBuL0WFZqchH+nJMVZWuEo1u1CEzjmg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-8GHjKylzOzqodhnM_eKr3w-1; Thu, 07 Jul 2022 01:24:40 -0400
X-MC-Unique: 8GHjKylzOzqodhnM_eKr3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3359101A589;
	Thu,  7 Jul 2022 05:24:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7EB6E1415117;
	Thu,  7 Jul 2022 05:24:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D9211947068;
	Thu,  7 Jul 2022 05:24:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 524521947067
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Jul 2022 05:24:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 26F6A112132C; Thu,  7 Jul 2022 05:24:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 227E91121320
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 05:24:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 099703C344E0
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 05:24:35 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-IN40tJkDPFCKBy0Eb8fuGA-1; Thu, 07 Jul 2022 01:24:31 -0400
X-MC-Unique: IN40tJkDPFCKBy0Eb8fuGA-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 6693368AA6; Thu,  7 Jul 2022 07:24:26 +0200 (CEST)
Date: Thu, 7 Jul 2022 07:24:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <20220707052425.GA13016@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
 <20210804094147.459763-8-hch@lst.de>
 <ad2c7878-dabb-cb41-1bba-60ef48fa1a9f@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <ad2c7878-dabb-cb41-1bba-60ef48fa1a9f@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 7/8] dm: delay registering the gendisk
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
 dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Mike Snitzer <snitzer@redhat.com>
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

On Thu, Jul 07, 2022 at 11:29:26AM +0800, Yu Kuai wrote:
> We found that this patch fix a nullptr crash in our test:

> Do you think it's ok to backport this patch(and all realted patches) to
> lts, or it's better to fix that bio can be submitted with queue
> uninitialized from block layer?

Given how long ago this was I do not remember offhand how much prep
work this would require.  The patch itself is of course tiny and
backportable, but someone will need to do the work and figure out how
much else would have to be backported.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


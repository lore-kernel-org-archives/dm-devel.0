Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C585EC77B7A
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 04:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685593605;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cDSUd7sm86R/YK9pSYRNqw6ZGcEdAYbgPtxlDV51Keo=;
	b=ErV6nxETZYUQr0pHJB0eiE+im+pBqWEVn0bU8xhxxYhbfdUAftP8lhz4got+SJGB1mz23p
	0uOgsi0s6Vxxhg+XALwbB63i82j2+rmWsZurc+1gAq8WFQyMgOrf14ww1JQ7WxQV9PiAZJ
	vp10MCFBOTU8qgwUc8taeKXkD7vUZsw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-F7ZD4ml2P7q3K-AdLprfcg-1; Thu, 01 Jun 2023 00:26:42 -0400
X-MC-Unique: F7ZD4ml2P7q3K-AdLprfcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9171185A794;
	Thu,  1 Jun 2023 04:26:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7F312C04492;
	Thu,  1 Jun 2023 04:26:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E0731946A46;
	Thu,  1 Jun 2023 04:26:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A0DE1946A41
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 04:26:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFDCA112132D; Thu,  1 Jun 2023 04:26:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E8707112132C
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 04:26:38 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD23A800B2A
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 04:26:38 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-OV-3S4U7MdWIRUcq1DdtGA-1; Thu, 01 Jun 2023 00:26:36 -0400
X-MC-Unique: OV-3S4U7MdWIRUcq1DdtGA-1
Received: by mail-pl1-f170.google.com with SMTP id
 d9443c01a7336-1b075e13a5eso3419335ad.3
 for <dm-devel@redhat.com>; Wed, 31 May 2023 21:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685593596; x=1688185596;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=HH54ZfR07bvx2it5kMbT2XCoKq4FYr76emvIl28NWxo=;
 b=YsBPK5fQNAIl0UrQVdm/rxfagxzGQrWp0uJWQ/V2GhAKqOoS3234m+J34S61yRZYa1
 RIjz7cqP7UGOkuccYwYkwdg6qES0lFMK5bGP4H4Zo+MKwvTlFO/C39E1iekiV5YYwmfJ
 KOSAdZ7qyspwfZXPHXk/OnIAPlGPDyPTwuaDE5Za0nRy4utzVNZC+QS5MME5LJ3dIpvU
 6pmr1ur17Q6LHmz2WWcSdG0VBKx+mhdlhaCROgsvZwzOIFqVo+NYqavJrTwYI+1SiDLc
 FboO0HpZxlm48LknKoILrydVT3ZmH+pZ3neacqO3vTJV72bKlGLZLvffpmkutHjX5yhb
 6YWw==
X-Gm-Message-State: AC+VfDzDRO/nIENIB98B3wSFQwbZ1LRuLIGK/PwnxPTo77qpNhoraYGG
 GMhzK4YL5chUMgUuJYyUt0qK+Q==
X-Google-Smtp-Source: ACHHUZ6hlZU/MsjoyVz4yyhoe997V/qcrYIwn3uWW59qEXQKN9Rt7VfRZ5XiA6hG1XPeblBFMsaoCQ==
X-Received: by 2002:a17:902:724c:b0:1af:b9ed:1677 with SMTP id
 c12-20020a170902724c00b001afb9ed1677mr6568666pll.2.1685593595885; 
 Wed, 31 May 2023 21:26:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au.
 [49.179.0.188]) by smtp.gmail.com with ESMTPSA id
 f13-20020a170902684d00b001a980a23802sm2281781pln.111.2023.05.31.21.26.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 May 2023 21:26:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q4ZtQ-006NBe-17;
 Thu, 01 Jun 2023 14:26:32 +1000
Date: Thu, 1 Jun 2023 14:26:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZHgd+G7/gg0uOGMF@dread.disaster.area>
References: <cover.1685532726.git.johannes.thumshirn@wdc.com>
 <58fa893c24c67340a63323f09a179fefdca07f2a.1685532726.git.johannes.thumshirn@wdc.com>
 <ZHfMC86ktyLtIxNb@dread.disaster.area>
 <20230601042021.GA21768@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230601042021.GA21768@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v7 19/20] fs: iomap: use bio_add_folio_nofail
 where possible
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Song Liu <song@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-fsdevel@vger.kernel.org,
 gouha7@uniontech.com, Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 01, 2023 at 06:20:21AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 01, 2023 at 08:36:59AM +1000, Dave Chinner wrote:
> > We lose adjacent page merging with this change.
> 
> This is only used for adding the first folio to a brand new bio,
> so there is nothing to merge with yet at this point.

Ah, sorry, missed that. Carry on. :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD7BC77B7C
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 04:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685509129;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b9YEtjZiVklMFtUVQmQaHNmXKykP9oYUCuegbiZtTbQ=;
	b=YJlcHnkP4aiAfFAwAj/SmJZIM56URmuLCqmDbLrR5PDgFvQfbrSSU+qS0k5X5krg1iw+4Z
	esQNrRLI/MSJEjJ06RzRNDwFltJWaC2ctPAH+mXpoh1Bm7gCe6FOsSdhXRycpfxEYsq5XC
	WbLRU1iRLPlsgiosJVTpMRY1UgwyIsE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-muh3XtlfMcawLEQLJJftmg-1; Wed, 31 May 2023 00:58:48 -0400
X-MC-Unique: muh3XtlfMcawLEQLJJftmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B2938032E4;
	Wed, 31 May 2023 04:58:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 109C02166B25;
	Wed, 31 May 2023 04:58:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BBA2119465A0;
	Wed, 31 May 2023 04:58:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3FF421946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 04:58:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 290F840C6EC4; Wed, 31 May 2023 04:58:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2253A40C6CD0
 for <dm-devel@redhat.com>; Wed, 31 May 2023 04:58:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 031313C397C0
 for <dm-devel@redhat.com>; Wed, 31 May 2023 04:58:39 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-kfooFzeRNz-yHRAeSycghw-1; Wed, 31 May 2023 00:58:35 -0400
X-MC-Unique: kfooFzeRNz-yHRAeSycghw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 139EE636B9;
 Wed, 31 May 2023 04:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD00C433A1;
 Wed, 31 May 2023 04:58:33 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id
 2adb3069b0e04-4f4bd608cf4so6134493e87.1; 
 Tue, 30 May 2023 21:58:33 -0700 (PDT)
X-Gm-Message-State: AC+VfDxiYs8eefpYT0qgchcrT3tk3iq30txK1Nn21AAY5cco8UuYKcSK
 onLox+V7Mydm3OP+DyaEwnGOyqO26Jux8P36LVU=
X-Google-Smtp-Source: ACHHUZ7XDiYWJcs+q0AXYFH83FpH+4XZaAkwQNLTh6knjyPLIO1LGIR2Y7lAqiqnrlvTJ8gMp4sK/wzuHD8SIBdPb68=
X-Received: by 2002:a2e:a28f:0:b0:2ad:9acb:4849 with SMTP id
 k15-20020a2ea28f000000b002ad9acb4849mr1778554lja.47.1685509111386; Tue, 30
 May 2023 21:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <c60c6f46b70c96b528b6c4746918ea87c2a01473.1685461490.git.johannes.thumshirn@wdc.com>
 <20230531042502.GM32705@lst.de>
In-Reply-To: <20230531042502.GM32705@lst.de>
From: Song Liu <song@kernel.org>
Date: Tue, 30 May 2023 21:58:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW62vBccjUkCUmYr+OZSLgGozFzX4YyzP8OV+dvsLujCGg@mail.gmail.com>
Message-ID: <CAPhsuW62vBccjUkCUmYr+OZSLgGozFzX4YyzP8OV+dvsLujCGg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 15/20] md: raid1: check if adding pages to
 resync bio fails
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
 Dave Kleikamp <shaggy@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, gouhao@uniontech.com,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-fsdevel@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgOToyNeKAr1BNIENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPiB3cm90ZToKPgo+IFRvIG1lIHRoZXNlIGxvb2sgbGlrZSBfX2Jpb19hZGRfcGFnZSBj
YW5kaWRhdGVzLCBidXQgSSBndWVzcyBTb25nCj4gcHJlZmVycmVkIGl0IHRoaXMgd2F5PyAgSXQn
bGwgYWRkIGEgYml0IHBvaW50bGVzcyBib2lsZXJwbGF0ZSBjb2RlLAo+IGJ1dCBJJ20gb2sgd2l0
aCB0aGF0LgoKV2UgaGFkIHNvbWUgZGlzY3Vzc2lvbiBvbiB0aGlzIGluIHYyLCBhbmQgZGVjaWRl
ZCB0byBrZWVwIHRoZXNlCmFzc2VydC1saWtlIFdBUk5fT04oKS4KClRoYW5rcywKU29uZwoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=


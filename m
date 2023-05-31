Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11D1C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 05:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685597534;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lglP8oA04vuHI4XUErkBDF+0ueZY1H7Cn+ptcr5WEeU=;
	b=AwJ2NfRKWFfWnRBxN/z4Pg1I0TEek99XpcwRHwhPkDQolMKnf8o2o92g/HAIf1QSjYeVo4
	3MVw0R0FSHLzFii3/6jYwyJz4y3H2TEE6eiBOFlaXMd780X1y2H+fTVHfth1aCBP9p3u6b
	8qxx1KzsYsVMS6pwoDjJh8yfyfGiEcw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-ZyCExYd9NySoY3QCLVARlA-1; Thu, 01 Jun 2023 01:32:11 -0400
X-MC-Unique: ZyCExYd9NySoY3QCLVARlA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6D54800B2A;
	Thu,  1 Jun 2023 05:32:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3EA31492B0A;
	Thu,  1 Jun 2023 05:32:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F0712194343B;
	Thu,  1 Jun 2023 05:32:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E7BE1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 08:06:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2108B40CFD46; Wed, 31 May 2023 08:06:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 196FC40CFD49
 for <dm-devel@redhat.com>; Wed, 31 May 2023 08:06:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2B823C13502
 for <dm-devel@redhat.com>; Wed, 31 May 2023 08:06:55 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-348-Vs1NMWbwMbOfkwHw8Zxqzw-1; Wed,
 31 May 2023 04:06:52 -0400
X-MC-Unique: Vs1NMWbwMbOfkwHw8Zxqzw-1
Received: from [192.168.0.2] (ip5f5ae86a.dynamic.kabel-deutschland.de
 [95.90.232.106])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested) (Authenticated sender: pmenzel)
 by mx.molgen.mpg.de (Postfix) with ESMTPSA id B64BB61E4052B;
 Wed, 31 May 2023 09:54:23 +0200 (CEST)
Message-ID: <e510055e-da93-e9c1-d60b-f6b357d6611b@molgen.mpg.de>
Date: Wed, 31 May 2023 09:54:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Song Liu <song@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <c60c6f46b70c96b528b6c4746918ea87c2a01473.1685461490.git.johannes.thumshirn@wdc.com>
 <20230531042502.GM32705@lst.de>
 <CAPhsuW62vBccjUkCUmYr+OZSLgGozFzX4YyzP8OV+dvsLujCGg@mail.gmail.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAPhsuW62vBccjUkCUmYr+OZSLgGozFzX4YyzP8OV+dvsLujCGg@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Thu, 01 Jun 2023 05:32:06 +0000
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
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, gouhao@uniontech.com,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-fsdevel@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: molgen.mpg.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RGVhciBKb2hhbm5lcywKCgpUaGFuayB5b3UgZm9yIHlvdXIgcGF0Y2hlcy4KCkFtIDMxLjA1LjIz
IHVtIDA2OjU4IHNjaHJpZWIgU29uZyBMaXU6Cj4gT24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgOToy
NeKAr1BNIENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPiB3cm90ZToKPj4KPj4gVG8gbWUg
dGhlc2UgbG9vayBsaWtlIF9fYmlvX2FkZF9wYWdlIGNhbmRpZGF0ZXMsIGJ1dCBJIGd1ZXNzIFNv
bmcKPj4gcHJlZmVycmVkIGl0IHRoaXMgd2F5PyAgSXQnbGwgYWRkIGEgYml0IHBvaW50bGVzcyBi
b2lsZXJwbGF0ZSBjb2RlLAo+PiBidXQgSSdtIG9rIHdpdGggdGhhdC4KPiAKPiBXZSBoYWQgc29t
ZSBkaXNjdXNzaW9uIG9uIHRoaXMgaW4gdjIsIGFuZCBkZWNpZGVkIHRvIGtlZXAgdGhlc2UKPiBh
c3NlcnQtbGlrZSBXQVJOX09OKCkuCgppdOKAmWQgYmUgZ3JlYXQgaWYgeW91IGFkZGVkIGEgc3Vt
bWFyeS9ub3RlIG9mIHRoZSBkaXNjdXNzaW9uIHRvIHRoZSAKY29tbWl0IG1lc3NhZ2UuCgoKS2lu
ZCByZWdhcmRzLAoKUGF1bAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=


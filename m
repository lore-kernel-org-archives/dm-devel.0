Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68862C7618E
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 22:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682116234;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=amhvbGcF8QBB1LlND4dzXcfS3EzyEYYEvgg554WxSa4=;
	b=PYe6oegcE8h6CVRPObLbDrp05dMeNHmtJwyQPll3dG+0kpAvIsuXeZSSazYnlE8Sstzknp
	5sTDsex2tfegeR/+BtGjIu+3YN/FSNoKd9JfMeHPVsvIGHyFTjvr2bF4Zsrcw/BkRV+TlE
	Bcpdxzzu98F7gfoif2ZKA2JwH/5SXAw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-xJ5KbYGTNUG2vc5NF0PsIQ-1; Fri, 21 Apr 2023 18:30:31 -0400
X-MC-Unique: xJ5KbYGTNUG2vc5NF0PsIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D39A3806118;
	Fri, 21 Apr 2023 22:30:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D68F140C2064;
	Fri, 21 Apr 2023 22:30:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A0CFB1946A40;
	Fri, 21 Apr 2023 22:30:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D22C319466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Apr 2023 22:30:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6DBA3C16026; Fri, 21 Apr 2023 22:30:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 65954C16024
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 22:30:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B24E85A588
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 22:30:27 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-y-XoavwwPamNFdU7yh74kg-1; Fri, 21 Apr 2023 18:30:25 -0400
X-MC-Unique: y-XoavwwPamNFdU7yh74kg-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red
 Hat Linux)) id 1ppzGj-00BxAj-0p; Fri, 21 Apr 2023 22:30:17 +0000
Date: Fri, 21 Apr 2023 15:30:17 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <ZEMOeb9Bt60jxV+d@bombadil.infradead.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
 <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
 <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 3/5] iomap: simplify iomap_init() with
 PAGE_SECTORS
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
Cc: djwong@kernel.org, philipp.reisner@linbit.com, linux-mm@kvack.org,
 dm-devel@redhat.com, agk@redhat.com, drbd-dev@lists.linbit.com,
 christoph.boehmwalder@linbit.com, Matthew Wilcox <willy@infradead.org>,
 hch@infradead.org, p.raghav@samsung.com, senozhatsky@chromium.org,
 snitzer@kernel.org, linux-block@vger.kernel.org, kbusch@kernel.org,
 da.gomez@samsung.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 minchan@kernel.org, patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBBcHIgMjEsIDIwMjMgYXQgMDQ6MjQ6NTdQTSAtMDYwMCwgSmVucyBBeGJvZSB3cm90
ZToKPiBPbiA0LzIxLzIzIDQ6MDLigK9QTSwgTHVpcyBDaGFtYmVybGFpbiB3cm90ZToKPiA+IE9u
IEZyaSwgQXByIDIxLCAyMDIzIGF0IDA5OjE0OjAwUE0gKzAxMDAsIE1hdHRoZXcgV2lsY294IHdy
b3RlOgo+ID4+IE9uIEZyaSwgQXByIDIxLCAyMDIzIGF0IDEyOjU4OjA1UE0gLTA3MDAsIEx1aXMg
Q2hhbWJlcmxhaW4gd3JvdGU6Cj4gPj4+IEp1c3QgdXNlIHRoZSBQQUdFX1NFQ1RPUlMgZ2VuZXJp
YyBkZWZpbmUuIFRoaXMgcHJvZHVjZXMgbm8gZnVuY3Rpb25hbAo+ID4+PiBjaGFuZ2VzLiBXaGls
ZSBhdCBpdCB1c2UgbGVmdCBzaGlmdCB0byBzaW1wbGlmeSB0aGlzIGV2ZW4gZnVydGhlci4KPiA+
Pgo+ID4+IEhvdyBpcyBGT08gPDwgMiBzaW1wbGVyIHRoYW4gRk9PICogND8KPiA+Pgo+ID4+PiAt
CXJldHVybiBiaW9zZXRfaW5pdCgmaW9tYXBfaW9lbmRfYmlvc2V0LCA0ICogKFBBR0VfU0laRSAv
IFNFQ1RPUl9TSVpFKSwKPiA+Pj4gKwlyZXR1cm4gYmlvc2V0X2luaXQoJmlvbWFwX2lvZW5kX2Jp
b3NldCwgUEFHRV9TRUNUT1JTIDw8IDIsCj4gPiAKPiA+IFdlIGNvdWxkIGp1c3QgZG86Cj4gPiAK
PiA+IAo+ID4gLQlyZXR1cm4gYmlvc2V0X2luaXQoJmlvbWFwX2lvZW5kX2Jpb3NldCwgNCAqIChQ
QUdFX1NJWkUgLyBTRUNUT1JfU0laRSksCj4gPiArCXJldHVybiBiaW9zZXRfaW5pdCgmaW9tYXBf
aW9lbmRfYmlvc2V0LCA0ICogUEFHRV9TRUNUT1JTLAo+ID4gCj4gPiBUaGUgc2hpZnQganVzdCBz
ZWVtZWQgb3B0aW1hbCBpZiB3ZSdyZSBqdXN0IGdvaW5nIHRvIGNoYW5nZSBpdC4KPiAKPiBJdCdz
IGdvaW5nIHRvIGdlbmVyYXRlIHRoZSBzYW1lIGNvZGUsIGJ1dCB0aGUgbXVsdGlwbGljYXRpb24g
aXMgYXJndWFibHkKPiBlYXNpZXIgdG8gcmVhZCAob3IgaGFyZGVyIHRvIG1pc3JlYWQpLgoKVGhl
biBsZXQncyBzdGljayB3aXRoIHRoZSA0ICogUEFHRV9TRUNUT1JTLiBMZXQgbWUga25vdyBpZiB5
b3UgbmVlZCBhbm90aGVyCnBhdGNoLgoKICBMdWlzCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==


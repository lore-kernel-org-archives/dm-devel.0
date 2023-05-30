Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6196C7EE37
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480085;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3SWdfQ4BRWFId7zJB7i8VQVMfWXTSh4Kv9/2kx2/kUA=;
	b=FtgQ+JtMHfrVs6r3NJlSZ91Zxt1DDq3eBkdUdd9/LJ0HCExyq9J/xkVGSKJXTE9MEUbPRj
	oZ7iH9J2nmaPZOVw4FcXRKTdAkH1DCwBjZi+gwseYpVH8RcjMPT3ugNmKdRfdVM4z9ftul
	0enoN90jFDV7OEt6sWgg2gE1Jds2oaQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-h5LSJ_msO3KR_5ve52xblg-1; Tue, 30 May 2023 16:54:44 -0400
X-MC-Unique: h5LSJ_msO3KR_5ve52xblg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79DD72808E97;
	Tue, 30 May 2023 20:54:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63D34140E95B;
	Tue, 30 May 2023 20:54:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7F7419465BA;
	Tue, 30 May 2023 20:54:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7CAB71946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:46:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 52C1F40C6CCC; Tue, 30 May 2023 20:46:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B76D40C6EC4
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:46:59 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C358858F14
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:46:59 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-jmc7WPD0NRKYMjZAse595g-1; Tue, 30 May 2023 16:46:57 -0400
X-MC-Unique: jmc7WPD0NRKYMjZAse595g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 248DF62F78;
 Tue, 30 May 2023 20:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EDBC4339C;
 Tue, 30 May 2023 20:41:09 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id
 38308e7fff4ca-2af189d323fso2841901fa.1; 
 Tue, 30 May 2023 13:41:09 -0700 (PDT)
X-Gm-Message-State: AC+VfDx3a7J3jJqB/NPRTwWcePPW4DY0HrB3Vk8Fz4oZjg1rXppIt/h4
 SinK+Ft3pL506Fg/h10/3Tlrwe8SN0SIfx+Kqls=
X-Google-Smtp-Source: ACHHUZ7vuf2vQNikh852gIOeYbs1mAspWrnHLpuRQ0WVk/9d/YVdWPAiSzLnXbcDRj80He113UbugMRuu4yM7AjsQxc=
X-Received: by 2002:a2e:a222:0:b0:2af:18a9:782f with SMTP id
 i2-20020a2ea222000000b002af18a9782fmr4570675ljm.0.1685479267531; Tue, 30 May
 2023 13:41:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <d7cfd04d410accee4148d8c0e51230bcb8b4bb8f.1685461490.git.johannes.thumshirn@wdc.com>
In-Reply-To: <d7cfd04d410accee4148d8c0e51230bcb8b4bb8f.1685461490.git.johannes.thumshirn@wdc.com>
From: Song Liu <song@kernel.org>
Date: Tue, 30 May 2023 13:40:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6hZWx3Jx0UOc20mf06c5QS5vfDKF_nauzm0mLkr3Xhsw@mail.gmail.com>
Message-ID: <CAPhsuW6hZWx3Jx0UOc20mf06c5QS5vfDKF_nauzm0mLkr3Xhsw@mail.gmail.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: Re: [dm-devel] [PATCH v6 13/20] md: check for failure when adding
 pages in alloc_behind_master_bio
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
 Christoph Hellwig <hch@lst.de>, Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgODo1MOKAr0FNIEpvaGFubmVzIFRodW1zaGlybgo8am9o
YW5uZXMudGh1bXNoaXJuQHdkYy5jb20+IHdyb3RlOgo+Cj4gYWxsb2NfYmVoaW5kX21hc3Rlcl9i
aW8oKSBjYW4gcG9zc2libHkgYWRkIG11bHRpcGxlIHBhZ2VzIHRvIGEgYmlvLCBidXQgaXQKPiBp
cyBub3QgY2hlY2tpbmcgZm9yIHRoZSByZXR1cm4gdmFsdWUgb2YgYmlvX2FkZF9wYWdlKCkgaWYg
YWRkaW5nIHJlYWxseQo+IHN1Y2NlZWRlZC4KPgo+IENoZWNrIGlmIHRoZSBwYWdlIGFkZGluZyBz
dWNjZWVkZWQgYW5kIGlmIG5vdCBiYWlsIG91dC4KPgo+IFJldmlld2VkLWJ5OiBEYW1pZW4gTGUg
TW9hbCA8ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+Cj4gU2lnbmVkLW9mZi1ieTog
Sm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4KCkFja2VkLWJ5
OiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPgoKPiAtLS0KPiAgZHJpdmVycy9tZC9yYWlkMS5j
IHwgNSArKysrLQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pCj4KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlkMS5jIGIvZHJpdmVycy9tZC9yYWlk
MS5jCj4gaW5kZXggNjhhOWUyZDk5ODViLi44MjgzZWYxNzdmNmMgMTAwNjQ0Cj4gLS0tIGEvZHJp
dmVycy9tZC9yYWlkMS5jCj4gKysrIGIvZHJpdmVycy9tZC9yYWlkMS5jCj4gQEAgLTExNDcsNyAr
MTE0NywxMCBAQCBzdGF0aWMgdm9pZCBhbGxvY19iZWhpbmRfbWFzdGVyX2JpbyhzdHJ1Y3QgcjFi
aW8gKnIxX2JpbywKPiAgICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5KCFwYWdlKSkKPiAgICAg
ICAgICAgICAgICAgICAgICAgICBnb3RvIGZyZWVfcGFnZXM7Cj4KPiAtICAgICAgICAgICAgICAg
YmlvX2FkZF9wYWdlKGJlaGluZF9iaW8sIHBhZ2UsIGxlbiwgMCk7Cj4gKyAgICAgICAgICAgICAg
IGlmICghYmlvX2FkZF9wYWdlKGJlaGluZF9iaW8sIHBhZ2UsIGxlbiwgMCkpIHsKPiArICAgICAg
ICAgICAgICAgICAgICAgICBmcmVlX3BhZ2UocGFnZSk7Cj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgZ290byBmcmVlX3BhZ2VzOwo+ICsgICAgICAgICAgICAgICB9Cj4KPiAgICAgICAgICAgICAg
ICAgc2l6ZSAtPSBsZW47Cj4gICAgICAgICAgICAgICAgIGkrKzsKPiAtLQo+IDIuNDAuMQo+Cgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


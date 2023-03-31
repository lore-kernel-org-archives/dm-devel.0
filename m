Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80384C77B6C
	for <dm-devel@archiver.kernel.org>; Mon,  3 Apr 2023 06:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680504269;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FlRUjjYnG9Qs4NIEe5Vr9tdMXql/dgDrwHTNkPZMco8=;
	b=jScoAmA5ItU2rruSTEQ7T93K/gNDO8q+gcwjgCarhnVQmWjOTgVY7E/VgD4ONNxsNbmHXk
	gJ63mSsiYALS7Y48IwieWmk+wE1iUXeF6JXRrQAtncZPOhbCg7p+YSKNYvTStH2W7GocHq
	IIPp24lK4qZYxCQNnMf3QS10Na1dJB0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-WIy4PdokPwqnpVMKqwtu3A-1; Mon, 03 Apr 2023 02:44:26 -0400
X-MC-Unique: WIy4PdokPwqnpVMKqwtu3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADBFF85A5A3;
	Mon,  3 Apr 2023 06:44:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44DA12027045;
	Mon,  3 Apr 2023 06:44:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 231481946A43;
	Mon,  3 Apr 2023 06:44:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CB60F19465BC
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 18:14:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 111C41121315; Fri, 31 Mar 2023 18:14:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 099EF1121314
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 18:14:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC2B91C008A5
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 18:14:11 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-CgTbE5QbOYqWsXgT241DLg-1; Fri, 31 Mar 2023 14:14:07 -0400
X-MC-Unique: CgTbE5QbOYqWsXgT241DLg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1960D62B26;
 Fri, 31 Mar 2023 18:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8041EC4339C;
 Fri, 31 Mar 2023 18:14:05 +0000 (UTC)
Received: by mail-lf1-f46.google.com with SMTP id h25so30016428lfv.6;
 Fri, 31 Mar 2023 11:14:05 -0700 (PDT)
X-Gm-Message-State: AAQBX9cTVgtL5S+kgH/5jF3+0usx+74dPPZ5WWxzkJU50rqoC8X319XH
 N1YLBbQMjpPLkhbqzqqBuoRKc33DUSQG00hwKCg=
X-Google-Smtp-Source: AKy350bGczgf8cOPQ3B8DjpL0OvNqhqJf0gVtuLTkWI0qZ++fzJqZuNXbM/Tji+xZXn5DWwX7QOe8uol0L5QJx5bU4Q=
X-Received: by 2002:ac2:5610:0:b0:4dd:a4e1:4861 with SMTP id
 v16-20020ac25610000000b004dda4e14861mr8251248lfd.3.1680286443592; Fri, 31 Mar
 2023 11:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <8b8a3bb2db8c5183ef36c1810f2ac776ac526327.1680172791.git.johannes.thumshirn@wdc.com>
In-Reply-To: <8b8a3bb2db8c5183ef36c1810f2ac776ac526327.1680172791.git.johannes.thumshirn@wdc.com>
From: Song Liu <song@kernel.org>
Date: Fri, 31 Mar 2023 11:13:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7a+mpn+VprfA2mC5Fc+M9BFq8i6d-y+-o5G1u5dOsk2Q@mail.gmail.com>
Message-ID: <CAPhsuW7a+mpn+VprfA2mC5Fc+M9BFq8i6d-y+-o5G1u5dOsk2Q@mail.gmail.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 03 Apr 2023 06:44:20 +0000
Subject: Re: [dm-devel] [PATCH v2 17/19] md: raid1: check if adding pages to
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
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMzAsIDIwMjMgYXQgMzo0NOKAr0FNIEpvaGFubmVzIFRodW1zaGlybgo8am9o
YW5uZXMudGh1bXNoaXJuQHdkYy5jb20+IHdyb3RlOgo+Cj4gQ2hlY2sgaWYgYWRkaW5nIHBhZ2Vz
IHRvIHJlc3luYyBiaW8gZmFpbHMgYW5kIGlmIGJhaWwgb3V0Lgo+Cj4gQXMgdGhlIGNvbW1lbnQg
YWJvdmUgc3VnZ2VzdHMgdGhpcyBjYW5ub3QgaGFwcGVuLCBXQVJOIGlmIGl0IGFjdHVhbGx5Cj4g
aGFwcGVucy4KPgo+IFRoaXMgd2F5IHdlIGNhbiBtYXJrIGJpb19hZGRfcGFnZXMgYXMgX19tdXN0
X2NoZWNrLgo+Cj4gU2lnbmVkLW9mZi1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50
aHVtc2hpcm5Ad2RjLmNvbT4KPiBSZXZpZXdlZC1ieTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5s
ZW1vYWxAb3BlbnNvdXJjZS53ZGMuY29tPgo+IC0tLQo+ICBkcml2ZXJzL21kL3JhaWQxLTEwLmMg
fCAgNyArKysrKystCj4gIGRyaXZlcnMvbWQvcmFpZDEwLmMgICB8IDEyICsrKysrKysrKystLQo+
ICAyIGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlkMS0xMC5jIGIvZHJpdmVycy9tZC9yYWlkMS0xMC5j
Cj4gaW5kZXggZTYxZjZjYWQ0ZTA4Li5jMjFiNmMxNjg3NTEgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVy
cy9tZC9yYWlkMS0xMC5jCj4gKysrIGIvZHJpdmVycy9tZC9yYWlkMS0xMC5jCj4gQEAgLTEwNSw3
ICsxMDUsMTIgQEAgc3RhdGljIHZvaWQgbWRfYmlvX3Jlc2V0X3Jlc3luY19wYWdlcyhzdHJ1Y3Qg
YmlvICpiaW8sIHN0cnVjdCByZXN5bmNfcGFnZXMgKnJwLAo+ICAgICAgICAgICAgICAgICAgKiB3
b24ndCBmYWlsIGJlY2F1c2UgdGhlIHZlYyB0YWJsZSBpcyBiaWcKPiAgICAgICAgICAgICAgICAg
ICogZW5vdWdoIHRvIGhvbGQgYWxsIHRoZXNlIHBhZ2VzCj4gICAgICAgICAgICAgICAgICAqLwoK
V2Uga25vdyB0aGVzZSB3b24ndCBmYWlsLiBTaGFsbCB3ZSBqdXN0IHVzZSBfX2Jpb19hZGRfcGFn
ZT8KClRoYW5rcywKU29uZwoKPiAtICAgICAgICAgICAgICAgYmlvX2FkZF9wYWdlKGJpbywgcGFn
ZSwgbGVuLCAwKTsKPiArICAgICAgICAgICAgICAgaWYgKFdBUk5fT04oIWJpb19hZGRfcGFnZShi
aW8sIHBhZ2UsIGxlbiwgMCkpKSB7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgYmlvLT5iaV9z
dGF0dXMgPSBCTEtfU1RTX1JFU09VUkNFOwo+ICsgICAgICAgICAgICAgICAgICAgICAgIGJpb19l
bmRpbyhiaW8pOwo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybjsKPiArICAgICAgICAg
ICAgICAgfQo+ICsKPiAgICAgICAgICAgICAgICAgc2l6ZSAtPSBsZW47Cj4gICAgICAgICB9IHdo
aWxlIChpZHgrKyA8IFJFU1lOQ19QQUdFUyAmJiBzaXplID4gMCk7Cj4gIH0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9tZC9yYWlkMTAuYyBiL2RyaXZlcnMvbWQvcmFpZDEwLmMKPiBpbmRleCA2YzY2
MzU3ZjkyZjUuLjU2ODJkYmE1MmZkMyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL3JhaWQxMC5j
Cj4gKysrIGIvZHJpdmVycy9tZC9yYWlkMTAuYwo+IEBAIC0zODA4LDcgKzM4MDgsMTEgQEAgc3Rh
dGljIHNlY3Rvcl90IHJhaWQxMF9zeW5jX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc2Vj
dG9yX3Qgc2VjdG9yX25yLAo+ICAgICAgICAgICAgICAgICAgICAgICAgICAqIHdvbid0IGZhaWwg
YmVjYXVzZSB0aGUgdmVjIHRhYmxlIGlzIGJpZyBlbm91Z2gKPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgKiB0byBob2xkIGFsbCB0aGVzZSBwYWdlcwo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAqLwo+IC0gICAgICAgICAgICAgICAgICAgICAgIGJpb19hZGRfcGFnZShiaW8sIHBhZ2UsIGxl
biwgMCk7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKFdBUk5fT04oIWJpb19hZGRfcGFn
ZShiaW8sIHBhZ2UsIGxlbiwgMCkpKSB7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBiaW8tPmJpX3N0YXR1cyA9IEJMS19TVFNfUkVTT1VSQ0U7Cj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBiaW9fZW5kaW8oYmlvKTsKPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGdvdG8gZ2l2ZXVwOwo+ICsgICAgICAgICAgICAgICAgICAgICAgIH0KPiAgICAgICAg
ICAgICAgICAgfQo+ICAgICAgICAgICAgICAgICBucl9zZWN0b3JzICs9IGxlbj4+OTsKPiAgICAg
ICAgICAgICAgICAgc2VjdG9yX25yICs9IGxlbj4+OTsKPiBAQCAtNDk4OSw3ICs0OTkzLDExIEBA
IHN0YXRpYyBzZWN0b3JfdCByZXNoYXBlX3JlcXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc2Vj
dG9yX3Qgc2VjdG9yX25yLAo+ICAgICAgICAgICAgICAgICAgICAgICAgICAqIHdvbid0IGZhaWwg
YmVjYXVzZSB0aGUgdmVjIHRhYmxlIGlzIGJpZyBlbm91Z2gKPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgKiB0byBob2xkIGFsbCB0aGVzZSBwYWdlcwo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAqLwo+IC0gICAgICAgICAgICAgICAgICAgICAgIGJpb19hZGRfcGFnZShiaW8sIHBhZ2UsIGxl
biwgMCk7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKFdBUk5fT04oIWJpb19hZGRfcGFn
ZShiaW8sIHBhZ2UsIGxlbiwgMCkpKSB7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBiaW8tPmJpX3N0YXR1cyA9IEJMS19TVFNfUkVTT1VSQ0U7Cj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBiaW9fZW5kaW8oYmlvKTsKPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiBzZWN0b3JzX2RvbmU7IC8qIFhYWDogaXMgdGhpcyBjb3JyZWN0PyAqLwo+
ICsgICAgICAgICAgICAgICAgICAgICAgIH0KPiAgICAgICAgICAgICAgICAgfQo+ICAgICAgICAg
ICAgICAgICBzZWN0b3JfbnIgKz0gbGVuID4+IDk7Cj4gICAgICAgICAgICAgICAgIG5yX3NlY3Rv
cnMgKz0gbGVuID4+IDk7Cj4gLS0KPiAyLjM5LjIKPgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbAo=


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E012C43334
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 16:46:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-f1vtdDQXPMyFt_WnarTZNA-1; Tue, 14 Jun 2022 12:46:12 -0400
X-MC-Unique: f1vtdDQXPMyFt_WnarTZNA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA4161C16B42;
	Tue, 14 Jun 2022 16:46:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 918641410DDB;
	Tue, 14 Jun 2022 16:46:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3ACF8194707C;
	Tue, 14 Jun 2022 16:46:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 271261947067
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 16:46:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 122B92166B29; Tue, 14 Jun 2022 16:46:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D9B02166B26
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:46:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6AEB8001EA
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:46:07 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-mnkDb591MaywLK-x6ypH2A-1; Tue, 14 Jun 2022 12:46:00 -0400
X-MC-Unique: mnkDb591MaywLK-x6ypH2A-1
Received: by mail-pj1-f41.google.com with SMTP id
 t3-20020a17090a510300b001ea87ef9a3dso9574145pjh.4
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:46:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:from:to:cc:references:in-reply-to
 :content-transfer-encoding;
 bh=tuHSMAswfP4PDhL4XI5a/Llq4rMmNVqNDh3Ui2JM9rU=;
 b=YiR+0AbnmddMZTHMZGwO5S2mhy1Nzi+vJFFd8T8c7cHVDPdJMv1kiBKgc6zqsW+XXZ
 Dazw+ycEMuY4OwVAIw4bJqkQeeYTw3JXJr03xK+GSqa4ILlx97wNIuZXCdnzxmfzFVd3
 vpnMolH+IDUUZUNWYoV4v5LTVeOOFC3rJqADkeh70TR95nZDhnVrDlc2oMUgUBXfJ538
 mOOUlPLuCUxmPWWByqOxwTflm33KOBdtgSx1LlyunaHY+cltEZ8VR5giU329Uf3scYcD
 JPTPfnk6ZTrIsvikgE03O/GE88c+4NEwgAYG3xHAwHPLOHc8jxzDZZ+WT7AN048KQqe7
 Bs1A==
X-Gm-Message-State: AJIora/IbiMKVhZLGYyqVH9vLAjxjrlHXm7XdTabXVfQqmJ3/uTmJ2Zl
 NxhmCyiO7jvtbjNaAKcw80o=
X-Google-Smtp-Source: AGRyM1sl2/QyN23Bh9vXZmMJcEtm2ae2dgvu7qiWC0RwOL+/NkIgeyj3t4A8uWlUfj5gVwnybtmQdw==
X-Received: by 2002:a17:903:230b:b0:167:5310:9eed with SMTP id
 d11-20020a170903230b00b0016753109eedmr5522694plh.46.1655225159302; 
 Tue, 14 Jun 2022 09:45:59 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ab60:e1ea:e2eb:c1b6?
 ([2620:15c:211:201:ab60:e1ea:e2eb:c1b6])
 by smtp.gmail.com with ESMTPSA id
 i132-20020a62878a000000b0051827128aeasm7811406pfe.131.2022.06.14.09.45.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Jun 2022 09:45:58 -0700 (PDT)
Message-ID: <dd5e7690-ffad-69c2-5d73-07b35eedeae6@acm.org>
Date: Tue, 14 Jun 2022 09:45:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From: Bart Van Assche <bvanassche@acm.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-4-hch@lst.de>
 <02468bd8-f2b3-1d5c-01dd-c9e9d6d5b09e@acm.org>
In-Reply-To: <02468bd8-f2b3-1d5c-01dd-c9e9d6d5b09e@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 3/6] block: open code blk_max_size_offset in
 blk_rq_get_max_sectors
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNi8xNC8yMiAwOTo0MywgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+IE9uIDYvMTQvMjIgMDI6
MDksIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+PiBibGtfcnFfZ2V0X21heF9zZWN0b3JzIGFs
d2F5cyB1c2VzIHEtPmxpbWl0cy5jaHVua19zZWN0b3JzIGFzIHRoZQo+PiBjaHVua19zZWN0b3Jz
IGFyZ3VtZW50LCBhbmQgYWxyZWFkeSBjaGVja3MgZm9yIG1heF9zZWN0b3JzIHRocm91Z2ggdGhl
Cj4+IGNhbGwgdG8gYmxrX3F1ZXVlX2dldF9tYXhfc2VjdG9ycy7CoCBUaGF0IG1lYW5zIG11Y2gg
b2YKPj4gYmxrX21heF9zaXplX29mZnNldCBpcyBub3QgbmVlZGVkIGFuZCBvcGVuIGNvZGluZyBp
dCBzaW1wbGlmaWVzIHRoZSBjb2RlLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4KPj4gLS0tCj4+IMKgIGJsb2NrL2Jsay1tZXJnZS5jIHwgOSArKysr
Ky0tLS0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMo
LSkKPj4KPj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1tZXJnZS5jIGIvYmxvY2svYmxrLW1lcmdl
LmMKPj4gaW5kZXggZGIyZTAzYzhhZjdmNC4uZGYwMDNlY2ZiZDQ3NCAxMDA2NDQKPj4gLS0tIGEv
YmxvY2svYmxrLW1lcmdlLmMKPj4gKysrIGIvYmxvY2svYmxrLW1lcmdlLmMKPj4gQEAgLTU2Niwx
NyArNTY2LDE4IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IAo+PiBibGtfcnFfZ2V0X21h
eF9zZWN0b3JzKHN0cnVjdCByZXF1ZXN0ICpycSwKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNlY3Rvcl90IG9mZnNldCkKPj4gwqAgewo+
PiDCoMKgwqDCoMKgIHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxID0gcnEtPnE7Cj4+ICvCoMKgwqAg
dW5zaWduZWQgaW50IG1heF9zZWN0b3JzOwo+PiDCoMKgwqDCoMKgIGlmIChibGtfcnFfaXNfcGFz
c3Rocm91Z2gocnEpKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHEtPmxpbWl0cy5tYXhf
aHdfc2VjdG9yczsKPj4gK8KgwqDCoCBtYXhfc2VjdG9ycyA9IGJsa19xdWV1ZV9nZXRfbWF4X3Nl
Y3RvcnMocSwgcmVxX29wKHJxKSk7Cj4+IMKgwqDCoMKgwqAgaWYgKCFxLT5saW1pdHMuY2h1bmtf
c2VjdG9ycyB8fAo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmVxX29wKHJxKSA9PSBSRVFfT1BfRElT
Q0FSRCB8fAo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmVxX29wKHJxKSA9PSBSRVFfT1BfU0VDVVJF
X0VSQVNFKQo+PiAtwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGJsa19xdWV1ZV9nZXRfbWF4X3NlY3Rv
cnMocSwgcmVxX29wKHJxKSk7Cj4+IC0KPj4gLcKgwqDCoCByZXR1cm4gbWluKGJsa19tYXhfc2l6
ZV9vZmZzZXQocSwgb2Zmc2V0LCAwKSwKPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmxrX3F1
ZXVlX2dldF9tYXhfc2VjdG9ycyhxLCByZXFfb3AocnEpKSk7Cj4+ICvCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gbWF4X3NlY3RvcnM7Cj4+ICvCoMKgwqAgcmV0dXJuIG1pbihtYXhfc2VjdG9ycywKPj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgIGJsa19jaHVua19zZWN0b3JzX2xlZnQob2Zmc2V0LCBxLT5s
aW1pdHMuY2h1bmtfc2VjdG9ycykpOwo+PiDCoCB9Cj4gCj4gYmxrX3NldF9kZWZhdWx0X2xpbWl0
cygpIGluaXRpYWxpemVzIGNodW5rX3NlY3RvcnMgdG8gemVybyBhbmQgCj4gYmxrX2NodW5rX3Nl
Y3RvcnNfbGVmdCgpIHRyaWdnZXJzIGEgZGl2aXNpb24gYnkgemVybyBpZiBhIHplcm8gaXMgcGFz
c2VkIAo+IGFzIHRoZSBzZWNvbmQgYXJndW1lbnQuIFdoYXQgYW0gSSBtaXNzaW5nPwoKQW5zd2Vy
aW5nIG15IG93biBxdWVzdGlvbjogSSBvdmVybG9va2VkIG9uZSBvZiB0aGUgcmV0dXJuIHN0YXRl
bWVudHMuCgpSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


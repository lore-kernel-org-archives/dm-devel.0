Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0048FE7D0C5
	for <dm-devel@archiver.kernel.org>; Tue, 26 Sep 2023 00:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695686702;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tpy/J0dbCV5oDmUPWcZvcDMevmo5v4zxWM+UagiPNF8=;
	b=ZyzEIHKUiEVparxusB4ZhRXj68DlhF3bMyB/zS9JjcjSJQN87lxOBWgduiuglNuSTkPyox
	XC943D/jV/SHgHBUcrOTrYnNyhhZ15NvibsD5Oif3xtN4E78fd6ADLsUIHB+NDSDGjbpbT
	so1YNqHlkgJQiCAFuSGRvcLXDRIp8gs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-CWl84MrnP9S7yng0N_CZlQ-1; Mon, 25 Sep 2023 20:04:59 -0400
X-MC-Unique: CWl84MrnP9S7yng0N_CZlQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 884E88007A4;
	Tue, 26 Sep 2023 00:04:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 07E2440C6E76;
	Tue, 26 Sep 2023 00:04:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BCAA4194658F;
	Tue, 26 Sep 2023 00:04:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 10FB2194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 23:59:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0C55E40C6EA8; Mon, 25 Sep 2023 23:59:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 05A4440C6E76
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 23:59:09 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A3DB3800E93
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 23:59:09 +0000 (UTC)
Received: from mail.ultracoder.org (188.227.94.15.ptspb.net [188.227.94.15])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-slLYhp0_PsGc6dtATp1aGA-1; Mon,
 25 Sep 2023 19:59:06 -0400
X-MC-Unique: slLYhp0_PsGc6dtATp1aGA-1
Message-ID: <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
Date: Tue, 26 Sep 2023 02:59:02 +0300
MIME-Version: 1.0
From: Kirill Kirilenko <kirill@ultracoder.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
 <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
In-Reply-To: <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] fstrim on raid1 LV with writemostly PV leads to
 system freeze
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Roman Mamedov <rm@romanrm.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ultracoder.org
Content-Language: ru-RU, en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjUuMDkuMjAyMyAwNTo1OCArMDMwMCwgWXUgS3VhaSB3cm90ZToKPiBSb21hbiBhbmQgS2ly
aWxsLCBjYW4geW91IHRlc3QgdGhlIGZvbGxvd2luZyBwYXRjaD8KPgo+IFRoYW5rcywKPiBLdWFp
Cj4KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlkMS5jIGIvZHJpdmVycy9tZC9yYWlkMS5j
Cj4gaW5kZXggNGIzMGExNzQyMTYyLi40OTYzZjg2NGVmOTkgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVy
cy9tZC9yYWlkMS5jCj4gKysrIGIvZHJpdmVycy9tZC9yYWlkMS5jCj4gQEAgLTEzNDUsNiArMTM0
NSw3IEBAIHN0YXRpYyB2b2lkIHJhaWQxX3dyaXRlX3JlcXVlc3Qoc3RydWN0IG1kZGV2Cj4gKm1k
ZGV2LCBzdHJ1Y3QgYmlvICpiaW8sCj4gwqDCoMKgwqDCoMKgwqAgaW50IGZpcnN0X2Nsb25lOwo+
IMKgwqDCoMKgwqDCoMKgIGludCBtYXhfc2VjdG9yczsKPiDCoMKgwqDCoMKgwqDCoCBib29sIHdy
aXRlX2JlaGluZCA9IGZhbHNlOwo+ICvCoMKgwqDCoMKgwqAgYm9vbCBpc19kaXNjYXJkID0gKGJp
b19vcChiaW8pID09IFJFUV9PUF9ESVNDQVJEKTsKPgo+IMKgwqDCoMKgwqDCoMKgIGlmIChtZGRl
dl9pc19jbHVzdGVyZWQobWRkZXYpICYmCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1kX2Ns
dXN0ZXJfb3BzLT5hcmVhX3Jlc3luY2luZyhtZGRldiwgV1JJVEUsCj4gQEAgLTE0MDUsNyArMTQw
Niw3IEBAIHN0YXRpYyB2b2lkIHJhaWQxX3dyaXRlX3JlcXVlc3Qoc3RydWN0IG1kZGV2Cj4gKm1k
ZGV2LCBzdHJ1Y3QgYmlvICpiaW8sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
KiB3cml0ZS1tb3N0bHksIHdoaWNoIG1lYW5zIHdlIGNvdWxkIGFsbG9jYXRlIHdyaXRlCj4gYmVo
aW5kCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBiaW8gbGF0ZXIuCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAocmRldiAmJiB0ZXN0X2JpdChXcml0ZU1vc3RseSwgJnJkZXYtPmZsYWdzKSkK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIWlzX2Rpc2NhcmQgJiYgcmRldiAm
JiB0ZXN0X2JpdChXcml0ZU1vc3RseSwKPiAmcmRldi0+ZmxhZ3MpKQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgd3JpdGVfYmVoaW5kID0gdHJ1ZTsKPgo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmRldiAmJiB1bmxpa2VseSh0ZXN0
X2JpdChCbG9ja2VkLCAmcmRldi0+ZmxhZ3MpKSkgewoKVGhhbmsgeW91LiBJIGNhbiBjb25maXJt
LCB0aGF0IHlvdXIgcGF0Y2ggZWxpbWluYXRlcyBmcmVlemVzIGR1cmluZwonZnN0cmltJyBleGVj
dXRpb24uIFRlc3RlZCBvbiBrZXJuZWwgNi41LjAuClN0aWxsICdmc3RyaW0nIHRha2VzIG1vcmUg
dGhhbiAyIG1pbnV0ZXMsIGJ1dCBJIGJlbGlldmUgaXQncyBub3JtYWwgdG8gYQpmaWxlIHN5c3Rl
bSB3aXRoIDFNKyBpbm9kZXMuCgpQcm9iYWJseSBJJ20gd3JvbmcgaGVyZSwgYnV0IHRvIG1lIHRo
aXMgZG9lc24ndCBsb29rIGxpa2UgYSBzb2x1dGlvbiwKbW9yZSBsaWtlIGEgbWFza2luZyB0aGUg
cmVhbCBwcm9ibGVtLgpFdmVuIHdpdGggVFJJTSBvcGVyYXRpb25zIHNwbGl0IGluIDFNQiBwaWVj
ZXMsIEkgZG9uJ3QgZXhwZWN0IGtlcm5lbCB0bwpmcmVlemUuCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


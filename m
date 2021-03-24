Return-Path: <SRS0=Kq+o=IW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42AFC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:33:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E9E861A10
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:33:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E9E861A10
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-lLGYvjbWNo2Bo8j49Ow3QQ-1; Wed, 24 Mar 2021 11:33:30 -0400
X-MC-Unique: lLGYvjbWNo2Bo8j49Ow3QQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07A1680006E;
	Wed, 24 Mar 2021 15:33:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 991F22B3CD;
	Wed, 24 Mar 2021 15:33:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 018E21800215;
	Wed, 24 Mar 2021 15:33:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12OFWime029281 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 11:32:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1B6F12026D60; Wed, 24 Mar 2021 15:32:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15B0C2026D64
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 15:32:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50A8510DCE82
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 15:32:40 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-193--JGCLkvfNRu7oEkGrUTnWQ-1;
	Wed, 24 Mar 2021 11:32:35 -0400
X-MC-Unique: -JGCLkvfNRu7oEkGrUTnWQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C4E32AF0D;
	Wed, 24 Mar 2021 15:32:32 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210324121927.362525-1-ming.lei@redhat.com>
	<20210324121927.362525-6-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <614dcf6d-2b45-394c-d295-c14c14dc9070@suse.de>
Date: Wed, 24 Mar 2021 16:32:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210324121927.362525-6-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12OFWime029281
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V3 05/13] block: add req flag of REQ_POLL_CTX
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yNC8yMSAxOjE5IFBNLCBNaW5nIExlaSB3cm90ZToKPiBBZGQgb25lIHJlcSBmbGFnIFJF
UV9QT0xMX0NUWCB3aGljaCB3aWxsIGJlIHVzZWQgaW4gdGhlIGZvbGxvd2luZyBwYXRjaCBmb3IK
PiBzdXBwb3J0aW5nIGJpbyBiYXNlZCBJTyBwb2xsaW5nLgo+IAo+IEV4YWN0bHkgdGhpcyBmbGFn
IGNhbiBoZWxwIHVzIHRvIGRvOgo+IAo+IDEpIHJlcXVlc3QgZmxhZyBpcyBjbG9uZWQgaW4gYmlv
X2Zhc3RfY2xvbmUoKSwgc28gaWYgd2UgbWFyayBvbmUgRlMgYmlvCj4gYXMgUkVRX1BPTExfQ1RY
LCBhbGwgYmlvcyBjbG9uZWQgZnJvbSB0aGlzIEZTIGJpbyB3aWxsIGJlIG1hcmtlZCBhcwo+IFJF
UV9QT0xMX0NUWCB0b28uCj4gCj4gMikgY3JlYXRlIHBlci10YXNrIGlvIHBvbGxpbmcgY29udGV4
dCBpZiB0aGUgYmlvIGJhc2VkIHF1ZXVlIHN1cHBvcnRzCj4gcG9sbGluZyBhbmQgdGhlIHN1Ym1p
dHRlZCBiaW8gaXMgSElQUkkuIFBlci10YXNrIGlvIHBvbGwgY29udGV4dCB3aWxsIGJlCj4gY3Jl
YXRlZCBkdXJpbmcgc3VibWl0X2JpbygpIGJlZm9yZSBtYXJraW5nIHRoaXMgSElQUkkgYmlvIGFz
IFJFUV9QT0xMX0NUWC4KPiBUaGVuIHdlIGNhbiBhdm9pZCB0byBjcmVhdGUgc3VjaCBpbyBwb2xs
aW5nIGNvbnRleHQgaWYgb25lIGNsb25lZCBiaW8gd2l0aAo+IFJFUV9QT0xMX0NUWCBpcyBzdWJt
aXR0ZWQgZnJvbSBhbm90aGVyIGtlcm5lbCBjb250ZXh0Lgo+IAo+IDMpIGZvciBzdXBwb3J0aW5n
IGJpbyBiYXNlZCBpbyBwb2xsaW5nLCB3ZSBuZWVkIHRvIHBvbGwgSU9zIGZyb20gYWxsCj4gdW5k
ZXJseWluZyBxdWV1ZXMgb2YgdGhlIGJpbyBkZXZpY2UsIHRoaXMgd2F5IGhlbHAgdXMgdG8gcmVj
b2duaXplIHdoaWNoCj4gSU8gbmVlZHMgdG8gcG9sbGVkIGluIGJpbyBiYXNlZCBzdHlsZSwgd2hp
Y2ggd2lsbCBiZSBhcHBsaWVkIGluCj4gZm9sbG93aW5nIHBhdGNoLgo+IAo+IFNpZ25lZC1vZmYt
Ynk6IE1pbmcgTGVpIDxtaW5nLmxlaUByZWRoYXQuY29tPgo+IC0tLQo+ICAgYmxvY2svYmxrLWNv
cmUuYyAgICAgICAgICB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysrKy0KPiAgIGluY2x1ZGUv
bGludXgvYmxrX3R5cGVzLmggfCAgNCArKysrCj4gICAyIGZpbGVzIGNoYW5nZWQsIDI4IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiAKPiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLWNvcmUu
YyBiL2Jsb2NrL2Jsay1jb3JlLmMKPiBpbmRleCA0NjcxYmJmMzFmZDMuLmViMDdkNjFjZmRjMiAx
MDA2NDQKPiAtLS0gYS9ibG9jay9ibGstY29yZS5jCj4gKysrIGIvYmxvY2svYmxrLWNvcmUuYwo+
IEBAIC04NDAsMTEgKzg0MCwzMCBAQCBzdGF0aWMgaW5saW5lIGJvb2wgYmxrX3F1ZXVlX3N1cHBv
cnRfYmlvX3BvbGwoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEpCj4gICBzdGF0aWMgaW5saW5lIHZv
aWQgYmxrX2Jpb19wb2xsX3ByZXByb2Nlc3Moc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCj4gICAJ
CXN0cnVjdCBiaW8gKmJpbykKPiAgIHsKPiArCWJvb2wgbXE7Cj4gKwo+ICAgCWlmICghKGJpby0+
Ymlfb3BmICYgUkVRX0hJUFJJKSkKPiAgIAkJcmV0dXJuOwo+ICAgCj4gLQlpZiAoIWJsa19xdWV1
ZV9wb2xsKHEpIHx8ICghcXVldWVfaXNfbXEocSkgJiYgIWJsa19nZXRfYmlvX3BvbGxfY3R4KCkp
KQo+ICsJLyoKPiArCSAqIENhbid0IHN1cHBvcnQgYmlvIGJhc2VkIElPIHBvbGxpbmcgd2l0aG91
dCBwZXItdGFzayBwb2xsIGN0eAo+ICsJICoKPiArCSAqIFdlIGhhdmUgY3JlYXRlZCBwZXItdGFz
ayBpbyBwb2xsIGNvbnRleHQsIGFuZCBtYXJrIHRoaXMKPiArCSAqIGJpbyBhcyBSRVFfUE9MTF9D
VFgsIHNvOiAxKSBpZiBhbnkgY2xvbmVkIGJpbyBmcm9tIHRoaXMgYmlvIGlzCj4gKwkgKiBzdWJt
aXR0ZWQgZnJvbSBhbm90aGVyIGtlcm5lbCBjb250ZXh0LCB3ZSB3b24ndCBjcmVhdGUgYmlvCj4g
KwkgKiBwb2xsIGNvbnRleHQgZm9yIGl0LCBhbmQgdGhhdCBiaW8gY2FuIGJlIGNvbXBsZXRlZCBi
eSBJUlE7Cj4gKwkgKiAyKSBJZiBzdWNoIGJpbyBpcyBzdWJtaXR0ZWQgZnJvbSBjdXJyZW50IGNv
bnRleHQsIHdlIHdpbGwKPiArCSAqIGNvbXBsZXRlIGl0IHZpYSBibGtfcG9sbCgpOyAzKSBJZiBk
cml2ZXIga25vd3MgdGhhdCBvbmUKPiArCSAqIHVuZGVybHlpbmcgYmlvIGFsbG9jYXRlZCBmcm9t
IGRyaXZlciBpcyBmb3IgRlMgYmlvLCBtZWFudGltZQo+ICsJICogaXQgaXMgc3VibWl0dGVkIGlu
IGN1cnJlbnQgY29udGV4dCwgZHJpdmVyIGNhbiBtYXJrIHN1Y2ggYmlvCj4gKwkgKiBhcyBSRVFf
SElQUkkgJiBSRVFfUE9MTF9DVFggbWFudWFsbHksIHNvIHRoZSBiaW8gY2FuIGJlIGNvbXBsZXRl
ZAo+ICsJICogdmlhIGJsa19wb2xsIHRvby4KPiArCSAqLwo+ICsJbXEgPSBxdWV1ZV9pc19tcShx
KTsKPiArCWlmICghYmxrX3F1ZXVlX3BvbGwocSkgfHwgKCFtcSAmJiAhYmxrX2dldF9iaW9fcG9s
bF9jdHgoKSkpCj4gICAJCWJpby0+Ymlfb3BmICY9IH5SRVFfSElQUkk7Cj4gKwllbHNlIGlmICgh
bXEpCj4gKwkJYmlvLT5iaV9vcGYgfD0gUkVRX1BPTExfQ1RYOwo+ICAgfQo+ICAgCj4gICBzdGF0
aWMgbm9pbmxpbmVfZm9yX3N0YWNrIGJvb2wgc3VibWl0X2Jpb19jaGVja3Moc3RydWN0IGJpbyAq
YmlvKQo+IEBAIC04OTQsOCArOTEzLDEyIEBAIHN0YXRpYyBub2lubGluZV9mb3Jfc3RhY2sgYm9v
bCBzdWJtaXRfYmlvX2NoZWNrcyhzdHJ1Y3QgYmlvICpiaW8pCj4gICAJLyoKPiAgIAkgKiBDcmVh
dGUgcGVyLXRhc2sgaW8gcG9sbCBjdHggaWYgYmlvIHBvbGxpbmcgc3VwcG9ydGVkIGFuZCBISVBS
SQo+ICAgCSAqIHNldC4KPiArCSAqCj4gKwkgKiBJZiBSRVFfUE9MTF9DVFggaXNuJ3Qgc2V0IGZv
ciB0aGlzIEhJUFJJIGJpbywgd2UgdGhpbmsgaXQgb3JpZ2luYXRlZAo+ICsJICogZnJvbSBGUyBh
bmQgYWxsb2NhdGUgaW8gcG9sbGluZyBjb250ZXh0Lgo+ICAgCSAqLwo+ICAgCWJsa19jcmVhdGVf
aW9fY29udGV4dChxLCBibGtfcXVldWVfc3VwcG9ydF9iaW9fcG9sbChxKSAmJgo+ICsJCQkhKGJp
by0+Ymlfb3BmICYgUkVRX1BPTExfQ1RYKSAmJgo+ICAgCQkJKGJpby0+Ymlfb3BmICYgUkVRX0hJ
UFJJKSk7Cj4gICAKPiAgIAlibGtfYmlvX3BvbGxfcHJlcHJvY2VzcyhxLCBiaW8pOwo+IGRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIGIvaW5jbHVkZS9saW51eC9ibGtfdHlw
ZXMuaAo+IGluZGV4IGRiMDI2YjZlYzE1YS4uOTkxNjBkNTg4YzJkIDEwMDY0NAo+IC0tLSBhL2lu
Y2x1ZGUvbGludXgvYmxrX3R5cGVzLmgKPiArKysgYi9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5o
Cj4gQEAgLTM5NCw2ICszOTQsOSBAQCBlbnVtIHJlcV9mbGFnX2JpdHMgewo+ICAgCj4gICAJX19S
RVFfSElQUkksCj4gICAKPiArCS8qIGZvciBtYXJraW5nIElPcyBvcmlnaW5hdGVkIGZyb20gc2Ft
ZSBGUyBiaW8gaW4gc2FtZSBjb250ZXh0ICovCj4gKwlfX1JFUV9QT0xMX0NUWCwKPiArCj4gICAJ
LyogZm9yIGRyaXZlciB1c2UgKi8KPiAgIAlfX1JFUV9EUlYsCj4gICAJX19SRVFfU1dBUCwJCS8q
IHN3YXBwaW5nIHJlcXVlc3QuICovCj4gQEAgLTQxOCw2ICs0MjEsNyBAQCBlbnVtIHJlcV9mbGFn
X2JpdHMgewo+ICAgCj4gICAjZGVmaW5lIFJFUV9OT1VOTUFQCQkoMVVMTCA8PCBfX1JFUV9OT1VO
TUFQKQo+ICAgI2RlZmluZSBSRVFfSElQUkkJCSgxVUxMIDw8IF9fUkVRX0hJUFJJKQo+ICsjZGVm
aW5lIFJFUV9QT0xMX0NUWAkJCSgxVUxMIDw8IF9fUkVRX1BPTExfQ1RYKQo+ICAgCj4gICAjZGVm
aW5lIFJFUV9EUlYJCQkoMVVMTCA8PCBfX1JFUV9EUlYpCj4gICAjZGVmaW5lIFJFUV9TV0FQCQko
MVVMTCA8PCBfX1JFUV9TV0FQKQo+IApXaGF0IGhhcHBlbnMgdG8gc3BsaXQgYmlvcz8KV2lsbCB0
aGV5IGJlIHRyYWNrZWQgc2ltaWxhcmx5IHRvIGNsb25lZCBiaW9zPwpJZiBzbywgc2hvdWxkbid0
IHlvdSBkb2N1bWVudCB0aGF0IGhlcmUsIHRvbz8KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhh
bm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFy
ZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgK
U1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5i
ZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4IElt
ZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


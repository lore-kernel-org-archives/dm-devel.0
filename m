Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1029C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 19:53:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0561A61181
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 19:53:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0561A61181
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-xMdC-Z0ZPeuo2seLlsiANw-1; Fri, 15 Oct 2021 15:53:33 -0400
X-MC-Unique: xMdC-Z0ZPeuo2seLlsiANw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE790802C87;
	Fri, 15 Oct 2021 19:53:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C108E5D9DE;
	Fri, 15 Oct 2021 19:53:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D2B1F4A703;
	Fri, 15 Oct 2021 19:53:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FJoDdJ027359 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 15:50:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9E9F8400E410; Fri, 15 Oct 2021 19:50:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 999A6400F3FB
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 19:50:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A72A811E7F
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 19:50:13 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-27-noUltoaMOg-X-mPZEURBLQ-1; Fri, 15 Oct 2021 15:50:09 -0400
X-MC-Unique: noUltoaMOg-X-mPZEURBLQ-1
Received: from [2601:1c0:6280:3f0::aa0b]
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mbTDS-008dhJ-4T; Fri, 15 Oct 2021 19:50:06 +0000
To: Deven Bowers <deven.desai@linux.microsoft.com>, corbet@lwn.net,
	axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
	eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
	<9c1eec3b-8bb0-9e3e-d6e5-18c670ac2b03@infradead.org>
	<7bd474ae-3dbe-4351-fa10-ee68e5c7267c@linux.microsoft.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e4bc834b-5483-604d-7fa1-e5eafdd5ebf5@infradead.org>
Date: Fri, 15 Oct 2021 12:50:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7bd474ae-3dbe-4351-fa10-ee68e5c7267c@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	jannh@google.com, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-audit@redhat.com
Subject: Re: [dm-devel] [RFC PATCH v7 07/16] ipe: add auditing support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTAvMTUvMjEgMTI6MjUgUE0sIERldmVuIEJvd2VycyB3cm90ZToKPiBPbiAxMC8xMy8yMDIx
IDM6NTQgUE0sIFJhbmR5IER1bmxhcCB3cm90ZToKPj4gSGksCj4+Cj4+IE9uIDEwLzEzLzIxIDEy
OjA2IFBNLCBkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29tIHdyb3RlOgo+Pj4gZGlmZiAt
LWdpdCBhL3NlY3VyaXR5L2lwZS9LY29uZmlnIGIvc2VjdXJpdHkvaXBlL0tjb25maWcKPj4+IGlu
ZGV4IGM0NTAzMDgzZTkyZC4uZWY1NTZiNjZlNjc0IDEwMDY0NAo+Pj4gLS0tIGEvc2VjdXJpdHkv
aXBlL0tjb25maWcKPj4+ICsrKyBiL3NlY3VyaXR5L2lwZS9LY29uZmlnCj4+PiBAQCAtMTcsMyAr
MTcsNTUgQEAgbWVudWNvbmZpZyBTRUNVUklUWV9JUEUKPj4+IMKgwqDCoMKgwqDCoMKgIHJlcXVp
cmVtZW50cyBvbiB0aGUgZmx5Lgo+Pj4gwqAgwqDCoMKgwqDCoMKgwqAgSWYgdW5zdXJlLCBhbnN3
ZXIgTi4KPj4+ICsKPj4+ICtpZiBTRUNVUklUWV9JUEUKPj4+ICsKPj4+ICtjaG9pY2UKPj4+ICvC
oMKgwqAgcHJvbXB0ICJIYXNoIGFsZ29yaXRobSB1c2VkIGluIGF1ZGl0aW5nIHBvbGljaWVzIgo+
Pj4gK8KgwqDCoCBkZWZhdWx0IElQRV9BVURJVF9IQVNIX1NIQTEKPj4+ICvCoMKgwqAgZGVwZW5k
cyBvbiBBVURJVAo+Pj4gK8KgwqDCoCBoZWxwCj4+PiArwqDCoMKgwqDCoMKgwqAgU3BlY2lmeSB0
aGUgaGFzaCBhbGdvcml0aG0gdXNlZCB3aGVuIGF1ZGl0aW5nIHBvbGljaWVzLgo+Pj4gK8KgwqDC
oMKgwqDCoMKgIFRoZSBoYXNoIGlzIHVzZWQgdG8gdW5pcXVlbHkgaWRlbnRpZnkgYSBwb2xpY3kg
ZnJvbSBvdGhlcgo+Pj4gK8KgwqDCoMKgwqDCoMKgIHBvbGljaWVzIG9uIHRoZSBzeXN0ZW0uCj4+
PiArCj4+PiArwqDCoMKgwqDCoMKgwqAgSWYgdW5zdXJlLCBsZWF2ZSBkZWZhdWx0Lgo+Pj4gKwo+
Pj4gK8KgwqDCoCBjb25maWcgSVBFX0FVRElUX0hBU0hfU0hBMQo+Pj4gK8KgwqDCoMKgwqDCoMKg
IGJvb2wgInNoYTEiCj4+PiArwqDCoMKgwqDCoMKgwqAgZGVwZW5kcyBvbiBDUllQVE9fU0hBMQo+
Pj4gK8KgwqDCoMKgwqDCoMKgIGhlbHAKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFVzZSB0
aGUgU0hBMTI4IGFsZ29yaXRobSB0byBoYXNoIHBvbGljaWVzCj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpbiB0aGUgYXVkaXQgcmVjb3Jkcy4KPj4+ICsKPj4+ICvCoMKgwqAgY29uZmlnIElQ
RV9BVURJVF9IQVNIX1NIQTI1Ngo+Pj4gK8KgwqDCoMKgwqDCoMKgIGJvb2wgInNoYTI1NiIKPj4+
ICvCoMKgwqDCoMKgwqDCoCBkZXBlbmRzIG9uIENSWVBUT19TSEEyNTYKPj4+ICvCoMKgwqDCoMKg
wqDCoCBoZWxwCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBVc2UgdGhlIFNIQTI1NiBhbGdv
cml0aG0gdG8gaGFzaCBwb2xpY2llcwo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW4gdGhl
IGF1ZGl0IHJlY29yZHMuCj4+PiArCj4+PiArwqDCoMKgIGNvbmZpZyBJUEVfQVVESVRfSEFTSF9T
SEEzODQKPj4+ICvCoMKgwqDCoMKgwqDCoCBib29sICJzaGEzODQiCj4+PiArwqDCoMKgwqDCoMKg
wqAgZGVwZW5kcyBvbiBDUllQVE9fU0hBNTEyCj4+PiArwqDCoMKgwqDCoMKgwqAgaGVscAo+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVXNlIHRoZSBTSEEzODQgYWxnb3JpdGhtIHRvIGhhc2gg
cG9saWNpZXMKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGluIHRoZSBhdWRpdCByZWNvcmRz
Cj4+PiArCj4+PiArwqDCoMKgIGNvbmZpZyBJUEVfQVVESVRfSEFTSF9TSEE1MTIKPj4+ICvCoMKg
wqDCoMKgwqDCoCBib29sICJzaGE1MTIiCj4+PiArwqDCoMKgwqDCoMKgwqAgZGVwZW5kcyBvbiBD
UllQVE9fU0hBNTEyCj4+PiArwqDCoMKgwqDCoMKgwqAgaGVscAo+Pj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgVXNlIHRoZSBTSEE1MTIgYWxnb3JpdGhtIHRvIGhhc2ggcG9saWNpZXMKPj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGluIHRoZSBhdWRpdCByZWNvcmRzCj4+PiArZW5kY2hvaWNl
Cj4+PiArCj4+PiArY29uZmlnIElQRV9BVURJVF9IQVNIX0FMRwo+Pj4gK8KgwqDCoCBzdHJpbmcK
Pj4+ICvCoMKgwqAgZGVwZW5kcyBvbiBBVURJVAo+Pj4gK8KgwqDCoCBkZWZhdWx0ICJzaGExIiBp
ZiBJUEVfQVVESVRfSEFTSF9TSEExCj4+PiArwqDCoMKgIGRlZmF1bHQgInNoYTI1NiIgaWYgSVBF
X0FVRElUX0hBU0hfU0hBMjU2Cj4+PiArwqDCoMKgIGRlZmF1bHQgInNoYTM4NCIgaWYgSVBFX0FV
RElUX0hBU0hfU0hBMzg0Cj4+PiArwqDCoMKgIGRlZmF1bHQgInNoYTUxMiIgaWYgSVBFX0FVRElU
X0hBU0hfU0hBNTEyCj4+PiArCj4+PiArZW5kaWYKPj4KPj4gUGxlYXNlIGZvbGxvdyBjb2Rpbmct
c3R5bGUgZm9yIEtjb25maWcgZmlsZXM6Cj4+Cj4+IChmcm9tIERvY3VtZW50YXRpb24vcHJvY2Vz
cy9jb2Rpbmctc3R5bGUucnN0LCBzZWN0aW9uIDEwKToKPj4KPj4gRm9yIGFsbCBvZiB0aGUgS2Nv
bmZpZyogY29uZmlndXJhdGlvbiBmaWxlcyB0aHJvdWdob3V0IHRoZSBzb3VyY2UgdHJlZSwKPj4g
dGhlIGluZGVudGF0aW9uIGlzIHNvbWV3aGF0IGRpZmZlcmVudC7CoCBMaW5lcyB1bmRlciBhIGBg
Y29uZmlnYGAgZGVmaW5pdGlvbgo+PiBhcmUgaW5kZW50ZWQgd2l0aCBvbmUgdGFiLCB3aGlsZSBo
ZWxwIHRleHQgaXMgaW5kZW50ZWQgYW4gYWRkaXRpb25hbCB0d28KPj4gc3BhY2VzLgo+Pgo+IE9v
Zi4gVGhhdCdzIGVtYmFycmFzc2luZy4gU29ycnksIEknbGwgZml4IHRoaXMgZm9yIHY4Lgo+IAo+
IFdoaWxlIEknbSBhdCBpdCwgaXMgdGhlIGhlbHAgdGV4dCByZXF1aXJlZCBmb3IgY2hvaWNlIGNv
bmZpZ3M/Cj4gY2hlY2twYXRjaCAtLXN0cmljdCBjb21wbGFpbnMgd2l0aCBhIHdhcm5pbmcgd2l0
aG91dCB0aGVtLCBidXQKPiBJIHNlZSBvdGhlciBwbGFjZXMgaW4gdGhlIHRyZWUgd2hlcmUgaGVs
cCB0ZXh0IGlzIG9taXR0ZWQgZm9yCj4gdGhlc2UgY29uZmlncyBhdHRhY2hlZCB0byBhIGNob2lj
ZS4KCkRvZXMgY2hlY2twYXRjaCBjb21wbGFpbiBhYm91dCB3aGF0IHlvdSBoYXZlIGFib3ZlCm9y
IGRpZCB5b3UgYWRkIHRoYXQgaGVscCB0ZXh0IHRvIGtlZXAgaXQgZnJvbSBjb21wbGFpbmluZz8K
Cgo+IERvY3VtZW50YXRpb24vcHJvY2Vzcy8qIGRvZXNuJ3Qgc2VlbSB0byBoYXZlIGFueSBndWlk
YW5jZSwgbm9yCj4gRG9jdW1lbnRhdGlvbi9rYnVpbGQvKiBvbiB3aGV0aGVyIGl0IGlzIHNhZmUg
dG8gaWdub3JlIHRoYXQKPiBjaGVja3BhdGNoIHdhcm5pbmcuCgpZZWFoLCBJIGRvbid0IHRoaW5r
IHRoYXQgd2UgaGF2ZSBhbnkgZ29vZCBndWlkYW5jZSBvbiB0aGF0LgoKSSB3b3VsZCBzYXkgdGhh
dCBpZiB0aGUgY2hvaWNlIHByb21wdCBwcm92aWRlcyBnb29kL2FkZXF1YXRlCmhlbHAgaW5mbywg
dGhlbiBlYWNoICdjb25maWcnIGluc2lkZSB0aGUgY2hvaWNlIGJsb2NrIGRvZXMgbm90Cm5lZWQg
aGVscCB0ZXh0LiBPVE9ILCBpZiB0aGUgY2hvaWNlIHByb21wdCBoYXMgbGl0dGxlL25vIGhlbHAK
aW5mbywgdGhlbiBlYWNoICdjb25maWcnIHVuZGVyIGl0IHNob3VsZCBoYXZlIHNvbWUgdXNlZnVs
IGluZm8uCgpJIG9ubHkgbG9va2VkIGluIGFyY2gveDg2L0tjb25maWcsIGluaXQvS2NvbmZpZywg
YW5kIGxpYi9LY29uZmlnLmRlYnVnLApidXQgeW91IGNhbiBzZWUgZWl0aGVyIGhlbHAgdGV4dCBt
ZXRob2QgYmVpbmcgdXNlZCBpbiB0aG9zZS4KCkFuZCB0aGVuIGlmIHRoZSBoZWxwIHRleHQgaXMg
YWRlcXVhdGUgaW4gZWl0aGVyIG9uZSBvZiB0aG9zZQptZXRob2RzLCBJIHdvdWxkIGp1c3QgaWdu
b3JlIHRoZSBjaGVja3BhdGNoIGNvbXBsYWludHMuCkl0J3MganVzdCBhIGd1aWRhbmNlIHRvb2wu
CgpIVEguCgotLSAKflJhbmR5CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs


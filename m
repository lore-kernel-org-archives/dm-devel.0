Return-Path: <SRS0=m4z6=PO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07847C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:03:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 79EA061078
	for <dm-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 79EA061078
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-bAfNqyuwMKuVHTWjc8d1tw-1; Tue, 26 Oct 2021 15:03:48 -0400
X-MC-Unique: bAfNqyuwMKuVHTWjc8d1tw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF968801FCE;
	Tue, 26 Oct 2021 19:03:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF3D460BF1;
	Tue, 26 Oct 2021 19:03:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 76CE74A704;
	Tue, 26 Oct 2021 19:03:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19QJ3bxr022641 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Oct 2021 15:03:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8E8F351DD; Tue, 26 Oct 2021 19:03:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8829E51DC
	for <dm-devel@redhat.com>; Tue, 26 Oct 2021 19:03:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A2DC185A7A4
	for <dm-devel@redhat.com>; Tue, 26 Oct 2021 19:03:33 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-544-96iZeawKMW6BGCuaX9pwtg-1;
	Tue, 26 Oct 2021 15:03:27 -0400
X-MC-Unique: 96iZeawKMW6BGCuaX9pwtg-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2B51A20A5C1D;
	Tue, 26 Oct 2021 12:03:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2B51A20A5C1D
Message-ID: <6865843a-0b64-2149-7652-aff7369532b9@linux.microsoft.com>
Date: Tue, 26 Oct 2021 12:03:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: Randy Dunlap <rdunlap@infradead.org>, corbet@lwn.net, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu, 
	paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
	<9c1eec3b-8bb0-9e3e-d6e5-18c670ac2b03@infradead.org>
	<7bd474ae-3dbe-4351-fa10-ee68e5c7267c@linux.microsoft.com>
	<e4bc834b-5483-604d-7fa1-e5eafdd5ebf5@infradead.org>
In-Reply-To: <e4bc834b-5483-604d-7fa1-e5eafdd5ebf5@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19QJ3bxr022641
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDEwLzE1LzIwMjEgMTI6NTAgUE0sIFJhbmR5IER1bmxhcCB3cm90ZToKPiBPbiAxMC8xNS8y
MSAxMjoyNSBQTSwgRGV2ZW4gQm93ZXJzIHdyb3RlOgo+PiBPbiAxMC8xMy8yMDIxIDM6NTQgUE0s
IFJhbmR5IER1bmxhcCB3cm90ZToKPj4+IEhpLAo+Pj4KPj4+IE9uIDEwLzEzLzIxIDEyOjA2IFBN
LCBkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29tIHdyb3RlOgo+Pj4+IGRpZmYgLS1naXQg
YS9zZWN1cml0eS9pcGUvS2NvbmZpZyBiL3NlY3VyaXR5L2lwZS9LY29uZmlnCj4+Pj4gaW5kZXgg
YzQ1MDMwODNlOTJkLi5lZjU1NmI2NmU2NzQgMTAwNjQ0Cj4+Pj4gLS0tIGEvc2VjdXJpdHkvaXBl
L0tjb25maWcKPj4+PiArKysgYi9zZWN1cml0eS9pcGUvS2NvbmZpZwo+Pj4+IEBAIC0xNywzICsx
Nyw1NSBAQCBtZW51Y29uZmlnIFNFQ1VSSVRZX0lQRQo+Pj4+IMKgwqDCoMKgwqDCoMKgIHJlcXVp
cmVtZW50cyBvbiB0aGUgZmx5Lgo+Pj4+IMKgIMKgwqDCoMKgwqDCoMKgIElmIHVuc3VyZSwgYW5z
d2VyIE4uCj4+Pj4gKwo+Pj4+ICtpZiBTRUNVUklUWV9JUEUKPj4+PiArCj4+Pj4gK2Nob2ljZQo+
Pj4+ICvCoMKgwqAgcHJvbXB0ICJIYXNoIGFsZ29yaXRobSB1c2VkIGluIGF1ZGl0aW5nIHBvbGlj
aWVzIgo+Pj4+ICvCoMKgwqAgZGVmYXVsdCBJUEVfQVVESVRfSEFTSF9TSEExCj4+Pj4gK8KgwqDC
oCBkZXBlbmRzIG9uIEFVRElUCj4+Pj4gK8KgwqDCoCBoZWxwCj4+Pj4gK8KgwqDCoMKgwqDCoMKg
IFNwZWNpZnkgdGhlIGhhc2ggYWxnb3JpdGhtIHVzZWQgd2hlbiBhdWRpdGluZyBwb2xpY2llcy4K
Pj4+PiArwqDCoMKgwqDCoMKgwqAgVGhlIGhhc2ggaXMgdXNlZCB0byB1bmlxdWVseSBpZGVudGlm
eSBhIHBvbGljeSBmcm9tIG90aGVyCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHBvbGljaWVzIG9uIHRo
ZSBzeXN0ZW0uCj4+Pj4gKwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBJZiB1bnN1cmUsIGxlYXZlIGRl
ZmF1bHQuCj4+Pj4gKwo+Pj4+ICvCoMKgwqAgY29uZmlnIElQRV9BVURJVF9IQVNIX1NIQTEKPj4+
PiArwqDCoMKgwqDCoMKgwqAgYm9vbCAic2hhMSIKPj4+PiArwqDCoMKgwqDCoMKgwqAgZGVwZW5k
cyBvbiBDUllQVE9fU0hBMQo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBoZWxwCj4+Pj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgVXNlIHRoZSBTSEExMjggYWxnb3JpdGhtIHRvIGhhc2ggcG9saWNpZXMK
Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbiB0aGUgYXVkaXQgcmVjb3Jkcy4KPj4+PiAr
Cj4+Pj4gK8KgwqDCoCBjb25maWcgSVBFX0FVRElUX0hBU0hfU0hBMjU2Cj4+Pj4gK8KgwqDCoMKg
wqDCoMKgIGJvb2wgInNoYTI1NiIKPj4+PiArwqDCoMKgwqDCoMKgwqAgZGVwZW5kcyBvbiBDUllQ
VE9fU0hBMjU2Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGhlbHAKPj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBVc2UgdGhlIFNIQTI1NiBhbGdvcml0aG0gdG8gaGFzaCBwb2xpY2llcwo+Pj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGluIHRoZSBhdWRpdCByZWNvcmRzLgo+Pj4+ICsKPj4+PiAr
wqDCoMKgIGNvbmZpZyBJUEVfQVVESVRfSEFTSF9TSEEzODQKPj4+PiArwqDCoMKgwqDCoMKgwqAg
Ym9vbCAic2hhMzg0Igo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBkZXBlbmRzIG9uIENSWVBUT19TSEE1
MTIKPj4+PiArwqDCoMKgwqDCoMKgwqAgaGVscAo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IFVzZSB0aGUgU0hBMzg0IGFsZ29yaXRobSB0byBoYXNoIHBvbGljaWVzCj4+Pj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgaW4gdGhlIGF1ZGl0IHJlY29yZHMKPj4+PiArCj4+Pj4gK8KgwqDCoCBj
b25maWcgSVBFX0FVRElUX0hBU0hfU0hBNTEyCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGJvb2wgInNo
YTUxMiIKPj4+PiArwqDCoMKgwqDCoMKgwqAgZGVwZW5kcyBvbiBDUllQVE9fU0hBNTEyCj4+Pj4g
K8KgwqDCoMKgwqDCoMKgIGhlbHAKPj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBVc2UgdGhl
IFNIQTUxMiBhbGdvcml0aG0gdG8gaGFzaCBwb2xpY2llcwo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGluIHRoZSBhdWRpdCByZWNvcmRzCj4+Pj4gK2VuZGNob2ljZQo+Pj4+ICsKPj4+PiAr
Y29uZmlnIElQRV9BVURJVF9IQVNIX0FMRwo+Pj4+ICvCoMKgwqAgc3RyaW5nCj4+Pj4gK8KgwqDC
oCBkZXBlbmRzIG9uIEFVRElUCj4+Pj4gK8KgwqDCoCBkZWZhdWx0ICJzaGExIiBpZiBJUEVfQVVE
SVRfSEFTSF9TSEExCj4+Pj4gK8KgwqDCoCBkZWZhdWx0ICJzaGEyNTYiIGlmIElQRV9BVURJVF9I
QVNIX1NIQTI1Ngo+Pj4+ICvCoMKgwqAgZGVmYXVsdCAic2hhMzg0IiBpZiBJUEVfQVVESVRfSEFT
SF9TSEEzODQKPj4+PiArwqDCoMKgIGRlZmF1bHQgInNoYTUxMiIgaWYgSVBFX0FVRElUX0hBU0hf
U0hBNTEyCj4+Pj4gKwo+Pj4+ICtlbmRpZgo+Pj4KPj4+IFBsZWFzZSBmb2xsb3cgY29kaW5nLXN0
eWxlIGZvciBLY29uZmlnIGZpbGVzOgo+Pj4KPj4+IChmcm9tIERvY3VtZW50YXRpb24vcHJvY2Vz
cy9jb2Rpbmctc3R5bGUucnN0LCBzZWN0aW9uIDEwKToKPj4+Cj4+PiBGb3IgYWxsIG9mIHRoZSBL
Y29uZmlnKiBjb25maWd1cmF0aW9uIGZpbGVzIHRocm91Z2hvdXQgdGhlIHNvdXJjZSB0cmVlLAo+
Pj4gdGhlIGluZGVudGF0aW9uIGlzIHNvbWV3aGF0IGRpZmZlcmVudC7CoCBMaW5lcyB1bmRlciBh
IGBgY29uZmlnYGAgCj4+PiBkZWZpbml0aW9uCj4+PiBhcmUgaW5kZW50ZWQgd2l0aCBvbmUgdGFi
LCB3aGlsZSBoZWxwIHRleHQgaXMgaW5kZW50ZWQgYW4gYWRkaXRpb25hbCAKPj4+IHR3bwo+Pj4g
c3BhY2VzLgo+Pj4KPj4gT29mLiBUaGF0J3MgZW1iYXJyYXNzaW5nLiBTb3JyeSwgSSdsbCBmaXgg
dGhpcyBmb3IgdjguCj4+Cj4+IFdoaWxlIEknbSBhdCBpdCwgaXMgdGhlIGhlbHAgdGV4dCByZXF1
aXJlZCBmb3IgY2hvaWNlIGNvbmZpZ3M/Cj4+IGNoZWNrcGF0Y2ggLS1zdHJpY3QgY29tcGxhaW5z
IHdpdGggYSB3YXJuaW5nIHdpdGhvdXQgdGhlbSwgYnV0Cj4+IEkgc2VlIG90aGVyIHBsYWNlcyBp
biB0aGUgdHJlZSB3aGVyZSBoZWxwIHRleHQgaXMgb21pdHRlZCBmb3IKPj4gdGhlc2UgY29uZmln
cyBhdHRhY2hlZCB0byBhIGNob2ljZS4KPgo+IERvZXMgY2hlY2twYXRjaCBjb21wbGFpbiBhYm91
dCB3aGF0IHlvdSBoYXZlIGFib3ZlCj4gb3IgZGlkIHlvdSBhZGQgdGhhdCBoZWxwIHRleHQgdG8g
a2VlcCBpdCBmcm9tIGNvbXBsYWluaW5nPwoKSSBhZGRlZCB0aGUgaGVscCB0ZXh0IHRvIGtlZXAg
aXQgZnJvbSBjb21wbGFpbmluZyAoYW5kIGFkZGVkIGl0IGluY29ycmVjdGx5LApjbGVhcmx5KS4K
Cj4KPgo+PiBEb2N1bWVudGF0aW9uL3Byb2Nlc3MvKiBkb2Vzbid0IHNlZW0gdG8gaGF2ZSBhbnkg
Z3VpZGFuY2UsIG5vcgo+PiBEb2N1bWVudGF0aW9uL2tidWlsZC8qIG9uIHdoZXRoZXIgaXQgaXMg
c2FmZSB0byBpZ25vcmUgdGhhdAo+PiBjaGVja3BhdGNoIHdhcm5pbmcuCj4KPiBZZWFoLCBJIGRv
bid0IHRoaW5rIHRoYXQgd2UgaGF2ZSBhbnkgZ29vZCBndWlkYW5jZSBvbiB0aGF0Lgo+Cj4gSSB3
b3VsZCBzYXkgdGhhdCBpZiB0aGUgY2hvaWNlIHByb21wdCBwcm92aWRlcyBnb29kL2FkZXF1YXRl
Cj4gaGVscCBpbmZvLCB0aGVuIGVhY2ggJ2NvbmZpZycgaW5zaWRlIHRoZSBjaG9pY2UgYmxvY2sg
ZG9lcyBub3QKPiBuZWVkIGhlbHAgdGV4dC4gT1RPSCwgaWYgdGhlIGNob2ljZSBwcm9tcHQgaGFz
IGxpdHRsZS9ubyBoZWxwCj4gaW5mbywgdGhlbiBlYWNoICdjb25maWcnIHVuZGVyIGl0IHNob3Vs
ZCBoYXZlIHNvbWUgdXNlZnVsIGluZm8uCj4KPiBJIG9ubHkgbG9va2VkIGluIGFyY2gveDg2L0tj
b25maWcsIGluaXQvS2NvbmZpZywgYW5kIGxpYi9LY29uZmlnLmRlYnVnLAo+IGJ1dCB5b3UgY2Fu
IHNlZSBlaXRoZXIgaGVscCB0ZXh0IG1ldGhvZCBiZWluZyB1c2VkIGluIHRob3NlLgo+Cj4gQW5k
IHRoZW4gaWYgdGhlIGhlbHAgdGV4dCBpcyBhZGVxdWF0ZSBpbiBlaXRoZXIgb25lIG9mIHRob3Nl
Cj4gbWV0aG9kcywgSSB3b3VsZCBqdXN0IGlnbm9yZSB0aGUgY2hlY2twYXRjaCBjb21wbGFpbnRz
Lgo+IEl0J3MganVzdCBhIGd1aWRhbmNlIHRvb2wuCgpBbHJpZ2h0LiBJIHRoaW5rIHRoZSBjaG9p
Y2UgZ3VpZGFuY2UgaXMgcHJldHR5IGNsZWFyOgoKICAgIFNwZWNpZnkgdGhlIGhhc2ggYWxnb3Jp
dGhtIHVzZWQgd2hlbiBhdWRpdGluZyBwb2xpY2llcy4KICAgIFRoZSBoYXNoIGlzIHVzZWQgdG8g
dW5pcXVlbHkgaWRlbnRpZnkgYSBwb2xpY3kgZnJvbSBvdGhlcgogICAgcG9saWNpZXMgb24gdGhl
IHN5c3RlbS4KClNvIEknbGwgcmVtb3ZlIHRoZSBoZWxwIHRleHQgZm9yIHRoZXNlIGNob2ljZXMu
CgpBdCB3b3JzdCwgSSBjYW4gbWFrZSB0aGUgY2hvaWNlIHRleHQgbW9yZSBjbGVhci4KPgo+IEhU
SC4KPgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


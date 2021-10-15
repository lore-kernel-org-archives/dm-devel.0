Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A8FC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 19:26:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7EAEA61181
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 19:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7EAEA61181
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-Mk8ShisUOzGSo9hf5TUbyA-1; Fri, 15 Oct 2021 15:26:03 -0400
X-MC-Unique: Mk8ShisUOzGSo9hf5TUbyA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D3CC804B6C;
	Fri, 15 Oct 2021 19:25:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AE615D9DE;
	Fri, 15 Oct 2021 19:25:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DAF2180598A;
	Fri, 15 Oct 2021 19:25:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FJPqf4025497 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 15:25:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6EFBD40CFD11; Fri, 15 Oct 2021 19:25:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 699A940CFD0D
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 19:25:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50728802A6A
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 19:25:52 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-353-WRB3DNTaPaKAzAZXlH_4cA-1;
	Fri, 15 Oct 2021 15:25:48 -0400
X-MC-Unique: WRB3DNTaPaKAzAZXlH_4cA-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id A840E20B9D2B;
	Fri, 15 Oct 2021 12:25:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A840E20B9D2B
Message-ID: <7bd474ae-3dbe-4351-fa10-ee68e5c7267c@linux.microsoft.com>
Date: Fri, 15 Oct 2021 12:25:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: Randy Dunlap <rdunlap@infradead.org>, corbet@lwn.net, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu, 
	paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
	<9c1eec3b-8bb0-9e3e-d6e5-18c670ac2b03@infradead.org>
From: Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <9c1eec3b-8bb0-9e3e-d6e5-18c670ac2b03@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19FJPqf4025497
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

T24gMTAvMTMvMjAyMSAzOjU0IFBNLCBSYW5keSBEdW5sYXAgd3JvdGU6Cj4gSGksCj4KPiBPbiAx
MC8xMy8yMSAxMjowNiBQTSwgZGV2ZW4uZGVzYWlAbGludXgubWljcm9zb2Z0LmNvbSB3cm90ZToK
Pj4gZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2lwZS9LY29uZmlnIGIvc2VjdXJpdHkvaXBlL0tjb25m
aWcKPj4gaW5kZXggYzQ1MDMwODNlOTJkLi5lZjU1NmI2NmU2NzQgMTAwNjQ0Cj4+IC0tLSBhL3Nl
Y3VyaXR5L2lwZS9LY29uZmlnCj4+ICsrKyBiL3NlY3VyaXR5L2lwZS9LY29uZmlnCj4+IEBAIC0x
NywzICsxNyw1NSBAQCBtZW51Y29uZmlnIFNFQ1VSSVRZX0lQRQo+PiDCoMKgwqDCoMKgwqDCoCBy
ZXF1aXJlbWVudHMgb24gdGhlIGZseS4KPj4gwqAgwqDCoMKgwqDCoMKgwqAgSWYgdW5zdXJlLCBh
bnN3ZXIgTi4KPj4gKwo+PiAraWYgU0VDVVJJVFlfSVBFCj4+ICsKPj4gK2Nob2ljZQo+PiArwqDC
oMKgIHByb21wdCAiSGFzaCBhbGdvcml0aG0gdXNlZCBpbiBhdWRpdGluZyBwb2xpY2llcyIKPj4g
K8KgwqDCoCBkZWZhdWx0IElQRV9BVURJVF9IQVNIX1NIQTEKPj4gK8KgwqDCoCBkZXBlbmRzIG9u
IEFVRElUCj4+ICvCoMKgwqAgaGVscAo+PiArwqDCoMKgwqDCoMKgwqAgU3BlY2lmeSB0aGUgaGFz
aCBhbGdvcml0aG0gdXNlZCB3aGVuIGF1ZGl0aW5nIHBvbGljaWVzLgo+PiArwqDCoMKgwqDCoMKg
wqAgVGhlIGhhc2ggaXMgdXNlZCB0byB1bmlxdWVseSBpZGVudGlmeSBhIHBvbGljeSBmcm9tIG90
aGVyCj4+ICvCoMKgwqDCoMKgwqDCoCBwb2xpY2llcyBvbiB0aGUgc3lzdGVtLgo+PiArCj4+ICvC
oMKgwqDCoMKgwqDCoCBJZiB1bnN1cmUsIGxlYXZlIGRlZmF1bHQuCj4+ICsKPj4gK8KgwqDCoCBj
b25maWcgSVBFX0FVRElUX0hBU0hfU0hBMQo+PiArwqDCoMKgwqDCoMKgwqAgYm9vbCAic2hhMSIK
Pj4gK8KgwqDCoMKgwqDCoMKgIGRlcGVuZHMgb24gQ1JZUFRPX1NIQTEKPj4gK8KgwqDCoMKgwqDC
oMKgIGhlbHAKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVXNlIHRoZSBTSEExMjggYWxnb3Jp
dGhtIHRvIGhhc2ggcG9saWNpZXMKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW4gdGhlIGF1
ZGl0IHJlY29yZHMuCj4+ICsKPj4gK8KgwqDCoCBjb25maWcgSVBFX0FVRElUX0hBU0hfU0hBMjU2
Cj4+ICvCoMKgwqDCoMKgwqDCoCBib29sICJzaGEyNTYiCj4+ICvCoMKgwqDCoMKgwqDCoCBkZXBl
bmRzIG9uIENSWVBUT19TSEEyNTYKPj4gK8KgwqDCoMKgwqDCoMKgIGhlbHAKPj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgVXNlIHRoZSBTSEEyNTYgYWxnb3JpdGhtIHRvIGhhc2ggcG9saWNpZXMK
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW4gdGhlIGF1ZGl0IHJlY29yZHMuCj4+ICsKPj4g
K8KgwqDCoCBjb25maWcgSVBFX0FVRElUX0hBU0hfU0hBMzg0Cj4+ICvCoMKgwqDCoMKgwqDCoCBi
b29sICJzaGEzODQiCj4+ICvCoMKgwqDCoMKgwqDCoCBkZXBlbmRzIG9uIENSWVBUT19TSEE1MTIK
Pj4gK8KgwqDCoMKgwqDCoMKgIGhlbHAKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVXNlIHRo
ZSBTSEEzODQgYWxnb3JpdGhtIHRvIGhhc2ggcG9saWNpZXMKPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgaW4gdGhlIGF1ZGl0IHJlY29yZHMKPj4gKwo+PiArwqDCoMKgIGNvbmZpZyBJUEVfQVVE
SVRfSEFTSF9TSEE1MTIKPj4gK8KgwqDCoMKgwqDCoMKgIGJvb2wgInNoYTUxMiIKPj4gK8KgwqDC
oMKgwqDCoMKgIGRlcGVuZHMgb24gQ1JZUFRPX1NIQTUxMgo+PiArwqDCoMKgwqDCoMKgwqAgaGVs
cAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBVc2UgdGhlIFNIQTUxMiBhbGdvcml0aG0gdG8g
aGFzaCBwb2xpY2llcwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbiB0aGUgYXVkaXQgcmVj
b3Jkcwo+PiArZW5kY2hvaWNlCj4+ICsKPj4gK2NvbmZpZyBJUEVfQVVESVRfSEFTSF9BTEcKPj4g
K8KgwqDCoCBzdHJpbmcKPj4gK8KgwqDCoCBkZXBlbmRzIG9uIEFVRElUCj4+ICvCoMKgwqAgZGVm
YXVsdCAic2hhMSIgaWYgSVBFX0FVRElUX0hBU0hfU0hBMQo+PiArwqDCoMKgIGRlZmF1bHQgInNo
YTI1NiIgaWYgSVBFX0FVRElUX0hBU0hfU0hBMjU2Cj4+ICvCoMKgwqAgZGVmYXVsdCAic2hhMzg0
IiBpZiBJUEVfQVVESVRfSEFTSF9TSEEzODQKPj4gK8KgwqDCoCBkZWZhdWx0ICJzaGE1MTIiIGlm
IElQRV9BVURJVF9IQVNIX1NIQTUxMgo+PiArCj4+ICtlbmRpZgo+Cj4gUGxlYXNlIGZvbGxvdyBj
b2Rpbmctc3R5bGUgZm9yIEtjb25maWcgZmlsZXM6Cj4KPiAoZnJvbSBEb2N1bWVudGF0aW9uL3By
b2Nlc3MvY29kaW5nLXN0eWxlLnJzdCwgc2VjdGlvbiAxMCk6Cj4KPiBGb3IgYWxsIG9mIHRoZSBL
Y29uZmlnKiBjb25maWd1cmF0aW9uIGZpbGVzIHRocm91Z2hvdXQgdGhlIHNvdXJjZSB0cmVlLAo+
IHRoZSBpbmRlbnRhdGlvbiBpcyBzb21ld2hhdCBkaWZmZXJlbnQuwqAgTGluZXMgdW5kZXIgYSBg
YGNvbmZpZ2BgIAo+IGRlZmluaXRpb24KPiBhcmUgaW5kZW50ZWQgd2l0aCBvbmUgdGFiLCB3aGls
ZSBoZWxwIHRleHQgaXMgaW5kZW50ZWQgYW4gYWRkaXRpb25hbCB0d28KPiBzcGFjZXMuCj4KT29m
LiBUaGF0J3MgZW1iYXJyYXNzaW5nLiBTb3JyeSwgSSdsbCBmaXggdGhpcyBmb3IgdjguCgpXaGls
ZSBJJ20gYXQgaXQsIGlzIHRoZSBoZWxwIHRleHQgcmVxdWlyZWQgZm9yIGNob2ljZSBjb25maWdz
PwpjaGVja3BhdGNoIC0tc3RyaWN0IGNvbXBsYWlucyB3aXRoIGEgd2FybmluZyB3aXRob3V0IHRo
ZW0sIGJ1dApJIHNlZSBvdGhlciBwbGFjZXMgaW4gdGhlIHRyZWUgd2hlcmUgaGVscCB0ZXh0IGlz
IG9taXR0ZWQgZm9yCnRoZXNlIGNvbmZpZ3MgYXR0YWNoZWQgdG8gYSBjaG9pY2UuCgpEb2N1bWVu
dGF0aW9uL3Byb2Nlc3MvKiBkb2Vzbid0IHNlZW0gdG8gaGF2ZSBhbnkgZ3VpZGFuY2UsIG5vcgpE
b2N1bWVudGF0aW9uL2tidWlsZC8qIG9uIHdoZXRoZXIgaXQgaXMgc2FmZSB0byBpZ25vcmUgdGhh
dApjaGVja3BhdGNoIHdhcm5pbmcuCgoKCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbA==


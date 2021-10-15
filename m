Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38E8C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 20:12:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 335D260E74
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 20:12:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 335D260E74
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-1wWCNFLVOw-UHkVB_8uA5w-1; Fri, 15 Oct 2021 16:12:39 -0400
X-MC-Unique: 1wWCNFLVOw-UHkVB_8uA5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF1D518A0728;
	Fri, 15 Oct 2021 20:12:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88960196E2;
	Fri, 15 Oct 2021 20:12:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA6BD4E58E;
	Fri, 15 Oct 2021 20:12:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FKBVCu030368 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 16:11:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 34C61D7B15; Fri, 15 Oct 2021 20:11:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F5B3D7B1A
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 20:11:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B221800B24
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 20:11:28 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-253-nznMvNcjOKyzgOqKuAnHbA-1;
	Fri, 15 Oct 2021 16:11:24 -0400
X-MC-Unique: nznMvNcjOKyzgOqKuAnHbA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 978ED60F48;
	Fri, 15 Oct 2021 20:11:22 +0000 (UTC)
Date: Fri, 15 Oct 2021 13:11:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Deven Bowers <deven.desai@linux.microsoft.com>
Message-ID: <YWngaVdvMyWBlITZ@gmail.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-security-module@vger.kernel.org, tytso@mit.edu,
	paul@paul-moore.com, snitzer@redhat.com, corbet@lwn.net,
	jannh@google.com, linux-doc@vger.kernel.org, jmorris@namei.org,
	eparis@redhat.com, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-audit@redhat.com, linux-fscrypt@vger.kernel.org,
	agk@redhat.com, serge@hallyn.com
Subject: Re: [dm-devel] [RFC PATCH v7 12/16] fsverity|security: add security
 hooks to fsverity digest and signature
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
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBPY3QgMTUsIDIwMjEgYXQgMTI6MjU6NTNQTSAtMDcwMCwgRGV2ZW4gQm93ZXJzIHdy
b3RlOgo+IAo+IE9uIDEwLzEzLzIwMjEgMTI6MjQgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToKPiA+
IE9uIFdlZCwgT2N0IDEzLCAyMDIxIGF0IDEyOjA2OjMxUE0gLTA3MDAsIGRldmVuLmRlc2FpQGxp
bnV4Lm1pY3Jvc29mdC5jb20gd3JvdGU6Cj4gPiA+IEZyb206IEZhbiBXdSA8d3VmYW5AbGludXgu
bWljcm9zb2Z0LmNvbT4KPiA+ID4gCj4gPiA+IEFkZCBzZWN1cml0eV9pbm9kZV9zZXRzZWN1cml0
eSB0byBmc3Zlcml0eSBzaWduYXR1cmUgdmVyaWZpY2F0aW9uLgo+ID4gPiBUaGlzIGNhbiBsZXQg
TFNNcyBzYXZlIHRoZSBzaWduYXR1cmUgZGF0YSBhbmQgZGlnZXN0IGhhc2hlcyBwcm92aWRlZAo+
ID4gPiBieSBmc3Zlcml0eS4KPiA+IENhbiB5b3UgZWxhYm9yYXRlIG9uIHdoeSBMU01zIG5lZWQg
dGhpcyBpbmZvcm1hdGlvbj8KPiAKPiBUaGUgcHJvcG9zZWQgTFNNIChJUEUpIG9mIHRoaXMgc2Vy
aWVzIHdpbGwgYmUgdGhlIG9ubHkgb25lIHRvIG5lZWQKPiB0aGlzIGluZm9ybWF0aW9uIGF0IHRo
ZcKgIG1vbWVudC4gSVBF4oCZcyBnb2FsIGlzIHRvIGhhdmUgcHJvdmlkZQo+IHRydXN0LWJhc2Vk
IGFjY2VzcyBjb250cm9sLiBUcnVzdCBhbmQgSW50ZWdyaXR5IGFyZSB0aWVkIHRvZ2V0aGVyLAo+
IGFzIHlvdSBjYW5ub3QgcHJvdmUgdHJ1c3Qgd2l0aG91dCBwcm92aW5nIGludGVncml0eS4KCkkg
dGhpbmsgeW91IG1lYW4gYXV0aGVudGljaXR5LCBub3QgaW50ZWdyaXR5PwoKQWxzbyBob3cgZG9l
cyB0aGlzIGRpZmZlciBmcm9tIElNQT8gIEkga25vdyB0aGF0IElNQSBkb2Vzbid0IHN1cHBvcnQg
ZnMtdmVyaXR5CmZpbGUgaGFzaGVzLCBidXQgdGhhdCBjb3VsZCBiZSBjaGFuZ2VkLiAgV2h5IG5v
dCBleHRlbmQgSU1BIHRvIGNvdmVyIHlvdXIgdXNlCmNhc2Uocyk/Cgo+IElQRSBuZWVkcyB0aGUg
ZGlnZXN0IGluZm9ybWF0aW9uIHRvIGJlIGFibGUgdG8gY29tcGFyZSBhIGRpZ2VzdAo+IHByb3Zp
ZGVkIGJ5IHRoZSBwb2xpY3kgYXV0aG9yLCBhZ2FpbnN0IHRoZSBkaWdlc3QgY2FsY3VsYXRlZCBi
eQo+IGZzdmVyaXR5IHRvIG1ha2UgYSBkZWNpc2lvbiBvbiB3aGV0aGVyIHRoYXQgc3BlY2lmaWMg
ZmlsZSwgcmVwcmVzZW50ZWQKPiBieSB0aGUgZGlnZXN0IGlzIGF1dGhvcml6ZWQgZm9yIHRoZSBh
Y3Rpb25zIHNwZWNpZmllZCBpbiB0aGUgcG9saWN5Lgo+IAo+IEEgbW9yZSBjb25jcmV0ZSBleGFt
cGxlLCBpZiBhbiBJUEUgcG9saWN5IGF1dGhvciB3cml0ZXM6Cj4gCj4gwqDCoMKgIG9wPUVYRUNV
VEUgZnN2ZXJpdHlfZGlnZXN0PTxIZXhEaWdlc3QgPiBhY3Rpb249REVOWQo+IAo+IElQRSB0YWtl
cyB0aGUgZGlnZXN0IHByb3ZpZGVkIGJ5IHRoaXMgc2VjdXJpdHkgaG9vaywgc3RvcmVzIGl0Cj4g
aW4gSVBFJ3Mgc2VjdXJpdHkgYmxvYiBvbiB0aGUgaW5vZGUuIElmIHRoaXMgZmlsZSBpcyBsYXRl
cgo+IGV4ZWN1dGVkLCBJUEUgY29tcGFyZXMgdGhlIGRpZ2VzdCBzdG9yZWQgaW4gdGhlIExTTSBi
bG9iLAo+IHByb3ZpZGVkIGJ5IHRoaXMgaG9vaywgYWdhaW5zdCA8SGV4RGlnZXN0PiBpbiB0aGUg
cG9saWN5LCBpZgo+IGl0IG1hdGNoZXMsIGl0IGRlbmllcyB0aGUgYWNjZXNzLCBwZXJmb3JtaW5n
IGEgcmV2b2NhdGlvbgo+IG9mIHRoYXQgZmlsZS4KCkRvIHlvdSBoYXZlIGEgYmV0dGVyIGV4YW1w
bGU/ICBUaGlzIG9uZSBpcyBwcmV0dHkgdXNlbGVzcyBzaW5jZSBvbmUgY2FuIGdldAphcm91bmQg
aXQganVzdCBieSBleGVjdXRpbmcgYSBmaWxlIHRoYXQgZG9lc24ndCBoYXZlIGZzLXZlcml0eSBl
bmFibGVkLgoKPiBUaGlzIGJyaW5ncyBtZSB0byB5b3VyIG5leHQgY29tbWVudDoKPiAKPiA+IFRo
ZSBkaWdlc3QgaXNuJ3QgbWVhbmluZ2Z1bCB3aXRob3V0IGtub3dpbmcgdGhlIGhhc2ggYWxnb3Jp
dGhtIGl0IHVzZXMuCj4gSXQncyBhdmFpbGFibGUgaGVyZSwgYnV0IHlvdSBhcmVuJ3QgcGFzc2lu
ZyBpdCB0byB0aGlzIGZ1bmN0aW9uLgo+IAo+IFRoZSBkaWdlc3QgaXMgbWVhbmluZ2Z1bCB3aXRo
b3V0IHRoZSBhbGdvcml0aG0gaW4gdGhpcyBjYXNlLgoKTm8sIGl0J3Mgbm90LgoKRGlnZXN0cyBh
cmUgbWVhbmluZ2xlc3Mgd2l0aG91dCBrbm93aW5nIHdoYXQgYWxnb3JpdGhtIHRoZXkgd2VyZSBj
cmVhdGVkIHdpdGguCgpJZiB5b3VyIHNlY3VyaXR5IHBvbGljeSBpcyBzb21ldGhpbmcgbGlrZSAi
VHJ1c3QgdGhlIGZpbGUgd2l0aCBkaWdlc3QgJGZvbyIgYW5kCm11bHRpcGxlIGhhc2ggYWxnb3Jp
dGhtcyBhcmUgcG9zc2libGUsIHRoZW4gdGhlIGFsb3JpdGhtIGludGVuZGVkIHRvIGJlIHVzZWQK
bmVlZHMgdG8gYmUgZXhwbGljaXRseSBzcGVjaWZpZWQuICBPdGhlcndpc2UgYW55IGFsZ29yaXRo
bSB3aXRoIHRoZSBzYW1lIGxlbmd0aApkaWdlc3Qgd2lsbCBiZSBhY2NlcHRlZC4gIFRoYXQncyBh
IGZhdGFsIGZsYXcgaWYgYW55IG9mIHRoZXNlIGFsZ29yaXRobXMgaXMKY3J5cHRvZ3JhcGhpY2Fs
bHkgYnJva2VuIG9yIHdhcyBuZXZlciBpbnRlbmRlZCB0byBiZSBhIGNyeXB0b2dyYXBoaWMgYWxn
b3JpdGhtCmluIHRoZSBmaXJzdCBwbGFjZSAoZS5nLiwgYSBub24tY3J5cHRvZ3JhcGhpYyBjaGVj
a3N1bSkuCgpDcnlwdG9zeXN0ZW1zIGFsd2F5cyBuZWVkIHRvIHNwZWNpZnkgdGhlIGNyeXB0byBh
bGdvcml0aG0ocykgdXNlZDsgdGhlIGFkdmVyc2FyeQptdXN0IG5vdCBiZSBhbGxvd2VkIHRvIGNo
b29zZSB0aGUgYWxnb3JpdGhtcy4KCkknbSBub3Qgc3VyZSBob3cgdGhlc2UgcGF0Y2hlcyBjYW4g
YmUgdGFrZW4gc2VyaW91c2x5IHdoZW4gdGhleSdyZSBnZXR0aW5nIHRoaXMKc29ydCBvZiB0aGlu
ZyB3cm9uZy4KCj4gPiA+ICsJCQkJCUZTX1ZFUklUWV9TSUdOQVRVUkVfU0VDX05BTUUsCj4gPiA+
ICsJCQkJCXNpZ25hdHVyZSwgc2lnX3NpemUsIDApOwo+ID4gVGhpcyBpcyBvbmx5IGZvciBmcy12
ZXJpdHkgYnVpbHQtaW4gc2lnbmF0dXJlcyB3aGljaCBhcmVuJ3QgdGhlIG9ubHkgd2F5IHRvIGRv
Cj4gPiBzaWduYXR1cmVzIHdpdGggZnMtdmVyaXR5LiAgQXJlIHlvdSBzdXJlIHRoaXMgaXMgd2hh
dCB5b3UncmUgbG9va2luZyBmb3I/Cj4gCj4gQ291bGQgeW91IGVsYWJvcmF0ZSBvbiB0aGUgb3Ro
ZXIgc2lnbmF0dXJlIHR5cGVzIHRoYXQgY2FuIGJlIHVzZWQKPiB3aXRoIGZzLXZlcml0eT8gSeKA
mW0gOTklIHN1cmUgdGhpcyBpcyB3aGF0IEnigJltIGxvb2tpbmcgZm9yIGFzIHRoaXMKPiBpcyBh
IHNpZ25hdHVyZSB2YWxpZGF0ZWQgaW4gdGhlIGtlcm5lbCBhZ2FpbnN0IHRoZSBmcy12ZXJpdHkg
a2V5cmluZwo+IGFzIHBhcnQgb2YgdGhlIOKAnGZzdmVyaXR5IGVuYWJsZeKAnSB1dGlsaXR5Lgo+
IAo+IEl0J3MgaW1wb3J0YW50IHRoYXQgdGhlIHNpZ25hdHVyZSBpcyB2YWxpZGF0ZWQgaW4gdGhl
IGtlcm5lbCwgYXMKPiB1c2Vyc3BhY2UgaXMgY29uc2lkZXJlZCB1bnRydXN0ZWQgdW50aWwgdGhl
IHNpZ25hdHVyZSBpcyB2YWxpZGF0ZWQKPiBmb3IgdGhpcyBjYXNlLgo+IAo+ID4gQ2FuIHlvdSBl
bGFib3JhdGUgb24geW91ciB1c2UgY2FzZSBmb3IgZnMtdmVyaXR5IGJ1aWx0LWluIHNpZ25hdHVy
ZXMsCj4gU3VyZSwgc2lnbmF0dXJlcywgbGlrZSBkaWdlc3RzLCBhbHNvIHByb3ZpZGUgYSB3YXkg
dG8gcHJvdmUgaW50ZWdyaXR5LAo+IGFuZCB0aGUgdHJ1c3QgY29tcG9uZW50IGNvbWVzIGZyb20g
dGhlIHZhbGlkYXRpb24gYWdhaW5zdCB0aGUga2V5cmluZywKPiBhcyBvcHBvc2VkIHRvIGEgZml4
ZWQgdmFsdWUgaW4gSVBF4oCZcyBwb2xpY3kuIFRoZSB1c2UgY2FzZSBmb3IgZnMtdmVyaXR5Cj4g
YnVpbHQtaW4gc2lnbmF0dXJlcyBpcyB0aGF0IHdlIGhhdmUgYSBydyBleHQ0IGZpbGVzeXN0ZW0g
dGhhdCBoYXMgc29tZQo+IGV4ZWN1dGFibGUgZmlsZXMsIGFuZCB3ZSB3YW50IHRvIGhhdmUgYSBl
eGVjdXRpb24gcG9saWN5ICh0aHJvdWdoIElQRSkKPiB0aGF0IG9ubHkgX3RydXN0ZWRfIGV4ZWN1
dGFibGVzIGNhbiBydW4uIFBlcmYgaXMgaW1wb3J0YW50IGhlcmUsIGhlbmNlCj4gZnMtdmVyaXR5
LgoKTW9zdCB1c2VycyBvZiBmcy12ZXJpdHkgYnVpbHQtaW4gc2lnbmF0dXJlcyBoYXZlIGFjdHVh
bGx5IGJlZW4gZW5mb3JjaW5nIHRoZWlyCnNlY3VyaXR5IHBvbGljeSBpbiB1c2Vyc3BhY2UsIGJ5
IGNoZWNraW5nIHdoZXRoZXIgc3BlY2lmaWMgZmlsZXMgaGF2ZSB0aGUKZnMtdmVyaXR5IGJpdCBz
ZXQgb3Igbm90LiAgU3VjaCB1c2VycyBjb3VsZCBqdXN0IHN0b3JlIGFuZCB2ZXJpZnkgc2lnbmF0
dXJlcyBpbgp1c2Vyc3BhY2UgaW5zdGVhZCwgd2l0aG91dCBhbnkga2VybmVsIGludm9sdmVtZW50
LiAgU28gdGhhdCdzIHdoYXQgSSd2ZSBiZWVuCnJlY29tbWVuZGluZyAod2l0aCBsaW1pdGVkIHN1
Y2Nlc3MsIHVuZm9ydHVuYXRlbHkpLgoKSWYgeW91IHJlYWxseSBkbyBuZWVkIGluLWtlcm5lbCBz
aWduYXR1cmUgdmVyaWZpY2F0aW9uLCB0aGVuIHRoYXQgbWF5IGJlIGEKbGVnaXRpbWF0ZSB1c2Ug
Y2FzZSBmb3IgdGhlIGZzLXZlcml0eSBidWlsdC1pbiBzaWduYXR1cmVzLCBhbHRob3VnaCBJIGRv
IHdvbmRlcgp3aHkgeW91IGFyZW4ndCB1c2luZyBJTUEgYW5kIGl0cyBzaWduYXR1cmUgbWVjaGFu
aXNtIGluc3RlYWQuCgotIEVyaWMKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEBy
ZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw=


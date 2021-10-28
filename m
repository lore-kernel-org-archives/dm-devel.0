Return-Path: <SRS0=rauK=PQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93DFC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 03:49:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3753360F22
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 03:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3753360F22
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-uVq57bHkOrC03lDWtoZ8nw-1; Wed, 27 Oct 2021 23:49:12 -0400
X-MC-Unique: uVq57bHkOrC03lDWtoZ8nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75F828026AD;
	Thu, 28 Oct 2021 03:49:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B3A795FC13;
	Thu, 28 Oct 2021 03:49:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 004FD1806D03;
	Thu, 28 Oct 2021 03:49:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19S3n1KC006134 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 23:49:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6E5932026D5D; Thu, 28 Oct 2021 03:49:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6946E2026D46
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 03:48:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B3181066558
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 03:48:58 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-540-ynsNGpKdPICIczSoNE2DPw-1;
	Wed, 27 Oct 2021 23:48:54 -0400
X-MC-Unique: ynsNGpKdPICIczSoNE2DPw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F52960F22;
	Thu, 28 Oct 2021 03:48:51 +0000 (UTC)
Date: Wed, 27 Oct 2021 20:48:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Deven Bowers <deven.desai@linux.microsoft.com>
Message-ID: <YXodhzYto5BRxqYO@sol.localdomain>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
	<YWngaVdvMyWBlITZ@gmail.com>
	<f027e3fa-2f70-0cdb-ac7b-255cee68edbb@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <f027e3fa-2f70-0cdb-ac7b-255cee68edbb@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBPY3QgMjYsIDIwMjEgYXQgMTI6MDM6NTNQTSAtMDcwMCwgRGV2ZW4gQm93ZXJzIHdy
b3RlOgo+ID4gPiBUaGUgcHJvcG9zZWQgTFNNIChJUEUpIG9mIHRoaXMgc2VyaWVzIHdpbGwgYmUg
dGhlIG9ubHkgb25lIHRvIG5lZWQKPiA+ID4gdGhpcyBpbmZvcm1hdGlvbiBhdCB0aGXCoCBtb21l
bnQuIElQReKAmXMgZ29hbCBpcyB0byBoYXZlIHByb3ZpZGUKPiA+ID4gdHJ1c3QtYmFzZWQgYWNj
ZXNzIGNvbnRyb2wuIFRydXN0IGFuZCBJbnRlZ3JpdHkgYXJlIHRpZWQgdG9nZXRoZXIsCj4gPiA+
IGFzIHlvdSBjYW5ub3QgcHJvdmUgdHJ1c3Qgd2l0aG91dCBwcm92aW5nIGludGVncml0eS4KPiA+
IEkgdGhpbmsgeW91IG1lYW4gYXV0aGVudGljaXR5LCBub3QgaW50ZWdyaXR5Pwo+IEnigJl2ZSBo
ZWFyZCBhIGxvdCBvZiBwZW9wbGUgdXNlIHRoZXNlIHRlcm1zIGluIG92ZXJsb2FkZWQgd2F5cy4K
PiAKPiBJZiB3ZeKAmXJlIHdvcmtpbmcgd2l0aCB0aGUgZGVmaW5pdGlvbiBvZiBhdXRoZW50aWNp
dHkgYmVpbmcKPiDigJx0aGUgcHJvcGVydHkgdGhhdCBhIHJlc291cmNlIHdhcyBfYWN0dWFsbHlf
IHNlbnQvY3JlYXRlZCBieSBhCj4gcGFydHnigJ0sIGFuZCBpbnRlZ3JpdHkgYmVpbmcg4oCcdGhl
IHByb3BlcnR5IHRoYXQgYSByZXNvdXJjZSB3YXMgbm90Cj4gbW9kaWZpZWQgZnJvbSBhIHBvaW50
IG9mIHRpbWXigJ0sIHRoZW4geWVzLiBUaG91Z2ggdGhlIHN0YXRlbWVudCBpc27igJl0Cj4gZmFs
c2UsIHRob3VnaCwgYmVjYXVzZSB5b3XigJlkIG5lZWQgdG8gcHJvdmUgaW50ZWdyaXR5IGluIHRo
ZSBwcm9jZXNzIG9mCj4gcHJvdmluZyBhdXRoZW50aWNpdHkuCj4gCj4gSWYgbm90LCBjb3VsZCB5
b3UgY2xhcmlmeSB3aGF0IHlvdSBtZWFuIGJ5IGF1dGhlbnRpY2l0eSBhbmQgaW50ZWdyaXR5LAo+
IHNvIHRoYXQgd2UgY2FuIHVzZSBjb25zaXN0ZW50IGRlZmluaXRpb25zPwoKSW4gY3J5cHRvZ3Jh
cGh5LCBpbnRlZ3JpdHkgbm9ybWFsbHkgbWVhbnMga25vd2luZyB3aGV0aGVyIGRhdGEgaGFzIGJl
ZW4Kbm9uLW1hbGljaW91c2x5IGNoYW5nZWQsIHdoaWxlIGF1dGhlbnRpY2l0eSBtZWFucyBrbm93
aW5nIHdoZXRoZXIgZGF0YSBpcyBmcm9tIGEKcGFydGljdWxhciBzb3VyY2UsIHdoaWNoIGltcGxp
ZXMga25vd2luZyB3aGV0aGVyIGl0IGhhcyBiZWVuIGNoYW5nZWQgYXQgYWxsCih3aGV0aGVyIG1h
bGljaW91c2x5IG9yIG5vdCkuICBDb25zaWRlciB0aGF0IHRoZXJlIGFyZSAiTWVzc2FnZSBBdXRo
ZW50aWNhdGlvbgpDb2RlcyIgKE1BQ3MpIGFuZCAiQXV0aGVudGljYXRlZCBFbmNyeXB0aW9uIiwg
bm90ICJNZXNzYWdlIEludGVncml0eSBDb2RlcyIgYW5kCiJJbnRhY3QgRW5jcnlwdGlvbiIuCgpV
bmZvcnR1bmF0ZWx5IGxvdHMgb2YgcGVvcGxlIGRvIG92ZXJsb2FkICJpbnRlZ3JpdHkiIHRvIG1l
YW4gYXV0aGVudGljaXR5LCBzbwp5b3UncmUgbm90IGFsb25lLiAgQnV0IGl0J3MgY29uZnVzaW5n
LCBzbyBpZiB5b3UncmUgZ29pbmcgdG8gZG8gdGhhdCB0aGVuIHBsZWFzZQptYWtlIHN1cmUgdG8g
Y2xlYXJseSBleHBsYWluIHdoYXQgeW91IG1lYW4uCgo+ID4gQWxzbyBob3cgZG9lcyB0aGlzIGRp
ZmZlciBmcm9tIElNQT8gIEkga25vdyB0aGF0IElNQSBkb2Vzbid0IHN1cHBvcnQgZnMtdmVyaXR5
Cj4gPiBmaWxlIGhhc2hlcywgYnV0IHRoYXQgY291bGQgYmUgY2hhbmdlZC4gIFdoeSBub3QgZXh0
ZW5kIElNQSB0byBjb3ZlciB5b3VyIHVzZQo+ID4gY2FzZShzKT8KPiBXZSBsb29rZWQgYXQgZXh0
ZW5kaW5nIElNQSB0byBjb3ZlciBvdXIgcmVxdWlyZW1lbnRzIGV4dGVuc2l2ZWx5IHRoZSBwYXN0
Cj4geWVhcgo+IGJhc2VkIG9uIGZlZWRiYWNrIHRoZSBsYXN0IHRpbWUgSSBwb3N0ZWQgdGhlc2Ug
cGF0Y2hlcy4gV2UgaW1wbGVtZW50ZWQgYQo+IHByb3RvdHlwZSB0aGF0IGhhZCBoYWxmIG9mIG91
ciByZXF1aXJlbWVudHMsIGJ1dCBmb3VuZCBpdCByZXN1bHRlZCBpbiBhCj4gbGFyZ2UgY2hhbmdl
IGxpc3QgdGhhdCB3b3VsZCByZXN1bHQgaW4gYSBsYXJnZSBhbW91bnQgb2YgcGFpbiBpbiByZXNw
ZWN0Cj4gdG8gbWFpbnRlbmFuY2UsIGluIGFkZGl0aW9uIHRvIG90aGVyIG1vcmUgYXJjaGl0ZWN0
dXJhbCBjb25jZXJucyBhYm91dCB0aGUKPiBpbXBsZW1lbnRhdGlvbi4gV2Ugd2VyZW7igJl0IGNv
bnZpbmNlZCBpdCB3YXMgdGhlIGNvcnJlY3QgZGlyZWN0aW9uLCBmb3Igb3VyCj4gbmVlZHMuCj4g
Cj4gVGhlcmUgd2FzIGEgcHJlc2VudGF0aW9uIGRvbmUgYXQgTFNTIDIwMjEgYXJvdW5kIHRoaXMg
cHJvdG90eXBlIGRvbmUgYnkgbXkKPiBjb2xsZWFndWUsIEZhbiwgd2hvIGF1dGhvcmVkIHRoaXMg
cGF0Y2ggYW5kIGltcGxlbWVudGVkIHRoZSBhZm9yZW1lbnRpb25lZAo+IHByb3RvdHlwZS4KPiAK
PiBJbiBnZW5lcmFsLCBJTUEgcHJvdmlkZXMgYSB3aG9sZSBzdWl0ZSBvZiBhbWF6aW5nIGZ1bmN0
aW9uYWxpdHkgd2hlbiBpdAo+IGNvbWVzIHRvIGV2ZXJ5dGhpbmcgaW50ZWdyaXR5LCBhcyB0aGUg
ZnMtdmVyaXR5IGRvY3VtZW50YXRpb24gc3RhdGVzCj4gaXRzZWxmOgo+IAo+ICAgIElNQSBzcGVj
aWZpZXMgYSBzeXN0ZW0td2lkZSBwb2xpY3kgdGhhdCBzcGVjaWZpZXMgd2hpY2gKPiAgICBmaWxl
cyBhcmUgaGFzaGVkIGFuZCB3aGF0IHRvIGRvIHdpdGggdGhvc2UgaGFzaGVzLCBzdWNoCj4gICAg
YXMgbG9nIHRoZW0sIGF1dGhlbnRpY2F0ZSB0aGVtLCBvciBhZGQgdGhlbSB0byBhCj4gICAgbWVh
c3VyZW1lbnQgbGlzdC4KPiAKPiBJbnN0ZWFkLCBJUEUgcHJvdmlkZXMgYSBmaW5lLXR1bmVkIHdh
eSB0byBfb25seV8gZW5mb3JjZSBhbiBhY2Nlc3MgY29udHJvbAo+IHBvbGljeSB0byB0aGVzZSBm
aWxlcyBiYXNlZCBvbiB0aGUgZGVmaW5lZCB0cnVzdCByZXF1aXJlbWVudHMgaW4gdGhlIHBvbGlj
eSwKPiB1bmRlciB2YXJpb3VzIGNvbnRleHRzLCAoeW91IG1pZ2h0IGhhdmUgZGlmZmVyZW50IHJl
cXVpcmVtZW50cyBmb3Igd2hhdAo+IGV4ZWN1dGVzIGluIGEgZ2VuZXJhbCBwdXJwb3NlLCB2ZXJz
dXMgbG9hZGFibGUga2VybmVsIG1vZHVsZXMsIGZvciBleGFtcGxlKS4KPiBJdCB3aWxsIG5ldmVy
IHByb3ZpZGUgYm90aGVyIHRvIGxvZywgbWVhc3VyZSwgb3IgcmV2YWxpZGF0ZSB0aGVzZSBoYXNo
ZXMKPiBiZWNhdXNlCj4gdGhhdOKAmXMgbm90IGl0cyBwdXJwb3NlLiBUaGlzIGlzIHdoeSBpdCBi
ZWxvbmdzIGF0IHRoZSBMU00gbGF5ZXIgaW5zdGVhZCBvZgo+IHRoZQo+IGludGVncml0eSBzdWJz
eXN0ZW0gbGF5ZXIsIGFzIGl0IGlzIHByb3ZpZGluZyBhY2Nlc3MgY29udHJvbCBiYXNlZCBvbiBh
Cj4gcG9saWN5LAo+IHZlcnN1cyBwcm92aWRpbmcgZGVlcCBpbnRlZ3JhdGlvbnMgd2l0aCB0aGUg
YWN0dWFsIGludGVncml0eSBjbGFpbS4KPiAKPiBJUEUgaXMgdHJ5aW5nIHRvIGJlIGFnbm9zdGlj
IHRvIGhvdyBwcmVjaXNlbHkg4oCcdHJ1c3TigJ0gaXMgcHJvdmlkZWQsIGFzCj4gb3Bwb3NlZCB0
byBiZSBkZWVwbHkgaW50ZWdyYXRlZCBpbnRvIHRoZSBtZWNoYW5pc20gdGhhdCBwcm92aWRlcwo+
IOKAnHRydXN04oCdLgoKSU1BIGRvZXNuJ3QgcmVxdWlyZSBsb2dnaW5nIG9yICJtZWFzdXJpbmci
IGhhc2hlcywgdGhvdWdoLiAgVGhvc2UgYXJlIGp1c3Qgc29tZQpvZiBpdHMgc3VwcG9ydGVkIGZl
YXR1cmVzLiAgQW5kIEkgdGhvdWdodCB0aGUgSU1BIGRldmVsb3BlcnMgd2VyZSBwbGFubmluZyB0
bwphZGQgc3VwcG9ydCBmb3IgZnMtdmVyaXR5IGhhc2hlcywgYW5kIHRoYXQgaXQgd291bGRuJ3Qg
cmVxdWlyZSBhbiBlbnRpcmVseSBuZXcKYXJjaGl0ZWN0dXJlIHRvIGRvIHNvLgoKQW55d2F5LCB3
aGlsZSBpdCBkb2VzIHNvdW5kIHRvIG1lIGxpa2UgeW91J3JlIGR1cGxpY2F0aW5nIElNQSwgSSBk
b24ndCByZWFsbHkKaGF2ZSBhIGhvcnNlIGluIHRoaXMgcmFjZSwgYW5kIEkgZGVmZXIgdG8gdGhl
IElNQSBkZXZlbG9wZXJzIG9uIHRoaXMuICBJIHRydXN0CnRoYXQgeW91J3ZlIGJlZW4gZW5nYWdp
bmcgd2l0aCB0aGVtPyAgVGhpcyBwYXRjaHNldCBpc24ndCBldmVuIENjJ2VkIHRvCmxpbnV4LWlu
dGVncml0eSwgc28gaXQncyB1bmNsZWFyIHRoYXQncyBiZWVuIGhhcHBlbmluZy4KCi0gRXJpYwoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


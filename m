Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2978CC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 16:59:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B90A561220
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 16:59:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B90A561220
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-NxUTuuYnPaawlvgxqC9F3A-1; Thu, 04 Nov 2021 12:59:45 -0400
X-MC-Unique: NxUTuuYnPaawlvgxqC9F3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA7F9101F01F;
	Thu,  4 Nov 2021 16:59:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5273970886;
	Thu,  4 Nov 2021 16:59:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DD4664E58E;
	Thu,  4 Nov 2021 16:59:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4GxH9i000841 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 12:59:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 24E3B112131F; Thu,  4 Nov 2021 16:59:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 014BD112131B
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 16:59:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A1A618A01A9
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 16:59:10 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-310-ZTfQNutQOdCl-23e3QfPuw-1;
	Thu, 04 Nov 2021 12:59:06 -0400
X-MC-Unique: ZTfQNutQOdCl-23e3QfPuw-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id D817320ABA92;
	Thu,  4 Nov 2021 09:59:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D817320ABA92
Message-ID: <bd189273-7640-e135-9ca3-e6f3b909b3a1@linux.microsoft.com>
Date: Thu, 4 Nov 2021 09:59:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: Steve Grubb <sgrubb@redhat.com>, corbet@lwn.net, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu, 
	paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
	serge@hallyn.com, linux-audit@redhat.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<2159283.iZASKD2KPV@x2>
	<8802b1ff-3028-642a-22c5-bc4896450a60@linux.microsoft.com>
	<1898302.usQuhbGJ8B@x2>
In-Reply-To: <1898302.usQuhbGJ8B@x2>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4GxH9i000841
X-loop: dm-devel@redhat.com
Cc: linux-fscrypt@vger.kernel.org, dm-devel@redhat.com, jannh@google.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDExLzIvMjAyMSAxMjo0NCBQTSwgU3RldmUgR3J1YmIgd3JvdGU6Cj4gSGVsbG8sCj4KPiBP
biBGcmlkYXksIE9jdG9iZXIgMTUsIDIwMjEgMzoyNTo0NyBQTSBFRFQgRGV2ZW4gQm93ZXJzIHdy
b3RlOgo+PiBPbiAxMC8xMy8yMDIxIDE6MDIgUE0sIFN0ZXZlIEdydWJiIHdyb3RlOgo+Pj4gT24g
V2VkbmVzZGF5LCBPY3RvYmVyIDEzLCAyMDIxIDM6MDY6MjYgUE0gRURUCj4+PiBkZXZlbi5kZXNh
aUBsaW51eC5taWNyb3NvZnQuY29tPiAKPj4+IHdyb3RlOgo+Pj4+IFVzZXJzIG9mIElQRSByZXF1
aXJlIGEgd2F5IHRvIGlkZW50aWZ5IHdoZW4gYW5kIHdoeSBhbiBvcGVyYXRpb24gZmFpbHMsCj4+
Pj4gYWxsb3dpbmcgdGhlbSB0byBib3RoIHJlc3BvbmQgdG8gdmlvbGF0aW9ucyBvZiBwb2xpY3kg
YW5kIGJlIG5vdGlmaWVkCj4+Pj4gb2YgcG90ZW50aWFsbHkgbWFsaWNpb3VzIGFjdGlvbnMgb24g
dGhlaXIgc3lzdGVucyB3aXRoIHJlc3BlY3QgdG8gSVBFCj4+Pj4gaXRzZWxmLgo+Pj4gV291bGQg
eW91IG1pbmQgc2VuZGluZyBleGFtcGxlcyBvZiBhdWRpdCBldmVudHMgc28gdGhhdCB3ZSBjYW4g
c2VlIHdoYXQKPj4+IHRoZSBlbmQgcmVzdWx0IGlzPyBTb21lIHBlb3BsZSBhZGQgdGhlbSB0byB0
aGUgY29tbWl0IHRleHQuIEJ1dCB3ZSBzdGlsbAo+Pj4gbmVlZCB0byBzZWUgd2hhdCB0aGV5IGxv
b2sgbGlrZS4KPj4gU3VyZSwgc29ycnkuIEnigJlsbCBhZGQgdGhlbSB0byB0aGUgY29tbWl0IGRl
c2NyaXB0aW9uIChhbmQgdGhlIGRvY3VtZW50YXRpb24KPj4gcGF0Y2ggYXQgdGhlIGVuZCkgZm9y
IHY4IOKAkyBJbiB0aGUgaW50ZXJlc3Qgb2YgYXN5bmNocm9ub3VzIGZlZWRiYWNrLCBJ4oCZdmUK
Pj4gY29waWVkIHRoZSByZWxldmFudCBleGFtcGxlczoKPiBUaGFua3MgZm9yIHNlbmRpbmcgdGhl
c2UuIFRoaXMgaGVscHMuCj4KPiAgIAo+PiBBVURJVDE0MjAgSVBFIGN0eF9waWQ9MjI5IGN0eF9v
cD1FWEVDVVRFIGN0eF9ob29rPU1NQVAgY3R4X2VuZm9yY2U9MAo+PiBjdHhfY29tbT0iZ3JlcCIg
Y3R4X3BhdGhuYW1lPSIvdXNyL2xpYi9saWJjLTIuMjMuc28iCj4+IGN0eF9pbm89NTMyIGN0eF9k
ZXY9dmRhIHJ1bGU9IkRFRkFVTFQgb3A9RVhFQ1VURSBhY3Rpb249REVOWSIKPiBRdWVzdGlvbi4u
LndoeSBkbyBhbGwgb2YgdGhlc2UgaGF2ZSBhIGN0eF8gIHByZWZpeD8KCkFoLCB0aGUgY3R4XyB3
YXMgYmVjYXVzZSB0aGVzZSBmaWVsZHMgYXJlIGFsbCBncm91cGVkIGluIGlwZSBpbiBhIApjb250
ZXh0IChjdHgpCnN0cnVjdHVyZS4gQW4gcHJpdmF0ZSB2ZXJzaW9uIChwcmUtdjEpIGhhZCB0aGVz
ZSBncm91cGVkIGxpa2U6CgogwqDCoCBjdHg9eyBwaWQ9MjI5IGNvbW09ImdyZXAiIG9wPUVYRUNV
VEUgLi4uIH0KCkJ1dCBkdXJpbmcgYW4gaW50ZXJuYWwgcmV2aWV3LCBpdCB3YXMgYnJvdWdodCB1
cCB0aGF0IHRoZSBncm91cGluZyBpcyBsaWtlbHkKbm9uLXN0YW5kYXJkIGFuZCB0byBjYXVzZSBt
b3JlIGlzc3VlcyB0aGFuIGl0cyB3b3J0aCBpbnN0ZWFkIG9mIGp1c3QgCnByZWZpeGluZwp0aGUg
ZmllbGQgd2l0aCBjdHhfLiBOb3cgdGhhdCBJIHRoaW5rIGFib3V0IGl0IGEgYml0IG1vcmUsIHRo
ZSBjb250ZXh0IGlzCmltcGxpY2l0LCBzbyB0aGUgcHJlZml4IGFuZCBncm91cGluZyBkb2Vzbid0
IG1ha2Ugc2Vuc2UuCgo+IElzIGl0IHBvc3NpYmxlIHRvIHRyaWdnZXIgYW4gYXVkaXQgY29udGV4
dCBzbyB0aGF0IHRoZSBhdWRpdCBtYWNoaW5lcnkKPiBjb2xsZWN0cyBhbGwgb2YgdGhpcyBzdHVm
ZiBpbiAgaXQncyBvd24gd2F5PyBXaGljaCBtZWFucyB5b3UgY291bGQgZHJvcAo+IGV2ZXJ5dGhp
bmcgZXhlY2VwdCBvcCwgaG9vaywgZW5mb3JjZSwgcnVsZSwgYW5kIGFjdGlvbi4KCkkgY291bGQg
ZG8gc29tZXRoaW5nIGludGVybmFsIGluIElQRSB0aGF0IHdpbGwgY3JlYXRlIHRoZSBjb250ZXh0
IGluIHRoZSAKcmlnaHQKd2F5LiBBcyBmYXIgYXMgaW5zaWRlIHRoZSBhdWRpdCBzdGFjayBpdCBs
b29rcyBsaWtlIHRoZSBjbG9zZXN0IGFuYWxvZ3VlIAp3b3VsZApiZSBjb21tb25fbHNtX2F1ZGl0
IC0gd2hpY2ggZml4ZXMgdGhlIHR5cGUgdG8gYmUgQVZDLiBJIGRvbid0IHRoaW5rIAphZGRpbmcg
YW5vdGhlcgpmb3JtIG9mIEFWQyBpcyBhcHByb3ByaWF0ZT8KCkkgY291bGQgYWxzbyBlaXRoZXIg
ZXh0ZW5kIGNvbW1vbl9sc21fYXVkaXQgdG8gYWNjZXB0IGEgdHlwZSBwYXJhbWV0ZXIsIG9yCm1h
a2UgYSBtb3JlIGdlbmVyYWxpemVkIGZ1bmN0aW9uIGFzIHBhcnQgb2YgdGhlIGF1ZGl0IGZyYW1l
d29yay4gRG8geW91IGhhdmUKYSBwcmVmZXJlbmNlPyBQYXVsLCBkbyB5b3UgaGF2ZSBhIHByZWZl
cmVuY2U/Cgo+IFdlIGFsc28gaGF2ZSBhIGZpZWxkIGRpY3Rpb25hcnkgaGVyZToKPiBodHRwczov
L2dpdGh1Yi5jb20vbGludXgtYXVkaXQvYXVkaXQtZG9jdW1lbnRhdGlvbi9ibG9iL21haW4vc3Bl
Y3MvZmllbGRzLwo+IGZpZWxkLWRpY3Rpb25hcnkuY3N2Cj4KPiB3aGljaCBuYW1lcyB0aGUga25v
d24gZmllbGRzIGFuZCBob3cgdGhleSBzaG91bGQgYmUgZm9ybWF0dGVkLiBJZiB0aGVyZSBpcyBh
Cj4gY29sbGlzaW9uIHdoZXJlIHRoZXkgYXJlIHNvbWV0aGluZyBlbHNlIGFuZCBjYW5ub3QgYmUg
aW4gdGhlIHNhbWUgZm9ybWF0LAo+IHRoZW4gd2UgbWFrZSBhIG5ldyBuYW1lIGFuZCBob3BlZnVs
bHkgdXBkYXRlIHRoZSBkaWN0aW9uYXJ5LiBGb3IgZXhhbXBsZSwgaWYKPiB5b3UgYXJlIGNvbGxl
Y3RpbmcgYSBwcm9jZXNzIGlkLCB1c2UgcGlkIGFuZCBub3QgY3R4X3BpZCBzbyB0aGF0IGl0IG1h
dGNoZXMgYQo+IGtub3duIGRlZmluaXRpb24uCgpXb3cuIEkgZGlkbid0IGtub3cgYWJvdXQgdGhp
cyAtIGl0IHNob3VsZCBiZSBwcmV0dHkgZWFzeSB0byBjaGFuZ2UgdGhlIApmaWVsZHMKdG8gZm9s
bG93IHRoaXMgbWFwcGluZy4gQWxtb3N0IGV2ZXJ5dGhpbmcgaGFzIGEgY29ycmVsYXRpb24gYWxy
ZWFkeS4gSXQgCmxvb2tzCmxpa2UgdGhlcmUgd291bGQgYmUgb25seSBvbmUgY29sbGlzaW9uIHdp
dGggaG9vayBiZWluZyBjdXJyZW50bHkgZGVmaW5lZAp3aXRoIG5ldGZpbHRlci4gRXZlcnl0aGlu
ZyBlbHNlIHdvdWxkIGJlIG5ldyAoZS5nLiBydWxlKSwgb3IgY291bGQgbWFwCmFuIGV4aXN0aW5n
ZmllbGQuCj4gQWxzbywgSSBkb24ndCB0aG5rIHRoZXNlIGV2ZW50cyBjYW4gc3RhbmQgb24gdGhl
aXIgb3duLiBXaG8gZGlkIHRoaXMgYWN0aW9uPwo+IFlvdSBoYXZlIHRoZSBwaWQsIGJ1dCBubyB1
aWQsIGF1aWQsIG9yIHNlc3Npb25faWQuCgpJdCBtYWtlcyBzZW5zZSB0byBhZGQgdGhlc2UgZmll
bGRzOyBhbmQgaXQnZCBiZSB0YWtlbiBjYXJlIG9mIHdpdGggeW91ciAKc3VnZ2VzdGlvbgphYm92
ZSB0byBtYWtlIHRoZSBhdWRpdCBjb250ZXh0IGp1c3QgZ2F0aGVycyB0aGlzIGluZm9ybWF0aW9u
IGluIGl0cyAKb3duLCBjb25zaXN0ZW50CndheS4KCj4gSG9wZSB0aGlzIGhlbHBzLi4uCj4KPiAt
U3RldmUKPgo+ICAgCj4+IEFVRElUMTQyMCBJUEUgY3R4X3BpZD0yMjkgY3R4X29wPUVYRUNVVEUg
Y3R4X2hvb2s9TU1BUCBjdHhfZW5mb3JjZT0wCj4+IGN0eF9jb21tPSJncmVwIiBjdHhfcGF0aG5h
bWU9Ii91c3IvbGliL2xpYmMtMi4yMy5zbyIKPj4gY3R4X2lubz01MzIgY3R4X2Rldj12ZGEgcnVs
ZT0iREVGQVVMVCBhY3Rpb249REVOWSIKPj4KPj4gQVVESVQxNDIwIElQRSBjdHhfcGlkPTI1MyBj
dHhfb3A9RVhFQ1VURSBjdHhfaG9vaz1NTUFQIGN0eF9lbmZvcmNlPTEKPj4gY3R4X2NvbW09ImFu
b24iIHJ1bGU9IkRFRkFVTFQgb3A9RVhFQ1VURSBhY3Rpb249REVOWSIKPj4KPj4gVGhlc2UgdGhy
ZWUgYXVkaXQgcmVjb3JkcyByZXByZXNlbnQgdmFyaW91cyB0eXBlcyBvZiByZXN1bHRzIGFmdGVy
Cj4+IGV2YWx1YXRpbmcKPj4gdGhlIHRydXN0IG9mIGEgcmVzb3VyY2UuIFRoZSBmaXJzdCB0d28g
ZGlmZmVyIGluIHRoZSBydWxlIHRoYXQgd2FzCj4+IG1hdGNoZWQgaW4KPj4gSVBFJ3MgcG9saWN5
LCB0aGUgZmlyc3QgYmVpbmcgYW4gb3BlcmF0aW9uLXNwZWNpZmljIGRlZmF1bHQsIHRoZSBzZWNv
bmQKPj4gYmVpbmcKPj4gYSBnbG9iYWwgZGVmYXVsdC4gVGhlIHRoaXJkIGlzIGFuIGV4YW1wbGUg
b2Ygd2hhdCBpcyBhdWRpdGVkIHdoZW4gYW5vbnltb3VzCj4+IG1lbW9yeSBpcyBibG9ja2VkIChh
cyB0aGVyZSBpcyBubyB3YXkgdG8gdmVyaWZ5IHRoZSB0cnVzdCBvZiBhbiBhbm9ueW1vdXMKPj4g
cGFnZSkuCj4+Cj4+IFRoZSByZW1haW5pbmcgdGhyZWUgZXZlbnRzLCBBVURJVF9UUlVTVF9QT0xJ
Q1lfTE9BRCAoMTQyMSksCj4+IEFVRElUX1RSVVNUX1BPTElDWV9BQ1RJVkFURSAoMTQyMiksIGFu
ZCBBVURJVF9UUlVTVF9TVEFUVVMgKDE0MjMpIGhhdmUgdGhpcwo+PiBmb3JtOgo+Pgo+PiBBVURJ
VDE0MjEgSVBFIHBvbGljeV9uYW1lPSJteS1wb2xpY3kiIHBvbGljeV92ZXJzaW9uPTAuMC4wCj4+
IDxoYXNoX2FsZ19uYW1lPj08aGFzaD4KPj4gQVVESVQxNDIyIElQRSBwb2xpY3lfbmFtZT0ibXkt
cG9saWN5IiBwb2xpY3lfdmVyc2lvbj0wLjAuMAo+PiA8aGFzaF9hbGdfbmFtZT49PGhhc2g+Cj4+
IEFVRElUMTQyMyBJUEUgZW5mb3JjZT0xCj4+Cj4+IFRoZSAxNDIxIChBVURJVF9UUlVTVF9QT0xJ
Q1lfTE9BRCkgZXZlbnQgcmVwcmVzZW50cyBhIG5ldyBwb2xpY3kgd2FzIGxvYWRlZAo+PiBpbnRv
IHRoZSBrZXJuZWwsIGJ1dCBub3QgaXMgbm90IG1hcmtlZCBhcyB0aGUgcG9saWN5IHRvIGVuZm9y
Y2UuIFRoZQo+Pgo+PiBUaGUgMTQyMiAoQVVESVRfVFJVU1RfUE9MSUNZX0FDVElWQVRFKSBldmVu
dCByZXByZXNlbnRzIGEgcG9saWN5IHRoYXQgd2FzCj4+IGFscmVhZHkgbG9hZGVkIHdhcyBtYWRl
IHRoZSBlbmZvcmNpbmcgcG9saWN5Lgo+Pgo+PiBUaGUgMTQyMyAoQVVESVRfVFJVU1RfU1RBVFVT
KSBldmVudCByZXByZXNlbnRzIGEgc3dpdGNoIGJldHdlZW4KPj4gcGVybWlzc2l2ZSBhbmQKPj4g
ZW5mb3JjZSwgaXQgaXMgYWRkZWQgaW4gMDgvMTYgKHRoZSBmb2xsb3dpbmcgcGF0Y2gpCgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


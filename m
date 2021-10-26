Return-Path: <SRS0=m4z6=PO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8838CC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:04:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A85E60EB9
	for <dm-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:04:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1A85E60EB9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-lpGONXNcMLW4fJfVdwNrcQ-1; Tue, 26 Oct 2021 15:04:13 -0400
X-MC-Unique: lpGONXNcMLW4fJfVdwNrcQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62D5318414AF;
	Tue, 26 Oct 2021 19:04:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4669260BF1;
	Tue, 26 Oct 2021 19:04:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1AC6E18199EE;
	Tue, 26 Oct 2021 19:04:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19QJ3u6Z022701 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Oct 2021 15:03:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9BC3A400F3F4; Tue, 26 Oct 2021 19:03:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97F5640C1242
	for <dm-devel@redhat.com>; Tue, 26 Oct 2021 19:03:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8030B811E7F
	for <dm-devel@redhat.com>; Tue, 26 Oct 2021 19:03:56 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-329-YBRdJdbyOjCTZnCCX8icRA-1;
	Tue, 26 Oct 2021 15:03:52 -0400
X-MC-Unique: YBRdJdbyOjCTZnCCX8icRA-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id 403732034CB5;
	Tue, 26 Oct 2021 12:03:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 403732034CB5
Message-ID: <40f70c77-80eb-2716-be77-9cbcf4770b8a@linux.microsoft.com>
Date: Tue, 26 Oct 2021 12:03:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: Roberto Sassu <roberto.sassu@huawei.com>,
	Eric Biggers <ebiggers@kernel.org>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
	<YWngaVdvMyWBlITZ@gmail.com>
	<5c1f800ba554485cb3659da689d2079a@huawei.com>
	<a16a628b9e21433198c490500a987121@huawei.com>
In-Reply-To: <a16a628b9e21433198c490500a987121@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19QJ3u6Z022701
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
	"paul@paul-moore.com" <paul@paul-moore.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "jannh@google.com" <jannh@google.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"jmorris@namei.org" <jmorris@namei.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>, "serge@hallyn.com" <serge@hallyn.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDEwLzIyLzIwMjEgOTozMSBBTSwgUm9iZXJ0byBTYXNzdSB3cm90ZToKPj4gRnJvbTogUm9i
ZXJ0byBTYXNzdSBbbWFpbHRvOnJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbV0KPj4gU2VudDogV2Vk
bmVzZGF5LCBPY3RvYmVyIDIwLCAyMDIxIDU6MDkgUE0KPj4+IEZyb206IEVyaWMgQmlnZ2VycyBb
bWFpbHRvOmViaWdnZXJzQGtlcm5lbC5vcmddCj4+PiBTZW50OiBGcmlkYXksIE9jdG9iZXIgMTUs
IDIwMjEgMTA6MTEgUE0KPj4+IE9uIEZyaSwgT2N0IDE1LCAyMDIxIGF0IDEyOjI1OjUzUE0gLTA3
MDAsIERldmVuIEJvd2VycyB3cm90ZToKPj4+PiBPbiAxMC8xMy8yMDIxIDEyOjI0IFBNLCBFcmlj
IEJpZ2dlcnMgd3JvdGU6Cj4+Pj4+IE9uIFdlZCwgT2N0IDEzLCAyMDIxIGF0IDEyOjA2OjMxUE0g
LTA3MDAsCj4+PiBkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29tICB3cm90ZToKPj4+Pj4+
IEZyb206IEZhbiBXdTx3dWZhbkBsaW51eC5taWNyb3NvZnQuY29tPgo+Pj4+Pj4KPj4+Pj4+IEFk
ZCBzZWN1cml0eV9pbm9kZV9zZXRzZWN1cml0eSB0byBmc3Zlcml0eSBzaWduYXR1cmUgdmVyaWZp
Y2F0aW9uLgo+Pj4+Pj4gVGhpcyBjYW4gbGV0IExTTXMgc2F2ZSB0aGUgc2lnbmF0dXJlIGRhdGEg
YW5kIGRpZ2VzdCBoYXNoZXMgcHJvdmlkZWQKPj4+Pj4+IGJ5IGZzdmVyaXR5Lgo+Pj4+PiBDYW4g
eW91IGVsYWJvcmF0ZSBvbiB3aHkgTFNNcyBuZWVkIHRoaXMgaW5mb3JtYXRpb24/Cj4+Pj4gVGhl
IHByb3Bvc2VkIExTTSAoSVBFKSBvZiB0aGlzIHNlcmllcyB3aWxsIGJlIHRoZSBvbmx5IG9uZSB0
byBuZWVkCj4+Pj4gdGhpcyBpbmZvcm1hdGlvbiBhdCB0aGXCoCBtb21lbnQuIElQReKAmXMgZ29h
bCBpcyB0byBoYXZlIHByb3ZpZGUKPj4+PiB0cnVzdC1iYXNlZCBhY2Nlc3MgY29udHJvbC4gVHJ1
c3QgYW5kIEludGVncml0eSBhcmUgdGllZCB0b2dldGhlciwKPj4+PiBhcyB5b3UgY2Fubm90IHBy
b3ZlIHRydXN0IHdpdGhvdXQgcHJvdmluZyBpbnRlZ3JpdHkuCj4+PiBJIHRoaW5rIHlvdSBtZWFu
IGF1dGhlbnRpY2l0eSwgbm90IGludGVncml0eT8KPj4+Cj4+PiBBbHNvIGhvdyBkb2VzIHRoaXMg
ZGlmZmVyIGZyb20gSU1BPyAgSSBrbm93IHRoYXQgSU1BIGRvZXNuJ3Qgc3VwcG9ydCBmcy12ZXJp
dHkKPj4+IGZpbGUgaGFzaGVzLCBidXQgdGhhdCBjb3VsZCBiZSBjaGFuZ2VkLiAgV2h5IG5vdCBl
eHRlbmQgSU1BIHRvIGNvdmVyIHlvdXIgdXNlCj4+PiBjYXNlKHMpPwo+Pj4KPj4+PiBJUEUgbmVl
ZHMgdGhlIGRpZ2VzdCBpbmZvcm1hdGlvbiB0byBiZSBhYmxlIHRvIGNvbXBhcmUgYSBkaWdlc3QK
Pj4+PiBwcm92aWRlZCBieSB0aGUgcG9saWN5IGF1dGhvciwgYWdhaW5zdCB0aGUgZGlnZXN0IGNh
bGN1bGF0ZWQgYnkKPj4+PiBmc3Zlcml0eSB0byBtYWtlIGEgZGVjaXNpb24gb24gd2hldGhlciB0
aGF0IHNwZWNpZmljIGZpbGUsIHJlcHJlc2VudGVkCj4+Pj4gYnkgdGhlIGRpZ2VzdCBpcyBhdXRo
b3JpemVkIGZvciB0aGUgYWN0aW9ucyBzcGVjaWZpZWQgaW4gdGhlIHBvbGljeS4KPj4+Pgo+Pj4+
IEEgbW9yZSBjb25jcmV0ZSBleGFtcGxlLCBpZiBhbiBJUEUgcG9saWN5IGF1dGhvciB3cml0ZXM6
Cj4+Pj4KPj4+PiAgwqDCoMKgIG9wPUVYRUNVVEUgZnN2ZXJpdHlfZGlnZXN0PTxIZXhEaWdlc3Qg
PiBhY3Rpb249REVOWQo+Pj4+Cj4+Pj4gSVBFIHRha2VzIHRoZSBkaWdlc3QgcHJvdmlkZWQgYnkg
dGhpcyBzZWN1cml0eSBob29rLCBzdG9yZXMgaXQKPj4+PiBpbiBJUEUncyBzZWN1cml0eSBibG9i
IG9uIHRoZSBpbm9kZS4gSWYgdGhpcyBmaWxlIGlzIGxhdGVyCj4+Pj4gZXhlY3V0ZWQsIElQRSBj
b21wYXJlcyB0aGUgZGlnZXN0IHN0b3JlZCBpbiB0aGUgTFNNIGJsb2IsCj4+Pj4gcHJvdmlkZWQg
YnkgdGhpcyBob29rLCBhZ2FpbnN0IDxIZXhEaWdlc3Q+IGluIHRoZSBwb2xpY3ksIGlmCj4+Pj4g
aXQgbWF0Y2hlcywgaXQgZGVuaWVzIHRoZSBhY2Nlc3MsIHBlcmZvcm1pbmcgYSByZXZvY2F0aW9u
Cj4+Pj4gb2YgdGhhdCBmaWxlLgo+Pj4gRG8geW91IGhhdmUgYSBiZXR0ZXIgZXhhbXBsZT8gIFRo
aXMgb25lIGlzIHByZXR0eSB1c2VsZXNzIHNpbmNlIG9uZSBjYW4gZ2V0Cj4+PiBhcm91bmQgaXQg
anVzdCBieSBleGVjdXRpbmcgYSBmaWxlIHRoYXQgZG9lc24ndCBoYXZlIGZzLXZlcml0eSBlbmFi
bGVkLgo+PiBJIHdhcyB3b25kZXJpbmcgaWYgdGhlIGZvbGxvd2luZyB1c2UgY2FzZSBjYW4gYmUg
c3VwcG9ydGVkOgo+PiBhbGxvdyB0aGUgZXhlY3V0aW9uIG9mIGZpbGVzIHByb3RlY3RlZCB3aXRo
IGZzdmVyaXR5IGlmIHRoZSByb290Cj4+IGRpZ2VzdCBpcyBmb3VuZCBhbW9uZyByZWZlcmVuY2Ug
dmFsdWVzIChpbnN0ZWFkIG9mIHByb3ZpZGluZwo+PiB0aGVtIG9uZSBieSBvbmUgaW4gdGhlIHBv
bGljeSkuCj4+Cj4+IFNvbWV0aGluZyBsaWtlOgo+Pgo+PiBvcD1FWEVDVVRFIGZzdmVyaXR5X2Rp
Z2VzdD1kaWdsaW0gYWN0aW9uPUFMTE9XCj4gTG9va3MgbGlrZSBpdCB3b3Jrcy4gSSBtb2RpZmll
ZCBJUEUgdG8gcXVlcnkgdGhlIHJvb3QgZGlnZXN0Cj4gb2YgYW4gZnN2ZXJpdHktcHJvdGVjdGVk
IGZpbGUgaW4gRElHTElNLgo+Cj4gIyBjYXQgaXBlLXBvbGljeQo+IHBvbGljeV9uYW1lPSJBbGxv
d0ZTVmVyaXR5S21vZHVsZXMiIHBvbGljeV92ZXJzaW9uPTAuMC4xCj4gREVGQVVMVCBhY3Rpb249
QUxMT1cKPiBERUZBVUxUIG9wPUtNT0RVTEUgYWN0aW9uPURFTlkKPiBvcD1LTU9EVUxFIGZzdmVy
aXR5X2RpZ2VzdD1kaWdsaW0gYWN0aW9uPUFMTE9XCj4KPiBJUEUgc2V0dXA6Cj4gIyBjYXQgaXBl
LXBvbGljeS5wN3MgPiAvc3lzL2tlcm5lbC9zZWN1cml0eS9pcGUvbmV3X3BvbGljeQo+ICMgZWNo
byAtbiAxID4gIC9zeXMva2VybmVsL3NlY3VyaXR5L2lwZS9wb2xpY2llcy9BbGxvd0ZTVmVyaXR5
S21vZHVsZXMvYWN0aXZlCj4gIyBlY2hvIDEgPiAvc3lzL2tlcm5lbC9zZWN1cml0eS9pcGUvZW5m
b3JjZQo+Cj4gSVBFIGRlbmllcyBsb2FkaW5nIG9mIGtlcm5lbCBtb2R1bGVzIG5vdCBwcm90ZWN0
ZWQgYnkgZnN2ZXJpdHk6Cj4gIyBpbnNtb2QgIC9saWIvbW9kdWxlcy81LjE1LjAtcmMxKy9rZXJu
ZWwvZnMvZmF0L2ZhdC5rbwo+IGluc21vZDogRVJST1I6IGNvdWxkIG5vdCBpbnNlcnQgbW9kdWxl
IC9saWIvbW9kdWxlcy81LjE1LjAtcmMxKy9rZXJuZWwvZnMvZmF0L2ZhdC5rbzogUGVybWlzc2lv
biBkZW5pZWQKPgo+IFByb3RlY3QgZmF0LmtvIHdpdGggZnN2ZXJpdHk6Cj4gIyBjcCAvbGliL21v
ZHVsZXMvNS4xNS4wLXJjMSsva2VybmVsL2ZzL2ZhdC9mYXQua28gL2ZzdmVyaXR5Cj4gIyBmc3Zl
cml0eSBlbmFibGUgL2ZzdmVyaXR5L2ZhdC5rbwo+ICMgZnN2ZXJpdHkgbWVhc3VyZSAvZnN2ZXJp
dHkvZmF0LmtvCj4gc2hhMjU2OjA3OWJlNmQ4ODYzOGU1ODE0MWVlMjRiYmE4OTgxMzkxN2M0NGZh
YTU1YWRhNGJmNWQ4MDMzNWVmZTE1NDc4MDMgL2ZzdmVyaXR5L2ZhdC5rbwo+Cj4gSVBFIHN0aWxs
IGRlbmllcyB0aGUgbG9hZGluZyBvZiBmYXQua28gKHJvb3QgZGlnZXN0IG5vdCB1cGxvYWRlZCB0
byB0aGUga2VybmVsKToKPiAjIGluc21vZCAvZnN2ZXJpdHkvZmF0LmtvCj4gaW5zbW9kOiBFUlJP
UjogY291bGQgbm90IGluc2VydCBtb2R1bGUgL2ZzdmVyaXR5L2ZhdC5rbzogUGVybWlzc2lvbiBk
ZW5pZWQKPgo+IEdlbmVyYXRlIGEgZGlnZXN0IGxpc3Qgd2l0aCB0aGUgcm9vdCBkaWdlc3QgYWJv
dmUgYW5kIHVwbG9hZCBpdCB0byB0aGUga2VybmVsOgo+ICMgLi9jb21wYWN0X2dlbiAtaSAwNzli
ZTZkODg2MzhlNTgxNDFlZTI0YmJhODk4MTM5MTdjNDRmYWE1NWFkYTRiZjVkODAzMzVlZmUxNTQ3
ODAzIC1hIHNoYTI1NiAtZCB0ZXN0IC1zIC10IGZpbGUgLWYKPiAjIGVjaG8gJFBXRC90ZXN0LzAt
ZmlsZV9saXN0LWNvbXBhY3QtMDc5YmU2ZDg4NjM4ZTU4MTQxZWUyNGJiYTg5ODEzOTE3YzQ0ZmFh
NTVhZGE0YmY1ZDgwMzM1ZWZlMTU0NzgwMyA+IC9zeXMva2VybmVsL3NlY3VyaXR5L2ludGVncml0
eS9kaWdsaW0vZGlnZXN0X2xpc3RfYWRkCj4KPiBJUEUgYWxsb3dzIHRoZSBsb2FkaW5nIG9mIGZh
dC5rbzoKPiAjIGluc21vZCAvZnN2ZXJpdHkvZmF0LmtvCj4gIwo+Cj4gUmVnYXJkaW5nIGF1dGhl
bnRpY2l0eSwgbm90IHNob3duIGluIHRoaXMgZGVtbywgSVBFIHdpbGwgYWxzbwo+IGVuc3VyZSB0
aGF0IHRoZSByb290IGRpZ2VzdCBpcyBzaWduZWQgKGRpZ2xpbV9kaWdlc3RfZ2V0X2luZm8oKQo+
IHJlcG9ydHMgdGhpcyBpbmZvcm1hdGlvbikuCgpJIGFwb2xvZ2l6ZSBmb3IgdGhlIGRlbGF5IGlu
IHJlc3BvbnNlcywgYnV0IGl0IGxvb2tzIGxpa2UKeW91J3ZlIGZpZ3VyZWQgaXQgb3V0LgoKVGhp
cyBraW5kIG9mIHRoaW5nIGlzIGV4YWN0bHkgd2hhdCBJUEUncyBkZXNpZ24gaXMgc3VwcG9zZWQg
dG8Kc29sdmUsIHlvdSBoYXZlIHNvbWUgb3RoZXIgc3lzdGVtIHdoaWNoIHByb3ZpZGVzIHRoZQpp
bnRlZ3JpdHkgbWVjaGFuaXNtIGFuZCAob3B0aW9uYWxseSkgZGV0ZXJtaW5lIGlmIGl0IGlzIHRy
dXN0ZWQgb3IKbm90LCBhbmQgSVBFIGNhbiBwcm92aWRlIHRoZSBwb2xpY3kgYXNwZWN0IHZlcnkg
ZWFzaWx5IHRvCm1ha2UgYSBzZXQgb2Ygc3lzdGVtLXdpZGUgcmVxdWlyZW1lbnRzIGFyb3VuZCB5
b3VyIG1lY2hhbmlzbS4KCkknbSB2ZXJ5IHN1cHBvcnRpdmUgb2YgYWRkaW5nIHRoZSBmdW5jdGlv
bmFsaXR5LCBidXQgSSB3b25kZXIKaWYgaXQgbWFrZXMgbW9yZSBzZW5zZSB0byBoYXZlIGRpZ2ls
bSdzIGV4dGVuc2lvbiBiZSBhIHNlcGFyYXRlCmtleSBpbnN0ZWFkIG9mIHRpZWQgdG8gdGhlIGZz
dmVyaXR5X2RpZ2VzdCBrZXkgLSBzb21ldGhpbmcgbGlrZQoKICAgIG9wPUVYRUNVVEUgZGlnbGlt
X2ZzdmVyaXR5PVRSVUUgYWN0aW9uPURFTlkKCnRoYXQgd2F5IHRoZSBjb25kaXRpb24gdGhhdCBl
bmFibGVzIHRoaXMgcHJvcGVydHkgY2FuIGRlcGVuZApvbiBkaWdpbG0gaW4gdGhlIGJ1aWxkLCBh
bmQgaXQgc2VwYXJhdGVzIHRoZSB0d28gc3lzdGVtcycKaW50ZWdyYXRpb25zIGluIGEgc2xpZ2h0
bHkgbW9yZSBjbGVhbiB3YXkuCgpBcyBhbiBhc2lkZSwgZGlkIHlvdSBmaW5kIGl0IGRpZmZpY3Vs
dCB0byBleHRlbmQ/Cgo+IFJvYmVydG8KPgo+IEhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRv
cmYgR21iSCwgSFJCIDU2MDYzCj4gTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFpob25nIFJv
bmdodWEKPgo+PiBESUdMSU0gaXMgYSBjb21wb25lbnQgSSdtIHdvcmtpbmcgb24gdGhhdCBnZW5l
cmljYWxseQo+PiBzdG9yZXMgZGlnZXN0cy4gVGhlIGN1cnJlbnQgdXNlIGNhc2UgaXMgdG8gc3Rv
cmUgZmlsZSBkaWdlc3RzCj4+IGZyb20gUlBNVEFHX0ZJTEVESUdFU1RTIGFuZCB1c2UgdGhlbSB3
aXRoIElNQSwgYnV0Cj4+IHRoZSBmc3Zlcml0eSB1c2UgY2FzZSBjb3VsZCBiZSBlYXNpbHkgc3Vw
cG9ydGVkIChpZiB0aGUgcm9vdAo+PiBkaWdlc3QgaXMgc3RvcmVkIGluIHRoZSBSUE0gaGVhZGVy
KS4KPj4KPj4gRElHTElNIGFsc28gdGVsbHMgd2hldGhlciBvciBub3QgdGhlIHNpZ25hdHVyZSBv
ZiB0aGUgc291cmNlCj4+IGNvbnRhaW5pbmcgZmlsZSBkaWdlc3RzIChvciBmc3Zlcml0eSBkaWdl
c3RzKSBpcyB2YWxpZCAodGhlIHNpZ25hdHVyZQo+PiBvZiB0aGUgUlBNIGhlYWRlciBpcyB0YWtl
biBmcm9tIFJQTVRBR19SU0FIRUFERVIpLgo+Pgo+PiBUaGUgbWVtb3J5IG9jY3VwYXRpb24gaXMg
cmVsYXRpdmVseSBzbWFsbCBmb3IgZXhlY3V0YWJsZXMKPj4gYW5kIHNoYXJlZCBsaWJyYXJpZXMu
IEkgcHVibGlzaGVkIGEgZGVtbyBmb3IgRmVkb3JhIGFuZAo+PiBvcGVuU1VTRSBzb21lIHRpbWUg
YWdvOgo+Pgo+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC0KPj4gaW50ZWdyaXR5LzQ4
Y2Q3MzdjNTA0ZDQ1MjA4Mzc3ZGFhMjdkNjI1NTMxQGh1YXdlaS5jb20vCj4+Cj4+IFRoYW5rcwo+
Pgo+PiBSb2JlcnRvCj4+Cj4+IEhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwg
SFJCIDU2MDYzCj4+IE1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBaaG9uZyBSb25naHVhCgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


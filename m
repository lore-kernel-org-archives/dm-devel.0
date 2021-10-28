Return-Path: <SRS0=rauK=PQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6931AC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 18:11:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D1D28610E5
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 18:11:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D1D28610E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-H1EsOQ3POOSubbSNmptBuw-1; Thu, 28 Oct 2021 14:11:34 -0400
X-MC-Unique: H1EsOQ3POOSubbSNmptBuw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13AFD1006AA2;
	Thu, 28 Oct 2021 18:11:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A54DF5D740;
	Thu, 28 Oct 2021 18:11:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A1E61800B9C;
	Thu, 28 Oct 2021 18:11:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19SIBLlU012856 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Oct 2021 14:11:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 575A640C1242; Thu, 28 Oct 2021 18:11:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53A19401A992
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 18:11:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3449F811E76
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 18:11:21 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-491-eDEd7GQaN-CApglJwEGqhw-1;
	Thu, 28 Oct 2021 14:11:17 -0400
X-MC-Unique: eDEd7GQaN-CApglJwEGqhw-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id A2C8B209F33F;
	Thu, 28 Oct 2021 11:11:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A2C8B209F33F
Message-ID: <9b2695ac-f6db-ac75-5451-4ea9667ce04f@linux.microsoft.com>
Date: Thu, 28 Oct 2021 11:11:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
To: Eric Biggers <ebiggers@kernel.org>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
	<YWngaVdvMyWBlITZ@gmail.com>
	<f027e3fa-2f70-0cdb-ac7b-255cee68edbb@linux.microsoft.com>
	<YXodhzYto5BRxqYO@sol.localdomain>
From: Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <YXodhzYto5BRxqYO@sol.localdomain>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19SIBLlU012856
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDEwLzI3LzIwMjEgODo0OCBQTSwgRXJpYyBCaWdnZXJzIHdyb3RlOgo+IE9uIFR1ZSwgT2N0
IDI2LCAyMDIxIGF0IDEyOjAzOjUzUE0gLTA3MDAsIERldmVuIEJvd2VycyB3cm90ZToKPj4+PiBU
aGUgcHJvcG9zZWQgTFNNIChJUEUpIG9mIHRoaXMgc2VyaWVzIHdpbGwgYmUgdGhlIG9ubHkgb25l
IHRvIG5lZWQKPj4+PiB0aGlzIGluZm9ybWF0aW9uIGF0IHRoZcKgIG1vbWVudC4gSVBF4oCZcyBn
b2FsIGlzIHRvIGhhdmUgcHJvdmlkZQo+Pj4+IHRydXN0LWJhc2VkIGFjY2VzcyBjb250cm9sLiBU
cnVzdCBhbmQgSW50ZWdyaXR5IGFyZSB0aWVkIHRvZ2V0aGVyLAo+Pj4+IGFzIHlvdSBjYW5ub3Qg
cHJvdmUgdHJ1c3Qgd2l0aG91dCBwcm92aW5nIGludGVncml0eS4KPj4+IEkgdGhpbmsgeW91IG1l
YW4gYXV0aGVudGljaXR5LCBub3QgaW50ZWdyaXR5Pwo+PiBJ4oCZdmUgaGVhcmQgYSBsb3Qgb2Yg
cGVvcGxlIHVzZSB0aGVzZSB0ZXJtcyBpbiBvdmVybG9hZGVkIHdheXMuCj4+Cj4+IElmIHdl4oCZ
cmUgd29ya2luZyB3aXRoIHRoZSBkZWZpbml0aW9uIG9mIGF1dGhlbnRpY2l0eSBiZWluZwo+PiDi
gJx0aGUgcHJvcGVydHkgdGhhdCBhIHJlc291cmNlIHdhcyBfYWN0dWFsbHlfIHNlbnQvY3JlYXRl
ZCBieSBhCj4+IHBhcnR54oCdLCBhbmQgaW50ZWdyaXR5IGJlaW5nIOKAnHRoZSBwcm9wZXJ0eSB0
aGF0IGEgcmVzb3VyY2Ugd2FzIG5vdAo+PiBtb2RpZmllZCBmcm9tIGEgcG9pbnQgb2YgdGltZeKA
nSwgdGhlbiB5ZXMuIFRob3VnaCB0aGUgc3RhdGVtZW50IGlzbuKAmXQKPj4gZmFsc2UsIHRob3Vn
aCwgYmVjYXVzZSB5b3XigJlkIG5lZWQgdG8gcHJvdmUgaW50ZWdyaXR5IGluIHRoZSBwcm9jZXNz
IG9mCj4+IHByb3ZpbmcgYXV0aGVudGljaXR5Lgo+Pgo+PiBJZiBub3QsIGNvdWxkIHlvdSBjbGFy
aWZ5IHdoYXQgeW91IG1lYW4gYnkgYXV0aGVudGljaXR5IGFuZCBpbnRlZ3JpdHksCj4+IHNvIHRo
YXQgd2UgY2FuIHVzZSBjb25zaXN0ZW50IGRlZmluaXRpb25zPwo+IEluIGNyeXB0b2dyYXBoeSwg
aW50ZWdyaXR5IG5vcm1hbGx5IG1lYW5zIGtub3dpbmcgd2hldGhlciBkYXRhIGhhcyBiZWVuCj4g
bm9uLW1hbGljaW91c2x5IGNoYW5nZWQsIHdoaWxlIGF1dGhlbnRpY2l0eSBtZWFucyBrbm93aW5n
IHdoZXRoZXIgZGF0YSBpcyBmcm9tIGEKPiBwYXJ0aWN1bGFyIHNvdXJjZSwgd2hpY2ggaW1wbGll
cyBrbm93aW5nIHdoZXRoZXIgaXQgaGFzIGJlZW4gY2hhbmdlZCBhdCBhbGwKPiAod2hldGhlciBt
YWxpY2lvdXNseSBvciBub3QpLiAgQ29uc2lkZXIgdGhhdCB0aGVyZSBhcmUgIk1lc3NhZ2UgQXV0
aGVudGljYXRpb24KPiBDb2RlcyIgKE1BQ3MpIGFuZCAiQXV0aGVudGljYXRlZCBFbmNyeXB0aW9u
Iiwgbm90ICJNZXNzYWdlIEludGVncml0eSBDb2RlcyIgYW5kCj4gIkludGFjdCBFbmNyeXB0aW9u
Ii4KPgo+IFVuZm9ydHVuYXRlbHkgbG90cyBvZiBwZW9wbGUgZG8gb3ZlcmxvYWQgImludGVncml0
eSIgdG8gbWVhbiBhdXRoZW50aWNpdHksIHNvCj4geW91J3JlIG5vdCBhbG9uZS4gIEJ1dCBpdCdz
IGNvbmZ1c2luZywgc28gaWYgeW91J3JlIGdvaW5nIHRvIGRvIHRoYXQgdGhlbiBwbGVhc2UKPiBt
YWtlIHN1cmUgdG8gY2xlYXJseSBleHBsYWluIHdoYXQgeW91IG1lYW4uCj4KPj4+IEFsc28gaG93
IGRvZXMgdGhpcyBkaWZmZXIgZnJvbSBJTUE/ICBJIGtub3cgdGhhdCBJTUEgZG9lc24ndCBzdXBw
b3J0IGZzLXZlcml0eQo+Pj4gZmlsZSBoYXNoZXMsIGJ1dCB0aGF0IGNvdWxkIGJlIGNoYW5nZWQu
ICBXaHkgbm90IGV4dGVuZCBJTUEgdG8gY292ZXIgeW91ciB1c2UKPj4+IGNhc2Uocyk/Cj4+IFdl
IGxvb2tlZCBhdCBleHRlbmRpbmcgSU1BIHRvIGNvdmVyIG91ciByZXF1aXJlbWVudHMgZXh0ZW5z
aXZlbHkgdGhlIHBhc3QKPj4geWVhcgo+PiBiYXNlZCBvbiBmZWVkYmFjayB0aGUgbGFzdCB0aW1l
IEkgcG9zdGVkIHRoZXNlIHBhdGNoZXMuIFdlIGltcGxlbWVudGVkIGEKPj4gcHJvdG90eXBlIHRo
YXQgaGFkIGhhbGYgb2Ygb3VyIHJlcXVpcmVtZW50cywgYnV0IGZvdW5kIGl0IHJlc3VsdGVkIGlu
IGEKPj4gbGFyZ2UgY2hhbmdlIGxpc3QgdGhhdCB3b3VsZCByZXN1bHQgaW4gYSBsYXJnZSBhbW91
bnQgb2YgcGFpbiBpbiByZXNwZWN0Cj4+IHRvIG1haW50ZW5hbmNlLCBpbiBhZGRpdGlvbiB0byBv
dGhlciBtb3JlIGFyY2hpdGVjdHVyYWwgY29uY2VybnMgYWJvdXQgdGhlCj4+IGltcGxlbWVudGF0
aW9uLiBXZSB3ZXJlbuKAmXQgY29udmluY2VkIGl0IHdhcyB0aGUgY29ycmVjdCBkaXJlY3Rpb24s
IGZvciBvdXIKPj4gbmVlZHMuCj4+Cj4+IFRoZXJlIHdhcyBhIHByZXNlbnRhdGlvbiBkb25lIGF0
IExTUyAyMDIxIGFyb3VuZCB0aGlzIHByb3RvdHlwZSBkb25lIGJ5IG15Cj4+IGNvbGxlYWd1ZSwg
RmFuLCB3aG8gYXV0aG9yZWQgdGhpcyBwYXRjaCBhbmQgaW1wbGVtZW50ZWQgdGhlIGFmb3JlbWVu
dGlvbmVkCj4+IHByb3RvdHlwZS4KPj4KPj4gSW4gZ2VuZXJhbCwgSU1BIHByb3ZpZGVzIGEgd2hv
bGUgc3VpdGUgb2YgYW1hemluZyBmdW5jdGlvbmFsaXR5IHdoZW4gaXQKPj4gY29tZXMgdG8gZXZl
cnl0aGluZyBpbnRlZ3JpdHksIGFzIHRoZSBmcy12ZXJpdHkgZG9jdW1lbnRhdGlvbiBzdGF0ZXMK
Pj4gaXRzZWxmOgo+Pgo+PiAgICAgSU1BIHNwZWNpZmllcyBhIHN5c3RlbS13aWRlIHBvbGljeSB0
aGF0IHNwZWNpZmllcyB3aGljaAo+PiAgICAgZmlsZXMgYXJlIGhhc2hlZCBhbmQgd2hhdCB0byBk
byB3aXRoIHRob3NlIGhhc2hlcywgc3VjaAo+PiAgICAgYXMgbG9nIHRoZW0sIGF1dGhlbnRpY2F0
ZSB0aGVtLCBvciBhZGQgdGhlbSB0byBhCj4+ICAgICBtZWFzdXJlbWVudCBsaXN0Lgo+Pgo+PiBJ
bnN0ZWFkLCBJUEUgcHJvdmlkZXMgYSBmaW5lLXR1bmVkIHdheSB0byBfb25seV8gZW5mb3JjZSBh
biBhY2Nlc3MgY29udHJvbAo+PiBwb2xpY3kgdG8gdGhlc2UgZmlsZXMgYmFzZWQgb24gdGhlIGRl
ZmluZWQgdHJ1c3QgcmVxdWlyZW1lbnRzIGluIHRoZSBwb2xpY3ksCj4+IHVuZGVyIHZhcmlvdXMg
Y29udGV4dHMsICh5b3UgbWlnaHQgaGF2ZSBkaWZmZXJlbnQgcmVxdWlyZW1lbnRzIGZvciB3aGF0
Cj4+IGV4ZWN1dGVzIGluIGEgZ2VuZXJhbCBwdXJwb3NlLCB2ZXJzdXMgbG9hZGFibGUga2VybmVs
IG1vZHVsZXMsIGZvciBleGFtcGxlKS4KPj4gSXQgd2lsbCBuZXZlciBwcm92aWRlIGJvdGhlciB0
byBsb2csIG1lYXN1cmUsIG9yIHJldmFsaWRhdGUgdGhlc2UgaGFzaGVzCj4+IGJlY2F1c2UKPj4g
dGhhdOKAmXMgbm90IGl0cyBwdXJwb3NlLiBUaGlzIGlzIHdoeSBpdCBiZWxvbmdzIGF0IHRoZSBM
U00gbGF5ZXIgaW5zdGVhZCBvZgo+PiB0aGUKPj4gaW50ZWdyaXR5IHN1YnN5c3RlbSBsYXllciwg
YXMgaXQgaXMgcHJvdmlkaW5nIGFjY2VzcyBjb250cm9sIGJhc2VkIG9uIGEKPj4gcG9saWN5LAo+
PiB2ZXJzdXMgcHJvdmlkaW5nIGRlZXAgaW50ZWdyYXRpb25zIHdpdGggdGhlIGFjdHVhbCBpbnRl
Z3JpdHkgY2xhaW0uCj4+Cj4+IElQRSBpcyB0cnlpbmcgdG8gYmUgYWdub3N0aWMgdG8gaG93IHBy
ZWNpc2VseSDigJx0cnVzdOKAnSBpcyBwcm92aWRlZCwgYXMKPj4gb3Bwb3NlZCB0byBiZSBkZWVw
bHkgaW50ZWdyYXRlZCBpbnRvIHRoZSBtZWNoYW5pc20gdGhhdCBwcm92aWRlcwo+PiDigJx0cnVz
dOKAnS4KPiBJTUEgZG9lc24ndCByZXF1aXJlIGxvZ2dpbmcgb3IgIm1lYXN1cmluZyIgaGFzaGVz
LCB0aG91Z2guICBUaG9zZSBhcmUganVzdCBzb21lCj4gb2YgaXRzIHN1cHBvcnRlZCBmZWF0dXJl
cy4gIEFuZCBJIHRob3VnaHQgdGhlIElNQSBkZXZlbG9wZXJzIHdlcmUgcGxhbm5pbmcgdG8KPiBh
ZGQgc3VwcG9ydCBmb3IgZnMtdmVyaXR5IGhhc2hlcywgYW5kIHRoYXQgaXQgd291bGRuJ3QgcmVx
dWlyZSBhbiBlbnRpcmVseSBuZXcKPiBhcmNoaXRlY3R1cmUgdG8gZG8gc28uCj4KPiBBbnl3YXks
IHdoaWxlIGl0IGRvZXMgc291bmQgdG8gbWUgbGlrZSB5b3UncmUgZHVwbGljYXRpbmcgSU1BLCBJ
IGRvbid0IHJlYWxseQo+IGhhdmUgYSBob3JzZSBpbiB0aGlzIHJhY2UsIGFuZCBJIGRlZmVyIHRv
IHRoZSBJTUEgZGV2ZWxvcGVycyBvbiB0aGlzLiAgSSB0cnVzdAo+IHRoYXQgeW91J3ZlIGJlZW4g
ZW5nYWdpbmcgd2l0aCB0aGVtPyAgVGhpcyBwYXRjaHNldCBpc24ndCBldmVuIENjJ2VkIHRvCj4g
bGludXgtaW50ZWdyaXR5LCBzbyBpdCdzIHVuY2xlYXIgdGhhdCdzIGJlZW4gaGFwcGVuaW5nLgpU
aGF0IHdhcyBlbnRpcmVseSBteSBtaXN0YWtlLiBNaW1pIGFuZCB0aGUgbGludXgtaW50ZWdyaXR5
IGxpc3Qgd2FzIENDJ2QgCm9uIHByZXZpb3VzCnZlcnNpb25zIChSb2JlcnRvIGFjdHVhbGx5IGFk
ZGVkIHRoZSBsaXN0IHRvIGhpcyByZXNwb25zZXMpIC0gd2hlbiBJIHdhcyAKcmVjb25zdHJ1Y3Rp
bmcKdGhlIFRvOiBsaW5lIHdpdGggZ2V0LW1haW50YWluZXJzLnBsLCB0aGUgbGlzdCBkaWRuJ3Qg
cG9wIHVwIGFuZCBJIGRpZCAKbm90IHJlbWVtYmVyIHRvCmFkZCBpdCBtYW51YWxseS4gSSd2ZSBj
b3JyZWN0ZWQgbXkgbWFpbGluZyBzY3JpcHQgdG8gcmUtYWRkIHRoZW0gYWdhaW4uCgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


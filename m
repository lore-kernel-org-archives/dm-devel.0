Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658A9C636CC
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676551228;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SpkqpkSe5q/lRfNVV9fUNwa0V5FgwS6rNiKe6z2sf80=;
	b=Q6vQIPQQoApZOYV3GFM1eqtMfEwQxZZck46XLMSG9ruGNlOvtiNwXcMas5gvjNnHgDgCLY
	2BYT+CnDX5CRYAVNsrs5ERRfyEaR9eziZCpCUMpEQG5Se3cNgaUxKOm547Pp5DETjvof44
	3CnHBxQFRE7Ogp3kfGHDPmjqIo3BuAA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-eq15if1rOt-mpGpHMPtvYg-1; Thu, 16 Feb 2023 07:40:24 -0500
X-MC-Unique: eq15if1rOt-mpGpHMPtvYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7A703C1014A;
	Thu, 16 Feb 2023 12:40:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F7A040B40C9;
	Thu, 16 Feb 2023 12:40:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66C491946589;
	Thu, 16 Feb 2023 12:40:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6F4FF194658D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 12:40:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7E72140B3FE1; Thu, 16 Feb 2023 12:40:10 +0000 (UTC)
Received: from [10.40.194.185] (ovpn-194-185.brq.redhat.com [10.40.194.185])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D0BD240CF8E4;
 Thu, 16 Feb 2023 12:39:53 +0000 (UTC)
Message-ID: <2bb4b267-b981-9ca4-f091-eb2d362711f5@redhat.com>
Date: Thu, 16 Feb 2023 13:39:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.2
To: Pingfan Liu <piliu@redhat.com>, Ming Lei <ming.lei@redhat.com>
References: <CAF+s44TZw40c_hNDi78VkMq6Xhp23h5j_cadHWirOnYW-wR=NQ@mail.gmail.com>
 <Y+10AxZ8tcd6SemJ@T590>
 <CAF+s44Qqvvhywg4_8Sx3QZ0=_+jz3kPzvmr539uS8Y6LEGY2sg@mail.gmail.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <CAF+s44Qqvvhywg4_8Sx3QZ0=_+jz3kPzvmr539uS8Y6LEGY2sg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] A hang bug of dm on s390x
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
Cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Ming Lei <minlei@redhat.com>, Tao Liu <ltao@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDE2LiAwMi4gMjMgdiA5OjMwIFBpbmdmYW4gTGl1IG5hcHNhbChhKToKPiBIaSBNaW5nLAo+
Cj4gVGhhbmsgeW91IGZvciBsb29raW5nIGludG8gdGhpcy4KPgo+IGxldCBtZSBsb29wIGluIEFs
YXNkYWlyLCBNaWtlIGFuZCBaZGVuZWsgZm9yIGZ1cnRoZXIgY29tbWVudCBvbiBMVk0gc3R1ZmYK
Pgo+Cj4gVGhhbmtzLAo+Cj4gUGluZ2ZhbgoKCkhpCgoKIEZyb20gbHZtMiBQT1YgLSBjb3VwbGUg
Y2xhcmlmaWNhdGlvbnMgLSB0byBsZXQgdGhpbi1wb29sIGF1dG8tZXh0ZW5kIC0gdXNlciAKaGFz
IHRvIGNvbmZpZ3VyZToKCgp0aGluX3Bvb2xfYXV0b2V4dGVuZF90aHJlc2hvbGQgPSA3MAoKdGhp
bl9wb29sX2F1dG9leHRlbmRfcGVyY2VudCA9IDIwCgoKSWYgdGhlIHRoaW5fcG9vbF9hdXRvZXh0
ZW5kX3RocmVzaG9sZCBpcyBsZWZ0IHdpdGggdGhlIGRlZmF1bHQgdmFsdWUgMTAwLCAKdGhlcmUg
aXMgbm8gZXh0ZW5zaW9uIG1hZGUgdG8gdGhlIHRoaW4tcG9vbC4KCkRlZmF1bHQgYmVoYXZpb3Ig
b2YgdGhpbi1wb29sIGtlcm5lbCB0YXJnZXQgd2hlbiBpdCBydW5zIG91dC1vZi1zcGFjZSBpcyB0
byAKcHV0IGFsbCBpbi1mbGlnaHQgSU8gb3BlcmF0aW9uIG9uLWhvbGQgZm9yIDYwcyAoY29uZmln
dXJhYmxlIGJ5IGtlcm5lbCAKcGFyYW1ldGVyKSB0aGVuIGFsbCBzdWNoIG9wZXJhdGlvbiBzdGFy
dHMgdG8gYmUgZXJyb3JlZCBhbmQgdGhpbi1wb29sIGdvZXMgdG8gCm91dC1vZi1zcGFjZSBlcnJv
ciBzdGF0ZS4KClRvIGltbWVkaWF0ZWx5IGdldCB0aGlzIHN0YXRlIHVzZcKgICctLWVycm9yd2hl
bmZ1bGw9eSfCoCB3aXRoIHRoaW5wb29sIAoobHZjcmVhdGUsIGx2Y29udmVydCwgbHZjaGFuZ2Up
IC0gdGhpcyB3aWxsIGF2b2lkIGFueSBkZWxheSBpZiB1c2VyIGRvZXNuJ3QgCndhbnQgZXhwYW5z
aW9uIG9mIHRoaW4tcG9vbCBhbmQgd2FudHMgdG8gZ2V0IGVycm9yIEFTQVAuCgpCdXQgdGhpcyBh
bGwgbWlnaHQgYmUgdW5yZWxhdGVkIHRvIHRoZSBpc3N1ZSB5b3UgYXJlIGdldHRpbmcgb24geW91
ciBody4KCgpSZWdhcmRzCgpaZGVuZWsKCgo+IE9uIFRodSwgRmViIDE2LCAyMDIzIGF0IDg6MDgg
QU0gTWluZyBMZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+IHdyb3RlOgo+PiBPbiBXZWQsIEZlYiAx
NSwgMjAyMyBhdCAwNzoyMzo0MFBNICswODAwLCBQaW5nZmFuIExpdSB3cm90ZToKPj4+IEhpIGd1
eXMsCj4+Pgo+Pj4gSSBlbmNvdW50ZXJlZCAgYSBoYW5nIGlzc3VlIG9uIGEgczM5MHggc3lzdGVt
LiAgVGhlIHRlc3RlZCBrZXJuZWwgaXMKPj4+IG5vdCBwcmVlbXB0aWJsZSBhbmQgYm9vdGluZyB3
aXRoICJucl9jcHVzPTEiCj4+Pgo+Pj4gVGhlIHRlc3Qgc3RlcHM6Cj4+PiAgICAgICAgdW1vdW50
IC9ob21lCj4+PiAgICAgICAgbHZyZW1vdmUgL2Rldi9yaGVsX3MzOTB4LWt2bS0wMTEvaG9tZQo+
Pj4gICAgICAgICMjIHVuY29tbWVudCAic25hcHNob3RfYXV0b2V4dGVuZF90aHJlc2hvbGQgPSA3
MCIgYW5kCj4+PiAgICAgICAgInNuYXBzaG90X2F1dG9leHRlbmRfcGVyY2VudCA9IDIwIiBpbiAv
ZXRjL2x2bS9sdm0uY29uZgo+Pj4KPj4+ICAgICAgICBzeXN0ZW1jdGwgZW5hYmxlIGx2bTItbW9u
aXRvci5zZXJ2aWNlCj4+PiAgICAgICAgc3lzdGVtY3RsIHN0YXJ0IGx2bTItbW9uaXRvci5zZXJ2
aWNlCj4+Pgo+Pj4gICAgICAgIGx2cmVtb3ZlIC15IHJoZWxfczM5MHgta3ZtLTAxMS90aGlucAo+
Pj4gICAgICAgIGx2Y3JlYXRlIC1MIDEwTSAtVCByaGVsX3MzOTB4LWt2bS0wMTEvdGhpbnAKPj4+
ICAgICAgICBsdmNyZWF0ZSAtViA0MDBNIC1UIHJoZWxfczM5MHgta3ZtLTAxMS90aGlucCAtbiBz
cmMKPj4+ICAgICAgICBta2ZzLmV4dDQgL2Rldi9yaGVsX3MzOTB4LWt2bS0wMTEvc3JjCj4+PiAg
ICAgICAgbW91bnQgL2Rldi9yaGVsX3MzOTB4LWt2bS0wMTEvc3JjIC9tbnQKPj4+ICAgICAgICBm
b3IoKGk9MDtpPDQ7aSsrKSk7IGRvIGRkIGlmPS9kZXYvemVybyBvZj0vbW50L3Rlc3QkaS5pbWcK
Pj4+IGJzPTEwME0gY291bnQ9MTsgZG9uZQo+Pj4KPj4+IEFuZCB0aGUgc3lzdGVtIGhhbmdzIHdp
dGggdGhlIGNvbnNvbGUgbG9nIFsxXQo+Pj4KPj4+IFRoZSByZWxhdGVkIGtlcm5lbCBjb25maWcK
Pj4+Cj4+PiAgICAgIENPTkZJR19QUkVFTVBUX05PTkVfQlVJTEQ9eQo+Pj4gICAgICBDT05GSUdf
UFJFRU1QVF9OT05FPXkKPj4+ICAgICAgQ09ORklHX1BSRUVNUFRfQ09VTlQ9eQo+Pj4gICAgICBD
T05GSUdfU0NIRURfQ09SRT15Cj4+Pgo+Pj4gSXQgdHVybnMgb3V0IHRoYXQgd2hlbiBoYW5naW5n
LCB0aGUga2VybmVsIGlzIHN0dWNrIGluIHRoZSBkZWFkLWxvb3AKPj4+IGluIHRoZSBmdW5jdGlv
biBkbV93cV93b3JrKCkKPj4+ICAgICAgICAgIHdoaWxlICghdGVzdF9iaXQoRE1GX0JMT0NLX0lP
X0ZPUl9TVVNQRU5ELCAmbWQtPmZsYWdzKSkgewo+Pj4gICAgICAgICAgICAgICAgICBzcGluX2xv
Y2tfaXJxKCZtZC0+ZGVmZXJyZWRfbG9jayk7Cj4+PiAgICAgICAgICAgICAgICAgIGJpbyA9IGJp
b19saXN0X3BvcCgmbWQtPmRlZmVycmVkKTsKPj4+ICAgICAgICAgICAgICAgICAgc3Bpbl91bmxv
Y2tfaXJxKCZtZC0+ZGVmZXJyZWRfbG9jayk7Cj4+Pgo+Pj4gICAgICAgICAgICAgICAgICBpZiAo
IWJpbykKPj4+ICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsKPj4+ICAgICAgICAgICAg
ICAgICAgdGhyZWFkX2NwdSA9IHNtcF9wcm9jZXNzb3JfaWQoKTsKPj4+ICAgICAgICAgICAgICAg
ICAgc3VibWl0X2Jpb19ub2FjY3QoYmlvKTsKPj4+ICAgICAgICAgIH0KPj4+IHdoZXJlIGRtX3dx
X3dvcmsoKS0+X19zdWJtaXRfYmlvX25vYWNjdCgpLT4uLi4tPmRtX2hhbmRsZV9yZXF1ZXVlKCkK
Pj4+IGtlZXBzIGdlbmVyYXRpbmcgbmV3IGJpbywgYW5kIHRoZSBjb25kaXRpb24gImlmICghYmlv
KSIgY2FuIG5vdCBiZQo+Pj4gbWVldC4KPj4+Cj4+Pgo+Pj4gQWZ0ZXIgYXBwbHlpbmcgdGhlIGZv
bGxvd2luZyBwYXRjaCwgdGhlIGlzc3VlIGlzIGdvbmUuCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbWQvZG0uYyBiL2RyaXZlcnMvbWQvZG0uYwo+Pj4gaW5kZXggZTFlYTNhN2JkOWQ5Li45
NWM5Y2IwN2E0MmYgMTAwNjQ0Cj4+PiAtLS0gYS9kcml2ZXJzL21kL2RtLmMKPj4+ICsrKyBiL2Ry
aXZlcnMvbWQvZG0uYwo+Pj4gQEAgLTI1NjcsNiArMjU2Nyw3IEBAIHN0YXRpYyB2b2lkIGRtX3dx
X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQo+Pj4gICAgICAgICAgICAgICAgICAgICAg
ICAgIGJyZWFrOwo+Pj4KPj4+ICAgICAgICAgICAgICAgICAgc3VibWl0X2Jpb19ub2FjY3QoYmlv
KTsKPj4+ICsgICAgICAgICAgICAgICBjb25kX3Jlc2NoZWQoKTsKPj4+ICAgICAgICAgIH0KPj4+
ICAgfQo+Pj4KPj4+IEJ1dCBJIHRoaW5rIGl0IGlzIG5vdCBhIHByb3BlciBzb2x1dGlvbi4gQW5k
IHdpdGhvdXQgdGhpcyBwYXRjaCwgaWYKPj4+IHJlbW92aW5nIG5yX2NwdXM9MSAodGhlIHN5c3Rl
bSBoYXMgdHdvIGNwdXMpLCB0aGUgaXNzdWUgY2FuIG5vdCBiZQo+Pj4gdHJpZ2dlcmVkLiBUaGF0
IHNheXMgd2hlbiBtb3JlIHRoYW4gb25lIGNwdSwgdGhlIGFib3ZlIGxvb3AgY2FuIGV4aXQKPj4+
IGJ5IHRoZSBjb25kaXRpb24gImlmICghYmlvKSIKPj4+Cj4+PiBBbnkgaWRlYXM/Cj4+IEkgdGhp
bmsgdGhlIHBhdGNoIGlzIGNvcnJlY3QuCj4+Cj4+IEZvciBrZXJuZWwgYnVpbHQgd2l0aG91dCBD
T05GSUdfUFJFRU1QVCwgaW4gY2FzZSBvZiBzaW5nbGUgY3B1IGNvcmUsCj4+IGlmIHRoZSBkbSB0
YXJnZXQoc3VjaCBhcyBkbS10aGluKSBuZWVkcyBhbm90aGVyIHdxIG9yIGt0aHJlYWQgZm9yCj4+
IGhhbmRsaW5nIElPLCB0aGVuIGRtIHRhcmdldCBzaWRlIGlzIGJsb2NrZWQgYmVjYXVzZSBkbV93
cV93b3JrKCkKPj4gaG9sZHMgdGhlIHNpbmdsZSBjcHUsIHNvb25lciBvciBsYXRlciwgZG0gdGFy
Z2V0IG1heSBoYXZlIG5vdAo+PiByZXNvdXJjZSB0byBoYW5kbGUgbmV3IGlvIGZyb20gZG0gY29y
ZSBhbmQgcmV0dXJucyBSRVFVRVVFLgo+Pgo+PiBUaGVuIGRtX3dxX3dvcmsgYmVjb21lcyBvbmUg
ZGVhZCBsb29wLgo+Pgo+Pgo+PiBUaGFua3MsCj4+IE1pbmcKPj4KCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK


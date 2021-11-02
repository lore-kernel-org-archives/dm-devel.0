Return-Path: <SRS0=e/dp=PW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92A3C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 06:52:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 84D146023B
	for <dm-devel@archiver.kernel.org>; Wed,  3 Nov 2021 06:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 84D146023B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635922324;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MlmdqLGtbQuEpj3Mju/NJ3u+BVx3bSsf22kCBUS3qO8=;
	b=bTv+moMiCcfbknEmriGvgCRVOMLwI5pN+QFgfaJ7g+Ob0/ColwFn9U7o3hgX884vX6oTo1
	bxX3FA5+ah5/nJqC/K6vbJZV/uzK2Z6Q9ACjNhIbCyVrhClO+XELrdUnEhfza0qckDnl6B
	YuUooHaVMhZKmXWFHFylsPS2RlIbN+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-YUJVjWnfMB-ds4b2heZamA-1; Wed, 03 Nov 2021 02:50:59 -0400
X-MC-Unique: YUJVjWnfMB-ds4b2heZamA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4129BAF82;
	Wed,  3 Nov 2021 06:50:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DEAD5F4F7;
	Wed,  3 Nov 2021 06:50:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 72E464E58F;
	Wed,  3 Nov 2021 06:50:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A2Jj0ED022344 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Nov 2021 15:45:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 93EAA1B472; Tue,  2 Nov 2021 19:45:00 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.9.231])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20627226E9;
	Tue,  2 Nov 2021 19:44:31 +0000 (UTC)
From: Steve Grubb <sgrubb@redhat.com>
To: corbet@lwn.net, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
	eparis@redhat.com, jmorris@namei.org, serge@hallyn.com,
	linux-audit@redhat.com, Deven Bowers <deven.desai@linux.microsoft.com>
Date: Tue, 02 Nov 2021 15:44:30 -0400
Message-ID: <1898302.usQuhbGJ8B@x2>
Organization: Red Hat
In-Reply-To: <8802b1ff-3028-642a-22c5-bc4896450a60@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<2159283.iZASKD2KPV@x2>
	<8802b1ff-3028-642a-22c5-bc4896450a60@linux.microsoft.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A2Jj0ED022344
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 03 Nov 2021 02:50:50 -0400
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8sCgpPbiBGcmlkYXksIE9jdG9iZXIgMTUsIDIwMjEgMzoyNTo0NyBQTSBFRFQgRGV2ZW4g
Qm93ZXJzIHdyb3RlOgo+IE9uIDEwLzEzLzIwMjEgMTowMiBQTSwgU3RldmUgR3J1YmIgd3JvdGU6
Cj4gPiBPbiBXZWRuZXNkYXksIE9jdG9iZXIgMTMsIDIwMjEgMzowNjoyNiBQTSBFRFQKPiA+IGRl
dmVuLmRlc2FpQGxpbnV4Lm1pY3Jvc29mdC5jb20+IAo+ID4gd3JvdGU6Cj4gPj4gVXNlcnMgb2Yg
SVBFIHJlcXVpcmUgYSB3YXkgdG8gaWRlbnRpZnkgd2hlbiBhbmQgd2h5IGFuIG9wZXJhdGlvbiBm
YWlscywKPiA+PiBhbGxvd2luZyB0aGVtIHRvIGJvdGggcmVzcG9uZCB0byB2aW9sYXRpb25zIG9m
IHBvbGljeSBhbmQgYmUgbm90aWZpZWQKPiA+PiBvZiBwb3RlbnRpYWxseSBtYWxpY2lvdXMgYWN0
aW9ucyBvbiB0aGVpciBzeXN0ZW5zIHdpdGggcmVzcGVjdCB0byBJUEUKPiA+PiBpdHNlbGYuCj4g
PiAKPiA+IFdvdWxkIHlvdSBtaW5kIHNlbmRpbmcgZXhhbXBsZXMgb2YgYXVkaXQgZXZlbnRzIHNv
IHRoYXQgd2UgY2FuIHNlZSB3aGF0Cj4gPiB0aGUgZW5kIHJlc3VsdCBpcz8gU29tZSBwZW9wbGUg
YWRkIHRoZW0gdG8gdGhlIGNvbW1pdCB0ZXh0LiBCdXQgd2Ugc3RpbGwKPiA+IG5lZWQgdG8gc2Vl
IHdoYXQgdGhleSBsb29rIGxpa2UuCj4gCj4gU3VyZSwgc29ycnkuIEnigJlsbCBhZGQgdGhlbSB0
byB0aGUgY29tbWl0IGRlc2NyaXB0aW9uIChhbmQgdGhlIGRvY3VtZW50YXRpb24KPiBwYXRjaCBh
dCB0aGUgZW5kKSBmb3Igdjgg4oCTIEluIHRoZSBpbnRlcmVzdCBvZiBhc3luY2hyb25vdXMgZmVl
ZGJhY2ssIEnigJl2ZQo+IGNvcGllZCB0aGUgcmVsZXZhbnQgZXhhbXBsZXM6CgpUaGFua3MgZm9y
IHNlbmRpbmcgdGhlc2UuIFRoaXMgaGVscHMuCgogCj4gQVVESVQxNDIwIElQRSBjdHhfcGlkPTIy
OSBjdHhfb3A9RVhFQ1VURSBjdHhfaG9vaz1NTUFQIGN0eF9lbmZvcmNlPTAKPiBjdHhfY29tbT0i
Z3JlcCIgY3R4X3BhdGhuYW1lPSIvdXNyL2xpYi9saWJjLTIuMjMuc28iCj4gY3R4X2lubz01MzIg
Y3R4X2Rldj12ZGEgcnVsZT0iREVGQVVMVCBvcD1FWEVDVVRFIGFjdGlvbj1ERU5ZIgoKUXVlc3Rp
b24uLi53aHkgZG8gYWxsIG9mIHRoZXNlIGhhdmUgYSBjdHhfICBwcmVmaXg/IElzIGl0IHBvc3Np
YmxlIHRvIHRyaWdnZXIgCmFuIGF1ZGl0IGNvbnRleHQgc28gdGhhdCB0aGUgYXVkaXQgbWFjaGlu
ZXJ5IGNvbGxlY3RzIGFsbCBvZiB0aGlzIHN0dWZmIGluIAppdCdzIG93biB3YXk/IFdoaWNoIG1l
YW5zIHlvdSBjb3VsZCBkcm9wIGV2ZXJ5dGhpbmcgZXhlY2VwdCBvcCwgaG9vaywgCmVuZm9yY2Us
IHJ1bGUsIGFuZCBhY3Rpb24uCgpXZSBhbHNvIGhhdmUgYSBmaWVsZCBkaWN0aW9uYXJ5IGhlcmU6
Cmh0dHBzOi8vZ2l0aHViLmNvbS9saW51eC1hdWRpdC9hdWRpdC1kb2N1bWVudGF0aW9uL2Jsb2Iv
bWFpbi9zcGVjcy9maWVsZHMvCmZpZWxkLWRpY3Rpb25hcnkuY3N2Cgp3aGljaCBuYW1lcyB0aGUg
a25vd24gZmllbGRzIGFuZCBob3cgdGhleSBzaG91bGQgYmUgZm9ybWF0dGVkLiBJZiB0aGVyZSBp
cyBhIApjb2xsaXNpb24gd2hlcmUgdGhleSBhcmUgc29tZXRoaW5nIGVsc2UgYW5kIGNhbm5vdCBi
ZSBpbiB0aGUgc2FtZSBmb3JtYXQsIAp0aGVuIHdlIG1ha2UgYSBuZXcgbmFtZSBhbmQgaG9wZWZ1
bGx5IHVwZGF0ZSB0aGUgZGljdGlvbmFyeS4gRm9yIGV4YW1wbGUsIGlmIAp5b3UgYXJlIGNvbGxl
Y3RpbmcgYSBwcm9jZXNzIGlkLCB1c2UgcGlkIGFuZCBub3QgY3R4X3BpZCBzbyB0aGF0IGl0IG1h
dGNoZXMgYSAKa25vd24gZGVmaW5pdGlvbi4KCkFsc28sIEkgZG9uJ3QgdGhuayB0aGVzZSBldmVu
dHMgY2FuIHN0YW5kIG9uIHRoZWlyIG93bi4gV2hvIGRpZCB0aGlzIGFjdGlvbj8gCllvdSBoYXZl
IHRoZSBwaWQsIGJ1dCBubyB1aWQsIGF1aWQsIG9yIHNlc3Npb25faWQuCgpIb3BlIHRoaXMgaGVs
cHMuLi4KCi1TdGV2ZQoKIAo+IEFVRElUMTQyMCBJUEUgY3R4X3BpZD0yMjkgY3R4X29wPUVYRUNV
VEUgY3R4X2hvb2s9TU1BUCBjdHhfZW5mb3JjZT0wCj4gY3R4X2NvbW09ImdyZXAiIGN0eF9wYXRo
bmFtZT0iL3Vzci9saWIvbGliYy0yLjIzLnNvIgo+IGN0eF9pbm89NTMyIGN0eF9kZXY9dmRhIHJ1
bGU9IkRFRkFVTFQgYWN0aW9uPURFTlkiCj4gCj4gQVVESVQxNDIwIElQRSBjdHhfcGlkPTI1MyBj
dHhfb3A9RVhFQ1VURSBjdHhfaG9vaz1NTUFQIGN0eF9lbmZvcmNlPTEKPiBjdHhfY29tbT0iYW5v
biIgcnVsZT0iREVGQVVMVCBvcD1FWEVDVVRFIGFjdGlvbj1ERU5ZIgo+IAo+IFRoZXNlIHRocmVl
IGF1ZGl0IHJlY29yZHMgcmVwcmVzZW50IHZhcmlvdXMgdHlwZXMgb2YgcmVzdWx0cyBhZnRlcgo+
IGV2YWx1YXRpbmcKPiB0aGUgdHJ1c3Qgb2YgYSByZXNvdXJjZS4gVGhlIGZpcnN0IHR3byBkaWZm
ZXIgaW4gdGhlIHJ1bGUgdGhhdCB3YXMKPiBtYXRjaGVkIGluCj4gSVBFJ3MgcG9saWN5LCB0aGUg
Zmlyc3QgYmVpbmcgYW4gb3BlcmF0aW9uLXNwZWNpZmljIGRlZmF1bHQsIHRoZSBzZWNvbmQKPiBi
ZWluZwo+IGEgZ2xvYmFsIGRlZmF1bHQuIFRoZSB0aGlyZCBpcyBhbiBleGFtcGxlIG9mIHdoYXQg
aXMgYXVkaXRlZCB3aGVuIGFub255bW91cwo+IG1lbW9yeSBpcyBibG9ja2VkIChhcyB0aGVyZSBp
cyBubyB3YXkgdG8gdmVyaWZ5IHRoZSB0cnVzdCBvZiBhbiBhbm9ueW1vdXMKPiBwYWdlKS4KPiAK
PiBUaGUgcmVtYWluaW5nIHRocmVlIGV2ZW50cywgQVVESVRfVFJVU1RfUE9MSUNZX0xPQUQgKDE0
MjEpLAo+IEFVRElUX1RSVVNUX1BPTElDWV9BQ1RJVkFURSAoMTQyMiksIGFuZCBBVURJVF9UUlVT
VF9TVEFUVVMgKDE0MjMpIGhhdmUgdGhpcwo+IGZvcm06Cj4gCj4gQVVESVQxNDIxIElQRSBwb2xp
Y3lfbmFtZT0ibXktcG9saWN5IiBwb2xpY3lfdmVyc2lvbj0wLjAuMAo+IDxoYXNoX2FsZ19uYW1l
Pj08aGFzaD4KPiBBVURJVDE0MjIgSVBFIHBvbGljeV9uYW1lPSJteS1wb2xpY3kiIHBvbGljeV92
ZXJzaW9uPTAuMC4wCj4gPGhhc2hfYWxnX25hbWU+PTxoYXNoPgo+IEFVRElUMTQyMyBJUEUgZW5m
b3JjZT0xCj4gCj4gVGhlIDE0MjEgKEFVRElUX1RSVVNUX1BPTElDWV9MT0FEKSBldmVudCByZXBy
ZXNlbnRzIGEgbmV3IHBvbGljeSB3YXMgbG9hZGVkCj4gaW50byB0aGUga2VybmVsLCBidXQgbm90
IGlzIG5vdCBtYXJrZWQgYXMgdGhlIHBvbGljeSB0byBlbmZvcmNlLiBUaGUKPiAKPiBUaGUgMTQy
MiAoQVVESVRfVFJVU1RfUE9MSUNZX0FDVElWQVRFKSBldmVudCByZXByZXNlbnRzIGEgcG9saWN5
IHRoYXQgd2FzCj4gYWxyZWFkeSBsb2FkZWQgd2FzIG1hZGUgdGhlIGVuZm9yY2luZyBwb2xpY3ku
Cj4gCj4gVGhlIDE0MjMgKEFVRElUX1RSVVNUX1NUQVRVUykgZXZlbnQgcmVwcmVzZW50cyBhIHN3
aXRjaCBiZXR3ZWVuCj4gcGVybWlzc2l2ZSBhbmQKPiBlbmZvcmNlLCBpdCBpcyBhZGRlZCBpbiAw
OC8xNiAodGhlIGZvbGxvd2luZyBwYXRjaCkKCgoKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs


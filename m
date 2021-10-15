Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111F3C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 19:26:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7E93761163
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 19:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7E93761163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-rSRuJYROOAGQnEPKTzdn7A-1; Fri, 15 Oct 2021 15:26:04 -0400
X-MC-Unique: rSRuJYROOAGQnEPKTzdn7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE4681922961;
	Fri, 15 Oct 2021 19:25:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92E8417A9B;
	Fri, 15 Oct 2021 19:25:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4DB674A702;
	Fri, 15 Oct 2021 19:25:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FJPvKE025523 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 15:25:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EBAA410088AB; Fri, 15 Oct 2021 19:25:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E700A10088AA
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 19:25:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23AA51066559
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 19:25:54 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-194-o33e4dH0PLm12iJ6Yz0Fdw-1;
	Fri, 15 Oct 2021 15:25:49 -0400
X-MC-Unique: o33e4dH0PLm12iJ6Yz0Fdw-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id 50A6D20B9D2C;
	Fri, 15 Oct 2021 12:25:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 50A6D20B9D2C
Message-ID: <8802b1ff-3028-642a-22c5-bc4896450a60@linux.microsoft.com>
Date: Fri, 15 Oct 2021 12:25:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: Steve Grubb <sgrubb@redhat.com>, corbet@lwn.net, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu, 
	paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
	serge@hallyn.com, linux-audit@redhat.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
	<2159283.iZASKD2KPV@x2>
From: Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <2159283.iZASKD2KPV@x2>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19FJPvKE025523
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTAvMTMvMjAyMSAxOjAyIFBNLCBTdGV2ZSBHcnViYiB3cm90ZToKCj4gSGVsbG8sCj4KPiBP
biBXZWRuZXNkYXksIE9jdG9iZXIgMTMsIDIwMjEgMzowNjoyNiBQTSBFRFQgZGV2ZW4uZGVzYWlA
bGludXgubWljcm9zb2Z0LmNvbQo+IHdyb3RlOgo+PiBVc2VycyBvZiBJUEUgcmVxdWlyZSBhIHdh
eSB0byBpZGVudGlmeSB3aGVuIGFuZCB3aHkgYW4gb3BlcmF0aW9uIGZhaWxzLAo+PiBhbGxvd2lu
ZyB0aGVtIHRvIGJvdGggcmVzcG9uZCB0byB2aW9sYXRpb25zIG9mIHBvbGljeSBhbmQgYmUgbm90
aWZpZWQKPj4gb2YgcG90ZW50aWFsbHkgbWFsaWNpb3VzIGFjdGlvbnMgb24gdGhlaXIgc3lzdGVu
cyB3aXRoIHJlc3BlY3QgdG8gSVBFCj4+IGl0c2VsZi4KPiBXb3VsZCB5b3UgbWluZCBzZW5kaW5n
IGV4YW1wbGVzIG9mIGF1ZGl0IGV2ZW50cyBzbyB0aGF0IHdlIGNhbiBzZWUgd2hhdCB0aGUKPiBl
bmQgcmVzdWx0IGlzPyBTb21lIHBlb3BsZSBhZGQgdGhlbSB0byB0aGUgY29tbWl0IHRleHQuIEJ1
dCB3ZSBzdGlsbCBuZWVkIHRvCj4gc2VlIHdoYXQgdGhleSBsb29rIGxpa2UuCj4KPiBUaGFua3Ms
Cj4gLVN0ZXZlCgpTdXJlLCBzb3JyeS4gSeKAmWxsIGFkZCB0aGVtIHRvIHRoZSBjb21taXQgZGVz
Y3JpcHRpb24gKGFuZCB0aGUgZG9jdW1lbnRhdGlvbgpwYXRjaCBhdCB0aGUgZW5kKSBmb3Igdjgg
4oCTIEluIHRoZSBpbnRlcmVzdCBvZiBhc3luY2hyb25vdXMgZmVlZGJhY2ssIEnigJl2ZQpjb3Bp
ZWQgdGhlIHJlbGV2YW50IGV4YW1wbGVzOgoKQVVESVQxNDIwIElQRSBjdHhfcGlkPTIyOSBjdHhf
b3A9RVhFQ1VURSBjdHhfaG9vaz1NTUFQIGN0eF9lbmZvcmNlPTAKY3R4X2NvbW09ImdyZXAiIGN0
eF9wYXRobmFtZT0iL3Vzci9saWIvbGliYy0yLjIzLnNvIgpjdHhfaW5vPTUzMiBjdHhfZGV2PXZk
YSBydWxlPSJERUZBVUxUIG9wPUVYRUNVVEUgYWN0aW9uPURFTlkiCgpBVURJVDE0MjAgSVBFIGN0
eF9waWQ9MjI5IGN0eF9vcD1FWEVDVVRFIGN0eF9ob29rPU1NQVAgY3R4X2VuZm9yY2U9MApjdHhf
Y29tbT0iZ3JlcCIgY3R4X3BhdGhuYW1lPSIvdXNyL2xpYi9saWJjLTIuMjMuc28iCmN0eF9pbm89
NTMyIGN0eF9kZXY9dmRhIHJ1bGU9IkRFRkFVTFQgYWN0aW9uPURFTlkiCgpBVURJVDE0MjAgSVBF
IGN0eF9waWQ9MjUzIGN0eF9vcD1FWEVDVVRFIGN0eF9ob29rPU1NQVAgY3R4X2VuZm9yY2U9MQpj
dHhfY29tbT0iYW5vbiIgcnVsZT0iREVGQVVMVCBvcD1FWEVDVVRFIGFjdGlvbj1ERU5ZIgoKVGhl
c2UgdGhyZWUgYXVkaXQgcmVjb3JkcyByZXByZXNlbnQgdmFyaW91cyB0eXBlcyBvZiByZXN1bHRz
IGFmdGVyIApldmFsdWF0aW5nCnRoZSB0cnVzdCBvZiBhIHJlc291cmNlLiBUaGUgZmlyc3QgdHdv
IGRpZmZlciBpbiB0aGUgcnVsZSB0aGF0IHdhcyAKbWF0Y2hlZCBpbgpJUEUncyBwb2xpY3ksIHRo
ZSBmaXJzdCBiZWluZyBhbiBvcGVyYXRpb24tc3BlY2lmaWMgZGVmYXVsdCwgdGhlIHNlY29uZCAK
YmVpbmcKYSBnbG9iYWwgZGVmYXVsdC4gVGhlIHRoaXJkIGlzIGFuIGV4YW1wbGUgb2Ygd2hhdCBp
cyBhdWRpdGVkIHdoZW4gYW5vbnltb3VzCm1lbW9yeSBpcyBibG9ja2VkIChhcyB0aGVyZSBpcyBu
byB3YXkgdG8gdmVyaWZ5IHRoZSB0cnVzdCBvZiBhbiBhbm9ueW1vdXMKcGFnZSkuCgpUaGUgcmVt
YWluaW5nIHRocmVlIGV2ZW50cywgQVVESVRfVFJVU1RfUE9MSUNZX0xPQUQgKDE0MjEpLApBVURJ
VF9UUlVTVF9QT0xJQ1lfQUNUSVZBVEUgKDE0MjIpLCBhbmQgQVVESVRfVFJVU1RfU1RBVFVTICgx
NDIzKSBoYXZlIHRoaXMKZm9ybToKCkFVRElUMTQyMSBJUEUgcG9saWN5X25hbWU9Im15LXBvbGlj
eSIgcG9saWN5X3ZlcnNpb249MC4wLjAgCjxoYXNoX2FsZ19uYW1lPj08aGFzaD4KQVVESVQxNDIy
IElQRSBwb2xpY3lfbmFtZT0ibXktcG9saWN5IiBwb2xpY3lfdmVyc2lvbj0wLjAuMCAKPGhhc2hf
YWxnX25hbWU+PTxoYXNoPgpBVURJVDE0MjMgSVBFIGVuZm9yY2U9MQoKVGhlIDE0MjEgKEFVRElU
X1RSVVNUX1BPTElDWV9MT0FEKSBldmVudCByZXByZXNlbnRzIGEgbmV3IHBvbGljeSB3YXMgbG9h
ZGVkCmludG8gdGhlIGtlcm5lbCwgYnV0IG5vdCBpcyBub3QgbWFya2VkIGFzIHRoZSBwb2xpY3kg
dG8gZW5mb3JjZS4gVGhlCgpUaGUgMTQyMiAoQVVESVRfVFJVU1RfUE9MSUNZX0FDVElWQVRFKSBl
dmVudCByZXByZXNlbnRzIGEgcG9saWN5IHRoYXQgd2FzCmFscmVhZHkgbG9hZGVkIHdhcyBtYWRl
IHRoZSBlbmZvcmNpbmcgcG9saWN5LgoKVGhlIDE0MjMgKEFVRElUX1RSVVNUX1NUQVRVUykgZXZl
bnQgcmVwcmVzZW50cyBhIHN3aXRjaCBiZXR3ZWVuIApwZXJtaXNzaXZlIGFuZAplbmZvcmNlLCBp
dCBpcyBhZGRlZCBpbiAwOC8xNiAodGhlIGZvbGxvd2luZyBwYXRjaCkKCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs


Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF053C4742C
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:03:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 60589208D5
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:03:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60589208D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-mrRu2GyoMymtqoeZo3nl7A-1; Fri, 13 Nov 2020 03:03:37 -0500
X-MC-Unique: mrRu2GyoMymtqoeZo3nl7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56BA98015A3;
	Fri, 13 Nov 2020 08:03:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39B4E5B4A0;
	Fri, 13 Nov 2020 08:03:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0E89058104;
	Fri, 13 Nov 2020 08:03:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACNGB4h016109 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 18:16:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4BB031175418; Thu, 12 Nov 2020 23:16:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 478741175416
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 23:16:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C39FC800183
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 23:16:08 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-526-2ExNEnYOOEeQp59-Nna9tA-1;
	Thu, 12 Nov 2020 18:16:04 -0500
X-MC-Unique: 2ExNEnYOOEeQp59-Nna9tA-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id C4B2820C287A;
	Thu, 12 Nov 2020 15:16:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C4B2820C287A
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-3-tusharsu@linux.microsoft.com>
	<d0e96ccc49590c5ff11675661592b70b0f021636.camel@linux.ibm.com>
	<7034a775-cde6-1eae-132a-4cb84f310bca@linux.microsoft.com>
	<0fa1a12388681b49167b58e349cb7c9e996dcd05.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <42b967c4-7a95-6b5e-aaa8-88e649ea987e@linux.microsoft.com>
Date: Thu, 12 Nov 2020 15:16:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0fa1a12388681b49167b58e349cb7c9e996dcd05.camel@linux.ibm.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ACNGB4h016109
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 2/7] IMA: update
 process_buffer_measurement to measure buffer hash
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIwLTExLTEyIDI6MTkgcC5tLiwgTWltaSBab2hhciB3cm90ZToKPiBPbiBUaHUsIDIw
MjAtMTEtMTIgYXQgMTM6NDcgLTA4MDAsIFR1c2hhciBTdWdhbmRoaSB3cm90ZToKPj4+IE9uIFN1
biwgMjAyMC0xMS0wMSBhdCAxNDoyNiAtMDgwMCwgVHVzaGFyIFN1Z2FuZGhpIHdyb3RlOgo+Pj4+
IHByb2Nlc3NfYnVmZmVyX21lYXN1cmVtZW50KCkgY3VycmVudGx5IG9ubHkgbWVhc3VyZXMgdGhl
IGlucHV0IGJ1ZmZlci4KPj4+PiBJbiBjYXNlIG9mIFNlTGludXggcG9saWN5IG1lYXN1cmVtZW50
LCB0aGUgcG9saWN5IGJlaW5nIG1lYXN1cmVkIGNvdWxkCj4+Pj4gYmUgbGFyZ2UgKHNldmVyYWwg
TUIpLiBUaGlzIG1heSByZXN1bHQgaW4gYSBsYXJnZSBlbnRyeSBpbiBJTUEKPj4+PiBtZWFzdXJl
bWVudCBsb2cuCj4+Pgo+Pj4gU0VMaW51eCBpcyBhbiBleGFtcGxlIG9mIG1lYXN1cmluZyBsYXJn
ZSBidWZmZXIgZGF0YS4gIFBsZWFzZSByZXdyaXRlCj4+PiB0aGlzIHBhdGNoIGRlc2NyaXB0aW9u
IChhbmQgdGhlIG90aGVyIHBhdGNoIGRlc2NyaXB0aW9ucyBpbiB0aGlzIHBhdGNoCj4+PiBzZXQp
IHdpdGhvdXQgdXNpbmcgdGhlIGV4YW1wbGUgdG8gZGVzY3JpYmUgaXRzIHB1cnBvc2UgWzFdLgo+
Pj4KPj4+IEluIHRoaXMgY2FzZSwgeW91IG1pZ2h0IHNheSwKPj4+Cj4+PiBUaGUgb3JpZ2luYWwg
SU1BIGJ1ZmZlciBkYXRhIG1lYXN1cmVtZW50IHNpemVzIHdlcmUgc21hbGwgKGUuZy4gYm9vdAo+
Pj4gY29tbWFuZCBsaW5lKSwgYnV0IG5ldyBidWZmZXIgZGF0YSBtZWFzdXJlbWVudCB1c2UgY2Fz
ZXMgYXJlIGEgbG90Cj4+PiBsYXJnZXIuICBKdXN0IGFzIElNQSBtZWFzdXJlcyB0aGUgZmlsZSBk
YXRhIGhhc2gsIG5vdCB0aGUgZmlsZSBkYXRhLAo+Pj4gSU1BIHNob3VsZCBzaW1pbGFybHkgc3Vw
cG9ydCBtZWFzdXJpbmcgdGhlIGJ1ZmZlciBkYXRhIGhhc2guCj4+Pgo+PiBTdXJlLiBUaGFua3Mg
YSBsb3QgZm9yIGdpdmluZyBhbiBleGFtcGxlIHdvcmRpbmcgZm9yIHVzLiBXaWxsIHVwZGF0ZS4K
Pj4+Pgo+Pj4+IEludHJvZHVjZSBhIGJvb2xlYW4gcGFyYW1ldGVyIG1lYXN1cmVfYnVmX2hhc2gg
dG8gc3VwcG9ydCBtZWFzdXJpbmcKPj4+PiBoYXNoIG9mIGEgYnVmZmVyLCB3aGljaCB3b3VsZCBi
ZSBtdWNoIHNtYWxsZXIsIGluc3RlYWQgb2YgdGhlIGJ1ZmZlcgo+Pj4+IGl0c2VsZi4KPj4+Cj4+
Pj4gVG8gdXNlIHRoZSBmdW5jdGlvbmFsaXR5IGludHJvZHVjZWQgaW4gdGhpcyBwYXRjaCwgdGhl
IGF0dGVzdGF0aW9uCj4+Pj4gY2xpZW50IGFuZCB0aGUgc2VydmVyIGNoYW5nZXMgbmVlZCB0byBn
byBoYW5kIGluIGhhbmQuIFRoZQo+Pj4+IGNsaWVudC9rZXJuZWwgd291bGQga25vdyB3aGF0IGRh
dGEgaXMgYmVpbmcgbWVhc3VyZWQgYXMtaXMKPj4+PiAoZS5nLiBLRVhFQ19DTURMSU5FKSwgYW5k
IHdoYXQgZGF0YSBoYXMgaXTigJlzIGhhc2ggbWVhc3VyZWQgKGUuZy4gU2VMaW51eAo+Pj4+IFBv
bGljeSkuIEFuZCB0aGUgYXR0ZXN0YXRpb24gc2VydmVyIHNob3VsZCB2ZXJpZnkgZGF0YS9oYXNo
IGFjY29yZGluZ2x5Lgo+Pj4+Cj4+Pj4gSnVzdCBsaWtlIHRoZSBkYXRhIGJlaW5nIG1lYXN1cmVk
IGluIG90aGVyIGNhc2VzLCB0aGUgYXR0ZXN0YXRpb24gc2VydmVyCj4+Pj4gd2lsbCBrbm93IHdo
YXQgYXJlIHBvc3NpYmxlIHZhbHVlcyBvZiB0aGUgbGFyZ2UgYnVmZmVycyBiZWluZyBtZWFzdXJl
ZC4KPj4+PiBlLmcuIHRoZSBwb3NzaWJsZSB2YWxpZCBTZUxpbnV4IHBvbGljeSB2YWx1ZXMgdGhh
dCBhcmUgYmVpbmcgcHVzaGVkIHRvCj4+Pj4gdGhlIGNsaWVudC4gVGhlIGF0dGVzdGF0aW9uIHNl
cnZlciB3aWxsIGhhdmUgdG8gbWFpbnRhaW4gdGhlIGhhc2ggb2YKPj4+PiB0aG9zZSBidWZmZXIg
dmFsdWVzLgo+Pj4KPj4+IEVhY2ggcGF0Y2ggaW4gdGhlIHBhdGNoIHNldCBidWlsZHMgdXBvbiB0
aGUgcHJldmlvdXMgb25lLiAgIChUaGluayBvZgo+Pj4gaXQgYXMgYSBzdG9yeSwgd2hlcmUgZWFj
aCBjaGFwdGVyIGJ1aWxkcyB1cG9uIHRoZSBwcmV2aW91cyBvbmVzLikKPj4+IFdpdGggcmFyZSBl
eGNlcHRpb25zLCBzaG91bGQgcGF0Y2hlcyByZWZlcmVuY2Ugc3Vic2VxdWVudCBwYXRjaGVzLiBb
Ml0KPj4+Cj4+PiBbMV0gUmVmZXIgdG8gRG9jdW1lbnRhdGlvbi9wcm9jZXNzL3N1Ym1pdHRpbmct
cGF0Y2hlcy5yc3QKPj4+IFsyXSBSZWZlciB0byB0aGUgc2VjdGlvbiAiOCkgQ29tbWVudGluZyIg
aW4KPj4+IERvY3VtZW50YXRpb24vcHJvY2Vzcy9jb2Rpbmctc3R5bGUucnN0Cj4+Pgo+PiBJIGFt
IG5vdCBzdXJlIGlmIHlvdSBoYXZlIGFueSBjb25jZXJucyBhYm91dCB0aGUgbGFzdCB0d28gcGFy
YWdyYXBocy4KPj4gVGhlIGRlc2NyaXB0aW9uIGFib3V0IHRoZSBhdHRlc3RhdGlvbiBjbGllbnQg
YW5kIHNlcnZlciAodGhlIGxhc3QgdHdvCj4+IHBhcmFncmFwaHMpIHdhcyBhZGRlZCBmb3IgaW5m
b3JtYXRpb24vY2xhcmlmaWNhdGlvbiBwdXJwb3NlIG9ubHksIGFzIHBlcgo+PiB5b3VyIGZlZWRi
YWNrIG9uIHByZXZpb3VzIGl0ZXJhdGlvbnMuIFRoZSBzdWJzZXF1ZW50IHBhdGNoZXMgZG9u4oCZ
dCBoYXZlCj4+IGFueSBjb2RlIHBlcnRhaW5pbmcgdG8gYXR0ZXN0YXRpb24gY2xpZW50L3NlcnZl
ci4KPj4KPj4gKlF1ZXN0aW9uKgo+PiBNYXliZSB0aGUgbGFzdCB0d28gcGFyYWdyYXBocyBhcmUg
Y29uZnVzaW5nL3JlZHVuZGFudC4gQ291bGQgeW91IHBsZWFzZQo+PiBsZXQgbWUga25vdyBpZiBJ
IHNob3VsZCByZW1vdmUgdGhlIGFib3ZlIHR3byBwYXJhZ3JhcGhzIGFsdG9nZXRoZXI/Cj4+IChz
dGFydGluZyB3aXRoIOKAnFRvIHVzZSB0aGUgZnVuY3Rpb25hbGl0eSBpbnRyb2R1Y2VkIGluIHRo
aXMgcGF0Y2ggLi4u4oCdKQo+Pgo+PiBJZiB3ZSBkZWNpZGUgdG8ga2VlcCB0aGUgcGFyYWdyYXBo
cywgSSB3aWxsIHJlbW92ZSB0aGUgc3BlY2lmaWMgZXhhbXBsZXMKPj4gKEtFWEVDX0NNRExJTkUs
IFNlTGludXggZXRjLikgYXMgeW91IG1lbnRpb25lZCBlbHNld2hlcmUuCj4gCj4gSW5zdGVhZCBv
ZiB0aGUgYWJvdmUgdHdvIHBhcmFncmFwaHMsIHBlcmhhcHMgZXhwbGFpbiBob3cgbWVhc3VyaW5n
IHRoZQo+IGZpbGUgZGF0YSBoYXNoIGRpZmZlcnMgZnJvbSBtZWFzdXJpbmcgdGhlIGJ1ZmZlciBk
YXRhIGhhc2guICBLZWVwIHRoZQo+IGV4cGxhbmF0aW9uIGdlbmVyaWMsIHNob3J0IGFuZCBzaW1w
bGUuCj4gCj4gTWltaQo+IApXaWxsIGRvLiBUaGFua3MgZm9yIHRoZSBxdWljayByZXNwb25zZSBN
aW1pLgpJIGFsc28gaGF2ZSBzb21lIGNsYXJpZmljYXRpb24gcXVlc3Rpb25zIG9uIHRoZSBvdGhl
ciBwYXRjaGVzIGluIHRoaXMKc2VyaWVzIGFzIHdlbGwuCgpXb3VsZCByZWFsbHkgYXBwcmVjaWF0
ZSBpZiB5b3UgY291bGQgaGVscCB1cyBnZXQgY2xhcmlmaWNhdGlvbiBvbiB0aG9zZS4KClRoYW5r
cyBhIGxvdCBhZ2Fpbi4KCn5UdXNoYXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw=


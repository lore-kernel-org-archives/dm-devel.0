Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518B5C55ABD
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A643720857
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A643720857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-8UpxzLH5PzeiYbHR_4EyTg-1; Fri, 13 Nov 2020 03:02:45 -0500
X-MC-Unique: 8UpxzLH5PzeiYbHR_4EyTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7EDE1084D8A;
	Fri, 13 Nov 2020 08:02:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EEB65D9F7;
	Fri, 13 Nov 2020 08:02:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 566E45810F;
	Fri, 13 Nov 2020 08:02:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACLlbp2005306 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 16:47:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 394731006512; Thu, 12 Nov 2020 21:47:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 354581007A27
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 21:47:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7F76800183
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 21:47:34 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-43-ky-tUznpPMmZIN8KgDVJAA-1;
	Thu, 12 Nov 2020 16:47:30 -0500
X-MC-Unique: ky-tUznpPMmZIN8KgDVJAA-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id C6CEE20C2872;
	Thu, 12 Nov 2020 13:47:27 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C6CEE20C2872
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-3-tusharsu@linux.microsoft.com>
	<d0e96ccc49590c5ff11675661592b70b0f021636.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <7034a775-cde6-1eae-132a-4cb84f310bca@linux.microsoft.com>
Date: Thu, 12 Nov 2020 13:47:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d0e96ccc49590c5ff11675661592b70b0f021636.camel@linux.ibm.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ACLlbp2005306
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGVsbG8gTWltaSwKCk9uIDIwMjAtMTEtMDUgNjozMCBhLm0uLCBNaW1pIFpvaGFyIHdyb3RlOgo+
IEhpIFR1c2hhciwKPiAKPiBQbGVhc2UgZG9uJ3QgaW5jbHVkZSB0aGUgZmlsZW5hbWUgaW4gdGhl
IFN1YmplY3QgbGluZVsxXS4gICBUaGUgU3ViamVjdAo+IGxpbmUgc2hvdWxkIGJlIGEgc3VtbWFy
eSBwaHJhc2UgZGVzY3JpYmluZyB0aGUgcGF0Y2guICAgSW4gdGhpcyBjYXNlLAo+IGl0IGlzIGFk
ZGluZyBzdXBwb3J0IGZvciBtZWFzdXJpbmcgdGhlIGJ1ZmZlciBkYXRhIGhhc2guCj4gClRoYW5r
cy4gV2lsbCB1cGRhdGUgdGhlIHN1YmplY3QgbGluZSBhY2NvcmRpbmdseS4KCj4gT24gU3VuLCAy
MDIwLTExLTAxIGF0IDE0OjI2IC0wODAwLCBUdXNoYXIgU3VnYW5kaGkgd3JvdGU6Cj4+IHByb2Nl
c3NfYnVmZmVyX21lYXN1cmVtZW50KCkgY3VycmVudGx5IG9ubHkgbWVhc3VyZXMgdGhlIGlucHV0
IGJ1ZmZlci4KPj4gSW4gY2FzZSBvZiBTZUxpbnV4IHBvbGljeSBtZWFzdXJlbWVudCwgdGhlIHBv
bGljeSBiZWluZyBtZWFzdXJlZCBjb3VsZAo+PiBiZSBsYXJnZSAoc2V2ZXJhbCBNQikuIFRoaXMg
bWF5IHJlc3VsdCBpbiBhIGxhcmdlIGVudHJ5IGluIElNQQo+PiBtZWFzdXJlbWVudCBsb2cuCj4g
Cj4gU0VMaW51eCBpcyBhbiBleGFtcGxlIG9mIG1lYXN1cmluZyBsYXJnZSBidWZmZXIgZGF0YS4g
IFBsZWFzZSByZXdyaXRlCj4gdGhpcyBwYXRjaCBkZXNjcmlwdGlvbiAoYW5kIHRoZSBvdGhlciBw
YXRjaCBkZXNjcmlwdGlvbnMgaW4gdGhpcyBwYXRjaAo+IHNldCkgd2l0aG91dCB1c2luZyB0aGUg
ZXhhbXBsZSB0byBkZXNjcmliZSBpdHMgcHVycG9zZSBbMV0uCj4gCj4gSW4gdGhpcyBjYXNlLCB5
b3UgbWlnaHQgc2F5LAo+IAo+IFRoZSBvcmlnaW5hbCBJTUEgYnVmZmVyIGRhdGEgbWVhc3VyZW1l
bnQgc2l6ZXMgd2VyZSBzbWFsbCAoZS5nLiBib290Cj4gY29tbWFuZCBsaW5lKSwgYnV0IG5ldyBi
dWZmZXIgZGF0YSBtZWFzdXJlbWVudCB1c2UgY2FzZXMgYXJlIGEgbG90Cj4gbGFyZ2VyLiAgSnVz
dCBhcyBJTUEgbWVhc3VyZXMgdGhlIGZpbGUgZGF0YSBoYXNoLCBub3QgdGhlIGZpbGUgZGF0YSwK
PiBJTUEgc2hvdWxkIHNpbWlsYXJseSBzdXBwb3J0IG1lYXN1cmluZyB0aGUgYnVmZmVyIGRhdGEg
aGFzaC4KPiAKU3VyZS4gVGhhbmtzIGEgbG90IGZvciBnaXZpbmcgYW4gZXhhbXBsZSB3b3JkaW5n
IGZvciB1cy4gV2lsbCB1cGRhdGUuCj4+Cj4+IEludHJvZHVjZSBhIGJvb2xlYW4gcGFyYW1ldGVy
IG1lYXN1cmVfYnVmX2hhc2ggdG8gc3VwcG9ydCBtZWFzdXJpbmcKPj4gaGFzaCBvZiBhIGJ1ZmZl
ciwgd2hpY2ggd291bGQgYmUgbXVjaCBzbWFsbGVyLCBpbnN0ZWFkIG9mIHRoZSBidWZmZXIKPj4g
aXRzZWxmLgo+IAo+PiBUbyB1c2UgdGhlIGZ1bmN0aW9uYWxpdHkgaW50cm9kdWNlZCBpbiB0aGlz
IHBhdGNoLCB0aGUgYXR0ZXN0YXRpb24KPj4gY2xpZW50IGFuZCB0aGUgc2VydmVyIGNoYW5nZXMg
bmVlZCB0byBnbyBoYW5kIGluIGhhbmQuIFRoZQo+PiBjbGllbnQva2VybmVsIHdvdWxkIGtub3cg
d2hhdCBkYXRhIGlzIGJlaW5nIG1lYXN1cmVkIGFzLWlzCj4+IChlLmcuIEtFWEVDX0NNRExJTkUp
LCBhbmQgd2hhdCBkYXRhIGhhcyBpdOKAmXMgaGFzaCBtZWFzdXJlZCAoZS5nLiBTZUxpbnV4Cj4+
IFBvbGljeSkuIEFuZCB0aGUgYXR0ZXN0YXRpb24gc2VydmVyIHNob3VsZCB2ZXJpZnkgZGF0YS9o
YXNoIGFjY29yZGluZ2x5Lgo+Pgo+PiBKdXN0IGxpa2UgdGhlIGRhdGEgYmVpbmcgbWVhc3VyZWQg
aW4gb3RoZXIgY2FzZXMsIHRoZSBhdHRlc3RhdGlvbiBzZXJ2ZXIKPj4gd2lsbCBrbm93IHdoYXQg
YXJlIHBvc3NpYmxlIHZhbHVlcyBvZiB0aGUgbGFyZ2UgYnVmZmVycyBiZWluZyBtZWFzdXJlZC4K
Pj4gZS5nLiB0aGUgcG9zc2libGUgdmFsaWQgU2VMaW51eCBwb2xpY3kgdmFsdWVzIHRoYXQgYXJl
IGJlaW5nIHB1c2hlZCB0bwo+PiB0aGUgY2xpZW50LiBUaGUgYXR0ZXN0YXRpb24gc2VydmVyIHdp
bGwgaGF2ZSB0byBtYWludGFpbiB0aGUgaGFzaCBvZgo+PiB0aG9zZSBidWZmZXIgdmFsdWVzLgo+
IAo+IEVhY2ggcGF0Y2ggaW4gdGhlIHBhdGNoIHNldCBidWlsZHMgdXBvbiB0aGUgcHJldmlvdXMg
b25lLiAgIChUaGluayBvZgo+IGl0IGFzIGEgc3RvcnksIHdoZXJlIGVhY2ggY2hhcHRlciBidWls
ZHMgdXBvbiB0aGUgcHJldmlvdXMgb25lcy4pCj4gV2l0aCByYXJlIGV4Y2VwdGlvbnMsIHNob3Vs
ZCBwYXRjaGVzIHJlZmVyZW5jZSBzdWJzZXF1ZW50IHBhdGNoZXMuIFsyXQo+IAo+IFsxXSBSZWZl
ciB0byBEb2N1bWVudGF0aW9uL3Byb2Nlc3Mvc3VibWl0dGluZy1wYXRjaGVzLnJzdAo+IFsyXSBS
ZWZlciB0byB0aGUgc2VjdGlvbiAiOCkgQ29tbWVudGluZyIgaW4KPiBEb2N1bWVudGF0aW9uL3By
b2Nlc3MvY29kaW5nLXN0eWxlLnJzdAo+IAo+IHRoYW5rcywKPiAKPiBNaW1pCj4gCkkgYW0gbm90
IHN1cmUgaWYgeW91IGhhdmUgYW55IGNvbmNlcm5zIGFib3V0IHRoZSBsYXN0IHR3byBwYXJhZ3Jh
cGhzLgpUaGUgZGVzY3JpcHRpb24gYWJvdXQgdGhlIGF0dGVzdGF0aW9uIGNsaWVudCBhbmQgc2Vy
dmVyICh0aGUgbGFzdCB0d28KcGFyYWdyYXBocykgd2FzIGFkZGVkIGZvciBpbmZvcm1hdGlvbi9j
bGFyaWZpY2F0aW9uIHB1cnBvc2Ugb25seSwgYXMgcGVyCnlvdXIgZmVlZGJhY2sgb24gcHJldmlv
dXMgaXRlcmF0aW9ucy4gVGhlIHN1YnNlcXVlbnQgcGF0Y2hlcyBkb27igJl0IGhhdmUKYW55IGNv
ZGUgcGVydGFpbmluZyB0byBhdHRlc3RhdGlvbiBjbGllbnQvc2VydmVyLgoKKlF1ZXN0aW9uKgpN
YXliZSB0aGUgbGFzdCB0d28gcGFyYWdyYXBocyBhcmUgY29uZnVzaW5nL3JlZHVuZGFudC4gQ291
bGQgeW91IHBsZWFzZQpsZXQgbWUga25vdyBpZiBJIHNob3VsZCByZW1vdmUgdGhlIGFib3ZlIHR3
byBwYXJhZ3JhcGhzIGFsdG9nZXRoZXI/IAooc3RhcnRpbmcgd2l0aCDigJxUbyB1c2UgdGhlIGZ1
bmN0aW9uYWxpdHkgaW50cm9kdWNlZCBpbiB0aGlzIHBhdGNoIC4uLuKAnSkKCklmIHdlIGRlY2lk
ZSB0byBrZWVwIHRoZSBwYXJhZ3JhcGhzLCBJIHdpbGwgcmVtb3ZlIHRoZSBzcGVjaWZpYyBleGFt
cGxlcwooS0VYRUNfQ01ETElORSwgU2VMaW51eCBldGMuKSBhcyB5b3UgbWVudGlvbmVkIGVsc2V3
aGVyZS4KCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31E5C388F9
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:22:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F60520735
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F60520735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-0EiL1gDuN7qjZ5sxNA7EDw-1; Mon, 26 Oct 2020 03:22:27 -0400
X-MC-Unique: 0EiL1gDuN7qjZ5sxNA7EDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE94D186841A;
	Mon, 26 Oct 2020 07:22:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C6E45C1A3;
	Mon, 26 Oct 2020 07:22:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6136B1832FC5;
	Mon, 26 Oct 2020 07:22:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NMp3L4006710 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 18:51:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4BD132157F4A; Fri, 23 Oct 2020 22:51:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45E0D2157F45
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 22:51:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B51608D632F
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 22:51:00 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-428-HTmRA676OCCIsQV30ML2pQ-1;
	Fri, 23 Oct 2020 18:50:54 -0400
X-MC-Unique: HTmRA676OCCIsQV30ML2pQ-1
Received: from [192.168.86.21] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9CF4220B4905;
	Fri, 23 Oct 2020 15:50:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9CF4220B4905
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
	<20200923192011.5293-5-tusharsu@linux.microsoft.com>
	<37aa4e6f5db6c53f4021f829ec09388d55d28208.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <87499f4e-d1d1-916c-24d2-0228bcacad26@linux.microsoft.com>
Date: Fri, 23 Oct 2020 15:50:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <37aa4e6f5db6c53f4021f829ec09388d55d28208.camel@linux.ibm.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09NMp3L4006710
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 4/6] IMA: add policy to measure critical
 data from kernel components
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIwLTEwLTIyIDI6MTUgcC5tLiwgTWltaSBab2hhciB3cm90ZToKPiBIaSBUdXNoYXIs
Cj4gCj4gVGhlIGFib3ZlIFN1YmplY3QgbGluZSBzaG91bGQgYmUgdHJ1bmNhdGVkIHRvICJJTUE6
IGFkZCBwb2xpY3kgdG8KPiBtZWFzdXJlIGNyaXRpY2FsIGRhdGEiLgo+IAo+IE9uIFdlZCwgMjAy
MC0wOS0yMyBhdCAxMjoyMCAtMDcwMCwgVHVzaGFyIFN1Z2FuZGhpIHdyb3RlOgo+PiBUaGVyZSB3
b3VsZCBiZSBzZXZlcmFsIGNhbmRpZGF0ZSBrZXJuZWwgY29tcG9uZW50cyBzdWl0YWJsZSBmb3Ig
SU1BCj4+IG1lYXN1cmVtZW50LiBOb3QgYWxsIG9mIHRoZW0gd291bGQgaGF2ZSBzdXBwb3J0IGZv
ciBJTUEgbWVhc3VyZW1lbnQuCj4gCj4gVGhpcyBpbnRybyBpcyBiZXNpZGVzIHRoZSBwb2ludC4g
IFRoZSBwYXRjaCBkZXNjcmlwdGlvbiBzaG91bGQgZGVzY3JpYmUKPiB3aGF0IGlzIG1lYW50IGJ5
ICJjcml0aWNhbCBkYXRhIi4KPiAKVGhhbmtzLiBJIHdpbGwgZml4IHRoZSBkZXNjcmlwdGlvbiB0
byBhZGRyZXNzIHRoaXMuCgo+PiBBbHNvLCBzeXN0ZW0gYWRtaW5pc3RyYXRvcnMgbWF5IG5vdCB3
YW50IHRvIG1lYXN1cmUgZGF0YSBmb3IgYWxsIG9mCj4+IHRoZW0sIGV2ZW4gd2hlbiB0aGV5IHN1
cHBvcnQgSU1BIG1lYXN1cmVtZW50Lgo+PiBBbiBJTUEgcG9saWN5IG9wdGlvbgo+PiBzcGVjaWZp
YyB0byB2YXJpb3VzIGtlcm5lbCBjb21wb25lbnRzIGlzIG5lZWRlZCB0byBtZWFzdXJlIHRoZWly
Cj4+IHJlc3BlY3RpdmUgY3JpdGljYWwgZGF0YS4KPj4KPj4gVGhpcyBwb2xpY3kgb3B0aW9uIG5l
ZWRzIHRvIGJlIGNvbnN0cmFpbmVkIHRvIG1lYXN1cmUgZGF0YSBmb3IKPj4gc3BlY2lmaWMga2Vy
bmVsIGNvbXBvbmVudHMgdGhhdCBhcmUgc3BlY2lmaWVkIGFzIGlucHV0IHZhbHVlcyB0byB0aGUK
Pj4gcG9saWN5IG9wdGlvbi4KPj4KPj4gQWRkIGEgbmV3IElNQSBwb2xpY3kgb3B0aW9uIC0gImRh
dGFfc291cmNlczo9IiB0byBhbGxvdyBtZWFzdXJpbmcKPj4gdmFyaW91cyBjcml0aWNhbCBrZXJu
ZWwgY29tcG9uZW50cy4gVGhpcyBwb2xpY3kgb3B0aW9uIHdvdWxkIGVuYWJsZSB0aGUKPj4gc3lz
dGVtIGFkbWluaXN0cmF0b3JzIHRvIGxpbWl0IHRoZSBtZWFzdXJlbWVudCB0byB0aGUgY29tcG9u
ZW50cwo+PiBsaXN0ZWQgaW4gImRhdGFfc291cmNlczo9IiwgaWYgdGhlIGNvbXBvbmVudHMgc3Vw
cG9ydCBJTUEgbWVhc3VyZW1lbnQuCj4+Cj4+IFRoZSBuZXcgcG9saWN5IG9wdGlvbiAiZGF0YV9z
b3VyY2VzOj0iIGlzIGRpZmZlcmVudCBmcm9tIHRoZSBleGlzdGluZwo+PiBwb2xpY3kgb3B0aW9u
ICJrZXlyaW5nczo9Ii4KPj4KPj4gSW4gY2FzZSBvZiAia2V5cmluZ3M6PSIsIGEgcG9saWN5IG1h
eSBtZWFzdXJlIGFsbCBrZXlyaW5ncyAod2hlbgo+PiAia2V5cmluZ3M6PSIgb3B0aW9uIGlzIG5v
dCBwcm92aWRlZCBmb3IgZnVuYyBLRVlfQ0hFQ0spLCBvciBtYXkKPj4gY29uc3RyYWluIHdoaWNo
IGtleXJpbmdzIG5lZWQgdG8gYmUgbWVhc3VyZWQgKHdoZW4gImtleXJpbmdzOj0iIG9wdGlvbgo+
PiBpcyBwcm92aWRlZCBmb3IgZnVuYyBLRVlfQ0hFQ0spLgo+Pgo+PiBCdXQgdW5saWtlICJrZXly
aW5nczo9IiwgdGhlIGVudHJpZXMgaW4gImRhdGFfc291cmNlczo9IiB3b3VsZCBoYXZlCj4+IGRp
ZmZlcmVudCBkYXRhIGZvcm1hdC4gRnVydGhlciwgdGhlIGNvbXBvbmVudHMgbGlzdGVkIGluCj4+
ICJkYXRhX3NvdXJjZXM6PSIgbmVlZCB0byBiZSBtb2RpZmllZCB0byBjYWxsIElNQSB0byBtZWFz
dXJlIHRoZWlyCj4+IGRhdGEuIFRoZXJlZm9yZSwgdW5saWtlICJrZXlyaW5nczo9IiwgSU1BIHNo
b3VsZG4ndCBtZWFzdXJlIGFsbCBvZiB0aGUKPj4gY29tcG9uZW50cyBieSBkZWZhdWx0LCB3aGVu
ICJkYXRhX3NvdXJjZXM6PSIgaXMgbm90IHNwZWNpZmllZC4gQmVjYXVzZQo+PiBtZWFzdXJpbmcg
bm9uLXZldHRlZCBjb21wb25lbnRzIGp1c3QgYnkgc3BlY2lmeWluZyB0aGVtIGFzIGEgcG9saWN5
Cj4+IG9wdGlvbiB2YWx1ZSBtYXkgaW1wYWN0IHRoZSBvdmVyYWxsIHJlbGlhYmlsaXR5IG9mIHRo
ZSBzeXN0ZW0uCj4+Cj4+IFRvIGFkZHJlc3MgdGhpcywgImRhdGFfc291cmNlczo9IiBzaG91bGQg
YmUgYSBtYW5kYXRvcnkgcG9saWN5IG9wdGlvbgo+PiBmb3IgZnVuYz1DUklUSUNBTF9EQVRBLiBU
aGlzIGZ1bmMgaXMgaW50cm9kdWNlZCBpbiB0aGUgNXRoIHBhdGNoIGluIHRoaXMKPj4gc2VyaWVz
KS4gQW5kIHRoZSBjb21waWxlLXRpbWUgdmV0dGluZyBmdW5jdGlvbmFsaXR5IGRlc2NyaWJlZCBh
Ym92ZSBpcwo+PiBpbnRyb2R1Y2VkIGluIHRoZSA2dGggcGF0Y2ggaW4gdGhpcyBzZXJpZXMuCj4+
Cj4+IFNpZ25lZC1vZmYtYnk6IFR1c2hhciBTdWdhbmRoaSA8dHVzaGFyc3VAbGludXgubWljcm9z
b2Z0LmNvbT4KPiAKPiBJIGRvbid0IHVuZGVyc3RhbmQgd2hhdCB5b3UgbWVhbiBieSAibm9uLXZl
dHRlZCIgY29tcG9uZW50cywgbm9yIGhvdwo+IG1lYXN1cmluZyBjcml0aWNhbCBkYXRhIG1heSBp
bXBhY3QgdGhlIG92ZXJhbGwgcmVsaWFiaWxpdHkgb2YgdGhlCj4gc3lzdGVtLgo+IApUdXNoYXI6
IEJlZm9yZSB3ZSBpbnRyb2R1Y2VkIHRoZSBtZWNoYW5pc20gdG8gY2hlY2sgc3VwcG9ydGVkCmRh
dGEtc291cmNlcyBhdCBjb21waWxlIHRpbWUgKHBhdGNoIDYvNiBvZiB0aGlzIHNlcmllcyksIHRo
ZXJlIHdhcyBhCmJhY2stYW5kLWZvcnRoIG9uIHdoZXRoZXIg4oCcZGF0YV9zb3VyY2VzOj3igJ0g
c2hvdWxkIGJlIGEgbWFuZGF0b3J5IHBvbGljeQpvcHRpb24sIG9yIG9wdGlvbmFsIGxpa2Ug4oCc
a2V5cmluZ3M6PeKAnS4gQW5kIHdlIGRlY2lkZWQgdG8gbWFrZSB0aGUK4oCcZGF0YV9zb3VyY2Vz
Oj3igJ0gbWFuZGF0b3J5LiBCdXQgbm93IHRoYXQgd2UgaGF2ZSB0aGUgY29tcGlsZSB0aW1lIGNo
ZWNrCihwYXRjaCA2LzYgb2YgdGhpcyBzZXJpZXMpLCB3ZSBjYW4gc3dpdGNoIHRvIG1ha2Ug4oCc
ZGF0YV9zb3VyY2VzOj3igJ0Kb3B0aW9uYWwgKHdpdGggdGhlIGRlZmF1bHQgdG8gYWxsb3cgbWVh
c3VyaW5nIGFsbCBjcml0aWNhbCBkYXRhIOKAkyBqdXN0IApsaWtlIHdoYXQgeW91IHN1Z2dlc3Rl
ZCBiZWxvdykuIEkgd2lsbCBtYWtlIHRoZSBjb2RlIGFuZCBkZXNjcmlwdGlvbiAKY2hhbmdlcyBh
Y2NvcmRpbmdseS4KPiBUaGUgc3lzdGVtIG93bmVyIG9yIGFkbWluc3RyYXRvciBkZWZpbmVzIHdo
YXQgdGhleSB3YW50IHRvIG1lYXN1cmUsCj4gaW5jbHVkaW5nICJjcml0aWNhbCBkYXRhIiwgYmFz
ZWQgb24gdGhlIHBvbGljeSBydWxlcy4gIFRoZXkgbWlnaHQKPiBkZWNpZGUgdGhhdCB0aGV5IHdh
bnQgdG8gY29uc3RyYWluIHdoaWNoICJjcml0aWNhbCBkYXRhIiBpcyBtZWFzdXJlZCBieQo+IHNw
ZWNpZnlpbmcgImRhdGFfc291cmNlczo9IiwgYnV0IHRoYXQgZGVjaXNpb24gaXMgdGhlaXIgcGVy
b2dhdGl2ZS4KPiBUaGUgZGVmYXVsdCBzaG91bGQgYWxsb3cgbWVhc3VyaW5nIGFsbCBjcml0aWNh
bCBkYXRhLgo+IApNYWtlcyBzZW5zZS4KVG8gc3VtbWFyaXplLCB3ZSB3aWxsIG1ha2UgdGhlIGRl
Y2lzaW9uIHdoaWNoIHNvdXJjZXMgdG8gbWVhc3VyZS0gYmFzZWQKb24gdGhlIHNvdXJjZXMgZGVm
aW5lZCBpbiB0aGUgYWxsb3cgbGlzdCAoaW4gcGF0Y2ggNikgYW5kIHRoZSBzb3VyY2VzCmRlZmlu
ZWQgaW4g4oCcZGF0YV9zb3VyY2VzOj3igJ0uIElmIOKAnGRhdGFfc291cmNlczo94oCdIGlzIG5v
dCBwcmVzZW50LCB3ZSB3aWxsCm1lYXN1cmUgYWxsIHNvdXJjZXMgZGVmaW5lZCBpbiB0aGUgYWxs
b3cgbGlzdC4KSG9wZSBteSB0aGlzIHVuZGVyc3RhbmRpbmcgaXMgY29ycmVjdCBiYXNlZCBvbiB5
b3VyIGZlZWRiYWNrLgoKPiAgIEEgc2ltcGxlIGV4YW1wbGUgb2YgImNyaXRpY2FsIGRhdGEiIGNv
dWxkIGJlIHNvbWUgaW4gbWVtb3J5IHN0cnVjdHVyZSwKPiBhbG9uZyB0aGUgbGluZXMgb2YgX19y
b19hZnRlcl9pbml0LCBvciBoYXNoIG9mIHRoZSBtZW1vcnkgc3RydWN0dXJlLgo+IE9uY2UgdGhl
IGRhdGEgc3RydWN0dXJlIGlzIGluaXRpYWxpemVkLCB0aGUgImNyaXRpY2FsIGRhdGEiIG1lYXN1
cmVtZW50Cj4gc2hvdWxkbid0IGNoYW5nZS4gICAgRnJvbSB0aGUgYXR0ZXN0YXRpb24gc2VydmVy
IHBlcnNwZWN0aXZlLCB0aGUgSU1BCj4gbWVhc3VyZW1lbnQgbGlzdCB3b3VsZCBjb250YWluIGEg
c2luZ2xlIHJlY29yZCB1bmxlc3MgdGhlIGNyaXRpY2FsIGRhdGEKPiBjaGFuZ2VzLiAgVGhlIGF0
dGVzdGF0aW9uIHNlcnZlciBkb2Vzbid0IG5lZWQgdG8ga25vdyBhbnl0aGluZyBhYm91dAo+IHRo
ZSBpbml0aWFsIHZhbHVlLCBqdXN0IHRoYXQgaXQgaGFzIGNoYW5nZWQgaW4gb3JkZXIgdG8gdHJp
Z2dlciBzb21lCj4gc29ydCBhbGVydC4KWWVzIGFncmVlZC4gQWZ0ZXIgdGhlIHVwZGF0ZXMgKGJh
c2VkIG9uIHlvdXIgZmVlZGJhY2spIEkgc3RhdGVkIGFib3ZlLAp0aGUgYmVoYXZpb3Igc2hvdWxk
IHJlbWFpbiBjb25zaXN0ZW50IHdpdGggd2hhdCB5b3UgZGVzY3JpYmVkIGhlcmUuCj4gCj4gdGhh
bmtzLAo+IAo+IE1pbWkKPiAKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


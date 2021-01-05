Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08BAC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 20:20:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EA62922D5A
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 20:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA62922D5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-BRXAZOE4PWSEjKJk3Gd8Dw-1; Tue, 05 Jan 2021 15:20:05 -0500
X-MC-Unique: BRXAZOE4PWSEjKJk3Gd8Dw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE763107ACE6;
	Tue,  5 Jan 2021 20:20:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B784627C20;
	Tue,  5 Jan 2021 20:20:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F51D4BB7B;
	Tue,  5 Jan 2021 20:20:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105KJwXK017895 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 15:19:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4CBB12026DE8; Tue,  5 Jan 2021 20:19:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 484962026DE4
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 20:19:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E88D7185A7BC
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 20:19:55 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-494-KmTEjz0BPXuthNNOxa44cg-1;
	Tue, 05 Jan 2021 15:19:53 -0500
X-MC-Unique: KmTEjz0BPXuthNNOxa44cg-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4EC8F20B7192;
	Tue,  5 Jan 2021 12:19:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4EC8F20B7192
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-4-tusharsu@linux.microsoft.com>
	<5ae72a76664ce7011d3041689efbfe1a2c67d44f.camel@linux.ibm.com>
	<9afab02b-4b02-485d-cca2-bdf8b1cf87e7@linux.microsoft.com>
	<3b5dd02fab216746409ccede82f51382539824d3.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <4907940a-ed56-3fa7-67bf-b75d238efacb@linux.microsoft.com>
Date: Tue, 5 Jan 2021 12:19:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3b5dd02fab216746409ccede82f51382539824d3.camel@linux.ibm.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 105KJwXK017895
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v9 3/8] IMA: define a hook to measure kernel
 integrity critical data
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIxLTAxLTA1IDEyOjE2IHAubS4sIE1pbWkgWm9oYXIgd3JvdGU6Cj4gT24gVHVlLCAy
MDIxLTAxLTA1IGF0IDEyOjAxIC0wODAwLCBUdXNoYXIgU3VnYW5kaGkgd3JvdGU6Cj4+Cj4+Pj4g
ZGF0YS4gSG93ZXZlciwgdmFyaW91cyBkYXRhIHN0cnVjdHVyZXMsIHBvbGljaWVzLCBhbmQgc3Rh
dGVzCj4+Pgo+Pj4gSGVyZSBhbmQgZXZlcnl3aGVyZSBlbHNlLCB0aGVyZSBhcmUgdHdvIGJsYW5r
cyBhZnRlciBhIHBlcmlvZC4KPj4+Cj4+IEkgY2hlY2tlZCB0aGlzIHBhdGNoIGZpbGUgaW4gbXVs
dGlwbGUgdGV4dCBlZGl0b3JzLCBidXQgY291bGRu4oCZdCBmaW5kCj4+IGFueSBpbnN0YW5jZSBv
ZiBwZXJpb2QgZm9sbG93ZWQgYnkgdHdvIHNwYWNlcy4gSSB3aWxsIGRvdWJsZSBjaGVjayBhZ2Fp
bgo+PiBhbGwgdGhlIHBhdGNoZXMgZm9yIG11bHRpcGxlIHNwYWNlcywgYW5kIHJlbW92ZSB0aGVt
IGlmIGFueS4KPiAKPiBUaGVyZSBzaG91bGQgYmUgdHdvIGJsYW5rcyBhZnRlciBhIHBlcmlvZCwg
bm90IG9uZSBibGFuay4KPiAKPiA8c25pcD4KPiAKPj4+PiArICoKPj4+PiArICogTWVhc3VyZSB0
aGUga2VybmVsIHN1YnN5c3RlbSBkYXRhLCBjcml0aWNhbCB0byB0aGUgaW50ZWdyaXR5IG9mIHRo
ZSBrZXJuZWwsCj4+Pj4gKyAqIGludG8gdGhlIElNQSBsb2cgYW5kIGV4dGVuZCB0aGUgQHBjci4K
Pj4+PiArICoKPj4+PiArICogVXNlIEBldmVudF9uYW1lIHRvIGRlc2NyaWJlIHRoZSBzdGF0ZS9i
dWZmZXIgZGF0YSBjaGFuZ2UuCj4+Pj4gKyAqIEV4YW1wbGVzIG9mIGNyaXRpY2FsIGRhdGEgKEBi
dWYpIGNvdWxkIGJlIHZhcmlvdXMgZGF0YSBzdHJ1Y3R1cmVzLAo+Pj4+ICsgKiBwb2xpY2llcywg
YW5kIHN0YXRlcyBzdG9yZWQgaW4ga2VybmVsIG1lbW9yeSB0aGF0IGNhbiBpbXBhY3QgdGhlIGlu
dGVncml0eQo+Pj4+ICsgKiBvZiB0aGUgc3lzdGVtLgo+Pj4+ICsgKgo+Pj4+ICsgKiBJZiBAbWVh
c3VyZV9idWZfaGFzaCBpcyBzZXQgdG8gdHJ1ZSAtIG1lYXN1cmUgaGFzaCBvZiB0aGUgYnVmZmVy
IGRhdGEsCj4+Pj4gKyAqIGVsc2UgbWVhc3VyZSB0aGUgYnVmZmVyIGRhdGEgaXRzZWxmLgo+Pj4+
ICsgKiBAbWVhc3VyZV9idWZfaGFzaCBjYW4gYmUgdXNlZCB0byBzYXZlIHNwYWNlLCBpZiB0aGUg
ZGF0YSBiZWluZyBtZWFzdXJlZAo+Pj4+ICsgKiBpcyB0b28gbGFyZ2UuCj4+Pj4gKyAqCj4+Pj4g
KyAqIFRoZSBkYXRhIChAYnVmKSBjYW4gb25seSBiZSBtZWFzdXJlZCwgbm90IGFwcHJhaXNlZC4K
Pj4+Cj4+PiBUaGUgIi8qKiIgaXMgdGhlIHN0YXJ0IG9mIGtlcm5lbC1kb2MuICBIYXZlIHlvdSBz
ZWVuIGFueXdoZXJlIGVsc2UgaW4KPj4gTXkgaW1wcmVzc2lvbiB3YXMgdGhlIGhvb2tzIGluIGlt
YV9tYWluLmMgZS5nLiBpbWFfZmlsZV9mcmVlKCkKPj4gaW1hX2ZpbGVfbW1hcCgpIHJlcXVpcmVk
IHRoZSBkb3VibGUtYXN0ZXJpc2sgKCIvKioiKSwgYW5kIGludGVybmFsCj4+IGZ1bmN0aW9ucyBs
aWtlIGltYV9yZHdyX3Zpb2xhdGlvbl9jaGVjaygpIHJlcXVpcmUgYSBzaW5nbGUtYXN0ZXJpc2sK
Pj4gKCIvKiIpCj4+Cj4+IGtlcm5lbC1kb2MucnN0IHN1Z2dlc3QgdGhlIGRvdWJsZS1hc3Rlcmlz
ayAoIi8qKiIpIGZvciBmdW5jdGlvbiBjb21tZW50Cj4+IGFzIHdlbGwuCj4+Cj4+IEZ1bmN0aW9u
IGRvY3VtZW50YXRpb24KPj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+Pgo+PiBUaGUgZ2VuZXJh
bCBmb3JtYXQgb2YgYSBmdW5jdGlvbiBhbmQgZnVuY3Rpb24tbGlrZSBtYWNybyBrZXJuZWwtZG9j
Cj4+IGNvbW1lbnQgaXM6Ogo+Pgo+PiAgICAgLyoqCj4+ICAgICAgKiBmdW5jdGlvbl9uYW1lKCkg
LSBCcmllZiBkZXNjcmlwdGlvbiBvZiBmdW5jdGlvbi4KPj4KPj4gUGxlYXNlIGxldCBtZSBrbm93
IGlmIHlvdSBzdGlsbCB3YW50IG1lIHRvIHJlbW92ZSB0aGUgZG91YmxlLWFzdGVyaXNrCj4+ICgi
LyoqIikgaGVyZS4KPiAKPiBZZXMsIG9mIGNvdXJzZSB0aGlzIG5lZWRzIHRvIGJlIGtlcm5lbC1k
b2MgYW5kIHJlcXVpcmVzICIvKioiCj4gClRoYW5rcyBmb3IgY29uZmlybWluZy4KPj4KPj4+IHRo
ZSBrZXJuZWwgdXNpbmcgdGhlIEA8dmFyaWFibGUgbmFtZT4gaW4gdGhlIGxvbmdlciBmdW5jdGlv
bgo+Pj4gZGVzY3JpcHRpb24/ICBIYXZlIHlvdSBzZWVuIHRoaXMgc3R5bGUgb2YgbG9uZ2VyICAg
ZnVuY3Rpb24KPj4+IGRlc2NyaXB0aW9uPyAgUmVmZXIgdG8gRG9jdW1lbnRhdGlvbi9kb2MtZ3Vp
ZGUva2VybmVsLWRvYy5yc3QgYW5kIG90aGVyCj4+PiBjb2RlIGZvciBleGFtcGxlcy4KPj4+Cj4+
IFRoYW5rcy4gSSB3aWxsIHJlbW92ZSB0aGUgcHJlZml4ICJAIiBmcm9tIDx2YXJpYWJsZSBuYW1l
PiBpbiB0aGUgbG9uZ2VyCj4+IGZ1bmN0aW9uIGRlc2NyaXB0aW9uLgo+IAo+IFJlbW92aW5nIHRo
ZSBAPHZhcmlhYmxlIG5hbWU+IGlzbid0IHN1ZmZpY2llbnQuICBQbGVhc2UgbG9vayBhdCBvdGhl
cgo+IGV4YW1wbGVzIG9mIGxvbmdlciBmdW5jdGlvbiBkZWZpbml0aW9ucyBiZWZvcmUgcmVwb3N0
aW5nLgo+IApZZXMuIEFncmVlZC4gSSB3aWxsIGdvIGFzIHBlciB0aGUgZ3VpZGFuY2UgaW4ga2Vy
bmVsLWRvYy5yc3QKClRoYW5rcyBhZ2FpbiwKVHVzaGFyCgoKPiB0aGFua3MsCj4gCj4gTWltaQo+
IAoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
d3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


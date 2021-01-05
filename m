Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03618C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 20:02:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 47CE422D5A
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 20:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47CE422D5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-bhNrTdH0Psmr3Lkahw7gng-1; Tue, 05 Jan 2021 15:01:59 -0500
X-MC-Unique: bhNrTdH0Psmr3Lkahw7gng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A345B107ACF6;
	Tue,  5 Jan 2021 20:01:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCC936F7E6;
	Tue,  5 Jan 2021 20:01:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D2DAB180954D;
	Tue,  5 Jan 2021 20:01:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105K1nCM016823 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 15:01:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 08B132166B2B; Tue,  5 Jan 2021 20:01:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02E892166B29
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 20:01:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE211811E84
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 20:01:46 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-125-YqOasD5hP9Ka14p38ko_cA-1;
	Tue, 05 Jan 2021 15:01:44 -0500
X-MC-Unique: YqOasD5hP9Ka14p38ko_cA-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9F2CD20B7192;
	Tue,  5 Jan 2021 12:01:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9F2CD20B7192
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-4-tusharsu@linux.microsoft.com>
	<5ae72a76664ce7011d3041689efbfe1a2c67d44f.camel@linux.ibm.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <9afab02b-4b02-485d-cca2-bdf8b1cf87e7@linux.microsoft.com>
Date: Tue, 5 Jan 2021 12:01:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5ae72a76664ce7011d3041689efbfe1a2c67d44f.camel@linux.ibm.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 105K1nCM016823
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIwLTEyLTI0IDU6MDQgYS5tLiwgTWltaSBab2hhciB3cm90ZToKPiBPbiBTYXQsIDIw
MjAtMTItMTIgYXQgMTA6MDIgLTA4MDAsIFR1c2hhciBTdWdhbmRoaSB3cm90ZToKPj4gSU1BIHBy
b3ZpZGVzIGNhcGFiaWxpdGllcyB0byBtZWFzdXJlIGZpbGUgZGF0YSwgYW5kIGluLW1lbW9yeSBi
dWZmZXIKPiAKPiBObyBuZWVkIGZvciB0aGUgY29tbWEgaGVyZS4KPiAKPiBVcCB0byB0aGlzIHBh
dGNoIHNldCwgYWxsIHRoZSBwYXRjaGVzIHJlZmVyIHRvICJidWZmZXIgZGF0YSIsIG5vdCAiaW4t
Cj4gbWVtb3J5IGJ1ZmZlciBkYXRhIi4gIFRoaXMgcGF0Y2ggaW50cm9kdWNlcyB0aGUgY29uY2Vw
dCBvZiBtZWFzdXJpbmcKPiAiaW4tbWVtb3J5IGJ1ZmZlciBkYXRhIi4gICBQbGVhc2UgcmVtb3Zl
ICJpbi1tZW1vcnkiIGFib3ZlLgo+IApXaWxsIHVwZGF0ZSB0aGUgZGVzY3JpcHRpb24gYWNjb3Jk
aW5nbHkuCj4+IGRhdGEuIEhvd2V2ZXIsIHZhcmlvdXMgZGF0YSBzdHJ1Y3R1cmVzLCBwb2xpY2ll
cywgYW5kIHN0YXRlcwo+IAo+IEhlcmUgYW5kIGV2ZXJ5d2hlcmUgZWxzZSwgdGhlcmUgYXJlIHR3
byBibGFua3MgYWZ0ZXIgYSBwZXJpb2QuCj4gCkkgY2hlY2tlZCB0aGlzIHBhdGNoIGZpbGUgaW4g
bXVsdGlwbGUgdGV4dCBlZGl0b3JzLCBidXQgY291bGRu4oCZdCBmaW5kCmFueSBpbnN0YW5jZSBv
ZiBwZXJpb2QgZm9sbG93ZWQgYnkgdHdvIHNwYWNlcy4gSSB3aWxsIGRvdWJsZSBjaGVjayBhZ2Fp
biAKYWxsIHRoZSBwYXRjaGVzIGZvciBtdWx0aXBsZSBzcGFjZXMsIGFuZCByZW1vdmUgdGhlbSBp
ZiBhbnkuCgo+PiBzdG9yZWQgaW4ga2VybmVsIG1lbW9yeSBhbHNvIGltcGFjdCB0aGUgaW50ZWdy
aXR5IG9mIHRoZSBzeXN0ZW0uCj4+IFNldmVyYWwga2VybmVsIHN1YnN5c3RlbXMgY29udGFpbiBz
dWNoIGludGVncml0eSBjcml0aWNhbCBkYXRhLiBUaGVzZQo+PiBrZXJuZWwgc3Vic3lzdGVtcyBo
ZWxwIHByb3RlY3QgdGhlIGludGVncml0eSBvZiBhIGRldmljZS4gQ3VycmVudGx5LAo+IAo+IF5p
bnRlZ3JpdHkgb2YgdGhlIHN5c3RlbS4KPiAKV2lsbCBkby4KPj4gSU1BIGRvZXMgbm90IHByb3Zp
ZGUgYSBnZW5lcmljIGZ1bmN0aW9uIGZvciBrZXJuZWwgc3Vic3lzdGVtcyB0byBtZWFzdXJlCj4+
IHRoZWlyIGludGVncml0eSBjcml0aWNhbCBkYXRhLgo+IAo+IFRoZSBlbXBoYXNpcyBzaG91bGQg
bm90IGJlIG9uICJrZXJuZWwgc3Vic3lzdGVtcyIuICBTaW1wbGlmeSB0byAiZm9yCj4gbWVhc3Vy
aW5nIGtlcm5lbCBpbnRlZ3JpdHkgY3JpdGljYWwgZGF0YSIuCj4gCldpbGwgZG8uCj4+ICAgCj4+
IERlZmluZSBhIG5ldyBJTUEgaG9vayAtIGltYV9tZWFzdXJlX2NyaXRpY2FsX2RhdGEgdG8gbWVh
c3VyZSBrZXJuZWwKPj4gaW50ZWdyaXR5IGNyaXRpY2FsIGRhdGEuCj4gCj4gRWl0aGVyICJpbWFf
bWVhc3VyZV9jcml0aWNhbF9kYXRhIiBpcyBiZXR3ZWVuIGh5cGhlbnMgb3Igd2l0aG91dCBhbnkK
PiBoeXBoZW5zLiAgSWYgbm90IGh5cGhlbmF0ZWQsIHRoZW4geW91IGNvdWxkIHNheSAibmFtZWQK
PiBpbWFfbWVhc3VyZV9jcml0aWNhbF9kYXRhIiwgYnV0ICJuYW1lZCIgaXNuJ3QgbmVjZXNzYXJ5
LiAgT3IgcmV2ZXJzZSAiYQo+IG5ldyBJTUEgaG9vayIgYW5kICJpbWFfbWVhc3VyZV9jcml0aWNh
bF9kYXRhIiwgYWRkaW5nIGNvbW1hJ3MgbGlrZToKPiBEZWZpbmUgaW1hX21lYXN1cmVfY3JpdGlj
YWxfZGF0YSwgYSBuZXcgSU1BIGhvb2ssIHRvIC4uLgo+IAo+IEFueSBvZiB0aGUgYWJvdmUgb3B0
aW9ucyB3b3JrLCBqdXN0IG5vdCBhIHNpbmdsZSBoeXBoZW4uCj4gClRoYW5rcyBmb3IgdGhlIHN1
Z2dlc3Rpb24uCkkgd2lsbCB1c2Ug4oCcRGVmaW5lIGltYV9tZWFzdXJlX2NyaXRpY2FsX2RhdGEs
IGEgbmV3IElNQSBob29rLCB0byAuLi7igJ0KCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFR1c2hhciBT
dWdhbmRoaSA8dHVzaGFyc3VAbGludXgubWljcm9zb2Z0LmNvbT4KPj4gUmV2aWV3ZWQtYnk6IFR5
bGVyIEhpY2tzIDx0eWhpY2tzQGxpbnV4Lm1pY3Jvc29mdC5jb20+Cj4+IC0tLQo+IAo+IDxzbmlw
Pgo+IAo+PiBkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5jIGIv
c2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5jCj4+IGluZGV4IDBmODQwOWQ3NzYwMi4u
ZGZmNGJjZTRmYjA5IDEwMDY0NAo+PiAtLS0gYS9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9t
YWluLmMKPj4gKysrIGIvc2VjdXJpdHkvaW50ZWdyaXR5L2ltYS9pbWFfbWFpbi5jCj4+IEBAIC05
MjIsNiArOTIyLDQwIEBAIHZvaWQgaW1hX2tleGVjX2NtZGxpbmUoaW50IGtlcm5lbF9mZCwgY29u
c3Qgdm9pZCAqYnVmLCBpbnQgc2l6ZSkKPj4gICAJZmRwdXQoZik7Cj4+ICAgfQo+PiAgIAo+PiAr
LyoqCj4+ICsgKiBpbWFfbWVhc3VyZV9jcml0aWNhbF9kYXRhIC0gbWVhc3VyZSBrZXJuZWwgaW50
ZWdyaXR5IGNyaXRpY2FsIGRhdGEKPj4gKyAqIEBldmVudF9uYW1lOiBldmVudCBuYW1lIHRvIGJl
IHVzZWQgZm9yIHRoZSBidWZmZXIgZW50cnkKPiAKPiBXaHkgZnV0dXJlIHRlbnNlPyAgIApJIHNp
bXBseSB1c2VkIHRoZSBkZXNjcmlwdGlvbiBmcm9tIHBfYl9tKCkKKiBAZXZlbnRuYW1lOiBldmVu
dCBuYW1lIHRvIGJlIHVzZWQgZm9yIHRoZSBidWZmZXIgZW50cnkuCgpCeSAiYnVmZmVyIGVudHJ5
IiBkbyB5b3UgbWVhbiBhIHJlY29yZCBpbiB0aGUgSU1BCj4gbWVhc3VyZW1lbnQgbGlzdD8KPiAK
WWVzLCBhIHJlY29yZCBpbiB0aGUgSU1BIG1lYXN1cmVtZW50IGxpc3QuCldpbGwgcmVtb3ZlIHRo
ZSBmdXR1cmUgdGVuc2UgYW5kIHJld29yZCBpdCB0byBzb21ldGhpbmcgbGlrZToKCiAgKiBAZXZl
bnRfbmFtZTogZXZlbnQgbmFtZSBmb3IgdGhlIGJ1ZmZlciBtZWFzdXJlbWVudCBlbnRyeQotb3It
CiAgKiBAZXZlbnRfbmFtZTogZXZlbnQgbmFtZSBmb3IgdGhlIHJlY29yZCBpbiB0aGUgSU1BIG1l
YXN1cmVtZW50IGxpc3QKCj4+ICsgKiBAYnVmOiBwb2ludGVyIHRvIGJ1ZmZlciBjb250YWluaW5n
IGRhdGEgdG8gbWVhc3VyZQo+IAo+IF5wb2ludGVyIHRvIGJ1ZmZlciBkYXRhCj4gCndpbGwgZG8u
Cj4+ICsgKiBAYnVmX2xlbjogbGVuZ3RoIG9mIGJ1ZmZlcihpbiBieXRlcykKPiAKPiBebGVuZ3Ro
IG9mIGJ1ZmZlciBkYXRhIChpbiBieXRlcykKPiAKd2lsbCBkby4KPj4gKyAqIEBtZWFzdXJlX2J1
Zl9oYXNoOiBtZWFzdXJlIGJ1ZmZlciBoYXNoCj4gCj4gQXMgcmVxdWVzdGVkIGluIDIvOCwgcGxl
YXNlIGFiYnJldmlhdGUgdGhlIGJvb2xlYW4gbmFtZSB0byAiaGFzaCIuCj4gUmVmZXIgdG8gc2Vj
dGlvbiAiNCkgTmFtaW5nIiBpbiBEb2N1bWVudGF0aW9uL3Byb2Nlc3MvY29kaW5nLXN0eWxlLnJz
dAo+IGZvciB2YXJpYWJsZSBuYW1pbmcgY29udmVudGlvbnMuCj4gCj4gXkBoYXNoOiBtZWFzdXJl
IGJ1ZmZlciBkYXRhIGhhc2gKPiAKU291bmRzIGdvb2QuIFdpbGwgZG8uCj4+ICsgKgo+PiArICog
TWVhc3VyZSB0aGUga2VybmVsIHN1YnN5c3RlbSBkYXRhLCBjcml0aWNhbCB0byB0aGUgaW50ZWdy
aXR5IG9mIHRoZSBrZXJuZWwsCj4+ICsgKiBpbnRvIHRoZSBJTUEgbG9nIGFuZCBleHRlbmQgdGhl
IEBwY3IuCj4+ICsgKgo+PiArICogVXNlIEBldmVudF9uYW1lIHRvIGRlc2NyaWJlIHRoZSBzdGF0
ZS9idWZmZXIgZGF0YSBjaGFuZ2UuCj4+ICsgKiBFeGFtcGxlcyBvZiBjcml0aWNhbCBkYXRhIChA
YnVmKSBjb3VsZCBiZSB2YXJpb3VzIGRhdGEgc3RydWN0dXJlcywKPj4gKyAqIHBvbGljaWVzLCBh
bmQgc3RhdGVzIHN0b3JlZCBpbiBrZXJuZWwgbWVtb3J5IHRoYXQgY2FuIGltcGFjdCB0aGUgaW50
ZWdyaXR5Cj4+ICsgKiBvZiB0aGUgc3lzdGVtLgo+PiArICoKPj4gKyAqIElmIEBtZWFzdXJlX2J1
Zl9oYXNoIGlzIHNldCB0byB0cnVlIC0gbWVhc3VyZSBoYXNoIG9mIHRoZSBidWZmZXIgZGF0YSwK
Pj4gKyAqIGVsc2UgbWVhc3VyZSB0aGUgYnVmZmVyIGRhdGEgaXRzZWxmLgo+PiArICogQG1lYXN1
cmVfYnVmX2hhc2ggY2FuIGJlIHVzZWQgdG8gc2F2ZSBzcGFjZSwgaWYgdGhlIGRhdGEgYmVpbmcg
bWVhc3VyZWQKPj4gKyAqIGlzIHRvbyBsYXJnZS4KPj4gKyAqCj4+ICsgKiBUaGUgZGF0YSAoQGJ1
ZikgY2FuIG9ubHkgYmUgbWVhc3VyZWQsIG5vdCBhcHByYWlzZWQuCj4gCj4gVGhlICIvKioiIGlz
IHRoZSBzdGFydCBvZiBrZXJuZWwtZG9jLiAgSGF2ZSB5b3Ugc2VlbiBhbnl3aGVyZSBlbHNlIGlu
Ck15IGltcHJlc3Npb24gd2FzIHRoZSBob29rcyBpbiBpbWFfbWFpbi5jIGUuZy4gaW1hX2ZpbGVf
ZnJlZSgpCmltYV9maWxlX21tYXAoKSByZXF1aXJlZCB0aGUgZG91YmxlLWFzdGVyaXNrICgiLyoq
IiksIGFuZCBpbnRlcm5hbApmdW5jdGlvbnMgbGlrZSBpbWFfcmR3cl92aW9sYXRpb25fY2hlY2so
KSByZXF1aXJlIGEgc2luZ2xlLWFzdGVyaXNrCigiLyoiKQoKa2VybmVsLWRvYy5yc3Qgc3VnZ2Vz
dCB0aGUgZG91YmxlLWFzdGVyaXNrICgiLyoqIikgZm9yIGZ1bmN0aW9uIGNvbW1lbnQKYXMgd2Vs
bC4KCkZ1bmN0aW9uIGRvY3VtZW50YXRpb24KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKVGhlIGdl
bmVyYWwgZm9ybWF0IG9mIGEgZnVuY3Rpb24gYW5kIGZ1bmN0aW9uLWxpa2UgbWFjcm8ga2VybmVs
LWRvYyAKY29tbWVudCBpczo6CgogICAvKioKICAgICogZnVuY3Rpb25fbmFtZSgpIC0gQnJpZWYg
ZGVzY3JpcHRpb24gb2YgZnVuY3Rpb24uCgpQbGVhc2UgbGV0IG1lIGtub3cgaWYgeW91IHN0aWxs
IHdhbnQgbWUgdG8gcmVtb3ZlIHRoZSBkb3VibGUtYXN0ZXJpc2sKKCIvKioiKSBoZXJlLgoKPiB0
aGUga2VybmVsIHVzaW5nIHRoZSBAPHZhcmlhYmxlIG5hbWU+IGluIHRoZSBsb25nZXIgZnVuY3Rp
b24KPiBkZXNjcmlwdGlvbj8gIEhhdmUgeW91IHNlZW4gdGhpcyBzdHlsZSBvZiBsb25nZXIgICBm
dW5jdGlvbgo+IGRlc2NyaXB0aW9uPyAgUmVmZXIgdG8gRG9jdW1lbnRhdGlvbi9kb2MtZ3VpZGUv
a2VybmVsLWRvYy5yc3QgYW5kIG90aGVyCj4gY29kZSBmb3IgZXhhbXBsZXMuCj4gClRoYW5rcy4g
SSB3aWxsIHJlbW92ZSB0aGUgcHJlZml4ICJAIiBmcm9tIDx2YXJpYWJsZSBuYW1lPiBpbiB0aGUg
bG9uZ2VyIApmdW5jdGlvbiBkZXNjcmlwdGlvbi4KCj4+ICsgKi8KPj4gK3ZvaWQgaW1hX21lYXN1
cmVfY3JpdGljYWxfZGF0YShjb25zdCBjaGFyICpldmVudF9uYW1lLAo+PiArCQkJICAgICAgIGNv
bnN0IHZvaWQgKmJ1ZiwgaW50IGJ1Zl9sZW4sCj4gCj4gQXMgImJ1Zl9sZW4iIHNob3VsZCBhbHdh
eXMgYmUgPj0gMCwgaXQgc2hvdWxkIG5vdCBiZSBkZWZpbmVkIGFzIGEKPiBzaWduZWQgdmFyaWFi
bGUuCj4gCkdvb2QgcG9pbnQuIEkgd2lsbCBzd2l0Y2ggdG8gZWl0aGVyIHNpemVfdCBvciB1bnNp
Z25lZCBpbnQuCgo+PiArCQkJICAgICAgIGJvb2wgbWVhc3VyZV9idWZfaGFzaCkKPj4gK3sKPj4g
KwlpZiAoIWV2ZW50X25hbWUgfHwgIWJ1ZiB8fCAhYnVmX2xlbikKPj4gKwkJcmV0dXJuOwo+PiAr
Cj4+ICsJcHJvY2Vzc19idWZmZXJfbWVhc3VyZW1lbnQoTlVMTCwgYnVmLCBidWZfbGVuLCBldmVu
dF9uYW1lLAo+PiArCQkJCSAgIENSSVRJQ0FMX0RBVEEsIDAsIE5VTEwsCj4+ICsJCQkJICAgbWVh
c3VyZV9idWZfaGFzaCk7Cj4gCj4gXmhhc2gKPiAKV2lsbCBkby4KPiB0aGFua3MsCj4gCj4gTWlt
aQo+IApUaGFua3MsClR1c2hhcgo+PiArfQo+PiArCj4+ICAgc3RhdGljIGludCBfX2luaXQgaW5p
dF9pbWEodm9pZCkKPj4gICB7Cj4+ICAgCWludCBlcnJvcjsKPiAKCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=


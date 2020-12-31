Return-Path: <SRS0=SCxI=GD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D715C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 31 Dec 2020 08:29:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF73322262
	for <dm-devel@archiver.kernel.org>; Thu, 31 Dec 2020 08:29:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF73322262
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-GmDNPq16PlejKXMrLSdSBw-1; Thu, 31 Dec 2020 03:29:24 -0500
X-MC-Unique: GmDNPq16PlejKXMrLSdSBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A81118C8C0F;
	Thu, 31 Dec 2020 08:29:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18B635C234;
	Thu, 31 Dec 2020 08:29:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86F754BB7B;
	Thu, 31 Dec 2020 08:29:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BV8TA9O009348 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 31 Dec 2020 03:29:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BDB2F5D227; Thu, 31 Dec 2020 08:29:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7AA46D69D
	for <dm-devel@redhat.com>; Thu, 31 Dec 2020 08:29:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED0B9858280
	for <dm-devel@redhat.com>; Thu, 31 Dec 2020 08:29:06 +0000 (UTC)
Received: from synology.com (mail.synology.com [211.23.38.101]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-319-lhBh6INjMAyHO-rEc6lh9Q-1;
	Thu, 31 Dec 2020 03:29:01 -0500
X-MC-Unique: lhBh6INjMAyHO-rEc6lh9Q-1
Received: from [10.17.32.105] (unknown [10.17.32.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by synology.com (Postfix) with ESMTPSA id 057D3CE7803D;
	Thu, 31 Dec 2020 16:28:56 +0800 (CST)
To: Mike Snitzer <snitzer@redhat.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
	<20201230233429.GA6456@redhat.com>
From: Danny Shih <dannyshih@synology.com>
Message-ID: <a318fd04-4f8c-2aec-2a58-18f456c98ef0@synology.com>
Date: Thu, 31 Dec 2020 16:28:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
	Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201230233429.GA6456@redhat.com>
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BV8TA9O009348
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/4] Fix order when split bio and send
 remaining back to itself
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

Ck1pa2UgU25pdHplciB3cml0ZXM6Cj4+IHN1Ym1pdF9iaW9fbm9hY2N0X2FkZF9oZWFkKCkgaW4g
YmxvY2sgZGV2aWNlIGxheWVyIHdoZW4gd2Ugd2FudCB0bwo+PiBzcGxpdCBiaW8gYW5kIHNlbmQg
cmVtYWluaW5nIGJhY2sgdG8gaXRzZWxmLgo+IE9yZGVyaW5nIGFzaWRlLCB5b3UgY2Fubm90IHNw
bGl0IG1vcmUgdGhhbiBvbmNlLiAgU28geW91ciBwcm9wb3NlZCBmaXgKPiB0byBpbnNlcnQgYXQg
aGVhZCBpc24ndCB2YWxpZCBiZWNhdXNlIHlvdSdyZSBzdGlsbCBpbXBsaWNpdGx5IGFsbG9jYXRp
bmcKPiBtb3JlIHRoYW4gb25lIGJpbyBmcm9tIHRoZSBiaW9zZXQgd2hpY2ggY291bGQgY2F1c2Ug
ZGVhZGxvY2sgaW4gYSBsb3cKPiBtZW1vcnkgc2l0dWF0aW9uLgo+Cj4gSSBoYWQgdG8gZGVhbCB3
aXRoIGEgY29tcGFyYWJsZSBpc3N1ZSB3aXRoIERNIGNvcmUgbm90IHRvbyBsb25nIGFnbywgc2Vl
Cj4gdGhpcyBjb21taXQ6Cj4KPiBjb21taXQgZWUxZGZhZDUzMjVmZjFjZmIyMjM5ZTU2NGNkNDEx
YjNiZmU4NjY3YQo+IEF1dGhvcjogTWlrZSBTbml0emVyIDxzbml0emVyQHJlZGhhdC5jb20+Cj4g
RGF0ZTogICBNb24gU2VwIDE0IDEzOjA0OjE5IDIwMjAgLTA0MDAKPgo+ICAgICAgZG06IGZpeCBi
aW8gc3BsaXR0aW5nIGFuZCBpdHMgYmlvIGNvbXBsZXRpb24gb3JkZXIgZm9yIHJlZ3VsYXIgSU8K
Pgo+ICAgICAgZG1fcXVldWVfc3BsaXQoKSBpcyByZW1vdmVkIGJlY2F1c2UgX19zcGxpdF9hbmRf
cHJvY2Vzc19iaW8oKSBfbXVzdF8KPiAgICAgIGhhbmRsZSBzcGxpdHRpbmcgYmlvcyB0byBlbnN1
cmUgcHJvcGVyIGJpbyBzdWJtaXNzaW9uIGFuZCBjb21wbGV0aW9uCj4gICAgICBvcmRlcmluZyBh
cyBhIGJpbyBpcyBzcGxpdC4KPgo+ICAgICAgT3RoZXJ3aXNlLCBtdWx0aXBsZSByZWN1cnNpdmUg
Y2FsbHMgdG8gLT5zdWJtaXRfYmlvIHdpbGwgY2F1c2UgbXVsdGlwbGUKPiAgICAgIHNwbGl0IGJp
b3MgdG8gYmUgYWxsb2NhdGVkIGZyb20gdGhlIHNhbWUgLT5iaW9fc3BsaXQgbWVtcG9vbCBhdCB0
aGUgc2FtZQo+ICAgICAgdGltZS4gVGhpcyB3b3VsZCByZXN1bHQgaW4gZGVhZGxvY2sgaW4gbG93
IG1lbW9yeSBjb25kaXRpb25zIGJlY2F1c2Ugbm8KPiAgICAgIHByb2dyZXNzIGNvdWxkIGJlIG1h
ZGUgKG9ubHkgb25lIGJpbyBpcyBhdmFpbGFibGUgaW4gLT5iaW9fc3BsaXQKPiAgICAgIG1lbXBv
b2wpLgo+Cj4gICAgICBUaGlzIGZpeCBoYXMgYmVlbiB2ZXJpZmllZCB0byBzdGlsbCBmaXggdGhl
IGxvc3Mgb2YgcGVyZm9ybWFuY2UsIGR1ZQo+ICAgICAgdG8gZXhjZXNzIHNwbGl0dGluZywgdGhh
dCBjb21taXQgMTIwYzkyNTdmNWYxIHByb3ZpZGVkLgo+Cj4gICAgICBGaXhlczogMTIwYzkyNTdm
NWYxICgiUmV2ZXJ0ICJkbTogYWx3YXlzIGNhbGwgYmxrX3F1ZXVlX3NwbGl0KCkgaW4gZG1fcHJv
Y2Vzc19iaW8oKSIiKQo+ICAgICAgQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyA1LjArLCBy
ZXF1aXJlcyBjdXN0b20gYmFja3BvcnQgZHVlIHRvIDUuOSBjaGFuZ2VzCj4gICAgICBSZXBvcnRl
ZC1ieTogTWluZyBMZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+Cj4gICAgICBTaWduZWQtb2ZmLWJ5
OiBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAcmVkaGF0LmNvbT4KPgo+IEJhc2ljYWxseSB5b3UgY2Fu
bm90IHNwbGl0IHRoZSBzYW1lIGJpbyBtb3JlIHRoYW4gb25jZSB3aXRob3V0Cj4gcmVjdXJzaW5n
LiAgWW91ciBlbGFib3JhdGUgZG9jdW1lbnRhdGlvbiBzaG93cyB0aGluZ3MgZ29pbmcgd3Jvbmcg
cXVpdGUKPiBlYXJseSBpbiBzdGVwIDMuICBUaGF0IGFkZGl0aW9uYWwgc3BsaXQgYW5kIHJlY3Vy
c2luZyBiYWNrIHRvIE1ECj4gc2hvdWxkbid0IGhhcHBlbiBiZWZvcmUgdGhlIGZpcnN0IGJpbyBz
cGxpdCBjb21wbGV0ZXMuCj4KPiBTZWVtcyB0aGUgcHJvcGVyIGZpeCBpcyB0byBkaXNhbGxvdyBt
YXhfc2VjdG9yc19rYiB0byBiZSBpbXBvc2VkLCB2aWEKPiBibGtfcXVldWVfc3BsaXQoKSwgaWYg
TUQgaGFzIGZ1cnRoZXIgc3BsaXR0aW5nIGNvbnN0cmFpbnRzLCB2aWEKPiBjaHVua19zZWN0b3Jz
LCB0aGF0IG5lZ2F0ZSBtYXhfc2VjdG9yc19rYiBhbnl3YXkuCj4KPiBNaWtlCgoKSGkgTWlrZSwK
CkkgdGhpbmsgeW91J3JlIHJpZ2h0IHRoYXQgYSBkcml2ZXIgc2hvdWxkIG5vdCBzcGxpdCB0aGUg
c2FtZSBiaW8gbW9yZQp0aGFuIG9uY2Ugd2l0aG91dCByZWN1cnNpbmcgd2hlbiB1c2luZyB0aGUg
c2FtZSBtZW1wb29sLgoKSWYgYSBkcml2ZXIgb25seSBzcGxpdCBiaW8gb25jZSwgdGhlIG91dC1v
Zi1vcmRlciBpc3N1ZSBubyBsb25nZXIgZXhpc3RzLgooVGhlcmVmb3JlLCB0aGlzIHByb2JsZW0g
d29uJ3Qgb2NjdXIgb24gRE0gZGV2aWNlLikKCkJ1dCB0aGUgTUQgZGV2aWNlcyBhcmUgdXNpbmcg
dGhlaXIgcHJpdmF0ZSBiaW9zZXQgKG1kZGV2LT5iaW9fc2V0Cm9yIGNvbmYtPmJpb19zcGxpdCkg
Zm9yIHNwbGl0dGluZyBieSB0aGVtc2VsdmVzIHRoYXQgYXJlIG5vdCB0aGUgc2FtZQpiaW9zZXQg
dXNlZCBpbiBibGtfcXVldWVfc3BsaXQoKSAoaS5lLiBxLT5iaW9fc3BsaXQpLiBUaGUgZGVhZGxv
Y2sKeW91IGhhdmUgbWVudGlvbmVkIG1pZ2h0IG5vdCBoYXBwZW4gdG8gdGhlbS4KCkkgdGhpbmsg
dGhlcmUgYXJlIHR3byBzb2x1dGlvbnM6CgoxLiBJbiBjYXNlIE1EIGRldmljZXMgd2FudCB0byBj
aGFuZ2UgdG8gdXNlIHEtPmJpb19zcGxpdCBzb21lZGF5CiDCoMKgIHdpdGhvdXQgdGhpcyBvdXQt
b2Ytb3JkZXIgaXNzdWUsIG1ha2UgdGhlbSBkbyBzcGxpdCBvbmNlIHdvdWxkIGJlCiDCoMKgIGEg
c29sdXRpb24uCgoyLiBJZiBNRCBkZXZpY2VzIHNob3VsZCBzcGxpdCB0aGUgYmlvIHR3aWNlLCBz
byB3ZSBjYW4gc2VwYXJhdGVseSBoYW5kbGUKIMKgwqAgbGltaXRzIGluIGJsa19xdWV1ZV9zcGxp
dCgpIGFuZCBlYWNoIHJhaWQgbGV2ZWwncyAocmFpZDAsIHJhaWQ1LCAKcmFpZDEsIC4uLikuCiDC
oMKgIEkgd2lsbCB0cnkgdG8gZmluZCBhbm90aGVyIHNvbHV0aW9uIGluIHRoaXMgY2FzZS4KCiDC
oMKgIE15IHByb3Bvc2FsIGlzIG5vdCBzdWl0YWJsZSBhZnRlciBJIHJlY29uc2lkZXIgdGhlIHBy
b2JsZW06CgogwqDCoCBJZiBhIGJpbyBpcyBzcGxpdCBpbnRvIEEgcGFydCBhbmQgQiBwYXJ0LgoK
IMKgwqAgKy0tLS0tLXwtLS0tLS0rCiDCoMKgIHzCoMKgIEHCoCB8wqDCoCBCwqAgfAogwqDCoCAr
LS0tLS0tfC0tLS0tLSsKCiDCoMKgIEkgdGhpbmsgYSBkcml2ZXIgc2hvdWxkIG1ha2Ugc3VyZSBB
IHBhcnQgaXMgYWx3YXlzIGhhbmRsZWQgYmVmb3JlIEIgCnBhcnQuCiDCoMKgIEluc2VydGluZyBi
aW8gYXQgaGVhZCBvZiBjdXJyZW50LT5iaW9fbGlzdCBhbmQgc3VibWl0dGluZyBiaW8gaW4gdGhl
IApzYW1lCiDCoMKgIHRpbWUgd2hpbGUgaGFuZGxpbmcgQSBwYXJ0IGNvdWxkIG1ha2UgYmlvcyBn
ZW5lcmF0ZWQgZnJvbSBBIHBhcnQgYmUKIMKgwqAgaGFuZGxlZCBiZWZvcmUgQiBwYXJ0LiBUaGlz
IGJyb2tlIHRoZSBvcmRlciBvZiB0aG9zZSBiaW9zIHRoYXQgZ2VuZXJhdGVkCiDCoMKgIGZvcm0g
QSBwYXJ0LgoKIMKgwqAgKE1heWJlIEkgc2hvdWxkIGZpbmQgYSB3YXkgdG8gbWFrZSBCIHBhcnQg
YXQgdGhlIGhlYWQgb2YgCmJpb19saXN0X29uX3N0YWNrWzFdCiDCoMKgIHdoaWxlIHN1Ym1pdHRp
bmcgaXQuLi4pCgpUaGFua3MgZm9yIHlvdXIgY29tbWVudHMuCkkgd2lsbCB0cnkgdG8gZmlndXJl
IG91dCBhIGJldHRlciB3YXkgdG8gZml4IGl0IGluIHRoZSBuZXh0IHZlcnNpb24uCgpCZXN0IHJl
Z2FyZHMsCkRhbm55IFNoaWgKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


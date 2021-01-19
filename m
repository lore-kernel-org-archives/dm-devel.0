Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1648C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 21:58:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5585222E01
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 21:58:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5585222E01
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-MAlio9h7Mi6c7YkaUew-zg-1; Tue, 19 Jan 2021 16:58:00 -0500
X-MC-Unique: MAlio9h7Mi6c7YkaUew-zg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48FF3107ACE3;
	Tue, 19 Jan 2021 21:57:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A55C60C9C;
	Tue, 19 Jan 2021 21:57:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCBA34BB7B;
	Tue, 19 Jan 2021 21:57:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10JLvn3f005904 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 16:57:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4D633110E999; Tue, 19 Jan 2021 21:57:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48A33110E99C
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 21:57:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7777800889
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 21:57:46 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-477-OE80G2IsNQa4hzVcgAQj7A-1;
	Tue, 19 Jan 2021 16:57:42 -0500
X-MC-Unique: OE80G2IsNQa4hzVcgAQj7A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E8C9CAB9F;
	Tue, 19 Jan 2021 21:57:40 +0000 (UTC)
Message-ID: <f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Tue, 19 Jan 2021 22:57:39 +0100
In-Reply-To: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
References: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10JLvn3f005904
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>, lihaotian9@huawei.com
Subject: Re: [dm-devel] [QUESTION]: multipath device with wrong path lead to
 metadata err
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCAyMDIxLTAxLTE4IGF0IDE5OjA4ICswODAwLCBsaXhpYW9rZW5nIHdyb3RlOgo+IEhp
Cj4gwqAgV2hlbiB3ZSBtYWtlIElPIHN0cmVzcyB0ZXN0IG9uIG11bHRpcGF0aCBkZXZpY2UsIHRo
ZXJlIHdpbGwKPiBiZSBhwqAgbWV0YWRhdGEgZXJyIGJlY2F1c2Ugb2Ygd3JvbmcgcGF0aC4KPiAK
PiAKPiBTZXF1ZW5jZSBvZiBldmVudHM6Cj4gKDEpbXVsdGlwYXRoIC1y77yMIGlwMSBsb2dvdXQg
YXQgc2FtZQo+IFRoZSBsb2FkIHRhYmxlIHBhcmFtcyBvZiAzNjAwMTQwNWNhNTE2NTM2N2Q2NzQ0
N2VhNjgxMDhlMWQgaXMKPiAiMCAxIGFsdWEgMSAxIHNlcnZpY2UtdGltZSAwIDEgMSA4OjEyOCAx
Iu+8iFRoZSByZWFzb24gbm8gMTI4IG1heQo+IGJlIG5vdCBsb25nIGFmdGVyIGlwMiBsb2dpbiBh
bmQgcGF0aF9kaXNjb3ZlcnkgZG9lc24ndCBmaW5kIHNkZSkuCj4gSG93ZXZlciwgZG9tYXAgZmFp
bGVkIGJlY2F1c2UgaXAxIGxvZ291dC4gVGhlIHBhdGggb2Ygc2RpIGlzCj4gc3RpbGwgaW4gZ3Zl
Y3MtPnBhdGh2ZWMuCgp2ZXJpZnlfcGF0aHMoKSB3b3VsZCBkZXRlY3QgdGhpcy4gV2UgZG8gY2Fs
bCB2ZXJpZnlfcGF0aHMoKSBpbgpjb2FsZXNjZV9wYXRocygpIGJlZm9yZSBjYWxsaW5nIGRvbWFw
KCksIGJ1dCBub3QgaW1tZWRpYXRlbHkgYmVmb3JlLgpQZXJoYXBzIHdlIHNob3VsZCBtb3ZlIHRo
ZSB2ZXJpZnlfcGF0aHMoKSBjYWxsIGRvd24gdG8gaW1tZWRpYXRlbHkKYmVmb3JlIHRoZSBkb21h
cCgpIGNhbGwuwqBUaGF0IHdvdWxkIGF0IGxlYXN0IG1pbmltaXplIHRoZSB0aW1lIHdpbmRvdwpm
b3IgdGhpcyByYWNlLiBJdCdzIGhhcmQgdG8gYXZvaWQgaXQgZW50aXJlbHkuIFRoZSB3YXkgbXVs
dGlwYXRoZCBpcwp3cml0dGVuLCB0aGUgdmVjcyBsb2NrIGlzIGhlbGQgYWxsIHRoZSB0aW1lIGR1
cmluZyBjb2FsZXNjZV9wYXRocygpLCAKYW5kIHRodXMgbm8gdWV2ZW50cyBjYW4gYmUgcHJvY2Vz
c2VkLiBXZSBjb3VsZCBhbHNvIGNvbnNpZGVyIGNhbGxpbmcKdmVyaWZ5X3BhdGhzKCkgYmVmb3Jl
ICphbmQqIGFmdGVyIGRvbWFwKCkuCgpXYXMgdGhpcyBhIG1hcCBjcmVhdGlvbiBvciBhIG1hcCBy
ZWxvYWQ/IFdhcyB0aGUgbWFwIHJlbW92ZWQgYWZ0ZXIgdGhlCmZhaWx1cmU/IERvIHlvdSBvYnNl
cnZlIHRoZSBtZXNzYWdlICJpZ25vcmluZyBtYXAiIG9yICJyZW1vdmluZyBtYXAiPwoKRG8geW91
IG9ic2VydmUgYSAicmVtb3ZlIiB1ZXZlbnQgZm9yIHNkaT8gCgo+IAo+ICgyKSBtdWx0aXBhdGhk
IGFkZCBwYXRoIHNkZQo+IFRoZSBsb2FkIHRhYmxlIHBhcmFtcyBvZiAzNjAwMTQwNWNhNTE2NTM2
N2Q2NzQ0N2VhNjgxMDhlMWQgaXMKPiAiMCAxIGFsdWEgMiAxIHNlcnZpY2UtdGltZSAwIDEgMSA4
OjY0IDEgc2VydmljZS10aW1lIDAgMSAxIDg6MTI4ICIKPiBhbmQgZG9tYXAgc3VjY2Vzc2VzLgo+
IEF0IHRoaXMgdGltZSwgMzYwMDE0MDVjYTUxNjUzNjdkNjc0NDdlYTY4MTA4ZTFkIGhhcyB0d28g
cGF0aCAoc2RlLAo+IHNkaSksCj4gYnV0IHNkaSBpcyBhY3R1YWxseSB0aGUgcGF0aCBvZiAzNjAw
MTQwNWI3Njc5YmQ5NmIwOTRiY2NiZjk3MWJjOTAuCj4gCj4gKDMpIG1ldGFkYXRhIG9mIDM2MDAx
NDA1Y2E1MTY1MzY3ZDY3NDQ3ZWE2ODEwOGUxZCBzeW5jCj4gVGhlIG1ldGFkYXRhIG9mIDM2MDAx
NDA1Yjc2NzliZDk2YjA5NGJjY2JmOTcxYmM5MCB3aWxsIGJlIGNvdmVyZWQKCldlbGwsIEkgc3Vw
cG9zZSB0aGUgImFkZCIgZXZlbnQgZm9yIHNkZSBtaWdodCBjb21lIGJlZm9yZSB0aGUgcmVtb3Zl
CmV2ZW50IGZvciBzZGkgKGlmIGFueSkuCgpJIHdvbmRlciBpZiB5b3UnZCBzZWUgdGhlIGlzc3Vl
IGFsc28gaWYgeW91IHJ1biB0aGUgc2FtZSB0ZXN0IHdpdGhvdXQKdGhlICJtdWx0aXBhdGggLUY7
IG11bHRpcGF0aCAtciIgbG9vcCwgb3Igd2l0aCBqdXN0IG9uZS4gT2ssIG9uZQptdWx0aXBhdGhf
cXVlcnkoKSBsb29wIHNpbXVsYXRlcyBhbiBhZG1pbiB3b3JraW5nIG9uIHRoZSBzeXN0ZW0sIGJ1
dCAyCnBhcmFsbGVsIGxvb3BzIC0gMiBhZG1pbnMgd29ya2luZyBpbiBwYXJhbGxlbCwgcGx1cyB0
aGUgaW50ZW5zaXZlCnNlcXVlbmNlIG9mIGFjdGlvbnMgZG9uZSBpbiBtdWx0aXBhdGhkX3F1ZXJ5
IGF0IHRoZSBzYW1lIHRpbWU/IFRoZQpyZXBlYXRlZCAibXVsdGlwYXRoIC1yIiBjYWxscyBhbmQg
bXVsdGlwYXRoZCBjb21tYW5kcyB3aWxsIGNhdXNlCm11bHRpcGF0aGQgdG8gc3BlbmQgYSBsb3Qg
b2YgdGltZSBpbiByZWNvbmZpZ3VyZSgpIGFuZCBpbiBjbGlfKiBjYWxscwpob2xkaW5nIHRoZSB2
ZWNzIGxvY2ssIHdoaWNoIG1ha2VzIGl0IGxpa2VseSB0aGF0IHVldmVudHMgYXJlIG1pc3NlZCBv
cgpwcm9jZXNzZWQgbGF0ZS4KCkRvbid0IGdldCBtZSB3cm9uZywgSSBkb24ndCBhcmd1ZSBhZ2Fp
bnN0IHRvdWdoIHRlc3RpbmcuIEJ1dCB3ZSBzaG91bGQKYmUgYXdhcmUgdGhhdCB0aGVyZSBhcmUg
YWx3YXlzIHRpbWUgaW50ZXJ2YWxzIGR1cmluZyB3aGljaCBtdWx0aXBhdGhkJ3MKcGljdHVyZSBv
ZiB0aGUgcHJlc2VudCBkZXZpY2VzIGlzIGRpZmZlcmVudCBmcm9tIHdoYXQgdGhlIGtlcm5lbCBz
ZWVzLgoKVGhlcmUncyBkZWZpbml0ZWx5IHJvb20gZm9yIGltcHJvdmVtZW50IGluIG11bHRpcGF0
aGQgd3J0IGxvY2tpbmcgYW5kCmV2ZW50IHByb2Nlc3NpbmcgaW4gZ2VuZXJhbCwgYnV0IHRoYXQn
cyBhIEJJRyBwaWVjZSBvZiB3b3JrLgoKVGhhbmtzCk1hcnRpbgoKCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=


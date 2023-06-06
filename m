Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 241B9C7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686070728;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=24ykvnOD0/0RFDuxwPtgIg2+1ug2hIx98ShCE3Yp1UI=;
	b=cG31lSjvUPbRIoS+xVO+cNl9ljezKhbG349oapUeKN1SsIQAZGFuw/2SKGXjwEauF4khtx
	975yO1RAOjArw7AAoT4AitYQUBVrn97Nn2z2SvcRJ1aL1e0QBVQCpZ5Yk7q7ZVyCIa1t7U
	7+Uxb/M9oV5h/pYKCUYx7wXqtJDnKO4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-axvg2Q1UP6iNjhRSj_iwcw-1; Tue, 06 Jun 2023 12:58:44 -0400
X-MC-Unique: axvg2Q1UP6iNjhRSj_iwcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4550A85A5BB;
	Tue,  6 Jun 2023 16:58:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DEAB6C1603B;
	Tue,  6 Jun 2023 16:58:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9207819465BC;
	Tue,  6 Jun 2023 16:58:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0092219465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 16:58:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9064C40D1B68; Tue,  6 Jun 2023 16:58:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89C3540D1B66
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:58:39 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E358101A55C
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:58:39 +0000 (UTC)
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-sNBW5NMtPK-hOgdgvt9nIA-1; Tue,
 06 Jun 2023 12:58:37 -0400
X-MC-Unique: sNBW5NMtPK-hOgdgvt9nIA-1
Received: from authenticated user by stravinsky.debian.org with esmtpsa
 (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2) (envelope-from <zeha@debian.org>)
 id 1q6Zrh-003deD-5v; Tue, 06 Jun 2023 16:49:01 +0000
Date: Tue, 6 Jun 2023 18:48:53 +0200
From: Chris Hofstaedtler <zeha@debian.org>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <bjgxqic4umo4rk2srj4mqdgvvxntosb2xxo63fmymirulir7st@jduzswoyhupe>
References: <a674434b-d365-1f07-2c6f-6a4ffa07578f@gmail.com>
 <946fc11571491dd39971288b48095b6480f7914f.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <946fc11571491dd39971288b48095b6480f7914f.camel@suse.com>
X-Debian-User: zeha
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] multipath-tools: Debian patches
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 dm-devel mailing list <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: debian.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksCgoqIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiBbMjMwNjA2IDE3OjE4XToKPiBP
biBNb24sIDIwMjMtMDYtMDUgYXQgMjE6NTkgKzAyMDAsIFhvc2UgVmF6cXVleiBQZXJleiB3cm90
ZToKPiA+IEhpLAoKPiBJIGhhdmUgbm8gRGViaWFuIHNhbHNhIGFjY291bnQsIHNvIEkgcmVwbHkg
aGVyZSwgdHJ5aW5nIHRvIHJlYWNoIENocmlzCj4gdmlhIGVtYWlsLgoKKG5vdCBzdXJlIHdoZXJl
IHRoaXMgbWFpbCB0aHJlYWQgc3RhcnRlZCwgSSBkb24ndCBzZWUgdGhlIGZpcnN0IG1haWwKaW4g
dGhlIGRtLWRldmVsIGFyY2hpdmVzKQoKPiA+IEEgY29tcGxhaW50IGFib3V0IHVwc3RyZWFtLCAi
UmVtb3ZlIGxpYnJhcnkgZGV2ZWxvcG1lbnQgZmlsZXMgYW5kIGFsbAo+ID4gb2YgbGliZG1tcCI6
Cj4gPiBodHRwczovL3NhbHNhLmRlYmlhbi5vcmcvbGludXgtYmxvY2tzLXRlYW0vbXVsdGlwYXRo
LXRvb2xzLy0vY29tbWl0LzhjNDY2NjE2OTdkNzU3NzYzMTkyZDhlMDExYzlhZDUzMzU4ZDIwYjcK
CkZUUiwgSSBkb24ndCBjb25zaWRlciB0aGlzIGEgImNvbXBsYWludCIuCgpUaGlzIGNvbW1pdCBt
b3N0bHkgZXhpc3RzIHRvIHJlY3RpZnkgYSBmZXcgRGViaWFuLXNwZWNpZmljLCBoaXN0b3JpYwpp
c3N1ZXM6CgoxKSB3ZSBzaGlwKHBlZCkgbGlicmFyaWVzIGluIHRoZSBkYWVtb24gcGFja2FnZS4g
VGhpcyB3b3VsZCBiZSBva2F5LAppZiB0aGUgbGlicmFyaWVzIGFyZSBwcml2YXRlIGxpYnMsIGJ1
dCBnaXZlbiBsaWJtcGF0aHBlcnNpc3QgZXhpc3RzLAp0aGV5IGFyZSBjbGVhcmx5IG5vdCBwcml2
YXRlLgoKMikgd2UgaW5zdGFsbChlZCkgdmFyaW91cyBmaWxlcyBpbnRvIG9sZCBub24tL3VzciBw
YXRocy4gVGhlc2Ugd2VyZQptb3N0bHkgdGhlIHBrZy1jb25maWcsIGhlYWRlcnMgYW5kIC5zbyBm
aWxlcy4gRm9yIERlYmlhbiByZWFzb25zLCB3ZQpjYW5ub3QgImp1c3QgbW92ZSB0aGVtIiAoeWV0
KSBpbnRvIC91c3IsIGhvd2V2ZXIgYXQgdGhlIHNhbWUgdGltZQp0aGVyZSBleGlzdGVuY2UgaXMg
YSAoRGViaWFuLXNwZWNpZmljKSBwcm9ibGVtIGluIHRoZSBmdXR1cmUuCgpHaXZlbiB0aGVyZSBh
cmUgY3VycmVudGx5IG5vIHVzZXJzIGluIERlYmlhbiBmb3IgYW55IG9mIHRoZXNlLCBpdAp3YXMg
ZWFzaWVzdCB0byByZW1vdmUgYWxsIHRoZSBkZXZlbG9wbWVudCBmaWxlcy4KCklmIGFuZCB3aGVu
IG90aGVyIHBhY2thZ2VzIGluIERlYmlhbiB3YW50IHRvIHVzZSB0aGUgbGlicywgdGhlCnBhY2th
Z2luZyB3aWxsIGhhdmUgdG8gYmVjb21lIGEgbG90IG1vcmUgY29tcGxpY2F0ZWQuCgo+IElmIENo
cmlzIGhhcyBmb2xsb3dlZCB0aGUgdXBzdHJlYW0gZGlzY3Vzc2lvbiwgaGUgaXMgcHJvYmFibHkg
YXdhcmUKPiB0aGF0IHdlIGRvIGNhcmUgYWJvdXQgdGhlIEFCSS4gV2UgZG9uJ3Qga2VlcCB0aGUg
bGlibXVsdGlwYXRoIEFCSQo+IHN0YWJsZSwgYnV0IHRyYWNrIGl0IHVzaW5nIEFCSSB2ZXJzaW9u
aW5nLgoKSSB3YXMgb25seSB2YWd1ZWx5IGF3YXJlIG9mIHRoZSBjaGFuZ2VzIGluIHRoZSA8bGli
Pi52ZXJzaW9uIGZpbGVzLAphbmQgdGhhdCBhbGwgLnNvIGZpbGVzIGFyZSAiLnNvLjAiLgoKRnJv
bSBhIHF1aWNrIGdsYW5jZSBpdCBsb29rcyBsaWtlIGxpYm11bHRpcGF0aC5zby4wIGZyb20gMC45
LjQKZXhwb3J0cyBhIGxvdCBvZiBzeW1ib2xzIHZlcnNpb25lZCBATElCTVVMVElQQVRIXzE3LjAu
MCwgYnV0IGYuZS4Kbm9uZSB2ZXJzaW9uZWQgQExJQk1VTFRJUEFUSF8xNS4wLjAsIGJ1dCB0aGUg
c29uYW1lIGRpZG4ndCBjaGFuZ2UuCgpTbyAtIEknbSBub3Qgc3VyZSBpZiwgZm9yIGEgRGViaWFu
IGxpYnJhcnkgcGFja2FnZSwgaXQgaXMgb2theSB0byBkbwplc3NlbnRpYWxseSBkcm9wIHN5bWJv
bHMgd2l0aG91dCBhIG5ldyBzb25hbWUuCgo+IEl0IGlzIHRydWUgdGhhdCBtb3N0IG9mIHRoZQo+
IGxpYm11bHRpcGF0aCBoZWFkZXJzIGFyZSBub3QgdXNlZCBmb3Igb3RoZXIgcHJvamVjdHMuIE5v
dCBpbnN0YWxsaW5nCj4gYW55IGhlYWRlcnMgZXhjZXB0IHRoZSBwdWJsaWMgb25lcyBtYWtlcyBz
ZW5zZSwgYWN0dWFsbHkuCj4gCj4gVGhlIGxpYm1wYXRocGVyc2lzdCBBUEkgKExJQk1QQVRIUEVS
U0lTVF8yLjEuMCkgdGhhdCdzIHVzZWQgYnkgcWVtdSBpcwo+IHN1cHBvc2VkIHRvIHJlbWFpbiBz
dGFibGUuIFdlIGhhdmUgbW92ZWQgdGhvc2UgcGFydHMgb2YgdGhlIEFCSSB0aGF0Cj4gdXNlZCB0
byBiZSBtb3JlIHZvbGF0aWxlIGludG8gX19MSUJNUEFUSFBFUlNJU1RfSU5UXzEuMC4wLgo+IAo+
IFRoZXJlZm9yZSBpdCBtYWtlcyBzZW5zZSB0byBrZWVwIHNoaXBwaW5nIG1wYXRoX3BlcnNpc3Qu
aCBhbmQgZHJvcCB0aGUKPiByZXN0LiBJZiB0aGF0IHdvcmtzIGZvciBEZWJpYW4sIGl0IHdpbGwg
cHJvYmFibHkgd29yayBmb3Igb3RoZXIKPiBkaXN0cm9zLCB0b28uCgpJIGhhdmVuJ3QgdHJpZWQg
YnVpbGRpbmcgYW55dGhpbmcgYWdhaW5zdCBsaWJtcGF0aHBlcnNpc3QsIGJ1dAp3b3VsZG4ndCBw
ZW9wbGUgYWxzbyBuZWVkIGxpYm11bHRpcGF0aC5zbywgYW5kIHRodXMgdHJhbnNpdGl2ZWx5Cmxp
bmsgaW4gbGlibXVsdGlwYXRoLnNvLjAsIHBvc3NpYmx5IHVzaW5nIGl0cyBzeW1ib2xzPwoKPiBs
aWJkbXBwIGNvbWVzIGZyb20gUmVkIEhhdCwgcGVyaGFwcyBCZW4ga25vd3Mgd2hldGhlciBpdCBp
cyBzdGlsbCB1c2VkCj4gYnkgYW55IGFsaXZlIHByb2plY3QuIEl0IGRvZXMgaGF2ZSBhIHN0YWJs
ZSBBUEkvQUJJLgoKSSBjb3VsZG4ndCBmaW5kIGFueSB1c2VycyBpbiBEZWJpYW4sIHNvIGl0IGRp
ZG4ndCBzZWVtIHVzZWZ1bCB0bwprZWVwIHNoaXBwaW5nIGl0LgoKPiA+IEFuZCBtYXliZSB0aGVz
ZSBhcmUgcmVsZXZhbnQgZm9yIHVwc3RyZWFtICggcmVwbzoKPiA+IGh0dHBzOi8vc2Fsc2EuZGVi
aWFuLm9yZy9saW51eC1ibG9ja3MtdGVhbS9tdWx0aXBhdGgtdG9vbHMvLS90cmVlL21hc3Rlci9k
ZWJpYW4vcGF0Y2hlcwo+ID4gwqApOgo+ID4gCj4gPiBodHRwczovL3VkZC5kZWJpYW4ub3JnL3Bh
dGNoZXMuY2dpP3NyYz1tdWx0aXBhdGgtdG9vbHMmdmVyc2lvbj0wLjkuNC0zCj4gPiAKPiAKPiBU
aGF0J3Mgbm90IGhvdyB3ZSB3b3JrLiBXZSBkb24ndCBwaWNrIGRvd25zdHJlYW0gcGF0Y2hlcy4g
SWYKPiBzb21ldGhpbmcncyB3cm9uZyB3aXRoIHRoZSB1cHN0cmVhbSBjb2RlLCB3ZSdsbCBoYXBw
aWx5IGRpc2N1c3MgcGF0Y2hlcwo+IGZyb20gdGhlIERlYmlhbiBwcm9qZWN0LCBwcmVmZXJhYmx5
IGhlcmUgb24gZG0tZGV2ZWwuCgpJIHRoaW5rIG1vc3Qgb2YgdGhlc2UgcGF0Y2hlcyBhcmUgbm90
IHVzZWZ1bCBmb3IgdXBzdHJlYW0uIERvIHlvdQpjYXJlIGFib3V0IG91ciBoaXN0b3JpYyBpbnN0
YWxsIHBhdGhzPwoKQ2hyaXMKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsCg==


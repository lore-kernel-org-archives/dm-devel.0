Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AFAC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 15:42:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C56BC64F09
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 15:42:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C56BC64F09
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cines.fr
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-ytDqQeuxNuykwXJvcNeknA-1; Tue, 02 Mar 2021 10:41:58 -0500
X-MC-Unique: ytDqQeuxNuykwXJvcNeknA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 903BB100CCD5;
	Tue,  2 Mar 2021 15:41:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4857019C93;
	Tue,  2 Mar 2021 15:41:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 38F6F18095CB;
	Tue,  2 Mar 2021 15:41:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122FfnOJ020185 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 10:41:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 93F542026D13; Tue,  2 Mar 2021 15:41:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E47D2026D48
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 15:41:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAFDA104D982
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 15:41:45 +0000 (UTC)
Received: from sati.cines.fr (sati.cines.fr [193.48.169.59]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-304-SA05CSacMmKeDKJAL52DdQ-1;
	Tue, 02 Mar 2021 10:41:43 -0500
X-MC-Unique: SA05CSacMmKeDKJAL52DdQ-1
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sati.cines.fr (Postfix) with ESMTP id 891EF2627EBD;
	Tue,  2 Mar 2021 16:41:41 +0100 (CET)
Received: from sati.cines.fr ([127.0.0.1])
	by localhost (sati.cines.fr [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id eNPrWYD_JmTq; Tue,  2 Mar 2021 16:41:41 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sati.cines.fr (Postfix) with ESMTP id 459572629C4F;
	Tue,  2 Mar 2021 16:41:41 +0100 (CET)
X-Virus-Scanned: amavisd-new at sati.cines.fr
Received: from sati.cines.fr ([127.0.0.1])
	by localhost (sati.cines.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BXP0W73JYV2Y; Tue,  2 Mar 2021 16:41:41 +0100 (CET)
Received: from daksha.cines.fr (daksha.cines.fr [193.48.169.58])
	by sati.cines.fr (Postfix) with ESMTP id 291AA2627EBD;
	Tue,  2 Mar 2021 16:41:41 +0100 (CET)
Date: Tue, 2 Mar 2021 16:41:41 +0100 (CET)
From: bchatelain@cines.fr
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <668683972.267173179.1614699701122.JavaMail.zimbra@cines.fr>
In-Reply-To: <e8c80d5b-419e-2799-072e-4a2e91940838@gmail.com>
References: <388321540.261431070.1614606275832.JavaMail.zimbra@cines.fr>
	<e8c80d5b-419e-2799-072e-4a2e91940838@gmail.com>
MIME-Version: 1.0
X-Originating-IP: [192.168.52.3]
Thread-Topic: multipath with SAS and FC.
Thread-Index: cd7u5ljZwXrkp8sniB8e9j4tu1iD6g==
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 122FfnOJ020185
X-loop: dm-devel@redhat.com
Cc: dm-devel <dm-devel@redhat.com>
Subject: Re: [dm-devel] multipath with SAS and FC.
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SXQncyB3b3JrIGdvb2QuCgpJIGhhdmUgYWRkIHRoaXMgbGluZSB0byBkZXZpY2UgaW4gbXVsdGlw
YXRoLmNvbmYgOgogIHBhdGhfZ3JvdXBpbmdfcG9saWN5ICJncm91cF9ieV9wcmlvIgoKCkkgaGF2
ZSBzb21ldGhpbmcgbGlrZSB0aGlzIDoKCiAgI211bHRpcGF0aCAtbGwKMzYwMDBkMzEwMDNkNWMy
MDAwMDAwMDAwMDAwMDAwMDEwIGRtLTMgQ09NUEVMTlQsQ29tcGVsbGVudCBWb2wKc2l6ZT0xLjVU
IGZlYXR1cmVzPScxIHF1ZXVlX2lmX25vX3BhdGgnIGh3aGFuZGxlcj0nMSBhbHVhJyB3cD1ydwp8
LSstIHBvbGljeT0nc2VydmljZS10aW1lIDAnIHByaW89NTAgc3RhdHVzPWFjdGl2ZQp8IGAtIDE6
MDowOjIgc2RiIDg6MTYgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKYC0rLSBwb2xpY3k9J3NlcnZpY2Ut
dGltZSAwJyBwcmlvPTEgc3RhdHVzPWVuYWJsZWQKICBgLSAxOjA6MToyIHNkYyA4OjMyIGFjdGl2
ZSByZWFkeSBydW5uaW5nCgpBbmQgbm8gbW9yZSBsb2dzIGluIC92YXIvbG9nL21lc3NhZ2VzLgoK
ClRoYW5rIFlvdS4KCgpSZWdhcmRzLApCZW5vaXQgQ2hhdGVsYWluLgoKCi0tLS0tIE1haWwgb3Jp
Z2luYWwgLS0tLS0KRGU6ICJYb3NlIFZhenF1ZXogUGVyZXoiIDx4b3NlLnZhenF1ZXpAZ21haWwu
Y29tPgrDgDogIkJlbm9pdCBDaGF0ZWxhaW4iIDxiY2hhdGVsYWluQGNpbmVzLmZyPiwgImRtLWRl
dmVsIiA8ZG0tZGV2ZWxAcmVkaGF0LmNvbT4KRW52b3nDqTogTWFyZGkgMiBNYXJzIDIwMjEgMTE6
MTU6MTkKT2JqZXQ6IFJlOiBbZG0tZGV2ZWxdIG11bHRpcGF0aCB3aXRoIFNBUyBhbmQgRkMuCgpP
biAzLzEvMjEgMjo0NCBQTSwgYmNoYXRlbGFpbkBjaW5lcy5mciB3cm90ZToKCj4gSSB0cnkgdG8g
dXNlIG11bHRpcGF0aCB3aXRoIFNBUyBkaXNrLCB0cmFuc3BvcnRlZCBieSBGaWJlciBDaGFubmVs
LCBvbgo+IERlbGwgQ29tcGVsbGVudC4KPiBNeSB2b2x1bWUgaXMgZGV0ZWN0ZWQgb24gMnggUjQ0
MCBQb3dlckVkZ2UgaG9zdGVkIGJ5IENlbnRvcyA4IGFuZAo+IG9yY2hlc3RyYXRlZCBieSBvVmly
dC4KPiBbLi4uXQo+ICMgbXVsdGlwYXRoIC1sbAo+IDM2MDAwZDMxMDAzZDVjMjAwMDAwMDAwMDAw
MDAwMDAxMCBkbS0zIENPTVBFTE5ULENvbXBlbGxlbnQgVm9sCj4gc2l6ZT0xLjVUIGZlYXR1cmVz
PScxIHF1ZXVlX2lmX25vX3BhdGgnIGh3aGFuZGxlcj0nMSBhbHVhJyB3cD1ydwo+IGAtKy0gcG9s
aWN5PSdzZXJ2aWNlLXRpbWUgMCcgcHJpbz0yNSBzdGF0dXM9YWN0aXZlCj4gIMKgwqAgfC0gMTow
OjA6MiBzZGIgODoxNiBhY3RpdmUgcmVhZHkgcnVubmluZwo+ICDCoMKgIGAtIDE6MDoxOjIgc2Rj
IDg6MzIgZmFpbGVkIHJlYWR5IHJ1bm5pbmcgwqAgLS0gbG9vcGluZyBmYWlsZWQvcmVhZHkKClRo
ZSBkZWZhdWx0IG1wdCBjb25maWcgZm9yICJDT01QRUxOVC9Db21wZWxsZW50IFZvbCIgaXMgYWxy
ZWFkeSAibXVsdGlidXMiLgpUaGVyZSBpcyBubyBuZWVkIHRvIGFkZCBhIGN1c3RvbSBjb25maWcg
dG8gL2V0Yy9tdWx0aXBhdGguY29uZi4KClRyeToKIyBzYXZlIG9sZCBjb25maWdzCm12IC9ldGMv
bXVsdGlwYXRoLmNvbmYgL2V0Yy9fbXVsdGlwYXRoLmNvbmYtJChkYXRlICslcykKY3AgLWEgL2V0
Yy9tdWx0aXBhdGgvd3dpZHMgL2V0Yy9tdWx0aXBhdGgvX3d3aWRzLSQoZGF0ZSArJXMpCiMgcmVj
b25maWcgbXAKbXBhdGhjb25mIC0tZW5hYmxlIC0tdXNlcl9mcmllbmRseV9uYW1lcyBuCm11bHRp
cGF0aCAtVwpzeXN0ZW1jdGwgZW5hYmxlIG11bHRpcGF0aGQuc2VydmljZQojIHJlY3JlYXRlIGlu
aXRyZCwgYW5kIHJlYm9vdCB0aGUgc3lzdGVtCmRyYWN1dCAtZgppbml0IDYKCgpJZiB0aGUgZGVm
YXVsdCBtb2RlIG9mICJDT01QRUxOVC9Db21wZWxsZW50IFZvbCIgYXJyYXlzIFdFUkUgQ0hBTkdF
RCB0byBBTFVBLAooZG1lc2cgLVQgfCBncmVwIC1pIGFsdWEpLiBUaGUgL2V0Yy9tdWx0aXBhdGgu
Y29uZiBmaWxlIG11c3QgY29udGFpbjoKCmRldmljZXMgewoJZGV2aWNlIHsKCQl2ZW5kb3IgIkNP
TVBFTE5UIgoJCXByb2R1Y3QgIkNvbXBlbGxlbnQgVm9sIgoJCXBhdGhfZ3JvdXBpbmdfcG9saWN5
ICJncm91cF9ieV9wcmlvIgoJCXByaW8gImFsdWEiCgkJZmFpbGJhY2sgImltbWVkaWF0ZSIKCQlu
b19wYXRoX3JldHJ5IDMwCgl9Cn0KCkZvbGxvdyB0aGUgc2FtZSBzdGVwcywgYnV0IGJlZm9yZSAi
ZHJhY3V0IC1mIiBhZGQgdGhhdCBjb25maWcgdG8gL2V0Yy9tdWx0aXBhdGguY29uZgoKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C01CC678D5
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 10:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678183538;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M3gSUJsHcj5L+RCdpHBIvJC9ABrgdLbCn85HpXT+a/Y=;
	b=fiyC5cAtFqH1w91erbW52tZ+rSLH9cpZnV35OAKm8VUU9P/YMNlVBtURVimpqrRv3jbM/c
	uTGpcWyHEQH3oN/EBp7BdcHXewRVhxaiioUDFDUz/LA9HzFEZG78OHbzh5Ff7GI+LtzmfG
	Sk/Llva9t+mutGw/qNrQsJdX1mVg5FM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-2OcLLw52MCiT7To4gHj59g-1; Tue, 07 Mar 2023 05:05:35 -0500
X-MC-Unique: 2OcLLw52MCiT7To4gHj59g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0E591C29D4F;
	Tue,  7 Mar 2023 10:05:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F20311121314;
	Tue,  7 Mar 2023 10:05:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7285019465A3;
	Tue,  7 Mar 2023 10:05:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFC311946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 10:05:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 88025112132D; Tue,  7 Mar 2023 10:05:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 806251121314
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 10:05:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63681857F45
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 10:05:24 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-416-35uYzyL4Pu2z1lSWNM4OTg-1; Tue,
 07 Mar 2023 05:05:20 -0500
X-MC-Unique: 35uYzyL4Pu2z1lSWNM4OTg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 4E77821A36;
 Tue,  7 Mar 2023 10:05:19 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29A781341F;
 Tue,  7 Mar 2023 10:05:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id duGdCF8MB2SaVAAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 07 Mar 2023 10:05:19 +0000
Message-ID: <132cc7022fa35b9a84e5064c25c3fc52bdebafd3.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Date: Tue, 07 Mar 2023 11:05:18 +0100
In-Reply-To: <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
 <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
 <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
 <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU2F0LCAyMDIzLTAzLTA0IGF0IDEyOjQ5IC0wODAwLCBCcmlhbiBCdW5rZXIgd3JvdGU6Cj4g
T24gTWFyIDMsIDIwMjMsIGF0IDEyOjQxIFBNLCBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNv
bT4gd3JvdGU6Cj4gPiAKPiA+IE9uIEZyaSwgMjAyMy0wMy0wMyBhdCAwOToxOCAtMDgwMCwgQnJp
YW4gQnVua2VyIHdyb3RlOgo+ID4gPiA+IAo+ID4gPiBIZWxsbyBNYXJ0aW4sIAo+ID4gPiAKPiA+
ID4gRG9lc27igJl0ICJzb21ldGhpbmcgaW4gYmV0d2VlbiBmYWlsZWQgYW5kIHVw4oCdIHNlbWFu
dGljcyBkZXNjcmliZQo+ID4gPiBBTFVBCj4gPiA+IHN0YXRlIHRyYW5zaXRpb25pbmcgcHJldHR5
IHdlbGw/Cj4gPiAKPiA+IHRyYW5zaXRpb25pbmcgLSB5ZXMuIHN0YW5kYnkgLSA/Pwo+ID4gCj4g
PiBNYXJ0aW4KPiA+IAo+IFRoZSBjaGVja2luZyBmb3Igc3RhbmRieSBpcyAxNCB5ZWFycyBvbGQs
IGFuZCBzYXlzIHRoYXQgVFVSIHJldHVybnMKPiBhIHVuaXQgYXR0ZW50aW9uIHdoZW4gdGhlIHBh
dGggaXMgaW4gc3RhbmRieS4gSSBhbSBub3Qgc3VyZSB3aHkgdGhhdAo+IHdvdWxkbuKAmXQgYmUg
aGFuZGxlZCBieSB0aGlzIGNvZGUgYWJvdmU6IEkgd291bGQgdGhpbmsgdGhlcmUgc2hvdWxkIGJl
Cj4ganVzdCBvbmUgdW5pdCBhdHRlbnRpb24gZm9yIGVhY2ggSV9UX0wgd2hlbiBhbiBBTFVBIHN0
YXRlIGNoYW5nZQo+IGhhcHBlbnMuCgpTUEM2IG1hbmRhdGVzIHRoYXQgVUEgYmUgZXN0YWJsaXNo
ZWQgYWZ0ZXIgYSAoc3VjY2Vzc2Z1bCBvciBmYWlsZWQpCnN0YXRlIHRyYW5zaXRpb24uIFRoZSBV
QSB3b3VsZCBiZSBzZWVuIG9uY2UgYWZ0ZXIgU1RBTkRCWSB3YXMgZW50ZXJlZCwKYW5kIGFmdGVy
IHRoYXQsIFRVUiB3b3VsZCBmaW5pc2ggd2l0aCBDSEVDSyBDT05ESVRJT04sIE5PVCBSRUFEWSwK
TE9HSUNBTCBVTklUIE5PVCBBQ0NFU1NJQkxFLCBUQVJHRVQgUE9SVCBJTiBTVEFOREJZIFNUQVRF
LgoKT3VyIGNvZGUgaXMgaW5kZWVkIGNvcnJlY3QgaW4gdGhpcyByZXNwZWN0LgoKTWFydGluCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


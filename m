Return-Path: <SRS0=Bru9=MZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C96BC4338F
	for <dm-devel@archiver.kernel.org>; Mon,  2 Aug 2021 10:42:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DAA9260E76
	for <dm-devel@archiver.kernel.org>; Mon,  2 Aug 2021 10:42:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DAA9260E76
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=thson.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-gBo8Tg_qMUSzLXiSBK9CVw-1; Mon, 02 Aug 2021 06:42:00 -0400
X-MC-Unique: gBo8Tg_qMUSzLXiSBK9CVw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D281107ACF5;
	Mon,  2 Aug 2021 10:41:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02AAA1002D71;
	Mon,  2 Aug 2021 10:41:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 323DD4BB7C;
	Mon,  2 Aug 2021 10:41:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 172AfiRc011074 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 2 Aug 2021 06:41:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9C98D100320C; Mon,  2 Aug 2021 10:41:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97F5F1005B77
	for <dm-devel@redhat.com>; Mon,  2 Aug 2021 10:41:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9B598D138E
	for <dm-devel@redhat.com>; Mon,  2 Aug 2021 10:41:41 +0000 (UTC)
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de
	[85.215.255.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-281-QCXfyo3mMRm385J4U8RPjg-1; Mon, 02 Aug 2021 06:41:39 -0400
X-MC-Unique: QCXfyo3mMRm385J4U8RPjg-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
	with ESMTPSA id t06ddcx72AcW8Oj
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Mon, 2 Aug 2021 12:38:32 +0200 (CEST)
From: Thore Sommer <public@thson.de>
To: tusharsu@linux.microsoft.com
Date: Mon,  2 Aug 2021 12:38:23 +0200
Message-Id: <20210802103823.199091-1-public@thson.de>
In-Reply-To: <f73308f3-485f-46cb-0f20-6619edb541e6@linux.microsoft.com>
References: <f73308f3-485f-46cb-0f20-6619edb541e6@linux.microsoft.com>
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
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	dm-devel@redhat.com, public@thson.de,
	linux-integrity@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/7] device mapper target measurements using
	IMA
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgVHVzaGFyLAoKdGhhbmsgeW91IGZvciBhbnN3ZXJpbmcgbXkgcXVlc3Rpb25zIGFuZCBsb29r
aW5nIGF0IG15IHN1Z2dlc3Rpb25zLgoKPiBJIGNhbiB1cGRhdGUgdGhlIHZlcml0eV9zdGF0dXMo
KSB0byBtZWFzdXJlIGlmIHYtPnNpZ25hdHVyZV9rZXlfZGVzYyBpcyAKPiBzZXQuCj4gCj4gU29t
ZXRoaW5nIGxpa2U6Cj4gRE1FTUlUKCJzaWduYXR1cmVfa2V5X2Rlc2NfcHJlc2VudD0lYywiLCB2
LT5zaWduYXR1cmVfa2V5X2Rlc2MgPyAneScgOgo+ICduJyk7CgpJZiBteSB1bmRlcnN0YW5kaW5n
IHRoYXQgdGhpcyBlbnRyeSBpcyBvbmx5IHNldCBpZiB0aGUgc2lnbmF0dXJlIHdhcyB2YWxpZGF0
ZWQKaXMgY29ycmVjdCB0aGVuIHRoaXMgc2hvdWxkIHdvcmsuCgo+IFBsZWFzZSBub3RlIOKAkyBl
dmVuIGlmIHdlIG1lYXN1cmUgc2lnbmF0dXJlX2tleV9kZXNjIChmdWxsIHN0cmluZyBvciBqdXN0
Cj4gaXRzIHByZXNlbmNlKTogaW4gb3JkZXIgdG8gdXNlIGl0IHdpdGggdGhlIGtleXJpbmdzLCB0
aGUgSU1BIHBvbGljeSBhbHNvCj4gbmVlZHMgdG8gYmUgc2V0IHRvIG1lYXN1cmUga2V5IHJpbmdz
ICh1c2luZyAibWVhc3VyZSBmdW5jPUtFWV9DSEVDSwo+IC4uLiIpLiBJdCBpcyBpbmRlcGVuZGVu
dCBmcm9tIG1lYXN1cmluZyB0aGUgZGV2aWNlIG1hcHBlciBkYXRhICh3aGljaCBpcwo+IG1lYXN1
cmVkIHdoZW4gdGhlIHBvbGljeSBpcyBzZXQgdG8g4oCcbWVhc3VyZSBmdW5jPUNSSVRJQ0FMX0RB
VEEKPiBsYWJlbD1kZXZpY2UtbWFwcGVyIC4uLiIpLgo+IAo+IFRoZXJlZm9yZSBtZWFzdXJpbmcg
a2V5cmluZ3MgdG9nZXRoZXIgKGkuZS4gaW4gdGhlIHNhbWUgSU1BIGxvZykgd2l0aCBETQo+IGRh
dGEgIGlzIG5vdCBhbHdheXMgZ3VhcmFudGVlZCwgc2luY2UgaXQgaXMgZGljdGF0ZWQgYnkgaG93
IHRoZSBJTUEKPiBwb2xpY3kgaXMgY29uZmlndXJlZC4KClRoYW5rcyBmb3IgcG9pbnRpbmcgdGhh
dCBvdXQuIEN1cnJlbnRseSB3ZSBkb24ndCBtZWFzdXJlIHRoZSBrZXlyaW5ncyBidXQgd2hlbgp3
ZSBlbmFibGUgcmVtb3RlIGF0dGVzdGF0aW9uIGZvciBkbS12ZXJpdHkgd2UnbGwgbWFrZSBzdXJl
IHRoYXQgb3VyIElNQSBwb2xpY3kKYWxzbyBtZWFzdXJlcyB0aGUga2V5cmluZ3MuCgpSZWdhcmRz
LApUaG9yZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


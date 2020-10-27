Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47118C56201
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 08:43:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AFF402224E
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 08:43:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFF402224E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-g7Nur58eMr2CScRVwuLZgA-1; Tue, 27 Oct 2020 04:43:22 -0400
X-MC-Unique: g7Nur58eMr2CScRVwuLZgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E1F95F9F8;
	Tue, 27 Oct 2020 08:43:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4104860FC2;
	Tue, 27 Oct 2020 08:43:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 18DAECF41;
	Tue, 27 Oct 2020 08:43:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09R6xd5P008901 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 02:59:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0578D114F086; Tue, 27 Oct 2020 06:59:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 01089114F085
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 06:59:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7ACB3185A79C
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 06:59:36 +0000 (UTC)
Received: from mail-yb1-f195.google.com (mail-yb1-f195.google.com
	[209.85.219.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-10-cgY_I31BP5SwzLlSzJTghQ-1; Tue, 27 Oct 2020 02:59:33 -0400
X-MC-Unique: cgY_I31BP5SwzLlSzJTghQ-1
Received: by mail-yb1-f195.google.com with SMTP id s89so341322ybi.12
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 23:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=/MJ+UTfnuNYWSl6F6YSIZ4D2DyAhRF8y858D6tasEvw=;
	b=pHG3EUgdxHwc7WCJu0PgfChrm8eeQmSqJvdCCXwlmoskZ+pnUa3ea4vk7hNUH6aF7D
	UUYZYnE5O2Tf+mohFIj2Z9dXmi/YezDOVB+mpJZ61PNaxCHK7BXLHaRhs3CPG4IM07c9
	+4grWGbRFakEGpL/TAYsbAe1MQnWg8aJQAfH46phkiLWdpDIJSSlIIFFpjFjDq9W0amN
	nC9JS2HxStny/udkUYvgimlts7EcfFMJ6NAiuBc2ceDEUMAv6RNgnr8ly4L6Flcs0BTH
	ITZsweXXu9Qk3BFrIMYU5QSLduCWhNurdTBtoq5QB5c3KqOSUwDSG5wCrYjV2JkVv+2q
	Ykkg==
X-Gm-Message-State: AOAM5307FBII5T6f5iWApvP5SOLmPHgbEqppeD6GNEntoQkwsKs4Aw8u
	C+ybDzrvZdDJcsO1arbbF82nME9Ss3FZq1sAVwvC0g==
X-Google-Smtp-Source: ABdhPJz+9qYgc6z6pEq4anawMnwD8UgeJFA5p9U95SlGuQbt5EuEgoDjkIODeWkTxrO6zuIhQ9mwwY+zQLKSY3uumOg=
X-Received: by 2002:a25:6609:: with SMTP id a9mr1102464ybc.375.1603781973236; 
	Mon, 26 Oct 2020 23:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201026130450.6947-1-gilad@benyossef.com>
	<20201026130450.6947-4-gilad@benyossef.com>
	<20201026175231.GG858@sol.localdomain>
	<d07b062c-1405-4d72-b907-1c4dfa97aecb@gmail.com>
	<20201026183936.GJ858@sol.localdomain>
	<fd5e46ce-a4bf-8025-05ea-e20d35485446@gmail.com>
In-Reply-To: <fd5e46ce-a4bf-8025-05ea-e20d35485446@gmail.com>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Tue, 27 Oct 2020 08:59:27 +0200
Message-ID: <CAOtvUMdatUOnffg90aEGanD0y1LtKc7EeKQ=E+N+W-wpo8Zo3A@mail.gmail.com>
To: Milan Broz <gmazyland@gmail.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09R6xd5P008901
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 27 Oct 2020 04:42:30 -0400
Cc: linux-raid@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH 3/4] dm crypt: switch to EBOIV crypto API
	template
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBPY3QgMjYsIDIwMjAgYXQgOTowNCBQTSBNaWxhbiBCcm96IDxnbWF6eWxhbmRAZ21h
aWwuY29tPiB3cm90ZToKPgo+Cj4KPiBPbiAyNi8xMC8yMDIwIDE5OjM5LCBFcmljIEJpZ2dlcnMg
d3JvdGU6Cj4gPiBPbiBNb24sIE9jdCAyNiwgMjAyMCBhdCAwNzoyOTo1N1BNICswMTAwLCBNaWxh
biBCcm96IHdyb3RlOgo+ID4+IE9uIDI2LzEwLzIwMjAgMTg6NTIsIEVyaWMgQmlnZ2VycyB3cm90
ZToKPiA+Pj4gT24gTW9uLCBPY3QgMjYsIDIwMjAgYXQgMDM6MDQ6NDZQTSArMDIwMCwgR2lsYWQg
QmVuLVlvc3NlZiB3cm90ZToKPiA+Pj4+IFJlcGxhY2UgdGhlIGV4cGxpY2l0IEVCT0lWIGhhbmRs
aW5nIGluIHRoZSBkbS1jcnlwdCBkcml2ZXIgd2l0aCBjYWxscwo+ID4+Pj4gaW50byB0aGUgY3J5
cHRvIEFQSSwgd2hpY2ggbm93IHBvc3Nlc3NlcyB0aGUgY2FwYWJpbGl0eSB0byBwZXJmb3JtCj4g
Pj4+PiB0aGlzIHByb2Nlc3Npbmcgd2l0aGluIHRoZSBjcnlwdG8gc3Vic3lzdGVtLgo+ID4+Pj4K
PiA+Pj4+IFNpZ25lZC1vZmYtYnk6IEdpbGFkIEJlbi1Zb3NzZWYgPGdpbGFkQGJlbnlvc3NlZi5j
b20+Cj4gPj4+Pgo+ID4+Pj4gLS0tCj4gPj4+PiAgZHJpdmVycy9tZC9LY29uZmlnICAgIHwgIDEg
Kwo+ID4+Pj4gIGRyaXZlcnMvbWQvZG0tY3J5cHQuYyB8IDYxICsrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiA+Pj4+ICAyIGZpbGVzIGNoYW5nZWQsIDIwIGluc2Vy
dGlvbnMoKyksIDQyIGRlbGV0aW9ucygtKQo+ID4+Pj4KPiA+Pj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL21kL0tjb25maWcgYi9kcml2ZXJzL21kL0tjb25maWcKPiA+Pj4+IGluZGV4IDMwYmEzNTcz
NjI2Yy4uY2E2ZTU2YTcyMjgxIDEwMDY0NAo+ID4+Pj4gLS0tIGEvZHJpdmVycy9tZC9LY29uZmln
Cj4gPj4+PiArKysgYi9kcml2ZXJzL21kL0tjb25maWcKPiA+Pj4+IEBAIC0yNzMsNiArMjczLDcg
QEAgY29uZmlnIERNX0NSWVBUCj4gPj4+PiAgICBzZWxlY3QgQ1JZUFRPCj4gPj4+PiAgICBzZWxl
Y3QgQ1JZUFRPX0NCQwo+ID4+Pj4gICAgc2VsZWN0IENSWVBUT19FU1NJVgo+ID4+Pj4gKyAgc2Vs
ZWN0IENSWVBUT19FQk9JVgo+ID4+Pj4gICAgaGVscAo+ID4+Pj4gICAgICBUaGlzIGRldmljZS1t
YXBwZXIgdGFyZ2V0IGFsbG93cyB5b3UgdG8gY3JlYXRlIGEgZGV2aWNlIHRoYXQKPiA+Pj4+ICAg
ICAgdHJhbnNwYXJlbnRseSBlbmNyeXB0cyB0aGUgZGF0YSBvbiBpdC4gWW91J2xsIG5lZWQgdG8g
YWN0aXZhdGUKPiA+Pj4KPiA+Pj4gQ2FuIENSWVBUT19FQk9JViBwbGVhc2Ugbm90IGJlIHNlbGVj
dGVkIGJ5IGRlZmF1bHQ/ICBJZiBzb21lb25lIHJlYWxseSB3YW50cwo+ID4+PiBCaXRsb2NrZXIg
Y29tcGF0aWJpbGl0eSBzdXBwb3J0LCB0aGV5IGNhbiBzZWxlY3QgdGhpcyBvcHRpb24gdGhlbXNl
bHZlcy4KPiA+Pgo+ID4+IFBsZWFzZSBubyEgVW50aWwgdGhpcyBtb3ZlIG9mIElWIHRvIGNyeXB0
byBBUEksIHdlIGNhbiByZWx5IG9uCj4gPj4gc3VwcG9ydCBpbiBkbS1jcnlwdCAoaWYgaXQgaXMg
bm90IHN1cHBvcnRlZCwgaXQgaXMganVzdCBhIHZlcnkgb2xkIGtlcm5lbCkuCj4gPj4gKEFjdHVh
bGx5LCB0aGlzIHdhcyB0aGUgZmlyc3QgdGhpbmcgSSBjaGVja2VkIGluIHRoaXMgcGF0Y2hzZXQg
LSBpZiBpdCBpcwo+ID4+IHVuY29uZGl0aW9uYWxseSBlbmFibGVkIGZvciBjb21wYXRpYmlsaXR5
IG9uY2UgZG1jcnlwdCBpcyBzZWxlY3RlZC4pCj4gPj4KPiA+PiBQZW9wbGUgYWxyZWFkeSB1c2Ug
cmVtb3ZhYmxlIGRldmljZXMgd2l0aCBCaXRMb2NrZXIuCj4gPj4gSXQgd2FzIHRoZSB3aG9sZSBw
b2ludCB0aGF0IGl0IHdvcmtzIG91dC1vZi10aGUtYm94IHdpdGhvdXQgZW5hYmxpbmcgYW55dGhp
bmcuCj4gPj4KPiA+PiBJZiB5b3UgaW5zaXN0IG9uIHRoaXMgdG8gYmUgb3B0aW9uYWwsIHBsZWFz
ZSBiZXR0ZXIga2VlcCB0aGlzIElWIGluc2lkZSBkbWNyeXB0Lgo+ID4+IChFQk9JViBoYXMgbm8g
b3RoZXIgdXNlIHRoYW4gZm9yIGRpc2sgZW5jcnlwdGlvbiBhbnl3YXkuKQo+ID4+Cj4gPj4gT3Ig
bWF5YmUgYW5vdGhlciBvcHRpb24gd291bGQgYmUgdG8gaW50cm9kdWNlIG9wdGlvbiB1bmRlciBk
bS1jcnlwdCBLY29uZmlnIHRoYXQKPiA+PiBkZWZhdWx0cyB0byBlbmFibGVkIChsaWtlIHN1cHBv
cnQgZm9yIGZvcmVpZ24vbGVnYWN5IGRpc2sgZW5jcnlwdGlvbiBzY2hlbWVzKSBhbmQgdGhhdAo+
ID4+IHNlbGVjdHMgdGhlc2UgSVZzL21vZGVzLgo+ID4+IEJ1dCByZXF1aXJpbmcgc29tZSByYW5k
b20gc3dpdGNoIGluIGNyeXB0byBBUEkgd2lsbCBvbmx5IGNvbmZ1c2UgdXNlcnMuCj4gPgo+ID4g
Q09ORklHX0RNX0NSWVBUIGNhbiBlaXRoZXIgc2VsZWN0IGV2ZXJ5IHdlaXJkIGNvbWJpbmF0aW9u
IG9mIGFsZ29yaXRobXMgYW55b25lCj4gPiBjYW4gZXZlciBiZSB1c2luZywgb3IgaXQgY2FuIHNl
bGVjdCBzb21lIGRlZmF1bHRzIGFuZCByZXF1aXJlIGFueSBvdGhlciBuZWVkZWQKPiA+IGFsZ29y
aXRobXMgdG8gYmUgZXhwbGljaXRseSBzZWxlY3RlZC4KPiA+Cj4gPiBJbiByZWFsaXR5LCBkbS1j
cnlwdCBoYXMgbmV2ZXIgZXZlbiBzZWxlY3RlZCBhbnkgcGFydGljdWxhciBibG9jayBjaXBoZXJz
LCBldmVuCj4gPiBBRVMuICBOb3IgaGFzIGl0IGV2ZXIgc2VsZWN0ZWQgWFRTLiAgU28gaXQncyBh
Y3R1YWxseSBhbHdheXMgbWFkZSB1c2VycyAob3IKPiA+IGtlcm5lbCBkaXN0cmlidXRvcnMpIGV4
cGxpY2l0bHkgc2VsZWN0IGFsZ29yaXRobXMuICBXaHkgdGhlIEJpdGxvY2tlciBzdXBwb3J0Cj4g
PiBzdWRkZW5seSBkaWZmZXJlbnQ/Cj4gPgo+ID4gSSdkIHRoaW5rIGEgbG90IG9mIGRtLWNyeXB0
IHVzZXJzIGRvbid0IHdhbnQgdG8gYmxvYXQgdGhlaXIga2VybmVscyB3aXRoIHJhbmRvbQo+ID4g
bGVnYWN5IGFsZ29yaXRobXMuCj4KPiBZZXMsIGJ1dCBJViBpcyBpbiByZWFsaXR5IG5vdCBhIGNy
eXB0b2dyYXBoaWMgYWxnb3JpdGhtLCBpdCBpcyBraW5kLW9mIGEgY29uZmlndXJhdGlvbgo+ICJv
cHRpb24iIG9mIHNlY3RvciBlbmNyeXB0aW9uIG1vZGUgaGVyZS4KPgo+IFdlIGhhZCBhbGwgb2Yg
ZGlzay1JViBpbnNpZGUgZG1jcnlwdCBiZWZvcmUgLSBidXQgb25jZSBpdCBpcyBwYXJ0aWFsbHkg
bW92ZWQgaW50byBjcnlwdG8gQVBJCj4gKEVTU0lWLCBFQk9JViBmb3Igbm93KSwgaXQgYmVjb21l
cyBtdWNoIG1vcmUgY29tcGxpY2F0ZWQgZm9yIHVzZXIgdG8gc2VsZWN0IHdoYXQgaGUgbmVlZHMu
Cj4KPiBJIHRoaW5rIHdlIGhhdmUgbm8gd2F5IHRvIGNoZWNrIHRoYXQgSVYgaXMgYXZhaWxhYmxl
IGZyb20gdXNlcnNwYWNlIC0gaXQKPiB3aWxsIHJlcG9ydCB0aGUgc2FtZSBlcnJvciBhcyBpZiBi
bG9jayBjaXBoZXIgaXMgbm90IGF2YWlsYWJsZSwgbm90IGhlbHBpbmcgdXNlciBtdWNoCj4gd2l0
aCB0aGUgZXJyb3IuCj4KPiBCdXQgdGhlbiBJIGFsc28gdGhpbmsgd2Ugc2hvdWxkIGFkZCBhYnN0
cmFjdCBkbS1jcnlwdCBvcHRpb25zIGhlcmUgKExlZ2FjeSBUcnVlQ3J5cHQgbW9kZXMsCj4gQml0
bG9ja2VyIG1vZGVzKSB0aGF0IHdpbGwgc2VsZWN0IHRoZXNlIGNyeXB0byBBUEkgY29uZmlndXJh
dGlvbiBzd2l0Y2hlcy4KPiBPdGhlcndpc2UgaXQgd2lsbCBiZSBvbmx5IGEgY29tcGxpY2F0ZWQg
bWF0cml4IG9mIGNyeXB0byBBUEkgb3B0aW9ucy4uLgoKaG0uLi4ganVzdCB0aGlua2luZyBvdXQg
bG91ZCwgYnV0IG1heWJlIHRoZSByaWdodCBzYXkgdG8gZ28gaXMgdG8gbm90CmhhdmUgYSBidWls
ZCBkZXBlbmRlbmN5LApidXQgYWRkIHNvbWUgdXNlciBhc3Npc3RhbmNlIGNvZGUgaW4gY3J5cHRv
c2V0dXAgdGhhdCBwYXJzZXMKL3Byb2MvY3J5cHRvIGFmdGVyIGZhaWx1cmVzIHRvCnRyeSBhbmQg
c3VnZ2VzdCB0aGUgdXNlciB3aXRoIGEgd2F5IGZvcndhcmQ/CgplLmcuIGlmIGVib2l2IG1hcHBp
bmcgaW5pdGlhdGlvbiBmYWlscywgc2NhbiAvcHJvYy9jcnlwdG8gYW5kIGVpdGhlcgp3YXJuIG9m
IGEgbGFjayBvZiBBRVMKb3IsIGFzc3VtaW5nIHNvbWUgaW5zdGFuY2Ugb2YgQUVTIGlzIGZvdW5k
LCB3YXJuIG9mIGxhY2sgb2YgRUJPSVYuCkl0J3MgYSBsaXR0bGUgbWVzc3kKYW5kIGhldXJpc3Rp
YyBjb2RlIGZvciBzdXJlLCBidXQgaXQgbGl2ZXMgaW4gYSB1c2VyIHNwYWNlIHV0aWxpdHkuCgpE
b2VzIHRoYXQgc291bmQgc2FuZT8KLS0gCkdpbGFkIEJlbi1Zb3NzZWYKQ2hpZWYgQ29mZmVlIERy
aW5rZXIKCnZhbHVlcyBvZiDOsiB3aWxsIGdpdmUgcmlzZSB0byBkb20hCgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs


Return-Path: <SRS0=G5ov=LP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9C3C4743C
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 14:05:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BBA6561026
	for <dm-devel@archiver.kernel.org>; Mon, 21 Jun 2021 14:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBA6561026
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624284329;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Pa4vaYxatJhRlzMjLed4NL1xNYTCZJffqmuSzpuj0JQ=;
	b=gXusNroei0GYn3TaArbobHva4elxSJeRWM2ZDAA6ny7pcowSrjMn6uwkJOtC9bv/sHsuGI
	a4bGArO/470jHCqPs3khMwgz/zLL+G8RfgqJbefy1SHser5qR0Rn+CuRJ951s23uulQEZ3
	DgUjGPpTmRKQfUt8SONEAMOiLdHO0p4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-lw2gE14TM5SR5kaMS46gRg-1; Mon, 21 Jun 2021 10:05:28 -0400
X-MC-Unique: lw2gE14TM5SR5kaMS46gRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3ECD1B18BC0;
	Mon, 21 Jun 2021 14:05:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0501360C9D;
	Mon, 21 Jun 2021 14:05:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5C6E4EA2A;
	Mon, 21 Jun 2021 14:05:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15LE5Fm1022353 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Jun 2021 10:05:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CC3CE608BA; Mon, 21 Jun 2021 14:05:15 +0000 (UTC)
Received: from T590 (ovpn-12-104.pek2.redhat.com [10.72.12.104])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38A2C60853;
	Mon, 21 Jun 2021 14:04:59 +0000 (UTC)
Date: Mon, 21 Jun 2021 22:04:54 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YNCchke/OxQVnSZA@T590>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-4-ming.lei@redhat.com>
	<5ba43dac-b960-7c85-3a89-fdae2d1e2f51@linux.alibaba.com>
	<YMywCX6nLqLiHXyy@T590>
	<9b42601a-ca54-4748-e592-3720b7994d7b@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <9b42601a-ca54-4748-e592-3720b7994d7b@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [RFC PATCH V2 3/3] dm: support bio polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdW4gMjEsIDIwMjEgYXQgMDc6MzM6MzRQTSArMDgwMCwgSmVmZmxlWHUgd3JvdGU6
Cj4gCj4gCj4gT24gNi8xOC8yMSAxMDozOSBQTSwgTWluZyBMZWkgd3JvdGU6Cj4gPiBGcm9tIDQ3
ZTUyM2I5ZWU5ODgzMTczNjllYWFkYjk2ODI2MzIzY2Q4NjgxOWUgTW9uIFNlcCAxNyAwMDowMDow
MCAyMDAxCj4gPiBGcm9tOiBNaW5nIExlaSA8bWluZy5sZWlAcmVkaGF0LmNvbT4KPiA+IERhdGU6
IFdlZCwgMTYgSnVuIDIwMjEgMTY6MTM6NDYgKzA4MDAKPiA+IFN1YmplY3Q6IFtSRkMgUEFUQ0gg
VjMgMy8zXSBkbTogc3VwcG9ydCBiaW8gcG9sbGluZwo+ID4gCj4gPiBTdXBwb3J0IGJpbyhSRVFf
UE9MTEVEKSBwb2xsaW5nIGluIHRoZSBmb2xsb3dpbmcgYXBwcm9hY2g6Cj4gPiAKPiA+IDEpIG9u
bHkgc3VwcG9ydCBpbyBwb2xsaW5nIG9uIG5vcm1hbCBSRUFEL1dSSVRFLCBhbmQgb3RoZXIgYWJu
b3JtYWwgSU9zCj4gPiBzdGlsbCBmYWxsYmFjayBvbiBJUlEgbW9kZSwgc28gdGhlIHRhcmdldCBp
byBpcyBleGFjdGx5IGluc2lkZSB0aGUgZG0KPiA+IGlvLgo+ID4gCj4gPiAyKSBob2xkIG9uZSBy
ZWZjbnQgb24gaW8tPmlvX2NvdW50IGFmdGVyIHN1Ym1pdHRpbmcgdGhpcyBkbSBiaW8gd2l0aAo+
ID4gUkVRX1BPTExFRAo+ID4gCj4gPiAzKSBzdXBwb3J0IGRtIG5hdGl2ZSBiaW8gc3BsaXR0aW5n
LCBhbnkgZG0gaW8gaW5zdGFuY2UgYXNzb2NpYXRlZCB3aXRoCj4gPiBjdXJyZW50IGJpbyB3aWxs
IGJlIGFkZGVkIGludG8gb25lIGxpc3Qgd2hpY2ggaGVhZCBpcyBiaW8tPmJpX2VuZF9pbwo+ID4g
d2hpY2ggd2lsbCBiZSByZWNvdmVyZWQgYmVmb3JlIGVuZGluZyB0aGlzIGJpbwo+ID4gCj4gPiA0
KSBpbXBsZW1lbnQgLnBvbGxfYmlvKCkgY2FsbGJhY2ssIGNhbGwgYmlvX3BvbGwoKSBvbiB0aGUg
c2luZ2xlIHRhcmdldAo+ID4gYmlvIGluc2lkZSB0aGUgZG0gaW8gd2hpY2ggaXMgcmV0cmlldmVk
IHZpYSBiaW8tPmJpX2Jpb19kcnZfZGF0YTsgY2FsbAo+ID4gZGVjX3BlbmRpbmcoKSBhZnRlciB0
aGUgdGFyZ2V0IGlvIGlzIGRvbmUgaW4gLnBvbGxfYmlvKCkKPiA+IAo+ID4gNCkgZW5hYmxlIFFV
RVVFX0ZMQUdfUE9MTCBpZiBhbGwgdW5kZXJseWluZyBxdWV1ZXMgZW5hYmxlIFFVRVVFX0ZMQUdf
UE9MTCwKPiA+IHdoaWNoIGlzIGJhc2VkIG9uIEplZmZsZSdzIHByZXZpb3VzIHBhdGNoLgo+ID4g
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBNaW5nIExlaSA8bWluZy5sZWlAcmVkaGF0LmNvbT4KPiA+IC0t
LQo+ID4gVjM6Cj4gPiAJLSBjb3ZlcnMgYWxsIGNvbW1lbnRzIGZyb20gSmVmZmxlCj4gPiAJLSBm
aXggY29ybmVyIGNhc2VzIHdoZW4gcG9sbGluZyBvbiBhYm5vcm1hbCBpb3MKPiA+IAo+IC4uLgo+
IAo+IE9uZSBidWcgYW5kIG9uZSBwZXJmb3JtYW5jZSBpc3N1ZSwgdGhvdWdoIEkgaGF2ZW4ndCBp
bnZlc3RpZ2F0ZWQgZGVlcAo+IGZvciBib3RoLgo+IAo+IAo+IGtlcm5lbCBiYXNlOiBiYXNlZCBv
biBKZW5zJyBmb3ItbmV4dCwgYXBwbHlpbmcgQ2hyaXN0b3BoIGFuZCBMZWltaW5nJ3MKPiBwYXRj
aHNldC4KPiAKPiAKPiAxLiBPbmUgYnVnIHdoZW4gdGhlcmUncyBETSBkZXZpY2Ugc3RhY2ssIGUu
Zy4sIGRtLWxpbmVhciB1cG9uIGFub3RoZXIKPiBkbS1saW5lYXIuIENhbiBiZSByZXByb2R1Y2Vk
IGJ5IGZvbGxvd2luZyBzdGVwczoKPiAKPiBgYGAKPiAkIHN1ZG8gZG1zZXR1cCBjcmVhdGUgdG1w
ZGV2IC0tdGFibGUgJzAgMjA5NzE1MiBsaW5lYXIgL2Rldi9udm1lMG4xIDAnCj4gCj4gJCBjYXQg
dG1wLnRhYmxlCj4gMCAyMDk3MTUyIGxpbmVhciAvZGV2L21hcHBlci90bXBkZXYgMAo+IDIwOTcx
NTIgMjA5NzE1MiBsaW5lYXIgL2Rldi9udm1lMG4xIDAKPiAKPiAkIGNhdCB0bXAudGFibGUgfCBk
bXNldHVwIGNyZWF0ZSB0ZXN0ZGV2Cj4gCj4gJCBmaW8gLW5hbWU9dGVzdCAtaW9lbmdpbmU9aW9f
dXJpbmcgLWlvZGVwdGg9MTI4IC1udW1qb2JzPTEgLXRocmVhZAo+IC1ydz1yYW5kcmVhZCAtZGly
ZWN0PTEgLWJzPTRrIC10aW1lX2Jhc2VkIC1ydW50aW1lPTEwIC1jcHVzX2FsbG93ZWQ9Ngo+IC1m
aWxlbmFtZT0vZGV2L21hcHBlci90ZXN0ZGV2IC1oaXByaT0xCj4gYGBgCj4gCj4gCj4gQlVHOiB1
bmFibGUgdG8gaGFuZGxlIHBhZ2UgZmF1bHQgZm9yIGFkZHJlc3M6IGZmZmZmZmZmYzAxYTYyMDgK
PiAjUEY6IHN1cGVydmlzb3Igd3JpdGUgYWNjZXNzIGluIGtlcm5lbCBtb2RlCj4gI1BGOiBlcnJv
cl9jb2RlKDB4MDAwMykgLSBwZXJtaXNzaW9ucyB2aW9sYXRpb24KPiBQR0QgMzk3NDBjMDY3IFA0
RCAzOTc0MGMwNjcgUFVEIDM5NzQwZTA2NyBQTUQgMTAzNWRiMDY3IFBURSAxZGRmNmYwNjEKPiBP
b3BzOiAwMDAzIFsjMV0gU01QIFBUSQo+IENQVTogNiBQSUQ6IDU4OTkgQ29tbTogZmlvIFRhaW50
ZWQ6IEcgUwo+IDUuMTMuMC0wLjEuZ2l0LjgxYmNkYzMuYWw3Lng4Nl82NCAjMQo+IEhhcmR3YXJl
IG5hbWU6IEludmVudGVjICAgICBLOTAwRzMtMTBHL0I5MDBHMywgQklPUyBBMi4yMCAwNi8yMy8y
MDE3Cj4gUklQOiAwMDEwOmRtX3N1Ym1pdF9iaW8rMHgxNzEvMHgzZTAgW2RtX21vZF0KCkl0IGhh
cyBiZWVuIGZpeGVkIGluIG15IGxvY2FsIHJlcG86CgpAQCAtMTYwOCw2ICsxNjQ5LDcgQEAgc3Rh
dGljIHZvaWQgaW5pdF9jbG9uZV9pbmZvKHN0cnVjdCBjbG9uZV9pbmZvICpjaSwgc3RydWN0IG1h
cHBlZF9kZXZpY2UgKm1kLAogICAgICAgIGNpLT5tYXAgPSBtYXA7CiAgICAgICAgY2ktPmlvID0g
YWxsb2NfaW8obWQsIGJpbyk7CiAgICAgICAgY2ktPnNlY3RvciA9IGJpby0+YmlfaXRlci5iaV9z
ZWN0b3I7CisgICAgICAgY2ktPnN1Ym1pdF9hc19wb2xsZWQgPSBmYWxzZTsKCj4gCj4gCj4gMi4g
UGVyZm9ybWFuY2UgSXNzdWUKPiAKPiBJIHRlc3QgYm90aCBvbiB4ODYgKHdpdGggb25seSBvbmUg
TlZNZSkgYW5kIGFhcmNoNjQgKHdpdGggbXVsdGlwbGUgTlZNZXMpLgo+IAo+IFRoZSByZXN1bHQg
KElPUFMpIG9uIHg4NiBpcyBhcyBleHBlY3RlZDoKPiAKPiBUeXBlIAkgIHxJUlEgICB8IFBvbGxp
bmcKPiAtLS0tLS0tLS0gfCAtLS0tIHwgLS0tLQo+IGRtLWxpbmVhciB8IDIzOWsgfCAzNTdrCj4g
Cj4gLSBkbS1saW5lYXIgYnVpbHQgdXBvbiBvbmUgTlZNZe+8jGJzPTRrLCBpb3BvbGw9MSwgaW9k
ZXB0aD0xMjgsCj4gbnVtam9icz0xLCBkaXJlY3QsIHJhbmRyZWFkLCBpb2VuZ2luZT1pb191cmlu
ZwoKVGhpcyBkYXRhIGxvb2tzIGdvb2QuCgo+IAo+IAo+IAo+IFdoaWxlIHRoZSByZXN1bHQgb24g
YWFyY2g2NCBpcyBhIGxpdHRsZSBjb25mdXNpbmcuCj4gCj4gVHlwZSAJICAgICAgfElSUSAgIHwg
UG9sbGluZwo+IC0tLS0tLS0tLS0tLS0gfCAtLS0tIHwgLS0tLQo+IGRtLWxpbmVhciBbMV0gfCAy
MDhrIHwgMjMwawo+IGRtLWxpbmVhciBbMl0gfCA2MzdrIHwgNjkxawo+IGRtLXN0cmlwZSAgICAg
fCAzMTBrIHwgMzU0awo+IAo+IC0gZG0tbGluZWFyIFsxXSBidWlsdCB1cG9uICpvbmUqIE5WTWXv
vIxicz00aywgaW9wb2xsPTEsIGlvZGVwdGg9MTI4LAo+ICpudW1qb2JzPTEqLCBkaXJlY3QsIHJh
bmRyZWFkLCBpb2VuZ2luZT1pb191cmluZwo+IC0gZG0tbGluZWFyIFsyXSBidWlsdCB1cG9uICp0
aHJlZSogTlZNZXPvvIxicz00aywgaW9wb2xsPTEsIGlvZGVwdGg9MTI4LAo+ICpudW1qb2JzPTMq
LCBkaXJlY3QsIHJhbmRyZWFkLCBpb2VuZ2luZT1pb191cmluZwo+IC0gZG0tc3RyaXBlIGJ1aWx0
IHVwb24gKnRocmVlKiBOVk1lc++8jGNodW5rX3NpemU9NGssIGJzPTEyaywgaW9wb2xsPTEsCj4g
aW9kZXB0aD0xMjgsIG51bWpvYnM9MywgZGlyZWN0LCByYW5kcmVhZCwgaW9lbmdpbmU9aW9fdXJp
bmcKPiAKPiAKPiBGb2xsb3dpbmcgaXMgdGhlIGNvcnJlc3BvbmRpbmcgdGVzdCByZXN1bHQgb2Yg
TGVpbWluZydzIGxhc3QKPiBpbXBsZW1lbnRhdGlvbiBmb3IgYmlvLWJhc2VkIHBvbGxpbmcgb24g
YWFyY2g2NC4KPiBJUlEJSU9QT0xMCXJhdGlvCj4gZG0tbGluZWFyIFsyXQk2MzlLCTgzNUsJfjMw
JQo+IGRtLXN0cmlwZSAJMzE0Swk0MDhLCX4zMCUKClRoZSBwcmV2aW91cyB2ZXJzaW9uIHBvbGxz
IG9uZSBodyBxdWV1ZSBvbmNlIGlmIGJpb3MgYXJlIHN1Ym1pdHRlZCB0bwpzYW1lIGh3IHF1ZXVl
LiBXZSBtaWdodCBpbXByb3ZlIGl0IGluIGZ1dHVyZS4KCgpUaGFua3MsCk1pbmcKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


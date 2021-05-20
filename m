Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0308C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 05:50:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 73B0B611BD
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 05:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73B0B611BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-JPe3vJUyOXK9qgwcGoQuOg-1; Thu, 20 May 2021 01:50:42 -0400
X-MC-Unique: JPe3vJUyOXK9qgwcGoQuOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94B53180FD6C;
	Thu, 20 May 2021 05:50:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53DCA10246F1;
	Thu, 20 May 2021 05:50:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 04A41180B464;
	Thu, 20 May 2021 05:50:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K5nd2g014590 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 01:49:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5870711701D2; Thu, 20 May 2021 05:49:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53E7110DCF7D
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:49:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E654E858F0D
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:49:36 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-514-UUIWah2DM8SY-CdAPng9fg-1;
	Thu, 20 May 2021 01:49:32 -0400
X-MC-Unique: UUIWah2DM8SY-CdAPng9fg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 77D53AF95;
	Thu, 20 May 2021 05:49:30 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-2-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <de53c430-6eaf-ad09-73be-771f243decab@suse.de>
Date: Thu, 20 May 2021 07:49:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520042228.974083-2-damien.lemoal@wdc.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K5nd2g014590
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 01/11] block: improve handling of all
 zones reset operation
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
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMC8yMSA2OjIyIEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBTQ1NJLCBaTlMgYW5k
IG51bGxfYmxrIHpvbmVkIGRldmljZXMgc3VwcG9ydCByZXNldHRpbmcgYWxsIHpvbmVzIHVzaW5n
Cj4gYSBzaW5nbGUgY29tbWFuZCAoUkVRX09QX1pPTkVfUkVTRVRfQUxMKSwgYXMgaW5kaWNhdGVk
IHVzaW5nIHRoZSBkZXZpY2UKPiByZXF1ZXN0IHF1ZXVlIGZsYWcgUVVFVUVfRkxBR19aT05FX1JF
U0VUQUxMLiBUaGlzIGZsYWcgaXMgbm90IHNldCBmb3IKPiBkZXZpY2UgbWFwcGVyIHRhcmdldHMg
Y3JlYXRpbmcgem9uZWQgZGV2aWNlcy4gSW4gdGhpcyBjYXNlLCBhIHVzZXIKPiByZXF1ZXN0IGZv
ciByZXNldHRpbmcgYWxsIHpvbmVzIG9mIGEgZGV2aWNlIGlzIHByb2Nlc3NlZCBpbgo+IGJsa2Rl
dl96b25lX21nbXQoKSBieSBpc3N1aW5nIGEgUkVRX09QX1pPTkVfUkVTRVQgb3BlcmF0aW9uIGZv
ciBlYWNoCj4gem9uZSBvZiB0aGUgZGV2aWNlLiBUaGlzIGxlYWRzIHRvIGRpZmZlcmVudCBiZWhh
dmlvcnMgb2YgdGhlCj4gQkxLUkVTRVRaT05FIGlvY3RsKCkgZGVwZW5kaW5nIG9uIHRoZSB0YXJn
ZXQgZGV2aWNlIHN1cHBvcnQgZm9yIHRoZQo+IHJlc2V0IGFsbCBvcGVyYXRpb24uIEUuZy4KPiAK
PiBibGt6b25lIHJlc2V0IC9kZXYvc2RYCj4gCj4gd2lsbCByZXNldCBhbGwgem9uZXMgb2YgYSBT
Q1NJIGRldmljZSB1c2luZyBhIHNpbmdsZSBjb21tYW5kIHRoYXQgd2lsbAo+IGlnbm9yZSBjb252
ZW50aW9uYWwsIHJlYWQtb25seSBvciBvZmZsaW5lIHpvbmVzLgo+IAo+IEJ1dCBhIGRtLWxpbmVh
ciBkZXZpY2UgaW5jbHVkaW5nIGNvbnZlbnRpb25hbCwgcmVhZC1vbmx5IG9yIG9mZmxpbmUKPiB6
b25lcyBjYW5ub3QgYmUgcmVzZXQgaW4gdGhlIHNhbWUgbWFubmVyIGFzIHNvbWUgb2YgdGhlIHNp
bmdsZSB6b25lCj4gcmVzZXQgb3BlcmF0aW9ucyBpc3N1ZWQgYnkgYmxrZGV2X3pvbmVfbWdtdCgp
IHdpbGwgZmFpbC4gRS5nLjoKPiAKPiBibGt6b25lIHJlc2V0IC9kZXYvZG0tWQo+IGJsa3pvbmU6
IC9kZXYvZG0tMDogQkxLUkVTRVRaT05FIGlvY3RsIGZhaWxlZDogUmVtb3RlIEkvTyBlcnJvcgo+
IAo+IFRvIHNpbXBsaWZ5IGFwcGxpY2F0aW9ucyBhbmQgdG9vbHMgZGV2ZWxvcG1lbnQsIHVuaWZ5
IHRoZSBiZWhhdmlvciBvZgo+IHRoZSBhbGwtem9uZSByZXNldCBvcGVyYXRpb24gYnkgbW9kaWZ5
aW5nIGJsa2Rldl96b25lX21nbXQoKSB0byBub3QKPiBpc3N1ZSBhIHpvbmUgcmVzZXQgb3BlcmF0
aW9uIGZvciBjb252ZW50aW9uYWwsIHJlYWQtb25seSBhbmQgb2ZmbGluZQo+IHpvbmVzLCB0aHVz
IG1pbWlja2luZyB3aGF0IGFuIGFjdHVhbCByZXNldC1hbGwgZGV2aWNlIGNvbW1hbmQgZG9lcyBv
biBhCj4gZGV2aWNlIHN1cHBvcnRpbmcgUkVRX09QX1pPTkVfUkVTRVRfQUxMLiBUaGlzIGVtdWxh
dGlvbiBpcyBkb25lIHVzaW5nCj4gdGhlIG5ldyBmdW5jdGlvbiBibGtkZXZfem9uZV9yZXNldF9h
bGxfZW11bGF0ZWQoKS4gVGhlIHpvbmVzIG5lZWRpbmcgYQo+IHJlc2V0IGFyZSBpZGVudGlmaWVk
IHVzaW5nIGEgYml0bWFwIHRoYXQgaXMgaW5pdGlhbGl6ZWQgdXNpbmcgYSB6b25lCj4gcmVwb3J0
LiBTaW5jZSBlbXB0eSB6b25lcyBkbyBub3QgbmVlZCBhIHJlc2V0LCBhbHNvIGlnbm9yZSB0aGVz
ZSB6b25lcy4KPiBUaGUgZnVuY3Rpb24gYmxrZGV2X3pvbmVfcmVzZXRfYWxsKCkgaXMgaW50cm9k
dWNlZCBmb3IgYmxvY2sgZGV2aWNlcwo+IG5hdGl2ZWx5IHN1cHBvcnRpbmcgcmVzZXQgYWxsIG9w
ZXJhdGlvbnMuIGJsa2Rldl96b25lX21nbXQoKSBpcyBtb2RpZmllZAo+IHRvIGNhbGwgZWl0aGVy
IGZ1bmN0aW9uIHRvIGV4ZWN1dGUgYW4gYWxsIHpvbmUgcmVzZXQgcmVxdWVzdC4KPiAKPiBTaWdu
ZWQtb2ZmLWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMuY29tPgo+IFtoY2g6
IHNwbGl0IGludG8gbXVsdGlwbGUgZnVuY3Rpb25zXQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxvY2svYmxrLXpvbmVkLmMgfCAxMTcg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQo+ICAgMSBmaWxl
IGNoYW5nZWQsIDkwIGluc2VydGlvbnMoKyksIDI3IGRlbGV0aW9ucygtKQo+IFJldmlld2VkLWJ5
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIu
IEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QK
aGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2
ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8
cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4
IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


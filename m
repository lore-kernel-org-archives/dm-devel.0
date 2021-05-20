Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB2EC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:14:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 67A8261184
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67A8261184
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-oYO9YW-ZPz2vMfWliSXMpw-1; Thu, 20 May 2021 02:14:03 -0400
X-MC-Unique: oYO9YW-ZPz2vMfWliSXMpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 206B4180FD6A;
	Thu, 20 May 2021 06:13:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1E665C224;
	Thu, 20 May 2021 06:13:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C648EA6EC;
	Thu, 20 May 2021 06:13:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K6BGQb016446 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 02:11:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A0261205D6C3; Thu, 20 May 2021 06:11:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B10D205D6C1
	for <dm-devel@redhat.com>; Thu, 20 May 2021 06:11:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 415A6185A79C
	for <dm-devel@redhat.com>; Thu, 20 May 2021 06:11:13 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-373-_Q9jaxJcNa-OoLGUbgDTYQ-1;
	Thu, 20 May 2021 02:11:08 -0400
X-MC-Unique: _Q9jaxJcNa-OoLGUbgDTYQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id EA311B0BF;
	Thu, 20 May 2021 06:11:06 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-12-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <05855613-eb08-768e-37cb-07e19946f22f@suse.de>
Date: Thu, 20 May 2021 08:11:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520042228.974083-12-damien.lemoal@wdc.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K6BGQb016446
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 11/11] dm crypt: Fix zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMC8yMSA2OjIyIEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBab25lIGFwcGVuZCBC
SU9zIChSRVFfT1BfWk9ORV9BUFBFTkQpIGFsd2F5cyBzcGVjaWZ5IHRoZSBzdGFydCBzZWN0b3IK
PiBvZiB0aGUgem9uZSB0byBiZSB3cml0dGVuIGluc3RlYWQgb2YgdGhlIGFjdHVhbCBzZWN0b3Ig
bG9jYXRpb24gdG8KPiB3cml0ZS4gVGhlIHdyaXRlIGxvY2F0aW9uIGlzIGRldGVybWluZWQgYnkg
dGhlIGRldmljZSBhbmQgcmV0dXJuZWQgdG8KPiB0aGUgaG9zdCB1cG9uIGNvbXBsZXRpb24gb2Yg
dGhlIG9wZXJhdGlvbi4gVGhpcyBpbnRlcmZhY2UsIHdoaWxlIHNpbXBsZQo+IGFuZCBlZmZpY2ll
bnQgZm9yIHdyaXRpbmcgaW50byBzZXF1ZW50aWFsIHpvbmVzIG9mIGEgem9uZWQgYmxvY2sKPiBk
ZXZpY2UsIGlzIGluY29tcGF0aWJsZSB3aXRoIHRoZSB1c2Ugb2Ygc2VjdG9yIHZhbHVlcyB0byBj
YWxjdWxhdGUgYQo+IGN5cGhlciBibG9jayBJVi4gQWxsIGRhdGEgd3JpdHRlbiBpbiBhIHpvbmUg
ZW5kIHVwIHVzaW5nIHRoZSBzYW1lIElWCj4gdmFsdWVzIGNvcnJlc3BvbmRpbmcgdG8gdGhlIGZp
cnN0IHNlY3RvcnMgb2YgdGhlIHpvbmUsIGJ1dCByZWFkCj4gb3BlcmF0aW9uIHdpbGwgc3BlY2lm
eSBhbnkgc2VjdG9yIHdpdGhpbiB0aGUgem9uZSByZXN1bHRpbmcgaW4gYW4gSVYKPiBtaXNtYXRj
aCBiZXR3ZWVuIGVuY3J5cHRpb24gYW5kIGRlY3J5cHRpb24uCj4gCj4gVG8gc29sdmUgdGhpcyBw
cm9ibGVtLCByZXBvcnQgdG8gRE0gY29yZSB0aGF0IHpvbmUgYXBwZW5kIG9wZXJhdGlvbnMgYXJl
Cj4gbm90IHN1cHBvcnRlZC4gVGhpcyByZXN1bHQgaW4gdGhlIHpvbmUgYXBwZW5kIG9wZXJhdGlv
bnMgYmVpbmcgZW11bGF0ZWQKPiB1c2luZyByZWd1bGFyIHdyaXRlIG9wZXJhdGlvbnMuCj4gCj4g
UmVwb3J0ZWQtYnk6IFNoaW4naWNoaXJvIEthd2FzYWtpIDxzaGluaWNoaXJvLmthd2FzYWtpQHdk
Yy5jb20+Cj4gU2lnbmVkLW9mZi1ieTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxAd2Rj
LmNvbT4KPiAtLS0KPiAgIGRyaXZlcnMvbWQvZG0tY3J5cHQuYyB8IDI0ICsrKysrKysrKysrKysr
KysrKystLS0tLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDUgZGVsZXRp
b25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYyBiL2RyaXZlcnMv
bWQvZG0tY3J5cHQuYwo+IGluZGV4IGY0MTBjZWVlNTFkNy4uNTBmNGNiZDYwMGQ1IDEwMDY0NAo+
IC0tLSBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+ICsrKyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQu
Ywo+IEBAIC0zMjgwLDE0ICszMjgwLDI4IEBAIHN0YXRpYyBpbnQgY3J5cHRfY3RyKHN0cnVjdCBk
bV90YXJnZXQgKnRpLCB1bnNpZ25lZCBpbnQgYXJnYywgY2hhciAqKmFyZ3YpCj4gICAJfQo+ICAg
CWNjLT5zdGFydCA9IHRtcGxsOwo+ICAgCj4gLQkvKgo+IC0JICogRm9yIHpvbmVkIGJsb2NrIGRl
dmljZXMsIHdlIG5lZWQgdG8gcHJlc2VydmUgdGhlIGlzc3VlciB3cml0ZQo+IC0JICogb3JkZXJp
bmcuIFRvIGRvIHNvLCBkaXNhYmxlIHdyaXRlIHdvcmtxdWV1ZXMgYW5kIGZvcmNlIGlubGluZQo+
IC0JICogZW5jcnlwdGlvbiBjb21wbGV0aW9uLgo+IC0JICovCj4gICAJaWYgKGJkZXZfaXNfem9u
ZWQoY2MtPmRldi0+YmRldikpIHsKPiArCQkvKgo+ICsJCSAqIEZvciB6b25lZCBibG9jayBkZXZp
Y2VzLCB3ZSBuZWVkIHRvIHByZXNlcnZlIHRoZSBpc3N1ZXIgd3JpdGUKPiArCQkgKiBvcmRlcmlu
Zy4gVG8gZG8gc28sIGRpc2FibGUgd3JpdGUgd29ya3F1ZXVlcyBhbmQgZm9yY2UgaW5saW5lCj4g
KwkJICogZW5jcnlwdGlvbiBjb21wbGV0aW9uLgo+ICsJCSAqLwo+ICAgCQlzZXRfYml0KERNX0NS
WVBUX05PX1dSSVRFX1dPUktRVUVVRSwgJmNjLT5mbGFncyk7Cj4gICAJCXNldF9iaXQoRE1fQ1JZ
UFRfV1JJVEVfSU5MSU5FLCAmY2MtPmZsYWdzKTsKPiArCj4gKwkJLyoKPiArCQkgKiBBbGwgem9u
ZSBhcHBlbmQgd3JpdGVzIHRvIGEgem9uZSBvZiBhIHpvbmVkIGJsb2NrIGRldmljZSB3aWxsCj4g
KwkJICogaGF2ZSB0aGUgc2FtZSBCSU8gc2VjdG9yLCB0aGUgc3RhcnQgb2YgdGhlIHpvbmUuIFdo
ZW4gdGhlCj4gKwkJICogY3lwaGVyIElWIG1vZGUgdXNlcyBzZWN0b3IgdmFsdWVzLCBhbGwgZGF0
YSB0YXJnZXRpbmcgYQo+ICsJCSAqIHpvbmUgd2lsbCBiZSBlbmNyeXB0ZWQgdXNpbmcgdGhlIGZp
cnN0IHNlY3RvciBudW1iZXJzIG9mIHRoZQo+ICsJCSAqIHpvbmUuIFRoaXMgd2lsbCBub3QgcmVz
dWx0IGluIHdyaXRlIGVycm9ycyBidXQgd2lsbAo+ICsJCSAqIGNhdXNlIG1vc3QgcmVhZHMgdG8g
ZmFpbCBhcyByZWFkcyB3aWxsIHVzZSB0aGUgc2VjdG9yIHZhbHVlcwo+ICsJCSAqIGZvciB0aGUg
YWN0dWFsIGRhdGEgbG9jYXRpb25zLCByZXN1bHRpbmcgaW4gSVYgbWlzbWF0Y2guCj4gKwkJICog
VG8gYXZvaWQgdGhpcyBwcm9ibGVtLCBhc2sgRE0gY29yZSB0byBlbXVsYXRlIHpvbmUgYXBwZW5k
Cj4gKwkJICogb3BlcmF0aW9ucyB3aXRoIHJlZ3VsYXIgd3JpdGVzLgo+ICsJCSAqLwo+ICsJCURN
REVCVUcoIlpvbmUgYXBwZW5kIG9wZXJhdGlvbnMgd2lsbCBiZSBlbXVsYXRlZCIpOwo+ICsJCXRp
LT5lbXVsYXRlX3pvbmVfYXBwZW5kID0gdHJ1ZTsKPiAgIAl9Cj4gICAKPiAgIAlpZiAoY3J5cHRf
aW50ZWdyaXR5X2FlYWQoY2MpIHx8IGNjLT5pbnRlZ3JpdHlfaXZfc2l6ZSkgewo+IApSZXZpZXdl
ZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0g
CkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0
ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQw
NTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5
IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBG
ZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs


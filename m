Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F1BC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:48:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F4036611BE
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:48:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F4036611BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-f7CmWpFpNceS45y9y6pwMQ-1; Thu, 20 May 2021 02:48:07 -0400
X-MC-Unique: f7CmWpFpNceS45y9y6pwMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50EEF801106;
	Thu, 20 May 2021 06:48:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA5C55C1A1;
	Thu, 20 May 2021 06:48:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5FFF44A58;
	Thu, 20 May 2021 06:48:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K6ld5J020333 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 02:47:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D940F202BFC1; Thu, 20 May 2021 06:47:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3DC7213349D
	for <dm-devel@redhat.com>; Thu, 20 May 2021 06:47:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EE42185A79C
	for <dm-devel@redhat.com>; Thu, 20 May 2021 06:47:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-505-HACbdl8vNV23qiUDQR1rtA-1;
	Thu, 20 May 2021 02:47:33 -0400
X-MC-Unique: HACbdl8vNV23qiUDQR1rtA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 8136DB137;
	Thu, 20 May 2021 06:47:31 +0000 (UTC)
To: Damien Le Moal <Damien.LeMoal@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-11-damien.lemoal@wdc.com>
	<68203e46-01bc-011c-ab8e-9c94ca60adce@suse.de>
	<DM6PR04MB7081B70FFD57914608B0349AE72A9@DM6PR04MB7081.namprd04.prod.outlook.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <be8be72c-0272-2969-ec46-ebb01db9d2ca@suse.de>
Date: Thu, 20 May 2021 08:47:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB7081B70FFD57914608B0349AE72A9@DM6PR04MB7081.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K6ld5J020333
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 10/11] dm: introduce zone append emulation
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

T24gNS8yMC8yMSA4OjI1IEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBPbiAyMDIxLzA1LzIw
IDE1OjEwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4gWy4uLl0KPj4+ICsvKgo+Pj4gKyAqIEZp
cnN0IHBoYXNlIG9mIEJJTyBtYXBwaW5nIGZvciB0YXJnZXRzIHdpdGggem9uZSBhcHBlbmQgZW11
bGF0aW9uOgo+Pj4gKyAqIGNoZWNrIGFsbCBCSU8gdGhhdCBjaGFuZ2UgYSB6b25lIHdyaXRlciBw
b2ludGVyIGFuZCBjaGFuZ2Ugem9uZQo+Pj4gKyAqIGFwcGVuZCBvcGVyYXRpb25zIGludG8gcmVn
dWxhciB3cml0ZSBvcGVyYXRpb25zLgo+Pj4gKyAqLwo+Pj4gK3N0YXRpYyBib29sIGRtX3pvbmVf
bWFwX2Jpb19iZWdpbihzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQsCj4+PiArCQkJCSAgc3RydWN0
IGJpbyAqb3JpZ19iaW8sIHN0cnVjdCBiaW8gKmNsb25lKQo+Pj4gK3sKPj4+ICsJc2VjdG9yX3Qg
em9uZV9zZWN0b3JzID0gYmxrX3F1ZXVlX3pvbmVfc2VjdG9ycyhtZC0+cXVldWUpOwo+Pj4gKwl1
bnNpZ25lZCBpbnQgem5vID0gYmlvX3pvbmVfbm8ob3JpZ19iaW8pOwo+Pj4gKwl1bnNpZ25lZCBs
b25nIGZsYWdzOwo+Pj4gKwlib29sIGdvb2RfaW8gPSBmYWxzZTsKPj4+ICsKPj4+ICsJc3Bpbl9s
b2NrX2lycXNhdmUoJm1kLT56d3Bfb2Zmc2V0X2xvY2ssIGZsYWdzKTsKPj4+ICsKPj4+ICsJLyoK
Pj4+ICsJICogSWYgdGhlIHRhcmdldCB6b25lIGlzIGluIGFuIGVycm9yIHN0YXRlLCByZWNvdmVy
IGJ5IGluc3BlY3RpbmcgdGhlCj4+PiArCSAqIHpvbmUgdG8gZ2V0IGl0cyBjdXJyZW50IHdyaXRl
IHBvaW50ZXIgcG9zaXRpb24uIE5vdGUgdGhhdCBzaW5jZSB0aGUKPj4+ICsJICogdGFyZ2V0IHpv
bmUgaXMgYWxyZWFkeSBsb2NrZWQsIGEgQklPIGlzc3VpbmcgY29udGV4dCBzaG91bGQgbmV2ZXIK
Pj4+ICsJICogc2VlIHRoZSB6b25lIHdyaXRlIGluIHRoZSBETV9aT05FX1VQREFUSU5HX1dQX09G
U1Qgc3RhdGUuCj4+PiArCSAqLwo+Pj4gKwlpZiAobWQtPnp3cF9vZmZzZXRbem5vXSA9PSBETV9a
T05FX0lOVkFMSURfV1BfT0ZTVCkgewo+Pj4gKwkJdW5zaWduZWQgaW50IHdwX29mZnNldDsKPj4+
ICsJCWludCByZXQ7Cj4+PiArCj4+PiArCQltZC0+endwX29mZnNldFt6bm9dID0gRE1fWk9ORV9V
UERBVElOR19XUF9PRlNUOwo+Pj4gKwo+Pj4gKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmbWQt
Pnp3cF9vZmZzZXRfbG9jaywgZmxhZ3MpOwo+Pj4gKwkJcmV0ID0gZG1fdXBkYXRlX3pvbmVfd3Bf
b2Zmc2V0KG1kLCB6bm8sICZ3cF9vZmZzZXQpOwo+Pj4gKwkJc3Bpbl9sb2NrX2lycXNhdmUoJm1k
LT56d3Bfb2Zmc2V0X2xvY2ssIGZsYWdzKTsKPj4+ICsKPj4+ICsJCWlmIChyZXQpIHsKPj4+ICsJ
CQltZC0+endwX29mZnNldFt6bm9dID0gRE1fWk9ORV9JTlZBTElEX1dQX09GU1Q7Cj4+PiArCQkJ
Z290byBvdXQ7Cj4+PiArCQl9Cj4+PiArCQltZC0+endwX29mZnNldFt6bm9dID0gd3Bfb2Zmc2V0
Owo+Pj4gKwl9IGVsc2UgaWYgKG1kLT56d3Bfb2Zmc2V0W3pub10gPT0gRE1fWk9ORV9VUERBVElO
R19XUF9PRlNUKSB7Cj4+PiArCQlETVdBUk5fTElNSVQoIkludmFsaWQgRE1fWk9ORV9VUERBVElO
R19XUF9PRlNUIHN0YXRlIik7Cj4+PiArCQlnb3RvIG91dDsKPj4+ICsJfQo+Pj4gKwo+Pj4gKwlz
d2l0Y2ggKGJpb19vcChvcmlnX2JpbykpIHsKPj4+ICsJY2FzZSBSRVFfT1BfV1JJVEVfWkVST0VT
Ogo+Pj4gKwljYXNlIFJFUV9PUF9XUklURV9TQU1FOgo+Pj4gKwljYXNlIFJFUV9PUF9XUklURToK
Pj4+ICsJCWJyZWFrOwo+Pj4gKwljYXNlIFJFUV9PUF9aT05FX1JFU0VUOgo+Pj4gKwljYXNlIFJF
UV9PUF9aT05FX0ZJTklTSDoKPj4+ICsJCWdvdG8gZ29vZDsKPj4+ICsJY2FzZSBSRVFfT1BfWk9O
RV9BUFBFTkQ6Cj4+PiArCQkvKgo+Pj4gKwkJICogQ2hhbmdlIHpvbmUgYXBwZW5kIG9wZXJhdGlv
bnMgaW50byBhIG5vbi1tZXJnZWFibGUgcmVndWxhcgo+Pj4gKwkJICogd3JpdGVzIGRpcmVjdGVk
IGF0IHRoZSBjdXJyZW50IHdyaXRlIHBvaW50ZXIgcG9zaXRpb24gb2YgdGhlCj4+PiArCQkgKiB0
YXJnZXQgem9uZS4KPj4+ICsJCSAqLwo+Pj4gKwkJY2xvbmUtPmJpX29wZiA9IFJFUV9PUF9XUklU
RSB8IFJFUV9OT01FUkdFIHwKPj4+ICsJCQkob3JpZ19iaW8tPmJpX29wZiAmICh+UkVRX09QX01B
U0spKTsKPj4+ICsJCWNsb25lLT5iaV9pdGVyLmJpX3NlY3RvciA9Cj4+PiArCQkJb3JpZ19iaW8t
PmJpX2l0ZXIuYmlfc2VjdG9yICsgbWQtPnp3cF9vZmZzZXRbem5vXTsKPj4+ICsJCWJyZWFrOwo+
Pj4gKwlkZWZhdWx0Ogo+Pj4gKwkJRE1XQVJOX0xJTUlUKCJJbnZhbGlkIEJJTyBvcGVyYXRpb24i
KTsKPj4+ICsJCWdvdG8gb3V0Owo+Pj4gKwl9Cj4+PiArCj4+PiArCS8qIENhbm5vdCB3cml0ZSB0
byBhIGZ1bGwgem9uZSAqLwo+Pj4gKwlpZiAobWQtPnp3cF9vZmZzZXRbem5vXSA+PSB6b25lX3Nl
Y3RvcnMpCj4+PiArCQlnb3RvIG91dDsKPj4+ICsKPj4+ICsJLyogV3JpdGVzIG11c3QgYmUgYWxp
Z25lZCB0byB0aGUgem9uZSB3cml0ZSBwb2ludGVyICovCj4+PiArCWlmICgoY2xvbmUtPmJpX2l0
ZXIuYmlfc2VjdG9yICYgKHpvbmVfc2VjdG9ycyAtIDEpKSAhPSBtZC0+endwX29mZnNldFt6bm9d
KQo+Pj4gKwkJZ290byBvdXQ7Cj4+PiArCj4+PiArZ29vZDoKPj4+ICsJZ29vZF9pbyA9IHRydWU7
Cj4+PiArCj4+PiArb3V0Ogo+Pj4gKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZtZC0+endwX29m
ZnNldF9sb2NrLCBmbGFncyk7Cj4+Cj4+IEknbSBub3QgaGFwcHkgd2l0aCB0aGUgc3BpbmxvY2su
IENhbid0IHRoZSBzYW1lIGVmZmVjdCBiZSBhY2hpZXZlZCB3aXRoCj4+IHNvbWUgY2xldmVyIFJF
QURfT05DRSgpL1dSSVRFX09OQ0UvY21wZXhjaCBtYWdpYz8KPj4gRXNwZWNpYWxseSBhcyB5b3Ug
aGF2ZSBhIHNlcGFyYXRlICd6b25lIGxvY2snIG1lY2hhbmlzbSAuLi4KPiAKPiBobW1tLi4uIExl
dCBtZSBzZWUuIEdpdmVuIHRoYXQgd2hhdCB0aGUgYmlvIGNvbXBsZXRpb24gaXMgcmVsYXRpdmVs
eSBzaW1wbGUsIGl0Cj4gbWF5IGJlIHBvc3NpYmxlLiBXaXRoIG1vcmUgY29mZmVlLCBJIGFteSBi
ZSBhYmxlIHRvIGNvbWUgdXAgd2l0aCBzb21ldGhpbmcgY2xldmVyLgo+IApNb3JlIGNvZmZlZSBp
cyBhbHdheXMgYSBnb29kIGlkZWEgOi0pCkkgd291bGQgbG9vayBhdCBraWxsaW5nIHRoZSBpbnRl
cm1lZGlhdGUgc3RhdGUgVVBEQVRJTkdfV1BfT0ZTVCBhbmQgb25seSAKdXBkYXRlIHRoZSBwb2lu
dGVyIG9uIGVuZGlvIChvciBpZiBpdCBmYWlsZWQpLgpUaGF0IHdheSB3ZSB3b3VsZCBuZWVkIHRv
IHVwZGF0ZSB0aGUgcG9pbnRlciBvbmx5IG9uY2UgaWYgd2UgaGF2ZSBhIApmaW5hbCBzdGF0ZSwg
YW5kIGRvbid0IG5lZWQgdG8gZG8gdGhlIGRvdWJsZSB1cGRhdGUgeW91IGFyZSBkb2luZyBub3cu
Cgo+Pgo+Pj4gKwo+Pj4gKwlyZXR1cm4gZ29vZF9pbzsKPj4+ICt9Cj4+PiArCj4+PiArLyoKPj4+
ICsgKiBTZWNvbmQgcGhhc2Ugb2YgQklPIG1hcHBpbmcgZm9yIHRhcmdldHMgd2l0aCB6b25lIGFw
cGVuZCBlbXVsYXRpb246Cj4+PiArICogdXBkYXRlIHRoZSB6b25lIHdyaXRlIHBvaW50ZXIgb2Zm
c2V0IGFycmF5IHRvIGFjY291bnQgZm9yIHRoZSBhZGRpdGlvbmFsCj4+PiArICogZGF0YSB3cml0
dGVuIHRvIGEgem9uZS4gTm90ZSB0aGF0IGF0IHRoaXMgcG9pbnQsIHRoZSByZW1hcHBlZCBjbG9u
ZSBCSU8KPj4+ICsgKiBtYXkgYWxyZWFkeSBoYXZlIGNvbXBsZXRlZCwgc28gd2UgZG8gbm90IHRv
dWNoIGl0Lgo+Pj4gKyAqLwo+Pj4gK3N0YXRpYyBibGtfc3RhdHVzX3QgZG1fem9uZV9tYXBfYmlv
X2VuZChzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQsCj4+PiArCQkJCQlzdHJ1Y3QgYmlvICpvcmln
X2JpbywKPj4+ICsJCQkJCXVuc2lnbmVkIGludCBucl9zZWN0b3JzKQo+Pj4gK3sKPj4+ICsJdW5z
aWduZWQgaW50IHpubyA9IGJpb196b25lX25vKG9yaWdfYmlvKTsKPj4+ICsJYmxrX3N0YXR1c190
IHN0cyA9IEJMS19TVFNfT0s7Cj4+PiArCXVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4+PiArCj4+PiAr
CXNwaW5fbG9ja19pcnFzYXZlKCZtZC0+endwX29mZnNldF9sb2NrLCBmbGFncyk7Cj4+PiArCj4+
PiArCS8qIFVwZGF0ZSB0aGUgem9uZSB3cCBvZmZzZXQgKi8KPj4+ICsJc3dpdGNoIChiaW9fb3Ao
b3JpZ19iaW8pKSB7Cj4+PiArCWNhc2UgUkVRX09QX1pPTkVfUkVTRVQ6Cj4+PiArCQltZC0+endw
X29mZnNldFt6bm9dID0gMDsKPj4+ICsJCWJyZWFrOwo+Pj4gKwljYXNlIFJFUV9PUF9aT05FX0ZJ
TklTSDoKPj4+ICsJCW1kLT56d3Bfb2Zmc2V0W3pub10gPSBibGtfcXVldWVfem9uZV9zZWN0b3Jz
KG1kLT5xdWV1ZSk7Cj4+PiArCQlicmVhazsKPj4+ICsJY2FzZSBSRVFfT1BfV1JJVEVfWkVST0VT
Ogo+Pj4gKwljYXNlIFJFUV9PUF9XUklURV9TQU1FOgo+Pj4gKwljYXNlIFJFUV9PUF9XUklURToK
Pj4+ICsJCW1kLT56d3Bfb2Zmc2V0W3pub10gKz0gbnJfc2VjdG9yczsKPj4+ICsJCWJyZWFrOwo+
Pj4gKwljYXNlIFJFUV9PUF9aT05FX0FQUEVORDoKPj4+ICsJCS8qCj4+PiArCQkgKiBDaGVjayB0
aGF0IHRoZSB0YXJnZXQgZGlkIG5vdCB0cnVuY2F0ZSB0aGUgd3JpdGUgb3BlcmF0aW9uCj4+PiAr
CQkgKiBlbXVsYXRpbmcgYSB6b25lIGFwcGVuZC4KPj4+ICsJCSAqLwo+Pj4gKwkJaWYgKG5yX3Nl
Y3RvcnMgIT0gYmlvX3NlY3RvcnMob3JpZ19iaW8pKSB7Cj4+PiArCQkJRE1XQVJOX0xJTUlUKCJU
cnVuY2F0ZWQgd3JpdGUgZm9yIHpvbmUgYXBwZW5kIik7Cj4+PiArCQkJc3RzID0gQkxLX1NUU19J
T0VSUjsKPj4+ICsJCQlicmVhazsKPj4+ICsJCX0KPj4+ICsJCW1kLT56d3Bfb2Zmc2V0W3pub10g
Kz0gbnJfc2VjdG9yczsKPj4+ICsJCWJyZWFrOwo+Pj4gKwlkZWZhdWx0Ogo+Pj4gKwkJRE1XQVJO
X0xJTUlUKCJJbnZhbGlkIEJJTyBvcGVyYXRpb24iKTsKPj4+ICsJCXN0cyA9IEJMS19TVFNfSU9F
UlI7Cj4+PiArCQlicmVhazsKPj4+ICsJfQo+Pj4gKwo+Pj4gKwlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZtZC0+endwX29mZnNldF9sb2NrLCBmbGFncyk7Cj4+Cj4+IFlvdSBkb24ndCBuZWVkIHRo
ZSBzcGlubG9jayBoZXJlOyB1c2luZyBXUklURV9PTkNFKCkgc2hvdWxkIGJlIHN1ZmZpY2llbnQu
Cj4gCj4gSWYgb3RoZXIgcmVmZXJlbmNlcyB0byB6d3Bfb2Zmc2V0IHVzZSBSRUFEX09OQ0UoKSwg
bm8gPwo+IApXaHksIGJ1dCBvZiBjb3Vyc2UuCklmIHlvdSB0b3VjaCBvbmUgeW91IGhhdmUgdG8g
dG91Y2ggYWxsIDotKQoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAg
ICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNv
bHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChB
RyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


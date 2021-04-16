Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F519C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 14:08:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A65E610FC
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 14:08:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A65E610FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-kfg6ixp0M--dVkCHV_svaw-1; Fri, 16 Apr 2021 10:08:47 -0400
X-MC-Unique: kfg6ixp0M--dVkCHV_svaw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A1EE18397B5;
	Fri, 16 Apr 2021 14:08:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 444105D6D3;
	Fri, 16 Apr 2021 14:08:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D10D844A5B;
	Fri, 16 Apr 2021 14:08:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GE89RJ032730 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 10:08:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CB62310547B4; Fri, 16 Apr 2021 14:08:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C698010547B6
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 14:08:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A64E284853B
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 14:08:05 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-144-phB43e_kN7mF7cuP8RHbhw-1;
	Fri, 16 Apr 2021 10:08:01 -0400
X-MC-Unique: phB43e_kN7mF7cuP8RHbhw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 17803AF11;
	Fri, 16 Apr 2021 14:08:00 +0000 (UTC)
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
References: <20210415231530.95464-1-snitzer@redhat.com>
	<20210415231530.95464-4-snitzer@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <6185100e-89e6-0a7f-8901-9ce86fe8f1ac@suse.de>
Date: Fri, 16 Apr 2021 16:07:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210415231530.95464-4-snitzer@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13GE89RJ032730
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v2 3/4] nvme: introduce FAILUP handling for
 REQ_FAILFAST_TRANSPORT
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8xNi8yMSAxOjE1IEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gSWYgUkVRX0ZBSUxGQVNU
X1RSQU5TUE9SVCBpcyBzZXQgaXQgbWVhbnMgdGhlIGRyaXZlciBzaG91bGQgbm90IHJldHJ5Cj4g
SU8gdGhhdCBjb21wbGV0ZWQgd2l0aCB0cmFuc3BvcnQgZXJyb3JzLiBSRVFfRkFJTEZBU1RfVFJB
TlNQT1JUIGlzCj4gc2V0IGJ5IG11bHRpcGF0aGluZyBzb2Z0d2FyZSAoZS5nLiBkbS1tdWx0aXBh
dGgpIGJlZm9yZSBpdCBpc3N1ZXMgSU8uCj4gCj4gVXBkYXRlIE5WTWUgdG8gYWxsb3cgZmFpbG92
ZXIgb2YgcmVxdWVzdHMgbWFya2VkIHdpdGggZWl0aGVyCj4gUkVRX05WTUVfTVBBVEggb3IgUkVR
X0ZBSUxGQVNUX1RSQU5TUE9SVC4gVGhpcyBhbGxvd3Mgc3VjaCByZXF1ZXN0cwo+IHRvIGJlIGdp
dmVuIGEgZGlzcG9zaXRpb24gb2YgZWl0aGVyIEZBSUxPVkVSIG9yIEZBSUxVUCByZXNwZWN0aXZl
bHkuCj4gRkFJTFVQIGhhbmRsaW5nIGVuc3VyZXMgYSByZXRyeWFibGUgZXJyb3IgaXMgcmV0dXJu
ZWQgdXAgZnJvbSBOVk1lLgo+IAo+IEludHJvZHVjZSBudm1lX2ZhaWx1cF9yZXEoKSBmb3IgdXNl
IGluIG52bWVfY29tcGxldGVfcnEoKSBpZgo+IG52bWVfZGVjaWRlX2Rpc3Bvc2l0aW9uKCkgcmV0
dXJucyBGQUlMVVAuIG52bWVfZmFpbHVwX3JlcSgpIGVuc3VyZXMKPiB0aGUgcmVxdWVzdCBpcyBj
b21wbGV0ZWQgd2l0aCBhIHJldHJ5YWJsZSBJTyBlcnJvciB3aGVuIGFwcHJvcHJpYXRlLgo+IF9f
bnZtZV9lbmRfcmVxKCkgd2FzIGZhY3RvcmVkIG91dCBmb3IgdXNlIGJ5IGJvdGggbnZtZV9lbmRf
cmVxKCkgYW5kCj4gbnZtZV9mYWlsdXBfcmVxKCkuCj4gCj4gU2lnbmVkLW9mZi1ieTogTWlrZSBT
bml0emVyIDxzbml0emVyQHJlZGhhdC5jb20+Cj4gLS0tCj4gIGRyaXZlcnMvbnZtZS9ob3N0L2Nv
cmUuYyB8IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDI2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbnZtZS9ob3N0L2NvcmUuYyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYwo+IGluZGV4
IDQxMzRjZjNjN2U0OC4uMTAzNzUxOTdkZDUzIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbnZtZS9o
b3N0L2NvcmUuYwo+ICsrKyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYwo+IEBAIC0yOTksNiAr
Mjk5LDcgQEAgZW51bSBudm1lX2Rpc3Bvc2l0aW9uIHsKPiAgCUNPTVBMRVRFLAo+ICAJUkVUUlks
Cj4gIAlGQUlMT1ZFUiwKPiArCUZBSUxVUCwKPiAgfTsKPiAgCj4gIHN0YXRpYyBpbmxpbmUgZW51
bSBudm1lX2Rpc3Bvc2l0aW9uIG52bWVfZGVjaWRlX2Rpc3Bvc2l0aW9uKHN0cnVjdCByZXF1ZXN0
ICpyZXEpCj4gQEAgLTMxOCwxMCArMzE5LDExIEBAIHN0YXRpYyBpbmxpbmUgZW51bSBudm1lX2Rp
c3Bvc2l0aW9uIG52bWVfZGVjaWRlX2Rpc3Bvc2l0aW9uKHN0cnVjdCByZXF1ZXN0ICpyZXEpCj4g
IAkgICAgbnZtZV9yZXEocmVxKS0+cmV0cmllcyA+PSBudm1lX21heF9yZXRyaWVzKQo+ICAJCXJl
dHVybiBDT01QTEVURTsKPiAgCj4gLQlpZiAocmVxLT5jbWRfZmxhZ3MgJiBSRVFfTlZNRV9NUEFU
SCkgewo+ICsJaWYgKHJlcS0+Y21kX2ZsYWdzICYgKFJFUV9OVk1FX01QQVRIIHwgUkVRX0ZBSUxG
QVNUX1RSQU5TUE9SVCkpIHsKPiAgCQlpZiAobnZtZV9pc19wYXRoX2Vycm9yKG52bWVfcmVxKHJl
cSktPnN0YXR1cykgfHwKPiAgCQkgICAgYmxrX3F1ZXVlX2R5aW5nKHJlcS0+cSkpCj4gLQkJCXJl
dHVybiBGQUlMT1ZFUjsKPiArCQkJcmV0dXJuIChyZXEtPmNtZF9mbGFncyAmIFJFUV9OVk1FX01Q
QVRIKSA/Cj4gKwkJCQlGQUlMT1ZFUiA6IEZBSUxVUDsKPiAgCX0gZWxzZSB7Cj4gIAkJaWYgKGJs
a19xdWV1ZV9keWluZyhyZXEtPnEpKQo+ICAJCQlyZXR1cm4gQ09NUExFVEU7Cj4gQEAgLTMzMCwx
MCArMzMyLDggQEAgc3RhdGljIGlubGluZSBlbnVtIG52bWVfZGlzcG9zaXRpb24gbnZtZV9kZWNp
ZGVfZGlzcG9zaXRpb24oc3RydWN0IHJlcXVlc3QgKnJlcSkKPiAgCXJldHVybiBSRVRSWTsKPiAg
fQo+ICAKPiAtc3RhdGljIGlubGluZSB2b2lkIG52bWVfZW5kX3JlcShzdHJ1Y3QgcmVxdWVzdCAq
cmVxKQo+ICtzdGF0aWMgaW5saW5lIHZvaWQgX19udm1lX2VuZF9yZXEoc3RydWN0IHJlcXVlc3Qg
KnJlcSwgYmxrX3N0YXR1c190IHN0YXR1cykKPiAgewo+IC0JYmxrX3N0YXR1c190IHN0YXR1cyA9
IG52bWVfZXJyb3Jfc3RhdHVzKG52bWVfcmVxKHJlcSktPnN0YXR1cyk7Cj4gLQo+ICAJaWYgKElT
X0VOQUJMRUQoQ09ORklHX0JMS19ERVZfWk9ORUQpICYmCj4gIAkgICAgcmVxX29wKHJlcSkgPT0g
UkVRX09QX1pPTkVfQVBQRU5EKQo+ICAJCXJlcS0+X19zZWN0b3IgPSBudm1lX2xiYV90b19zZWN0
KHJlcS0+cS0+cXVldWVkYXRhLAo+IEBAIC0zNDMsNiArMzQzLDI0IEBAIHN0YXRpYyBpbmxpbmUg
dm9pZCBudm1lX2VuZF9yZXEoc3RydWN0IHJlcXVlc3QgKnJlcSkKPiAgCWJsa19tcV9lbmRfcmVx
dWVzdChyZXEsIHN0YXR1cyk7Cj4gIH0KPiAgCj4gK3N0YXRpYyBpbmxpbmUgdm9pZCBudm1lX2Vu
ZF9yZXEoc3RydWN0IHJlcXVlc3QgKnJlcSkKPiArewo+ICsJX19udm1lX2VuZF9yZXEocmVxLCBu
dm1lX2Vycm9yX3N0YXR1cyhudm1lX3JlcShyZXEpLT5zdGF0dXMpKTsKPiArfQo+ICsKPiArc3Rh
dGljIHZvaWQgbnZtZV9mYWlsdXBfcmVxKHN0cnVjdCByZXF1ZXN0ICpyZXEpCj4gK3sKPiArCWJs
a19zdGF0dXNfdCBzdGF0dXMgPSBudm1lX2Vycm9yX3N0YXR1cyhudm1lX3JlcShyZXEpLT5zdGF0
dXMpOwo+ICsKPiArCWlmIChXQVJOX09OX09OQ0UoIWJsa19wYXRoX2Vycm9yKHN0YXR1cykpKSB7
Cj4gKwkJcHJfZGVidWcoIlJlcXVlc3QgbWVhbnQgZm9yIGZhaWxvdmVyIGJ1dCBibGtfc3RhdHVz
X3QgKGVycm5vPSVkKSB3YXMgbm90IHJldHJ5YWJsZS5cbiIsCj4gKwkJCSBibGtfc3RhdHVzX3Rv
X2Vycm5vKHN0YXR1cykpOwo+ICsJCXN0YXR1cyA9IEJMS19TVFNfSU9FUlI7Cj4gKwl9Cj4gKwo+
ICsJX19udm1lX2VuZF9yZXEocmVxLCBzdGF0dXMpOwo+ICt9Cj4gKwo+ICB2b2lkIG52bWVfY29t
cGxldGVfcnEoc3RydWN0IHJlcXVlc3QgKnJlcSkKPiAgewo+ICAJdHJhY2VfbnZtZV9jb21wbGV0
ZV9ycShyZXEpOwo+IEBAIC0zNjEsNiArMzc5LDkgQEAgdm9pZCBudm1lX2NvbXBsZXRlX3JxKHN0
cnVjdCByZXF1ZXN0ICpyZXEpCj4gIAljYXNlIEZBSUxPVkVSOgo+ICAJCW52bWVfZmFpbG92ZXJf
cmVxKHJlcSk7Cj4gIAkJcmV0dXJuOwo+ICsJY2FzZSBGQUlMVVA6Cj4gKwkJbnZtZV9mYWlsdXBf
cmVxKHJlcSk7Cj4gKwkJcmV0dXJuOwo+ICAJfQo+ICB9Cj4gIEVYUE9SVF9TWU1CT0xfR1BMKG52
bWVfY29tcGxldGVfcnEpOwo+IAoKSG1tLiBRdWl0ZSBjb252b2x1dGVkLCBtZXRoaW5rcy4KU2hv
dWxkbid0IHRoaXMgYWNoaWV2ZSB0aGUgc2FtZSB0aGluZz8KCmRpZmYgLS1naXQgYS9kcml2ZXJz
L252bWUvaG9zdC9jb3JlLmMgYi9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMKaW5kZXggZTg5ZWMy
NTIyY2E2Li44YzM2YTIxOTZiNjYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUu
YworKysgYi9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMKQEAgLTMwMyw4ICszMDMsMTAgQEAgc3Rh
dGljIGlubGluZSBlbnVtIG52bWVfZGlzcG9zaXRpb24KbnZtZV9kZWNpZGVfZGlzcG9zaXRpb24o
c3RydWN0IHJlcXVlc3QgKnJlcSkKICAgICAgICBpZiAobGlrZWx5KG52bWVfcmVxKHJlcSktPnN0
YXR1cyA9PSAwKSkKICAgICAgICAgICAgICAgIHJldHVybiBDT01QTEVURTsKCi0gICAgICAgaWYg
KGJsa19ub3JldHJ5X3JlcXVlc3QocmVxKSB8fAotICAgICAgICAgICAobnZtZV9yZXEocmVxKS0+
c3RhdHVzICYgTlZNRV9TQ19ETlIpIHx8CisgICAgICAgaWYgKGJsa19ub3JldHJ5X3JlcXVlc3Qo
cmVxKSkKKyAgICAgICAgICAgICAgIG52bWVfcmVxKHJlcSktPnN0YXR1cyB8PSBOVk1FX1NDX0RO
UjsKKworICAgICAgIGlmICgobnZtZV9yZXEocmVxKS0+c3RhdHVzICYgTlZNRV9TQ19ETlIpIHx8
CiAgICAgICAgICAgIG52bWVfcmVxKHJlcSktPnJldHJpZXMgPj0gbnZtZV9tYXhfcmV0cmllcykK
ICAgICAgICAgICAgICAgIHJldHVybiBDT01QTEVURTsKCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRy
LiBIYW5uZXMgUmVpbmVja2UJCSAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVA
c3VzZS5kZQkJCSAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUg
U29sdXRpb25zIEdlcm1hbnkgR21iSCwgOTA0MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2cmZm
ZXIsIEhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw=


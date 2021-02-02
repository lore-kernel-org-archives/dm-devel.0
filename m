Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A723EC433E6
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:51:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EA96364E93
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA96364E93
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-2jdjBfWzOAm8CMA2yyNAHA-1; Wed, 03 Feb 2021 04:51:22 -0500
X-MC-Unique: 2jdjBfWzOAm8CMA2yyNAHA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A65A9100F341;
	Wed,  3 Feb 2021 09:51:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89419779F4;
	Wed,  3 Feb 2021 09:51:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E334D18095CC;
	Wed,  3 Feb 2021 09:51:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112CmKSi019993 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 07:48:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 693232166B27; Tue,  2 Feb 2021 12:48:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 640432166B2D
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 12:48:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C2F1858F0F
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 12:48:18 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-328-nukoSFXBPw2k2Tlu5anXzg-1;
	Tue, 02 Feb 2021 07:48:13 -0500
X-MC-Unique: nukoSFXBPw2k2Tlu5anXzg-1
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; d="scan'208";a="104103944"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 02 Feb 2021 20:48:06 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id C3DA44CE6D68;
	Tue,  2 Feb 2021 20:48:02 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 2 Feb 2021 20:48:03 +0800
To: "Darrick J. Wong" <djwong@kernel.org>
References: <20210129062757.1594130-1-ruansy.fnst@cn.fujitsu.com>
	<20210129062757.1594130-10-ruansy.fnst@cn.fujitsu.com>
	<20210202024147.GI7193@magnolia>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <d9c989bc-be7d-4771-4cd8-2e4653648b4d@cn.fujitsu.com>
Date: Tue, 2 Feb 2021 20:48:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202024147.GI7193@magnolia>
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: C3DA44CE6D68.AE3BA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 03 Feb 2021 04:50:36 -0500
Cc: y-goto@fujitsu.com, qi.fuli@fujitsu.com, snitzer@redhat.com,
	linux-nvdimm@lists.01.org, rgoldwyn@suse.de,
	darrick.wong@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v2 09/10] xfs: Implement
 ->corrupted_range() for XFS
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIxLzIvMiDkuIrljYgxMDo0MSwgRGFycmljayBKLiBXb25nIHdyb3RlOgo+IE9uIEZy
aSwgSmFuIDI5LCAyMDIxIGF0IDAyOjI3OjU2UE0gKzA4MDAsIFNoaXlhbmcgUnVhbiB3cm90ZToK
Pj4gVGhpcyBmdW5jdGlvbiBpcyB1c2VkIHRvIGhhbmRsZSBlcnJvcnMgd2hpY2ggbWF5IGNhdXNl
IGRhdGEgbG9zdCBpbgo+PiBmaWxlc3lzdGVtLiAgU3VjaCBhcyBtZW1vcnkgZmFpbHVyZSBpbiBm
c2RheCBtb2RlLgo+Pgo+PiBJbiBYRlMsIGl0IHJlcXVpcmVzICJybWFwYnQiIGZlYXR1cmUgaW4g
b3JkZXIgdG8gcXVlcnkgZm9yIGZpbGVzIG9yCj4+IG1ldGFkYXRhIHdoaWNoIGFzc29jaWF0ZWQg
dG8gdGhlIGNvcnJ1cHRlZCBkYXRhLiAgVGhlbiB3ZSBjb3VsZCBjYWxsIGZzCj4+IHJlY292ZXIg
ZnVuY3Rpb25zIHRvIHRyeSB0byByZXBhaXIgdGhlIGNvcnJ1cHRlZCBkYXRhLihkaWQgbm90Cj4+
IGltcGxlbWVudGVkIGluIHRoaXMgcGF0Y2hzZXQpCj4gCj4gSSB3b3VsZCBzdWdnZXN0Ogo+ICJJ
ZiB0aGUgcm1hcCBmZWF0dXJlIG9mIFhGUyBlbmFibGVkLCB3ZSBjYW4gcXVlcnkgaXQgdG8gZmlu
ZCBmaWxlcyBhbmQKPiBtZXRhZGF0YSB3aGljaCBhcmUgYXNzb2NpYXRlZCB3aXRoIHRoZSBjb3Jy
dXB0IGRhdGEuICBGb3Igbm93IGFsbCB3ZSBkbwo+IGlzIGtpbGwgcHJvY2Vzc2VzIHdpdGggdGhh
dCBmaWxlIG1hcHBlZCBpbnRvIHRoZWlyIGFkZHJlc3Mgc3BhY2VzLCBidXQKPiBmdXR1cmUgcGF0
Y2hlcyBjb3VsZCBhY3R1YWxseSBkbyBzb21ldGhpbmcgYWJvdXQgY29ycnVwdCBtZXRhZGF0YS4i
Cj4gCgpZZXMsIHRoaXMgaXMgYmV0dGVyLgoKPj4gQWZ0ZXIgdGhhdCwgdGhlIG1lbW9yeSBmYWls
dXJlIGFsc28gbmVlZHMgdG8gbm90aWZ5IHRoZSBwcm9jZXNzZXMgd2hvCj4+IGFyZSB1c2luZyB0
aG9zZSBmaWxlcy4KPj4KPj4gT25seSBzdXBwb3J0IGRhdGEgZGV2aWNlLiAgUmVhbHRpbWUgZGV2
aWNlIGlzIG5vdCBzdXBwb3J0ZWQgZm9yIG5vdy4KPj4KPj4gU2lnbmVkLW9mZi1ieTogU2hpeWFu
ZyBSdWFuIDxydWFuc3kuZm5zdEBjbi5mdWppdHN1LmNvbT4KPj4gLS0tCj4+ICAgZnMveGZzL3hm
c19mc29wcy5jIHwgICA1ICsrKwo+PiAgIGZzL3hmcy94ZnNfbW91bnQuaCB8ICAgMSArCj4+ICAg
ZnMveGZzL3hmc19zdXBlci5jIHwgMTA5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKwo+PiAgIDMgZmlsZXMgY2hhbmdlZCwgMTE1IGluc2VydGlvbnMoKykKPj4K
Pj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfZnNvcHMuYyBiL2ZzL3hmcy94ZnNfZnNvcHMuYwo+
PiBpbmRleCA5NTljZTkxYTM3NTUuLmYwMzkwMWE1YzY3MyAxMDA2NDQKPj4gLS0tIGEvZnMveGZz
L3hmc19mc29wcy5jCj4+ICsrKyBiL2ZzL3hmcy94ZnNfZnNvcHMuYwo+PiBAQCAtNDk4LDYgKzQ5
OCwxMSBAQCB4ZnNfZG9fZm9yY2Vfc2h1dGRvd24oCj4+ICAgIkNvcnJ1cHRpb24gb2YgaW4tbWVt
b3J5IGRhdGEgZGV0ZWN0ZWQuICBTaHV0dGluZyBkb3duIGZpbGVzeXN0ZW0iKTsKPj4gICAJCWlm
IChYRlNfRVJSTEVWRUxfSElHSCA8PSB4ZnNfZXJyb3JfbGV2ZWwpCj4+ICAgCQkJeGZzX3N0YWNr
X3RyYWNlKCk7Cj4+ICsJfSBlbHNlIGlmIChmbGFncyAmIFNIVVRET1dOX0NPUlJVUFRfTUVUQSkg
ewo+PiArCQl4ZnNfYWxlcnRfdGFnKG1wLCBYRlNfUFRBR19TSFVURE9XTl9DT1JSVVBULAo+PiAr
IkNvcnJ1cHRpb24gb2Ygb24tZGlzayBtZXRhZGF0YSBkZXRlY3RlZC4gIFNodXR0aW5nIGRvd24g
ZmlsZXN5c3RlbSIpOwo+PiArCQlpZiAoWEZTX0VSUkxFVkVMX0hJR0ggPD0geGZzX2Vycm9yX2xl
dmVsKQo+PiArCQkJeGZzX3N0YWNrX3RyYWNlKCk7Cj4+ICAgCX0gZWxzZSBpZiAobG9nZXJyb3Ip
IHsKPj4gICAJCXhmc19hbGVydF90YWcobXAsIFhGU19QVEFHX1NIVVRET1dOX0xPR0VSUk9SLAo+
PiAgIAkJCSJMb2cgSS9PIEVycm9yIERldGVjdGVkLiBTaHV0dGluZyBkb3duIGZpbGVzeXN0ZW0i
KTsKPj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfbW91bnQuaCBiL2ZzL3hmcy94ZnNfbW91bnQu
aAo+PiBpbmRleCBkZmE0MjliNzdlZTIuLjhmMGRmNjdmZmNjMSAxMDA2NDQKPj4gLS0tIGEvZnMv
eGZzL3hmc19tb3VudC5oCj4+ICsrKyBiL2ZzL3hmcy94ZnNfbW91bnQuaAo+PiBAQCAtMjc0LDYg
KzI3NCw3IEBAIHZvaWQgeGZzX2RvX2ZvcmNlX3NodXRkb3duKHN0cnVjdCB4ZnNfbW91bnQgKm1w
LCBpbnQgZmxhZ3MsIGNoYXIgKmZuYW1lLAo+PiAgICNkZWZpbmUgU0hVVERPV05fTE9HX0lPX0VS
Uk9SCTB4MDAwMgkvKiB3cml0ZSBhdHRlbXB0IHRvIHRoZSBsb2cgZmFpbGVkICovCj4+ICAgI2Rl
ZmluZSBTSFVURE9XTl9GT1JDRV9VTU9VTlQJMHgwMDA0CS8qIHNodXRkb3duIGZyb20gYSBmb3Jj
ZWQgdW5tb3VudCAqLwo+PiAgICNkZWZpbmUgU0hVVERPV05fQ09SUlVQVF9JTkNPUkUJMHgwMDA4
CS8qIGNvcnJ1cHQgaW4tbWVtb3J5IGRhdGEgc3RydWN0dXJlcyAqLwo+PiArI2RlZmluZSBTSFVU
RE9XTl9DT1JSVVBUX01FVEEJMHgwMDEwICAvKiBjb3JydXB0IG1ldGFkYXRhIG9uIGRldmljZSAq
Lwo+PiAgIAo+PiAgIC8qCj4+ICAgICogRmxhZ3MgZm9yIHhmc19tb3VudGZzCj4+IGRpZmYgLS1n
aXQgYS9mcy94ZnMveGZzX3N1cGVyLmMgYi9mcy94ZnMveGZzX3N1cGVyLmMKPj4gaW5kZXggODEz
YmU4NzlhNWU1Li45MzA5M2ZlMGVlOGEgMTAwNjQ0Cj4+IC0tLSBhL2ZzL3hmcy94ZnNfc3VwZXIu
Ywo+PiArKysgYi9mcy94ZnMveGZzX3N1cGVyLmMKPj4gQEAgLTM1LDYgKzM1LDExIEBACj4+ICAg
I2luY2x1ZGUgInhmc19yZWZjb3VudF9pdGVtLmgiCj4+ICAgI2luY2x1ZGUgInhmc19ibWFwX2l0
ZW0uaCIKPj4gICAjaW5jbHVkZSAieGZzX3JlZmxpbmsuaCIKPj4gKyNpbmNsdWRlICJ4ZnNfYWxs
b2MuaCIKPj4gKyNpbmNsdWRlICJ4ZnNfcm1hcC5oIgo+PiArI2luY2x1ZGUgInhmc19ybWFwX2J0
cmVlLmgiCj4+ICsjaW5jbHVkZSAieGZzX3J0YWxsb2MuaCIKPj4gKyNpbmNsdWRlICJ4ZnNfYml0
LmgiCj4+ICAgCj4+ICAgI2luY2x1ZGUgPGxpbnV4L21hZ2ljLmg+Cj4+ICAgI2luY2x1ZGUgPGxp
bnV4L2ZzX2NvbnRleHQuaD4KPj4gQEAgLTExMDUsNiArMTExMCwxMDkgQEAgeGZzX2ZzX2ZyZWVf
Y2FjaGVkX29iamVjdHMoCj4+ICAgCXJldHVybiB4ZnNfcmVjbGFpbV9pbm9kZXNfbnIoWEZTX00o
c2IpLCBzYy0+bnJfdG9fc2Nhbik7Cj4+ICAgfQo+PiAgIAo+PiArc3RhdGljIGludAo+PiAreGZz
X2NvcnJ1cHRfaGVscGVyKAo+PiArCXN0cnVjdCB4ZnNfYnRyZWVfY3VyCQkqY3VyLAo+PiArCXN0
cnVjdCB4ZnNfcm1hcF9pcmVjCQkqcmVjLAo+PiArCXZvaWQJCQkJKmRhdGEpCj4+ICt7Cj4+ICsJ
c3RydWN0IHhmc19pbm9kZQkJKmlwOwo+PiArCXN0cnVjdCBhZGRyZXNzX3NwYWNlCQkqbWFwcGlu
ZzsKPj4gKwlpbnQJCQkJcmMgPSAwOwo+PiArCWludAkJCQkqZmxhZ3MgPSBkYXRhOwo+PiArCj4+
ICsJaWYgKFhGU19STUFQX05PTl9JTk9ERV9PV05FUihyZWMtPnJtX293bmVyKSB8fAo+PiArCSAg
ICAocmVjLT5ybV9mbGFncyAmIChYRlNfUk1BUF9BVFRSX0ZPUksgfCBYRlNfUk1BUF9CTUJUX0JM
T0NLKSkpIHsKPj4gKwkJLy8gVE9ETyBjaGVjayBhbmQgdHJ5IHRvIGZpeCBtZXRhZGF0YQo+PiAr
CQlyYyA9IC1FRlNDT1JSVVBURUQ7Cj4gCj4gVGhlIHhmc19mb3JjZV9zaHV0ZG93bigpIGNhbGwg
c2hvdWxkIGdvIGhlcmUsIHNpbmNlIFNIVVRET1dOX0NPUlJVUFRfTUVUQQo+IGlzIHNwZWNpZmlj
IHRvIHRoaXMgY2FzZS4KCk9LLgo+IAo+IEkgZ3Vlc3Mgb25lIGNvdWxkIGFsc28gZGlnIHRocm91
Z2ggdGhlIGJ1ZmZlciBjYWNoZSBhbmQgZGVsd3JpX3N1Ym1pdAo+IHRob3NlIGJ1ZmZlcnMgb3Ig
c29tZXRoaW5nLgo+IAo+PiArCX0gZWxzZSB7Cj4+ICsJCS8qCj4+ICsJCSAqIEdldCBmaWxlcyB0
aGF0IGluY29yZSwgZmlsdGVyIG91dCBvdGhlcnMgdGhhdCBhcmUgbm90IGluIHVzZS4KPj4gKwkJ
ICovCj4+ICsJCXJjID0geGZzX2lnZXQoY3VyLT5iY19tcCwgY3VyLT5iY190cCwgcmVjLT5ybV9v
d25lciwKPj4gKwkJCSAgICAgIFhGU19JR0VUX0lOQ09SRSwgMCwgJmlwKTsKPj4gKwkJaWYgKHJj
IHx8ICFpcCkKPj4gKwkJCXJldHVybiByYzsKPj4gKwkJaWYgKCFWRlNfSShpcCktPmlfbWFwcGlu
ZykKPj4gKwkJCWdvdG8gb3V0Owo+PiArCj4+ICsJCW1hcHBpbmcgPSBWRlNfSShpcCktPmlfbWFw
cGluZzsKPj4gKwkJaWYgKElTX0RBWChWRlNfSShpcCkpKQo+PiArCQkJcmMgPSBtZl9kYXhfbWFw
cGluZ19raWxsX3Byb2NzKG1hcHBpbmcsIHJlYy0+cm1fb2Zmc2V0LAo+PiArCQkJCQkJICAgICAg
ICpmbGFncyk7Cj4+ICsJCWVsc2UKPj4gKwkJCW1hcHBpbmdfc2V0X2Vycm9yKG1hcHBpbmcsIC1F
SU8pOwo+PiArCj4+ICsJCS8vIFRPRE8gdHJ5IHRvIGZpeCBkYXRhCj4gCj4gV2hhdCBjb3VsZCB3
ZSBkbyB0byBmaXggdGhlIGRhdGE/ICBJZiB3ZSdyZSBub3QgaW4gU19EQVggbW9kZSBhbmQKPiB0
aGVyZSdzIGFjdHVhbGx5IHBhZ2VjYWNoZSBtYXBwZWQgaW4sIGRvZXMgdGhhdCBpbXBseSB0aGF0
IHdlIGNvdWxkCj4gbWFyayBpdCBkaXJ0eSBhbmQga2ljayBvZmYgZGlydHkgcGFnZWNhY2hlIHdy
aXRlYmFjaz8KCkJ1dCBpbiB0aGlzIGNhc2UsIHRoZSBkYXggcGFnZSBpcyBhbHJlYWR5IGJyb2tl
biwgaXQgc2VlbXMgdGhhdCBwYWdlIApjYWNoZSBzaG91bGQgbm90IGJlIHdyaXR0ZW4gYmFjayB0
byB0aGUgb3JpZ2luIGRheCBwYWdlLiAgSSB0aGluayAKYW5vdGhlciBkYXggcGFnZSBuZWVkIHRv
IGJlIGFsbG9jYXRlIGZvciB0aGUgd3JpdGViYWNrLgoKPiAKPj4gK291dDoKPj4gKwkJeGZzX2ly
ZWxlKGlwKTsKPj4gKwl9Cj4+ICsKPj4gKwlyZXR1cm4gcmM7Cj4+ICt9Cj4+ICsKPj4gK3N0YXRp
YyBpbnQKPj4gK3hmc19mc19jb3JydXB0ZWRfcmFuZ2UoCj4+ICsJc3RydWN0IHN1cGVyX2Jsb2Nr
CSpzYiwKPj4gKwlzdHJ1Y3QgYmxvY2tfZGV2aWNlCSpiZGV2LAo+PiArCWxvZmZfdAkJCW9mZnNl
dCwKPj4gKwlzaXplX3QJCQlsZW4sCj4+ICsJdm9pZAkJCSpkYXRhKQo+PiArewo+PiArCXN0cnVj
dCB4ZnNfbW91bnQJKm1wID0gWEZTX00oc2IpOwo+PiArCXN0cnVjdCB4ZnNfdHJhbnMJKnRwID0g
TlVMTDsKPj4gKwlzdHJ1Y3QgeGZzX2J0cmVlX2N1cgkqY3VyID0gTlVMTDsKPj4gKwlzdHJ1Y3Qg
eGZzX3JtYXBfaXJlYwlybWFwX2xvdywgcm1hcF9oaWdoOwo+PiArCXN0cnVjdCB4ZnNfYnVmCQkq
YWdmX2JwID0gTlVMTDsKPj4gKwl4ZnNfZnNibG9ja190CQlmc2JubyA9IFhGU19CX1RPX0ZTQiht
cCwgb2Zmc2V0KTsKPj4gKwl4ZnNfZmlsYmxrc190CQliY250ID0gWEZTX0JfVE9fRlNCKG1wLCBs
ZW4pOwo+PiArCXhmc19hZ251bWJlcl90CQlhZ25vID0gWEZTX0ZTQl9UT19BR05PKG1wLCBmc2Ju
byk7Cj4+ICsJeGZzX2FnYmxvY2tfdAkJYWdibm8gPSBYRlNfRlNCX1RPX0FHQk5PKG1wLCBmc2Ju
byk7Cj4+ICsJaW50CQkJZXJyb3IgPSAwOwo+PiArCj4+ICsJaWYgKG1wLT5tX3J0ZGV2X3Rhcmdw
ICYmIG1wLT5tX3J0ZGV2X3RhcmdwLT5idF9iZGV2ID09IGJkZXYpIHsKPj4gKwkJeGZzX3dhcm4o
bXAsICJjb3JydXB0ZWRfcmFuZ2Ugc3VwcG9ydCBub3QgYXZhaWxhYmxlIGZvciByZWFsdGltZSBk
ZXZpY2UhIik7Cj4+ICsJCXJldHVybiAwOwo+PiArCX0KPj4gKwlpZiAobXAtPm1fbG9nZGV2X3Rh
cmdwICYmIG1wLT5tX2xvZ2Rldl90YXJncC0+YnRfYmRldiA9PSBiZGV2ICYmCj4+ICsJICAgIG1w
LT5tX2xvZ2Rldl90YXJncCAhPSBtcC0+bV9kZGV2X3RhcmdwKSB7Cj4+ICsJCXhmc19lcnIobXAs
ICJvbmRpc2sgbG9nIGNvcnJ1cHQsIHNodXR0aW5nIGRvd24gZnMhIik7Cj4+ICsJCXhmc19mb3Jj
ZV9zaHV0ZG93bihtcCwgU0hVVERPV05fQ09SUlVQVF9NRVRBKTsKPiAKPiBMb25nZXIgdGVybSBx
dWVzdGlvbiBmb3IgdGhlIHJlc3Qgb2YgdGhlIHhmcyBjb21tdW5pdHk6IENhbiB3ZSBkbyBiZXR0
ZXIKPiB0aGFuIHRoaXM/ICBJZiB0aGUgYWlsIGhhcyBjaGVja3BvaW50ZWQgcGFzdCB0aGlzIHBh
cnQgb2YgdGhlIGxvZyB0aGVuCj4gd2UgY291bGQganVzdCB3cml0ZSB6ZXJvZXMgaW50byBkZWFk
IGFyZWEsIHJpZ2h0Pwo+IAo+IEFsc28sIGlmIG9uZSBvZiB0aGUgbG9nIGJ1ZmZlcnMgcG9pbnRz
IHRvIGEgZGVhZCBsb2cgYXJlYSBhbmQgaXNuJ3QgdGhlCj4gb25lIHRoYXQncyBjdXJyZW50bHkg
YmVpbmcgd3JpdHRlbiBpbnRvLCBjYW4gd2UganVzdCBzdWJtaXRfYmlvIGl0IHRvCj4gcmV3cml0
ZSB0aGUgbG9zdCBwYXJ0IG9mIHRoZSBsb2c/PwoKWWVzLCBXZSBzaG91bGQgYWxzbyBmaXggdGhl
IGxvZyByYXRoZXIgdGhhbiBzaHV0ZG93biBpdCBkaXJlY3RseS4gIEkgCndpbGwgdGFrZSB0aGF0
IGludG8gY29uc2lkZXJhdGlvbiBpbiBmdXR1cmUgcGF0Y2hlcy4KCj4gCj4+ICsJCXJldHVybiAw
Owo+PiArCX0KPj4gKwo+PiArCWlmICgheGZzX3NiX3ZlcnNpb25faGFzcm1hcGJ0KCZtcC0+bV9z
YikpIHsKPj4gKwkJeGZzX3dhcm4obXAsICJjb3JydXB0ZWRfcmFuZ2UgbmVlZHMgcm1hcGJ0IGVu
YWJsZWQhIik7Cj4+ICsJCXJldHVybiAwOwo+PiArCX0KPj4gKwo+PiArCWVycm9yID0geGZzX3Ry
YW5zX2FsbG9jX2VtcHR5KG1wLCAmdHApOwo+PiArCWlmIChlcnJvcikKPj4gKwkJcmV0dXJuIGVy
cm9yOwo+PiArCj4+ICsJZXJyb3IgPSB4ZnNfYWxsb2NfcmVhZF9hZ2YobXAsIHRwLCBhZ25vLCAw
LCAmYWdmX2JwKTsKPj4gKwlpZiAoZXJyb3IpCj4+ICsJCWdvdG8gb3V0X2NhbmNlbF90cDsKPj4g
Kwo+PiArCWN1ciA9IHhmc19ybWFwYnRfaW5pdF9jdXJzb3IobXAsIHRwLCBhZ2ZfYnAsIGFnbm8p
Owo+PiArCj4+ICsJLyogQ29uc3RydWN0IGEgcmFuZ2UgZm9yIHJtYXAgcXVlcnkgKi8KPj4gKwlt
ZW1zZXQoJnJtYXBfbG93LCAwLCBzaXplb2Yocm1hcF9sb3cpKTsKPj4gKwltZW1zZXQoJnJtYXBf
aGlnaCwgMHhGRiwgc2l6ZW9mKHJtYXBfaGlnaCkpOwo+PiArCXJtYXBfbG93LnJtX3N0YXJ0Ymxv
Y2sgPSBybWFwX2hpZ2gucm1fc3RhcnRibG9jayA9IGFnYm5vOwo+PiArCXJtYXBfbG93LnJtX2Js
b2NrY291bnQgPSBybWFwX2hpZ2gucm1fYmxvY2tjb3VudCA9IGJjbnQ7Cj4+ICsKPj4gKwllcnJv
ciA9IHhmc19ybWFwX3F1ZXJ5X3JhbmdlKGN1ciwgJnJtYXBfbG93LCAmcm1hcF9oaWdoLCB4ZnNf
Y29ycnVwdF9oZWxwZXIsIGRhdGEpOwo+IAo+IExvbmcgbGluZSBoZXJlLi4uCj4gCj4+ICsJaWYg
KGVycm9yID09IC1FRlNDT1JSVVBURUQpCj4+ICsJCXhmc19mb3JjZV9zaHV0ZG93bihtcCwgU0hV
VERPV05fQ09SUlVQVF9NRVRBKTsKPiAKPiBUaGlzIHNob3VsZCBnbyBpbiB4ZnNfY29ycnVwdF9o
ZWxwZXIgYXMgSSBtZW50aW9uZWQgYWJvdmUuCgpPSy4KCgotLQpUaGFua3MsClJ1YW4gU2hpeWFu
Zy4KPiAKPiAtLUQKPiAKPj4gKwo+PiArCXhmc19idHJlZV9kZWxfY3Vyc29yKGN1ciwgZXJyb3Ip
Owo+PiArCXhmc190cmFuc19icmVsc2UodHAsIGFnZl9icCk7Cj4+ICtvdXRfY2FuY2VsX3RwOgo+
PiArCXhmc190cmFuc19jYW5jZWwodHApOwo+PiArCXJldHVybiBlcnJvcjsKPj4gK30KPj4gKwo+
PiAgIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc3VwZXJfb3BlcmF0aW9ucyB4ZnNfc3VwZXJfb3BlcmF0
aW9ucyA9IHsKPj4gICAJLmFsbG9jX2lub2RlCQk9IHhmc19mc19hbGxvY19pbm9kZSwKPj4gICAJ
LmRlc3Ryb3lfaW5vZGUJCT0geGZzX2ZzX2Rlc3Ryb3lfaW5vZGUsCj4+IEBAIC0xMTE4LDYgKzEy
MjYsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHN1cGVyX29wZXJhdGlvbnMgeGZzX3N1cGVyX29w
ZXJhdGlvbnMgPSB7Cj4+ICAgCS5zaG93X29wdGlvbnMJCT0geGZzX2ZzX3Nob3dfb3B0aW9ucywK
Pj4gICAJLm5yX2NhY2hlZF9vYmplY3RzCT0geGZzX2ZzX25yX2NhY2hlZF9vYmplY3RzLAo+PiAg
IAkuZnJlZV9jYWNoZWRfb2JqZWN0cwk9IHhmc19mc19mcmVlX2NhY2hlZF9vYmplY3RzLAo+PiAr
CS5jb3JydXB0ZWRfcmFuZ2UJPSB4ZnNfZnNfY29ycnVwdGVkX3JhbmdlLAo+PiAgIH07Cj4+ICAg
Cj4+ICAgc3RhdGljIGludAo+PiAtLSAKPj4gMi4zMC4wCj4+Cj4+Cj4+Cj4gCj4gCgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs


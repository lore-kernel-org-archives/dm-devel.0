Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464FEC433C1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:23:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8B63561919
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 08:23:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B63561919
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-FdE2ad9iM7e3CTSjhudkkA-1; Tue, 30 Mar 2021 04:23:49 -0400
X-MC-Unique: FdE2ad9iM7e3CTSjhudkkA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D64181622;
	Tue, 30 Mar 2021 08:23:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEFAF5D9C6;
	Tue, 30 Mar 2021 08:23:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 955254BB7C;
	Tue, 30 Mar 2021 08:23:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U6p3Ix008884 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 02:51:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AAAF549C2B; Tue, 30 Mar 2021 06:51:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A54BE47CD4
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:51:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC6C5185A7B2
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:51:00 +0000 (UTC)
Received: from out30-54.freemail.mail.aliyun.com
	(out30-54.freemail.mail.aliyun.com [115.124.30.54]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-376-DEAtM1quMCio2cp1drPOaA-1;
	Tue, 30 Mar 2021 02:50:57 -0400
X-MC-Unique: DEAtM1quMCio2cp1drPOaA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UTpnuEy_1617087051
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UTpnuEy_1617087051) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 30 Mar 2021 14:50:52 +0800
To: Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-12-ming.lei@redhat.com>
	<162f000f-7f86-8988-4a15-2c3bf70de1b7@suse.de>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <a213b9b1-992d-3deb-200d-c74eac500747@linux.alibaba.com>
Date: Tue, 30 Mar 2021 14:50:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <162f000f-7f86-8988-4a15-2c3bf70de1b7@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 30 Mar 2021 04:22:10 -0400
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V4 11/12] block: add poll_capable method to
 support bio-based IO polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgpPbiAzLzMwLzIxIDI6MjYgUE0sIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPiBPbiAzLzI5LzIx
IDU6MjYgUE0sIE1pbmcgTGVpIHdyb3RlOgo+PiBGcm9tOiBKZWZmbGUgWHUgPGplZmZsZXh1QGxp
bnV4LmFsaWJhYmEuY29tPgo+Pgo+PiBUaGlzIG1ldGhvZCBjYW4gYmUgdXNlZCB0byBjaGVjayBp
ZiBiaW8tYmFzZWQgZGV2aWNlIHN1cHBvcnRzIElPIHBvbGxpbmcKPj4gb3Igbm90LiBGb3IgbXEg
ZGV2aWNlcywgY2hlY2tpbmcgZm9yIGh3IHF1ZXVlIGluIHBvbGxpbmcgbW9kZSBpcwo+PiBhZGVx
dWF0ZSwgd2hpbGUgdGhlIHNhbml0eSBjaGVjayBzaGFsbCBiZSBpbXBsZW1lbnRhdGlvbiBzcGVj
aWZpYyBmb3IKPj4gYmlvLWJhc2VkIGRldmljZXMuIEZvciBleGFtcGxlLCBkbSBkZXZpY2UgbmVl
ZHMgdG8gY2hlY2sgaWYgYWxsCj4+IHVuZGVybHlpbmcgZGV2aWNlcyBhcmUgY2FwYWJsZSBvZiBJ
TyBwb2xsaW5nLgo+Pgo+PiBUaG91Z2ggYmlvLWJhc2VkIGRldmljZSBtYXkgaGF2ZSBkb25lIHRo
ZSBzYW5pdHkgY2hlY2sgZHVyaW5nIHRoZQo+PiBkZXZpY2UgaW5pdGlhbGl6YXRpb24gcGhhc2Us
IGNhY2hlaW5nIHRoZSByZXN1bHQgb2YgdGhpcyBzYW5pdHkgY2hlY2sKPj4gKHN1Y2ggYXMgYnkg
Y2FjaGVpbmcgaW4gdGhlIHF1ZXVlX2ZsYWdzKSBtYXkgbm90IHdvcmsuIEJlY2F1c2UgZm9yIGRt
Cj4+IGRldmljZXMsIHVzZXJzIGNvdWxkIGNoYW5nZSB0aGUgc3RhdGUgb2YgdGhlIHVuZGVybHlp
bmcgZGV2aWNlcyB0aHJvdWdoCj4+ICcvc3lzL2Jsb2NrLzxkZXY+L2lvX3BvbGwnLCBieXBhc3Np
bmcgdGhlIGRtIGRldmljZSBhYm92ZS4gSW4gdGhpcyBjYXNlLAo+PiB0aGUgY2FjaGVkIHJlc3Vs
dCBvZiB0aGUgdmVyeSBiZWdpbm5pbmcgc2FuaXR5IGNoZWNrIGNvdWxkIGJlCj4+IG91dC1vZi1k
YXRlLiBUaHVzIHRoZSBzYW5pdHkgY2hlY2sgbmVlZHMgdG8gYmUgZG9uZSBldmVyeSB0aW1lICdp
b19wb2xsJwo+PiBpcyB0byBiZSBtb2RpZmllZC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogSmVmZmxl
IFh1IDxqZWZmbGV4dUBsaW51eC5hbGliYWJhLmNvbT4KPj4gLS0tCj4+IMKgIGJsb2NrL2Jsay1z
eXNmcy5jwqDCoMKgwqDCoCB8IDE0ICsrKysrKysrKysrLS0tCj4+IMKgIGluY2x1ZGUvbGludXgv
YmxrZGV2LmggfMKgIDEgKwo+PiDCoCAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9ibG9jay9ibGstc3lzZnMuYyBiL2Js
b2NrL2Jsay1zeXNmcy5jCj4+IGluZGV4IGRiMzI2OGQ0MTI3NC4uYzhlN2U0YWY2NmNiIDEwMDY0
NAo+PiAtLS0gYS9ibG9jay9ibGstc3lzZnMuYwo+PiArKysgYi9ibG9jay9ibGstc3lzZnMuYwo+
PiBAQCAtNDI2LDkgKzQyNiwxNyBAQCBzdGF0aWMgc3NpemVfdCBxdWV1ZV9wb2xsX3N0b3JlKHN0
cnVjdAo+PiByZXF1ZXN0X3F1ZXVlICpxLCBjb25zdCBjaGFyICpwYWdlLAo+PiDCoMKgwqDCoMKg
IHVuc2lnbmVkIGxvbmcgcG9sbF9vbjsKPj4gwqDCoMKgwqDCoCBzc2l6ZV90IHJldDsKPj4gwqAg
LcKgwqDCoCBpZiAoIXEtPnRhZ19zZXQgfHwgcS0+dGFnX3NldC0+bnJfbWFwcyA8PSBIQ1RYX1RZ
UEVfUE9MTCB8fAo+PiAtwqDCoMKgwqDCoMKgwqAgIXEtPnRhZ19zZXQtPm1hcFtIQ1RYX1RZUEVf
UE9MTF0ubnJfcXVldWVzKQo+PiAtwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+ICvC
oMKgwqAgaWYgKHF1ZXVlX2lzX21xKHEpKSB7Cj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoIXEtPnRh
Z19zZXQgfHwgcS0+dGFnX3NldC0+bnJfbWFwcyA8PSBIQ1RYX1RZUEVfUE9MTCB8fAo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAhcS0+dGFnX3NldC0+bWFwW0hDVFhfVFlQRV9QT0xMXS5ucl9x
dWV1ZXMpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+PiArwqDC
oMKgIH0gZWxzZSB7Cj4+ICvCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZ2VuZGlzayAqZGlzayA9IHF1
ZXVlX3RvX2Rpc2socSk7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIGlmICghZGlzay0+Zm9wcy0+
cG9sbF9jYXBhYmxlIHx8Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICFkaXNrLT5mb3BzLT5w
b2xsX2NhcGFibGUoZGlzaykpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlO
VkFMOwo+PiArwqDCoMKgIH0KPj4gwqAgwqDCoMKgwqDCoCByZXQgPSBxdWV1ZV92YXJfc3RvcmUo
JnBvbGxfb24sIHBhZ2UsIGNvdW50KTsKPj4gwqDCoMKgwqDCoCBpZiAocmV0IDwgMCkKPj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYmxrZGV2LmggYi9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5o
Cj4+IGluZGV4IGJmYWI3NGI0NWYxNS4uYTQ2Zjk3NWYyYTJmIDEwMDY0NAo+PiAtLS0gYS9pbmNs
dWRlL2xpbnV4L2Jsa2Rldi5oCj4+ICsrKyBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPj4gQEAg
LTE4ODEsNiArMTg4MSw3IEBAIHN0cnVjdCBibG9ja19kZXZpY2Vfb3BlcmF0aW9ucyB7Cj4+IMKg
wqDCoMKgwqAgaW50ICgqcmVwb3J0X3pvbmVzKShzdHJ1Y3QgZ2VuZGlzayAqLCBzZWN0b3JfdCBz
ZWN0b3IsCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCBucl96b25l
cywgcmVwb3J0X3pvbmVzX2NiIGNiLCB2b2lkICpkYXRhKTsKPj4gwqDCoMKgwqDCoCBjaGFyICoo
KmRldm5vZGUpKHN0cnVjdCBnZW5kaXNrICpkaXNrLCB1bW9kZV90ICptb2RlKTsKPj4gK8KgwqDC
oCBib29sICgqcG9sbF9jYXBhYmxlKShzdHJ1Y3QgZ2VuZGlzayAqZGlzayk7Cj4+IMKgwqDCoMKg
wqAgc3RydWN0IG1vZHVsZSAqb3duZXI7Cj4+IMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IHByX29w
cyAqcHJfb3BzOwo+PiDCoCB9Owo+Pgo+IEkgcmVhbGx5IHdvbmRlciBob3cgdGhpcyB3b3VsZCB3
b3JrIGZvciBudm1lIG11bHRpcGF0aDsgYnV0IEkgZ3Vlc3MgaXQKPiBkb2Vzbid0IGNoYW5nZSB0
aGUgY3VycmVudCBzaXR1YXRpb24uCgpJIHdvbmRlciwgYXQgbGVhc3QsIG1kL2RtLCB3aGljaCBp
cyBidWlsdCB1cG9uIG90aGVyIGRldmljZXMsIG9yCid2aXJ0dWFsIGRldmljZScgaW4gb3RoZXIg
d29yZHMsIHNob3VsZCBiZSBkaXN0aW5ndWlzaGVkIGZyb20gb3RoZXIKJ29yaWdpbmFsJyBiaW8t
YmFzZWQgZGV2aWNlIChlLmcuLCBudm1lIG11bHRpcGF0aCkgdGhlbi4gTWF5YmUgb25lIGV4dHJh
CmZsYWcgb3Igc29tZXRoaW5nLgoKLS0gClRoYW5rcywKSmVmZmxlCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs


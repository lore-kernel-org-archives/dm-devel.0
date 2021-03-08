Return-Path: <SRS0=Ydjc=IG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71505C433E6
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 07:48:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4909D6513A
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 07:48:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4909D6513A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-WnFTwfwGNcWI4JrOPjxO1Q-1; Mon, 08 Mar 2021 02:48:29 -0500
X-MC-Unique: WnFTwfwGNcWI4JrOPjxO1Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB3E080432E;
	Mon,  8 Mar 2021 07:48:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 561D45D9D3;
	Mon,  8 Mar 2021 07:48:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 241CF1809C8C;
	Mon,  8 Mar 2021 07:48:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1283sL1h005263 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 7 Mar 2021 22:54:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8790F2166BB3; Mon,  8 Mar 2021 03:54:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 819B72166BA2
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 03:54:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 859D7185A7BC
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 03:54:18 +0000 (UTC)
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-42-hZQEpA2DNm2jlo3HRsH1HA-1;
	Sun, 07 Mar 2021 22:54:14 -0500
X-MC-Unique: hZQEpA2DNm2jlo3HRsH1HA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
	TI=SMTPD_---0UQpD6c2_1615175646
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UQpD6c2_1615175646) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 08 Mar 2021 11:54:07 +0800
To: Heinz Mauelshagen <heinzm@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <20210302190555.201228400@debian-a64.vm>
	<33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
	<alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
	<157a750d-3d58-ae2e-07f1-b677c1b471c7@linux.alibaba.com>
	<bd447632-f174-e6f2-ddf8-d5385da13f6b@redhat.com>
	<fc9707dc-0a21-90d3-ed4f-e201406c50eb@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
Date: Mon, 8 Mar 2021 11:54:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <fc9707dc-0a21-90d3-ed4f-e201406c50eb@redhat.com>
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
X-Mailman-Approved-At: Mon, 08 Mar 2021 02:48:20 -0500
Cc: axboe@kernel.dk, Mike Snitzer <msnitzer@redhat.com>,
	caspar@linux.alibaba.com, hch@lst.de,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
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

CgpPbiAzLzYvMjEgMTo1NiBBTSwgSGVpbnogTWF1ZWxzaGFnZW4gd3JvdGU6Cj4gCj4gT24gMy81
LzIxIDY6NDYgUE0sIEhlaW56IE1hdWVsc2hhZ2VuIHdyb3RlOgo+PiBPbiAzLzUvMjEgMTA6NTIg
QU0sIEplZmZsZVh1IHdyb3RlOgo+Pj4KPj4+IE9uIDMvMy8yMSA2OjA5IFBNLCBNaWt1bGFzIFBh
dG9ja2Egd3JvdGU6Cj4+Pj4KPj4+PiBPbiBXZWQsIDMgTWFyIDIwMjEsIEplZmZsZVh1IHdyb3Rl
Ogo+Pj4+Cj4+Pj4+Cj4+Pj4+IE9uIDMvMy8yMSAzOjA1IEFNLCBNaWt1bGFzIFBhdG9ja2Egd3Jv
dGU6Cj4+Pj4+Cj4+Pj4+PiBTdXBwb3J0IEkvTyBwb2xsaW5nIGlmIHN1Ym1pdF9iaW9fbm9hY2N0
X21xX2RpcmVjdCByZXR1cm5lZCBub24tZW1wdHkKPj4+Pj4+IGNvb2tpZS4KPj4+Pj4+Cj4+Pj4+
PiBTaWduZWQtb2ZmLWJ5OiBNaWt1bGFzIFBhdG9ja2EgPG1wYXRvY2thQHJlZGhhdC5jb20+Cj4+
Pj4+Pgo+Pj4+Pj4gLS0tCj4+Pj4+PiDCoCBkcml2ZXJzL21kL2RtLmMgfMKgwqDCoCA1ICsrKysr
Cj4+Pj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCj4+Pj4+Pgo+Pj4+Pj4g
SW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL21kL2RtLmMKPj4+Pj4+ID09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KPj4+Pj4+
IC0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL21kL2RtLmPCoMKgwqAgMjAyMS0wMy0wMgo+Pj4+
Pj4gMTk6MjY6MzQuMDAwMDAwMDAwICswMTAwCj4+Pj4+PiArKysgbGludXgtMi42L2RyaXZlcnMv
bWQvZG0uY8KgwqDCoCAyMDIxLTAzLTAyIDE5OjI2OjM0LjAwMDAwMDAwMCArMDEwMAo+Pj4+Pj4g
QEAgLTE2ODIsNiArMTY4MiwxMSBAQCBzdGF0aWMgdm9pZCBfX3NwbGl0X2FuZF9wcm9jZXNzX2Jp
byhzdHJ1Cj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+Pj4+Pj4gwqDCoMKgwqDCoCB9Cj4+
Pj4+PiDCoCArwqDCoMKgIGlmIChjaS5wb2xsX2Nvb2tpZSAhPSBCTEtfUUNfVF9OT05FKSB7Cj4+
Pj4+PiArwqDCoMKgwqDCoMKgwqAgd2hpbGUgKGF0b21pY19yZWFkKCZjaS5pby0+aW9fY291bnQp
ID4gMSAmJgo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmxrX3BvbGwoY2ku
cG9sbF9xdWV1ZSwgY2kucG9sbF9jb29raWUsIHRydWUpKSA7Cj4+Pj4+PiArwqDCoMKgIH0KPj4+
Pj4+ICsKPj4+Pj4+IMKgwqDCoMKgwqAgLyogZHJvcCB0aGUgZXh0cmEgcmVmZXJlbmNlIGNvdW50
ICovCj4+Pj4+PiDCoMKgwqDCoMKgIGRlY19wZW5kaW5nKGNpLmlvLCBlcnJub190b19ibGtfc3Rh
dHVzKGVycm9yKSk7Cj4+Pj4+PiDCoCB9Cj4+Pj4+IEl0IHNlZW1zIHRoYXQgdGhlIGdlbmVyYWwg
aWRlYSBvZiB5b3VyIGRlc2lnbiBpcyB0bwo+Pj4+PiAxKSBzdWJtaXQgKm9uZSogc3BsaXQgYmlv
Cj4+Pj4+IDIpIGJsa19wb2xsKCksIHdhaXRpbmcgdGhlIHByZXZpb3VzbHkgc3VibWl0dGVkIHNw
bGl0IGJpbyBjb21wbGV0cwo+Pj4+IE5vLCBJIHN1Ym1pdCBhbGwgdGhlIGJpb3MgYW5kIHBvbGwg
Zm9yIHRoZSBsYXN0IG9uZS4KPj4+Pgo+Pj4+PiBhbmQgdGhlbiBzdWJtaXQgbmV4dCBzcGxpdCBi
aW8sIHJlcGVhdGluZyB0aGUgYWJvdmUgcHJvY2Vzcy4gSSdtCj4+Pj4+IGFmcmFpZAo+Pj4+PiB0
aGUgcGVyZm9ybWFuY2UgbWF5IGJlIGFuIGlzc3VlIGhlcmUsIHNpbmNlIHRoZSBiYXRjaCBldmVy
eSB0aW1lCj4+Pj4+IGJsa19wb2xsKCkgcmVhcHMgbWF5IGRlY3JlYXNlLgo+Pj4+IENvdWxkIHlv
dSBiZW5jaG1hcmsgaXQ/Cj4+PiBJIG9ubHkgdGVzdGVkIGRtLWxpbmVhci4KPj4+Cj4+PiBUaGUg
Y29uZmlndXJhdGlvbiAoZG0gdGFibGUpIG9mIGRtLWxpbmVhciBpczoKPj4+IDAgMTA0ODU3NiBs
aW5lYXIgL2Rldi9udm1lMG4xIDAKPj4+IDEwNDg1NzYgMTA0ODU3NiBsaW5lYXIgL2Rldi9udm1l
Mm4xIDAKPj4+IDIwOTcxNTIgMTA0ODU3NiBsaW5lYXIgL2Rldi9udm1lNW4xIDAKPj4+Cj4+Pgo+
Pj4gZmlvIHNjcmlwdCB1c2VkIGlzOgo+Pj4gYGBgCj4+PiAkY2F0IGZpby5jb25mCj4+PiBbZ2xv
YmFsXQo+Pj4gbmFtZT1pb3VyaW5nLXNxcG9sbC1pb3BvbGwtMQo+Pj4gaW9lbmdpbmU9aW9fdXJp
bmcKPj4+IGlvZGVwdGg9MTI4Cj4+PiBudW1qb2JzPTEKPj4+IHRocmVhZAo+Pj4gcnc9cmFuZHJl
YWQKPj4+IGRpcmVjdD0xCj4+PiByZWdpc3RlcmZpbGVzPTEKPj4+IGhpcHJpPTEKPj4+IHJ1bnRp
bWU9MTAKPj4+IHRpbWVfYmFzZWQKPj4+IGdyb3VwX3JlcG9ydGluZwo+Pj4gcmFuZHJlcGVhdD0w
Cj4+PiBmaWxlbmFtZT0vZGV2L21hcHBlci90ZXN0ZGV2Cj4+PiBicz00awo+Pj4KPj4+IFtqb2It
MV0KPj4+IGNwdXNfYWxsb3dlZD0xNAo+Pj4gYGBgCj4+Pgo+Pj4gSU9QUyAoSVJRIG1vZGUpIHwg
SU9QUyAoaW9wb2xsIG1vZGUgKGhpcHJpPTEpKQo+Pj4gLS0tLS0tLS0tLS0tLS0tIHwgLS0tLS0t
LS0tLS0tLS0tLS0tLS0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMjEzayB8wqDCoMKgwqDC
oMKgwqDCoMKgwqAgMTlrCj4+Pgo+Pj4gQXQgbGVhc3QsIGl0IGRvZXNuJ3Qgd29yayB3ZWxsIHdp
dGggaW9fdXJpbmcgaW50ZXJmYWNlLgo+Pj4KPj4+Cj4+Cj4+Cj4+IEplZmZsZSwKPj4KPj4gSSBy
YW4geW91ciBhYm92ZSBmaW8gdGVzdCBvbiBhIGxpbmVhciBMViBzcGxpdCBhY3Jvc3MgMyBOVk1l
cyB0bwo+PiBzZWNvbmQgeW91ciBzcGxpdCBtYXBwaW5nCj4+IChzeXN0ZW06IDMyIGNvcmUgSW50
ZWwsIDI1NkdpQiBSQU0pIGNvbXBhcmluZyBpbyBlbmdpbmVzIHN5bmMsIGxpYmFpbwo+PiBhbmQg
aW9fdXJpbmcsCj4+IHRoZSBsYXR0ZXIgdy8gYW5kIHcvbyBoaXByaSAoc3luYytsaWJhaW8gb2J2
aW91c2x5IHcvbyByZWdpc3RlcmZpbGVzCj4+IGFuZCBoaXByaSkgd2hpY2ggcmVzdWx0ZWQgb2s6
Cj4+Cj4+Cj4+Cj4+IHN5bmPCoCB8wqAgbGliYWlvwqAgfMKgIElSUSBtb2RlIChoaXByaT0wKSB8
IGlvcG9sbCAoaGlwcmk9MSkKPj4gLS0tLS0tfC0tLS0tLS0tLS18LS0tLS0tLS0tLS0tLS0tLS0t
LS0tfC0tLS0tLS0tLS0tLS0tLS0tIDU2LjNLIHzCoMKgwqAKPj4gMjkwS8KgIHzCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgMzI5SyB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDM1MUsg
SSBjYW4ndCBzZWNvbmQgeW91cgo+PiBkcmFzdGljIGhpcHJpPTEgZHJvcCBoZXJlLi4uCj4gCj4g
Cj4gU29ycnksIGVtYWlsIG1lc3MuCj4gCj4gCj4gc3luYyDCoCB8wqAgbGliYWlvwqAgfMKgIElS
USBtb2RlIChoaXByaT0wKSB8IGlvcG9sbCAoaGlwcmk9MSkKPiAtLS0tLS0tfC0tLS0tLS0tLS18
LS0tLS0tLS0tLS0tLS0tLS0tLS0tfC0tLS0tLS0tLS0tLS0tLS0tCj4gNTYuM0vCoCB8wqDCoMKg
IDI5MEvCoCB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDMyOUsgfMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAzNTFLCj4gCj4gCj4gCj4gSSBjYW4ndCBzZWNvbmQgeW91ciBkcmFzdGlj
IGhpcHJpPTEgZHJvcCBoZXJlLi4uCj4gCgpIdW1tbSwgdGhhdCdzIGluZGVlZCBzb21ld2hhdCBz
dHJhbmdlLi4uCgpNeSB0ZXN0IGVudmlyb25tZW50OgotIENQVTogMTI4IGNvcmVzLCB0aG91Z2gg
b25seSBvbmUgQ1BVIGNvcmUgaXMgdXNlZCBzaW5jZQonY3B1c19hbGxvd2VkPTE0JyBpbiBmaW8g
Y29uZmlndXJhdGlvbgotIG1lbW9yeTogOTgzRyBtZW1vcnkgZnJlZQotIE5WTWU6IEh1YXdhaSBF
UzM1MTBQIChIV0U1MlA0MzRUMEwwMDVOKSwgd2l0aCAnbnZtZS5wb2xsX3F1ZXVlcz0zJwoKTWF5
YmUgeW91IGRpZG4ndCBzcGVjaWZ5ICdudm1lLnBvbGxfcXVldWVzPVhYWCc/IEluIHRoaXMgY2Fz
ZSwgSU8gc3RpbGwKZ29lcyBpbnRvIElSUSBtb2RlLCBldmVuIHlvdSBoYXZlIHNwZWNpZmllZCAn
aGlwcmk9MSc/CgotLSAKVGhhbmtzLApKZWZmbGUKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw=


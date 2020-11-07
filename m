Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3899C4742C
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FC01206C0
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FC01206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-G9HlNnupO6i8TVjy6dr0Yw-1; Sun, 08 Nov 2020 12:05:25 -0500
X-MC-Unique: G9HlNnupO6i8TVjy6dr0Yw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAE59809DDA;
	Sun,  8 Nov 2020 17:05:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA360277B6;
	Sun,  8 Nov 2020 17:05:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 92E9792303;
	Sun,  8 Nov 2020 17:05:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A78CjAF011806 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 7 Nov 2020 03:12:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D12E5205EB12; Sat,  7 Nov 2020 08:12:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBD072049CBC
	for <dm-devel@redhat.com>; Sat,  7 Nov 2020 08:12:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EA0A800296
	for <dm-devel@redhat.com>; Sat,  7 Nov 2020 08:12:43 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-429-XNoyzjnGOqyTQIyCAn_Z_g-1;
	Sat, 07 Nov 2020 03:12:38 -0500
X-MC-Unique: XNoyzjnGOqyTQIyCAn_Z_g-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R611e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
	TI=SMTPD_---0UEUaDCf_1604736751
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UEUaDCf_1604736751) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 07 Nov 2020 16:12:32 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201103092329.17694-1-jefflexu@linux.alibaba.com>
	<b042e052-fa66-6542-f382-8bf33c4ffc24@linux.alibaba.com>
	<20201106152132.GA12366@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <ab909100-fcd0-5b27-2014-076d7a72df12@linux.alibaba.com>
Date: Sat, 7 Nov 2020 16:12:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201106152132.GA12366@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Sun, 08 Nov 2020 12:04:49 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: Re: [dm-devel] Why queue_work unneeded for REQUEUE bio
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDExLzYvMjAgMTE6MjEgUE0sIE1pa2UgU25pdHplciB3cm90ZToKPiBPbiBUaHUsIE5vdiAw
NSAyMDIwIGF0IDEwOjQ5cG0gLTA1MDAsCj4gSmVmZmxlWHUgPGplZmZsZXh1QGxpbnV4LmFsaWJh
YmEuY29tPiB3cm90ZToKPgo+PiBIaSBNaWtlLAo+Pgo+Pgo+PiBJIGhhdmUgYW5vdGhlciBxdWVz
dGlvbiBhYm91dCBkbSwgdGhvdWdoIGl0J3MgaXJyZWxldmFudCB0byB0aGlzIG9yaWdpbmFsCj4+
Cj4+IG1haWwuCj4+Cj4+Cj4+IEN1cnJlbnRseSBhYm5vcm1hbCBJTyB3aWxsIGNhbGwgYmxrX3F1
ZXVlX3NwbGl0KCkgYW5kIG5vcm1hbCBJTyB3aWxsCj4+Cj4+IGJlIHNwbGl0IGNvbnNpZGVyaW5n
IEBtYXhfc2VjdG9ycy9AY2h1bmtfc2VjdG9zIChpbiBtYXhfaW9fbGVuKCkpLgo+Pgo+Pgo+PiBR
dWVzdGlvbiAxOiBXaHkgYmlvIHNob3VsZCBiZSBzcGxpdCBjb25zaWRlcmluZyBxdWV1ZV9saW1p
dHMgaW4gZG0gbGF5ZXI/Cj4+Cj4+IEFmdGVyIGFsbCB0aGUgdW5kZXJseWluZyBkZXZpY2Ugd2ls
bCBzcGxpdCB0aGVtc2VsdmVzIGJ5IHF1ZXVlX2xpbWl0cyBpZgo+Pgo+PiB0aGUgZG0gbGF5ZXIg
ZG9lc24ndCBzcGxpdCBieSBxdWV1ZV9saW1pdHMuCj4gU29tZSB0YXJnZXRzIGhhdmUgImFibm9y
bWFsIElPIiBjb25zdHJhaW50cyBpbiB0aGVpciBpbXBsZW1lbnRhdGlvbiB0aGF0Cj4gaXMgcmVm
bGVjdGVkIGluIHRoZSBxdWV1ZV9saW1pdHMgLS0gZGlzY2FyZHMgaW4gcGFydGljdWxhci4KPgo+
PiBUaGVuIFF1ZXN0aW9uIDI6IEN1cnJlbnRseSBvbmx5IEBtYXhfc2VjdG9ycyBpcyBjb25zaWRl
cmVkIHdoZW4gc3BsaXR0aW5nCj4+Cj4+IG5vcm1hbCBJTyBpbiBkbSBsYXllci4gU2hvdWxkIHdl
IGFsc28gY29uc2lkZXIKPj4gQG1heF9zZWdtZW50cy9AbWF4X3NlZ21lbnRfc2l6ZQo+Pgo+PiBh
cyBibGtfcXVldWVfc3BsaXQoKSBkb2VzPwo+IEdyZWF0IHF1ZXN0aW9uLCBpdCBkb2VzIGFwcGVh
ciB0aGUgb25lIGdhcCBpbiBETSdzIHNwbGl0dGluZyBmb3IKPiAibm9ybWFsIiBJTy4gSSdtIGxl
c3MgZmFtaWxpYXIgd2l0aCBAbWF4X3NlZ21lbnRzL0BtYXhfc2VnbWVudF9zaXplLgo+Cj4gU2lu
Y2UgY29tbWl0IDUwOTFjZGVjNTZmYSAoImRtOiBjaGFuZ2UgbWF4X2lvX2xlbigpIHRvIHVzZQo+
IGJsa19tYXhfc2l6ZV9vZmZzZXQoKSIpIERNIGlzIG1ha2luZyB1c2Ugb2YgbW9yZSBibG9jayBj
b3JlIGNvZGUgdG8KPiBjYWxjdWxhdGUgaXRzIHNwbGl0cyAtLSB0aGUgb2Zmc2V0IGJhc2VkIHNw
bGl0dGluZyBpcyBtdWNoIG1vcmUgbmF0dXJhbAo+IGZvciBETSB0byBwZXJmb3JtIGdpdmVuIHRo
YXQgcG90ZW50aWFsIGZvciBzcGFubmluZyBtdWx0aXBsZSB0YXJnZXRzLAo+IGV0Yy4gIEJ1dCBE
TSB0YXJnZXRzIHJlYWxseSBkb24ndCBnZXQgaW52b2x2ZWQgd2l0aCBjb25jZXJuIGZvcgo+IEBt
YXhfc2VnbWVudHMvQG1heF9zZWdtZW50X3NpemUKPgo+IGRtLWNyeXB0LmM6Y3J5cHRfaW9faGlu
dHMgaXMgdGhlIG9ubHkgRE0gdGFyZ2V0IGNvZGUgdGhhdCBjb25jZXJucwo+IGl0c2VsZiB3aXRo
IEBtYXhfc2VnbWVudF9zaXplIC0tIGFuZCBpdCBpcyBwdW5pdGl2ZSBieSBzZXR0aW5nIGl0IHRv
Cj4gUEFHRV9TSVpFLCBwbGVhc2Ugc2VlIGNvbW1pdCA1ODZiMjg2YjExMGU5NGUgKCJkbSBjcnlw
dDogY29uc3RyYWluIGNyeXB0Cj4gZGV2aWNlJ3MgbWF4X3NlZ21lbnRfc2l6ZSB0byBQQUdFX1NJ
WkUiKSBmb3IgbW9yZSBjb250ZXh0LgoKVGhhbmtzLiBTbyB0aGUgcHJpbmNpcGxlIG9mIGhhbmRs
aW5nIHF1ZXVlX2xpbWl0cyBvZiBkbSBsYXllciBpcyB0aGF0LMKgIApvbmx5IHdoZW4gZG0tdGFy
Z2V0CgpzcGVjaWZpYyBxdWV1ZV9saW1pdHMgaXMgc2V0LCBzaGFsbCB3ZSBjb25zaWRlciBxdWV1
ZV9saW1pdHN3aGVuIApzcGxpdHRpbmcgYmlvIGluIGRtLCBpbgoKd2hpY2ggY2FzZSB0aGVzZSBx
dWV1ZV9saW1pdHMgKGZyb20gdW5kZXJseWluZyBkZXZpY2VzKSBhcmUgbGVmdCBmb3IgdGhlIAp1
bmRlcmx5aW5nIGRldmljZXMKCnRvIGJlIGhhbmRsZWQgYXBwcm9wcmlhdGVseS4KCgooSW4gdGhp
cyBjYXNlIHRoZXJlJ3Mgbm8gZG0tdGFyZ2V0IHNldCBpdHMgb3duIApAbWF4X3NlZ21lbnRzL0Bt
YXhfc2VnbWVudF9zaXplLCB0aGVuCgp0aGVzZSB0d28gcGFyYW1ldGVycyBhcmUgbm90IGNvbnNp
ZGVyZWQgd2hlbiBkbSBzcGxpdHRpbmcuKQoKCklmIHRoYXQncyB0aGUgY2FzZSwgdGhlbiB3aHkg
Ym90aGVyIHN0YWNraW5nIHF1ZXVlX2xpbWl0cyBpbiAKYmxrX3N0YWNrX2xpbWl0cygpPyBTdWNo
IGFzCgpgYGAKCmJsa19zdGFja19saW1pdHMKCiDCoMKgwqAgdC0+bWF4X3NlZ21lbnRzID0gbWlu
X25vdF96ZXJvKHQtPm1heF9zZWdtZW50cywgYi0+bWF4X3NlZ21lbnRzKTsKIMKgwqDCoCB0LT5t
YXhfc2VnbWVudF9zaXplID0gbWluX25vdF96ZXJvKHQtPm1heF9zZWdtZW50X3NpemUsCiDCoMKg
wqAgwqDCoMKgIMKgwqDCoCDCoMKgwqAgwqDCoMKgIMKgwqAgYi0+bWF4X3NlZ21lbnRfc2l6ZSk7
CgpgYGAKCgpJJ20gbm90IGNoYWxsZW5naW5nIHRoZSBpbXBsZW1lbnRhdGlvbi4gT2YgY291cnNl
IGl0IHdvcmtzIGZpbmUgCmN1cnJlbnRseS4gSSdtIGp1c3QgY3VyaW91cwoKYWJvdXQgdGhlIGRl
c2lnbiBjb25zaWRlcmF0aW9uIGJlbmVhdGggdGhlIGltcGxlbWVudGF0aW9uLiA6LSkKCgotLSAK
VGhhbmtzLApKZWZmbGUKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


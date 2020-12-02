Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22088C71155
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 59E162222A
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59E162222A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-jrqRE8sNNzmwut1iIAqGxA-1; Wed, 02 Dec 2020 04:55:31 -0500
X-MC-Unique: jrqRE8sNNzmwut1iIAqGxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7551192D792;
	Wed,  2 Dec 2020 09:55:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9747189CE;
	Wed,  2 Dec 2020 09:55:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 775D24EEEE;
	Wed,  2 Dec 2020 09:55:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B23vnm8002752 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 22:57:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 598342166B29; Wed,  2 Dec 2020 03:57:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 549462166B27
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 03:57:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4286800296
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 03:57:46 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-343-GugC1YmQPbKV4LOb4FZPvg-1;
	Tue, 01 Dec 2020 22:57:42 -0500
X-MC-Unique: GugC1YmQPbKV4LOb4FZPvg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UHHiNul_1606881455
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UHHiNul_1606881455) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 02 Dec 2020 11:57:36 +0800
From: JeffleXu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
References: <20201201160709.31748-1-snitzer@redhat.com>
	<20201202033855.60882-1-jefflexu@linux.alibaba.com>
	<20201202033855.60882-2-jefflexu@linux.alibaba.com>
Message-ID: <feb19a02-5ece-505f-e905-86dc84cdb204@linux.alibaba.com>
Date: Wed, 2 Dec 2020 11:57:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201202033855.60882-2-jefflexu@linux.alibaba.com>
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
X-Mailman-Approved-At: Wed, 02 Dec 2020 04:55:04 -0500
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] dm: use gcd() to fix chunk_sectors limit
	stacking
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QWN0dWFsbHkgaW4gdGVybXMgb2YgdGhpcyBpc3N1ZSwgSSB0aGluayB0aGUgZGlsZW1tYSBoZXJl
IGlzIHRoYXQsCkBjaHVua19zZWN0b3JzIG9mIGRtIGRldmljZSBpcyBtYWlubHkgZnJvbSB0d28g
c291cmNlLgoKT25lIGlzIHRoYXQgZnJvbSB0aGUgdW5kZXJseWluZyBkZXZpY2VzLCB3aGljaCBp
cyBjYWxjdWxhdGVkIGludG8gb25lCmNvbXBvc2VkIG9uZSBpbiBibGtfc3RhY2tfbGltaXRzKCku
Cgo+IGNvbW1pdCAyMmFkYTgwMmVkZTggKCJibG9jazogdXNlIGxjbV9ub3RfemVybygpIHdoZW4g
c3RhY2tpbmcKPiBjaHVua19zZWN0b3JzIikgYnJva2UgY2h1bmtfc2VjdG9ycyBsaW1pdCBzdGFj
a2luZy4gY2h1bmtfc2VjdG9ycyBtdXN0Cj4gcmVmbGVjdCB0aGUgbW9zdCBsaW1pdGVkIG9mIGFs
bCBkZXZpY2VzIGluIHRoZSBJTyBzdGFjay4KPiAKPiBPdGhlcndpc2UgbWFsZm9ybWVkIElPIG1h
eSByZXN1bHQuIEUuZy46IHByaW9yIHRvIHRoaXMgZml4LAo+IC0+Y2h1bmtfc2VjdG9ycyA9IGxj
bV9ub3RfemVybyg4LCAxMjgpIHdvdWxkIHJlc3VsdCBpbgo+IGJsa19tYXhfc2l6ZV9vZmZzZXQo
KSBzcGxpdHRpbmcgSU8gYXQgMTI4IHNlY3RvcnMgcmF0aGVyIHRoYW4gdGhlCj4gcmVxdWlyZWQg
bW9yZSByZXN0cmljdGl2ZSA4IHNlY3RvcnMuCgpGb3IgdGhpcyBwYXJ0LCB0ZWNobmljYWxseSBJ
IGNhbid0IGFncmVlIHRoYXQgJ2NodW5rX3NlY3RvcnMgbXVzdApyZWZsZWN0IHRoZSBtb3N0IGxp
bWl0ZWQgb2YgYWxsIGRldmljZXMgaW4gdGhlIElPIHN0YWNrJy4gRXZlbiBpZiB0aGUgZG0KZGV2
aWNlIGFkdmVydGlzZXMgY2h1bmtfc2VjdG9ycyBvZiAxMjhLIHdoZW4gdGhlIGxpbWl0cyBvZiB0
d28KdW5kZXJseWluZyBkZXZpY2VzIGFyZSA4SyBhbmQgMTI4SywgYW5kIHRodXMgc3BsaXR0aW5n
IGlzIG5vdCBkb25lIGluIGRtCmRldmljZSBwaGFzZSwgdGhlIHVuZGVybHlpbmcgZGV2aWNlcyB3
aWxsIHNwbGl0IGJ5IHRoZW1zZWx2ZXMuCgo+IEBAIC01NDcsNyArNTQ3LDEwIEBAIGludCBibGtf
c3RhY2tfbGltaXRzKHN0cnVjdCBxdWV1ZV9saW1pdHMgKnQsIHN0cnVjdCBxdWV1ZV9saW1pdHMg
KmIsCj4gIAo+ICAJdC0+aW9fbWluID0gbWF4KHQtPmlvX21pbiwgYi0+aW9fbWluKTsKPiAgCXQt
PmlvX29wdCA9IGxjbV9ub3RfemVybyh0LT5pb19vcHQsIGItPmlvX29wdCk7Cj4gLQl0LT5jaHVu
a19zZWN0b3JzID0gbGNtX25vdF96ZXJvKHQtPmNodW5rX3NlY3RvcnMsIGItPmNodW5rX3NlY3Rv
cnMpOwo+ICsKPiArCS8qIFNldCBub24tcG93ZXItb2YtMiBjb21wYXRpYmxlIGNodW5rX3NlY3Rv
cnMgYm91bmRhcnkgKi8KPiArCWlmIChiLT5jaHVua19zZWN0b3JzKQo+ICsJCXQtPmNodW5rX3Nl
Y3RvcnMgPSBnY2QodC0+Y2h1bmtfc2VjdG9ycywgYi0+Y2h1bmtfc2VjdG9ycyk7CgpUaGlzIG1h
eSBpbnRyb2R1Y2VzIGEgcmVncmVzc2lvbi4gU3VwcG9zZSB0aGUgQGNodW5rX3NlY3RvcnMgbGlt
aXRzIG9mCnR3byB1bmRlcmx5aW5nIGRldmljZXMgYXJlIDhLIGFuZCAxMjhLLCB0aGVuIEBjaHVu
a19zZWN0b3JzIG9mIGRtIGRldmljZQppcyA4SyBhZnRlciB0aGUgZml4LiBTbyBldmVuIHdoZW4g
YSAxMjhLIHNpemVkIGJpbyBpcyBhY3R1YWxseQpyZWRpcmVjdGluZyB0byB0aGUgdW5kZXJseWlu
ZyBkZXZpY2Ugd2l0aCAxMjhLIEBjaHVua19zZWN0b3JzIGxpbWl0LAp0aGlzIDEyOEsgc2l6ZWQg
YmlvIHdpbGwgYWN0dWFsbHkgc3BsaXQgaW50byAxNiBzcGxpdCBiaW9zLCBlYWNoIDhLCnNpemVk
44CCT2J2aW91c2x5IGl0IGlzIGV4Y2Vzc2l2ZSBzcGxpdC4gQW5kIEkgdGhpbmsgdGhpcyBpcyBh
Y3R1YWxseSB3aHkKbGNtX25vdF96ZXJvKGEsIGIpIGlzIHVzZWQgb3JpZ2luYWxseS4KCgpUaGUg
b3RoZXIgb25lIHNvdXJjZSBpcyBkbSBkZXZpY2UgaXRzZWxmLiBETSBkZXZpY2UgY2FuIHNldCBA
bWF4X2lvX2xlbgp0aHJvdWdoIC0+aW9faGludCgpLCBhbmQgdGhlbiBzZXQgQGNodW5rX3NlY3Rv
cnMgZnJvbSBAbWF4X2lvX2xlbi4KClRoaXMgcGFydCBpcyBhY3R1YWxseSB3aGVyZSAnY2h1bmtf
c2VjdG9ycyBtdXN0IHJlZmxlY3QgdGhlIG1vc3QgbGltaXRlZApvZiBhbGwgZGV2aWNlcyBpbiB0
aGUgSU8gc3RhY2snIGlzIHRydWUsIGFuZCB3ZSBoYXZlIHRvIGFwcGx5IHRoZSBtb3N0CnN0cmlj
dCBsaW1pdGF0aW9uIGhlcmUuIFRoaXMgaXMgYWN0dWFsbHkgd2hhdCB0aGUgZm9sbG93aW5nIHBh
dGNoIGRvZXMuCgoKCk9uIDEyLzIvMjAgMTE6MzggQU0sIEplZmZsZSBYdSB3cm90ZToKPiBBcyBp
dCBzYWlkIGluIGNvbW1pdCA3ZTc5ODZmOWQzYmEgKCJibG9jazogdXNlIGdjZCgpIHRvIGZpeAo+
IGNodW5rX3NlY3RvcnMgbGltaXQgc3RhY2tpbmciKSwgY2h1bmtfc2VjdG9ycyBzaG91bGQgcmVm
bGVjdCB0aGUgbW9zdAo+IGxpbWl0ZWQgb2YgYWxsIGRldmljZXMgaW4gdGhlIElPIHN0YWNrLgo+
IAo+IFRoZSBwcmV2aW91cyBjb21taXQgb25seSBmaXhlcyBibG9jay9ibGstc2V0dGluZ3MuYzpi
bGtfc3RhY2tfbGltaXRzKCksCj4gd2hpbGUgbGVhdmluZyBkbS5jOmRtX2NhbGN1bGF0ZV9xdWV1
ZV9saW1pdHMoKSB1bmZpeGVkLgo+IAo+IEZpeGVzOiA4ODJlYzRlNjA5YzEgKCJkbSB0YWJsZTog
c3RhY2sgJ2NodW5rX3NlY3RvcnMnIGxpbWl0IHRvIGFjY291bnQgZm9yIHRhcmdldC1zcGVjaWZp
YyBzcGxpdHRpbmciKQo+IGNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj4gUmVwb3J0ZWQtYnk6
IEpvaG4gRG9ybWlueSA8amRvcm1pbnlAcmVkaGF0LmNvbT4KPiBSZXBvcnRlZC1ieTogQnJ1Y2Ug
Sm9obnN0b24gPGJqb2huc3RvQHJlZGhhdC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogSmVmZmxlIFh1
IDxqZWZmbGV4dUBsaW51eC5hbGliYWJhLmNvbT4KPiAtLS0KPiAgZHJpdmVycy9tZC9kbS10YWJs
ZS5jIHwgMyArKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXRhYmxlLmMgYi9kcml2ZXJzL21k
L2RtLXRhYmxlLmMKPiBpbmRleCBjZTU0M2I3NjFiZTcuLmRjYzBhMjczNTVkNyAxMDA2NDQKPiAt
LS0gYS9kcml2ZXJzL21kL2RtLXRhYmxlLmMKPiArKysgYi9kcml2ZXJzL21kL2RtLXRhYmxlLmMK
PiBAQCAtMjIsNiArMjIsNyBAQAo+ICAjaW5jbHVkZSA8bGludXgvYmxrLW1xLmg+Cj4gICNpbmNs
dWRlIDxsaW51eC9tb3VudC5oPgo+ICAjaW5jbHVkZSA8bGludXgvZGF4Lmg+Cj4gKyNpbmNsdWRl
IDxsaW51eC9nY2QuaD4KPiAgCj4gICNkZWZpbmUgRE1fTVNHX1BSRUZJWCAidGFibGUiCj4gIAo+
IEBAIC0xNDU3LDcgKzE0NTgsNyBAQCBpbnQgZG1fY2FsY3VsYXRlX3F1ZXVlX2xpbWl0cyhzdHJ1
Y3QgZG1fdGFibGUgKnRhYmxlLAo+ICAKPiAgCQkvKiBTdGFjayBjaHVua19zZWN0b3JzIGlmIHRh
cmdldC1zcGVjaWZpYyBzcGxpdHRpbmcgaXMgcmVxdWlyZWQgKi8KPiAgCQlpZiAodGktPm1heF9p
b19sZW4pCj4gLQkJCXRpX2xpbWl0cy5jaHVua19zZWN0b3JzID0gbGNtX25vdF96ZXJvKHRpLT5t
YXhfaW9fbGVuLAo+ICsJCQl0aV9saW1pdHMuY2h1bmtfc2VjdG9ycyA9IGdjZCh0aS0+bWF4X2lv
X2xlbiwKPiAgCQkJCQkJCSAgICAgICB0aV9saW1pdHMuY2h1bmtfc2VjdG9ycyk7Cj4gIAkJLyog
U2V0IEkvTyBoaW50cyBwb3J0aW9uIG9mIHF1ZXVlIGxpbWl0cyAqLwo+ICAJCWlmICh0aS0+dHlw
ZS0+aW9faGludHMpCj4gCgotLSAKVGhhbmtzLApKZWZmbGUKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==


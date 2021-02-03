Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66749C433DB
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:51:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 04A4F64F6C
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04A4F64F6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-z7lDj75yPkG0P9Y6rwRI2A-1; Wed, 03 Feb 2021 04:51:23 -0500
X-MC-Unique: z7lDj75yPkG0P9Y6rwRI2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7414107ACE3;
	Wed,  3 Feb 2021 09:51:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86A34100AE2C;
	Wed,  3 Feb 2021 09:51:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C1BF18095CC;
	Wed,  3 Feb 2021 09:51:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1131ppOs016474 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 20:51:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E1F862026D3F; Wed,  3 Feb 2021 01:51:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBD8F2026D15
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 01:51:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEEF3800B3A
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 01:51:47 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-42-C5Ivo1jcNwmCsUMd9ubOcg-1; 
	Tue, 02 Feb 2021 20:51:44 -0500
X-MC-Unique: C5Ivo1jcNwmCsUMd9ubOcg-1
X-IronPort-AV: E=Sophos;i="5.79,396,1602518400"; d="scan'208";a="104124130"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 03 Feb 2021 09:51:42 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id C1F3D4CE6D74;
	Wed,  3 Feb 2021 09:51:38 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Wed, 3 Feb 2021 09:51:39 +0800
To: "Darrick J. Wong" <djwong@kernel.org>
References: <20210129062757.1594130-1-ruansy.fnst@cn.fujitsu.com>
	<20210129062757.1594130-9-ruansy.fnst@cn.fujitsu.com>
	<20210202031711.GJ7193@magnolia>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <8742625e-8ae7-47a8-fd62-18c201c45a33@cn.fujitsu.com>
Date: Wed, 3 Feb 2021 09:51:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202031711.GJ7193@magnolia>
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: C1F3D4CE6D74.A03BC
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 03 Feb 2021 04:50:36 -0500
Cc: y-goto@fujitsu.com, qi.fuli@fujitsu.com, snitzer@redhat.com,
	linux-nvdimm@lists.01.org, rgoldwyn@suse.de,
	darrick.wong@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v2 08/10] md: Implement
	->corrupted_range()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIxLzIvMiDkuIrljYgxMToxNywgRGFycmljayBKLiBXb25nIHdyb3RlOgo+IE9uIEZy
aSwgSmFuIDI5LCAyMDIxIGF0IDAyOjI3OjU1UE0gKzA4MDAsIFNoaXlhbmcgUnVhbiB3cm90ZToK
Pj4gV2l0aCB0aGUgc3VwcG9ydCBvZiAtPnJtYXAoKSwgaXQgaXMgcG9zc2libGUgdG8gb2J0YWlu
IHRoZSBzdXBlcmJsb2NrIG9uCj4+IGEgbWFwcGVkIGRldmljZS4KPj4KPj4gSWYgYSBwbWVtIGRl
dmljZSBpcyB1c2VkIGFzIG9uZSB0YXJnZXQgb2YgbWFwcGVkIGRldmljZSwgd2UgY2Fubm90Cj4+
IG9idGFpbiBpdHMgc3VwZXJibG9jayBkaXJlY3RseS4gIFdpdGggdGhlIGhlbHAgb2YgU1lTRlMs
IHRoZSBtYXBwZWQKPj4gZGV2aWNlIGNhbiBiZSBmb3VuZCBvbiB0aGUgdGFyZ2V0IGRldmljZXMu
ICBTbywgd2UgaXRlcmF0ZSB0aGUKPj4gYmRldi0+YmRfaG9sZGVyX2Rpc2tzIHRvIG9idGFpbiBp
dHMgbWFwcGVkIGRldmljZS4KPj4KPj4gU2lnbmVkLW9mZi1ieTogU2hpeWFuZyBSdWFuIDxydWFu
c3kuZm5zdEBjbi5mdWppdHN1LmNvbT4KPj4gLS0tCj4+ICAgZHJpdmVycy9tZC9kbS5jICAgICAg
IHwgNjEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+PiAgIGRy
aXZlcnMvbnZkaW1tL3BtZW0uYyB8IDExICsrKy0tLS0tCj4+ICAgZnMvYmxvY2tfZGV2LmMgICAg
ICAgIHwgNDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0KPiAKPiBJIGZlZWwgbGlrZSB0
aGlzIF5eXiBwYXJ0IHRoYXQgaW1wbGVtZW50cyB0aGUgZ2VuZXJpYyBhYmlsaXR5IGZvciBhIGJs
b2NrCj4gZGV2aWNlIHdpdGggYSBiYWQgc2VjdG9yIHRvIG5vdGlmeSB3aGF0ZXZlcidzIGhvbGRp
bmcgb250byBpdCAoZnMsIG90aGVyCj4gYmxvY2sgZGV2aWNlKSBzaG91bGQgYmUgaW4gcGF0Y2gg
Mi4gIFRoYXQncyBnZW5lcmljIGJsb2NrIGxheWVyIGNvZGUsCj4gYW5kIGl0J3MgaGFyZCB0byB0
ZWxsICh3aGVuIHlvdSdyZSBsb29raW5nIGF0IHBhdGNoIDIpIHdoYXQgdGhlIGJhcmUKPiBmdW5j
dGlvbiBkZWNsYXJhdGlvbiBpbiBpdCBpcyByZWFsbHkgc3VwcG9zZWQgdG8gZG8uCj4gCj4gQWxz
bywgdGhpcyBwYXRjaCBpcyBzdGlsbCBkaWZmaWN1bHQgdG8gcmV2aWV3IGJlY2F1c2UgaXQgbWl4
ZXMgZGV2aWNlCj4gbWFwcGVyLCBudmRpbW0sIGFuZCBibG9jayBsYXllciBjaGFuZ2VzIQoKT0su
ICBJJ2xsIHNwbGl0IHRoaXMgdG8gbWFrZSBpdCBsb29rcyBzaW1wbGUuCgo+IAo+PiAgIGluY2x1
ZGUvbGludXgvZ2VuaGQuaCB8ICAyICsrCj4+ICAgNCBmaWxlcyBjaGFuZ2VkLCAxMDcgaW5zZXJ0
aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0u
YyBiL2RyaXZlcnMvbWQvZG0uYwo+PiBpbmRleCA3YmFjNTY0ZjNmYWEuLjMxYjBjMzQwYjY5NSAx
MDA2NDQKPj4gLS0tIGEvZHJpdmVycy9tZC9kbS5jCj4+ICsrKyBiL2RyaXZlcnMvbWQvZG0uYwo+
PiBAQCAtNTA3LDYgKzUwNyw2NiBAQCBzdGF0aWMgaW50IGRtX2Jsa19yZXBvcnRfem9uZXMoc3Ry
dWN0IGdlbmRpc2sgKmRpc2ssIHNlY3Rvcl90IHNlY3RvciwKPj4gICAjZGVmaW5lIGRtX2Jsa19y
ZXBvcnRfem9uZXMJCU5VTEwKPj4gICAjZW5kaWYgLyogQ09ORklHX0JMS19ERVZfWk9ORUQgKi8K
Pj4gICAKPj4gK3N0cnVjdCBjb3JydXB0ZWRfaGl0X2luZm8gewo+PiArCXN0cnVjdCBibG9ja19k
ZXZpY2UgKmJkZXY7Cj4+ICsJc2VjdG9yX3Qgb2Zmc2V0Owo+PiArfTsKPj4gKwo+PiArc3RhdGlj
IGludCBkbV9ibGtfY29ycnVwdGVkX2hpdChzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0IGRt
X2RldiAqZGV2LAo+PiArCQkJCXNlY3Rvcl90IHN0YXJ0LCBzZWN0b3JfdCBjb3VudCwgdm9pZCAq
ZGF0YSkKPj4gK3sKPj4gKwlzdHJ1Y3QgY29ycnVwdGVkX2hpdF9pbmZvICpiYyA9IGRhdGE7Cj4+
ICsKPj4gKwlyZXR1cm4gYmMtPmJkZXYgPT0gKHZvaWQgKilkZXYtPmJkZXYgJiYKPj4gKwkJCShz
dGFydCA8PSBiYy0+b2Zmc2V0ICYmIGJjLT5vZmZzZXQgPCBzdGFydCArIGNvdW50KTsKPj4gKwo+
PiArfQo+PiArCj4+ICtzdHJ1Y3QgY29ycnVwdGVkX2RvX2luZm8gewo+PiArCXNpemVfdCBsZW5n
dGg7Cj4+ICsJdm9pZCAqZGF0YTsKPj4gK307Cj4+ICsKPj4gK3N0YXRpYyBpbnQgZG1fYmxrX2Nv
cnJ1cHRlZF9kbyhzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0IGJsb2NrX2RldmljZSAqYmRl
diwKPj4gKwkJCSAgICAgICBzZWN0b3JfdCBkaXNrX3NlY3QsIHZvaWQgKmRhdGEpCj4+ICt7Cj4+
ICsJc3RydWN0IGNvcnJ1cHRlZF9kb19pbmZvICpiYyA9IGRhdGE7Cj4+ICsJbG9mZl90IGRpc2tf
b2ZmID0gdG9fYnl0ZXMoZGlza19zZWN0KTsKPj4gKwlsb2ZmX3QgYmRldl9vZmYgPSB0b19ieXRl
cyhkaXNrX3NlY3QgLSBnZXRfc3RhcnRfc2VjdChiZGV2KSk7Cj4+ICsKPj4gKwlyZXR1cm4gYmRf
Y29ycnVwdGVkX3JhbmdlKGJkZXYsIGRpc2tfb2ZmLCBiZGV2X29mZiwgYmMtPmxlbmd0aCwgYmMt
PmRhdGEpOwo+PiArfQo+PiArCj4+ICtzdGF0aWMgaW50IGRtX2Jsa19jb3JydXB0ZWRfcmFuZ2Uo
c3RydWN0IGdlbmRpc2sgKmRpc2ssCj4+ICsJCQkJICBzdHJ1Y3QgYmxvY2tfZGV2aWNlICp0YXJn
ZXRfYmRldiwKPj4gKwkJCQkgIGxvZmZfdCB0YXJnZXRfb2Zmc2V0LCBzaXplX3QgbGVuLCB2b2lk
ICpkYXRhKQo+PiArewo+PiArCXN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCA9IGRpc2stPnByaXZh
dGVfZGF0YTsKPj4gKwlzdHJ1Y3QgZG1fdGFibGUgKm1hcDsKPj4gKwlzdHJ1Y3QgZG1fdGFyZ2V0
ICp0aTsKPj4gKwlzZWN0b3JfdCB0YXJnZXRfc2VjdCA9IHRvX3NlY3Rvcih0YXJnZXRfb2Zmc2V0
KTsKPj4gKwlzdHJ1Y3QgY29ycnVwdGVkX2hpdF9pbmZvIGhpID0ge3RhcmdldF9iZGV2LCB0YXJn
ZXRfc2VjdH07Cj4+ICsJc3RydWN0IGNvcnJ1cHRlZF9kb19pbmZvIGRpID0ge2xlbiwgZGF0YX07
Cj4+ICsJaW50IHNyY3VfaWR4LCBpLCByYyA9IC1FTk9ERVY7Cj4+ICsKPj4gKwltYXAgPSBkbV9n
ZXRfbGl2ZV90YWJsZShtZCwgJnNyY3VfaWR4KTsKPj4gKwlpZiAoIW1hcCkKPj4gKwkJcmV0dXJu
IHJjOwo+PiArCj4+ICsJZm9yIChpID0gMDsgaSA8IGRtX3RhYmxlX2dldF9udW1fdGFyZ2V0cyht
YXApOyBpKyspIHsKPj4gKwkJdGkgPSBkbV90YWJsZV9nZXRfdGFyZ2V0KG1hcCwgaSk7Cj4+ICsJ
CWlmICghKHRpLT50eXBlLT5pdGVyYXRlX2RldmljZXMgJiYgdGktPnR5cGUtPnJtYXApKQo+PiAr
CQkJY29udGludWU7Cj4+ICsJCWlmICghdGktPnR5cGUtPml0ZXJhdGVfZGV2aWNlcyh0aSwgZG1f
YmxrX2NvcnJ1cHRlZF9oaXQsICZoaSkpCj4+ICsJCQljb250aW51ZTsKPj4gKwo+PiArCQlyYyA9
IHRpLT50eXBlLT5ybWFwKHRpLCB0YXJnZXRfc2VjdCwgZG1fYmxrX2NvcnJ1cHRlZF9kbywgJmRp
KTsKPiAKPiBXaHkgaXMgaXQgbmVjZXNzYXJ5IHRvIGNhbGwgLT5pdGVyYXRlX2RldmljZXMgaGVy
ZT8KCi0+aXRlcmF0ZV9kZXZpY2VzKCkgaGVyZSBpcyB0byBmaW5kIG91dCB3aGljaCB0YXJnZXQg
aXMgdGhlIHBtZW0gZGV2aWNlIAp3aGljaCBpcyBjb3JydXB0ZWQgbm93LiAgVGhlbiBjYWxsIC0+
cm1hcCgpIG9uIHRoaXMgdGFyZ2V0LiAgT3RoZXIgCnRhcmdldHMgd2lsbCBiZSBpZ25vcmVkLgoK
PiAKPiBJZiB5b3UgcGFzcyB0aGUgdGFyZ2V0X2JkZXYsIG9mZnNldCwgYW5kIGxlbmd0aCB0byB0
aGUgZG0tdGFyZ2V0J3MKPiAtPnJtYXAgZnVuY3Rpb24sIGl0IHNob3VsZCBiZSBhYmxlIHRvIHdv
cmsgYmFja3dhcmRzIHRocm91Z2ggaXRzIG1hcHBpbmcKPiBsb2dpYyB0byBjb21lIHVwIHdpdGgg
YWxsIHRoZSBMQkEgcmFuZ2VzIG9mIHRoZSBtYXBwZWRfZGV2aWNlIHRoYXQKPiBhcmUgYWZmZWN0
ZWQsIGFuZCB0aGVuIGl0IGNhbiBjYWxsIGJkX2NvcnJ1cHRlZF9yYW5nZSBvbiBlYWNoIG9mIHRo
b3NlCj4gcmV2ZXJzZSBtYXBwaW5ncy4KPiAKPiBJdCB3b3VsZCBiZSBoZWxwZnVsIHRvIGhhdmUg
dGhlIGNoYW5nZXMgdG8gZG0tbGluZWFyLmMgaW4gdGhpcyBwYXRjaAo+IHRvbywgc2luY2UgdGhh
dCdzIHRoZSBvbmx5IHJlYWwgaW1wbGVtZW50YXRpb24gYXQgdGhpcyBwb2ludC4KPiAKPj4gKwkJ
YnJlYWs7Cj4+ICsJfQo+PiArCj4+ICsJZG1fcHV0X2xpdmVfdGFibGUobWQsIHNyY3VfaWR4KTsK
Pj4gKwlyZXR1cm4gcmM7Cj4+ICt9Cj4+ICsKPj4gICBzdGF0aWMgaW50IGRtX3ByZXBhcmVfaW9j
dGwoc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kLCBpbnQgKnNyY3VfaWR4LAo+PiAgIAkJCSAgICBz
dHJ1Y3QgYmxvY2tfZGV2aWNlICoqYmRldikKPj4gICB7Cj4+IEBAIC0zMDYyLDYgKzMxMjIsNyBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IGJsb2NrX2RldmljZV9vcGVyYXRpb25zIGRtX2Jsa19kb3Bz
ID0gewo+PiAgIAkuZ2V0Z2VvID0gZG1fYmxrX2dldGdlbywKPj4gICAJLnJlcG9ydF96b25lcyA9
IGRtX2Jsa19yZXBvcnRfem9uZXMsCj4+ICAgCS5wcl9vcHMgPSAmZG1fcHJfb3BzLAo+PiArCS5j
b3JydXB0ZWRfcmFuZ2UgPSBkbV9ibGtfY29ycnVwdGVkX3JhbmdlLAo+PiAgIAkub3duZXIgPSBU
SElTX01PRFVMRQo+PiAgIH07Cj4+ICAgCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252ZGltbS9w
bWVtLmMgYi9kcml2ZXJzL252ZGltbS9wbWVtLmMKPj4gaW5kZXggNTAxOTU5OTQ3ZDQ4Li4zZDlm
NGNjYmJkOWUgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvbnZkaW1tL3BtZW0uYwo+PiArKysgYi9k
cml2ZXJzL252ZGltbS9wbWVtLmMKPj4gQEAgLTI1NiwyMSArMjU2LDE2IEBAIHN0YXRpYyBpbnQg
cG1lbV9yd19wYWdlKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHNlY3Rvcl90IHNlY3RvciwK
Pj4gICBzdGF0aWMgaW50IHBtZW1fY29ycnVwdGVkX3JhbmdlKHN0cnVjdCBnZW5kaXNrICpkaXNr
LCBzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LAo+PiAgIAkJCQlsb2ZmX3QgZGlza19vZmZzZXQs
IHNpemVfdCBsZW4sIHZvaWQgKmRhdGEpCj4+ICAgewo+PiAtCXN0cnVjdCBzdXBlcl9ibG9jayAq
c2I7Cj4+ICAgCWxvZmZfdCBiZGV2X29mZnNldDsKPj4gICAJc2VjdG9yX3QgZGlza19zZWN0b3Ig
PSBkaXNrX29mZnNldCA+PiBTRUNUT1JfU0hJRlQ7Cj4+IC0JaW50IHJjID0gMDsKPj4gKwlpbnQg
cmMgPSAtRU5PREVWOwo+PiAgIAo+PiAgIAliZGV2ID0gYmRnZXRfZGlza19zZWN0b3IoZGlzaywg
ZGlza19zZWN0b3IpOwo+PiAgIAlpZiAoIWJkZXYpCj4+IC0JCXJldHVybiAtRU5PREVWOwo+PiAr
CQlyZXR1cm4gcmM7Cj4+ICAgCj4+ICAgCWJkZXZfb2Zmc2V0ID0gKGRpc2tfc2VjdG9yIC0gZ2V0
X3N0YXJ0X3NlY3QoYmRldikpIDw8IFNFQ1RPUl9TSElGVDsKPj4gLQlzYiA9IGdldF9zdXBlcihi
ZGV2KTsKPj4gLQlpZiAoc2IgJiYgc2ItPnNfb3AtPmNvcnJ1cHRlZF9yYW5nZSkgewo+PiAtCQly
YyA9IHNiLT5zX29wLT5jb3JydXB0ZWRfcmFuZ2Uoc2IsIGJkZXYsIGJkZXZfb2Zmc2V0LCBsZW4s
IGRhdGEpOwo+PiAtCQlkcm9wX3N1cGVyKHNiKTsKPj4gLQl9Cj4+ICsJcmMgPSBiZF9jb3JydXB0
ZWRfcmFuZ2UoYmRldiwgYmRldl9vZmZzZXQsIGJkZXZfb2Zmc2V0LCBsZW4sIGRhdGEpOwo+PiAg
IAo+PiAgIAliZHB1dChiZGV2KTsKPj4gICAJcmV0dXJuIHJjOwo+PiBkaWZmIC0tZ2l0IGEvZnMv
YmxvY2tfZGV2LmMgYi9mcy9ibG9ja19kZXYuYwo+PiBpbmRleCAzYjg5NjNlMjI4YTEuLjNjYzJi
MjkxMWUzYSAxMDA2NDQKPj4gLS0tIGEvZnMvYmxvY2tfZGV2LmMKPj4gKysrIGIvZnMvYmxvY2tf
ZGV2LmMKPj4gQEAgLTEwNzksNiArMTA3OSwyNyBAQCBzdHJ1Y3QgYmRfaG9sZGVyX2Rpc2sgewo+
PiAgIAlpbnQJCQlyZWZjbnQ7Cj4+ICAgfTsKPj4gICAKPj4gK3N0YXRpYyBpbnQgYmRfZGlza19o
b2xkZXJfY29ycnVwdGVkX3JhbmdlKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGxvZmZfdCBv
ZmYsCj4+ICsJCQkJCSAgc2l6ZV90IGxlbiwgdm9pZCAqZGF0YSkKPj4gK3sKPj4gKwlzdHJ1Y3Qg
YmRfaG9sZGVyX2Rpc2sgKmhvbGRlcjsKPj4gKwlzdHJ1Y3QgZ2VuZGlzayAqZGlzazsKPj4gKwlp
bnQgcmMgPSAwOwo+PiArCj4+ICsJaWYgKGxpc3RfZW1wdHkoJihiZGV2LT5iZF9ob2xkZXJfZGlz
a3MpKSkKPj4gKwkJcmV0dXJuIC1FTk9ERVY7Cj4+ICsKPj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5
KGhvbGRlciwgJmJkZXYtPmJkX2hvbGRlcl9kaXNrcywgbGlzdCkgewo+PiArCQlkaXNrID0gaG9s
ZGVyLT5kaXNrOwo+PiArCQlpZiAoZGlzay0+Zm9wcy0+Y29ycnVwdGVkX3JhbmdlKSB7Cj4+ICsJ
CQlyYyA9IGRpc2stPmZvcHMtPmNvcnJ1cHRlZF9yYW5nZShkaXNrLCBiZGV2LCBvZmYsIGxlbiwg
ZGF0YSk7Cj4+ICsJCQlpZiAocmMgIT0gLUVOT0RFVikKPj4gKwkJCQlicmVhazsKPj4gKwkJfQo+
PiArCX0KPj4gKwlyZXR1cm4gcmM7Cj4+ICt9Cj4+ICsKPj4gICBzdGF0aWMgc3RydWN0IGJkX2hv
bGRlcl9kaXNrICpiZF9maW5kX2hvbGRlcl9kaXNrKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYs
Cj4+ICAgCQkJCQkJICBzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKPj4gICB7Cj4+IEBAIC0xMjEyLDcg
KzEyMzMsMjYgQEAgdm9pZCBiZF91bmxpbmtfZGlza19ob2xkZXIoc3RydWN0IGJsb2NrX2Rldmlj
ZSAqYmRldiwgc3RydWN0IGdlbmRpc2sgKmRpc2spCj4+ICAgCW11dGV4X3VubG9jaygmYmRldi0+
YmRfbXV0ZXgpOwo+PiAgIH0KPj4gICBFWFBPUlRfU1lNQk9MX0dQTChiZF91bmxpbmtfZGlza19o
b2xkZXIpOwo+PiAtI2VuZGlmCj4+ICsjZW5kaWYgLyogQ09ORklHX1NZU0ZTICovCj4+ICsKPj4g
K2ludCBiZF9jb3JydXB0ZWRfcmFuZ2Uoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgbG9mZl90
IGRpc2tfb2ZmLAo+PiArCQkgICAgICAgbG9mZl90IGJkZXZfb2ZmLCBzaXplX3QgbGVuLCB2b2lk
ICpkYXRhKQo+PiArewo+PiArCXN0cnVjdCBzdXBlcl9ibG9jayAqc2IgPSBnZXRfc3VwZXIoYmRl
dik7Cj4+ICsJaW50IHJjID0gLUVPUE5PVFNVUFA7Cj4+ICsKPj4gKwlpZiAoIXNiKSB7Cj4+ICsj
aWZkZWYgQ09ORklHX1NZU0ZTCj4+ICsJCXJjID0gYmRfZGlza19ob2xkZXJfY29ycnVwdGVkX3Jh
bmdlKGJkZXYsIGRpc2tfb2ZmLCBsZW4sIGRhdGEpOwo+PiArI2VuZGlmIC8qIENPTkZJR19TWVNG
UyAqLwo+IAo+IE5vcm1hbCBrZXJuZWwgY29udmVudGlvbiBpcyB0aGF0IHlvdSdkIHByb3ZpZGUg
YSBlbXB0eSBzaGVsbCBmb3IgdGhlCj4gQ09ORklHX1NZU0ZTPW4gY2FzZSwgZS5nLgo+IAo+ICNp
ZmRlZiBDT05GSUdfU1lTRlMKPiBpbnQgYmRfY29ycnVwdGVkX3JhbmdlKC4uLikgewo+IAkvKiBy
ZWFsIGNvZGUgKi8KPiB9Cj4gI2Vsc2UKPiBzdGF0aWMgaW5saW5lIGJkX2NvcnJ1cHRlZF9yYW5n
ZSguLi4pIHsgcmV0dXJuIC1FT1BOT1RTVVBQOyB9Cj4gI2VuZGlmCj4gCj4gc28gdGhhdCB5b3Ug
ZG9uJ3QgaGF2ZSBwcmVwcm9jZXNzb3IgZGlyZWN0aXZlcyBtYWtpbmcgdGhpcyBmdW5jdGlvbgo+
IGNob3BweS4KCkknbGwgZml4IGl0LgoKCi0tClRoYW5rcywKUnVhbiBTaGl5YW5nLgoKPiAKPiAt
LUQKPiAKPj4gKwkJcmV0dXJuIHJjOwo+PiArCX0gZWxzZSBpZiAoc2ItPnNfb3AtPmNvcnJ1cHRl
ZF9yYW5nZSkKPj4gKwkJcmMgPSBzYi0+c19vcC0+Y29ycnVwdGVkX3JhbmdlKHNiLCBiZGV2LCBi
ZGV2X29mZiwgbGVuLCBkYXRhKTsKPj4gKwlkcm9wX3N1cGVyKHNiKTsKPj4gKwo+PiArCXJldHVy
biByYzsKPj4gK30KPj4gK0VYUE9SVF9TWU1CT0woYmRfY29ycnVwdGVkX3JhbmdlKTsKPj4gICAK
Pj4gICBzdGF0aWMgdm9pZCBfX2Jsa2Rldl9wdXQoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwg
Zm1vZGVfdCBtb2RlLCBpbnQgZm9yX3BhcnQpOwo+PiAgIAo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9nZW5oZC5oIGIvaW5jbHVkZS9saW51eC9nZW5oZC5oCj4+IGluZGV4IDRkYTQ4MDc5
ODk1NS4uOTk2ZjkxYjA4ZDQ4IDEwMDY0NAo+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L2dlbmhkLmgK
Pj4gKysrIGIvaW5jbHVkZS9saW51eC9nZW5oZC5oCj4+IEBAIC0zMTUsNiArMzE1LDggQEAgdm9p
ZCB1bnJlZ2lzdGVyX2Jsa2Rldih1bnNpZ25lZCBpbnQgbWFqb3IsIGNvbnN0IGNoYXIgKm5hbWUp
Owo+PiAgIGJvb2wgYmRldl9jaGVja19tZWRpYV9jaGFuZ2Uoc3RydWN0IGJsb2NrX2RldmljZSAq
YmRldik7Cj4+ICAgaW50IF9faW52YWxpZGF0ZV9kZXZpY2Uoc3RydWN0IGJsb2NrX2RldmljZSAq
YmRldiwgYm9vbCBraWxsX2RpcnR5KTsKPj4gICB2b2lkIHNldF9jYXBhY2l0eShzdHJ1Y3QgZ2Vu
ZGlzayAqZGlzaywgc2VjdG9yX3Qgc2l6ZSk7Cj4+ICtpbnQgYmRfY29ycnVwdGVkX3JhbmdlKHN0
cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGxvZmZfdCBkaXNrX29mZiwKPj4gKwkJICAgICAgIGxv
ZmZfdCBiZGV2X29mZiwgc2l6ZV90IGxlbiwgdm9pZCAqZGF0YSk7Cj4+ICAgCj4+ICAgLyogZm9y
IGRyaXZlcnMvY2hhci9yYXcuYzogKi8KPj4gICBpbnQgYmxrZGV2X2lvY3RsKHN0cnVjdCBibG9j
a19kZXZpY2UgKiwgZm1vZGVfdCwgdW5zaWduZWQsIHVuc2lnbmVkIGxvbmcpOwo+PiAtLSAKPj4g
Mi4zMC4wCj4+Cj4+Cj4+Cj4gCj4gCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs


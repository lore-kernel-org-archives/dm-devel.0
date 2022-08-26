Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27819C3DA6B
	for <dm-devel@archiver.kernel.org>; Mon, 29 Aug 2022 05:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661752585;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Gt7x/4XAzncKdWJXpF7ehkmIniz0zF0lYFMOfBldaJg=;
	b=VB+M/7YwZMLLF8twpWOZ/DraVQTwd2t9sekB6oeaXS2d8g4BhlzsWG7CRCdG915zj1pV8m
	Uo3z+nNDp0+23c+txKOZeGwcqgsna81lPfHzmNcZzF+qGk2LfCzzZdCT0rP4IxGzWc7yL7
	4st5sR/x3qHlenH+NgwGt0f/Hm0o6S8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-yPsuQeS3PkuZzwWWfRvVQg-1; Mon, 29 Aug 2022 01:56:21 -0400
X-MC-Unique: yPsuQeS3PkuZzwWWfRvVQg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FE86803918;
	Mon, 29 Aug 2022 05:56:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B2EC2166B29;
	Mon, 29 Aug 2022 05:56:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EDEAC1946A45;
	Mon, 29 Aug 2022 05:56:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E70D01946A43
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 Aug 2022 20:16:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B922E4010D45; Fri, 26 Aug 2022 20:16:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B57A04010FA1
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 20:16:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9862B185A794
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 20:16:43 +0000 (UTC)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-55-QwWGSqbWNcSCTGckKuPrrg-1; Fri,
 26 Aug 2022 16:16:34 -0400
X-MC-Unique: QwWGSqbWNcSCTGckKuPrrg-1
Message-ID: <09bb7615-cf72-7f1e-9158-2ce231c0dda8@linux.dev>
Date: Fri, 26 Aug 2022 14:09:22 -0600
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Jonathan Derrick <jonathan.derrick@linux.dev>
To: Pankaj Raghav <p.raghav@samsung.com>, agk@redhat.com, snitzer@kernel.org, 
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com, hch@lst.de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121904eucas1p1cdedb3e9af928e25564f46e70765d39b@eucas1p1.samsung.com>
 <20220823121859.163903-4-p.raghav@samsung.com>
 <1dc85f87-7146-ccd2-bbf4-e3077dd7a548@linux.dev>
In-Reply-To: <1dc85f87-7146-ccd2-bbf4-e3077dd7a548@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 29 Aug 2022 05:56:16 +0000
Subject: Re: [dm-devel] [PATCH v12 03/13] block: allow blk-zoned devices to
 have non-power-of-2 zone size
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: bvanassche@acm.org, pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiA4LzI2LzIwMjIgMjowNiBQTSwgSm9uYXRoYW4gRGVycmljayB3cm90ZToKPiAKPiAKPiBP
biA4LzIzLzIwMjIgNjoxOCBBTSwgUGFua2FqIFJhZ2hhdiB3cm90ZToKPj4gQ2hlY2tpbmcgaWYg
YSBnaXZlbiBzZWN0b3IgaXMgYWxpZ25lZCB0byBhIHpvbmUgaXMgYSBjb21tb24KPj4gb3BlcmF0
aW9uIHRoYXQgaXMgcGVyZm9ybWVkIGZvciB6b25lZCBkZXZpY2VzLiBBZGQKPj4gYmRldl9pc196
b25lX3N0YXJ0IGhlbHBlciB0byBjaGVjayBmb3IgdGhpcyBpbnN0ZWFkIG9mIG9wZW5jb2Rpbmcg
aXQKPj4gZXZlcnl3aGVyZS4KPj4KPj4gQ29udmVydCB0aGUgY2FsY3VsYXRpb25zIG9uIHpvbmUg
c2l6ZSB0byBiZSBnZW5lcmljIGluc3RlYWQgb2YgcmVseWluZyBvbgo+PiBwb3dlci1vZi0yKHBv
MikgYmFzZWQgYXJpdGhtZXRpYyBpbiB0aGUgYmxvY2sgbGF5ZXIgdXNpbmcgdGhlIGhlbHBlcnMK
Pj4gd2hlcmV2ZXIgcG9zc2libGUuCj4+Cj4+IFRoZSBvbmx5IGhvdCBwYXRoIGFmZmVjdGVkIGJ5
IHRoaXMgY2hhbmdlIGZvciB6b25lZCBkZXZpY2VzIHdpdGggcG8yCj4+IHpvbmUgc2l6ZSBpcyBp
biBibGtfY2hlY2tfem9uZV9hcHBlbmQoKSBidXQgYmRldl9pc196b25lX3N0YXJ0KCkgCj4+IGhl
bHBlciBpcwo+PiB1c2VkIHRvIG9wdGltaXplIHRoZSBjYWxjdWxhdGlvbiBmb3IgcG8yIHpvbmUg
c2l6ZXMuCj4+Cj4+IEZpbmFsbHksIGFsbG93IHpvbmVkIGRldmljZXMgd2l0aCBub24gcG8yIHpv
bmUgc2l6ZXMgcHJvdmlkZWQgdGhhdCB0aGVpcgo+PiB6b25lIGNhcGFjaXR5IGFuZCB6b25lIHNp
emUgYXJlIGVxdWFsLiBUaGUgbWFpbiBtb3RpdmF0aW9uIHRvIGFsbG93IHpvbmVkCj4+IGRldmlj
ZXMgd2l0aCBub24gcG8yIHpvbmUgc2l6ZSBpcyB0byByZW1vdmUgdGhlIHVubWFwcGVkIExCQSBi
ZXR3ZWVuCj4+IHpvbmUgY2FwY2l0eSBhbmQgem9uZSBzaXplIGZvciBkZXZpY2VzIHRoYXQgY2Fu
bm90IGhhdmUgYSBwbzIgem9uZQo+PiBjYXBhY2l0eS4KPj4KPj4gUmV2aWV3ZWQtYnk6IEx1aXMg
Q2hhbWJlcmxhaW4gPG1jZ3JvZkBrZXJuZWwub3JnPgo+PiBSZXZpZXdlZC1ieTogSGFubmVzIFJl
aW5lY2tlIDxoYXJlQHN1c2UuZGU+Cj4+IFJldmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2
YW5hc3NjaGVAYWNtLm9yZz4KPj4gU2lnbmVkLW9mZi1ieTogUGFua2FqIFJhZ2hhdiA8cC5yYWdo
YXZAc2Ftc3VuZy5jb20+Cj4+IC0tLQo+PiDCoCBibG9jay9ibGstY29yZS5jwqDCoMKgwqDCoMKg
IHzCoCAyICstCj4+IMKgIGJsb2NrL2Jsay16b25lZC5jwqDCoMKgwqDCoCB8IDI0ICsrKysrKysr
KysrKysrKysrKy0tLS0tLQo+PiDCoCBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oIHwgMzAgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrCj4+IMKgIDMgZmlsZXMgY2hhbmdlZCwgNDkgaW5zZXJ0
aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1jb3Jl
LmMgYi9ibG9jay9ibGstY29yZS5jCj4+IGluZGV4IGEwZDExMDRjNTU5MC4uMWNiNTE5MjIwZmZi
IDEwMDY0NAo+PiAtLS0gYS9ibG9jay9ibGstY29yZS5jCj4+ICsrKyBiL2Jsb2NrL2Jsay1jb3Jl
LmMKPj4gQEAgLTU2Myw3ICs1NjMsNyBAQCBzdGF0aWMgaW5saW5lIGJsa19zdGF0dXNfdCAKPj4g
YmxrX2NoZWNrX3pvbmVfYXBwZW5kKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLAo+PiDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIEJMS19TVFNfTk9UU1VQUDsKPj4gwqDCoMKgwqDCoCAvKiBUaGUg
YmlvIHNlY3RvciBtdXN0IHBvaW50IHRvIHRoZSBzdGFydCBvZiBhIHNlcXVlbnRpYWwgem9uZSAq
Lwo+PiAtwqDCoMKgIGlmIChiaW8tPmJpX2l0ZXIuYmlfc2VjdG9yICYgKGJkZXZfem9uZV9zZWN0
b3JzKGJpby0+YmlfYmRldikgLSAKPj4gMSkgfHwKPj4gK8KgwqDCoCBpZiAoIWJkZXZfaXNfem9u
ZV9zdGFydChiaW8tPmJpX2JkZXYsIGJpby0+YmlfaXRlci5iaV9zZWN0b3IpIHx8Cj4+IMKgwqDC
oMKgwqDCoMKgwqDCoCAhYmlvX3pvbmVfaXNfc2VxKGJpbykpCj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gQkxLX1NUU19JT0VSUjsKPj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay16b25lZC5j
IGIvYmxvY2svYmxrLXpvbmVkLmMKPj4gaW5kZXggZGNlOWM5NWI0YmNkLi42ODA2YzY5YzgxZGMg
MTAwNjQ0Cj4+IC0tLSBhL2Jsb2NrL2Jsay16b25lZC5jCj4+ICsrKyBiL2Jsb2NrL2Jsay16b25l
ZC5jCj4+IEBAIC0yODUsMTAgKzI4NSwxMCBAQCBpbnQgYmxrZGV2X3pvbmVfbWdtdChzdHJ1Y3Qg
YmxvY2tfZGV2aWNlICpiZGV2LCAKPj4gZW51bSByZXFfb3Agb3AsCj4+IMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gLUVJTlZBTDsKPj4gwqDCoMKgwqDCoCAvKiBDaGVjayBhbGlnbm1lbnQgKGhh
bmRsZSBldmVudHVhbCBzbWFsbGVyIGxhc3Qgem9uZSkgKi8KPj4gLcKgwqDCoCBpZiAoc2VjdG9y
ICYgKHpvbmVfc2VjdG9ycyAtIDEpKQo+PiArwqDCoMKgIGlmICghYmRldl9pc196b25lX3N0YXJ0
KGJkZXYsIHNlY3RvcikpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPj4g
LcKgwqDCoCBpZiAoKG5yX3NlY3RvcnMgJiAoem9uZV9zZWN0b3JzIC0gMSkpICYmIGVuZF9zZWN0
b3IgIT0gY2FwYWNpdHkpCj4+ICvCoMKgwqAgaWYgKCFiZGV2X2lzX3pvbmVfc3RhcnQoYmRldiwg
bnJfc2VjdG9ycykgJiYgZW5kX3NlY3RvciAhPSBjYXBhY2l0eSkKPj4gwqDCoMKgwqDCoMKgwqDC
oMKgIHJldHVybiAtRUlOVkFMOwo+PiDCoMKgwqDCoMKgIC8qCj4+IEBAIC00ODYsMTQgKzQ4Niwy
NiBAQCBzdGF0aWMgaW50IGJsa19yZXZhbGlkYXRlX3pvbmVfY2Ioc3RydWN0IAo+PiBibGtfem9u
ZSAqem9uZSwgdW5zaWduZWQgaW50IGlkeCwKPj4gwqDCoMKgwqDCoMKgICogc21hbGxlciBsYXN0
IHpvbmUuCj4+IMKgwqDCoMKgwqDCoCAqLwo+PiDCoMKgwqDCoMKgIGlmICh6b25lLT5zdGFydCA9
PSAwKSB7Cj4+IC3CoMKgwqDCoMKgwqDCoCBpZiAoem9uZS0+bGVuID09IDAgfHwgIWlzX3Bvd2Vy
X29mXzIoem9uZS0+bGVuKSkgewo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcl93YXJuKCIl
czogSW52YWxpZCB6b25lZCBkZXZpY2Ugd2l0aCBub24gcG93ZXIgb2YgdHdvIAo+PiB6b25lIHNp
emUgKCVsbHUpXG4iLAo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRpc2stPmRp
c2tfbmFtZSwgem9uZS0+bGVuKTsKPj4gK8KgwqDCoMKgwqDCoMKgIGlmICh6b25lLT5sZW4gPT0g
MCkgewo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcl93YXJuKCIlczogSW52YWxpZCB6ZXJv
IHpvbmUgc2l6ZSIsIGRpc2stPmRpc2tfbmFtZSk7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJldHVybiAtRU5PREVWOwo+PiArwqDCoMKgwqDCoMKgwqAgfQo+PiArCj4+ICvCoMKgwqDCoMKg
wqDCoCAvKgo+PiArwqDCoMKgwqDCoMKgwqDCoCAqIE5vbiBwb3dlci1vZi0yIHpvbmUgc2l6ZSBz
dXBwb3J0IHdhcyBhZGRlZCB0byByZW1vdmUgdGhlCj4+ICvCoMKgwqDCoMKgwqDCoMKgICogZ2Fw
IGJldHdlZW4gem9uZSBjYXBhY2l0eSBhbmQgem9uZSBzaXplLiBUaG91Z2ggaXQgaXMgCj4+IHRl
Y2huaWNhbGx5Cj4+ICvCoMKgwqDCoMKgwqDCoMKgICogcG9zc2libGUgdG8gaGF2ZSBnYXBzIGlu
IGEgbm9uIHBvd2VyLW9mLTIgZGV2aWNlLCBMaW51eCAKPj4gcmVxdWlyZXMKPj4gK8KgwqDCoMKg
wqDCoMKgwqAgKiB0aGUgem9uZSBzaXplIHRvIGJlIGVxdWFsIHRvIHpvbmUgY2FwYWNpdHkgZm9y
IG5vbiBwb3dlci1vZi0yCj4+ICvCoMKgwqDCoMKgwqDCoMKgICogem9uZWQgZGV2aWNlcy4KPj4g
K8KgwqDCoMKgwqDCoMKgwqAgKi8KPj4gK8KgwqDCoMKgwqDCoMKgIGlmICghaXNfcG93ZXJfb2Zf
Mih6b25lLT5sZW4pICYmIHpvbmUtPmNhcGFjaXR5IDwgem9uZS0+bGVuKSB7Cj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHByX2VycigiJXM6IEludmFsaWQgem9uZSBjYXBhY2l0eSAlbGxkIHdp
dGggbm9uIAo+PiBwb3dlci1vZi0yIHpvbmUgc2l6ZSAlbGxkIiwKPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkaXNrLT5kaXNrX25hbWUsIHpvbmUtPmNhcGFjaXR5LCB6
b25lLT5sZW4pOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVOT0RFVjsK
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIH0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGFyZ3MtPnpvbmVf
c2VjdG9ycyA9IHpvbmUtPmxlbjsKPj4gLcKgwqDCoMKgwqDCoMKgIGFyZ3MtPm5yX3pvbmVzID0g
KGNhcGFjaXR5ICsgem9uZS0+bGVuIC0gMSkgPj4gaWxvZzIoem9uZS0+bGVuKTsKPj4gK8KgwqDC
oMKgwqDCoMKgIGFyZ3MtPm5yX3pvbmVzID0gZGl2NjRfdTY0KGNhcGFjaXR5ICsgem9uZS0+bGVu
IC0gMSwgem9uZS0+bGVuKTsKPj4gwqDCoMKgwqDCoCB9IGVsc2UgaWYgKHpvbmUtPnN0YXJ0ICsg
YXJncy0+em9uZV9zZWN0b3JzIDwgY2FwYWNpdHkpIHsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGlm
ICh6b25lLT5sZW4gIT0gYXJncy0+em9uZV9zZWN0b3JzKSB7Cj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHByX3dhcm4oIiVzOiBJbnZhbGlkIHpvbmVkIGRldmljZSB3aXRoIG5vbiBjb25z
dGFudCB6b25lIAo+PiBzaXplXG4iLAo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9ibGtk
ZXYuaCBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPj4gaW5kZXggODRlNzg4MTI2MmUzLi5kMGQ2
NmEwZGIyMjQgMTAwNjQ0Cj4+IC0tLSBhL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPj4gKysrIGIv
aW5jbHVkZS9saW51eC9ibGtkZXYuaAo+PiBAQCAtNzA0LDYgKzcwNCwzMCBAQCBzdGF0aWMgaW5s
aW5lIHVuc2lnbmVkIGludCBkaXNrX3pvbmVfbm8oc3RydWN0IAo+PiBnZW5kaXNrICpkaXNrLCBz
ZWN0b3JfdCBzZWN0b3IpCj4+IMKgwqDCoMKgwqAgcmV0dXJuIGRpdjY0X3U2NChzZWN0b3IsIHpv
bmVfc2VjdG9ycyk7Cj4+IMKgIH0KPj4gK3N0YXRpYyBpbmxpbmUgc2VjdG9yX3QgYmRldl9vZmZz
ZXRfZnJvbV96b25lX3N0YXJ0KHN0cnVjdCAKPj4gYmxvY2tfZGV2aWNlICpiZGV2LAo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZWN0b3Jf
dCBzZWMpCj4+ICt7Cj4+ICvCoMKgwqAgc2VjdG9yX3Qgem9uZV9zZWN0b3JzID0gYmRldl96b25l
X3NlY3RvcnMoYmRldik7Cj4+ICvCoMKgwqAgdTY0IHJlbWFpbmRlciA9IDA7Cj4+ICsKPj4gK8Kg
wqDCoCBpZiAoIWJkZXZfaXNfem9uZWQoYmRldikpCj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4g
MDsKPiBTZWUgYmVsb3cKPiAKPj4gKwo+PiArwqDCoMKgIGlmIChpc19wb3dlcl9vZl8yKHpvbmVf
c2VjdG9ycykpCj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gc2VjICYgKHpvbmVfc2VjdG9ycyAt
IDEpOwo+PiArCj4+ICvCoMKgwqAgZGl2NjRfdTY0X3JlbShzZWMsIHpvbmVfc2VjdG9ycywgJnJl
bWFpbmRlcik7Cj4+ICvCoMKgwqAgcmV0dXJuIHJlbWFpbmRlcjsKPj4gK30KPj4gKwo+PiArc3Rh
dGljIGlubGluZSBib29sIGJkZXZfaXNfem9uZV9zdGFydChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpi
ZGV2LCAKPj4gc2VjdG9yX3Qgc2VjKQo+PiArewo+PiArwqDCoMKgIGlmICghYmRldl9pc196b25l
ZChiZGV2KSkKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsKPiBEdXBsaWNhdGluZyB0
aGUgc2FtZSBjaGVjayBhYm92ZSwgYW5kIHRoZSBjaGVjayBhYm92ZSBpcyBsZXNzIGNsZWFyIGlu
IAo+IHRoZSBjYXNlIG9mICF6b25lZCBzaW5jZSBpdCByZXR1cm5zIDAgYW5kIG5vdCBzb21lIHdh
cm5pbmcgdGhhdCBtYWtlcyAKPiBzZW5zZSBpbiB0aGUgY2FzZSBvZiB6b25lZCBjaGVjayBvbiAh
em9uZWQgYmRldi4KPiBDYW4geW91IHNpbXBseSBleGNsdWRlIGFib3ZlIGNoZWNrPwpOZXZlcm1p
bmQsIGp1c3Qgbm90aWNlZCBiZGV2X29mZnNldF9mcm9tX3pvbmVfc3RhcnQgaXMgdXNlZCBpbiBs
YXRlciAKcGF0Y2hlcy4KCj4gCj4gCj4+ICsKPj4gK8KgwqDCoCByZXR1cm4gYmRldl9vZmZzZXRf
ZnJvbV96b25lX3N0YXJ0KGJkZXYsIHNlYykgPT0gMDsKPj4gK30KPj4gKwo+PiDCoCBzdGF0aWMg
aW5saW5lIGJvb2wgZGlza196b25lX2lzX3NlcShzdHJ1Y3QgZ2VuZGlzayAqZGlzaywgc2VjdG9y
X3QgCj4+IHNlY3RvcikKPj4gwqAgewo+PiDCoMKgwqDCoMKgIGlmICghYmxrX3F1ZXVlX2lzX3pv
bmVkKGRpc2stPnF1ZXVlKSkKPj4gQEAgLTc0OCw2ICs3NzIsMTIgQEAgc3RhdGljIGlubGluZSB1
bnNpZ25lZCBpbnQgZGlza196b25lX25vKHN0cnVjdCAKPj4gZ2VuZGlzayAqZGlzaywgc2VjdG9y
X3Qgc2VjdG9yKQo+PiDCoCB7Cj4+IMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4+IMKgIH0KPj4gKwo+
PiArc3RhdGljIGlubGluZSBib29sIGJkZXZfaXNfem9uZV9zdGFydChzdHJ1Y3QgYmxvY2tfZGV2
aWNlICpiZGV2LCAKPj4gc2VjdG9yX3Qgc2VjKQo+PiArewo+PiArwqDCoMKgIHJldHVybiBmYWxz
ZTsKPj4gK30KPj4gKwo+PiDCoCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBiZGV2X21heF9v
cGVuX3pvbmVzKHN0cnVjdCBibG9ja19kZXZpY2UgCj4+ICpiZGV2KQo+PiDCoCB7Cj4+IMKgwqDC
oMKgwqAgcmV0dXJuIDA7CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BCEC64EC4
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 01:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678151794;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7EZYO+jhhPVWeeggYKCmOxS4ACEiG84HCRaHaMUpabM=;
	b=LffcbyxRmdlvtL5YhRlc0yhcq+TUQeGmfpxProVX8G7g1vHz77DdENSzjgwUf4NaeEjlG1
	LsBgiAtaoeeU3Cd8CjvGD2uphH5ZyPeXSMNLKONSUoefe96Z4OHP/+eT7E1SsfPcvmFhVW
	d2UvxLMnF9S26U3Biw5yfBoFthtIIwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-vgIEiw5sMyWVB9G9WMlflA-1; Mon, 06 Mar 2023 20:16:31 -0500
X-MC-Unique: vgIEiw5sMyWVB9G9WMlflA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 737E585CBE2;
	Tue,  7 Mar 2023 01:16:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 02476C16029;
	Tue,  7 Mar 2023 01:16:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9DDA91946595;
	Tue,  7 Mar 2023 01:16:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7BF01946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 01:16:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1991C1602A; Tue,  7 Mar 2023 01:16:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A69BC16029
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 01:16:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4736E3C025D9
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 01:16:22 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-vtDu3sm9P7W-l7QpNcQBfw-1; Mon, 06 Mar 2023 20:16:17 -0500
X-MC-Unique: vtDu3sm9P7W-l7QpNcQBfw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PVyFN4mZGz4f3jHm;
 Tue,  7 Mar 2023 09:16:08 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
 by APP4 (Coremail) with SMTP id gCh0CgBXwLNXkAZkDhKLEw--.63350S3;
 Tue, 07 Mar 2023 09:16:09 +0800 (CST)
Message-ID: <73107895-206b-78ca-8393-7d32765b7ed8@huaweicloud.com>
Date: Tue, 7 Mar 2023 09:16:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <alpine.LRH.2.21.2303061115140.24847@file01.intranet.prod.int.rdu2.redhat.com>
 <ZAYV6OekGBVFgjAM@redhat.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <ZAYV6OekGBVFgjAM@redhat.com>
X-CM-TRANSID: gCh0CgBXwLNXkAZkDhKLEw--.63350S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJw13ZFWkuFy3ur1fJw1kKrg_yoWrWFyxpF
 sxWr9akws7JryjqrsFkF1UtFyUtrsrAFy7JryxWF1kAa4Uuw1DJ3yUCw4rXr9xGFy7Cry7
 tr1DJFy8tr17JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] dm-crypt: add cond_resched() to dmcrypt_write()
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
Cc: yangerkun@huawei.com, dm-devel@redhat.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMy8zLzcgMDozMywgTWlrZSBTbml0emVyIOWGmemBkzoKPiBPbiBNb24sIE1hciAw
NiAyMDIzIGF0IDExOjE3UCAtMDUwMCwKPiBNaWt1bGFzIFBhdG9ja2EgPG1wYXRvY2thQHJlZGhh
dC5jb20+IHdyb3RlOgo+IAo+PiBUaGUgbG9vcCBpbiBkbWNyeXB0X3dyaXRlIG1heSBiZSBydW5u
aW5nIGZvciB1bmJvdW5kZWQgYW1vdW50IG9mIHRpbWUsCj4+IHRodXMgd2UgbmVlZCBjb25kX3Jl
c2NoZWQoKSBpbiBpdC4KPj4KPj4gVGhpcyBjb21taXQgZml4ZXMgdGhlIGZvbGxvd2luZyB3YXJu
aW5nOgo+Pgo+PiBbIDMzOTEuMTUzMjU1XVsgICBDMTJdIHdhdGNoZG9nOiBCVUc6IHNvZnQgbG9j
a3VwIC0gQ1BVIzEyIHN0dWNrIGZvciAyM3MhIFtkbWNyeXB0X3dyaXRlLzI6Mjg5N10KPj4gLi4u
Cj4+IFsgMzM5MS4yNTgzNzJdWyAgIEMxMl0gQ1BVOiAxMiBQSUQ6IDI4OTcgQ29tbTogZG1jcnlw
dF93cml0ZS8yIFRhaW50ZWQ6IEcgICAgICAgICAgICAgTCAgICA1LjEwLjArICM4Cj4+IFsgMzM5
MS4yNjcyODhdWyAgIEMxMl0gSGFyZHdhcmUgbmFtZTogSHVhd2VpIFRhaVNoYW4gMjI4MCBWMi9C
QzgyQU1EREEsIEJJT1MgMS43NSAwNC8yNi8yMDIxCj4+IFsgMzM5MS4yNzU0MjhdWyAgIEMxMl0g
cHN0YXRlOiA4MDQwMDAwOSAoTnpjdiBkYWlmICtQQU4gLVVBTyAtVENPIEJUWVBFPS0tKQo+PiBb
IDMzOTEuMjgyMTAyXVsgICBDMTJdIHBjIDogYmxrX2F0dGVtcHRfYmlvX21lcmdlLnBhcnQuNisw
eDM4LzB4MTU4Cj4+IFsgMzM5MS4yODgwODBdWyAgIEMxMl0gbHIgOiBibGtfYXR0ZW1wdF9wbHVn
X21lcmdlKzB4YzAvMHgxYjAKPj4gWyAzMzkxLjI5MzU0MF1bICAgQzEyXSBzcCA6IGZmZmY4MDAw
NzE4YWJjMzAKPj4gWyAzMzkxLjI5NzUzMF1bICAgQzEyXSB4Mjk6IGZmZmY4MDAwNzE4YWJjMzAg
eDI4OiAwMDAwMDAwMDAwMDAwMDAwCj4+IFsgMzM5MS4zMDM1MDldWyAgIEMxMl0geDI3OiBmZmZm
MjAyMDM2MWQ5YWMwIHgyNjogMDAwMDAwMDAwMDAwMDAwMQo+PiBbIDMzOTEuMzA5NDg4XVsgICBD
MTJdIHgyNTogMDAwMDAwMDAwMDAwMDAwMSB4MjQ6IGZmZmY4MDAwNzE4YWJkMDgKPj4gWyAzMzkx
LjMxNTQ2N11bICAgQzEyXSB4MjM6IGZmZmYwMDIwYTEwZGJiMDAgeDIyOiAwMDAwMDAwMDAwMDAw
MDAxCj4+IFsgMzM5MS4zMjE0NDVdWyAgIEMxMl0geDIxOiBmZmZmODAwMDcxOGFiZTIwIHgyMDog
ZmZmZjAwMjBhMTBkYmIwMAo+PiBbIDMzOTEuMzI3NDI0XVsgICBDMTJdIHgxOTogZmZmZjAwMjBh
ZWQ3YjA0MCB4MTg6IDAwMDAwMDAwMDAwMDAwMDAKPj4gWyAzMzkxLjMzMzQwMl1bICAgQzEyXSB4
MTc6IDAwMDAwMDAwMDAwMDAwMDAgeDE2OiBmZmZmZmRmZmZmZTAwMDAwCj4+IFsgMzM5MS4zMzkz
ODFdWyAgIEMxMl0geDE1OiAwMDAwMDAwMDAwMDAxMDAwIHgxNDogMDAwMDAwMDAwMDAwMDAwMAo+
PiBbIDMzOTEuMzQ1MzU5XVsgICBDMTJdIHgxMzogMDAwMDAwMDAwMDAwMjAwMCB4MTI6IGZmZmYy
MDYwMDExZjkwNzAKPj4gWyAzMzkxLjM1MTMzOF1bICAgQzEyXSB4MTE6IDAwMDAwMDAwMDAwMDAw
MDEgeDEwOiAwMDAwMDAwMDAwMDAwMDAyCj4+IFsgMzM5MS4zNTczMTZdWyAgIEMxMl0geDkgOiBm
ZmZmODAwMDEwNTg2YzM4IHg4IDogZmZmZjIwMjAwOWE3ZjIwMAo+PiBbIDMzOTEuMzYzMjk0XVsg
ICBDMTJdIHg3IDogZmZmZjgwMDA3MThhYmQwMCB4NiA6IGZmZmYyMDIwMGRmMzM3NTAKPj4gWyAz
MzkxLjM2OTI3NF1bICAgQzEyXSB4NSA6IDAwMDAwMDAwMDAwMDAwMDEgeDQgOiAwMDAwMDAwMDAw
MDAwMDAwCj4+IFsgMzM5MS4zNzUyNTJdWyAgIEMxMl0geDMgOiAwMDAwMDAwMDAwMDAwMDAxIHgy
IDogZmZmZjAwMjBhMTBkYmIwMAo+PiBbIDMzOTEuMzgxMjMwXVsgICBDMTJdIHgxIDogZmZmZjAw
MjBhZWQ3YjA0MCB4MCA6IDAwMDAwMDAwMDAwMDEwMDAKPj4gWyAzMzkxLjM4NzIxMF1bICAgQzEy
XSBDYWxsIHRyYWNlOgo+PiBbIDMzOTEuMzkwMzM4XVsgICBDMTJdICBibGtfYXR0ZW1wdF9iaW9f
bWVyZ2UucGFydC42KzB4MzgvMHgxNTgKPj4gWyAzMzkxLjM5NTk3MF1bICAgQzEyXSAgYmxrX2F0
dGVtcHRfcGx1Z19tZXJnZSsweGMwLzB4MWIwCj4+IFsgMzM5MS40MDEwODVdWyAgIEMxMl0gIGJs
a19tcV9zdWJtaXRfYmlvKzB4Mzk4LzB4NTUwCj4+IFsgMzM5MS40MDU4NTZdWyAgIEMxMl0gIHN1
Ym1pdF9iaW9fbm9hY2N0KzB4MzA4LzB4MzgwCj4+IFsgMzM5MS40MTA2MzBdWyAgIEMxMl0gIGRt
Y3J5cHRfd3JpdGUrMHgxZTQvMHgyMDggW2RtX2NyeXB0XQo+PiBbIDMzOTEuNDE2MDA1XVsgICBD
MTJdICBrdGhyZWFkKzB4MTMwLzB4MTM4Cj4+IFsgMzM5MS40MTk5MTFdWyAgIEMxMl0gIHJldF9m
cm9tX2ZvcmsrMHgxMC8weDE4Cj4+Cj4+IFNpZ25lZC1vZmYtYnk6IE1pa3VsYXMgUGF0b2NrYSA8
bXBhdG9ja2FAcmVkaGF0LmNvbT4KPj4gUmVwb3J0ZWQtYnk6IHlhbmdlcmt1biA8eWFuZ2Vya3Vu
QGh1YXdlaS5jb20+Cj4+IEZpeGVzOiBkYzI2NzYyMTBjNDIgKCJkbSBjcnlwdDogb2ZmbG9hZCB3
cml0ZXMgdG8gdGhyZWFkIikKPj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKPj4KPj4gLS0t
Cj4+ICAgZHJpdmVycy9tZC9kbS1jcnlwdC5jIHwgICAgMSArCj4+ICAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspCj4+Cj4+IEluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9tZC9kbS1jcnlw
dC5jCj4+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KPj4gLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvbWQvZG0tY3J5
cHQuYwo+PiArKysgbGludXgtMi42L2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+PiBAQCAtMTk1NCw2
ICsxOTU0LDcgQEAgcG9wX2Zyb21fbGlzdDoKPj4gICAJCQlpbyA9IGNyeXB0X2lvX2Zyb21fbm9k
ZShyYl9maXJzdCgmd3JpdGVfdHJlZSkpOwo+PiAgIAkJCXJiX2VyYXNlKCZpby0+cmJfbm9kZSwg
JndyaXRlX3RyZWUpOwo+PiAgIAkJCWtjcnlwdGRfaW9fd3JpdGUoaW8pOwo+PiArCQkJY29uZF9y
ZXNjaGVkKCk7Cj4+ICAgCQl9IHdoaWxlICghUkJfRU1QVFlfUk9PVCgmd3JpdGVfdHJlZSkpOwo+
PiAgIAkJYmxrX2ZpbmlzaF9wbHVnKCZwbHVnKTsKPj4gICAJfQo+Pgo+IAo+IEkgc3VnZ2VzdGVk
IHRoZSBzYW1lIGhlcmU6Cj4gaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vYXJjaGl2ZXMvZG0t
ZGV2ZWwvMjAyMy1GZWJydWFyeS8wNTM0MDIuaHRtbAo+IAo+IFlldCB5YW5nZXJrdW4gcmVzaXN0
ZWQgaXQ6Cj4gaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vYXJjaGl2ZXMvZG0tZGV2ZWwvMjAy
My1GZWJydWFyeS8wNTM0MTAuaHRtbAo+IAo+IEFuZCBzdHVjayB3aXRoIHRoZWlyIG1vcmUgdGhy
b3R0bGVkIGFwcHJvYWNoICh3aGljaCBsb29rcyB3cm9uZyB0byBtZSwKPiBzaG91bGRuJ3QgaXQg
YmUgdXNpbmcgdGltZV9pc19hZnRlcl9qaWZmaWVzIT8pCgpIaSwKCi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0+CiAg
ICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgfAogICAg
ICAgICAgICAgICBzdGFydF90aW1lICAgICBzdGFydF90aW1lICsgSFogICAgIGppZmZpZXMKCihz
dGFydF90aW1lICsgSFopIDwgamlmZmllcyBtZWFucyBzaW5jZSBzdGFydF90aW1lLCB3ZSBoYXZl
IHBhc3MgMXMsIHNvIAp3ZSBuZWVkIHRvIGNvbmRfcmVzY2hlZChzZWUgd3JpdGViYWNrX3NiX2lu
b2RlcyBhbmQgCmJsa19tcV9kb19kaXNwYXRjaF9zY2hlZCkuLi4KClRoYW5rcywKS3VuLgoKPiBo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9hcmNoaXZlcy9kbS1kZXZlbC8yMDIzLU1hcmNoLzA1
MzQ3My5odG1sCj4gCj4gQW55d2F5LCBJJ20gaW5jbGluZWQgdG8gdGFrZSB5b3VyIHBhdGNoLCBJ
IHNoYXJlIHlvdXIgdmlld3M6Cj4gaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vYXJjaGl2ZXMv
ZG0tZGV2ZWwvMjAyMy1NYXJjaC8wNTM0NzAuaHRtbAoKPiAKPiBNaWtlCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


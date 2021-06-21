Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6620C49EAB
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5E67A61C5E
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E67A61C5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-GO_RpDlPNBSGgcG2jJQ70Q-1; Mon, 28 Jun 2021 05:52:58 -0400
X-MC-Unique: GO_RpDlPNBSGgcG2jJQ70Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A16B362FA;
	Mon, 28 Jun 2021 09:52:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E90185D6AD;
	Mon, 28 Jun 2021 09:52:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BDC5B1809CB2;
	Mon, 28 Jun 2021 09:52:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15LBXl6X008158 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Jun 2021 07:33:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F1DAF20236FE; Mon, 21 Jun 2021 11:33:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED419200BCE9
	for <dm-devel@redhat.com>; Mon, 21 Jun 2021 11:33:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CBA180D1BF
	for <dm-devel@redhat.com>; Mon, 21 Jun 2021 11:33:44 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-326-8zpKsiZuMFKwrEHGUdqDlQ-1;
	Mon, 21 Jun 2021 07:33:39 -0400
X-MC-Unique: 8zpKsiZuMFKwrEHGUdqDlQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R571e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UdA9Y25_1624275214
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UdA9Y25_1624275214) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 21 Jun 2021 19:33:35 +0800
To: Ming Lei <ming.lei@redhat.com>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-4-ming.lei@redhat.com>
	<5ba43dac-b960-7c85-3a89-fdae2d1e2f51@linux.alibaba.com>
	<YMywCX6nLqLiHXyy@T590>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <9b42601a-ca54-4748-e592-3720b7994d7b@linux.alibaba.com>
Date: Mon, 21 Jun 2021 19:33:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMywCX6nLqLiHXyy@T590>
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
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [RFC PATCH V2 3/3] dm: support bio polling
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

CgpPbiA2LzE4LzIxIDEwOjM5IFBNLCBNaW5nIExlaSB3cm90ZToKPiBGcm9tIDQ3ZTUyM2I5ZWU5
ODgzMTczNjllYWFkYjk2ODI2MzIzY2Q4NjgxOWUgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxCj4g
RnJvbTogTWluZyBMZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+Cj4gRGF0ZTogV2VkLCAxNiBKdW4g
MjAyMSAxNjoxMzo0NiArMDgwMAo+IFN1YmplY3Q6IFtSRkMgUEFUQ0ggVjMgMy8zXSBkbTogc3Vw
cG9ydCBiaW8gcG9sbGluZwo+IAo+IFN1cHBvcnQgYmlvKFJFUV9QT0xMRUQpIHBvbGxpbmcgaW4g
dGhlIGZvbGxvd2luZyBhcHByb2FjaDoKPiAKPiAxKSBvbmx5IHN1cHBvcnQgaW8gcG9sbGluZyBv
biBub3JtYWwgUkVBRC9XUklURSwgYW5kIG90aGVyIGFibm9ybWFsIElPcwo+IHN0aWxsIGZhbGxi
YWNrIG9uIElSUSBtb2RlLCBzbyB0aGUgdGFyZ2V0IGlvIGlzIGV4YWN0bHkgaW5zaWRlIHRoZSBk
bQo+IGlvLgo+IAo+IDIpIGhvbGQgb25lIHJlZmNudCBvbiBpby0+aW9fY291bnQgYWZ0ZXIgc3Vi
bWl0dGluZyB0aGlzIGRtIGJpbyB3aXRoCj4gUkVRX1BPTExFRAo+IAo+IDMpIHN1cHBvcnQgZG0g
bmF0aXZlIGJpbyBzcGxpdHRpbmcsIGFueSBkbSBpbyBpbnN0YW5jZSBhc3NvY2lhdGVkIHdpdGgK
PiBjdXJyZW50IGJpbyB3aWxsIGJlIGFkZGVkIGludG8gb25lIGxpc3Qgd2hpY2ggaGVhZCBpcyBi
aW8tPmJpX2VuZF9pbwo+IHdoaWNoIHdpbGwgYmUgcmVjb3ZlcmVkIGJlZm9yZSBlbmRpbmcgdGhp
cyBiaW8KPiAKPiA0KSBpbXBsZW1lbnQgLnBvbGxfYmlvKCkgY2FsbGJhY2ssIGNhbGwgYmlvX3Bv
bGwoKSBvbiB0aGUgc2luZ2xlIHRhcmdldAo+IGJpbyBpbnNpZGUgdGhlIGRtIGlvIHdoaWNoIGlz
IHJldHJpZXZlZCB2aWEgYmlvLT5iaV9iaW9fZHJ2X2RhdGE7IGNhbGwKPiBkZWNfcGVuZGluZygp
IGFmdGVyIHRoZSB0YXJnZXQgaW8gaXMgZG9uZSBpbiAucG9sbF9iaW8oKQo+IAo+IDQpIGVuYWJs
ZSBRVUVVRV9GTEFHX1BPTEwgaWYgYWxsIHVuZGVybHlpbmcgcXVldWVzIGVuYWJsZSBRVUVVRV9G
TEFHX1BPTEwsCj4gd2hpY2ggaXMgYmFzZWQgb24gSmVmZmxlJ3MgcHJldmlvdXMgcGF0Y2guCj4g
Cj4gU2lnbmVkLW9mZi1ieTogTWluZyBMZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+Cj4gLS0tCj4g
VjM6Cj4gCS0gY292ZXJzIGFsbCBjb21tZW50cyBmcm9tIEplZmZsZQo+IAktIGZpeCBjb3JuZXIg
Y2FzZXMgd2hlbiBwb2xsaW5nIG9uIGFibm9ybWFsIGlvcwo+IAouLi4KCk9uZSBidWcgYW5kIG9u
ZSBwZXJmb3JtYW5jZSBpc3N1ZSwgdGhvdWdoIEkgaGF2ZW4ndCBpbnZlc3RpZ2F0ZWQgZGVlcApm
b3IgYm90aC4KCgprZXJuZWwgYmFzZTogYmFzZWQgb24gSmVucycgZm9yLW5leHQsIGFwcGx5aW5n
IENocmlzdG9waCBhbmQgTGVpbWluZydzCnBhdGNoc2V0LgoKCjEuIE9uZSBidWcgd2hlbiB0aGVy
ZSdzIERNIGRldmljZSBzdGFjaywgZS5nLiwgZG0tbGluZWFyIHVwb24gYW5vdGhlcgpkbS1saW5l
YXIuIENhbiBiZSByZXByb2R1Y2VkIGJ5IGZvbGxvd2luZyBzdGVwczoKCmBgYAokIHN1ZG8gZG1z
ZXR1cCBjcmVhdGUgdG1wZGV2IC0tdGFibGUgJzAgMjA5NzE1MiBsaW5lYXIgL2Rldi9udm1lMG4x
IDAnCgokIGNhdCB0bXAudGFibGUKMCAyMDk3MTUyIGxpbmVhciAvZGV2L21hcHBlci90bXBkZXYg
MAoyMDk3MTUyIDIwOTcxNTIgbGluZWFyIC9kZXYvbnZtZTBuMSAwCgokIGNhdCB0bXAudGFibGUg
fCBkbXNldHVwIGNyZWF0ZSB0ZXN0ZGV2CgokIGZpbyAtbmFtZT10ZXN0IC1pb2VuZ2luZT1pb191
cmluZyAtaW9kZXB0aD0xMjggLW51bWpvYnM9MSAtdGhyZWFkCi1ydz1yYW5kcmVhZCAtZGlyZWN0
PTEgLWJzPTRrIC10aW1lX2Jhc2VkIC1ydW50aW1lPTEwIC1jcHVzX2FsbG93ZWQ9NgotZmlsZW5h
bWU9L2Rldi9tYXBwZXIvdGVzdGRldiAtaGlwcmk9MQpgYGAKCgpCVUc6IHVuYWJsZSB0byBoYW5k
bGUgcGFnZSBmYXVsdCBmb3IgYWRkcmVzczogZmZmZmZmZmZjMDFhNjIwOAojUEY6IHN1cGVydmlz
b3Igd3JpdGUgYWNjZXNzIGluIGtlcm5lbCBtb2RlCiNQRjogZXJyb3JfY29kZSgweDAwMDMpIC0g
cGVybWlzc2lvbnMgdmlvbGF0aW9uClBHRCAzOTc0MGMwNjcgUDREIDM5NzQwYzA2NyBQVUQgMzk3
NDBlMDY3IFBNRCAxMDM1ZGIwNjcgUFRFIDFkZGY2ZjA2MQpPb3BzOiAwMDAzIFsjMV0gU01QIFBU
SQpDUFU6IDYgUElEOiA1ODk5IENvbW06IGZpbyBUYWludGVkOiBHIFMKNS4xMy4wLTAuMS5naXQu
ODFiY2RjMy5hbDcueDg2XzY0ICMxCkhhcmR3YXJlIG5hbWU6IEludmVudGVjICAgICBLOTAwRzMt
MTBHL0I5MDBHMywgQklPUyBBMi4yMCAwNi8yMy8yMDE3ClJJUDogMDAxMDpkbV9zdWJtaXRfYmlv
KzB4MTcxLzB4M2UwIFtkbV9tb2RdCkNvZGU6IDA4IDg1IGMwIDBmIDg0IDc4IDAxIDAwIDAwIDgw
IDdjIDI0IDJjIDAwIDBmIDg0IGI4IDAwIDAwIDAwIDQ4IDhiCjUzIDM4IDQ4IDhiIDQ0IDI0IDE4
IDQ4IDg1IGQyIDQ4IDhkIDQ4IDI4IDQ4IDg5IDUwIDI4IDc0IDA0IDw0OD4gODkgNGEKMDggNDgg
ODkgNGIgMzggNDggODMgYzMgMzggNDggODkgNTggMzAgNDEgZjcgYzUgZmUgZmYgZmYKUlNQOiAw
MDE4OmZmZmY5ZTVjNDVlMWI5YTAgRUZMQUdTOiAwMDAxMDI4NgpSQVg6IGZmZmY4YWI1OWZkNTAx
NDAgUkJYOiBmZmZmOGFiNTlmZDUwMDg4IFJDWDogZmZmZjhhYjU5ZmQ1MDE2OApSRFg6IGZmZmZm
ZmZmYzAxYTYyMDAgUlNJOiAwMDAwMDAwMDAwMDUyZjA4IFJESTogMDAwMDAwMDAwMDAwMDAwMApS
QlA6IGZmZmY4YWI1OWZkNTAxYzggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAwMDAw
MDAwMDAwMApSMTA6IGZmZmY5ZTVjNDVlMWI5NTAgUjExOiAwMDAwMDAwMDAwMDAwMDA3IFIxMjog
ZmZmZjhhYjRjMmJjMjAwMApSMTM6IDAwMDAwMDAwMDAwMDAwMDAgUjE0OiBmZmZmOGFiNGMyYmMy
NTQ4IFIxNTogZmZmZjhhYjU5ZmQ1MDE0MApGUzogIDAwMDA3ZjU1NWRlNDI3MDAoMDAwMCkgR1M6
ZmZmZjhhZjMzZjE4MDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwCkNTOiAgMDAxMCBE
UzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKQ1IyOiBmZmZmZmZmZmMwMWE2
MjA4IENSMzogMDAwMDAwMDEyNDk5MDAwNSBDUjQ6IDAwMDAwMDAwMDAzNzA2ZTAKRFIwOiAwMDAw
MDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDAK
RFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjogMDAwMDAwMDBmZmZlMGZmMCBEUjc6IDAwMDAwMDAw
MDAwMDA0MDAKQ2FsbCBUcmFjZToKIHN1Ym1pdF9iaW9fbm9hY2N0KzB4MTQ0LzB4M2YwCiA/IHN1
Ym1pdF9iaW8rMHg0Mi8weDEyMAogc3VibWl0X2JpbysweDQyLzB4MTIwCiBibGtkZXZfZGlyZWN0
X0lPKzB4NDU0LzB4NGIwCiA/IGlvX3Jlc3VibWl0X3ByZXArMHg0MC8weDQwCiA/IF9fZnNub3Rp
ZnlfcGFyZW50KzB4ZmYvMHgzNTAKID8gX19mc25vdGlmeV9wYXJlbnQrMHgxMGYvMHgzNTAKID8g
Z2VuZXJpY19maWxlX3JlYWRfaXRlcisweDgzLzB4MTUwCiBnZW5lcmljX2ZpbGVfcmVhZF9pdGVy
KzB4ODMvMHgxNTAKIGJsa2Rldl9yZWFkX2l0ZXIrMHg0MS8weDUwCiBpb19yZWFkKzB4ZTkvMHg0
MjAKID8gX19jb25kX3Jlc2NoZWQrMHgxNi8weDQwCiA/IF9fa21hbGxvY19ub2RlKzB4MTZlLzB4
NGUwCiA/IG1lbWNnX2FsbG9jX3BhZ2Vfb2JqX2Nncm91cHMrMHgzMi8weDkwCiA/IGlvX2lzc3Vl
X3NxZSsweDdlOC8weDEyNjAKIGlvX2lzc3VlX3NxZSsweDdlOC8weDEyNjAKID8gaW9fc3VibWl0
X3NxZXMrMHg0N2IvMHgxNDIwCiBfX2lvX3F1ZXVlX3NxZSsweDU2LzB4MzgwCiA/IGlvX3N1Ym1p
dF9zcWVzKzB4MTIwYS8weDE0MjAKIGlvX3N1Ym1pdF9zcWVzKzB4MTIwYS8weDE0MjAKID8gX194
NjRfc3lzX2lvX3VyaW5nX2VudGVyKzB4MWQyLzB4M2UwCiBfX3g2NF9zeXNfaW9fdXJpbmdfZW50
ZXIrMHgxZDIvMHgzZTAKID8gZXhpdF90b191c2VyX21vZGVfcHJlcGFyZSsweDRjLzB4MjEwCiBk
b19zeXNjYWxsXzY0KzB4MzYvMHg3MAogZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4
NDQvMHhhZQpSSVA6IDAwMzM6MHg3ZjU1ZDNjYjFiNTkKQ29kZTogMDAgZjMgYzMgNjYgMmUgMGYg
MWYgODQgMDAgMDAgMDAgMDAgMDAgMGYgMWYgNDAgMDAgNDggODkgZjggNDggODkKZjcgNDggODkg
ZDYgNDggODkgY2EgNGQgODkgYzIgNGQgODkgYzggNGMgOGIgNGMgMjQgMDggMGYgMDUgPDQ4PiAz
ZCAwMQpmMCBmZiBmZiA3MyAwMSBjMyA0OCA4YiAwZCBmZiBlMiAyYiAwMCBmNyBkOCA2NCA4OSAw
MSA0OApSU1A6IDAwMmI6MDAwMDdmNTU1ZGU0MWIxOCBFRkxBR1M6IDAwMDAwMjQ2IE9SSUdfUkFY
OiAwMDAwMDAwMDAwMDAwMWFhClJBWDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDAwMDAwMDAw
MDAwMDEgUkNYOiAwMDAwN2Y1NWQzY2IxYjU5ClJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAw
MDAwMDAwMDAwMDAwMDEgUkRJOiAwMDAwMDAwMDAwMDAwMDA1ClJCUDogMDAwMDdmNTU3Y2U4MTAw
MCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClIxMDogMDAwMDAw
MDAwMDAwMDAwMSBSMTE6IDAwMDAwMDAwMDAwMDAyNDYgUjEyOiAwMDAwMDAwMDAxMjc2MDAwClIx
MzogMDAwMDAwMDAwMDAwMDAwMSBSMTQ6IDAwMDAwMDAwMDAwMDAwMDAgUjE1OiAwMDAwMDAwMDAx
MmM4MzI4CgoKCgoyLiBQZXJmb3JtYW5jZSBJc3N1ZQoKSSB0ZXN0IGJvdGggb24geDg2ICh3aXRo
IG9ubHkgb25lIE5WTWUpIGFuZCBhYXJjaDY0ICh3aXRoIG11bHRpcGxlIE5WTWVzKS4KClRoZSBy
ZXN1bHQgKElPUFMpIG9uIHg4NiBpcyBhcyBleHBlY3RlZDoKClR5cGUgCSAgfElSUSAgIHwgUG9s
bGluZwotLS0tLS0tLS0gfCAtLS0tIHwgLS0tLQpkbS1saW5lYXIgfCAyMzlrIHwgMzU3awoKLSBk
bS1saW5lYXIgYnVpbHQgdXBvbiBvbmUgTlZNZe+8jGJzPTRrLCBpb3BvbGw9MSwgaW9kZXB0aD0x
MjgsCm51bWpvYnM9MSwgZGlyZWN0LCByYW5kcmVhZCwgaW9lbmdpbmU9aW9fdXJpbmcKCgoKV2hp
bGUgdGhlIHJlc3VsdCBvbiBhYXJjaDY0IGlzIGEgbGl0dGxlIGNvbmZ1c2luZy4KClR5cGUgCSAg
ICAgIHxJUlEgICB8IFBvbGxpbmcKLS0tLS0tLS0tLS0tLSB8IC0tLS0gfCAtLS0tCmRtLWxpbmVh
ciBbMV0gfCAyMDhrIHwgMjMwawpkbS1saW5lYXIgWzJdIHwgNjM3ayB8IDY5MWsKZG0tc3RyaXBl
ICAgICB8IDMxMGsgfCAzNTRrCgotIGRtLWxpbmVhciBbMV0gYnVpbHQgdXBvbiAqb25lKiBOVk1l
77yMYnM9NGssIGlvcG9sbD0xLCBpb2RlcHRoPTEyOCwKKm51bWpvYnM9MSosIGRpcmVjdCwgcmFu
ZHJlYWQsIGlvZW5naW5lPWlvX3VyaW5nCi0gZG0tbGluZWFyIFsyXSBidWlsdCB1cG9uICp0aHJl
ZSogTlZNZXPvvIxicz00aywgaW9wb2xsPTEsIGlvZGVwdGg9MTI4LAoqbnVtam9icz0zKiwgZGly
ZWN0LCByYW5kcmVhZCwgaW9lbmdpbmU9aW9fdXJpbmcKLSBkbS1zdHJpcGUgYnVpbHQgdXBvbiAq
dGhyZWUqIE5WTWVz77yMY2h1bmtfc2l6ZT00aywgYnM9MTJrLCBpb3BvbGw9MSwKaW9kZXB0aD0x
MjgsIG51bWpvYnM9MywgZGlyZWN0LCByYW5kcmVhZCwgaW9lbmdpbmU9aW9fdXJpbmcKCgpGb2xs
b3dpbmcgaXMgdGhlIGNvcnJlc3BvbmRpbmcgdGVzdCByZXN1bHQgb2YgTGVpbWluZydzIGxhc3QK
aW1wbGVtZW50YXRpb24gZm9yIGJpby1iYXNlZCBwb2xsaW5nIG9uIGFhcmNoNjQuCklSUQlJT1BP
TEwJcmF0aW8KZG0tbGluZWFyIFsyXQk2MzlLCTgzNUsJfjMwJQpkbS1zdHJpcGUgCTMxNEsJNDA4
Swl+MzAlCgoKLS0gClRoYW5rcywKSmVmZmxlCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs


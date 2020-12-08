Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB6DC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 16:48:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8E89A23A79
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 16:48:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E89A23A79
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-BgC7hsVkOP6aOxve4VVR3w-1; Tue, 08 Dec 2020 11:48:03 -0500
X-MC-Unique: BgC7hsVkOP6aOxve4VVR3w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 267A38B88A8;
	Tue,  8 Dec 2020 16:47:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 01DBC36FA;
	Tue,  8 Dec 2020 16:47:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B9685180954D;
	Tue,  8 Dec 2020 16:47:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8GljoA011549 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 11:47:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9FDD5112D40C; Tue,  8 Dec 2020 16:47:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B84D112D40B
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 16:47:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32AB4858287
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 16:47:43 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-478-irrw9_rCOCeoP4qroL2s0g-1;
	Tue, 08 Dec 2020 11:47:38 -0500
X-MC-Unique: irrw9_rCOCeoP4qroL2s0g-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 2C329AD21;
	Tue,  8 Dec 2020 16:47:37 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201208162829.2424563-1-hch@lst.de>
	<20201208162829.2424563-5-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <8df170f5-3000-7eba-0482-0066cc24ae71@suse.de>
Date: Tue, 8 Dec 2020 17:47:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208162829.2424563-5-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B8GljoA011549
X-loop: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/6] block: propagate BLKROSET on the whole
 device to all partitions
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

T24gMTIvOC8yMCA1OjI4IFBNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBDaGFuZ2UgdGhl
IHBvbGljeSBzbyB0aGF0IGEgQkxLUk9TRVQgb24gdGhlIHdob2xlIGRldmljZSBhbHNvIGFmZmVj
dHMKPiBwYXJ0aXRpb25zLiAgVG8gcXVvdGUgTWFydGluIEsuIFBldGVyc2VuOgo+IAo+IEl0J3Mg
dmVyeSBjb21tb24gZm9yIGRhdGFiYXNlIGZvbGtzIHRvIHR3aWRkbGUgdGhlIHJlYWQtb25seSBz
dGF0ZSBvZgo+IGJsb2NrIGRldmljZXMgYW5kIHBhcnRpdGlvbnMuIEkga25vdyB0aGF0IG91ciB1
c2VycyB3aWxsIGZpbmQgaXQgdmVyeQo+IGNvdW50ZXItaW50dWl0aXZlIHRoYXQgc2V0dGluZyAv
ZGV2L3NkYSByZWFkLW9ubHkgd29uJ3QgcHJldmVudCB3cml0ZXMKPiB0byAvZGV2L3NkYTEuCj4g
Cj4gVGhlIGV4aXN0aW5nIGJlaGF2aW9yIGlzIGluY29uc2lzdGVudCBpbiB0aGUgc2Vuc2UgdGhh
dCBkb2luZzoKPiAKPiAgICAjIGJsb2NrZGV2IC0tc2V0cm8gL2Rldi9zZGEKPiAgICAjIGVjaG8g
Zm9vID4gL2Rldi9zZGExCj4gCj4gcGVybWl0cyB3cml0ZXMuIEJ1dDoKPiAKPiAgICAjIGJsb2Nr
ZGV2IC0tc2V0cm8gL2Rldi9zZGEKPiAgICA8c29tZXRoaW5nIHRyaWdnZXJzIHJldmFsaWRhdGU+
Cj4gICAgIyBlY2hvIGZvbyA+IC9kZXYvc2RhMQo+IAo+IGRvZXNuJ3QuCj4gCj4gQW5kIGEgc3Vi
c2VxdWVudDoKPiAKPiAgICAjIGJsb2NrZGV2IC0tc2V0cncgL2Rldi9zZGEKPiAgICAjIGVjaG8g
Zm9vID4gL2Rldi9zZGExCj4gCj4gZG9lc24ndCB3b3JrIGVpdGhlciBzaW5jZSBzZGExJ3MgcmVh
ZC1vbmx5IHBvbGljeSBoYXMgYmVlbiBpbmhlcml0ZWQKPiBmcm9tIHRoZSB3aG9sZS1kaXNrIGRl
dmljZS4KPiAKPiBZb3UgbmVlZCB0byBkbzoKPiAKPiAgICAjIGJsb2NrZGV2IC0tcmVyZWFkcHQK
PiAKPiBhZnRlciBzZXR0aW5nIHRoZSB3aG9sZS1kaXNrIGRldmljZSBydyB0byBlZmZlY3R1YXRl
IHRoZSBzYW1lIGNoYW5nZSBvbgo+IHRoZSBwYXJ0aXRpb25zLCBvdGhlcndpc2UgdGhleSBhcmUg
c3R1Y2sgYmVpbmcgcmVhZC1vbmx5IGluZGVmaW5pdGVseS4KPiAKPiBIb3dldmVyLCBzZXR0aW5n
IHRoZSByZWFkLW9ubHkgcG9saWN5IG9uIGEgcGFydGl0aW9uIGRvZXMgKm5vdCogcmVxdWlyZQo+
IHRoZSByZXZhbGlkYXRlIHN0ZXAuIEFzIGEgbWF0dGVyIG9mIGZhY3QsIGRvaW5nIHRoZSByZXZh
bGlkYXRlIHdpbGwgYmxvdwo+IGF3YXkgdGhlIHBvbGljeSBzZXR0aW5nIHlvdSBqdXN0IG1hZGUu
Cj4gCj4gU28gdGhlIHVzZXIgbmVlZHMgdG8gdGFrZSBkaWZmZXJlbnQgYWN0aW9ucyBkZXBlbmRp
bmcgb24gd2hldGhlciB0aGV5Cj4gYXJlIHRyeWluZyB0byByZWFkLXByb3RlY3QgYSB3aG9sZS1k
aXNrIGRldmljZSBvciBhIHBhcnRpdGlvbi4gRGVzcGl0ZQo+IHVzaW5nIHRoZSBzYW1lIGlvY3Rs
LiBUaGF0IGlzIHJlYWxseSBjb25mdXNpbmcuCj4gCj4gSSBoYXZlIGxvc3QgY291bnQgaG93IG1h
bnkgdGltZXMgb3VyIGN1c3RvbWVycyBoYXZlIGhhZCBkYXRhIGNsb2JiZXJlZAo+IGJlY2F1c2Ug
b2YgYW1iaWd1aXR5IG9mIHRoZSBleGlzdGluZyB3aG9sZS1kaXNrIGRldmljZSBwb2xpY3kuIFRo
ZQo+IGN1cnJlbnQgYmVoYXZpb3IgdmlvbGF0ZXMgdGhlIHByaW5jaXBsZSBvZiBsZWFzdCBzdXJw
cmlzZSBieSBsZXR0aW5nIHRoZQo+IHVzZXIgdGhpbmsgdGhleSB3cml0ZSBwcm90ZWN0ZWQgdGhl
IHdob2xlIGRpc2sgd2hlbiB0aGV5IGFjdHVhbGx5Cj4gZGlkbid0Lgo+IAo+IFN1Z2dlc3RlZC1i
eTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTog
TWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4KPiAtLS0KPiAg
IGJsb2NrL2dlbmhkLmMgfCAzICstLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9ibG9jay9nZW5oZC5jIGIvYmxvY2sv
Z2VuaGQuYwo+IGluZGV4IGQ5Zjk4OWMxNTE0MTIzLi42ZTUxZWNiOTI4MGFjYSAxMDA2NDQKPiAt
LS0gYS9ibG9jay9nZW5oZC5jCj4gKysrIGIvYmxvY2svZ2VuaGQuYwo+IEBAIC0xNjU2LDggKzE2
NTYsNyBAQCBFWFBPUlRfU1lNQk9MKHNldF9kaXNrX3JvKTsKPiAgIAo+ICAgaW50IGJkZXZfcmVh
ZF9vbmx5KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYpCj4gICB7Cj4gLQlyZXR1cm4gYmRldi0+
YmRfcmVhZF9vbmx5IHx8Cj4gLQkJdGVzdF9iaXQoR0RfUkVBRF9PTkxZLCAmYmRldi0+YmRfZGlz
ay0+c3RhdGUpOwo+ICsJcmV0dXJuIGJkZXYtPmJkX3JlYWRfb25seSB8fCBnZXRfZGlza19ybyhi
ZGV2LT5iZF9kaXNrKTsKPiAgIH0KPiAgIEVYUE9SVF9TWU1CT0woYmRldl9yZWFkX29ubHkpOwo+
ICAgCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVy
cywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwg
U3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVs
ZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jD
pGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbA==


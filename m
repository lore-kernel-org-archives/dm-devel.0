Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2483DC5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:21:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 913882158C
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:21:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 913882158C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-43DD9WiqPsWqBq3cYm2-lg-1; Fri, 20 Nov 2020 02:21:04 -0500
X-MC-Unique: 43DD9WiqPsWqBq3cYm2-lg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33E8518C43C2;
	Fri, 20 Nov 2020 07:21:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15BAF60BE2;
	Fri, 20 Nov 2020 07:21:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DF8994A7C6;
	Fri, 20 Nov 2020 07:20:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK7KvOP003300 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 02:20:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 78ECDE778C; Fri, 20 Nov 2020 07:20:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72768E778A
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:20:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39A7D103B800
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:20:54 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-233-x0Hy57_DNXWjwANa9ARXPw-1;
	Fri, 20 Nov 2020 02:20:49 -0500
X-MC-Unique: x0Hy57_DNXWjwANa9ARXPw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 95218AC0C;
	Fri, 20 Nov 2020 07:20:47 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-33-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <d1beca65-cd8e-57ff-e7d7-6347cb6344b4@suse.de>
Date: Fri, 20 Nov 2020 08:20:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-33-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AK7KvOP003300
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 32/78] block: remove set_device_ro
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMTYvMjAgMzo1NyBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gRm9sZCBzZXRf
ZGV2aWNlX3JvIGludG8gaXRzIG9ubHkgcmVtYWluaW5nIGNhbGxlci4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiAtLS0KPiAgIGJsb2NrL2dlbmhk
LmMgICAgICAgICB8IDcgLS0tLS0tLQo+ICAgYmxvY2svaW9jdGwuYyAgICAgICAgIHwgMiArLQo+
ICAgaW5jbHVkZS9saW51eC9nZW5oZC5oIHwgMSAtCj4gICAzIGZpbGVzIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCA5IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9ibG9jay9nZW5oZC5j
IGIvYmxvY2svZ2VuaGQuYwo+IGluZGV4IDhjMzUwZmVjZmU4YmZlLi5iMGYwYjBjYWM5YWE3ZiAx
MDA2NDQKPiAtLS0gYS9ibG9jay9nZW5oZC5jCj4gKysrIGIvYmxvY2svZ2VuaGQuYwo+IEBAIC0x
ODQzLDEzICsxODQzLDYgQEAgc3RhdGljIHZvaWQgc2V0X2Rpc2tfcm9fdWV2ZW50KHN0cnVjdCBn
ZW5kaXNrICpnZCwgaW50IHJvKQo+ICAgCWtvYmplY3RfdWV2ZW50X2VudigmZGlza190b19kZXYo
Z2QpLT5rb2JqLCBLT0JKX0NIQU5HRSwgZW52cCk7Cj4gICB9Cj4gICAKPiAtdm9pZCBzZXRfZGV2
aWNlX3JvKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGludCBmbGFnKQo+IC17Cj4gLQliZGV2
LT5iZF9wYXJ0LT5wb2xpY3kgPSBmbGFnOwo+IC19Cj4gLQo+IC1FWFBPUlRfU1lNQk9MKHNldF9k
ZXZpY2Vfcm8pOwo+IC0KPiAgIHZvaWQgc2V0X2Rpc2tfcm8oc3RydWN0IGdlbmRpc2sgKmRpc2ss
IGludCBmbGFnKQo+ICAgewo+ICAgCXN0cnVjdCBkaXNrX3BhcnRfaXRlciBwaXRlcjsKPiBkaWZm
IC0tZ2l0IGEvYmxvY2svaW9jdGwuYyBiL2Jsb2NrL2lvY3RsLmMKPiBpbmRleCA5NmNiNDU0NDcz
NjQ2OC4uMDQyNTVkYzVmM2JmZjMgMTAwNjQ0Cj4gLS0tIGEvYmxvY2svaW9jdGwuYwo+ICsrKyBi
L2Jsb2NrL2lvY3RsLmMKPiBAQCAtMzcxLDcgKzM3MSw3IEBAIHN0YXRpYyBpbnQgYmxrZGV2X3Jv
c2V0KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGZtb2RlX3QgbW9kZSwKPiAgIAkJaWYgKHJl
dCkKPiAgIAkJCXJldHVybiByZXQ7Cj4gICAJfQo+IC0Jc2V0X2RldmljZV9ybyhiZGV2LCBuKTsK
PiArCWJkZXYtPmJkX3BhcnQtPnBvbGljeSA9IG47Cj4gICAJcmV0dXJuIDA7Cj4gICB9Cj4gICAK
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9nZW5oZC5oIGIvaW5jbHVkZS9saW51eC9nZW5o
ZC5oCj4gaW5kZXggNGIyMmJmZDkzMzZlMWEuLjg0MjdhZDhiZWY1MjBkIDEwMDY0NAo+IC0tLSBh
L2luY2x1ZGUvbGludXgvZ2VuaGQuaAo+ICsrKyBiL2luY2x1ZGUvbGludXgvZ2VuaGQuaAo+IEBA
IC0zMDQsNyArMzA0LDYgQEAgZXh0ZXJuIHZvaWQgZGVsX2dlbmRpc2soc3RydWN0IGdlbmRpc2sg
KmdwKTsKPiAgIGV4dGVybiBzdHJ1Y3QgZ2VuZGlzayAqZ2V0X2dlbmRpc2soZGV2X3QgZGV2LCBp
bnQgKnBhcnRubyk7Cj4gICBleHRlcm4gc3RydWN0IGJsb2NrX2RldmljZSAqYmRnZXRfZGlzayhz
dHJ1Y3QgZ2VuZGlzayAqZGlzaywgaW50IHBhcnRubyk7Cj4gICAKPiAtZXh0ZXJuIHZvaWQgc2V0
X2RldmljZV9ybyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBpbnQgZmxhZyk7Cj4gICBleHRl
cm4gdm9pZCBzZXRfZGlza19ybyhzdHJ1Y3QgZ2VuZGlzayAqZGlzaywgaW50IGZsYWcpOwo+ICAg
Cj4gICBzdGF0aWMgaW5saW5lIGludCBnZXRfZGlza19ybyhzdHJ1Y3QgZ2VuZGlzayAqZGlzaykK
PiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoK
SGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9y
YWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAr
NDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3Ry
LiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRz
ZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZv
L2RtLWRldmVs


Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C990C5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:26:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD3CE2158C
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD3CE2158C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-4t83Z208O8OdlUdidUYhAQ-1; Fri, 20 Nov 2020 02:26:41 -0500
X-MC-Unique: 4t83Z208O8OdlUdidUYhAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9323B107AD26;
	Fri, 20 Nov 2020 07:26:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 731855C1D5;
	Fri, 20 Nov 2020 07:26:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45899180954D;
	Fri, 20 Nov 2020 07:26:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK7QYsf004148 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 02:26:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 351A02166B28; Fri, 20 Nov 2020 07:26:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FB8D2166B2C
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:26:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A881858EEC
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:26:31 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-324-tJSo42FYOqWl1MHSVLeFww-1;
	Fri, 20 Nov 2020 02:26:25 -0500
X-MC-Unique: tJSo42FYOqWl1MHSVLeFww-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 2A51FAB3D;
	Fri, 20 Nov 2020 07:26:23 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-56-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <75f4c397-ac03-2c5f-d620-0e619ad78fe8@suse.de>
Date: Fri, 20 Nov 2020 08:26:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-56-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AK7QYsf004148
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
Subject: Re: [dm-devel] [PATCH 55/78] block: change the hash used for
 looking up block devices
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMTYvMjAgMzo1NyBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gQWRkaW5nIHRo
ZSBtaW5vciB0byB0aGUgbWFqb3IgY3JlYXRlcyB0b25zIG9mIHBvaW50bGVzcyBjb25mbGljdHMu
IEp1c3QKPiB1c2UgdGhlIGRldl90IGl0c2VsZiwgd2hpY2ggaXMgMzItYml0cyBhbmQgdGh1cyBp
cyBndWFyYW50ZWVkIHRvIGZpdAo+IGludG8gaW5vX3QuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hy
aXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBmcy9ibG9ja19kZXYuYyB8IDI2
ICsrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAyNCBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZnMvYmxvY2tfZGV2LmMg
Yi9mcy9ibG9ja19kZXYuYwo+IGluZGV4IGQ4NjY0ZjVjMWZmNjY5Li4yOWRiMTJjM2JiNTAxYyAx
MDA2NDQKPiAtLS0gYS9mcy9ibG9ja19kZXYuYwo+ICsrKyBiL2ZzL2Jsb2NrX2Rldi5jCj4gQEAg
LTg3MCwzNSArODcwLDEyIEBAIHZvaWQgX19pbml0IGJkZXZfY2FjaGVfaW5pdCh2b2lkKQo+ICAg
CWJsb2NrZGV2X3N1cGVyYmxvY2sgPSBiZF9tbnQtPm1udF9zYjsgICAvKiBGb3Igd3JpdGViYWNr
ICovCj4gICB9Cj4gICAKPiAtLyoKPiAtICogTW9zdCBsaWtlbHkgX3ZlcnlfIGJhZCBvbmUgLSBi
dXQgdGhlbiBpdCdzIGhhcmRseSBjcml0aWNhbCBmb3Igc21hbGwKPiAtICogL2RldiBhbmQgY2Fu
IGJlIGZpeGVkIHdoZW4gc29tZWJvZHkgd2lsbCBuZWVkIHJlYWxseSBsYXJnZSBvbmUuCj4gLSAq
IEtlZXAgaW4gbWluZCB0aGF0IGl0IHdpbGwgYmUgZmVkIHRocm91Z2ggaWNhY2hlIGhhc2ggZnVu
Y3Rpb24gdG9vLgo+IC0gKi8KPiAtc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGhhc2goZGV2
X3QgZGV2KQo+IC17Cj4gLQlyZXR1cm4gTUFKT1IoZGV2KStNSU5PUihkZXYpOwo+IC19Cj4gLQo+
IC1zdGF0aWMgaW50IGJkZXZfdGVzdChzdHJ1Y3QgaW5vZGUgKmlub2RlLCB2b2lkICpkYXRhKQo+
IC17Cj4gLQlyZXR1cm4gQkRFVl9JKGlub2RlKS0+YmRldi5iZF9kZXYgPT0gKihkZXZfdCAqKWRh
dGE7Cj4gLX0KPiAtCj4gLXN0YXRpYyBpbnQgYmRldl9zZXQoc3RydWN0IGlub2RlICppbm9kZSwg
dm9pZCAqZGF0YSkKPiAtewo+IC0JQkRFVl9JKGlub2RlKS0+YmRldi5iZF9kZXYgPSAqKGRldl90
ICopZGF0YTsKPiAtCXJldHVybiAwOwo+IC19Cj4gLQo+ICAgc3RhdGljIHN0cnVjdCBibG9ja19k
ZXZpY2UgKmJkZ2V0KGRldl90IGRldikKPiAgIHsKPiAgIAlzdHJ1Y3QgYmxvY2tfZGV2aWNlICpi
ZGV2Owo+ICAgCXN0cnVjdCBpbm9kZSAqaW5vZGU7Cj4gICAKPiAtCWlub2RlID0gaWdldDVfbG9j
a2VkKGJsb2NrZGV2X3N1cGVyYmxvY2ssIGhhc2goZGV2KSwKPiAtCQkJYmRldl90ZXN0LCBiZGV2
X3NldCwgJmRldik7Cj4gLQo+ICsJaW5vZGUgPSBpZ2V0X2xvY2tlZChibG9ja2Rldl9zdXBlcmJs
b2NrLCBkZXYpOwo+ICAgCWlmICghaW5vZGUpCj4gICAJCXJldHVybiBOVUxMOwo+ICAgCj4gQEAg
LTkxMCw2ICs4ODcsNyBAQCBzdGF0aWMgc3RydWN0IGJsb2NrX2RldmljZSAqYmRnZXQoZGV2X3Qg
ZGV2KQo+ICAgCQliZGV2LT5iZF9zdXBlciA9IE5VTEw7Cj4gICAJCWJkZXYtPmJkX2lub2RlID0g
aW5vZGU7Cj4gICAJCWJkZXYtPmJkX3BhcnRfY291bnQgPSAwOwo+ICsJCWJkZXYtPmJkX2RldiA9
IGRldjsKPiAgIAkJaW5vZGUtPmlfbW9kZSA9IFNfSUZCTEs7Cj4gICAJCWlub2RlLT5pX3JkZXYg
PSBkZXY7Cj4gICAJCWlub2RlLT5pX2JkZXYgPSBiZGV2Owo+IApSZXZpZXdlZC1ieTogSGFubmVz
IFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMg
UmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3Vz
ZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0Ug
U29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpI
UkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2
cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


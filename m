Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D7BC63777
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:43:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AD11D22256
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD11D22256
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-hLwWFTYVOkCIE2yM-AKTaw-1; Fri, 20 Nov 2020 02:43:19 -0500
X-MC-Unique: hLwWFTYVOkCIE2yM-AKTaw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DA3151A6;
	Fri, 20 Nov 2020 07:43:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0890310016F5;
	Fri, 20 Nov 2020 07:43:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 941EC180954D;
	Fri, 20 Nov 2020 07:43:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK7hCGC005977 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 02:43:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A69402166B2B; Fri, 20 Nov 2020 07:43:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E4F12166B2F
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:43:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ECD9803DCE
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:43:09 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-582-kUsP95GfMtys3J5bki71wg-1;
	Fri, 20 Nov 2020 02:43:04 -0500
X-MC-Unique: kUsP95GfMtys3J5bki71wg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E6A77AB3D;
	Fri, 20 Nov 2020 07:43:02 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-66-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <310bff8b-dbda-609a-a392-619733b86bd1@suse.de>
Date: Fri, 20 Nov 2020 08:43:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-66-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AK7hCGC005977
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
Subject: Re: [dm-devel] [PATCH 65/78] dm: remove the block_device reference
 in struct mapped_device
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

T24gMTEvMTYvMjAgMzo1NyBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gR2V0IHJpZCBv
ZiB0aGUgbG9uZy1sYXN0aW5nIHN0cnVjdCBibG9ja19kZXZpY2UgcmVmZXJlbmNlIGluCj4gc3Ry
dWN0IG1hcHBlZF9kZXZpY2UuICBUaGUgb25seSByZW1haW5pbmcgdXNlciBpcyB0aGUgZnJlZXpl
IGNvZGUsCj4gd2hlcmUgd2UgY2FuIHRyaXZpYWxseSBsb29rIHVwIHRoZSBibG9jayBkZXZpY2Ug
YXQgZnJlZXplIHRpbWUKPiBhbmQgcmVsZWFzZSB0aGUgcmVmZXJlbmNlIGF0IHRoYXcgdGltZS4K
PiAKPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiAtLS0K
PiAgIGRyaXZlcnMvbWQvZG0tY29yZS5oIHwgIDIgLS0KPiAgIGRyaXZlcnMvbWQvZG0uYyAgICAg
IHwgMjIgKysrKysrKysrKystLS0tLS0tLS0tLQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNl
cnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9k
bS1jb3JlLmggYi9kcml2ZXJzL21kL2RtLWNvcmUuaAo+IGluZGV4IGQ1MjIwOTNjYjM5ZGRhLi5i
MWI0MDBlZDc2ZmU5MCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL2RtLWNvcmUuaAo+ICsrKyBi
L2RyaXZlcnMvbWQvZG0tY29yZS5oCj4gQEAgLTEwNyw4ICsxMDcsNiBAQCBzdHJ1Y3QgbWFwcGVk
X2RldmljZSB7Cj4gICAJLyoga29iamVjdCBhbmQgY29tcGxldGlvbiAqLwo+ICAgCXN0cnVjdCBk
bV9rb2JqZWN0X2hvbGRlciBrb2JqX2hvbGRlcjsKPiAgIAo+IC0Jc3RydWN0IGJsb2NrX2Rldmlj
ZSAqYmRldjsKPiAtCj4gICAJc3RydWN0IGRtX3N0YXRzIHN0YXRzOwo+ICAgCj4gICAJLyogZm9y
IGJsay1tcSByZXF1ZXN0LWJhc2VkIERNIHN1cHBvcnQgKi8KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZC9kbS5jIGIvZHJpdmVycy9tZC9kbS5jCj4gaW5kZXggNmQ3ZWI3MmQ0MWY5ZWEuLmM3ODlm
ZmVhMmJhZGRlIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvZG0uYwo+ICsrKyBiL2RyaXZlcnMv
bWQvZG0uYwo+IEBAIC0xNzQ0LDExICsxNzQ0LDYgQEAgc3RhdGljIHZvaWQgY2xlYW51cF9tYXBw
ZWRfZGV2aWNlKHN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCkKPiAgIAo+ICAgCWNsZWFudXBfc3Jj
dV9zdHJ1Y3QoJm1kLT5pb19iYXJyaWVyKTsKPiAgIAo+IC0JaWYgKG1kLT5iZGV2KSB7Cj4gLQkJ
YmRwdXQobWQtPmJkZXYpOwo+IC0JCW1kLT5iZGV2ID0gTlVMTDsKPiAtCX0KPiAtCj4gICAJbXV0
ZXhfZGVzdHJveSgmbWQtPnN1c3BlbmRfbG9jayk7Cj4gICAJbXV0ZXhfZGVzdHJveSgmbWQtPnR5
cGVfbG9jayk7Cj4gICAJbXV0ZXhfZGVzdHJveSgmbWQtPnRhYmxlX2RldmljZXNfbG9jayk7Cj4g
QEAgLTE4NDAsMTAgKzE4MzUsNiBAQCBzdGF0aWMgc3RydWN0IG1hcHBlZF9kZXZpY2UgKmFsbG9j
X2RldihpbnQgbWlub3IpCj4gICAJaWYgKCFtZC0+d3EpCj4gICAJCWdvdG8gYmFkOwo+ICAgCj4g
LQltZC0+YmRldiA9IGJkZ2V0X2Rpc2sobWQtPmRpc2ssIDApOwo+IC0JaWYgKCFtZC0+YmRldikK
PiAtCQlnb3RvIGJhZDsKPiAtCj4gICAJZG1fc3RhdHNfaW5pdCgmbWQtPnN0YXRzKTsKPiAgIAo+
ICAgCS8qIFBvcHVsYXRlIHRoZSBtYXBwaW5nLCBub2JvZHkga25vd3Mgd2UgZXhpc3QgeWV0ICov
Cj4gQEAgLTIzODQsMTIgKzIzNzUsMTcgQEAgc3RydWN0IGRtX3RhYmxlICpkbV9zd2FwX3RhYmxl
KHN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCwgc3RydWN0IGRtX3RhYmxlICp0YWJsZSkKPiAgICAq
Lwo+ICAgc3RhdGljIGludCBsb2NrX2ZzKHN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCkKPiAgIHsK
PiArCXN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXY7Cj4gICAJaW50IHI7Cj4gICAKPiAgIAlXQVJO
X09OKG1kLT5mcm96ZW5fc2IpOwo+ICAgCj4gLQltZC0+ZnJvemVuX3NiID0gZnJlZXplX2JkZXYo
bWQtPmJkZXYpOwo+ICsJYmRldiA9IGJkZ2V0X2Rpc2sobWQtPmRpc2ssIDApOwo+ICsJaWYgKCFi
ZGV2KQo+ICsJCXJldHVybiAtRU5PTUVNOwo+ICsJbWQtPmZyb3plbl9zYiA9IGZyZWV6ZV9iZGV2
KGJkZXYpOwo+ICAgCWlmIChJU19FUlIobWQtPmZyb3plbl9zYikpIHsKPiArCQliZHB1dChiZGV2
KTsKPiAgIAkJciA9IFBUUl9FUlIobWQtPmZyb3plbl9zYik7Cj4gICAJCW1kLT5mcm96ZW5fc2Ig
PSBOVUxMOwo+ICAgCQlyZXR1cm4gcjsKPiBAQCAtMjQwMiwxMCArMjM5OCwxNCBAQCBzdGF0aWMg
aW50IGxvY2tfZnMoc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kKQo+ICAgCj4gICBzdGF0aWMgdm9p
ZCB1bmxvY2tfZnMoc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kKQo+ICAgewo+ICsJc3RydWN0IGJs
b2NrX2RldmljZSAqYmRldjsKPiArCj4gICAJaWYgKCF0ZXN0X2JpdChETUZfRlJPWkVOLCAmbWQt
PmZsYWdzKSkKPiAgIAkJcmV0dXJuOwo+ICAgCj4gLQl0aGF3X2JkZXYobWQtPmJkZXYsIG1kLT5m
cm96ZW5fc2IpOwo+ICsJYmRldiA9IG1kLT5mcm96ZW5fc2ItPnNfYmRldjsKPiArCXRoYXdfYmRl
dihiZGV2LCBtZC0+ZnJvemVuX3NiKTsKPiArCWJkcHV0KGJkZXYpOwo+ICAgCW1kLT5mcm96ZW5f
c2IgPSBOVUxMOwo+ICAgCWNsZWFyX2JpdChETUZfRlJPWkVOLCAmbWQtPmZsYWdzKTsKPiAgIH0K
PiAKWWF5LiBKdXN0IHdoYXQgSSBuZWVkIGZvciB0aGUgYmxrLWludGVycG9zZXIgY29kZSwgd2hl
cmUgdGhlIC0+YmRldgpwb2ludGVyIGlzIHJlYWxseSBnZXR0aW5nIGluIHRoZSB3YXkuCgpSZXZp
ZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMK
LS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJj
aGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEg
NzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkw
NDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVy
OiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw=


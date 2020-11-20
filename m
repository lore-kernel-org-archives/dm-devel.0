Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B59DC63777
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:41:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 786D222256
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:41:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 786D222256
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-HoyWJEPRPg25v2VEYEMW5w-1; Fri, 20 Nov 2020 02:41:34 -0500
X-MC-Unique: HoyWJEPRPg25v2VEYEMW5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83592814413;
	Fri, 20 Nov 2020 07:41:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FC995D6AD;
	Fri, 20 Nov 2020 07:41:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F1B7F4BB7B;
	Fri, 20 Nov 2020 07:41:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK7fRwo005730 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 02:41:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A104D10EB291; Fri, 20 Nov 2020 07:41:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D19510EB292
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:41:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4002B103B802
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:41:25 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-256-v0cSH20mNoCXAlfKgsQKXQ-1;
	Fri, 20 Nov 2020 02:41:20 -0500
X-MC-Unique: v0cSH20mNoCXAlfKgsQKXQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 0C348AC23;
	Fri, 20 Nov 2020 07:41:19 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-65-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <38ac9782-a563-b7ea-595a-124159fb755d@suse.de>
Date: Fri, 20 Nov 2020 08:41:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-65-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AK7fRwo005730
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
Subject: Re: [dm-devel] [PATCH 64/78] dm: simplify flush_bio initialization
 in __send_empty_flush
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMTYvMjAgMzo1NyBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gV2UgZG9uJ3Qg
cmVhbGx5IG5lZWQgdGhlIHN0cnVjdCBibG9ja19kZXZpY2UgdG8gaW5pdGlhbGl6ZSBhIGJpby4g
IFNvCj4gc3dpdGNoIGZyb20gdXNpbmcgYmlvX3NldF9kZXYgdG8gbWFudWFsbHkgc2V0dGluZyB1
cCBiaV9kaXNrIChiaV9wYXJ0bm8KPiB3aWxsIGFsd2F5cyBiZSB6ZXJvIGFuZCBoYXMgYmVlbiBj
bGVhcmVkIGJ5IGJpb19pbml0IGFscmVhZHkpLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgZHJpdmVycy9tZC9kbS5jIHwgMTIgKysr
LS0tLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9u
cygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLmMgYi9kcml2ZXJzL21kL2RtLmMK
PiBpbmRleCA1NDczOWYxYjU3OWJjOC4uNmQ3ZWI3MmQ0MWY5ZWEgMTAwNjQ0Cj4gLS0tIGEvZHJp
dmVycy9tZC9kbS5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS5jCj4gQEAgLTE0MjIsMTggKzE0MjIs
MTIgQEAgc3RhdGljIGludCBfX3NlbmRfZW1wdHlfZmx1c2goc3RydWN0IGNsb25lX2luZm8gKmNp
KQo+ICAgCSAqLwo+ICAgCWJpb19pbml0KCZmbHVzaF9iaW8sIE5VTEwsIDApOwo+ICAgCWZsdXNo
X2Jpby5iaV9vcGYgPSBSRVFfT1BfV1JJVEUgfCBSRVFfUFJFRkxVU0ggfCBSRVFfU1lOQzsKPiAr
CWZsdXNoX2Jpby5iaV9kaXNrID0gY2ktPmlvLT5tZC0+ZGlzazsKPiArCWJpb19hc3NvY2lhdGVf
YmxrZygmZmx1c2hfYmlvKTsKPiArCj4gICAJY2ktPmJpbyA9ICZmbHVzaF9iaW87Cj4gICAJY2kt
PnNlY3Rvcl9jb3VudCA9IDA7Cj4gICAKPiAtCS8qCj4gLQkgKiBFbXB0eSBmbHVzaCB1c2VzIGEg
c3RhdGljYWxseSBpbml0aWFsaXplZCBiaW8sIGFzIHRoZSBiYXNlIGZvcgo+IC0JICogY2xvbmlu
Zy4gIEhvd2V2ZXIsIGJsa2cgYXNzb2NpYXRpb24gcmVxdWlyZXMgdGhhdCBhIGJkZXYgaXMKPiAt
CSAqIGFzc29jaWF0ZWQgd2l0aCBhIGdlbmRpc2ssIHdoaWNoIGRvZXNuJ3QgaGFwcGVuIHVudGls
IHRoZSBiZGV2IGlzCj4gLQkgKiBvcGVuZWQuICBTbywgYmxrZyBhc3NvY2lhdGlvbiBpcyBkb25l
IGF0IGlzc3VlIHRpbWUgb2YgdGhlIGZsdXNoCj4gLQkgKiByYXRoZXIgdGhhbiB3aGVuIHRoZSBk
ZXZpY2UgaXMgY3JlYXRlZCBpbiBhbGxvY19kZXYoKS4KPiAtCSAqLwo+IC0JYmlvX3NldF9kZXYo
Y2ktPmJpbywgY2ktPmlvLT5tZC0+YmRldik7Cj4gLQo+ICAgCUJVR19PTihiaW9faGFzX2RhdGEo
Y2ktPmJpbykpOwo+ICAgCXdoaWxlICgodGkgPSBkbV90YWJsZV9nZXRfdGFyZ2V0KGNpLT5tYXAs
IHRhcmdldF9ucisrKSkpCj4gICAJCV9fc2VuZF9kdXBsaWNhdGVfYmlvcyhjaSwgdGksIHRpLT5u
dW1fZmx1c2hfYmlvcywgTlVMTCk7Cj4gCkFoLCB0aG91Z2h0IGFzIG11Y2guIEkndmUgc3R1bWJs
ZWQgYWNyb3NzIHRoaXMgd2hpbGUgZGVidWdnaW5nIApibGstaW50ZXJwb3Nlci4KClJldmlld2Vk
LWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAK
RHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRl
Y3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1
MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkg
TsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZl
bGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


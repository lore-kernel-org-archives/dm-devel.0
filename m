Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96532C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:10:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0222E206CA
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:10:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0222E206CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-ePJwFk9bP96qbEru3DR5dA-1; Mon, 30 Nov 2020 02:10:29 -0500
X-MC-Unique: ePJwFk9bP96qbEru3DR5dA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD2F6802B42;
	Mon, 30 Nov 2020 07:10:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CB125C1BB;
	Mon, 30 Nov 2020 07:10:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6BF641809C9F;
	Mon, 30 Nov 2020 07:10:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU7ANbC021751 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:10:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1C358200A4F0; Mon, 30 Nov 2020 07:10:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 178972026D49
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:10:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEE89103B807
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:10:20 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-310-uduJrjcOO_alhKwz16w3zQ-1;
	Mon, 30 Nov 2020 02:10:16 -0500
X-MC-Unique: uduJrjcOO_alhKwz16w3zQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9CD36AC6A;
	Mon, 30 Nov 2020 07:10:14 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-16-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <9520bc81-43f6-889a-7e39-007f6f5ab9bf@suse.de>
Date: Mon, 30 Nov 2020 08:10:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-16-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU7ANbC021751
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 15/45] block: change the hash used for
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

T24gMTEvMjgvMjAgNToxNCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gQWRkaW5nIHRo
ZSBtaW5vciB0byB0aGUgbWFqb3IgY3JlYXRlcyB0b25zIG9mIHBvaW50bGVzcyBjb25mbGljdHMu
IEp1c3QKPiB1c2UgdGhlIGRldl90IGl0c2VsZiwgd2hpY2ggaXMgMzItYml0cyBhbmQgdGh1cyBp
cyBndWFyYW50ZWVkIHRvIGZpdAo+IGludG8gaW5vX3QuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hy
aXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gUmV2aWV3ZWQtYnk6IEdyZWcgS3JvYWgtSGFy
dG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Cj4gUmV2aWV3ZWQtYnk6IEphbiBLYXJh
IDxqYWNrQHN1c2UuY3o+Cj4gQWNrZWQtYnk6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KPiAt
LS0KPiAgIGZzL2Jsb2NrX2Rldi5jIHwgMjYgKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDI0IGRlbGV0aW9ucygtKQo+IAo+IGRp
ZmYgLS1naXQgYS9mcy9ibG9ja19kZXYuYyBiL2ZzL2Jsb2NrX2Rldi5jCj4gaW5kZXggYzU3NTUx
NTBjNmJlNjIuLmQ3MDdhYjM3NmRhODZlIDEwMDY0NAo+IC0tLSBhL2ZzL2Jsb2NrX2Rldi5jCj4g
KysrIGIvZnMvYmxvY2tfZGV2LmMKPiBAQCAtODYzLDM1ICs4NjMsMTIgQEAgdm9pZCBfX2luaXQg
YmRldl9jYWNoZV9pbml0KHZvaWQpCj4gICAJYmxvY2tkZXZfc3VwZXJibG9jayA9IGJkX21udC0+
bW50X3NiOyAgIC8qIEZvciB3cml0ZWJhY2sgKi8KPiAgIH0KPiAgIAo+IC0vKgo+IC0gKiBNb3N0
IGxpa2VseSBfdmVyeV8gYmFkIG9uZSAtIGJ1dCB0aGVuIGl0J3MgaGFyZGx5IGNyaXRpY2FsIGZv
ciBzbWFsbAo+IC0gKiAvZGV2IGFuZCBjYW4gYmUgZml4ZWQgd2hlbiBzb21lYm9keSB3aWxsIG5l
ZWQgcmVhbGx5IGxhcmdlIG9uZS4KPiAtICogS2VlcCBpbiBtaW5kIHRoYXQgaXQgd2lsbCBiZSBm
ZWQgdGhyb3VnaCBpY2FjaGUgaGFzaCBmdW5jdGlvbiB0b28uCj4gLSAqLwo+IC1zdGF0aWMgaW5s
aW5lIHVuc2lnbmVkIGxvbmcgaGFzaChkZXZfdCBkZXYpCj4gLXsKPiAtCXJldHVybiBNQUpPUihk
ZXYpK01JTk9SKGRldik7Cj4gLX0KPiAtCj4gLXN0YXRpYyBpbnQgYmRldl90ZXN0KHN0cnVjdCBp
bm9kZSAqaW5vZGUsIHZvaWQgKmRhdGEpCj4gLXsKPiAtCXJldHVybiBCREVWX0koaW5vZGUpLT5i
ZGV2LmJkX2RldiA9PSAqKGRldl90ICopZGF0YTsKPiAtfQo+IC0KPiAtc3RhdGljIGludCBiZGV2
X3NldChzdHJ1Y3QgaW5vZGUgKmlub2RlLCB2b2lkICpkYXRhKQo+IC17Cj4gLQlCREVWX0koaW5v
ZGUpLT5iZGV2LmJkX2RldiA9ICooZGV2X3QgKilkYXRhOwo+IC0JcmV0dXJuIDA7Cj4gLX0KPiAt
Cj4gICBzdGF0aWMgc3RydWN0IGJsb2NrX2RldmljZSAqYmRnZXQoZGV2X3QgZGV2KQo+ICAgewo+
ICAgCXN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXY7Cj4gICAJc3RydWN0IGlub2RlICppbm9kZTsK
PiAgIAo+IC0JaW5vZGUgPSBpZ2V0NV9sb2NrZWQoYmxvY2tkZXZfc3VwZXJibG9jaywgaGFzaChk
ZXYpLAo+IC0JCQliZGV2X3Rlc3QsIGJkZXZfc2V0LCAmZGV2KTsKPiAtCj4gKwlpbm9kZSA9IGln
ZXRfbG9ja2VkKGJsb2NrZGV2X3N1cGVyYmxvY2ssIGRldik7Cj4gICAJaWYgKCFpbm9kZSkKPiAg
IAkJcmV0dXJuIE5VTEw7Cj4gICAKPiBAQCAtOTAzLDYgKzg4MCw3IEBAIHN0YXRpYyBzdHJ1Y3Qg
YmxvY2tfZGV2aWNlICpiZGdldChkZXZfdCBkZXYpCj4gICAJCWJkZXYtPmJkX3N1cGVyID0gTlVM
TDsKPiAgIAkJYmRldi0+YmRfaW5vZGUgPSBpbm9kZTsKPiAgIAkJYmRldi0+YmRfcGFydF9jb3Vu
dCA9IDA7Cj4gKwkJYmRldi0+YmRfZGV2ID0gZGV2Owo+ICAgCQlpbm9kZS0+aV9tb2RlID0gU19J
RkJMSzsKPiAgIAkJaW5vZGUtPmlfcmRldiA9IGRldjsKPiAgIAkJaW5vZGUtPmlfYmRldiA9IGJk
ZXY7Cj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVy
cywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwg
U3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVs
ZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jD
pGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbA==


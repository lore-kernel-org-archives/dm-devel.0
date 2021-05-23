Return-Path: <SRS0=zCJ6=KS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D8BC47080
	for <dm-devel@archiver.kernel.org>; Sun, 23 May 2021 08:13:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2EA4C61261
	for <dm-devel@archiver.kernel.org>; Sun, 23 May 2021 08:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EA4C61261
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-hsn5GY3UNMW1ER6xoMPy7w-1; Sun, 23 May 2021 04:13:07 -0400
X-MC-Unique: hsn5GY3UNMW1ER6xoMPy7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2B1E802B78;
	Sun, 23 May 2021 08:13:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D34D06E505;
	Sun, 23 May 2021 08:13:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A1F6444A63;
	Sun, 23 May 2021 08:13:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14N8D0hd029219 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 May 2021 04:13:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 55A0C2166BDF; Sun, 23 May 2021 08:13:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 513852166BA4
	for <dm-devel@redhat.com>; Sun, 23 May 2021 08:12:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2BF9101A55F
	for <dm-devel@redhat.com>; Sun, 23 May 2021 08:12:56 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-262-1CBsTzZGPCGryawXAhRL3g-1;
	Sun, 23 May 2021 04:12:52 -0400
X-MC-Unique: 1CBsTzZGPCGryawXAhRL3g-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 009B9AC3A;
	Sun, 23 May 2021 08:12:51 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
	Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-15-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <e65de9e6-337c-3e41-b5c2-d033ff236582@suse.de>
Date: Sun, 23 May 2021 10:12:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-15-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14N8D0hd029219
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 14/26] md: convert to
	blk_alloc_disk/blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMS8yMSA3OjUxIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBDb252ZXJ0IHRo
ZSBtZCBkcml2ZXIgdG8gdXNlIHRoZSBibGtfYWxsb2NfZGlzayBhbmQgYmxrX2NsZWFudXBfZGlz
awo+IGhlbHBlcnMgdG8gc2ltcGxpZnkgZ2VuZGlzayBhbmQgcmVxdWVzdF9xdWV1ZSBhbGxvY2F0
aW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+
IC0tLQo+ICAgZHJpdmVycy9tZC9tZC5jIHwgMjUgKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLQo+
ICAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pCj4gCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQuYyBiL2RyaXZlcnMvbWQvbWQuYwo+IGluZGV4IDQ5
Zjg5N2ZiYjg5Yi4uZDgwNmJlOGNjMjEwIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvbWQuYwo+
ICsrKyBiL2RyaXZlcnMvbWQvbWQuYwo+IEBAIC01NTk4LDEyICs1NTk4LDEwIEBAIHN0YXRpYyB2
b2lkIG1kX2ZyZWUoc3RydWN0IGtvYmplY3QgKmtvKQo+ICAgCWlmIChtZGRldi0+c3lzZnNfbGV2
ZWwpCj4gICAJCXN5c2ZzX3B1dChtZGRldi0+c3lzZnNfbGV2ZWwpOwo+ICAgCj4gLQlpZiAobWRk
ZXYtPmdlbmRpc2spCj4gKwlpZiAobWRkZXYtPmdlbmRpc2spIHsKPiAgIAkJZGVsX2dlbmRpc2so
bWRkZXYtPmdlbmRpc2spOwo+IC0JaWYgKG1kZGV2LT5xdWV1ZSkKPiAtCQlibGtfY2xlYW51cF9x
dWV1ZShtZGRldi0+cXVldWUpOwo+IC0JaWYgKG1kZGV2LT5nZW5kaXNrKQo+IC0JCXB1dF9kaXNr
KG1kZGV2LT5nZW5kaXNrKTsKPiArCQlibGtfY2xlYW51cF9kaXNrKG1kZGV2LT5nZW5kaXNrKTsK
PiArCX0KPiAgIAlwZXJjcHVfcmVmX2V4aXQoJm1kZGV2LT53cml0ZXNfcGVuZGluZyk7Cj4gICAK
PiAgIAliaW9zZXRfZXhpdCgmbWRkZXYtPmJpb19zZXQpOwo+IEBAIC01NzExLDIwICs1NzA5LDEz
IEBAIHN0YXRpYyBpbnQgbWRfYWxsb2MoZGV2X3QgZGV2LCBjaGFyICpuYW1lKQo+ICAgCQlnb3Rv
IGFib3J0Owo+ICAgCj4gICAJZXJyb3IgPSAtRU5PTUVNOwo+IC0JbWRkZXYtPnF1ZXVlID0gYmxr
X2FsbG9jX3F1ZXVlKE5VTUFfTk9fTk9ERSk7Cj4gLQlpZiAoIW1kZGV2LT5xdWV1ZSkKPiArCWRp
c2sgPSBibGtfYWxsb2NfZGlzayhOVU1BX05PX05PREUpOwo+ICsJaWYgKCFkaXNrKQo+ICAgCQln
b3RvIGFib3J0Owo+ICAgCj4gLQlibGtfc2V0X3N0YWNraW5nX2xpbWl0cygmbWRkZXYtPnF1ZXVl
LT5saW1pdHMpOwo+IC0KPiAtCWRpc2sgPSBhbGxvY19kaXNrKDEgPDwgc2hpZnQpOwo+IC0JaWYg
KCFkaXNrKSB7Cj4gLQkJYmxrX2NsZWFudXBfcXVldWUobWRkZXYtPnF1ZXVlKTsKPiAtCQltZGRl
di0+cXVldWUgPSBOVUxMOwo+IC0JCWdvdG8gYWJvcnQ7Cj4gLQl9Cj4gICAJZGlzay0+bWFqb3Ig
PSBNQUpPUihtZGRldi0+dW5pdCk7Cj4gICAJZGlzay0+Zmlyc3RfbWlub3IgPSB1bml0IDw8IHNo
aWZ0Owo+ICsJZGlzay0+bWlub3JzID0gMSA8PCBzaGlmdDsKPiAgIAlpZiAobmFtZSkKPiAgIAkJ
c3RyY3B5KGRpc2stPmRpc2tfbmFtZSwgbmFtZSk7Cj4gICAJZWxzZSBpZiAocGFydGl0aW9uZWQp
Cj4gQEAgLTU3MzMsNyArNTcyNCw5IEBAIHN0YXRpYyBpbnQgbWRfYWxsb2MoZGV2X3QgZGV2LCBj
aGFyICpuYW1lKQo+ICAgCQlzcHJpbnRmKGRpc2stPmRpc2tfbmFtZSwgIm1kJWQiLCB1bml0KTsK
PiAgIAlkaXNrLT5mb3BzID0gJm1kX2ZvcHM7Cj4gICAJZGlzay0+cHJpdmF0ZV9kYXRhID0gbWRk
ZXY7Cj4gLQlkaXNrLT5xdWV1ZSA9IG1kZGV2LT5xdWV1ZTsKPiArCj4gKwltZGRldi0+cXVldWUg
PSBkaXNrLT5xdWV1ZTsKPiArCWJsa19zZXRfc3RhY2tpbmdfbGltaXRzKCZtZGRldi0+cXVldWUt
PmxpbWl0cyk7Cj4gICAJYmxrX3F1ZXVlX3dyaXRlX2NhY2hlKG1kZGV2LT5xdWV1ZSwgdHJ1ZSwg
dHJ1ZSk7Cj4gICAJLyogQWxsb3cgZXh0ZW5kZWQgcGFydGl0aW9ucy4gIFRoaXMgbWFrZXMgdGhl
Cj4gICAJICogJ21kcCcgZGV2aWNlIHJlZHVuZGFudCwgYnV0IHdlIGNhbid0IHJlYWxseQo+IApX
b3VsZG4ndCBpdCBtYWtlIHNlbnNlIHRvIGludHJvZHVjZSBhIGhlbHBlciAnYmxrX3F1ZXVlX2Zy
b21fZGlzaygpJyBvciAKc29tZXN1Y2ggdG8gYXZvaWQgaGF2aW5nIHRvIGtlZXAgYW4gZXhwbGlj
aXQgJ3F1ZXVlJyBwb2ludGVyPwoKCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWlu
ZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRl
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0
d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAz
NjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZl
cgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A6DC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 05:50:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9842F611BD
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 05:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9842F611BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-rap1nLC6MIyCFocoKneyFA-1; Thu, 20 May 2021 01:50:27 -0400
X-MC-Unique: rap1nLC6MIyCFocoKneyFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FCB51007476;
	Thu, 20 May 2021 05:50:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95CCB614FD;
	Thu, 20 May 2021 05:50:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9458C44A5D;
	Thu, 20 May 2021 05:50:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K5oJMU014658 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 01:50:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4C557107673; Thu, 20 May 2021 05:50:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A4C107693
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:50:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F134101D22A
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:50:16 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-20-D8rPlKZTMO29ekPZcjfNqw-1;
	Thu, 20 May 2021 01:50:08 -0400
X-MC-Unique: D8rPlKZTMO29ekPZcjfNqw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 87BB7AF03;
	Thu, 20 May 2021 05:50:06 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-3-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <c4b2a9b8-3d0e-1266-dcdd-cc11e5567c60@suse.de>
Date: Thu, 20 May 2021 07:50:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520042228.974083-3-damien.lemoal@wdc.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K5oJMU014658
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 02/11] block: introduce bio zone helpers
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

T24gNS8yMC8yMSA2OjIyIEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBJbnRyb2R1Y2UgdGhl
IGhlbHBlciBmdW5jdGlvbnMgYmlvX3pvbmVfbm8oKSBhbmQgYmlvX3pvbmVfaXNfc2VxKCkuCj4g
Qm90aCBhcmUgdGhlIEJJTyBjb3VudGVycGFydHMgb2YgdGhlIHJlcXVlc3QgaGVscGVycyBibGtf
cnFfem9uZV9ubygpCj4gYW5kIGJsa19ycV96b25lX2lzX3NlcSgpLCByZXNwZWN0aXZlbHkgcmV0
dXJuaW5nIHRoZSBudW1iZXIgb2YgdGhlCj4gdGFyZ2V0IHpvbmUgb2YgYSBiaW8gYW5kIHRydWUg
aWYgdGhlIEJJTyB0YXJnZXQgem9uZSBpcyBzZXF1ZW50aWFsLgo+IAo+IFNpZ25lZC1vZmYtYnk6
IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVtb2FsQHdkYy5jb20+Cj4gLS0tCj4gICBpbmNsdWRl
L2xpbnV4L2Jsa2Rldi5oIHwgMTIgKysrKysrKysrKysrCj4gICAxIGZpbGUgY2hhbmdlZCwgMTIg
aW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5oIGIv
aW5jbHVkZS9saW51eC9ibGtkZXYuaAo+IGluZGV4IGY2OWM3NWJkNmQyNy4uMmRiMGYzNzZmNWQ5
IDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKPiArKysgYi9pbmNsdWRlL2xp
bnV4L2Jsa2Rldi5oCj4gQEAgLTEwMDgsNiArMTAwOCwxOCBAQCBzdGF0aWMgaW5saW5lIHVuc2ln
bmVkIGludCBibGtfcnFfc3RhdHNfc2VjdG9ycyhjb25zdCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCj4g
ICAvKiBIZWxwZXIgdG8gY29udmVydCBCTEtfWk9ORV9aT05FX1hYWCB0byBpdHMgc3RyaW5nIGZv
cm1hdCBYWFggKi8KPiAgIGNvbnN0IGNoYXIgKmJsa196b25lX2NvbmRfc3RyKGVudW0gYmxrX3pv
bmVfY29uZCB6b25lX2NvbmQpOwo+ICAgCj4gK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGJp
b196b25lX25vKHN0cnVjdCBiaW8gKmJpbykKPiArewo+ICsJcmV0dXJuIGJsa19xdWV1ZV96b25l
X25vKGJkZXZfZ2V0X3F1ZXVlKGJpby0+YmlfYmRldiksCj4gKwkJCQkgYmlvLT5iaV9pdGVyLmJp
X3NlY3Rvcik7Cj4gK30KPiArCj4gK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGJpb196b25l
X2lzX3NlcShzdHJ1Y3QgYmlvICpiaW8pCj4gK3sKPiArCXJldHVybiBibGtfcXVldWVfem9uZV9p
c19zZXEoYmRldl9nZXRfcXVldWUoYmlvLT5iaV9iZGV2KSwKPiArCQkJCSAgICAgYmlvLT5iaV9p
dGVyLmJpX3NlY3Rvcik7Cj4gK30KPiArCj4gICBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBi
bGtfcnFfem9uZV9ubyhzdHJ1Y3QgcmVxdWVzdCAqcnEpCj4gICB7Cj4gICAJcmV0dXJuIGJsa19x
dWV1ZV96b25lX25vKHJxLT5xLCBibGtfcnFfcG9zKHJxKSk7Cj4gClJldmlld2VkLWJ5OiBIYW5u
ZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5l
cyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBz
dXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VT
RSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJn
CkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5k
w7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


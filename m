Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CB0C5519F
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:14:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4597206CA
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:14:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4597206CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-eAnJ5PPHNUWxkEjbwMRExg-1; Mon, 30 Nov 2020 02:14:38 -0500
X-MC-Unique: eAnJ5PPHNUWxkEjbwMRExg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B73118C8C00;
	Mon, 30 Nov 2020 07:14:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10BE95D6A8;
	Mon, 30 Nov 2020 07:14:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DD5D180954D;
	Mon, 30 Nov 2020 07:14:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU7EVQL022080 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:14:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 32A6420296AA; Mon, 30 Nov 2020 07:14:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C74020296A6
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:14:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2436103B805
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:14:28 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-465-T6bRL_PxNcu47-V55eFyTQ-1;
	Mon, 30 Nov 2020 02:14:24 -0500
X-MC-Unique: T6bRL_PxNcu47-V55eFyTQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 82ED1AC55;
	Mon, 30 Nov 2020 07:14:22 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-17-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <595de89b-944c-a694-c63e-7600370d28fc@suse.de>
Date: Mon, 30 Nov 2020 08:14:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-17-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU7EVQL022080
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 16/45] block: switch bdgrab to use igrab
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

T24gMTEvMjgvMjAgNToxNCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gQWxsIG9mIHRo
ZSBjdXJyZW50IGNhbGxlcnMgYWxyZWFkeSBoYXZlIGEgcmVmZXJlbmNlLCBidXQgdG8gcHJlcGFy
ZSBmb3IKPiBhZGRpdGlvbmFsIHVzZXJzIGVuc3VyZSBiZGdyYWIgcmV0dXJucyBOVUxMIGlmIHRo
ZSBibG9jayBkZXZpY2UgaXMgYmVlaW5nCj4gZnJlZWQuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hy
aXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBmcy9ibG9ja19kZXYuYyB8IDYg
KysrKystCj4gICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
Cj4gCj4gZGlmZiAtLWdpdCBhL2ZzL2Jsb2NrX2Rldi5jIGIvZnMvYmxvY2tfZGV2LmMKPiBpbmRl
eCBkNzA3YWIzNzZkYTg2ZS4uOTYyZmFiZThhNjdiODMgMTAwNjQ0Cj4gLS0tIGEvZnMvYmxvY2tf
ZGV2LmMKPiArKysgYi9mcy9ibG9ja19kZXYuYwo+IEBAIC04OTQsMTAgKzg5NCwxNCBAQCBzdGF0
aWMgc3RydWN0IGJsb2NrX2RldmljZSAqYmRnZXQoZGV2X3QgZGV2KQo+ICAgLyoqCj4gICAgKiBi
ZGdyYWIgLS0gR3JhYiBhIHJlZmVyZW5jZSB0byBhbiBhbHJlYWR5IHJlZmVyZW5jZWQgYmxvY2sg
ZGV2aWNlCj4gICAgKiBAYmRldjoJQmxvY2sgZGV2aWNlIHRvIGdyYWIgYSByZWZlcmVuY2UgdG8u
Cj4gKyAqCj4gKyAqIFJldHVybnMgdGhlIGJsb2NrX2RldmljZSB3aXRoIGFuIGFkZGl0aW9uYWwg
cmVmZXJlbmNlIHdoZW4gc3VjY2Vzc2Z1bCwKPiArICogb3IgTlVMTCBpZiB0aGUgaW5vZGUgaXMg
YWxyZWFkeSBiZWVpbmcgZnJlZWQuCj4gICAgKi8KPiAgIHN0cnVjdCBibG9ja19kZXZpY2UgKmJk
Z3JhYihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2KQo+ICAgewo+IC0JaWhvbGQoYmRldi0+YmRf
aW5vZGUpOwo+ICsJaWYgKCFpZ3JhYihiZGV2LT5iZF9pbm9kZSkpCj4gKwkJcmV0dXJuIE5VTEw7
Cj4gICAJcmV0dXJuIGJkZXY7Cj4gICB9Cj4gICBFWFBPUlRfU1lNQk9MKGJkZ3JhYik7Cj4gClJl
dmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5l
cwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBB
cmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkx
MSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwg
OTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhy
ZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbA==


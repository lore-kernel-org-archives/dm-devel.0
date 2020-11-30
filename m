Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A121C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:08:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 78338206CB
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78338206CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-TgO1m4s-MoSOyneSPnXFFw-1; Mon, 30 Nov 2020 02:08:13 -0500
X-MC-Unique: TgO1m4s-MoSOyneSPnXFFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E017E1E7EF;
	Mon, 30 Nov 2020 07:08:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B7E960C4D;
	Mon, 30 Nov 2020 07:08:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36B174A7C6;
	Mon, 30 Nov 2020 07:08:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU786M0021468 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:08:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2A3B02166B2E; Mon, 30 Nov 2020 07:08:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 256A92166B2C
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:08:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D842858EEC
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:08:04 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-204-NJGmZcShNI-f9Y1bk35tfA-1;
	Mon, 30 Nov 2020 02:07:59 -0500
X-MC-Unique: NJGmZcShNI-f9Y1bk35tfA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 0A17FAC8F;
	Mon, 30 Nov 2020 07:07:58 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-8-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <2b576021-844b-cdd9-a11d-f1f124707e65@suse.de>
Date: Mon, 30 Nov 2020 08:07:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-8-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU786M0021468
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 07/45] loop: do not call set_blocksize
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

T24gMTEvMjgvMjAgNToxNCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gc2V0X2Jsb2Nr
c2l6ZSBpcyB1c2VkIGJ5IGZpbGUgc3lzdGVtcyB0byB1c2UgdGhlaXIgcHJlZmVycmVkIGJ1ZmZl
ciBjYWNoZQo+IGJsb2NrIHNpemUuICBCbG9jayBkcml2ZXJzIHNob3VsZCBub3Qgc2V0IGl0Lgo+
IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IFJldmll
d2VkLWJ5OiBKYW4gS2FyYSA8amFja0BzdXNlLmN6Pgo+IC0tLQo+ICAgZHJpdmVycy9ibG9jay9s
b29wLmMgfCAzIC0tLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDMgZGVsZXRpb25zKC0pCj4gCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svbG9vcC5jIGIvZHJpdmVycy9ibG9jay9sb29wLmMKPiBp
bmRleCA5YTI3ZDRmMWMwOGFhYy4uYjQyYzcyODYyMGM5ZTQgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVy
cy9ibG9jay9sb29wLmMKPiArKysgYi9kcml2ZXJzL2Jsb2NrL2xvb3AuYwo+IEBAIC0xMTY0LDkg
KzExNjQsNiBAQCBzdGF0aWMgaW50IGxvb3BfY29uZmlndXJlKHN0cnVjdCBsb29wX2RldmljZSAq
bG8sIGZtb2RlX3QgbW9kZSwKPiAgIAlzaXplID0gZ2V0X2xvb3Bfc2l6ZShsbywgZmlsZSk7Cj4g
ICAJbG9vcF9zZXRfc2l6ZShsbywgc2l6ZSk7Cj4gICAKPiAtCXNldF9ibG9ja3NpemUoYmRldiwg
U19JU0JMSyhpbm9kZS0+aV9tb2RlKSA/Cj4gLQkJICAgICAgYmxvY2tfc2l6ZShpbm9kZS0+aV9i
ZGV2KSA6IFBBR0VfU0laRSk7Cj4gLQo+ICAgCWxvLT5sb19zdGF0ZSA9IExvX2JvdW5kOwo+ICAg
CWlmIChwYXJ0X3NoaWZ0KQo+ICAgCQlsby0+bG9fZmxhZ3MgfD0gTE9fRkxBR1NfUEFSVFNDQU47
Cj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywK
Ckhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3Rv
cmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0
ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0
c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbA==


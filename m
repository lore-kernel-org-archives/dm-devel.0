Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F340C5519F
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:46:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 73CB820709
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:46:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73CB820709
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-Dn_FWgBiOQe3bZnk4-jt5w-1; Mon, 30 Nov 2020 02:46:45 -0500
X-MC-Unique: Dn_FWgBiOQe3bZnk4-jt5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EE861005D67;
	Mon, 30 Nov 2020 07:46:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F0C660657;
	Mon, 30 Nov 2020 07:46:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E7B4B4A7C6;
	Mon, 30 Nov 2020 07:46:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU7kcgB026481 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:46:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 38C8A200A4F0; Mon, 30 Nov 2020 07:46:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3429A2026D49
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:46:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFA49811E85
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:46:34 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-273-IavlzT6sO7i2LrJDtPOs6A-1;
	Mon, 30 Nov 2020 02:46:31 -0500
X-MC-Unique: IavlzT6sO7i2LrJDtPOs6A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5BC21AC55;
	Mon, 30 Nov 2020 07:46:30 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-38-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <e20d55a3-5d82-6e74-3cad-35b58fe1ceb1@suse.de>
Date: Mon, 30 Nov 2020 08:46:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-38-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU7kcgB026481
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 37/45] block: allocate struct hd_struct as
 part of struct bdev_inode
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMjgvMjAgNToxNSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gQWxsb2NhdGUg
aGRfc3RydWN0IHRvZ2V0aGVyIHdpdGggc3RydWN0IGJsb2NrX2RldmljZSB0byBwcmUtbG9hZAo+
IHRoZSBsaWZldGltZSBydWxlIGNoYW5nZXMgaW4gcHJlcGFyYXRpb24gb2YgbWVyZ2luZyB0aGUg
dHdvIHN0cnVjdHVyZXMuCj4gCj4gTm90ZSB0aGF0IHBhcnQwIHdhcyBwcmV2aW91c2x5IGVtYmVk
ZGVkIGludG8gc3RydWN0IGdlbmRpc2ssIGJ1dCBpcwo+IGEgc2VwYXJhdGUgYWxsb2NhdGlvbiBu
b3csIGFuZCBhbHJlYWR5IHBvaW50cyB0byB0aGUgYmxvY2tfZGV2aWNlIGluc3RlYWQKPiBvZiB0
aGUgaGRfc3RydWN0LiAgVGhlIGxpZmV0aW1lIG9mIHN0cnVjdCBnZW5kaXNrIGlzIHN0aWxsIGNv
bnRyb2xsZWQgYnkKPiB0aGUgc3RydWN0IGRldmljZSBlbWJlZGRlZCBpbiB0aGUgcGFydDAgaGRf
c3RydWN0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
Pgo+IC0tLQo+ICAgYmxvY2svYmxrLWNvcmUuYyAgICAgICAgICAgICAgICAgICB8IDE2ICsrKyst
LS0KPiAgIGJsb2NrL2Jsay1mbHVzaC5jICAgICAgICAgICAgICAgICAgfCAgMiArLQo+ICAgYmxv
Y2svYmxrLW1lcmdlLmMgICAgICAgICAgICAgICAgICB8ICAyIC0KPiAgIGJsb2NrL2Jsay5oICAg
ICAgICAgICAgICAgICAgICAgICAgfCAyMSAtLS0tLS0tLS0tCj4gICBibG9jay9nZW5oZC5jICAg
ICAgICAgICAgICAgICAgICAgIHwgNTAgKysrKysrKysrLS0tLS0tLS0tLS0tLQo+ICAgYmxvY2sv
cGFydGl0aW9ucy9jb3JlLmMgICAgICAgICAgICB8IDY3ICsrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQo+ICAgZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfcmVjZWl2ZXIuYyB8ICAyICstCj4g
ICBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF93b3JrZXIuYyAgIHwgIDMgKy0KPiAgIGRyaXZlcnMv
YmxvY2svenJhbS96cmFtX2Rydi5jICAgICAgfCAgMiArLQo+ICAgZHJpdmVycy9tZC9kbS5jICAg
ICAgICAgICAgICAgICAgICB8ICA0ICstCj4gICBkcml2ZXJzL21kL21kLmMgICAgICAgICAgICAg
ICAgICAgIHwgIDIgKy0KPiAgIGZzL2Jsb2NrX2Rldi5jICAgICAgICAgICAgICAgICAgICAgfCAz
OSArKysrKystLS0tLS0tLS0tLQo+ICAgaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCAgICAgICAg
ICB8ICAyICstCj4gICBpbmNsdWRlL2xpbnV4L2dlbmhkLmggICAgICAgICAgICAgIHwgMTQgKysr
LS0tLQo+ICAgaW5jbHVkZS9saW51eC9wYXJ0X3N0YXQuaCAgICAgICAgICB8ICA0ICstCj4gICAx
NSBmaWxlcyBjaGFuZ2VkLCA2MSBpbnNlcnRpb25zKCspLCAxNjkgZGVsZXRpb25zKC0pCj4gClJl
dmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5l
cwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBB
cmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkx
MSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwg
OTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhy
ZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbA==


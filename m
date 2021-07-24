Return-Path: <SRS0=ZA/Q=MS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04FCC4320A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0A14C60F42
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jul 2021 07:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0A14C60F42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-DDC4worTMnK2LyOSWRSg7w-1; Mon, 26 Jul 2021 03:08:37 -0400
X-MC-Unique: DDC4worTMnK2LyOSWRSg7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A16D487D545;
	Mon, 26 Jul 2021 07:08:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D54C5D6A1;
	Mon, 26 Jul 2021 07:08:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 53306180BAB2;
	Mon, 26 Jul 2021 07:08:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16O2bMW5021796 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Jul 2021 22:37:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5627E10553FF; Sat, 24 Jul 2021 02:37:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51D4D10553FE
	for <dm-devel@redhat.com>; Sat, 24 Jul 2021 02:37:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61A57800883
	for <dm-devel@redhat.com>; Sat, 24 Jul 2021 02:37:19 +0000 (UTC)
Received: from out30-54.freemail.mail.aliyun.com
	(out30-54.freemail.mail.aliyun.com [115.124.30.54]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-298-W5jKguxdP6ujSswpCnSPvA-1;
	Fri, 23 Jul 2021 22:37:16 -0400
X-MC-Unique: W5jKguxdP6ujSswpCnSPvA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R891e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=xianting.tian@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UglKWF5_1627093904
Received: from 192.168.0.105(mailfrom:xianting.tian@linux.alibaba.com
	fp:SMTPD_---0UglKWF5_1627093904) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 24 Jul 2021 10:31:45 +0800
To: agk@redhat.com, snitzer@redhat.com
References: <1626537263-8752-1-git-send-email-xianting_tian@126.com>
From: Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <ee68b3ff-2448-9c6b-acbe-f4f0b5585f48@linux.alibaba.com>
Date: Sat, 24 Jul 2021 10:31:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1626537263-8752-1-git-send-email-xianting_tian@126.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Jul 2021 03:08:04 -0400
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm io: fix comments to align with on-stack
	plugging
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Q291bGQgSSBnZXQgdGhlIGNvbW1lbnRzIGZvciB0aGUgcGF0Y2g/wqAgdGhhbmtzCgrlnKggMjAy
MS83LzE3IOS4i+WNiDExOjU0LCBYaWFudGluZyBUaWFuIOWGmemBkzoKPiBGcm9tOiBYaWFudGlu
ZyBUaWFuIDx4aWFudGluZy50aWFuQGxpbnV4LmFsaWJhYmEuY29tPgo+Cj4gVGhlciBpcyBubyB1
bnBsdWdnaW5nIHRpbWVyIG5vdywgb24tc3RhY2sgaW8gcGx1Z2dpbmcgaXMgdXNlZDoKPiAJc3Ry
dWN0IGJsa19wbHVnIHBsdWc7Cj4KPiAJYmxrX3N0YXJ0X3BsdWcoJnBsdWcpOwo+IAlzdWJtaXRf
YmF0Y2hfb2ZfaW8oKTsKPiAJYmxrX2ZpbmlzaF9wbHVnKCZwbHVnKTsKPgo+IFNvIHJlbW92ZSB0
aGUgb2xkIGNvbW1lbnRzIGZvciB1bnBsdWdnaW5nIHRpbWVyLgo+Cj4gU2lnbmVkLW9mZi1ieTog
WGlhbnRpbmcgVGlhbiA8eGlhbnRpbmcudGlhbkBsaW51eC5hbGliYWJhLmNvbT4KPiAtLS0KPiAg
IGRyaXZlcnMvbWQvZG0taW8uYyB8IDUgLS0tLS0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA1IGRlbGV0
aW9ucygtKQo+Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0taW8uYyBiL2RyaXZlcnMvbWQv
ZG0taW8uYwo+IGluZGV4IDJkM2NkYTAuLjdkYmExOTMgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9t
ZC9kbS1pby5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS1pby5jCj4gQEAgLTUyOCwxMSArNTI4LDYg
QEAgc3RhdGljIGludCBkcF9pbml0KHN0cnVjdCBkbV9pb19yZXF1ZXN0ICppb19yZXEsIHN0cnVj
dCBkcGFnZXMgKmRwLAo+ICAgCj4gICAvKgo+ICAgICogTmV3IGNvbGxhcHNlZCAoYSlzeW5jaHJv
bm91cyBpbnRlcmZhY2UuCj4gLSAqCj4gLSAqIElmIHRoZSBJTyBpcyBhc3luY2hyb25vdXMgKGku
ZS4gaXQgaGFzIG5vdGlmeS5mbiksIHlvdSBtdXN0IGVpdGhlciB1bnBsdWcKPiAtICogdGhlIHF1
ZXVlIHdpdGggYmxrX3VucGx1ZygpIHNvbWUgdGltZSBsYXRlciBvciBzZXQgUkVRX1NZTkMgaW4K
PiAtICogaW9fcmVxLT5iaV9vcGYuIElmIHlvdSBmYWlsIHRvIGRvIG9uZSBvZiB0aGVzZSwgdGhl
IElPIHdpbGwgYmUgc3VibWl0dGVkIHRvCj4gLSAqIHRoZSBkaXNrIGFmdGVyIHEtPnVucGx1Z19k
ZWxheSwgd2hpY2ggZGVmYXVsdHMgdG8gM21zIGluIGJsay1zZXR0aW5ncy5jLgo+ICAgICovCj4g
ICBpbnQgZG1faW8oc3RydWN0IGRtX2lvX3JlcXVlc3QgKmlvX3JlcSwgdW5zaWduZWQgbnVtX3Jl
Z2lvbnMsCj4gICAJICBzdHJ1Y3QgZG1faW9fcmVnaW9uICp3aGVyZSwgdW5zaWduZWQgbG9uZyAq
c3luY19lcnJvcl9iaXRzKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bA==


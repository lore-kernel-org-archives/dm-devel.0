Return-Path: <SRS0=l7Hk=GN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE56C433DB
	for <dm-devel@archiver.kernel.org>; Sun, 10 Jan 2021 15:01:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F297229EF
	for <dm-devel@archiver.kernel.org>; Sun, 10 Jan 2021 15:01:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F297229EF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-LrElrTpLPY29EGQtopwA-Q-1; Sun, 10 Jan 2021 10:01:35 -0500
X-MC-Unique: LrElrTpLPY29EGQtopwA-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39DC710054FF;
	Sun, 10 Jan 2021 15:01:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 166F65D6D5;
	Sun, 10 Jan 2021 15:01:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E03B2180954D;
	Sun, 10 Jan 2021 15:01:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10AF1SYf015858 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 10 Jan 2021 10:01:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6783F2026D49; Sun, 10 Jan 2021 15:01:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 633942026D47
	for <dm-devel@redhat.com>; Sun, 10 Jan 2021 15:01:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1209811E78
	for <dm-devel@redhat.com>; Sun, 10 Jan 2021 15:01:25 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-190-wdDDtkSiMnmy-lY4e-Ifyg-1;
	Sun, 10 Jan 2021 10:01:20 -0500
X-MC-Unique: wdDDtkSiMnmy-lY4e-Ifyg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 09169ACC6;
	Sun, 10 Jan 2021 15:01:19 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210109104254.1077093-1-hch@lst.de>
	<20210109104254.1077093-7-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <3269f70a-2bd4-9aa6-5f14-b13e5b67687e@suse.de>
Date: Sun, 10 Jan 2021 16:01:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210109104254.1077093-7-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10AF1SYf015858
X-loop: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 6/6] nvme: allow revalidate to set a
	namespace read-only
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

T24gMS85LzIxIDExOjQyIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBVbmNvbmRpdGlv
bmFsbHkgY2FsbCBzZXRfZGlza19ybyBub3cgdGhhdCBpdCBvbmx5IHVwZGF0ZXMgdGhlIGhhcmR3
YXJlCj4gc3RhdGUuICBUaGlzIGFsbG93cyB0byBwcm9wZXJseSBzZXQgdXAgdGhlIExpbnV4IGRl
dmljZXMgcmVhZC1vbmx5IHdoZW4KPiB0aGUgY29udHJvbGxlciB0dXJucyBhIHByZXZpb3VzbHkg
d3JpdGFibGUgbmFtZXNwYWNlIHJlYWQtb25seS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3Rv
cGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTogS2VpdGggQnVzY2ggPGtidXNj
aEBrZXJuZWwub3JnPgo+IFJldmlld2VkLWJ5OiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5w
ZXRlcnNlbkBvcmFjbGUuY29tPgo+IC0tLQo+ICAgZHJpdmVycy9udm1lL2hvc3QvY29yZS5jIHwg
NSArKy0tLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkKPiAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jIGIvZHJpdmVycy9u
dm1lL2hvc3QvY29yZS5jCj4gaW5kZXggY2UxYjYxNTE5NDQxMzEuLjNhMDU1N2NjYzlmYzVkIDEw
MDY0NAo+IC0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYwo+ICsrKyBiL2RyaXZlcnMvbnZt
ZS9ob3N0L2NvcmUuYwo+IEBAIC0yMTE0LDkgKzIxMTQsOCBAQCBzdGF0aWMgdm9pZCBudm1lX3Vw
ZGF0ZV9kaXNrX2luZm8oc3RydWN0IGdlbmRpc2sgKmRpc2ssCj4gICAJbnZtZV9jb25maWdfZGlz
Y2FyZChkaXNrLCBucyk7Cj4gICAJbnZtZV9jb25maWdfd3JpdGVfemVyb2VzKGRpc2ssIG5zKTsK
PiAgIAo+IC0JaWYgKChpZC0+bnNhdHRyICYgTlZNRV9OU19BVFRSX1JPKSB8fAo+IC0JICAgIHRl
c3RfYml0KE5WTUVfTlNfRk9SQ0VfUk8sICZucy0+ZmxhZ3MpKQo+IC0JCXNldF9kaXNrX3JvKGRp
c2ssIHRydWUpOwo+ICsJc2V0X2Rpc2tfcm8oZGlzaywgKGlkLT5uc2F0dHIgJiBOVk1FX05TX0FU
VFJfUk8pIHx8Cj4gKwkJdGVzdF9iaXQoTlZNRV9OU19GT1JDRV9STywgJm5zLT5mbGFncykpOwo+
ICAgfQo+ICAgCj4gICBzdGF0aWMgaW5saW5lIGJvb2wgbnZtZV9maXJzdF9zY2FuKHN0cnVjdCBn
ZW5kaXNrICpkaXNrKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2Uu
ZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAg
ICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdt
YkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVy
ZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=


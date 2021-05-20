Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68A4C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 05:52:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5907A61163
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 05:52:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5907A61163
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-jKMwhlFjONOVzMSRvMjCkA-1; Thu, 20 May 2021 01:52:18 -0400
X-MC-Unique: jKMwhlFjONOVzMSRvMjCkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4280A107ACCD;
	Thu, 20 May 2021 05:52:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 255656A036;
	Thu, 20 May 2021 05:52:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E87B255353;
	Thu, 20 May 2021 05:52:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K5qAn7014827 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 01:52:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3528F2133491; Thu, 20 May 2021 05:52:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30BA2202BFA0
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:52:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A713857AA4
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:52:06 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-503-sWmMDsMNN_moETMkn6k6qQ-1;
	Thu, 20 May 2021 01:52:04 -0400
X-MC-Unique: sWmMDsMNN_moETMkn6k6qQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 6A0D3AF03;
	Thu, 20 May 2021 05:52:02 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-4-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <cf0fdb6d-78f9-9dee-2462-5b9f9d5addc1@suse.de>
Date: Thu, 20 May 2021 07:52:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520042228.974083-4-damien.lemoal@wdc.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K5qAn7014827
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 03/11] block: introduce
	BIO_ZONE_WRITE_LOCKED bio flag
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
IEJJTyBmbGFnIEJJT19aT05FX1dSSVRFX0xPQ0tFRCB0byBpbmRpY2F0ZSB0aGF0IGEgQklPIG93
bnMKPiB0aGUgd3JpdGUgbG9jayBvZiB0aGUgem9uZSBpdCBpcyB0YXJnZXRpbmcuIFRoaXMgaXMg
dGhlIGNvdW50ZXJwYXJ0IG9mCj4gdGhlIHN0cnVjdCByZXF1ZXN0IGZsYWcgUlFGX1pPTkVfV1JJ
VEVfTE9DS0VELgo+IAo+IFRoaXMgbmV3IEJJTyBmbGFnIGlzIHJlc2VydmVkIGZvciBub3cgZm9y
IHpvbmUgd3JpdGUgbG9ja2luZyBjb250cm9sCj4gZm9yIGRldmljZSBtYXBwZXIgdGFyZ2V0cyBl
eHBvc2luZyBhIHpvbmVkIGJsb2NrIGRldmljZS4gU2luY2UgaW4gdGhpcwo+IGNhc2UsIHRoZSBs
b2NrIGZsYWcgbXVzdCBub3QgYmUgcHJvcGFnYXRlZCB0byB0aGUgc3RydWN0IHJlcXVlc3QgdGhh
dAo+IHdpbGwgYmUgdXNlZCB0byBwcm9jZXNzIHRoZSBCSU8sIGEgQklPIHByaXZhdGUgZmxhZyBp
cyB1c2VkIHJhdGhlciB0aGFuCj4gY2hhbmdpbmcgdGhlIFJRRl9aT05FX1dSSVRFX0xPQ0tFRCBy
ZXF1ZXN0IGZsYWcgaW50byBhIGNvbW1vbiBSRVFfWFhYCj4gZmxhZyB0aGF0IGNvdWxkIGJlIHVz
ZWQgZm9yIGJvdGggQklPIGFuZCByZXF1ZXN0LiBUaGlzIGF2b2lkcyBjb25mbGljdHMKPiBkb3du
IHRoZSBzdGFjayB3aXRoIHRoZSBibG9jayBJTyBzY2hlZHVsZXIgem9uZSB3cml0ZSBsb2NraW5n
Cj4gKGluIG1xLWRlYWRsaW5lKS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBEYW1pZW4gTGUgTW9hbCA8
ZGFtaWVuLmxlbW9hbEB3ZGMuY29tPgo+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4KPiAtLS0KPiAgIGluY2x1ZGUvbGludXgvYmxrX3R5cGVzLmggfCAxICsKPiAg
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo+IAo+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L2Jsa190eXBlcy5oIGIvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAo+IGluZGV4IGRi
MDI2YjZlYzE1YS4uZTVjZjEyZjEwMmEyIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGludXgvYmxr
X3R5cGVzLmgKPiArKysgYi9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oCj4gQEAgLTMwNCw2ICsz
MDQsNyBAQCBlbnVtIHsKPiAgIAlCSU9fQ0dST1VQX0FDQ1QsCS8qIGhhcyBiZWVuIGFjY291bnRl
ZCB0byBhIGNncm91cCAqLwo+ICAgCUJJT19UUkFDS0VELAkJLyogc2V0IGlmIGJpbyBnb2VzIHRo
cm91Z2ggdGhlIHJxX3FvcyBwYXRoICovCj4gICAJQklPX1JFTUFQUEVELAo+ICsJQklPX1pPTkVf
V1JJVEVfTE9DS0VELAkvKiBPd25zIGEgem9uZWQgZGV2aWNlIHpvbmUgd3JpdGUgbG9jayAqLwo+
ICAgCUJJT19GTEFHX0xBU1QKPiAgIH07Cj4gICAKPiAKSSB3b3VsZCBoYXZlIG1lcmdlZCB0aGlz
IHdpdGggdGhlIHBhdGNoIGFjdHVhbGx5IHVzaW5nIGl0LCBidXQgdGhpcyBpcyAKcHJvYmFibHkg
YSBwZXJzb25hbCBwcmVmZXJlbmNlLgoKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFy
ZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAg
ICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0
aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBO
w7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


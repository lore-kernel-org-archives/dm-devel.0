Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D76C64E7A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 12:48:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E82E5206A1
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 12:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E82E5206A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-lOTcNSgRNyyasvX5dhW35g-1; Thu, 03 Dec 2020 07:47:59 -0500
X-MC-Unique: lOTcNSgRNyyasvX5dhW35g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FEB9109DDE7;
	Thu,  3 Dec 2020 12:47:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC7635B4A0;
	Thu,  3 Dec 2020 12:47:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 556341809CA0;
	Thu,  3 Dec 2020 12:47:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3Ckc04004889 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 07:46:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 489F72166B29; Thu,  3 Dec 2020 12:46:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43C3F2166B27
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 12:46:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 147E7811E76
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 12:46:36 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-437-gRrP_KOlMwuZGgph9-GDaQ-1;
	Thu, 03 Dec 2020 07:46:33 -0500
X-MC-Unique: gRrP_KOlMwuZGgph9-GDaQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3FE8DAC65;
	Thu,  3 Dec 2020 12:46:32 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201130175854.982460-1-hch@lst.de>
	<20201130175854.982460-3-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <168a66f3-326f-6cb5-3153-e7ab75e332a6@suse.de>
Date: Thu, 3 Dec 2020 13:46:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130175854.982460-3-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B3Ckc04004889
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	dm-devel@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/5] block: simplify and extended the
 block_bio_merge tracepoint class
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

T24gMTEvMzAvMjAgNjo1OCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVGhlIGJsb2Nr
X2Jpb19tZXJnZSB0cmFjZXBvaW50IGNsYXNzIGNhbiBiZSByZXVzZWQgZm9yIG1vc3QgYmlvLWJh
c2VkCj4gdHJhY2Vwb2ludHMuICBGb3IgdGhhdCBpcyBqdXN0IG5lZWRzIHRvIGxvc2UgdGhlIHN1
cGVyZmxvdXMgYW5kIHJxCgonYW5kIHJxJyA/CkRvIHlvdSBtZWFuICdxIGFuZCBycSc/Cgo+IHBh
cmFtZXRlcnMuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3Qu
ZGU+Cj4gLS0tCj4gICBibG9jay9ibGstY29yZS5jICAgICAgICAgICAgIHwgICAyICstCj4gICBi
bG9jay9ibGstbWVyZ2UuYyAgICAgICAgICAgIHwgICA0ICstCj4gICBibG9jay9ibGstbXEuYyAg
ICAgICAgICAgICAgIHwgICAyICstCj4gICBibG9jay9ib3VuY2UuYyAgICAgICAgICAgICAgIHwg
ICAyICstCj4gICBpbmNsdWRlL3RyYWNlL2V2ZW50cy9ibG9jay5oIHwgMTU4ICsrKysrKysrLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gICBrZXJuZWwvdHJhY2UvYmxrdHJhY2UuYyAgICAg
IHwgIDQxICsrKy0tLS0tLQo+ICAgNiBmaWxlcyBjaGFuZ2VkLCA0OCBpbnNlcnRpb25zKCspLCAx
NjEgZGVsZXRpb25zKC0pCj4gCk90aGVyd2lzZToKClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVj
a2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNr
ZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2Fy
ZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgw
OSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


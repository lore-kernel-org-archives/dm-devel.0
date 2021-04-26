Return-Path: <SRS0=wTOt=JX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BE5C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 07:12:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 57883611C0
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 07:12:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57883611C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-7KGxu_a-N0O4BNc5bIdmPQ-1; Mon, 26 Apr 2021 03:12:39 -0400
X-MC-Unique: 7KGxu_a-N0O4BNc5bIdmPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1E5F18397A4;
	Mon, 26 Apr 2021 07:12:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 175BD6268B;
	Mon, 26 Apr 2021 07:12:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 23BE04EA30;
	Mon, 26 Apr 2021 07:12:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13Q7CO4Z012643 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Apr 2021 03:12:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 835B81111A67; Mon, 26 Apr 2021 07:12:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F01F1111A68
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 07:12:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DBA1101A52C
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 07:12:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-557-BH5_olgGPSqwU8UlH3HRow-1;
	Mon, 26 Apr 2021 03:12:19 -0400
X-MC-Unique: BH5_olgGPSqwU8UlH3HRow-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 55022B00D;
	Mon, 26 Apr 2021 07:12:17 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
	<20210422122038.2192933-5-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <2811ba56-dee3-9c3b-0bc6-d1072425032d@suse.de>
Date: Mon, 26 Apr 2021 09:12:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210422122038.2192933-5-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13Q7CO4Z012643
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V6 04/12] block: move block polling code into
 one dedicated source file
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
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yMi8yMSAyOjIwIFBNLCBNaW5nIExlaSB3cm90ZToKPiBQcmVwYXJlIGZvciBzdXBwb3J0
aW5nIGJpbyBiYXNlZCBpbyBwb2xsaW5nLCBhbmQgbW92ZSBibGsgcG9sbGluZwo+IGNvZGUgaW50
byBvbmUgZGVkaWNhdGVkIHNvdXJjZSBmaWxlLiBBbmQgdGhyZWUgc2hhcmVkIGZ1bmN0aW9ucyBh
cmUKPiBwdXQgaW50byBwcml2YXRlIGhlYWRlciBvZiBibGstbXEuaAo+IAo+IFN1Z2dlc3RlZC1i
eTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gU2lnbmVkLW9mZi1ieTogTWluZyBM
ZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+Cj4gLS0tCj4gIGJsb2NrL01ha2VmaWxlICAgfCAgIDMg
Ky0KPiAgYmxvY2svYmxrLW1xLmMgICB8IDIzMCAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQo+ICBibG9jay9ibGstbXEuaCAgIHwgIDQwICsrKysrKysrKwo+
ICBibG9jay9ibGstcG9sbC5jIHwgMTk2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysKPiAgNCBmaWxlcyBjaGFuZ2VkLCAyMzggaW5zZXJ0aW9ucygrKSwgMjMxIGRlbGV0
aW9ucygtKQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgYmxvY2svYmxrLXBvbGwuYwo+IApSZXZpZXdl
ZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0g
CkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0Cmhh
cmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdh
cmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgOTA0MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2
cmZmZXIsIEhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=


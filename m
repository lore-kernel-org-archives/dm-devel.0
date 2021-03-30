Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DFAC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:43:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 129E26198A
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 129E26198A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-rMCgm9ylMBKBU6JGe4GhWw-1; Tue, 30 Mar 2021 02:43:04 -0400
X-MC-Unique: rMCgm9ylMBKBU6JGe4GhWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1C601927802;
	Tue, 30 Mar 2021 06:43:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE21D66FFF;
	Tue, 30 Mar 2021 06:43:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 764B71809C83;
	Tue, 30 Mar 2021 06:43:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U6f852007962 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 02:41:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0EF042157F26; Tue, 30 Mar 2021 06:41:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08CFC2166B44
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:41:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9213811E93
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:41:05 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-68-C_Ub40xKN3C-iJAqjyjRHw-1;
	Tue, 30 Mar 2021 02:41:01 -0400
X-MC-Unique: C_Ub40xKN3C-iJAqjyjRHw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id DBBC5B1BD;
	Tue, 30 Mar 2021 06:40:59 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-13-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <c9cb5fe6-490e-867c-a8bc-842f3c5de835@suse.de>
Date: Tue, 30 Mar 2021 08:40:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210329152622.173035-13-ming.lei@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12U6f852007962
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V4 12/12] dm: support IO polling for
	bio-based dm device
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yOS8yMSA1OjI2IFBNLCBNaW5nIExlaSB3cm90ZToKPiBGcm9tOiBKZWZmbGUgWHUgPGpl
ZmZsZXh1QGxpbnV4LmFsaWJhYmEuY29tPgo+IAo+IElPIHBvbGxpbmcgaXMgZW5hYmxlZCB3aGVu
IGFsbCB1bmRlcmx5aW5nIHRhcmdldCBkZXZpY2VzIGFyZSBjYXBhYmxlCj4gb2YgSU8gcG9sbGlu
Zy4gVGhlIHNhbml0eSBjaGVjayBzdXBwb3J0cyB0aGUgc3RhY2tlZCBkZXZpY2UgbW9kZWwsIGlu
Cj4gd2hpY2ggb25lIGRtIGRldmljZSBtYXkgYmUgYnVpbGQgdXBvbiBhbm90aGVyIGRtIGRldmlj
ZS4gSW4gdGhpcyBjYXNlLAo+IHRoZSBtYXBwZWQgZGV2aWNlIHdpbGwgY2hlY2sgaWYgdGhlIHVu
ZGVybHlpbmcgZG0gdGFyZ2V0IGRldmljZQo+IHN1cHBvcnRzIElPIHBvbGxpbmcuCj4gCj4gUmV2
aWV3ZWQtYnk6IE1pa2UgU25pdHplciA8c25pdHplckByZWRoYXQuY29tPgo+IFNpZ25lZC1vZmYt
Ynk6IEplZmZsZSBYdSA8amVmZmxleHVAbGludXguYWxpYmFiYS5jb20+Cj4gU2lnbmVkLW9mZi1i
eTogTWluZyBMZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+Cj4gLS0tCj4gICBkcml2ZXJzL21kL2Rt
LXRhYmxlLmMgICAgICAgICB8IDI0ICsrKysrKysrKysrKysrKysrKysrKysrKwo+ICAgZHJpdmVy
cy9tZC9kbS5jICAgICAgICAgICAgICAgfCAxNCArKysrKysrKysrKysrKwo+ICAgaW5jbHVkZS9s
aW51eC9kZXZpY2UtbWFwcGVyLmggfCAgMSArCj4gICAzIGZpbGVzIGNoYW5nZWQsIDM5IGluc2Vy
dGlvbnMoKykKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoK
Q2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtl
cm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBN
YXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBH
ZXNjaMOkZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbA==


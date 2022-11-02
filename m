Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2501C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667398655;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VYyRyiqMJnZToH5mwqEDz3pjYUjqKlo7qm+N4cEKt0o=;
	b=W2mRZrtZb6EAHPO9Gr8qlv2mmpP6XZFjU/t2lqqUujAdv2E5wEFarNYHrqDdhhTIavwcBL
	AQFh7jgUh1BIwkAA8QAbTqSEv4NR9YEvUUkAyNCbOD+XQh6fNzlHXnR8DrPgtIX5b9EbZE
	AVVgRhwfOMbXeMfFs48wBWMgJTLGXOc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-QzP7vtIFPNivzh6oHSaqQQ-1; Wed, 02 Nov 2022 10:17:17 -0400
X-MC-Unique: QzP7vtIFPNivzh6oHSaqQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 246C91C09B8F;
	Wed,  2 Nov 2022 14:17:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0675C2E6B7;
	Wed,  2 Nov 2022 14:17:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B3751946597;
	Wed,  2 Nov 2022 14:17:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1BBA31946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 14:17:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 01B64112C063; Wed,  2 Nov 2022 14:17:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EECC4112C062
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 14:17:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC60186F133
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 14:17:06 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-iE-hyYlsMJWhhrJanrD61A-1; Wed, 02 Nov 2022 10:17:05 -0400
X-MC-Unique: iE-hyYlsMJWhhrJanrD61A-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id E1C7A68AA6; Wed,  2 Nov 2022 15:17:00 +0100 (CET)
Date: Wed, 2 Nov 2022 15:17:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <20221102141700.GA4442@lst.de>
References: <20221102064854.GA8950@lst.de>
 <1dc5c1d0-72b6-5455-0b05-5c755ad69045@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <1dc5c1d0-72b6-5455-0b05-5c755ad69045@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 8/7] block: don't claim devices that are not
 live in bd_link_disk_holder
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBOb3YgMDIsIDIwMjIgYXQgMDg6MTc6MzdQTSArMDgwMCwgWXUgS3VhaSB3cm90ZToK
PiBJIHRoaW5rIHRoaXMgaXMgc3RpbGwgbm90IHNhZmUg8J+klAoKSW5kZWVkIC0gd3Jvbmcgb3Bl
bl9tdXRleC4KCj4gKyAgICAgICAvKgo+ICsgICAgICAgICogZGVsX2dlbmRpc2sgZHJvcHMgdGhl
IGluaXRpYWwgcmVmZXJlbmNlIHRvIGJkX2hvbGRlcl9kaXIsIHNvIHdlIAo+IG5lZWQKPiArICAg
ICAgICAqIHRvIGtlZXAgb3VyIG93biBoZXJlIHRvIGFsbG93IGZvciBjbGVhbnVwIHBhc3QgdGhh
dCBwb2ludC4KPiArICAgICAgICAqLwo+ICsgICAgICAgbXV0ZXhfbG9jaygmYmRldi0+YmRfZGlz
ay0+b3Blbl9tdXRleCk7Cj4gKyAgICAgICBpZiAoIWRpc2tfbGl2ZShiZGV2LT5iZF9kaXNrKSkg
ewo+ICsgICAgICAgICAgICAgICByZXQgPSAtRU5PREVWOwo+ICsgICAgICAgICAgICAgICBtdXRl
eF91bmxvY2soJmJkZXYtPmJkX2Rpc2stPm9wZW5fbXV0ZXgpOwo+ICsgICAgICAgICAgICAgICBn
b3RvIG91dF91bmxvY2s7Cj4gKyAgICAgICB9CgpJIHRoaW5rIHRoaXMgbmVlZHMgdG8gYmUgZG9u
ZSBiZWZvcmUgdGFraW5nIGRpc2stPm9wZW5fbXV0ZXgsIG90aGVyd2lzZQp3ZSBjcmVhdGUgYSBs
b2NrIG9yZGVyIGRlcGVuZGVuY3kuICBBbHNvIHRoZSBjb21tZW50IHNlZW1zIHRvIG92ZXJmbG93
CnRoZSB1c3VhbCA4MCBjaGFyYWN0ZXIgbGltaXQsIGFuZCBhcyB5b3Ugbm90ZWQgaW4gdGhlIG5l
eHQgbWFpbCB0aGlzCm5lZWRzIG1vcmUgdW53aW5kaW5nLiAgQnV0IHllcywgb3RoZXJ3aXNlIHRo
aXMgaXMgdGhlIHJpZ2h0IHRoaW5nIHRvCmRvLiAgRG8geW91IHdhbnQgdG8gc2VuZCBhIHJlcGxh
Y2VtZW50IGZvciB0aGlzIHBhdGNoPwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbAo=


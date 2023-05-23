Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F22C7EE2A
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684903841;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nJl/J082ttvfaH/fmPNxCalWrw3WB7uS2ZImcbquEXQ=;
	b=BixPKRoZGZ9Zbd7Rg6oMgSFlrXfWKhVhcgFetxDvM/Fo1ugQGL/8Z4y0sji5rs7fMEp9AB
	M7kdpvU0Cp2w/4tihtU9TxIbCbwTFDeTUkvgh32HbBHaSzT42DcCydNrWXYgVNpU7MEZ0E
	BxStjuizXW/3Bxthrx3fjyErTjhFwm4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-Xs2rac5DPU6ptFd-CERq-w-1; Wed, 24 May 2023 00:50:38 -0400
X-MC-Unique: Xs2rac5DPU6ptFd-CERq-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DE273800EA1;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E0FE9E68;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 158A019465A8;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D872219465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 09:34:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6C289D7A; Tue, 23 May 2023 09:34:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE5C89D73
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:34:12 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87A293C13A0C
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:34:12 +0000 (UTC)
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net
 [217.70.183.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-2oygsCvwPvCafxkCOBuvzg-1; Tue, 23 May 2023 05:34:10 -0400
X-MC-Unique: 2oygsCvwPvCafxkCOBuvzg-1
Received: (Authenticated sender: miquel.raynal@bootlin.com)
 by mail.gandi.net (Postfix) with ESMTPSA id 9C42B1C000B;
 Tue, 23 May 2023 09:34:03 +0000 (UTC)
Date: Tue, 23 May 2023 11:34:02 +0200
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20230523113402.32fa86ba@xps-13>
In-Reply-To: <20230523074535.249802-24-hch@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-24-hch@lst.de>
Organization: Bootlin
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 24 May 2023 04:50:30 +0000
Subject: Re: [dm-devel] [PATCH 23/24] mtd: block2mtd: don't call
 early_lookup_bdev after the system is running
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-mtd@lists.infradead.org, Pavel Machek <pavel@ucw.cz>,
 Richard Weinberger <richard@nod.at>, Joern Engel <joern@lazybastard.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bootlin.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQ2hyaXN0b3BoLAoKaGNoQGxzdC5kZSB3cm90ZSBvbiBUdWUsIDIzIE1heSAyMDIzIDA5OjQ1
OjM0ICswMjAwOgoKPiBlYXJseV9sb29rdXBfYmRldiBpcyBzdXBwb3NlZCB0byBvbmx5IGJlIGNh
bGxlZCBmcm9tIHRoZSBlYXJseSBib290Cj4gY29kZSwgYnV0IG1kdGJsb2NrX2Vhcmx5X2dldF9i
ZGV2IGlzIGNhbGxlZCBhcyBhIGdlbmVyYWwgZmFsbGJhY2sgd2hlbgo+IGxvb2t1cF9iZGV2IGZh
aWxzLCB3aGljaCBpcyBwcm9ibGVtYXRpYyBiZWNhdXNlIGVhcmx5X2xvb2t1cF9iZGV2Cj4gYnlw
YXNzZXMgYWxsIG5vcm1hbCBwYXRoIGJhc2VkIHBlcm1pc3Npb24gY2hlY2tpbmcsIGFuZCBtaWdo
dCBjYXVzZQo+IHByb2JsZW1zIHdpdGggY2VydGFpbiBjb250YWluZXIgZW52aXJvbm1lbnRzIHJl
bmFtaW5nIGRldmljZXMuCj4gCj4gU3dpdGNoIHRvIG9ubHkgY2FsbCBlYXJseV9sb29rdXBfYmRl
diB3aGVuIGRtIGlzIGJ1aWx0LWluIGFuZCB0aGUgc3lzdGVtCj4gc3RhdGUgaW4gbm90IHJ1bm5p
bmcgeWV0Lgo+IAo+IE5vdGUgdGhhdCB0aGlzIHN0cmljdGx5IHNwZWFraW5nIGNoYW5nZXMgdGhl
IGtlcm5lbCBBQkkgYXMgdGhlIFBBUlRVVUlEPQo+IGFuZCBQQVJUTEFCRUw9IHN0eWxlIHN5bnRh
eCBpcyBub3cgbm90IGF2YWlsYWJsZSBkdXJpbmcgYSBydW5uaW5nCj4gc3lzdGVtcy4gIFRoZXkg
bmV2ZXIgd2VyZSBpbnRlbmRlZCBmb3IgdGhhdCwgYnV0IHRoaXMgYnJlYWtzIHRoaW5ncwo+IHdl
J2xsIGhhdmUgdG8gZmlndXJlIG91dCBhIHdheSB0byBtYWtlIHRoZW0gYXZhaWxhYmxlIGFnYWlu
LiAgQnV0IGlmCj4gYXZvaWRhYmxlIGluIGFueSB3YXkgSSdkIHJhdGhlciBhdm9pZCB0aGF0LgoK
U291bmRzIHJlYXNvbmFibGUgdG8gbWUuIFJpY2hhcmQ/CgpSZXZpZXdlZC1ieTogTWlxdWVsIFJh
eW5hbCA8bWlxdWVsLnJheW5hbEBib290bGluLmNvbT4KClRoYW5rcywKTWlxdcOobAoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=


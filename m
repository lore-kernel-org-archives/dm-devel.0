Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 796BFC77B7C
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684903839;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eSSP5rRKD8HWYS8FoPdKQXGp4JyJNDNyH5cawXjdFnw=;
	b=DtEBYRzpgNcjhlNMslvZGA80ubQY84SXVH581lRmBT0Sif8xTRabEPHNH70utcRK6z5eQW
	clk17Ess0AoFw6wufMtCqsgS8omJXhXA5WVAereeDkJx3GmqLlp7X/OszsB8D2cLtgtinz
	53dJ795iGBqTa2tLedf5u5CE1fz2y/o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-NYyJkAUqP9WTjsUL8xilYg-1; Wed, 24 May 2023 00:50:37 -0400
X-MC-Unique: NYyJkAUqP9WTjsUL8xilYg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A1AC3800E91;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57DFB400DFF;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3B87919465BD;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9EE5619465B1
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 10:00:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 890B4C164EE; Tue, 23 May 2023 10:00:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8178DC1ED9C
 for <dm-devel@redhat.com>; Tue, 23 May 2023 10:00:20 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 643A42A59575
 for <dm-devel@redhat.com>; Tue, 23 May 2023 10:00:20 +0000 (UTC)
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net
 [217.70.178.240]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-oMRQI9S1PPmcxza8Zwi5Qg-1; Tue, 23 May 2023 06:00:18 -0400
X-MC-Unique: oMRQI9S1PPmcxza8Zwi5Qg-1
Received: from relay8-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::228])
 by mslow1.mail.gandi.net (Postfix) with ESMTP id C8723CFDAA
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:32:46 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
 by mail.gandi.net (Postfix) with ESMTPSA id 692C81BF208;
 Tue, 23 May 2023 09:32:37 +0000 (UTC)
Date: Tue, 23 May 2023 11:32:36 +0200
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20230523113236.7003c303@xps-13>
In-Reply-To: <20230523074535.249802-23-hch@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-23-hch@lst.de>
Organization: Bootlin
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 24 May 2023 04:50:30 +0000
Subject: Re: [dm-devel] [PATCH 22/24] mtd: block2mtd: factor the early block
 device open logic into a helper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bootlin.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQ2hyaXN0b3BoLAoKaGNoQGxzdC5kZSB3cm90ZSBvbiBUdWUsIDIzIE1heSAyMDIzIDA5OjQ1
OjMzICswMjAwOgoKPiBTaW1wbHkgYWRkX2RldmljZSBhIGJpdCBieSBzcGxpdHRpbmcgb3V0IHRo
ZSBjdW1iZXJzb21lIGVhcmx5IGJvb3QgbG9naWMKCkkgZ3Vlc3MgeW91IG1lYW50ICJTaW1wbGlm
eS4uLiIKCk90aGVyd2lzZSBsZ3RtIHNvLAoKUmV2aWV3ZWQtYnk6IE1pcXVlbCBSYXluYWwgPG1p
cXVlbC5yYXluYWxAYm9vdGxpbi5jb20+Cgo+IGludG8gYSBzZXBhcmF0ZSBoZWxwZXIuCj4gCj4g
U2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gIGRy
aXZlcnMvbXRkL2RldmljZXMvYmxvY2sybXRkLmMgfCA1MyArKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDIzIGRlbGV0
aW9ucygtKQo+IAoKVGhhbmtzLApNaXF1w6hsCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==


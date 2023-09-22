Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6ACCD4853
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695666970;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QIYD8Z55MtIN6v/zRK7ZY3AjRdY2aqxXhnmYY0JlblM=;
	b=Df/0nIRo/3v1vGwA3YKWfK/NvTWJHO42V3H7CTX/IMDRsP9scrF5OAsdCPm9qMNls9Pl1O
	OpOdijCrvWoUoo7GoxzadpnLq027TjSbVhnk3C+QJZnlYd48b7Heo/v9ZOix9n/jQbLyhT
	MP4t9EsS3Fgyb38xzBwLSWwzN/3Gs8E=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-MTar0_XnNM2hncQfvfXjIA-1; Mon, 25 Sep 2023 14:36:06 -0400
X-MC-Unique: MTar0_XnNM2hncQfvfXjIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCD283C23FD0;
	Mon, 25 Sep 2023 18:36:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 749621005E22;
	Mon, 25 Sep 2023 18:36:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 317D7194658F;
	Mon, 25 Sep 2023 18:36:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D53C41946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Sep 2023 10:03:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A4E828FD; Fri, 22 Sep 2023 10:03:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 81D4D51E3
 for <dm-devel@redhat.com>; Fri, 22 Sep 2023 10:03:19 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B51F800B35
 for <dm-devel@redhat.com>; Fri, 22 Sep 2023 10:03:19 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-pbZMj2nSNvmGngFlWcM2Hg-1; Fri, 22 Sep 2023 06:03:17 -0400
X-MC-Unique: pbZMj2nSNvmGngFlWcM2Hg-1
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230922095652epoutp032cb4be4c1484d7bd54ae2c4dec19e3b7~HMAveDwmJ1692816928epoutp03X
 for <dm-devel@redhat.com>; Fri, 22 Sep 2023 09:56:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230922095652epoutp032cb4be4c1484d7bd54ae2c4dec19e3b7~HMAveDwmJ1692816928epoutp03X
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas2p3.samsung.com (KnoxPortal) with ESMTP id
 20230922095651epcas2p371b9f8536ade2eb286cce8ce27fba03b~HMAu4pkhP2974629746epcas2p3s;
 Fri, 22 Sep 2023 09:56:51 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.102]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4RsSNM094nz4x9Pr; Fri, 22 Sep
 2023 09:56:51 +0000 (GMT)
X-AuditID: b6c32a45-84fff700000025dd-4b-650d64e25f49
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
 epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
 55.37.09693.2E46D056; Fri, 22 Sep 2023 18:56:50 +0900 (KST)
Mime-Version: 1.0
From: Jinyoung Choi <j-young.choi@samsung.com>
To: Nitesh Jagadeesh Shetty <nj.shetty@samsung.com>, Jens Axboe
 <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, "dm-devel@redhat.com"
 <dm-devel@redhat.com>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20230920080756.11919-4-nj.shetty@samsung.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230922095650epcms2p8e25340eff5de01f8b3ce63ae81266881@epcms2p8>
Date: Fri, 22 Sep 2023 18:56:50 +0900
X-CMS-MailID: 20230922095650epcms2p8e25340eff5de01f8b3ce63ae81266881
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA22Ta0xTZxjHc3ra00IsORQcr7Bs5DgRMJS2ofAil5gJy4lzGYrJLsR0R3pW
 GNA2PcUpLhHYrNCNy6iTURgXYTDAISBjlQJhxVGBOcIIOiAS3Wg2QSgXiSgBR2mZ+7Bvv/fJ
 //k/lzcPDxXoub68VKWW1iipdAJzZ3f2B4WH/CHn0yJrF4TXhgZQuLS6zoa5xRsobL5XhMG5
 /mUEzvRdROBDSxDsWSjnwIm+GyzYfaWEBRubf2bBEssdBNrGjSzYM3kA1ujq2LC7Z5ANx7oq
 MFhVb+PCz++aMNhg3WTB34ttCDTN5CCwc70KhS1zdja8NekHRzasnEO+5A3jPS45Mt3GJsdu
 Z5LtTfkYeb3uPGmeyMbI2kIDhyz4dAEjl2yTbNLeO46RhR1NCHl9+By50v4K2T4zz0rweD8t
 OoWm5LTGn1Ymq+SpSkUM8Wai7LBMGi4Sh4gjYQThr6Qy6Bgi7mhCyBup6VvLIPxPU+mZW6EE
 imGI0NhojSpTS/unqBhtDEGr5enqCLWQoTKYTKVCqKS1B8UikUS6JfwgLaWodI6rno47o88b
 5WQjta/rETcewMPAYncrV4+48wS4CQG5hfcRPcLj8XFPsGHycqAXHgsqqw475AKcAL9eNSIO
 9sJF4LMpHdvBGC4Epr/M2zbe+DAKTM8fII4HivdwQPWGne0sxgdfX7S52A/82PDDtpMbHgXW
 Sq2oMx4I1uoLXLwbTDTPc3fYPlCFONkbXJi+7dJ4gvtPza74HmCxrGKOpgGuAq19x5zhT4Du
 md0lDwV38tq2W+Djb4Gcsufb9mx8H2h7tOKyiQNfNZdgDkbxA6C+Zg51WKJ4ELjWFep03wtu
 TrKdCg+Q17/B3Rkwu239f9lUOcNypgaAK7mSYmSv8cWajf8pZXxRqhpBm5CXaDWToaAZiVr8
 788mqzLake2jCI43IYb5RaEFYfEQCwJ4KOHNT152pwV8OXU2i9aoZJrMdJqxINKtIb9EfXcn
 q7auSqmVicMiRWHh4eIIiVQUQfjwpy98IxfgCkpLp9G0mtbs5LF4br7ZrEZjUfWg9SOiu8zc
 /Lc0UByQu0/22qODQvukuXGso8YeLD9ESQQFDZLCvE2wyGHOTYU84L2dOOT3pzw+VtA7eCtm
 UGmdX+Lm363dP3K2zDx7LPvmkRVdwBf5c1cvH/fzpIKwZ2ZlFH3peKUpcXgpqSZrWRPwTgeV
 lfPx0ae9JwMfDi1UDIeM5H7Poipap46cXPuuL3YxavXDYVXOmXKV3vBY8W18S+ryu/sFv5mD
 LKuEz2inrPGxTjkbV81rGmd8PPimU+LRutU9vF3mYtv5n05Flr682VLenTb7HjepbJd03LLi
 mdD7pF14ukpxIskw0NQVHWiY/0WXZXhyQrX46mWCzaRQ4mBUw1D/AFH2eOKdBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081447epcas5p144e631c5b8c72acf64d38b04d6c2c925
References: <20230920080756.11919-4-nj.shetty@samsung.com>
 <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081447epcas5p144e631c5b8c72acf64d38b04d6c2c925@epcms2p8>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 25 Sep 2023 18:36:03 +0000
Subject: Re: [dm-devel] [PATCH v16 03/12] block: add copy offload support
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
Reply-To: j-young.choi@samsung.com
Cc: "anuj1072538@gmail.com" <anuj1072538@gmail.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 SSDR Gost Dev <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Anuj Gupta <anuj20.g@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 1
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiArLyoKPiArICogVGhpcyBtdXN0IG9ubHkgYmUgY2FsbGVkIG9uY2UgYWxsIGJpb3MgaGF2ZSBi
ZWVuIGlzc3VlZCBzbyB0aGF0IHRoZSByZWZjb3VudAo+ICsgKiBjYW4gb25seSBkZWNyZWFzZS4g
VGhpcyBqdXN0IHdhaXRzIGZvciBhbGwgYmlvcyB0byBjb21wbGV0ZS4KPiArICogUmV0dXJucyB0
aGUgbGVuZ3RoIG9mIGJ5dGVzIGNvcGllZCBvciBlcnJvcgo+ICsgKi8KPiArc3RhdGljIHNzaXpl
X3QgYmxrZGV2X2NvcHlfd2FpdF9pb19jb21wbGV0aW9uKHN0cnVjdCBibGtkZXZfY29weV9pbyAq
Y2lvKQoKSGksIE5pdGVzaCwKCmRvbid0IGZ1bmN0aW9ucyB3YWl0aW5nIGZvciBjb21wbGV0aW9u
IHVzdWFsbHkgc2V0IHRoZWlyIG5hbWVzIHRvICd3YWl0X2Zvcl9jb21wbGV0aW9uXyc/CihlLmcu
IGJsa2Rldl9jb3B5X3dhaXRfZm9yX2NvbXBsZXRpb25faW8pCgoKPiArc3NpemVfdCBibGtkZXZf
Y29weV9vZmZsb2FkKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGxvZmZfdCBwb3NfaW4sCj4g
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGxvZmZfdCBwb3Nfb3V0
LCBzaXplX3QgbGVuLAo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCB2b2lkICgqZW5kaW8pKHZvaWQgKiwgaW50LCBzc2l6ZV90KSwKPiArwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgdm9pZCAqcHJpdmF0ZSwgZ2ZwX3QgZ2ZwKQo+ICt7
Cj4gK8KgIMKgIMKgIMKgIHN0cnVjdCBibGtkZXZfY29weV9pbyAqY2lvOwo+ICvCoCDCoCDCoCDC
oCBzdHJ1Y3QgYmxrZGV2X2NvcHlfb2ZmbG9hZF9pbyAqb2ZmbG9hZF9pbzsKPiArwqAgwqAgwqAg
wqAgc3RydWN0IGJpbyAqc3JjX2JpbywgKmRzdF9iaW87Cj4gK8KgIMKgIMKgIMKgIHNzaXplX3Qg
cmVtLCBjaHVuaywgcmV0Owo+ICvCoCDCoCDCoCDCoCBzc2l6ZV90IG1heF9jb3B5X2J5dGVzID0g
YmRldl9tYXhfY29weV9zZWN0b3JzKGJkZXYpIDw8IFNFQ1RPUl9TSElGVDsKCndvdWxkbid0IGl0
IGJlIGJldHRlciB0byB1c2Ugc2l6ZV90IGZvciB2YXJpYWJsZXMgdGhhdCBkb24ndCByZXR1cm4/
CnZhbHVlcyBzdWNoIGFzIGNodW5rIGFuZCBtYXhfY29weV9ieXRlcyBtYXkgYmUgZGVmaW5lZCBh
cyAndW5zaWduZWQnLgoKPiArwqAgwqAgwqAgwqAgc3RydWN0IGJsa19wbHVnIHBsdWc7Cj4gKwo+
ICvCoCDCoCDCoCDCoCBpZiAoIW1heF9jb3B5X2J5dGVzKQo+ICvCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCByZXR1cm4gLUVPUE5PVFNVUFA7Cj4gKwo+ICvCoCDCoCDCoCDCoCByZXQgPSBibGtkZXZf
Y29weV9zYW5pdHlfY2hlY2soYmRldiwgcG9zX2luLCBiZGV2LCBwb3Nfb3V0LCBsZW4pOwo+ICvC
oCDCoCDCoCDCoCBpZiAocmV0KQo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gcmV0
Owo+ICsKPiArwqAgwqAgwqAgwqAgY2lvID0ga3phbGxvYyhzaXplb2YoKmNpbyksIEdGUF9LRVJO
RUwpOwo+ICvCoCDCoCDCoCDCoCBpZiAoIWNpbykKPiArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
cmV0dXJuIC1FTk9NRU07Cj4gK8KgIMKgIMKgIMKgIGF0b21pY19zZXQoJmNpby0+cmVmY291bnQs
IDEpOwo+ICvCoCDCoCDCoCDCoCBjaW8tPndhaXRlciA9IGN1cnJlbnQ7Cj4gK8KgIMKgIMKgIMKg
IGNpby0+ZW5kaW8gPSBlbmRpbzsKPiArwqAgwqAgwqAgwqAgY2lvLT5wcml2YXRlID0gcHJpdmF0
ZTsKPiArCj4gK8KgIMKgIMKgIMKgIC8qCj4gK8KgIMKgIMKgIMKgIMKgKiBJZiB0aGVyZSBpcyBh
IGVycm9yLCBjb3BpZWQgd2lsbCBiZSBzZXQgdG8gbGVhc3Qgc3VjY2Vzc2Z1bGx5Cj4gK8KgIMKg
IMKgIMKgIMKgKiBjb21wbGV0ZWQgY29waWVkIGxlbmd0aAo+ICvCoCDCoCDCoCDCoCDCoCovCj4g
K8KgIMKgIMKgIMKgIGNpby0+Y29waWVkID0gbGVuOwo+ICvCoCDCoCDCoCDCoCBmb3IgKHJlbSA9
IGxlbjsgcmVtID4gMDsgcmVtIC09IGNodW5rKSB7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGNodW5rID0gbWluKHJlbSwgbWF4X2NvcHlfYnl0ZXMpOwo+ICsKPiArwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgb2ZmbG9hZF9pbyA9IGt6YWxsb2Moc2l6ZW9mKCpvZmZsb2FkX2lvKSwgR0ZQX0tF
Uk5FTCk7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmICghb2ZmbG9hZF9pbykKPiArwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZ290byBlcnJfZnJlZV9jaW87Cj4gK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIG9mZmxvYWRfaW8tPmNpbyA9IGNpbzsKPiArwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgLyoKPiArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqIEZvciBwYXJ0
aWFsIGNvbXBsZXRpb24sIHdlIHVzZSBvZmZsb2FkX2lvLT5vZmZzZXQgdG8gdHJ1bmNhdGUKPiAr
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqIHN1Y2Nlc3NmdWwgY29weSBsZW5ndGgKPiArwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAqLwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBvZmZs
b2FkX2lvLT5vZmZzZXQgPSBsZW4gLSByZW07Cj4gKwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBzcmNfYmlvID0gYmlvX2FsbG9jKGJkZXYsIDAsIFJFUV9PUF9DT1BZX1NSQywgZ2ZwKTsKPiAr
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKCFzcmNfYmlvKQo+ICvCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIGVycl9mcmVlX29mZmxvYWRfaW87Cj4gK8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIHNyY19iaW8tPmJpX2l0ZXIuYmlfc2l6ZSA9IGNodW5rOwo+ICvCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCBzcmNfYmlvLT5iaV9pdGVyLmJpX3NlY3RvciA9IHBvc19pbiA+
PiBTRUNUT1JfU0hJRlQ7Cj4gKwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBibGtfc3RhcnRf
cGx1ZygmcGx1Zyk7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGRzdF9iaW8gPSBibGtfbmV4
dF9iaW8oc3JjX2JpbywgYmRldiwgMCwgUkVRX09QX0NPUFlfRFNULCBnZnApOwo+ICvCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBpZiAoIWRzdF9iaW8pCj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGdvdG8gZXJyX2ZyZWVfc3JjX2JpbzsKPiArwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgZHN0X2Jpby0+YmlfaXRlci5iaV9zaXplID0gY2h1bms7Cj4gK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIGRzdF9iaW8tPmJpX2l0ZXIuYmlfc2VjdG9yID0gcG9zX291dCA+PiBTRUNUT1Jf
U0hJRlQ7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGRzdF9iaW8tPmJpX2VuZF9pbyA9IGJs
a2Rldl9jb3B5X29mZmxvYWRfZHN0X2VuZGlvOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBk
c3RfYmlvLT5iaV9wcml2YXRlID0gb2ZmbG9hZF9pbzsKPiArCj4gK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIGF0b21pY19pbmMoJmNpby0+cmVmY291bnQpOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBzdWJtaXRfYmlvKGRzdF9iaW8pOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBibGtf
ZmluaXNoX3BsdWcoJnBsdWcpOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwb3NfaW4gKz0g
Y2h1bms7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHBvc19vdXQgKz0gY2h1bms7Cj4gK8Kg
IMKgIMKgIMKgIH0KPiArCj4gK8KgIMKgIMKgIMKgIGlmIChhdG9taWNfZGVjX2FuZF90ZXN0KCZj
aW8tPnJlZmNvdW50KSkKPiArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmxrZGV2X2NvcHlfZW5k
aW8oY2lvKTsKPiArwqAgwqAgwqAgwqAgaWYgKGNpby0+ZW5kaW8pCgpJc24ndCBpdCBhIHByb2Js
ZW0gaWYgdGhlIG1lbW9yeSBvZiBjaW8gaXMgcmVsZWFzZWQgaW4gYmxrZGV2X2NvcHlfZW5kaW8o
KT8KSXQgaXMgdW5saWtlbHkgdG8gb2NjdXIgaWYgdGhlcmUgaXMgYW4gaW5mbGlnaHQgaS9vIGVh
cmxpZXIsCml0IHdvdWxkIGJlIG5pY2UgdG8gbW9kaWZ5IGNvbnNpZGVyaW5nIGNvZGUgZmxvdy4K
Cgo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXR1cm4gLUVJT0NCUVVFVUVEOwo+ICsKPiAr
wqAgwqAgwqAgwqAgcmV0dXJuIGJsa2Rldl9jb3B5X3dhaXRfaW9fY29tcGxldGlvbihjaW8pOwo+
ICsKPiArZXJyX2ZyZWVfc3JjX2JpbzoKPiArwqAgwqAgwqAgwqAgYmlvX3B1dChzcmNfYmlvKTsK
PiArZXJyX2ZyZWVfb2ZmbG9hZF9pbzoKPiArwqAgwqAgwqAgwqAga2ZyZWUob2ZmbG9hZF9pbyk7
Cj4gK2Vycl9mcmVlX2NpbzoKPiArwqAgwqAgwqAgwqAgY2lvLT5jb3BpZWQgPSBtaW5fdChzc2l6
ZV90LCBjaW8tPmNvcGllZCwgKGxlbiAtIHJlbSkpOwo+ICvCoCDCoCDCoCDCoCBjaW8tPnN0YXR1
cyA9IC1FTk9NRU07Cj4gK8KgIMKgIMKgIMKgIGlmIChyZW0gPT0gbGVuKSB7Cj4gK8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIGtmcmVlKGNpbyk7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJl
dHVybiBjaW8tPnN0YXR1czsKCmlzbid0IGl0IGEgcHJvYmxlbSBpZiB0aGUgbWVtb3J5IG9mIGNp
byBpcyByZWxlYXNlZD8KCkJlc3QgUmVnYXJkcywKSmlueW91bmcuCgoKCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK


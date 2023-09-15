Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B45ACD37AD
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 22:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694817848;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z3kGkkFNBP5QisPLoWSIq0SBPLMci++cSKDje8gMss0=;
	b=LZoSB2Dm4JEN9S90/P5DwijM/8EhUwMpEYd7vju7ysM1/c96K2/R2+djWIa70zeralUiRK
	Cw+g+K4U4w+0YHg50U+aC9Dll/ZJ+O9ANwOTiWtkki9FozgF7BFEUnAa11ZHGtmpcNbbvV
	U1kcewe79R7GioEQ4/oarKVRnOMZAlI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-TnSe8ul4OIeCYYAUZmnGBw-1; Fri, 15 Sep 2023 18:44:04 -0400
X-MC-Unique: TnSe8ul4OIeCYYAUZmnGBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6900C82A6C0;
	Fri, 15 Sep 2023 22:44:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54E481054FC3;
	Fri, 15 Sep 2023 22:44:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3FD64194658F;
	Fri, 15 Sep 2023 22:44:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 863AC1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 22:43:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59ACB1CBC1; Fri, 15 Sep 2023 22:43:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51933176C3
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 22:43:50 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C3EA817053
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 22:43:50 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-3ezBNUmDOk28NJx_VREwTQ-1; Fri, 15 Sep 2023 18:43:47 -0400
X-MC-Unique: 3ezBNUmDOk28NJx_VREwTQ-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red
 Hat Linux)) id 1qhHXM-00BUtM-2g; Fri, 15 Sep 2023 22:43:44 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, hch@infradead.org, djwong@kernel.org,
 minchan@kernel.org, senozhatsky@chromium.org
Date: Fri, 15 Sep 2023 15:43:40 -0700
Message-Id: <20230915224343.2740317-2-mcgrof@kernel.org>
In-Reply-To: <20230915224343.2740317-1-mcgrof@kernel.org>
References: <20230915224343.2740317-1-mcgrof@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v3 1/4] drbd: use PAGE_SECTORS_SHIFT and
 PAGE_SECTORS
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
Cc: p.raghav@samsung.com, linux-xfs@vger.kernel.org, rohan.puri@samsung.com,
 da.gomez@samsung.com, mcgrof@kernel.org, patches@lists.linux.dev,
 willy@infradead.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-fsdevel@vger.kernel.org,
 rpuri.linux@gmail.com, kbusch@kernel.org, drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

UmVwbGFjZSBjb21tb24gY29uc3RhbnRzIHdpdGggZ2VuZXJpYyB2ZXJzaW9ucy4KVGhpcyBwcm9k
dWNlcyBubyBmdW5jdGlvbmFsIGNoYW5nZXMuCgpBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2Fs
ZGVyIDxjaHJpc3RvcGguYm9laG13YWxkZXJAbGluYml0LmNvbT4KUmV2aWV3ZWQtYnk6IEpvaGFu
bmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5jb20+ClNpZ25lZC1vZmYtYnk6
IEx1aXMgQ2hhbWJlcmxhaW4gPG1jZ3JvZkBrZXJuZWwub3JnPgotLS0KIGRyaXZlcnMvYmxvY2sv
ZHJiZC9kcmJkX2JpdG1hcC5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJk
X2JpdG1hcC5jIGIvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfYml0bWFwLmMKaW5kZXggODVjYTAw
MGEwNTY0Li4xYTE3ODJmNTVlNjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJk
X2JpdG1hcC5jCisrKyBiL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX2JpdG1hcC5jCkBAIC0xMDAw
LDcgKzEwMDAsNyBAQCBzdGF0aWMgdm9pZCBibV9wYWdlX2lvX2FzeW5jKHN0cnVjdCBkcmJkX2Jt
X2Fpb19jdHggKmN0eCwgaW50IHBhZ2VfbnIpIF9fbXVzdF9obwogCXVuc2lnbmVkIGludCBsZW47
CiAKIAlmaXJzdF9ibV9zZWN0ID0gZGV2aWNlLT5sZGV2LT5tZC5tZF9vZmZzZXQgKyBkZXZpY2Ut
PmxkZXYtPm1kLmJtX29mZnNldDsKLQlvbl9kaXNrX3NlY3RvciA9IGZpcnN0X2JtX3NlY3QgKyAo
KChzZWN0b3JfdClwYWdlX25yKSA8PCAoUEFHRV9TSElGVC1TRUNUT1JfU0hJRlQpKTsKKwlvbl9k
aXNrX3NlY3RvciA9IGZpcnN0X2JtX3NlY3QgKyAoKChzZWN0b3JfdClwYWdlX25yKSA8PCBQQUdF
X1NFQ1RPUlNfU0hJRlQpOwogCiAJLyogdGhpcyBtaWdodCBoYXBwZW4gd2l0aCB2ZXJ5IHNtYWxs
CiAJICogZmxleGlibGUgZXh0ZXJuYWwgbWV0YSBkYXRhIGRldmljZSwKQEAgLTEwMDgsNyArMTAw
OCw3IEBAIHN0YXRpYyB2b2lkIGJtX3BhZ2VfaW9fYXN5bmMoc3RydWN0IGRyYmRfYm1fYWlvX2N0
eCAqY3R4LCBpbnQgcGFnZV9ucikgX19tdXN0X2hvCiAJbGFzdF9ibV9zZWN0ID0gZHJiZF9tZF9s
YXN0X2JpdG1hcF9zZWN0b3IoZGV2aWNlLT5sZGV2KTsKIAlpZiAoZmlyc3RfYm1fc2VjdCA8PSBv
bl9kaXNrX3NlY3RvciAmJiBsYXN0X2JtX3NlY3QgPj0gb25fZGlza19zZWN0b3IpIHsKIAkJc2Vj
dG9yX3QgbGVuX3NlY3QgPSBsYXN0X2JtX3NlY3QgLSBvbl9kaXNrX3NlY3RvciArIDE7Ci0JCWlm
IChsZW5fc2VjdCA8IFBBR0VfU0laRS9TRUNUT1JfU0laRSkKKwkJaWYgKGxlbl9zZWN0IDwgUEFH
RV9TRUNUT1JTKQogCQkJbGVuID0gKHVuc2lnbmVkIGludClsZW5fc2VjdCpTRUNUT1JfU0laRTsK
IAkJZWxzZQogCQkJbGVuID0gUEFHRV9TSVpFOwotLSAKMi4zOS4yCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


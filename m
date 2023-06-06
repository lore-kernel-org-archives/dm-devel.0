Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B40B5C7EE29
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120546;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q8FWuGfP5mmZ5VLaPY5wqE8Wr8STbzDSpfMR5i3bsEU=;
	b=GcS/DxSfvlmjHQxcz01dXAxTzuQo4KFJrp2dohWpQ/sOSaBG6l3E8+BGAB0D2nSX9FiAxw
	iWLPpvDTPjAVdndV7+gnWH13Sri7Yv6PvqERPB/zpLIvJeGU8r+HgMJKp1rW8hVTQ1OEDz
	KUiHrmuvo7Kk3RRvvK5ip7OvtZK7RwI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-GoDftrANPoKQGRJK5zLG3Q-1; Wed, 07 Jun 2023 02:49:03 -0400
X-MC-Unique: GoDftrANPoKQGRJK5zLG3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C32EE85A5BE;
	Wed,  7 Jun 2023 06:49:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B24E0C1603B;
	Wed,  7 Jun 2023 06:49:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 937EB19452C7;
	Wed,  7 Jun 2023 06:49:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 161D11946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 08:24:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3EBA40D1B66; Tue,  6 Jun 2023 08:24:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EBD7B40D1B68
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 08:24:43 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BD088002BF
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 08:24:43 +0000 (UTC)
Received: from lithops.sigma-star.at (lithops.sigma-star.at
 [195.201.40.130]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-0mFHZez4PfmRV5VQvAYrKw-1; Tue, 06 Jun 2023 04:24:41 -0400
X-MC-Unique: 0mFHZez4PfmRV5VQvAYrKw-1
Received: from localhost (localhost [127.0.0.1])
 by lithops.sigma-star.at (Postfix) with ESMTP id A2DC56081100;
 Tue,  6 Jun 2023 10:24:39 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
 by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
 with ESMTP id siZzZpJorNJf; Tue,  6 Jun 2023 10:24:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
 by lithops.sigma-star.at (Postfix) with ESMTP id 34240616B2CF;
 Tue,  6 Jun 2023 10:24:39 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
 by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id YeogKuuY1hxw; Tue,  6 Jun 2023 10:24:39 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
 by lithops.sigma-star.at (Postfix) with ESMTP id E97466081100;
 Tue,  6 Jun 2023 10:24:38 +0200 (CEST)
Date: Tue, 6 Jun 2023 10:24:38 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: hch <hch@lst.de>
Message-ID: <318049918.3687133.1686039878761.JavaMail.zimbra@nod.at>
In-Reply-To: <20230606073950.225178-24-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-24-hch@lst.de>
MIME-Version: 1.0
X-Originating-IP: [195.201.40.130]
Thread-Topic: block: use a simple bool to track open for write
Thread-Index: X/xlpyhSf8bloXE5HNEoh3ox5Q1J9Q==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:49:00 +0000
Subject: Re: [dm-devel] [PATCH 23/31] mtd: block: use a simple bool to track
 open for write
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 linux-nvme <linux-nvme@lists.infradead.org>,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel <dm-devel@redhat.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs <linux-nilfs@vger.kernel.org>,
 linux-scsi <linux-scsi@vger.kernel.org>, linux-pm <linux-pm@vger.kernel.org>,
 linux-um <linux-um@lists.infradead.org>, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block <linux-block@vger.kernel.org>,
 linux-bcache <linux-bcache@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-mtd <linux-mtd@lists.infradead.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: nod.at
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

LS0tLS0gVXJzcHLDvG5nbGljaGUgTWFpbCAtLS0tLQo+IFZvbjogImhjaCIgPGhjaEBsc3QuZGU+
Cj4gSW5zdGVhZCBvZiBwcm9wYWdhdGluZyB0aGUgZm1vZGVfdCwganVzdCB1c2UgYSBib29sIHRv
IHRyYWNrIGlmIGEgbXRkCj4gYmxvY2sgZGV2aWNlIHdhcyBvcGVuZWQgZm9yIHdyaXRpbmcuCj4g
Cj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4g
ZHJpdmVycy9tdGQvbXRkX2Jsa2RldnMuYyAgICB8IDIgKy0KPiBkcml2ZXJzL210ZC9tdGRibG9j
ay5jICAgICAgIHwgMiArLQo+IGluY2x1ZGUvbGludXgvbXRkL2Jsa3RyYW5zLmggfCAyICstCj4g
MyBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4gCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbXRkL210ZF9ibGtkZXZzLmMgYi9kcml2ZXJzL210ZC9tdGRfYmxr
ZGV2cy5jCj4gaW5kZXggZjBiYjA5ZmRlOTVlM2EuLmJkMGI3NTQ1MzY0MzQ5IDEwMDY0NAo+IC0t
LSBhL2RyaXZlcnMvbXRkL210ZF9ibGtkZXZzLmMKPiArKysgYi9kcml2ZXJzL210ZC9tdGRfYmxr
ZGV2cy5jCj4gQEAgLTIwOCw3ICsyMDgsNyBAQCBzdGF0aWMgaW50IGJsa3RyYW5zX29wZW4oc3Ry
dWN0IGdlbmRpc2sgKmRpc2ssIGZtb2RlX3QgbW9kZSkKPiAJcmV0ID0gX19nZXRfbXRkX2Rldmlj
ZShkZXYtPm10ZCk7Cj4gCWlmIChyZXQpCj4gCQlnb3RvIGVycm9yX3JlbGVhc2U7Cj4gLQlkZXYt
PmZpbGVfbW9kZSA9IG1vZGU7Cj4gKwlkZXYtPndyaXRhYmxlID0gbW9kZSAmIEZNT0RFX1dSSVRF
Owo+IAo+IHVubG9jazoKPiAJZGV2LT5vcGVuKys7Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbXRk
L210ZGJsb2NrLmMgYi9kcml2ZXJzL210ZC9tdGRibG9jay5jCj4gaW5kZXggYTBhMTE5NGRjMWQ5
MDIuLmZhNDc2ZmI0ZGZmYjZjIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbXRkL210ZGJsb2NrLmMK
PiArKysgYi9kcml2ZXJzL210ZC9tdGRibG9jay5jCj4gQEAgLTI5NCw3ICsyOTQsNyBAQCBzdGF0
aWMgdm9pZCBtdGRibG9ja19yZWxlYXNlKHN0cnVjdCBtdGRfYmxrdHJhbnNfZGV2ICptYmQpCj4g
CQkgKiBJdCB3YXMgdGhlIGxhc3QgdXNhZ2UuIEZyZWUgdGhlIGNhY2hlLCBidXQgb25seSBzeW5j
IGlmCj4gCQkgKiBvcGVuZWQgZm9yIHdyaXRpbmcuCj4gCQkgKi8KPiAtCQlpZiAobWJkLT5maWxl
X21vZGUgJiBGTU9ERV9XUklURSkKPiArCQlpZiAobWJkLT53cml0YWJsZSkKPiAJCQltdGRfc3lu
YyhtYmQtPm10ZCk7Cj4gCQl2ZnJlZShtdGRibGstPmNhY2hlX2RhdGEpOwo+IAl9Cj4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvbXRkL2Jsa3RyYW5zLmggYi9pbmNsdWRlL2xpbnV4L210ZC9i
bGt0cmFucy5oCj4gaW5kZXggMTVjYzliOTVlMzJiNTIuLjZlNDcxNDM2YmJhNTU2IDEwMDY0NAo+
IC0tLSBhL2luY2x1ZGUvbGludXgvbXRkL2Jsa3RyYW5zLmgKPiArKysgYi9pbmNsdWRlL2xpbnV4
L210ZC9ibGt0cmFucy5oCj4gQEAgLTM0LDcgKzM0LDcgQEAgc3RydWN0IG10ZF9ibGt0cmFuc19k
ZXYgewo+IAlzdHJ1Y3QgYmxrX21xX3RhZ19zZXQgKnRhZ19zZXQ7Cj4gCXNwaW5sb2NrX3QgcXVl
dWVfbG9jazsKPiAJdm9pZCAqcHJpdjsKPiAtCWZtb2RlX3QgZmlsZV9tb2RlOwo+ICsJYm9vbCB3
cml0YWJsZTsKPiB9OwoKQWNrZWQtYnk6IFJpY2hhcmQgV2VpbmJlcmdlciA8cmljaGFyZEBub2Qu
YXQ+CgpUaGFua3MsCi8vcmljaGFyZAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbAo=


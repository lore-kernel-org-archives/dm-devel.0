Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE79AC77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 07:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685086456;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7d5oUS6sLa6outalDlp67Iqjq6em62IVCr4sMj7H2rg=;
	b=R8VX84kNbDmtfFbE1iYyAWIl065D9LQY1Ytt3ES/LLyQOF7MO60NtVSZn2ztS61UdPGOzX
	d2EeiZL4zVc+zH1GiVEvir5mZq760oZyYI5fNctgJy5QhKuQDhSQmTSJjO70i9mDWmRsjB
	N3HcNKtxlZtaTpTmuYoT5Kx4KbgQF/4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-SrVjOC9lO16KcOyBZVBz7Q-1; Fri, 26 May 2023 03:34:13 -0400
X-MC-Unique: SrVjOC9lO16KcOyBZVBz7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FD5F3803508;
	Fri, 26 May 2023 07:34:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D0E35C0004B;
	Fri, 26 May 2023 07:34:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CBA2419465A4;
	Fri, 26 May 2023 07:34:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50F5619465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 07:33:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98A4BC154D2; Fri, 26 May 2023 07:33:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F78EC154D1
 for <dm-devel@redhat.com>; Fri, 26 May 2023 07:33:47 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F31D811E8E
 for <dm-devel@redhat.com>; Fri, 26 May 2023 07:33:47 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-3l4FbPZCOg676_U7mr3Ujg-1; Fri, 26 May 2023 03:33:45 -0400
X-MC-Unique: 3l4FbPZCOg676_U7mr3Ujg-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red
 Hat Linux)) id 1q2RxB-001RdT-0G; Fri, 26 May 2023 07:33:37 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, hch@infradead.org, djwong@kernel.org,
 minchan@kernel.org, senozhatsky@chromium.org
Date: Fri, 26 May 2023 00:33:33 -0700
Message-Id: <20230526073336.344543-3-mcgrof@kernel.org>
In-Reply-To: <20230526073336.344543-1-mcgrof@kernel.org>
References: <20230526073336.344543-1-mcgrof@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 2/5] drbd: use PAGE_SECTORS_SHIFT and
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
 linux-mm@kvack.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 rpuri.linux@gmail.com, kbusch@kernel.org, drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

UmVwbGFjZSBjb21tb24gY29uc3RhbnRzIHdpdGggZ2VuZXJpYyB2ZXJzaW9ucy4KVGhpcyBwcm9k
dWNlcyBubyBmdW5jdGlvbmFsIGNoYW5nZXMuCgpBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2Fs
ZGVyIDxjaHJpc3RvcGguYm9laG13YWxkZXJAbGluYml0LmNvbT4KU2lnbmVkLW9mZi1ieTogTHVp
cyBDaGFtYmVybGFpbiA8bWNncm9mQGtlcm5lbC5vcmc+Ci0tLQogZHJpdmVycy9ibG9jay9kcmJk
L2RyYmRfYml0bWFwLmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfYml0
bWFwLmMgYi9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9iaXRtYXAuYwppbmRleCA2YWM4YzU0YjQ0
YzcuLmI1NTZlNjYzNGYxMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfYml0
bWFwLmMKKysrIGIvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfYml0bWFwLmMKQEAgLTEwMDAsNyAr
MTAwMCw3IEBAIHN0YXRpYyB2b2lkIGJtX3BhZ2VfaW9fYXN5bmMoc3RydWN0IGRyYmRfYm1fYWlv
X2N0eCAqY3R4LCBpbnQgcGFnZV9ucikgX19tdXN0X2hvCiAJdW5zaWduZWQgaW50IGxlbjsKIAog
CWZpcnN0X2JtX3NlY3QgPSBkZXZpY2UtPmxkZXYtPm1kLm1kX29mZnNldCArIGRldmljZS0+bGRl
di0+bWQuYm1fb2Zmc2V0OwotCW9uX2Rpc2tfc2VjdG9yID0gZmlyc3RfYm1fc2VjdCArICgoKHNl
Y3Rvcl90KXBhZ2VfbnIpIDw8IChQQUdFX1NISUZULVNFQ1RPUl9TSElGVCkpOworCW9uX2Rpc2tf
c2VjdG9yID0gZmlyc3RfYm1fc2VjdCArICgoKHNlY3Rvcl90KXBhZ2VfbnIpIDw8IFBBR0VfU0VD
VE9SU19TSElGVCk7CiAKIAkvKiB0aGlzIG1pZ2h0IGhhcHBlbiB3aXRoIHZlcnkgc21hbGwKIAkg
KiBmbGV4aWJsZSBleHRlcm5hbCBtZXRhIGRhdGEgZGV2aWNlLApAQCAtMTAwOCw3ICsxMDA4LDcg
QEAgc3RhdGljIHZvaWQgYm1fcGFnZV9pb19hc3luYyhzdHJ1Y3QgZHJiZF9ibV9haW9fY3R4ICpj
dHgsIGludCBwYWdlX25yKSBfX211c3RfaG8KIAlsYXN0X2JtX3NlY3QgPSBkcmJkX21kX2xhc3Rf
Yml0bWFwX3NlY3RvcihkZXZpY2UtPmxkZXYpOwogCWlmIChmaXJzdF9ibV9zZWN0IDw9IG9uX2Rp
c2tfc2VjdG9yICYmIGxhc3RfYm1fc2VjdCA+PSBvbl9kaXNrX3NlY3RvcikgewogCQlzZWN0b3Jf
dCBsZW5fc2VjdCA9IGxhc3RfYm1fc2VjdCAtIG9uX2Rpc2tfc2VjdG9yICsgMTsKLQkJaWYgKGxl
bl9zZWN0IDwgUEFHRV9TSVpFL1NFQ1RPUl9TSVpFKQorCQlpZiAobGVuX3NlY3QgPCBQQUdFX1NF
Q1RPUlMpCiAJCQlsZW4gPSAodW5zaWduZWQgaW50KWxlbl9zZWN0KlNFQ1RPUl9TSVpFOwogCQll
bHNlCiAJCQlsZW4gPSBQQUdFX1NJWkU7Ci0tIAoyLjM5LjIKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK


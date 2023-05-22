Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F5EC77B75
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 22:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684793433;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yBFA0/soahSalWtid5ZgMvQ8eNrkjGIyWkeO7S9hsDA=;
	b=AujGTSbBphQsyYTE9lWTrrOSEty24N5VM0q9aeViD0Vhiu3smhYSY0mdMYB7nlklWhpjt3
	UT+rhmvdSs5s7J/Ayd7PnqmYg3+3p4pteU4hkniRzDQfsZOCfFAc67QOycTFCM48oVaKFE
	iB5iIIhLv10DJviHFVLTUSj2YI0uCsk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-5Rs-Woc7OJKgZHf3wX8zNw-1; Mon, 22 May 2023 18:10:30 -0400
X-MC-Unique: 5Rs-Woc7OJKgZHf3wX8zNw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE25E3C02B96;
	Mon, 22 May 2023 22:10:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CC2E482060;
	Mon, 22 May 2023 22:10:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D4ECE19465A0;
	Mon, 22 May 2023 22:10:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 66AB11946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 22:10:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CFC94482062; Mon, 22 May 2023 22:10:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C7C05482060
 for <dm-devel@redhat.com>; Mon, 22 May 2023 22:10:14 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A76BB1C0419B
 for <dm-devel@redhat.com>; Mon, 22 May 2023 22:10:14 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-wyMxxV6eOumIAq6FWmkIvA-1; Mon, 22 May 2023 18:10:05 -0400
X-MC-Unique: wyMxxV6eOumIAq6FWmkIvA-1
Received: by mail-pf1-f172.google.com with SMTP id
 d2e1a72fcca58-64d426e63baso3552978b3a.0
 for <dm-devel@redhat.com>; Mon, 22 May 2023 15:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684793404; x=1687385404;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Zhk/FFw49fszGKvEVhYvbvMP+dTpGvDn5zl+3/9L1Dc=;
 b=DZG498S/J4aWC/2A79S5TKGQIGGhNnYbkkOhwq7Iy1ZY8U6wq02VlSsQelakIctszl
 LOgY007X1F2HEDmQWSBseFB3DN7kPqmaS6A6eRuw3+YTqCL0s5yKPy1m9ZVqKmEUCn1Q
 M5XWkM0tTCJB6XvgkDHKYkHuVKuNQBVMIU09saIBnjmLcLDEdSmkTAR+SiZ+uf0EdcZc
 xrad8GLQK/d1FF55CMDOhZNDTFfS/dNhxkAzvQsCic9P9lrF7XgO2tnkAHzkNYNFP66r
 nBHgLidlXBQbZJ1aOu1ua2g7CbpVORSCBLDy58+I5kHQyIMMtD5SbtxlwxrsWiQt7Rvx
 eU6w==
X-Gm-Message-State: AC+VfDz6KTGXhF7H8hSORYuBQmehZ/E5LTqEgFmeVC5o+1ATMJM5cphN
 XNA6UtRf7HBJLtMpMaYVw2KNmUFLMlZCa8bJb0U=
X-Google-Smtp-Source: ACHHUZ5WRtvEBtYahpKG6aPeTI5eHL+V7B6L6O9jAUq/08MWwaaWRvizWzszQGPZBbFKrv/0tLK8Kg==
X-Received: by 2002:a17:902:ea0f:b0:1ad:c736:2090 with SMTP id
 s15-20020a170902ea0f00b001adc7362090mr14394226plg.3.1684793403998; 
 Mon, 22 May 2023 15:10:03 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:7ecd:bb34:d662:f45a])
 by smtp.gmail.com with UTF8SMTPSA id
 v4-20020a170902b7c400b001ab2b4105ddsm5308998plz.60.2023.05.22.15.10.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 22 May 2023 15:10:03 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Date: Mon, 22 May 2023 15:09:55 -0700
Message-ID: <20230522221000.603769-1-sarthakkukreti@chromium.org>
In-Reply-To: <20230522163710.GA11607@frogsfrogsfrogs>
References: <20230522163710.GA11607@frogsfrogsfrogs>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v7 5/5] loop: Add support for provision requests
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBNYXkgMjIsIDIwMjMgYXQgOTozN+KAr0FNIERhcnJpY2sgSi4gV29uZyA8ZGp3b25n
QGtlcm5lbC5vcmc+IHdyb3RlOgo+Cj4gSWYgc29tZW9uZSBjYWxscyBmYWxsb2NhdGUoVU5TSEFS
RV9SQU5HRSkgb24gYSBsb29wIGJkZXYsIHNob3VsZG4ndAo+IHRoZXJlIGJlIGEgd2F5IHRvIHBh
c3MgdGhhdCB0aHJvdWdoIHRvIHRoZSBmYWxsb2NhdGUgY2FsbCB0byB0aGUgYmFja2luZwo+IGZp
bGU/Cj4KPiAtLUQKPgoKWWVhaCwgSSB0aGluayB3ZSBjb3VsZCBhZGQgYSBSRVFfVU5TSEFSRSBi
aXQgKHNpbWlsYXIgdG8gUkVRX05PVU5NQVApIHRvIHBhc3MgZG93biB0aGUgaW50ZW50IHRvIHRo
ZSBiYWNraW5nIGZpbGUgKGFuZCBwb3NzaWJseSBiZXlvbmQuLi4pLgoKSSB0b29rIGEgc3RhYiBh
dCBpbXBsZW1lbnRpbmcgaXQgYXMgYSBmb2xsb3cgdXAgcGF0Y2ggc28gdGhhdCB0aGVyZSdzIGxl
c3MgcmV2aWV3IGNodXJuIG9uIHRoZSBjdXJyZW50IHNlcmllcy4gSWYgaXQgbG9va3MgZ29vZCwg
SSBjYW4gYWRkIGl0IHRvIHRoZSBlbmQgb2YgdGhlIHNlcmllcyAob3IgaW5jb3Jwb3JhdGUgdGhp
cyBpbnRvIHRoZSBleGlzdGluZyBibG9jayBhbmQgbG9vcCBwYXRjaGVzKToKCkZyb206IFNhcnRo
YWsgS3VrcmV0aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPgpEYXRlOiBNb24sIDIyIE1h
eSAyMDIzIDE0OjE4OjE1IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gYmxvY2s6IFBhc3MgdW5zaGFy
ZSBpbnRlbnQgdmlhIFJFUV9PUF9QUk9WSVNJT04KCkFsbG93IFJFUV9PUF9QUk9WSVNJT04gdG8g
cGFzcyBpbiBhbiBleHRyYSBSRVFfVU5TSEFSRSBiaXQgdG8KYW5ub3RhdGUgdW5zaGFyZSByZXF1
ZXN0cyB0byB1bmRlcmx5aW5nIGxheWVycy4gTGF5ZXJzIHRoYXQgc3VwcG9ydApGQUxMT0NfRkxf
VU5TSEFSRSB3aWxsIGJlIGFibGUgdG8gdXNlIHRoaXMgYXMgYW4gaW5kaWNhdG9yIG9mIHdoaWNo
CmZhbGxvY2F0ZSgpIG1vZGUgdG8gdXNlLgoKU2lnbmVkLW9mZi1ieTogU2FydGhhayBLdWtyZXRp
IDxzYXJ0aGFra3VrcmV0aUBjaHJvbWl1bS5vcmc+Ci0tLQogYmxvY2svYmxrLWxpYi5jICAgICAg
ICAgICB8ICA2ICsrKysrLQogYmxvY2svZm9wcy5jICAgICAgICAgICAgICB8ICA2ICsrKysrLQog
ZHJpdmVycy9ibG9jay9sb29wLmMgICAgICB8IDM1ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLS0tLS0tCiBpbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIHwgIDMgKysrCiBpbmNsdWRlL2xp
bnV4L2Jsa2Rldi5oICAgIHwgIDMgKystCiA1IGZpbGVzIGNoYW5nZWQsIDQ0IGluc2VydGlvbnMo
KyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLWxpYi5jIGIvYmxvY2sv
YmxrLWxpYi5jCmluZGV4IDNjZmY1ZmI2NTRmNS4uYmVhNmY1YTcwMGIzIDEwMDY0NAotLS0gYS9i
bG9jay9ibGstbGliLmMKKysrIGIvYmxvY2svYmxrLWxpYi5jCkBAIC0zNTAsNiArMzUwLDcgQEAg
RVhQT1JUX1NZTUJPTChibGtkZXZfaXNzdWVfc2VjdXJlX2VyYXNlKTsKICAqIEBzZWN0b3I6CXN0
YXJ0IHNlY3RvcgogICogQG5yX3NlY3RzOgludW1iZXIgb2Ygc2VjdG9ycyB0byBwcm92aXNpb24K
ICAqIEBnZnBfbWFzazoJbWVtb3J5IGFsbG9jYXRpb24gZmxhZ3MgKGZvciBiaW9fYWxsb2MpCisg
KiBAZmxhZ3M6CWNvbnRyb2xzIGRldGFpbGVkIGJlaGF2aW9yCiAgKgogICogRGVzY3JpcHRpb246
CiAgKiAgSXNzdWVzIGEgcHJvdmlzaW9uIHJlcXVlc3QgdG8gdGhlIGJsb2NrIGRldmljZSBmb3Ig
dGhlIHJhbmdlIG9mIHNlY3RvcnMuCkBAIC0zNTcsNyArMzU4LDcgQEAgRVhQT1JUX1NZTUJPTChi
bGtkZXZfaXNzdWVfc2VjdXJlX2VyYXNlKTsKICAqICB1bmRlcmx5aW5nIHN0b3JhZ2UgcG9vbCB0
byBhbGxvY2F0ZSBzcGFjZSBmb3IgdGhpcyBibG9jayByYW5nZS4KICAqLwogaW50IGJsa2Rldl9p
c3N1ZV9wcm92aXNpb24oc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgc2VjdG9yX3Qgc2VjdG9y
LAotCQlzZWN0b3JfdCBucl9zZWN0cywgZ2ZwX3QgZ2ZwKQorCQlzZWN0b3JfdCBucl9zZWN0cywg
Z2ZwX3QgZ2ZwLCB1bnNpZ25lZCBmbGFncykKIHsKIAlzZWN0b3JfdCBic19tYXNrID0gKGJkZXZf
bG9naWNhbF9ibG9ja19zaXplKGJkZXYpID4+IDkpIC0gMTsKIAl1bnNpZ25lZCBpbnQgbWF4X3Nl
Y3RvcnMgPSBiZGV2X21heF9wcm92aXNpb25fc2VjdG9ycyhiZGV2KTsKQEAgLTM4MCw2ICszODEs
OSBAQCBpbnQgYmxrZGV2X2lzc3VlX3Byb3Zpc2lvbihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2
LCBzZWN0b3JfdCBzZWN0b3IsCiAJCWJpby0+YmlfaXRlci5iaV9zZWN0b3IgPSBzZWN0b3I7CiAJ
CWJpby0+YmlfaXRlci5iaV9zaXplID0gcmVxX3NlY3RzIDw8IFNFQ1RPUl9TSElGVDsKIAorCQlp
ZiAoZmxhZ3MgJiBCTEtERVZfVU5TSEFSRV9SQU5HRSkKKwkJCWJpby0+Ymlfb3BmIHw9IFJFUV9V
TlNIQVJFOworCiAJCXNlY3RvciArPSByZXFfc2VjdHM7CiAJCW5yX3NlY3RzIC09IHJlcV9zZWN0
czsKIAkJaWYgKCFucl9zZWN0cykgewpkaWZmIC0tZ2l0IGEvYmxvY2svZm9wcy5jIGIvYmxvY2sv
Zm9wcy5jCmluZGV4IGJlMmU0MWYxNjBiZi4uNjg0ODc1NmYwNTU3IDEwMDY0NAotLS0gYS9ibG9j
ay9mb3BzLmMKKysrIGIvYmxvY2svZm9wcy5jCkBAIC02NTksNyArNjU5LDExIEBAIHN0YXRpYyBs
b25nIGJsa2Rldl9mYWxsb2NhdGUoc3RydWN0IGZpbGUgKmZpbGUsIGludCBtb2RlLCBsb2ZmX3Qg
c3RhcnQsCiAJY2FzZSBGQUxMT0NfRkxfS0VFUF9TSVpFOgogCWNhc2UgRkFMTE9DX0ZMX1VOU0hB
UkVfUkFOR0UgfCBGQUxMT0NfRkxfS0VFUF9TSVpFOgogCQllcnJvciA9IGJsa2Rldl9pc3N1ZV9w
cm92aXNpb24oYmRldiwgc3RhcnQgPj4gU0VDVE9SX1NISUZULAotCQkJCQkgICAgICAgbGVuID4+
IFNFQ1RPUl9TSElGVCwgR0ZQX0tFUk5FTCk7CisJCQkJCSAgICAgICBsZW4gPj4gU0VDVE9SX1NI
SUZULCBHRlBfS0VSTkVMLAorCQkJCQkgICAgICAgKG1vZGUgJgorCQkJCQkJRkFMTE9DX0ZMX1VO
U0hBUkVfUkFOR0UpID8KKwkJCQkJCSAgICAgICBCTEtERVZfVU5TSEFSRV9SQU5HRSA6CisJCQkJ
CQkgICAgICAgMCk7CiAJCWJyZWFrOwogCWNhc2UgRkFMTE9DX0ZMX1pFUk9fUkFOR0U6CiAJY2Fz
ZSBGQUxMT0NfRkxfWkVST19SQU5HRSB8IEZBTExPQ19GTF9LRUVQX1NJWkU6CmRpZmYgLS1naXQg
YS9kcml2ZXJzL2Jsb2NrL2xvb3AuYyBiL2RyaXZlcnMvYmxvY2svbG9vcC5jCmluZGV4IDdmZTFh
NjYyOTc1NC4uYzg0NGIxNDVkNjY2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jsb2NrL2xvb3AuYwor
KysgYi9kcml2ZXJzL2Jsb2NrL2xvb3AuYwpAQCAtMzA2LDYgKzMwNiwzMCBAQCBzdGF0aWMgaW50
IGxvX3JlYWRfc2ltcGxlKHN0cnVjdCBsb29wX2RldmljZSAqbG8sIHN0cnVjdCByZXF1ZXN0ICpy
cSwKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGJvb2wgdmFsaWRhdGVfZmFsbG9jYXRlX21vZGUo
c3RydWN0IGxvb3BfZGV2aWNlICpsbywgaW50IG1vZGUpCit7CisJYm9vbCByZXQgPSB0cnVlOwor
CisJc3dpdGNoIChtb2RlKSB7CisJY2FzZSBGQUxMT0NfRkxfUFVOQ0hfSE9MRToKKwljYXNlIEZB
TExPQ19GTF9aRVJPX1JBTkdFOgorCQlpZiAoIWJkZXZfbWF4X2Rpc2NhcmRfc2VjdG9ycyhsby0+
bG9fZGV2aWNlKSkKKwkJCXJldCA9IGZhbHNlOworCQlicmVhazsKKwljYXNlIDA6CisJY2FzZSBG
QUxMT0NfRkxfVU5TSEFSRV9SQU5HRToKKwkJaWYgKCFiZGV2X21heF9wcm92aXNpb25fc2VjdG9y
cyhsby0+bG9fZGV2aWNlKSkKKwkJCXJldCA9IGZhbHNlOworCQlicmVhazsKKworCWRlZmF1bHQ6
CisJCXJldCA9IGZhbHNlOworCX0KKworCXJldHVybiByZXQ7Cit9CisKKwogc3RhdGljIGludCBs
b19mYWxsb2NhdGUoc3RydWN0IGxvb3BfZGV2aWNlICpsbywgc3RydWN0IHJlcXVlc3QgKnJxLCBs
b2ZmX3QgcG9zLAogCQkJaW50IG1vZGUpCiB7CkBAIC0zMTYsMTEgKzM0MCw3IEBAIHN0YXRpYyBp
bnQgbG9fZmFsbG9jYXRlKHN0cnVjdCBsb29wX2RldmljZSAqbG8sIHN0cnVjdCByZXF1ZXN0ICpy
cSwgbG9mZl90IHBvcywKIAlzdHJ1Y3QgZmlsZSAqZmlsZSA9IGxvLT5sb19iYWNraW5nX2ZpbGU7
CiAJaW50IHJldDsKIAotCWlmIChtb2RlICYgKEZBTExPQ19GTF9QVU5DSF9IT0xFIHwgRkFMTE9D
X0ZMX1pFUk9fUkFOR0UpICYmCi0JICAgICFiZGV2X21heF9kaXNjYXJkX3NlY3RvcnMobG8tPmxv
X2RldmljZSkpCi0JCXJldHVybiAtRU9QTk9UU1VQUDsKLQotCWlmIChtb2RlID09IDAgJiYgIWJk
ZXZfbWF4X3Byb3Zpc2lvbl9zZWN0b3JzKGxvLT5sb19kZXZpY2UpKQorCWlmICghdmFsaWRhdGVf
ZmFsbG9jYXRlX21vZGUobG8sIG1vZGUpKQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7CiAKIAltb2Rl
IHw9IEZBTExPQ19GTF9LRUVQX1NJWkU7CkBAIC00OTMsNyArNTEzLDEwIEBAIHN0YXRpYyBpbnQg
ZG9fcmVxX2ZpbGViYWNrZWQoc3RydWN0IGxvb3BfZGV2aWNlICpsbywgc3RydWN0IHJlcXVlc3Qg
KnJxKQogCWNhc2UgUkVRX09QX0RJU0NBUkQ6CiAJCXJldHVybiBsb19mYWxsb2NhdGUobG8sIHJx
LCBwb3MsIEZBTExPQ19GTF9QVU5DSF9IT0xFKTsKIAljYXNlIFJFUV9PUF9QUk9WSVNJT046Ci0J
CXJldHVybiBsb19mYWxsb2NhdGUobG8sIHJxLCBwb3MsIDApOworCQlyZXR1cm4gbG9fZmFsbG9j
YXRlKGxvLCBycSwgcG9zLAorCQkJCSAgICAocnEtPmNtZF9mbGFncyAmIFJFUV9VTlNIQVJFKSA/
CisJCQkJCSAgICBGQUxMT0NfRkxfVU5TSEFSRV9SQU5HRSA6CisJCQkJCSAgICAwKTsKIAljYXNl
IFJFUV9PUF9XUklURToKIAkJaWYgKGNtZC0+dXNlX2FpbykKIAkJCXJldHVybiBsb19yd19haW8o
bG8sIGNtZCwgcG9zLCBJVEVSX1NPVVJDRSk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Js
a190eXBlcy5oIGIvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAppbmRleCBiN2JiMDIyNmZkZWUu
LjFhNTM2ZmQ4OTdjYiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAorKysg
Yi9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oCkBAIC00MjMsNiArNDIzLDggQEAgZW51bSByZXFf
ZmxhZ19iaXRzIHsKIAkgKi8KIAkvKiBmb3IgUkVRX09QX1dSSVRFX1pFUk9FUzogKi8KIAlfX1JF
UV9OT1VOTUFQLAkJLyogZG8gbm90IGZyZWUgYmxvY2tzIHdoZW4gemVyb2luZyAqLworCS8qIGZv
ciBSRVFfT1BfUFJPVklTSU9OOiAqLworCV9fUkVRX1VOU0hBUkUsCQkvKiB1bnNoYXJlIGJsb2Nr
cyAqLwogCiAJX19SRVFfTlJfQklUUywJCS8qIHN0b3BzIGhlcmUgKi8KIH07CkBAIC00NTEsNiAr
NDUzLDcgQEAgZW51bSByZXFfZmxhZ19iaXRzIHsKICNkZWZpbmUgUkVRX0ZTX1BSSVZBVEUJKF9f
Zm9yY2UgYmxrX29wZl90KSgxVUxMIDw8IF9fUkVRX0ZTX1BSSVZBVEUpCiAKICNkZWZpbmUgUkVR
X05PVU5NQVAJKF9fZm9yY2UgYmxrX29wZl90KSgxVUxMIDw8IF9fUkVRX05PVU5NQVApCisjZGVm
aW5lIFJFUV9VTlNIQVJFCShfX2ZvcmNlIGJsa19vcGZfdCkoMVVMTCA8PCBfX1JFUV9VTlNIQVJF
KQogCiAjZGVmaW5lIFJFUV9GQUlMRkFTVF9NQVNLIFwKIAkoUkVRX0ZBSUxGQVNUX0RFViB8IFJF
UV9GQUlMRkFTVF9UUkFOU1BPUlQgfCBSRVFfRkFJTEZBU1RfRFJJVkVSKQpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9ibGtkZXYuaCBiL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKaW5kZXggNDYy
Y2U1ODZkNDZmLi42MGMwOWIwZDNmYzkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvYmxrZGV2
LmgKKysrIGIvaW5jbHVkZS9saW51eC9ibGtkZXYuaApAQCAtMTA0OSwxMCArMTA0OSwxMSBAQCBp
bnQgYmxrZGV2X2lzc3VlX3NlY3VyZV9lcmFzZShzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBz
ZWN0b3JfdCBzZWN0b3IsCiAJCXNlY3Rvcl90IG5yX3NlY3RzLCBnZnBfdCBnZnApOwogCiBleHRl
cm4gaW50IGJsa2Rldl9pc3N1ZV9wcm92aXNpb24oc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwg
c2VjdG9yX3Qgc2VjdG9yLAotCQlzZWN0b3JfdCBucl9zZWN0cywgZ2ZwX3QgZ2ZwX21hc2spOwor
CQlzZWN0b3JfdCBucl9zZWN0cywgZ2ZwX3QgZ2ZwX21hc2ssIHVuc2lnbmVkIGludCBmbGFncyk7
CiAKICNkZWZpbmUgQkxLREVWX1pFUk9fTk9VTk1BUAkoMSA8PCAwKSAgLyogZG8gbm90IGZyZWUg
YmxvY2tzICovCiAjZGVmaW5lIEJMS0RFVl9aRVJPX05PRkFMTEJBQ0sJKDEgPDwgMSkgIC8qIGRv
bid0IHdyaXRlIGV4cGxpY2l0IHplcm9lcyAqLworI2RlZmluZSBCTEtERVZfVU5TSEFSRV9SQU5H
RQkoMSA8PCAyKSAgLyogdW5zaGFyZSByYW5nZSBvbiBwcm92aXNpb24gKi8KIAogZXh0ZXJuIGlu
dCBfX2Jsa2Rldl9pc3N1ZV96ZXJvb3V0KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHNlY3Rv
cl90IHNlY3RvciwKIAkJc2VjdG9yX3QgbnJfc2VjdHMsIGdmcF90IGdmcF9tYXNrLCBzdHJ1Y3Qg
YmlvICoqYmlvcCwKLS0gCjIuMzkuMgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbAo=


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B2AC54EBD
	for <dm-devel@archiver.kernel.org>; Thu, 12 Jan 2023 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673535543;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Wn4R9ZXoCS50X5v2rBVNow9aIkQ3WoZ47zuEJZ8SvV4=;
	b=E+qvJ2kB9o8tMqPZXaKyHBTHKI75TkKszmxG6DIt4NrwoDM66QChadYv4aq3gmdnb5jUqD
	Gi0dZRhP+ClOLoXl3gkrsioSk96qMG/zjN44Xzr7H0yJV4ZWsXdCQNszNJcviEkKlkgJSb
	tOQb4fO8NdiDEImzo1Jfrp8rkXHnOX4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-q1QQWb_nOLCqzZtvnAWLmQ-1; Thu, 12 Jan 2023 09:58:38 -0500
X-MC-Unique: q1QQWb_nOLCqzZtvnAWLmQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 720AB3815EE5;
	Thu, 12 Jan 2023 14:58:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5FC46492B00;
	Thu, 12 Jan 2023 14:58:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05132194704A;
	Thu, 12 Jan 2023 14:58:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D9B0D1946A78
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 Jan 2023 13:37:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC0DE4078905; Thu, 12 Jan 2023 13:37:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C413B4078904
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A557A1C0513E
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:23 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-velusuYmMBGQx82nSxwxtA-1; Thu, 12 Jan 2023 08:37:21 -0500
X-MC-Unique: velusuYmMBGQx82nSxwxtA-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230112133718epoutp029e04d31ecf753f666b7a571431f7dea8~5kz-Y1VX71977919779epoutp02e
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 13:37:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230112133718epoutp029e04d31ecf753f666b7a571431f7dea8~5kz-Y1VX71977919779epoutp02e
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230112133718epcas5p437bad450396846e909113f3d0d882a48~5kz_0tOX52984229842epcas5p4k;
 Thu, 12 Jan 2023 13:37:18 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Nt5FS5GFhz4x9Px; Thu, 12 Jan
 2023 13:37:16 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 21.66.03362.C0D00C36; Thu, 12 Jan 2023 22:37:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230112120131epcas5p4374e6add89990dd546bd0ae38f4386f0~5jgWZWF5v0983009830epcas5p4V;
 Thu, 12 Jan 2023 12:01:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230112120131epsmtrp2e60d5d391c6f729215e19237dc753b83~5jgWT-6i73008330083epsmtrp2h;
 Thu, 12 Jan 2023 12:01:31 +0000 (GMT)
X-AuditID: b6c32a4b-4e5fa70000010d22-d9-63c00d0c30b5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 89.33.10542.A96FFB36; Thu, 12 Jan 2023 21:01:31 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230112120128epsmtip2f6dd2b1d2e6ed1351ebe40f693614486~5jgTeUo3b0767707677epsmtip2c;
 Thu, 12 Jan 2023 12:01:27 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Date: Thu, 12 Jan 2023 17:28:58 +0530
Message-Id: <20230112115908.23662-5-nj.shetty@samsung.com>
In-Reply-To: <20230112115908.23662-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHPfeW21tCl0sROSLDeolbkACt9HFBGLiR7W7UrAmLSzQGu/ZC
 CaVt2oIPslksmoBB1IFKFZGXUR6y8RqvKtahAkE0PgZGhoOyGBU6eUwCMkcpbP73+f3O93t+
 j5ODo7x/MH88VWtiDFqFhsQ8WS03gz8O9eJ2KQUnyz6i6ntvodThE4soVTNcgFG2yXMe1FBX
 G0J1lp9CqCs13QjVUfYaocaeTrOp7ncTGHXK/hhQ44+sCGV7EkJ12npY1IP28xhVemmcTbU6
 sgHVslCKUtNVOWzq6ksni7rzZAM1sHjbI24dbR3px+g26zCbHvj9Zxb9oD+DbqjOxejGykN0
 x5AZo/MtkxjtvPYIo483VQO6sS+Lnm4IpBscE4icuystWs0oVIyBz2iVOlWqNiWGTEhM+ixJ
 LBEIQ4WRlJTkaxXpTAwZL5OHfp6qWRqa5GcqNBlLKbnCaCTDP4k26DJMDF+tM5piSEav0uhF
 +jCjIt2YoU0J0zKmKKFAsFW8JNybpq6+bkH0h4P2l5grWWZwKyAPcHBIiGDn2RkkD3jiPKID
 wOYLs5g7mAJwLP9PD3cwDaCt8Tyyahnv70XdB+0Anp4rZrsDCwK7RgZYeQDHMSIE9r3DXYa1
 xFMEtvUFuTQosYDAZzfngUvjQ8TAxrx0l4ZFbIaW7kIPF3OJKFj89o6HSwKJcFgw4u1Kc4ht
 sHZwhuWWeMOeYscyo8RGaGk+t9wPJCo4sL28DrgbjYeXnxeibvaBL243sd3sD6cnbZib98Er
 hZcxtzkHQOtv1hVzLDzSW4C6mkCJYFjfHu5OfwiLeq8i7sIfwPwFx8pSuLD1wioHwdr6iyv3
 r4eP32SvMA1zxhZXNnocwKb+n9gnAN/63kDW9way/l/6IkCrwXpGb0xPYYxifYSW2fffKyt1
 6Q1g+SNsSWgFo8/+CrMDBAd2AHGUXMvt7L6u5HFVigMHGYMuyZChYYx2IF5a+EnU31epW/pJ
 WlOSUBQpEEkkElFkhERI+nGZ5lIlj0hRmJg0htEzhlUfgnP8zcgw0iv6rj5fM3+solY5WDeH
 F3h3+GzaMf460fKp15pGvXPvYpPs5ZTYl3DmfjlVE8XamJA225G9eyBf7WmG28m4/Qc4c7uP
 RgTw+Kc5fpm+39pG9J6gVnoo+EhQVXXLjfkqxxqlbI+5wssuPqYJKRGfKS/f9iJgCPbvxJ1f
 V5V9Exs7GP3q7N+JXiV3i+5f2pGlqoyGGOC/GvfJipNF/bAzabPcsT1Z9GY+7yG5aUNaUKYE
 8I6mth2MVfvff7tVbj+Tn7xONhtl/TXw+d349mTZaJZXsPSP73fF51z7cXRGKrg3UReoqnfK
 v5go+kqzx6+H+xBR9dwzt93o+SXXIJWSLKNaIdyCGoyKfwE8GgRjkQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWy7bCSvO7sb/uTDZYuYbJYf+oYs0XThL/M
 Fqvv9rNZ7H03m9Xi5oGdTBZ7Fk1isli5+iiTxe6FH5ksHt/5zG5x9P9bNotJh64xWjy9OovJ
 Yu8tbYs9e0+yWFzeNYfNYv6yp+wWO540Mlps+z2f2eLz0hZ2i3Wv37NYnLglbXH+73FWBzGP
 WffPsnnsnHWX3eP8vY0sHpfPlnpsWtXJ5rF5Sb3H7psNbB69ze/YPN7vu8rm0bdlFaPH5tPV
 Hp83yXlsevKWKYA3issmJTUnsyy1SN8ugStj1f5mpoIm5Yq5DUtYGhiPyXQxcnJICJhIPD17
 irmLkYtDSGAHo8Sr/ulMEAlJiWV/jzBD2MISK/89Z4coamSSWLXnAJDDwcEmoC1x+j8HSFxE
 4BmTxNl7j8AmMQu0M0tc6j3PDFIkLGArsbkrF2QQi4CqRPPRKawgNq+AlcTMPydYQUokBPQl
 +u8LgoQ5Bawl1tz4wgJiCwGVzNpzlQmiXFDi5MwnLCDlzALqEuvnCYGEmQXkJZq3zmaewCg4
 C0nVLISqWUiqFjAyr2KUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI5uLa0djHtWfdA7
 xMjEwXiIUYKDWUmEd8/R/clCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0t
 SC2CyTJxcEo1MJ2Zdn+/3p422fncrnnGM9Uj87MOBBs68vz40TArbMok1it9W0SDk98853zI
 tGgH4+fEXcfZmm792sL7L+U/p6po/5oDEZZtAcqP9h9giJl1KNxcafs2AfvnIQtFW1p1QkI/
 9IlXux9oNfNT+WkpeKHdUXovg96dVSmu/XLFfg9YvKb8frffKFg7sTtlzoqwxPXvL69NlPCa
 sKTtZ4jN3+kWgpXzHD3mSpaaCendb7N3XcIiWcW2W+ZaUK/d4l9/pfxnP9u8yjWl73ZltWH/
 hNvHTnaHzfDdcWEll+SbpSxHO1JXfr125P3MmxKPbhz4W3oxMKlj1SZ7qxDPvMCnt5QKmIq+
 qjyKPZv/aa2egxJLcUaioRZzUXEiAHdQi11dAwAA
X-CMS-MailID: 20230112120131epcas5p4374e6add89990dd546bd0ae38f4386f0
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230112120131epcas5p4374e6add89990dd546bd0ae38f4386f0
References: <20230112115908.23662-1-nj.shetty@samsung.com>
 <CGME20230112120131epcas5p4374e6add89990dd546bd0ae38f4386f0@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 12 Jan 2023 14:58:20 +0000
Subject: [dm-devel] [PATCH v6 4/9] block: Introduce a new ioctl for copy
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
Cc: p.raghav@samsung.com, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Nitesh Shetty <nj.shetty@samsung.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier.gonz@samsung.com>,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QWRkIG5ldyBCTEtDT1BZIGlvY3RsIHRoYXQgb2ZmbG9hZHMgY29weWluZyBvZiBvbmUgb3IgbW9y
ZSBzb3VyY2VzIHJhbmdlcwp0byBvbmUgb3IgbW9yZSBkZXN0aW5hdGlvbiBpbiBhIGRldmljZS4g
Q09QWSBpb2N0bCBhY2NlcHRzIGEgJ2NvcHlfcmFuZ2UnCnN0cnVjdHVyZSB0aGF0IGNvbnRhaW5z
IG5vIG9mIHJhbmdlLCBhIHJlc2VydmVkIGZpZWxkICwgZm9sbG93ZWQgYnkgYW4KYXJyYXkgb2Yg
cmFuZ2VzLiBFYWNoIHNvdXJjZSByYW5nZSBpcyByZXByZXNlbnRlZCBieSAncmFuZ2VfZW50cnkn
IHRoYXQKY29udGFpbnMgc291cmNlIHN0YXJ0IG9mZnNldCwgZGVzdGluYXRpb24gc3RhcnQgb2Zm
c2V0IGFuZCBsZW5ndGggb2YKc291cmNlIHJhbmdlcyAoaW4gYnl0ZXMpCgpNQVhfQ09QWV9OUl9S
QU5HRSwgbGltaXRzIHRoZSBudW1iZXIgb2YgZW50cmllcyBmb3IgdGhlIElPQ1RMIGFuZApNQVhf
Q09QWV9UT1RBTF9MRU5HVEggbGltaXRzIHRoZSB0b3RhbCBjb3B5IGxlbmd0aCwgSU9DVEwgY2Fu
IGhhbmRsZS4KCkV4YW1wbGUgY29kZSwgdG8gaXNzdWUgQkxLQ09QWToKLyogU2FtcGxlIGV4YW1w
bGUgdG8gY29weSB0aHJlZSBlbnRyaWVzIHdpdGggW2Rlc3Qsc3JjLGxlbl0sCiogWzMyNzY4LCAw
LCA0MDk2XSBbMzY4NjQsIDQwOTYsIDQwOTZdIFs0MDk2MCw4MTkyLDQwOTZdIG9uIHNhbWUgZGV2
aWNlICovCgppbnQgbWFpbih2b2lkKQp7CglpbnQgaSwgcmV0LCBmZDsKCXVuc2lnbmVkIGxvbmcg
c3JjID0gMCwgZHN0ID0gMzI3NjgsIGxlbiA9IDQwOTY7CglzdHJ1Y3QgY29weV9yYW5nZSAqY3I7
CgoJY3IgPSAoc3RydWN0IGNvcHlfcmFuZ2UgKiltYWxsb2Moc2l6ZW9mKCpjcikrCgkJCQkJKHNp
emVvZihzdHJ1Y3QgcmFuZ2VfZW50cnkpKjMpKTsKCWNyLT5ucl9yYW5nZSA9IDM7Cgljci0+cmVz
ZXJ2ZWQgPSAwOwoJZm9yIChpID0gMDsgaTwgY3ItPm5yX3JhbmdlOyBpKyssIHNyYyArPSBsZW4s
IGRzdCArPSBsZW4pIHsKCQljci0+cmFuZ2VzW2ldLmRzdCA9IGRzdDsKCQljci0+cmFuZ2VzW2ld
LnNyYyA9IHNyYzsKCQljci0+cmFuZ2VzW2ldLmxlbiA9IGxlbjsKCQljci0+cmFuZ2VzW2ldLmNv
bXBfbGVuID0gMDsKCX0KCglmZCA9IG9wZW4oIi9kZXYvbnZtZTBuMSIsIE9fUkRXUik7CglpZiAo
ZmQgPCAwKSByZXR1cm4gMTsKCglyZXQgPSBpb2N0bChmZCwgQkxLQ09QWSwgY3IpOwoJaWYgKHJl
dCAhPSAwKQoJICAgICAgIHByaW50ZigiY29weSBmYWlsZWQsIHJldD0gJWRcbiIsIHJldCk7CgoJ
Zm9yIChpPTA7IGk8IGNyLT5ucl9yYW5nZTsgaSsrKQoJCWlmIChjci0+cmFuZ2VzW2ldLmxlbiAh
PSBjci0+cmFuZ2VzW2ldLmNvbXBfbGVuKQoJCQlwcmludGYoIlBhcnRpYWwgY29weSBmb3IgZW50
cnkgJWQ6IHJlcXVlc3RlZCAlbGx1LAoJCQkJY29tcGxldGVkICVsbHVcbiIsCgkJCQlpLCBjci0+
cmFuZ2VzW2ldLmxlbiwKCQkJCWNyLT5yYW5nZXNbaV0uY29tcF9sZW4pOwoJY2xvc2UoZmQpOwoJ
ZnJlZShjcik7CglyZXR1cm4gcmV0Owp9CgpSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxo
YXJlQHN1c2UuZGU+ClNpZ25lZC1vZmYtYnk6IE5pdGVzaCBTaGV0dHkgPG5qLnNoZXR0eUBzYW1z
dW5nLmNvbT4KU2lnbmVkLW9mZi1ieTogSmF2aWVyIEdvbnrDoWxleiA8amF2aWVyLmdvbnpAc2Ft
c3VuZy5jb20+ClNpZ25lZC1vZmYtYnk6IEFudWogR3VwdGEgPGFudWoyMC5nQHNhbXN1bmcuY29t
PgotLS0KIGJsb2NrL2lvY3RsLmMgICAgICAgICAgIHwgMzYgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrCiBpbmNsdWRlL3VhcGkvbGludXgvZnMuaCB8ICA5ICsrKysrKysrKwog
MiBmaWxlcyBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYmxvY2svaW9j
dGwuYyBiL2Jsb2NrL2lvY3RsLmMKaW5kZXggOTY2MTc1MTI5ODJlLi5kNjM2YmMxZjAwNDcgMTAw
NjQ0Ci0tLSBhL2Jsb2NrL2lvY3RsLmMKKysrIGIvYmxvY2svaW9jdGwuYwpAQCAtMTIwLDYgKzEy
MCw0MCBAQCBzdGF0aWMgaW50IGJsa19pb2N0bF9kaXNjYXJkKHN0cnVjdCBibG9ja19kZXZpY2Ug
KmJkZXYsIGZtb2RlX3QgbW9kZSwKIAlyZXR1cm4gZXJyOwogfQogCitzdGF0aWMgaW50IGJsa19p
b2N0bF9jb3B5KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIGZtb2RlX3QgbW9kZSwKKwkJdW5z
aWduZWQgbG9uZyBhcmcpCit7CisJc3RydWN0IGNvcHlfcmFuZ2UgdWNvcHlfcmFuZ2UsICprY29w
eV9yYW5nZSA9IE5VTEw7CisJc2l6ZV90IHBheWxvYWRfc2l6ZSA9IDA7CisJaW50IHJldDsKKwor
CWlmICghKG1vZGUgJiBGTU9ERV9XUklURSkpCisJCXJldHVybiAtRUJBREY7CisKKwlpZiAoY29w
eV9mcm9tX3VzZXIoJnVjb3B5X3JhbmdlLCAodm9pZCBfX3VzZXIgKilhcmcsCisJCQkJc2l6ZW9m
KHVjb3B5X3JhbmdlKSkpCisJCXJldHVybiAtRUZBVUxUOworCisJaWYgKHVubGlrZWx5KCF1Y29w
eV9yYW5nZS5ucl9yYW5nZSB8fCB1Y29weV9yYW5nZS5yZXNlcnZlZCB8fAorCQkJCXVjb3B5X3Jh
bmdlLm5yX3JhbmdlID49IE1BWF9DT1BZX05SX1JBTkdFKSkKKwkJcmV0dXJuIC1FSU5WQUw7CisK
KwlwYXlsb2FkX3NpemUgPSAodWNvcHlfcmFuZ2UubnJfcmFuZ2UgKiBzaXplb2Yoc3RydWN0IHJh
bmdlX2VudHJ5KSkgKworCQkJCXNpemVvZih1Y29weV9yYW5nZSk7CisKKwlrY29weV9yYW5nZSA9
IG1lbWR1cF91c2VyKCh2b2lkIF9fdXNlciAqKWFyZywgcGF5bG9hZF9zaXplKTsKKwlpZiAoSVNf
RVJSKGtjb3B5X3JhbmdlKSkKKwkJcmV0dXJuIFBUUl9FUlIoa2NvcHlfcmFuZ2UpOworCisJcmV0
ID0gYmxrZGV2X2lzc3VlX2NvcHkoYmRldiwgYmRldiwga2NvcHlfcmFuZ2UtPnJhbmdlcywKKwkJ
CWtjb3B5X3JhbmdlLT5ucl9yYW5nZSwgTlVMTCwgTlVMTCwgR0ZQX0tFUk5FTCk7CisJaWYgKGNv
cHlfdG9fdXNlcigodm9pZCBfX3VzZXIgKilhcmcsIGtjb3B5X3JhbmdlLCBwYXlsb2FkX3NpemUp
KQorCQlyZXQgPSAtRUZBVUxUOworCisJa2ZyZWUoa2NvcHlfcmFuZ2UpOworCXJldHVybiByZXQ7
Cit9CisKIHN0YXRpYyBpbnQgYmxrX2lvY3RsX3NlY3VyZV9lcmFzZShzdHJ1Y3QgYmxvY2tfZGV2
aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsCiAJCXZvaWQgX191c2VyICphcmdwKQogewpAQCAtNDgy
LDYgKzUxNiw4IEBAIHN0YXRpYyBpbnQgYmxrZGV2X2NvbW1vbl9pb2N0bChzdHJ1Y3QgZmlsZSAq
ZmlsZSwgZm1vZGVfdCBtb2RlLCB1bnNpZ25lZCBjbWQsCiAJCXJldHVybiBibGtfaW9jdGxfZGlz
Y2FyZChiZGV2LCBtb2RlLCBhcmcpOwogCWNhc2UgQkxLU0VDRElTQ0FSRDoKIAkJcmV0dXJuIGJs
a19pb2N0bF9zZWN1cmVfZXJhc2UoYmRldiwgbW9kZSwgYXJncCk7CisJY2FzZSBCTEtDT1BZOgor
CQlyZXR1cm4gYmxrX2lvY3RsX2NvcHkoYmRldiwgbW9kZSwgYXJnKTsKIAljYXNlIEJMS1pFUk9P
VVQ6CiAJCXJldHVybiBibGtfaW9jdGxfemVyb291dChiZGV2LCBtb2RlLCBhcmcpOwogCWNhc2Ug
QkxLR0VURElTS1NFUToKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oIGIvaW5j
bHVkZS91YXBpL2xpbnV4L2ZzLmgKaW5kZXggOTI0OGI2ZDI1OWRlLi44YWYxMGI5MjZhNmYgMTAw
NjQ0Ci0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oCisrKyBiL2luY2x1ZGUvdWFwaS9saW51
eC9mcy5oCkBAIC04Miw2ICs4MiwxNCBAQCBzdHJ1Y3QgcmFuZ2VfZW50cnkgewogCV9fdTY0IGNv
bXBfbGVuOwogfTsKIAorc3RydWN0IGNvcHlfcmFuZ2UgeworCV9fdTY0IG5yX3JhbmdlOworCV9f
dTY0IHJlc2VydmVkOworCisJLyogUmFuZ2VzIGFsd2F5cyBtdXN0IGJlIGF0IHRoZSBlbmQgKi8K
KwlzdHJ1Y3QgcmFuZ2VfZW50cnkgcmFuZ2VzW107Cit9OworCiAvKiBleHRlbnQtc2FtZSAoZGVk
dXBlKSBpb2N0bHM7IHRoZXNlIE1VU1QgbWF0Y2ggdGhlIGJ0cmZzIGlvY3RsIGRlZmluaXRpb25z
ICovCiAjZGVmaW5lIEZJTEVfREVEVVBFX1JBTkdFX1NBTUUJCTAKICNkZWZpbmUgRklMRV9ERURV
UEVfUkFOR0VfRElGRkVSUwkxCkBAIC0yMDMsNiArMjExLDcgQEAgc3RydWN0IGZzeGF0dHIgewog
I2RlZmluZSBCTEtST1RBVElPTkFMIF9JTygweDEyLDEyNikKICNkZWZpbmUgQkxLWkVST09VVCBf
SU8oMHgxMiwxMjcpCiAjZGVmaW5lIEJMS0dFVERJU0tTRVEgX0lPUigweDEyLDEyOCxfX3U2NCkK
KyNkZWZpbmUgQkxLQ09QWSBfSU9XUigweDEyLCAxMjksIHN0cnVjdCBjb3B5X3JhbmdlKQogLyoK
ICAqIEEganVtcCBoZXJlOiAxMzAtMTM2IGFyZSByZXNlcnZlZCBmb3Igem9uZWQgYmxvY2sgZGV2
aWNlcwogICogKHNlZSB1YXBpL2xpbnV4L2Jsa3pvbmVkLmgpCi0tIAoyLjM1LjEuNTAwLmdiODk2
ZjcyOWUyCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


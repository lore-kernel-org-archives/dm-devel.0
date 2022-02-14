Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD3CC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:24 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-qRKW6PZOO0imhIs1-ZeHPQ-1; Mon, 14 Feb 2022 03:48:19 -0500
X-MC-Unique: qRKW6PZOO0imhIs1-ZeHPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A87F1006AA6;
	Mon, 14 Feb 2022 08:48:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 158AA78C3E;
	Mon, 14 Feb 2022 08:48:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E087A1802E34;
	Mon, 14 Feb 2022 08:48:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8Zv2u009229 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:35:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A7D185361CE; Mon, 14 Feb 2022 08:35:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A39965361CC
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:35:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86FB210665A2
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:35:57 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-610-MHG0rTT2MOunSb6ZyRfX5Q-1; Mon, 14 Feb 2022 03:35:53 -0500
X-MC-Unique: MHG0rTT2MOunSb6ZyRfX5Q-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id
	20220214083549epoutp0166504a6ec6c246ead4f88719420bb918~Tmh_qGFES1136711367epoutp01b;
	Mon, 14 Feb 2022 08:35:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
	20220214083549epoutp0166504a6ec6c246ead4f88719420bb918~Tmh_qGFES1136711367epoutp01b
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20220214083549epcas5p2748eb531c83cc8bcc76037d15ed7a202~Tmh_JVqcQ0070900709epcas5p2Z;
	Mon, 14 Feb 2022 08:35:49 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4JxyGl2mDgz4x9QY;
	Mon, 14 Feb 2022 08:35:43 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.D6.06423.B541A026; Mon, 14 Feb 2022 17:35:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20220214080620epcas5p364a6e5bbf5ade9d115945d7b0cb1b947~TmIOhqSJ31726917269epcas5p36;
	Mon, 14 Feb 2022 08:06:20 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220214080620epsmtrp2b82da63aa6f748b02e74cd5c9c23f0c3~TmIOfljmA2569425694epsmtrp2U;
	Mon, 14 Feb 2022 08:06:20 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-31-620a145becb2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.94.08738.B7D0A026; Mon, 14 Feb 2022 17:06:19 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080615epsmtip2a6c26a2edbfcb401039983a9d28e574e~TmIKDKmgP2389323893epsmtip2Q;
	Mon, 14 Feb 2022 08:06:15 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Mon, 14 Feb 2022 13:29:54 +0530
Message-Id: <20220214080002.18381-5-nj.shetty@samsung.com>
In-Reply-To: <20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTZxT2vfdyW0iKd4DdC4uxK1kGGoXO0r0wEJOhu37gHASz4ARKuRZC
	abt+TNzUIQiLKIIwCBSdoAhRUQQ2RKCgODCAfCzlSwWVAS6KIgIKpgJrvbD57znneZ5z3nPe
	HC7u0MFx4cYodYxGKVUISTui6pb7p2t3O9lFenakrUJlrc04qrs7ZYMuDaaTKGfiDY5e3By2
	QZnpuRxkGrFHxvF8G9Q1exhDwxULGKo7m4mhC5eaMPRPyTmAagtfWoiBKQ462taFobdDItS0
	8JxEmY29AI32GDBkvLcG1RlbCGSqOUWiM8WjHHSsr5pE9WNGHJXcnsdQh+EtiapHDgNUZT6D
	o1sPegh0ZewFgVLKXwGUfPwNB3XO3bbZ6EqburfRhoftJH0yaZxDXzcMcujOB+UEnVQwQNCm
	dj1dcfEoSVcW/Uxn9ZcAuvZuAkkn3mnC6dzJaZJOSxon6Zej9wj6RX0PuZMfGusbzUijGI2A
	UcpUUTFKuZ9wW3D4l+FeEk/RWpE3+lwoUErjGD9hwPadazfHKCxLFAp+kCr0ltROqVYr9Njg
	q1HpdYwgWqXV+QkZdZRCLVav00rjtHqlfJ2S0fmIPD0/87III2KjZ6/lEOr+j+NP9JwmE0D9
	R6nAlgspMTRXjhGpwI7rQNUCmHxjHLMSDtQkgEUZtiwxBeCz0cv4kqM78Q1giRoAU8xmkg2S
	MTjRkm5huFySWgPbFrhWgxNFwAszM4QV41QlB9blh1qxI+UPzXfLbayYoD6BHYZfgRXzKB/Y
	9uDPxWausHDo5juNLfUFvDFWgrOaD2BL3shizVUw6Y983PoGSGXbwbyrmTasOQAeqVngsNgR
	Pr39+yJ2gVPjRpI1HANw9s5DjA1yAUzKSCJZlT/8q24Os06DU+6wrMaDTa+E2a1XMLazPUwz
	j2Bsngerf1vCrrC0rGCxjDPsnTm8iGlYntNMsPs9AWDDc0UGEBjeG8jw3kCG/zsXAPwicGbU
	2jg5o/VSi5TMvv9+WaaKqwDvDmv1lmow+GhiXSPAuKARQC4udOKFtdtGOvCipPt/ZDSqcI1e
	wWgbgZdl4ydxlxUyleUylbpwkdjbUyyRSMTe6yUi4Ye8NvlVqQMll+qYWIZRM5olH8a1dUnA
	fLc2yfLsmydr97Tu7ig9EOzSfPBRll1DxfWggCf8gu/2HTLtKr4ZkbbstHEgtf/x0Pe/pIVs
	uu8f+TbeTcF3W75Hk3W2qUgzXDYndjqXH7uyN/j19P2WV6WCyJCrHv57V8TNizrT09f7DsXL
	gr2e+G5KiBRnycNcVQe/DTWJAq8suyf6W+Ie87QkfPbrZgWYSHzMf8rr3HvQiS4sZo5cTg9y
	fF06Hfa4vrZj+3nmfHDg8j6gL/IhGjc+/Olad9dxQV+hNsZPIDkQT58+VL91R+gO/vzykMTJ
	r+wbnrk5e0y7JxfF7KkaQru+ma8IlGX0TmzYHHFqTYrt2AC/r7tyY/b+AWOQkNBGS0WrcY1W
	+i+oMGJD4QQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA03SbUxTZxQH8D333t57aVK8VMVHjeiqBoIZk0mXJ7iBLzCfbGQxapzZkrlq
	rwVGS9daHRqzYrcZcU5FZHDxBV+AgC/YziHSFrAVTS0FJnZSR3FGGNMKBXEKUWQUYua3f87/
	l3O+HJaUlohmsRmarbxOo8iS0WKqximb+85OiXjT4jKrHFXfvE4im29IhM76D9CocGCERMGr
	D0Qo/0ARg9q7w5G9v0SE2oZzCfTAMkYg26l8AlWebSJQb8VpgKwnB8eLziEG7XW3Eejl/XjU
	NNZHo3zHHwD1eAUC2e8uQja7i0LtdUdpdKK8h0H77tTSqD5gJ1HFjVcEahFe0qi2Oxegmhcn
	SOTs8lLoQiBIoR/N/wL0w08jDGodvSFaNh+33/4EC/c8ND5k6mfwFcHP4NYuM4VNpZ0UbvcY
	sKVqL41/PfMdPtxRAbDVZ6Tx7uYmEhc9eUrj/aZ+Gg/23KVwsN5Lr478XPyBks/K2Mbr3k36
	Spw+fLmQ0na8/e3P3mO0EdTPzgNhLOQS4O3dIyAPiFkpVwvgrUETNVnMhOWj18jJPBVWvupl
	JpGJgIXujvGCZWluEXSPsSEzjaNg5fPnVMiQnJ+B5y9ZJhZN5ZLhC59ZFMoUtxC2CAUglCVc
	InR3vT4wH568f3XChHFLYWOgYmIuHTdFXgcz6SOgq7ibCt0luWhYfVwaGpPcXGj6rYQ8CCKE
	N5TwvxLeUKWArAIzea1erVLr47XvafjtcXqFWm/QqOI2Z6stYOJ/YmNrga1qIM4BCBY4AGRJ
	2TTJl56wTVKJUpGzg9dlb9QZsni9A8xmKdkMSVuea6OUUym28l/zvJbXvW4JNmyWkXCW1F0L
	H854ttYpT9QEoj3aDn9kIGXOLzhdt74gMb741PX3z1XtW11dtP1yi5Ky1qTU/b3Y2fBxapLl
	iWrts4up0w+Otu7YkPo0uiX/yCXDwz2bM8vvaPJMsoSRNLvL2HAh5eGCoTLjUt9RzzZXUqRK
	cFu/2OWzNczwh7vtrd2Zhs+Kg47S6GVT7tE6/OcS65qYdSuPHBqzM8kr6h8dtxUsjPmnLnmd
	+aNVt/oWwK6c8u/NW1TsORP6K8exR+0/NrBkXlpjc7N8Dm78NKr5wz7lzrSyrLf8Db1bOlfK
	RuU3s6N+P/ONPJgbY7uo1JIRG3atiMKZHm4goBCtP+9YnnD4sYzSpyviY0mdXvEft6Oxdq4D
	AAA=
X-CMS-MailID: 20220214080620epcas5p364a6e5bbf5ade9d115945d7b0cb1b947
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080620epcas5p364a6e5bbf5ade9d115945d7b0cb1b947
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080620epcas5p364a6e5bbf5ade9d115945d7b0cb1b947@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E8Zv2u009229
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Feb 2022 03:47:51 -0500
Cc: Nitesh, Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
	javier@javigon.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
	James Smart <james.smart@broadcom.com>, hch@lst.de, Alexander,
	Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
	Chaitanya Kulkarni <kch@nvidia.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	=?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier.gonz@samsung.com>,
	lsf-pc@lists.linux-foundation.org, Viro <viro@zeniv.linux.org.uk>
Subject: [dm-devel] [PATCH v3 04/10] block: Introduce a new ioctl for copy
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
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
CgljciA9IChzdHJ1Y3QgY29weV9yYW5nZSAqKW1hbGxvYyhzaXplb2YoKmNyKSsKCQkJCQkoc2l6
ZW9mKHN0cnVjdCByYW5nZV9lbnRyeSkqMykpOwoJY3ItPm5yX3JhbmdlID0gMzsKCWNyLT5yZXNl
cnZlZCA9IDA7Cglmb3IgKGkgPSAwOyBpPCBjci0+bnJfcmFuZ2U7IGkrKywgc3JjICs9IGxlbiwg
ZHN0ICs9IGxlbikgewoJCWNyLT5yYW5nZV9saXN0W2ldLmRzdCA9IGRzdDsKCQljci0+cmFuZ2Vf
bGlzdFtpXS5zcmMgPSBzcmM7CgkJY3ItPnJhbmdlX2xpc3RbaV0ubGVuID0gbGVuOwoJCWNyLT5y
YW5nZV9saXN0W2ldLmNvbXBfbGVuID0gMDsKCX0KCWZkID0gb3BlbigiL2Rldi9udm1lMG4xIiwg
T19SRFdSKTsKCWlmIChmZCA8IDApIHJldHVybiAxOwoJcmV0ID0gaW9jdGwoZmQsIEJMS0NPUFks
IGNyKTsKCWlmIChyZXQgIT0gMCkKCSAgICAgICBwcmludGYoImNvcHkgZmFpbGVkLCByZXQ9ICVk
XG4iLCByZXQpOwoJZm9yIChpPTA7IGk8IGNyLT5ucl9yYW5nZTsgaSsrKQoJCWlmIChjci0+cmFu
Z2VfbGlzdFtpXS5sZW4gIT0gY3ItPnJhbmdlX2xpc3RbaV0uY29tcF9sZW4pCgkJCXByaW50Zigi
UGFydGlhbCBjb3B5IGZvciBlbnRyeSAlZDogcmVxdWVzdGVkICVsbHUsIGNvbXBsZXRlZCAlbGx1
XG4iLAoJCQkJCQkJCWksIGNyLT5yYW5nZV9saXN0W2ldLmxlbiwKCQkJCQkJCQljci0+cmFuZ2Vf
bGlzdFtpXS5jb21wX2xlbik7CgljbG9zZShmZCk7CglmcmVlKGNyKTsKCXJldHVybiByZXQ7Cn0K
ClNpZ25lZC1vZmYtYnk6IE5pdGVzaCBTaGV0dHkgPG5qLnNoZXR0eUBzYW1zdW5nLmNvbT4KU2ln
bmVkLW9mZi1ieTogSmF2aWVyIEdvbnrDoWxleiA8amF2aWVyLmdvbnpAc2Ftc3VuZy5jb20+ClNp
Z25lZC1vZmYtYnk6IEFybmF2IERhd24gPGFybmF2LmRhd25Ac2Ftc3VuZy5jb20+Ci0tLQogYmxv
Y2svaW9jdGwuYyAgICAgICAgICAgfCAzMiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KwogaW5jbHVkZS91YXBpL2xpbnV4L2ZzLmggfCAgOSArKysrKysrKysKIDIgZmlsZXMgY2hhbmdl
ZCwgNDEgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL2lvY3RsLmMgYi9ibG9jay9p
b2N0bC5jCmluZGV4IDRhODYzNDAxMzNlNC4uYTJkYzJjZmJhZTZkIDEwMDY0NAotLS0gYS9ibG9j
ay9pb2N0bC5jCisrKyBiL2Jsb2NrL2lvY3RsLmMKQEAgLTEyNCw2ICsxMjQsMzYgQEAgc3RhdGlj
IGludCBibGtfaW9jdGxfZGlzY2FyZChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBmbW9kZV90
IG1vZGUsCiAJcmV0dXJuIGVycjsKIH0KIAorc3RhdGljIGludCBibGtfaW9jdGxfY29weShzdHJ1
Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsCisJCXVuc2lnbmVkIGxvbmcgYXJn
KQoreworCXN0cnVjdCBjb3B5X3JhbmdlIGNyYW5nZSwgKnJhbmdlcyA9IE5VTEw7CisJc2l6ZV90
IHBheWxvYWRfc2l6ZSA9IDA7CisJaW50IHJldDsKKworCWlmICghKG1vZGUgJiBGTU9ERV9XUklU
RSkpCisJCXJldHVybiAtRUJBREY7CisKKwlpZiAoY29weV9mcm9tX3VzZXIoJmNyYW5nZSwgKHZv
aWQgX191c2VyICopYXJnLCBzaXplb2YoY3JhbmdlKSkpCisJCXJldHVybiAtRUZBVUxUOworCisJ
aWYgKHVubGlrZWx5KCFjcmFuZ2UubnJfcmFuZ2UgfHwgY3JhbmdlLnJlc2VydmVkIHx8IGNyYW5n
ZS5ucl9yYW5nZSA+PSBNQVhfQ09QWV9OUl9SQU5HRSkpCisJCXJldHVybiAtRUlOVkFMOworCisJ
cGF5bG9hZF9zaXplID0gKGNyYW5nZS5ucl9yYW5nZSAqIHNpemVvZihzdHJ1Y3QgcmFuZ2VfZW50
cnkpKSArIHNpemVvZihjcmFuZ2UpOworCisJcmFuZ2VzID0gbWVtZHVwX3VzZXIoKHZvaWQgX191
c2VyICopYXJnLCBwYXlsb2FkX3NpemUpOworCWlmIChJU19FUlIocmFuZ2VzKSkKKwkJcmV0dXJu
IFBUUl9FUlIocmFuZ2VzKTsKKworCXJldCA9IGJsa2Rldl9pc3N1ZV9jb3B5KGJkZXYsIHJhbmdl
cy0+bnJfcmFuZ2UsIHJhbmdlcy0+cmFuZ2VfbGlzdCwgYmRldiwgR0ZQX0tFUk5FTCk7CisJaWYg
KGNvcHlfdG9fdXNlcigodm9pZCBfX3VzZXIgKilhcmcsIHJhbmdlcywgcGF5bG9hZF9zaXplKSkK
KwkJcmV0ID0gLUVGQVVMVDsKKworCWtmcmVlKHJhbmdlcyk7CisJcmV0dXJuIHJldDsKK30KKwog
c3RhdGljIGludCBibGtfaW9jdGxfemVyb291dChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBm
bW9kZV90IG1vZGUsCiAJCXVuc2lnbmVkIGxvbmcgYXJnKQogewpAQCAtNDU1LDYgKzQ4NSw4IEBA
IHN0YXRpYyBpbnQgYmxrZGV2X2NvbW1vbl9pb2N0bChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2
LCBmbW9kZV90IG1vZGUsCiAJY2FzZSBCTEtTRUNESVNDQVJEOgogCQlyZXR1cm4gYmxrX2lvY3Rs
X2Rpc2NhcmQoYmRldiwgbW9kZSwgYXJnLAogCQkJCUJMS0RFVl9ESVNDQVJEX1NFQ1VSRSk7CisJ
Y2FzZSBCTEtDT1BZOgorCQlyZXR1cm4gYmxrX2lvY3RsX2NvcHkoYmRldiwgbW9kZSwgYXJnKTsK
IAljYXNlIEJMS1pFUk9PVVQ6CiAJCXJldHVybiBibGtfaW9jdGxfemVyb291dChiZGV2LCBtb2Rl
LCBhcmcpOwogCWNhc2UgQkxLR0VURElTS1NFUToKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9s
aW51eC9mcy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2ZzLmgKaW5kZXggNTViY2E4ZjZlOGVkLi4x
OTA5MTFlYTQzMTEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oCisrKyBiL2lu
Y2x1ZGUvdWFwaS9saW51eC9mcy5oCkBAIC03OCw2ICs3OCwxNCBAQCBzdHJ1Y3QgcmFuZ2VfZW50
cnkgewogCV9fdTY0IGNvbXBfbGVuOwogfTsKIAorc3RydWN0IGNvcHlfcmFuZ2UgeworCV9fdTY0
IG5yX3JhbmdlOworCV9fdTY0IHJlc2VydmVkOworCisJLyogUmFuZ2VfbGlzdCBhbHdheXMgbXVz
dCBiZSBhdCB0aGUgZW5kICovCisJc3RydWN0IHJhbmdlX2VudHJ5IHJhbmdlX2xpc3RbXTsKK307
CisKIC8qIGV4dGVudC1zYW1lIChkZWR1cGUpIGlvY3RsczsgdGhlc2UgTVVTVCBtYXRjaCB0aGUg
YnRyZnMgaW9jdGwgZGVmaW5pdGlvbnMgKi8KICNkZWZpbmUgRklMRV9ERURVUEVfUkFOR0VfU0FN
RQkJMAogI2RlZmluZSBGSUxFX0RFRFVQRV9SQU5HRV9ESUZGRVJTCTEKQEAgLTE5OSw2ICsyMDcs
NyBAQCBzdHJ1Y3QgZnN4YXR0ciB7CiAjZGVmaW5lIEJMS1JPVEFUSU9OQUwgX0lPKDB4MTIsMTI2
KQogI2RlZmluZSBCTEtaRVJPT1VUIF9JTygweDEyLDEyNykKICNkZWZpbmUgQkxLR0VURElTS1NF
USBfSU9SKDB4MTIsMTI4LF9fdTY0KQorI2RlZmluZSBCTEtDT1BZIF9JT1dSKDB4MTIsIDEyOSwg
c3RydWN0IGNvcHlfcmFuZ2UpCiAvKgogICogQSBqdW1wIGhlcmU6IDEzMC0xMzYgYXJlIHJlc2Vy
dmVkIGZvciB6b25lZCBibG9jayBkZXZpY2VzCiAgKiAoc2VlIHVhcGkvbGludXgvYmxrem9uZWQu
aCkKLS0gCjIuMzAuMC1yYzAKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs


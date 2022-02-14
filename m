Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F923C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:24 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-bFT7zPqPM-2Lzcu1dnGSdA-1; Mon, 14 Feb 2022 03:48:19 -0500
X-MC-Unique: bFT7zPqPM-2Lzcu1dnGSdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 570AD189DF41;
	Mon, 14 Feb 2022 08:48:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12F845F92E;
	Mon, 14 Feb 2022 08:48:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA81C1809CBF;
	Mon, 14 Feb 2022 08:48:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8Ytvf009147 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:34:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2562D14582F2; Mon, 14 Feb 2022 08:34:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 214B814582F1
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:34:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC0A48039D5
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:34:54 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-602-OoEyadvJOCyhYNPocTAmiw-1; Mon, 14 Feb 2022 03:34:49 -0500
X-MC-Unique: OoEyadvJOCyhYNPocTAmiw-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id
	20220214083446epoutp0388b33d8e6892ec8968523c7a595b84a6~TmhDp91Xk0636606366epoutp03P;
	Mon, 14 Feb 2022 08:34:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
	20220214083446epoutp0388b33d8e6892ec8968523c7a595b84a6~TmhDp91Xk0636606366epoutp03P
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20220214083445epcas5p26fa92a4f5144c6e20ec809149f325a3f~TmhDQfoV-1890418904epcas5p2n;
	Mon, 14 Feb 2022 08:34:45 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4JxyFX1yMqz4x9Q3;
	Mon, 14 Feb 2022 08:34:40 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	57.F5.05590.E141A026; Mon, 14 Feb 2022 17:34:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080551epcas5p201d4d85e9d66077f97585bb3c64517c0~TmH0DlolQ0641206412epcas5p2k;
	Mon, 14 Feb 2022 08:05:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220214080551epsmtrp1e7b9ac42b2a39510a8cb2b24652a1017~TmH0B0nE20045600456epsmtrp1G;
	Mon, 14 Feb 2022 08:05:51 +0000 (GMT)
X-AuditID: b6c32a4b-739ff700000015d6-5b-620a141e7676
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	9D.84.08738.F5D0A026; Mon, 14 Feb 2022 17:05:51 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080546epsmtip2b0944a037ec35c960299faf315798fe6~TmHvuft_Q2320123201epsmtip2K;
	Mon, 14 Feb 2022 08:05:46 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Mon, 14 Feb 2022 13:29:50 +0530
Message-Id: <20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02TeUxUVxTGc99782YgBZ+IeCVR6dg2AYMybF6NtBYIfdFKaUhaNFU6MK8z
	CAzTWajSpAIj1gGUpa2FgSgoSwVFREV2CgSHYZFNpMhWdIhr2SlQtjI8aP3vOye/757l5vBw
	i3KuNS9IqmTkUmEInzQliutsbe23W5oGOGSPOaFbjQ9wVNEzyUH5/QkkujQ2h6PRmmcclJyQ
	wkWdBnNUOZLGQW2zURh6VrSMoYqryRi6nl+Poee51wAqzxzHkKapDUMLQwJUv/wXiZJrHwM0
	3KXFUOWTXaiiUk+gzrJ0El3JGeaiuO4SElW9rsRRrm4JQw+1CyQqMUQBVDx/BUd1A10EKng9
	SqBzt6cBiomf46LWRR3nIJ/ufHSY1g62kHSSeoRLl2r7uXTrwG2CVmf0EXRni4ouytOQ9J2s
	M/RPf+QCurwnkqSjm+txOmViiqQvqEdIenz4CUGPVnWRPlbHgg9IGKGIkdsw0sAwUZBU7MY/
	7Ovv4e/i6iCwF+xDe/k2UmEo48b3/NTH3isoZGV/fJtwYYhqJeUjVCj4ez48IA9TKRkbSZhC
	6cZnZKIQmbNst0IYqlBJxbuljHK/wMHB0WUF/DpY0pM0x5FlWZ2qup6JRYIMKhaY8CDlDIfj
	9ZxYYMqzoMoB7G3vxdhgAsCSFzMcI2VBTQLYPSZZd8yWvgAsVAZg1NX0NUcMBt/ETqwEPB5J
	7YJNyzyjwZIi4PWZGcLI4NQkCRtuzK8ymyhHWPL7diNDUO/D3LkGYNRm1H6ob4vG2WI7YeZQ
	DYfNb4T6VANh1Di1A6rvpa0xEyawv/4bVnvCV4bzHFZvgq90d7mstoYvE85xjT1AKg7A2eZB
	jA1SAFQnqkmW+gi2VyyuNodTtvBW2R42vQ3+0liAsYXN4YV5A8bmzWDJ5XW9E964lbH2zFb4
	eCaKND4DKRpOa75il3gc3sgvIBPBDu1b42jfGkf7f+EMgOeBrYxMESpmFC4yJynz3X//GhgW
	WgRWr8jucAl4+ufY7lqA8UAtgDycb2l2osUkwMJMJDwdwcjD/OWqEEZRC1xWdpyEW28ODFs5
	Q6nSX+C8z8HZ1dXVeZ+Tq4C/xaxRXCi0oMRCJRPMMDJGvu7DeCbWkdh+apsi70v38N5uq5dO
	rZn3vXVt4fZpnjOp19x+fVVHnLH0/WL6eU7G/aY39z7Jj3HnfoAHSWu/1XtEdEZ0+P1crbTV
	7II/+nofWuqZ6lX9fbvvaPLEC02foUZ/LPEI12t52C9bZHe0uXpk2TPWJUijK2y6VHp+KPvy
	UPbUxyDwYkqvVXrDuKj4iNjjQWHqQ4Hh++MFg+/84PbZzbvtvdGFczFpEkHRwELceyf1S05e
	5dvO+oX/FuBulRp/86xb0SVxyqjuZEbH6aqxU/bBtuaSY953Tuw9OlW1YUuopqih+l3NU57K
	/tGGrEXXJZth0WbHBeZgR86A7z+6sty8RZ7S6+LGz0/xCYVEKLDD5Qrhvy5gmLzOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxiG955zenroVnYsBg5gbChfBgcb1Zhnyowk+/EmGuPiotnSjR7H
	CYK0Nq246WYG1M8qQyCZWvwA7GgKCyjGrkjbKIjS0c6Gihs6cQYaNwkUQQYNX6Zjy/x35b6v
	5/71MKRsjkpgCrX7BL2WL1bQEsrepZBn5kklu95rmF8BrT/fIcE5MCmC5seVNHw/HiYhdGtI
	BNWVZ8UQGI4G11itCPwzZQQMtS0S4GyoJsDW3E3AM+tlBB31Lwg40esnYO5pNnQvjtJQ3fkA
	QbDfTIDr4WpwujwUBG6cp+FSY1AMJ3910OAecZFgvbtAwC/mORocw2UI7LOXSOga7KegZSRE
	wdGrUwiOnAqL4d78XdEmBQ7c34zNT3w0rjKOiXG7+bEY3xu8SmFj3e8UDvhKcFvTCRpfs3yL
	a36zItwxUErjcm83ic9OvKRxhXGMxi+CDykccvfT22I/leTkC8WF+wX9uxvVkt0DVWGRzhL7
	ldtWT5SiOtaEohiOXcvNtP+JTEjCyFgH4o4FJomlIp5rnL9NLnEMZ1t4Jo6wjDUSnKkaTIhh
	aHY117vIROLlLMXZpqepyA7JXhBz3hGvOOLEsErOcXNlxKHYVM4a7kERlrLrOY+//N/5ZK7+
	6S3RUr6M85wbpiKnJJvOtV6URWKSlXPG67XkafS2+TXL/L9lfs2qQ2QTihd0Bk2BxpCtU2qF
	L7MMvMZQoi3I+mKvpg398yAZGQ7kbBrP6kQEgzoRx5CK5dLPfVG7ZNJ8/sBBQb83T19SLBg6
	USJDKeKkfpMnT8YW8PuEPYKgE/T/tQQTlVBK6NeNv/yor0jaYkbrD68b/CNns/oTlEI8yqzs
	jnqAYqJPJVw4MvrBQvpb9o+3gdvSt2bWrzaUUWkVRa0H+OTLq0q2Jqkd23u/Lsr6LjW5pcb6
	5M7kcQ0y2lFwKjR8MEXXqptRvX/Tp1fuuOFsvNZXnpSmuqKLOQyno909Pc2ZtccKt3vl5dOf
	nVw2dL9qNPRTWgK/gVA+90wNBi8+r1gh3+KLC6vUHkluYqFqZ0MqeT1xPFzTonwH74nLMa1t
	/sbrLMpNvz2xNdeVN7Ap9ihd4XnzwysWGyVfdcier5WPTKSc+XFL8uwh1RuK9r/5H+J37rA0
	HSe6pnSPkno7ziz8paAMu/nsDFJv4F8B1ZQ2/48DAAA=
X-CMS-MailID: 20220214080551epcas5p201d4d85e9d66077f97585bb3c64517c0
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080551epcas5p201d4d85e9d66077f97585bb3c64517c0
References: <CGME20220214080551epcas5p201d4d85e9d66077f97585bb3c64517c0@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E8Ytvf009147
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Feb 2022 03:47:51 -0500
Cc: Nitesh, Snitzer <snitzer@redhat.com>, djwong@kernel.org, Mike,
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
	lsf-pc@lists.linux-foundation.org, Viro <viro@zeniv.linux.org.uk>
Subject: [dm-devel] [PATCH v3 00/10] Add Copy offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhlIHBhdGNoIHNlcmllcyBjb3ZlcnMgdGhlIHBvaW50cyBkaXNjdXNzZWQgaW4gTm92ZW1iZXIg
MjAyMSB2aXJ0dWFsIGNhbGwKW0xTRi9NTS9CRlAgVE9QSUNdIFN0b3JhZ2U6IENvcHkgT2ZmbG9h
ZFswXS4KV2UgaGF2ZSBjb3ZlcmVkIHRoZSBJbml0aWFsIGFncmVlZCByZXF1aXJlbWVudHMgaW4g
dGhpcyBwYXRjaHNldC4KUGF0Y2hzZXQgYm9ycm93cyBNaWt1bGFzJ3MgdG9rZW4gYmFzZWQgYXBw
cm9hY2ggZm9yIDIgYmRldgppbXBsZW1lbnRhdGlvbi4KCk92ZXJhbGwgc2VyaWVzIHN1cHBvcnRz
IOKAkwoKMS4gRHJpdmVyCi0gTlZNZSBDb3B5IGNvbW1hbmQgKHNpbmdsZSBOUyksIGluY2x1ZGlu
ZyBzdXBwb3J0IGluIG52bWUtdGFyZ2V0IChmb3IKCWJsb2NrIGFuZCBmaWxlIGJhY2tlbmQpCgoy
LiBCbG9jayBsYXllcgotIEJsb2NrLWdlbmVyaWMgY29weSAoUkVRX0NPUFkgZmxhZyksIHdpdGgg
aW50ZXJmYWNlIGFjY29tbW9kYXRpbmcKCXR3byBibG9jay1kZXZzLCBhbmQgbXVsdGktc291cmNl
L2Rlc3RpbmF0aW9uIGludGVyZmFjZQotIEVtdWxhdGlvbiwgd2hlbiBvZmZsb2FkIGlzIG5hdGl2
ZWx5IGFic2VudAotIGRtLWxpbmVhciBzdXBwb3J0IChmb3IgY2FzZXMgbm90IHJlcXVpcmluZyBz
cGxpdCkKCjMuIFVzZXItaW50ZXJmYWNlCi0gbmV3IGlvY3RsCgo0LiBJbi1rZXJuZWwgdXNlcgot
IGRtLWtjb3B5ZAoKWzBdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUvQ0ErMUUz
cko3Qlo3TGpRWFhUZFgrLTBFZHo9elQxNG1tUEdNaVZDelVnQjMzQzYwdGJRQG1haWwuZ21haWwu
Y29tLwoKQ2hhbmdlcyBpbiB2MzoKLSBmaXhlZCBwb3NzaWJsZSByYWNlIGNvbmRpdGlvbiByZXBv
cnRlZCBieSBEYW1pZW4gTGUgTW9hbAotIG5ldyBzeXNmcyBjb250cm9scyBhcyBzdWdnZXN0ZWQg
YnkgRGFtaWVuIExlIE1vYWwKLSBmaXhlZCBwb3NzaWJsZSBtZW1vcnkgbGVhayByZXBvcnRlZCBi
eSBEYW4gQ2FycGVudGVyLCBsa3AKLSBtaW5vciBmaXhlcwoKCkFybmF2IERhd24gKDEpOgogIG52
bWV0OiBhZGQgY29weSBjb21tYW5kIHN1cHBvcnQgZm9yIGJkZXYgYW5kIGZpbGUgbnMKCk5pdGVz
aCBTaGV0dHkgKDYpOgogIGJsb2NrOiBJbnRyb2R1Y2UgcXVldWUgbGltaXRzIGZvciBjb3B5LW9m
ZmxvYWQgc3VwcG9ydAogIGJsb2NrOiBBZGQgY29weSBvZmZsb2FkIHN1cHBvcnQgaW5mcmFzdHJ1
Y3R1cmUKICBibG9jazogSW50cm9kdWNlIGEgbmV3IGlvY3RsIGZvciBjb3B5CiAgYmxvY2s6IGFk
ZCBlbXVsYXRpb24gZm9yIGNvcHkKICBkbTogQWRkIHN1cHBvcnQgZm9yIGNvcHkgb2ZmbG9hZC4K
ICBkbTogRW5hYmxlIGNvcHkgb2ZmbG9hZCBmb3IgZG0tbGluZWFyIHRhcmdldAoKU2VsdmFLdW1h
ciBTICgzKToKICBibG9jazogbWFrZSBiaW9fbWFwX2tlcm4oKSBub24gc3RhdGljCiAgbnZtZTog
YWRkIGNvcHkgb2ZmbG9hZCBzdXBwb3J0CiAgZG0ga2NvcHlkOiB1c2UgY29weSBvZmZsb2FkIHN1
cHBvcnQKCiBibG9jay9ibGstbGliLmMgICAgICAgICAgICAgICAgICAgfCAzNDYgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrCiBibG9jay9ibGstbWFwLmMgICAgICAgICAgICAgICAgICAg
fCAgIDIgKy0KIGJsb2NrL2Jsay1zZXR0aW5ncy5jICAgICAgICAgICAgICB8ICA1OSArKysrKwog
YmxvY2svYmxrLXN5c2ZzLmMgICAgICAgICAgICAgICAgIHwgMTM4ICsrKysrKysrKysrKwogYmxv
Y2svYmxrLmggICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsKIGJsb2NrL2lvY3RsLmMgICAg
ICAgICAgICAgICAgICAgICB8ICAzMiArKysKIGRyaXZlcnMvbWQvZG0ta2NvcHlkLmMgICAgICAg
ICAgICB8ICA1NSArKysrLQogZHJpdmVycy9tZC9kbS1saW5lYXIuYyAgICAgICAgICAgIHwgICAx
ICsKIGRyaXZlcnMvbWQvZG0tdGFibGUuYyAgICAgICAgICAgICB8ICA0NSArKysrCiBkcml2ZXJz
L21kL2RtLmMgICAgICAgICAgICAgICAgICAgfCAgIDYgKwogZHJpdmVycy9udm1lL2hvc3QvY29y
ZS5jICAgICAgICAgIHwgMTE5ICsrKysrKysrKy0KIGRyaXZlcnMvbnZtZS9ob3N0L2ZjLmMgICAg
ICAgICAgICB8ICAgNCArCiBkcml2ZXJzL252bWUvaG9zdC9udm1lLmggICAgICAgICAgfCAgIDcg
KwogZHJpdmVycy9udm1lL2hvc3QvcGNpLmMgICAgICAgICAgIHwgICA5ICsKIGRyaXZlcnMvbnZt
ZS9ob3N0L3JkbWEuYyAgICAgICAgICB8ICAgNiArCiBkcml2ZXJzL252bWUvaG9zdC90Y3AuYyAg
ICAgICAgICAgfCAgIDggKwogZHJpdmVycy9udm1lL2hvc3QvdHJhY2UuYyAgICAgICAgIHwgIDE5
ICsrCiBkcml2ZXJzL252bWUvdGFyZ2V0L2FkbWluLWNtZC5jICAgfCAgIDggKy0KIGRyaXZlcnMv
bnZtZS90YXJnZXQvaW8tY21kLWJkZXYuYyB8ICA2NSArKysrKysKIGRyaXZlcnMvbnZtZS90YXJn
ZXQvaW8tY21kLWZpbGUuYyB8ICA0OCArKysrKwogaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCAg
ICAgICAgIHwgIDIxICsrCiBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oICAgICAgICAgICAgfCAgMTcg
KysKIGluY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5oICAgICB8ICAgNSArCiBpbmNsdWRlL2xp
bnV4L252bWUuaCAgICAgICAgICAgICAgfCAgNDMgKysrLQogaW5jbHVkZS91YXBpL2xpbnV4L2Zz
LmggICAgICAgICAgIHwgIDIzICsrCiAyNSBmaWxlcyBjaGFuZ2VkLCAxMDc0IGluc2VydGlvbnMo
KyksIDE0IGRlbGV0aW9ucygtKQoKCmJhc2UtY29tbWl0OiAyM2EzZmU1ZTZiYjU4MzA0ZTY2MmM2
MDRiODZiYzEyNjQ0NTNlODg4Ci0tIAoyLjMwLjAtcmMwCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbA==


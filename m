Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E59C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:34:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-r0VGETTAO1u0wr1kgl6Luw-1; Tue, 08 Feb 2022 17:34:28 -0500
X-MC-Unique: r0VGETTAO1u0wr1kgl6Luw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1012B1018729;
	Tue,  8 Feb 2022 22:34:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E35636ABBE;
	Tue,  8 Feb 2022 22:34:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BC8B35ABFD;
	Tue,  8 Feb 2022 22:34:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217EUhkb012673 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 09:30:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F220F53D3; Mon,  7 Feb 2022 14:30:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC96353D0
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:30:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A90E23C11A1C
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:30:39 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-97-ydxAgKXwNjKXo-JWRqFp_g-1; Mon, 07 Feb 2022 09:30:37 -0500
X-MC-Unique: ydxAgKXwNjKXo-JWRqFp_g-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id
	20220207142245epoutp04f3c5dc7d69fd9bb8f033806f9fe549f3~Rhv47Ku5T1970319703epoutp04U
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:22:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
	20220207142245epoutp04f3c5dc7d69fd9bb8f033806f9fe549f3~Rhv47Ku5T1970319703epoutp04U
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20220207142244epcas5p29a7306d5c7f8e54ea7a493ffcb0fa016~Rhv3nwPUf2954829548epcas5p2e;
	Mon,  7 Feb 2022 14:22:44 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4JspJG57mjz4x9Pq;
	Mon,  7 Feb 2022 14:22:38 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	95.1E.46822.28A21026; Mon,  7 Feb 2022 23:19:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20220207141901epcas5p162ec2387815be7a1fd67ce0ab7082119~Rhsn75jdi1498914989epcas5p16;
	Mon,  7 Feb 2022 14:19:01 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220207141901epsmtrp1f9eeb35e5f80b47703f826b47335f7a2~Rhsn6oK7q0764707647epsmtrp1r;
	Mon,  7 Feb 2022 14:19:01 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-28-62012a82045c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	8D.33.08738.45A21026; Mon,  7 Feb 2022 23:19:00 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20220207141856epsmtip1abc84e3ece99ad466b43b11b462c0490~RhskKuvSp0284102841epsmtip1j;
	Mon,  7 Feb 2022 14:18:56 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: mpatocka@redhat.com
Date: Mon,  7 Feb 2022 19:43:38 +0530
Message-Id: <20220207141348.4235-1-nj.shetty@samsung.com>
In-Reply-To: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbdRTH97u3vS3LileG4QeRjBQ18lzLKP46hpgIy3VjBiJmQpxY4AqE
	0ta2uEk0wCp78JDCECtsg20MFJi48pBBYVBSAQuIIpThNuW1ORhsPNxAcLWloPvvcx7fc37n
	/HLYuMMVlgs7SaKk5RKRmEtsZzR1eXj6HPcEsbxu4w6ku7HERDW38glU/HAVRw86J5moMF/D
	QkNT9qhtvpSJBlcyMTSpNWNId7EQQ9/UGDB0t+oSQKeNgxhaH+cjg3mOQIX6EYDaxryQrq2X
	gcoqp1kox9RMoPbZNhxVdT/BUMGpYQwNlKwTqGmtDEddt4cZqGYdoazcVRaauf7ea67U0K8H
	qQLVPItSld9kUEP9qZS2+jRB1VekU2dGqwDVeiODoI73GXBKs7hMUKa+7zEqTzVPUAvTYwyq
	aTyPRT1oHyaozxuqQbhjdPK+RFoUT8vdaEmcND5JkhDEPfhWzOsxggAe34cvRK9w3SSiFDqI
	GxIW7rM/SWxZEtftI5E41eIKFykU3N2v7pNLU5W0W6JUoQzi0rJ4scxf5qsQpShSJQm+Elq5
	l8/j+Qksie8nJ/aXLzJlasdjxdPPZIAp+2xgx4akP/xtZQxY2YFsBbBHH5cNtlt4EcCq3C+B
	zVgCsOjOKLalGKhpZNoCLQB295gIm5GFwdK6a6xswGYTpBc0mtlWgSPpBNcHmzYq4eQSA46Y
	SljWwE7SD/7dcW2jKoN8EdYabjGsWg4phI0jobZm7vDCeCfTynZkBDT3nsWtzCGfhb1fTTGs
	jJO7oKqxFLfWh+QdO3jf1MqwiUPgOdVPm7wTznQ3sGzsAu/ln2DZBDkArvT9jtkMDYAqtYqw
	ZQXDn3X/YNYX4aQHrGvZbXO7wi9+/BazdbaHeWtTm2vhwObzW+wOa+vKN8s4w5HHmZtMwZb6
	JsK27AoAF/RH1MCt5KmBSp4aqOT/zuUArwbOtEyRkkArBDI/CX30v0+Ok6ZowcbdeB5oBuN/
	PPTVA4wN9ACyca4j5/kcs8iBEy/6OI2WS2PkqWJaoQcCy8ILcJfn4qSWw5MoY/j+Qp5/QECA
	v3BPAJ/rxDEmfCdyIBNESjqZpmW0fEuHse1cMrCs+nc1s7HbPkihL0c8OiTUpWuKfT6bULfx
	Tt6c2VHuvd/Q7vnGJ2V1rgNeqooJgyv1UuQ7y38tDIah63O1ukCH5q5WY9Wcit/aEP0oInDy
	annvgOP5ZoM62j8oKpRzjBIHV/odXuOFrom5wihzWthyiuBNXnHtnkuKl+/FuRxF5suclV8O
	Tc6FCmZ7i4LVL5jPZg6fK9UuO/WduRJzPzI//c/FH+ojT7n2dybG7l0iGavTpo67zidM3le1
	B3SHjScXnnBCJorc0wvql6Wj/etvezCT3bwrojxK4+UdF2szc46gcC+i54LsU+3jXdsk657c
	QHr8w9t+aXFOXw/E51ZqYrkMRaKI74nLFaJ/AZLhC3bABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWy7bCSnG6IFmOSwetT5hZ7bn5mtVh9t5/N
	YtqHn8wW7w8+ZrWY1D+D3eLyEz6Lve9ms1pc+NHIZPF4038miz2LJjFZrFx9lMni+fLFjBad
	py8wWfx5aGhx9P9bNotJh64xWuy9pW2xZ+9JFov5y56yW3Rf38Fmse/1XmaL5cf/MVlM7LjK
	ZHFu1h82i22/5zNbHL53lcVi9R8Li9aen+wWr/bHOch6XL7i7TGx+R27R/OCOywel8+Wemxa
	1cnmsXlJvcfkG8sZPXbfbGDzaDpzlNljxqcvbB7Xz2xn8uhtfsfm8fHpLRaPbQ972T3e77vK
	5tG3ZRVjgEgUl01Kak5mWWqRvl0CV8bZBZ9YCyaIVEx7yt/A+ISvi5GTQ0LAROLc6q2sILaQ
	wA5Gie1fFCDikhLL/h5hhrCFJVb+e87excgFVNPMJDFz+nGgBg4ONgFtidP/OUBqRATEJf5c
	2MYIUsMsMJ1VouHUZSaQhLCAkcSvAzvBbBYBVYk1R++ygPTyClhKbL3mCjFfWWLhw4NgN3AK
	BEr8PzmHGeKeAIk/3x6xg9i8AoISJ2c+AWtlFlCXWD9PCCTMLCAv0bx1NvMERsFZSKpmIVTN
	QlK1gJF5FaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcOLQ0trBuGfVB71DjEwcjIcY
	JTiYlUR4Zbr/JwrxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TB
	KdXANCNoZuKXv03rd85RCvdddpDruUAuz8It5hJubhPTFmqnpWnELnFi/hlsduKkgJ6ka3xB
	d97lt0wOJ5qleDQllZZ/vb9L+KCcfMHhcvelBs33hbfMMl1c+1dJLVw49FFVytWQ1AeiP51P
	Jh5ece3bd6b0wtDzPlXJBZkyxznbH3JcjvfqCAnfqrZtR45BtFRv3M1j1veX5hdlBjwvMXHt
	ZOhZ/cugIrhUq6vl++n1PKvuNPF9XHO3PcpxY1IY/1f5Vx8ta18G1U3sEgx6f2Vm5JUTi0xL
	L7Vev3S089H2/tADPpNcN0uzuMgofOgOaw8/vJhzvXjDqq1Vp/5v1xZw53i+Ic+abb1Iyp9a
	uXYlluKMREMt5qLiRACU4PdziwMAAA==
X-CMS-MailID: 20220207141901epcas5p162ec2387815be7a1fd67ce0ab7082119
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220207141901epcas5p162ec2387815be7a1fd67ce0ab7082119
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<CGME20220207141901epcas5p162ec2387815be7a1fd67ce0ab7082119@epcas5p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 217EUhkb012673
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 08 Feb 2022 02:51:51 -0500
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, nj.shetty@samsung.com, zach.brown@ni.com,
	chaitanyak@nvidia.com, msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: [dm-devel] [PATCH v2 00/10] Add Copy offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
cm9hY2ggZm9yIDIgYmRldgppbXBsZW1lbnRhdGlvbi4KCgpUaGlzIGlzIG9uIHRvcCBvZiBvdXIg
cHJldmlvdXMgcGF0Y2hzZXQgdjFbMV0uCk92ZXJhbGwgc2VyaWVzIHN1cHBvcnRzIOKAkwoKMS4g
RHJpdmVyCi0gTlZNZSBDb3B5IGNvbW1hbmQgKHNpbmdsZSBOUyksIGluY2x1ZGluZyBzdXBwb3J0
IGluIG52bWUtdGFyZ2V0IChmb3IKCWJsb2NrIGFuZCBmaWxlIGJhY2tlbmQpCgoyLiBCbG9jayBs
YXllcgotIEJsb2NrLWdlbmVyaWMgY29weSAoUkVRX0NPUFkgZmxhZyksIHdpdGggaW50ZXJmYWNl
IGFjY29tbW9kYXRpbmcKCXR3byBibG9jay1kZXZzLCBhbmQgbXVsdGktc291cmNlL2Rlc3RpbmF0
aW9uIGludGVyZmFjZQotIEVtdWxhdGlvbiwgd2hlbiBvZmZsb2FkIGlzIG5hdGl2ZWx5IGFic2Vu
dAotIGRtLWxpbmVhciBzdXBwb3J0IChmb3IgY2FzZXMgbm90IHJlcXVpcmluZyBzcGxpdCkKCjMu
IFVzZXItaW50ZXJmYWNlCi0gbmV3IGlvY3RsCgo0LiBJbi1rZXJuZWwgdXNlcgotIGRtLWtjb3B5
ZAoKWzBdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUvQ0ErMUUzcko3Qlo3TGpR
WFhUZFgrLTBFZHo9elQxNG1tUEdNaVZDelVnQjMzQzYwdGJRQG1haWwuZ21haWwuY29tLwpbMV0g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYmxvY2svMjAyMTA4MTcxMDE0MjMuMTIzNjct
MS1zZWx2YWt1bWEuczFAc2Ftc3VuZy5jb20vCgpBcm5hdiBEYXduICgxKToKICBudm1ldDogYWRk
IGNvcHkgY29tbWFuZCBzdXBwb3J0IGZvciBiZGV2IGFuZCBmaWxlIG5zCgpOaXRlc2ggU2hldHR5
ICg2KToKICBibG9jazogSW50cm9kdWNlIHF1ZXVlIGxpbWl0cyBmb3IgY29weS1vZmZsb2FkIHN1
cHBvcnQKICBibG9jazogQWRkIGNvcHkgb2ZmbG9hZCBzdXBwb3J0IGluZnJhc3RydWN0dXJlCiAg
YmxvY2s6IEludHJvZHVjZSBhIG5ldyBpb2N0bCBmb3IgY29weQogIGJsb2NrOiBhZGQgZW11bGF0
aW9uIGZvciBjb3B5CiAgZG06IEFkZCBzdXBwb3J0IGZvciBjb3B5IG9mZmxvYWQuCiAgZG06IEVu
YWJsZSBjb3B5IG9mZmxvYWQgZm9yIGRtLWxpbmVhciB0YXJnZXQKClNlbHZhS3VtYXIgUyAoMyk6
CiAgYmxvY2s6IG1ha2UgYmlvX21hcF9rZXJuKCkgbm9uIHN0YXRpYwogIG52bWU6IGFkZCBjb3B5
IHN1cHBvcnQKICBkbSBrY29weWQ6IHVzZSBjb3B5IG9mZmxvYWQgc3VwcG9ydAoKIGJsb2NrL2Js
ay1saWIuYyAgICAgICAgICAgICAgICAgICB8IDMzNSArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysKIGJsb2NrL2Jsay1tYXAuYyAgICAgICAgICAgICAgICAgICB8ICAgMiArLQogYmxvY2sv
YmxrLXNldHRpbmdzLmMgICAgICAgICAgICAgIHwgICA2ICsKIGJsb2NrL2Jsay1zeXNmcy5jICAg
ICAgICAgICAgICAgICB8ICA1MSArKysrKwogYmxvY2svYmxrLmggICAgICAgICAgICAgICAgICAg
ICAgIHwgICAyICsKIGJsb2NrL2lvY3RsLmMgICAgICAgICAgICAgICAgICAgICB8ICAzNyArKysr
CiBkcml2ZXJzL21kL2RtLWtjb3B5ZC5jICAgICAgICAgICAgfCAgNTcgKysrKy0KIGRyaXZlcnMv
bWQvZG0tbGluZWFyLmMgICAgICAgICAgICB8ICAgMSArCiBkcml2ZXJzL21kL2RtLXRhYmxlLmMg
ICAgICAgICAgICAgfCAgNDMgKysrKwogZHJpdmVycy9tZC9kbS5jICAgICAgICAgICAgICAgICAg
IHwgICA2ICsKIGRyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYyAgICAgICAgICB8IDEyMSArKysrKysr
KysrLQogZHJpdmVycy9udm1lL2hvc3QvbnZtZS5oICAgICAgICAgIHwgICA3ICsKIGRyaXZlcnMv
bnZtZS9ob3N0L3BjaS5jICAgICAgICAgICB8ICAgOSArCiBkcml2ZXJzL252bWUvaG9zdC90cmFj
ZS5jICAgICAgICAgfCAgMTkgKysKIGRyaXZlcnMvbnZtZS90YXJnZXQvYWRtaW4tY21kLmMgICB8
ICAgOCArLQogZHJpdmVycy9udm1lL3RhcmdldC9pby1jbWQtYmRldi5jIHwgIDY2ICsrKysrKwog
ZHJpdmVycy9udm1lL3RhcmdldC9pby1jbWQtZmlsZS5jIHwgIDQ4ICsrKysrCiBpbmNsdWRlL2xp
bnV4L2Jsa190eXBlcy5oICAgICAgICAgfCAgMjAgKysKIGluY2x1ZGUvbGludXgvYmxrZGV2Lmgg
ICAgICAgICAgICB8ICAxNyArKwogaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggICAgIHwg
ICA1ICsKIGluY2x1ZGUvbGludXgvbnZtZS5oICAgICAgICAgICAgICB8ICA0MyArKystCiBpbmNs
dWRlL3VhcGkvbGludXgvZnMuaCAgICAgICAgICAgfCAgMjMgKysKIDIyIGZpbGVzIGNoYW5nZWQs
IDkxMiBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKCi0tIAoyLjMwLjAtcmMwCgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==


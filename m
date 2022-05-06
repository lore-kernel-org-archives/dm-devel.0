Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E64C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 07:53:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-KS0fiFB9Oge67nFlIOnngQ-1; Mon, 09 May 2022 03:53:30 -0400
X-MC-Unique: KS0fiFB9Oge67nFlIOnngQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A29FB8117B0;
	Mon,  9 May 2022 07:53:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AB682026D64;
	Mon,  9 May 2022 07:53:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F10AF194704E;
	Mon,  9 May 2022 07:53:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C55D41947056
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 12:57:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B05420296A9; Fri,  6 May 2022 12:57:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5435F200BA83
 for <dm-devel@redhat.com>; Fri,  6 May 2022 12:57:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 934A4185A7B2
 for <dm-devel@redhat.com>; Fri,  6 May 2022 12:57:07 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-cB58n7VWP6mF9byduLDv9A-1; Fri, 06 May 2022 08:57:05 -0400
X-MC-Unique: cB58n7VWP6mF9byduLDv9A-1
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246Bhea4032518;
 Fri, 6 May 2022 12:57:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw3279f12-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 06 May 2022 12:57:04 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246C6GE0009740;
 Fri, 6 May 2022 12:57:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.98])
 by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw3279f0m-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 06 May 2022 12:57:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
 by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246CrK4Z028206;
 Fri, 6 May 2022 12:57:02 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com
 (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
 by ppma03ams.nl.ibm.com with ESMTP id 3ftp7fwgbx-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 06 May 2022 12:57:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com
 [9.149.105.59])
 by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 246Cv0dI39256422
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 6 May 2022 12:57:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id F2900A4053;
 Fri,  6 May 2022 12:56:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 1CD1EA4040;
 Fri,  6 May 2022 12:56:59 +0000 (GMT)
Received: from [9.145.54.141] (unknown [9.145.54.141])
 by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Fri,  6 May 2022 12:56:59 +0000 (GMT)
Message-ID: <1f26f6b4-4d33-6291-31c2-5cb68a5be829@linux.ibm.com>
Date: Fri, 6 May 2022 14:56:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-8-hch@lst.de>
From: =?UTF-8?Q?Jan_H=c3=b6ppner?= <hoeppner@linux.ibm.com>
In-Reply-To: <20220418045314.360785-8-hch@lst.de>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8a7-K9CSYxb93olkIOkZv_aoAnTW7JGG
X-Proofpoint-GUID: MVmeZnFqL5lpsQIB56qwcq7OjT6X-h0N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060070
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-001b2d01.pphosted.com id 246Bhea4032518
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Mon, 09 May 2022 07:53:25 +0000
Subject: Re: [dm-devel] [PATCH 07/11] dasd: don't set the discard_alignment
 queue limit
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
Cc: linux-block@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Richard Weinberger <richard@nod.at>,
 Jason Wang <jasowang@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-um@lists.infradead.org, Song Liu <song@kernel.org>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Stefan Haberland <sth@linux.ibm.com>, xen-devel@lists.xenproject.org,
 Johannes Berg <johannes@sipsolutions.net>,
 virtualization@lists.linux-foundation.org, Jack Wang <jinpu.wang@ionos.com>,
 =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTgvMDQvMjAyMiAwNjo1MywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVGhlIGRpc2Nh
cmRfYWxpZ25tZW50IHF1ZXVlIGxpbWl0IGlzIG5hbWVkIGEgYml0IG1pc2xlYWRpbmcgbWVhbnMg
dGhlCj4gb2Zmc2V0IGludG8gdGhlIGJsb2NrIGRldmljZSBhdCB3aGljaCB0aGUgZGlzY2FyZCBn
cmFudWxhcml0eSBzdGFydHMuCj4gU2V0dGluZyBpdCB0byBQQUdFX1NJWkUgd2hpbGUgdGhlIGRp
c2NhcmQgZ3JhbnVsYXJpdHkgaXMgdGhlIGJsb2NrIHNpemUKPiB0aGF0IGlzIHNtYWxsZXIgb3Ig
dGhlIHNhbWUgYXMgUEFHRV9TSVpFIGFzIGRvbmUgYnkgZGFzZCBpcyBtb3N0bHkKPiBoYXJtbGVz
cyBidXQgYWxzbyB1c2VsZXNzLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2ln
IDxoY2hAbHN0LmRlPgoKQWNrZWQtYnk6IEphbiBIw7ZwcG5lciA8aG9lcHBuZXJAbGludXguaWJt
LmNvbT4KClNvcnJ5IGZvciBhIHJhdGhlciBsYXRlIGFuc3dlci4gSSBzYXcgdGhhdCBKZW5zIGFs
cmVhZHkgYXBwbGllZAp0aGUgcGF0Y2hlcyBzbyBpdCdzIGZpbmUgd2hlbiB0aGUgQWNrIGlzbid0
IGFkZGVkIGFueW1vcmUuCldhbnRlZCB0byBzZW5kIGl0IGFueXdheSBzbyB0aGF0IHlvdSBrbm93
IHdlJ3JlIGF3YXJlIG9mIGl0LgoKPiAtLS0KPiAgZHJpdmVycy9zMzkwL2Jsb2NrL2Rhc2RfZmJh
LmMgfCAxIC0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkKPiAKPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zMzkwL2Jsb2NrL2Rhc2RfZmJhLmMgYi9kcml2ZXJzL3MzOTAvYmxvY2svZGFz
ZF9mYmEuYwo+IGluZGV4IDhiZDU2NjVkYjkxOTguLjYwYmU3ZjdiZjJkMTYgMTAwNjQ0Cj4gLS0t
IGEvZHJpdmVycy9zMzkwL2Jsb2NrL2Rhc2RfZmJhLmMKPiArKysgYi9kcml2ZXJzL3MzOTAvYmxv
Y2svZGFzZF9mYmEuYwo+IEBAIC03ODIsNyArNzgyLDYgQEAgc3RhdGljIHZvaWQgZGFzZF9mYmFf
c2V0dXBfYmxrX3F1ZXVlKHN0cnVjdCBkYXNkX2Jsb2NrICpibG9jaykKPiAgCWJsa19xdWV1ZV9z
ZWdtZW50X2JvdW5kYXJ5KHEsIFBBR0VfU0laRSAtIDEpOwo+ICAKPiAgCXEtPmxpbWl0cy5kaXNj
YXJkX2dyYW51bGFyaXR5ID0gbG9naWNhbF9ibG9ja19zaXplOwo+IC0JcS0+bGltaXRzLmRpc2Nh
cmRfYWxpZ25tZW50ID0gUEFHRV9TSVpFOwo+ICAKPiAgCS8qIENhbGN1bGF0ZSBtYXhfZGlzY2Fy
ZF9zZWN0b3JzIGFuZCBtYWtlIGl0IFBBR0UgYWxpZ25lZCAqLwo+ICAJbWF4X2J5dGVzID0gVVNI
UlRfTUFYICogbG9naWNhbF9ibG9ja19zaXplOwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=


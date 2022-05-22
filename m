Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD025C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 07:23:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-ZdlVdgjgMqOJlLbAKrqDNw-1; Wed, 25 May 2022 03:23:00 -0400
X-MC-Unique: ZdlVdgjgMqOJlLbAKrqDNw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48D7B857A80;
	Wed, 25 May 2022 07:22:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D1E2112131B;
	Wed, 25 May 2022 07:22:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04FA5194EB83;
	Wed, 25 May 2022 07:22:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B77F01947057
 for <dm-devel@listman.corp.redhat.com>; Sun, 22 May 2022 22:07:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97E46401E89; Sun, 22 May 2022 22:07:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 929BC401E4C
 for <dm-devel@redhat.com>; Sun, 22 May 2022 22:07:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7605C3C02B66
 for <dm-devel@redhat.com>; Sun, 22 May 2022 22:07:31 +0000 (UTC)
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-vgOH9oZ7P-29xwUdpx19gA-1; Sun, 22 May 2022 18:07:29 -0400
X-MC-Unique: vgOH9oZ7P-29xwUdpx19gA-1
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
 by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id
 20220522220141usoutp025a96a23b1ee25774022f99d708b14e18~xjGSGOTvT1556715567usoutp02t;
 Sun, 22 May 2022 22:01:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com
 20220522220141usoutp025a96a23b1ee25774022f99d708b14e18~xjGSGOTvT1556715567usoutp02t
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
 [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220522220140uscas1p22d4a147918cf989a4404f62fa141dfc1~xjGRLL0Rz2024220242uscas1p2I;
 Sun, 22 May 2022 22:01:40 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
 ussmges2new.samsung.com (USCPEMTA) with SMTP id FA.1F.09642.4C2BA826; Sun,
 22 May 2022 18:01:40 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
 [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220522220139uscas1p1e3426b4457e0753c701e9917fe3ec6d2~xjGQI9cZg2083020830uscas1p1R;
 Sun, 22 May 2022 22:01:39 +0000 (GMT)
X-AuditID: cbfec36f-c15ff700000025aa-e5-628ab2c4ddd4
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
 ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id CE.A4.52945.3C2BA826; Sun,
 22 May 2022 18:01:39 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
 SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.2375.24; Sun, 22 May 2022 15:01:38 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
 SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Sun,
 22 May 2022 15:01:38 -0700
From: Adam Manzanares <a.manzanares@samsung.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [ANNOUNCE] CFP: Zoned Storage Microconference - Linux Plumbers
 Conference 2022
Thread-Index: AQHYbieCqwy4fi3r20GqJMCAwVTLug==
Date: Sun, 22 May 2022 22:01:38 +0000
Message-ID: <20220522220128.GA347919@bgt-140510-bm01>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se1BMcRTH53fv3bu3rXRbTR2tYaxpUGMrI9awCs1YhsljGPK8dFWqLXvL
 c0iGURvNhlJbXtXUSimL1qTH9JjUJr2kJo8mCjsGkVIobDej/z7nd8739/2emUPh4tsCZypY
 FcmqVUyolBQRRTUDjXOrDZo9HgXJzvLST2kCeUnGBUxe2ukmb3mjF8pLSusIeWtxOinXG6sJ
 eYe2F/lQSkNuHKmMbxtCys9lbaTybv0xZb9h2jqBv2hJABsafJBVuy/dLQq6UpAojHgFhxsT
 B4Un0TnQICsK6PlQ12dGGiSixPRNBJmabNLSENNnMHj80PvfUFfWe4wfykcwXHyW5IuvCG4U
 5Aj5IhtB3LXrmEVC0h7w89Ed3MIO9DJ4UDEwpsDpLgxiTUXI0phMb4XKlA8kP7QTWspiEM8y
 OJVeItAgiiJoFzA3bLE829JekJX9lLAwoh3huylvzAunnaCz5xrGR7WHjLQSnGdHGC3uJnme
 AV3fzULLlzg9BwqK3XnpUtBWpxI8z4BL8d1C3soe6lJ7CF46BSr0HeNcS0HK89U8+8JHU8O4
 lQQu57USlhWBPougT1sm4Astghcfh8dDLIbRuGdC3m0SjPx4jbRopm7CDrr/+XQT8ukm5NNN
 yHcdCXKRUxTHhQWy3DwVe0jGMWFclCpQtjc8zID+nlT9aFX4A9Te+UVWiTAKVSKgcKmDrZGJ
 3SO2DWCOHGXV4bvUUaEsV4kkFCF1ss0OLmTEdCATyYawbASr/tfFKCvnk1jMcSqBPOD3ayRm
 X33VoobkxFWZL4mmhC1PfLDJ7jnbnij6U73zexpr1obfOlXhepCZWg6nbfA3bbcuZSqyQPHC
 OH1W3I5uhd/25Y7bnn+bNmJcaFdYkx5y9SIu9Huda5Xla03tX7vV3iNhekaHg6hrtX1rTjmW
 O8eYuDHz3lBLffzbBe8MsGHeeefbJk52QjXVqDf5f8B9mmvbOavLm6j1ZYpVy62Tvtmd8ZSa
 3RzcJO83b5itj5H0apNX9I20Od3vjng1tObK+YX7GvtdBpPo6KDm2RmU/+90O9/SpFHZz9TI
 NYRZH2BemWaKDltUGDvJ8Zcr4X5xf9Nxu/uxNkVeEinBBTGerriaY/4AZk1MI8EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWS2cA0Uffwpq4kgwnbxS32vpvNarFn0SQm
 i723tC0uPV7BbrFn70kWi8u75rBZrNh+hMXixoSnjA4cHptWdbJ5dF/9wejxft9VNo/Np6s9
 Pm+SC2CN4rJJSc3JLEst0rdL4MqYu34ie8E9iYrzE7+xNzD2SHQxcnJICJhI3F/ygqmLkYtD
 SGA1o8SF7xOgnE+MEqdal7BBOMsYJb59P8QI0sImYCDx+/hGZhBbRMBRYsfBr2BFzAL3mSQ6
 Tm0DKxIWiJQ4NOM1G0RRnMSXAz+hbD2Jpjl7WLsYOThYBFQlXp6NAAnzCphKLFl2hQXEZhQQ
 k/h+ag0TiM0sIC5x68l8JohTBSSW7DnPDGGLSrx8/I8VwlaUuP/9JTvISGYBTYn1u/QhWu0k
 JhyZyQJhK0pM6X7IDrFKUOLkzCcsEK2SEgdX3GCZwCg2C8m2WQiTZiGZNAvJpFlIJi1gZF3F
 KF5aXJybXlFsnJdarlecmFtcmpeul5yfu4kRGK+n/x2O2cF479ZHvUOMTByMhxglOJiVRHi3
 J3YkCfGmJFZWpRblxxeV5qQWH2KU5mBREuf1iJ0YLySQnliSmp2aWpBaBJNl4uCUamAyYJ40
 /8xEpintW1gCefyVuuZEv9+ptHjxrdjbMq8PLZ+XuC3n/W3P+VzVZ4TS/LmX8+5qdzU7pvg8
 KXE2U/1SDbPjZTnG/msmSPsqiXxc9uTvd/3zk9qnFIdd7o3LWPpoqXM5y73UOQESQg3zBERK
 dTwfSyTxTneOexC19pdTkdOPT0kt4Xud3Nuk9mzkuhi+NvHAtPRXyo+OaT5SPrfUYk1le+LO
 T+8bz6vt7O3rnLV38nOBGU/LLzhw8TZnhcY8912/cvWb0K87HToTP5dGuN1snb72QD5X1nuB
 XW5zvDe57bDiTPd26e88Xy56vl0l6voq+/Y7XkdVGnXvFWzfeONLubbgraWssa/a3r5SYinO
 SDTUYi4qTgQA4u756EYDAAA=
X-CMS-MailID: 20220522220139uscas1p1e3426b4457e0753c701e9917fe3ec6d2
CMS-TYPE: 301P
X-CMS-RootMailID: 20220522220139uscas1p1e3426b4457e0753c701e9917fe3ec6d2
References: <CGME20220522220139uscas1p1e3426b4457e0753c701e9917fe3ec6d2@uscas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 25 May 2022 07:22:55 +0000
Subject: [dm-devel] [ANNOUNCE] CFP: Zoned Storage Microconference - Linux
 Plumbers Conference 2022
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "mb@lightnvm.io" <mb@lightnvm.io>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <597CF64C8C3AE644ACFB3A70A5B9FCE2@ssi.samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Wm9uZWQgU3RvcmFnZSBEZXZpY2VzIChTTVIgSEREcyBhbmQgWk5TIFNTRHMpIGhhdmUgZGVtb25z
dHJhdGVkIHRoYXQgdGhleSBjYW4NCmltcHJvdmUgc3RvcmFnZSBjYXBhY2l0eSwgdGhyb3VnaHB1
dCwgYW5kIGxhdGVuY3kgb3ZlciBjb252ZW50aW9uYWwgc3RvcmFnZQ0KZGV2aWNlcyBmb3IgbWFu
eSB3b3JrbG9hZHMuIFpvbmVkIHN0b3JhZ2UgdGVjaG5vbG9neSBpcyBkZXBsb3llZCBhdCBzY2Fs
ZSBpbg0Kc29tZSBvZiB0aGUgbGFyZ2VzdCBkYXRhIGNlbnRlcnMgaW4gdGhlIHdvcmxkLiBUaGVy
ZSdzIGFscmVhZHkgYQ0Kd2VsbC1lc3RhYmxpc2hlZCBzZXQgb2Ygc3RvcmFnZSB2ZW5kb3JzIHdp
dGggaW5jcmVhc2luZyBkZXZpY2UgYXZhaWxhYmlsaXR5IGFuZA0KYSBtYXR1cmUgc29mdHdhcmUg
Zm91bmRhdGlvbiBmb3IgaW50ZXJhY3Rpbmcgd2l0aCB6b25lZCBzdG9yYWdlIGRldmljZXMgaXMN
CmF2YWlsYWJsZS4gWm9uZWQgc3RvcmFnZSBzb2Z0d2FyZSBzdXBwb3J0IGlzIGV2b2x2aW5nIGFu
ZCB0aGVpciBpcyByb29tIGZvcg0KaW5jcmVhc2VkIGZpbGUtc3lzdGVtIHN1cHBvcnQgYW5kIGFk
ZGl0aW9uYWwgdXNlcnNwYWNlIGFwcGxpY2F0aW9ucy4NCg0KVGhlIFpvbmVkIFN0b3JhZ2UgbWlj
cm9jb25mZXJlbmNlIGZvY3VzZXMgb24gZXZvbHZpbmcgdGhlIExpbnV4IHpvbmVkIA0Kc3RvcmFn
ZSBlY29zeXN0ZW0gYnkgaW1wcm92aW5nIGtlcm5lbCBzdXBwb3J0LCBmaWxlIHN5c3RlbXMsIGFu
ZCBhcHBsaWNhdGlvbnMuDQpJbiBhZGRpdGlvbiwgdGhlIGZvcnVtIGFsbG93cyB1cyB0byBvcGVu
IHRoZSBkaXNjdXNzaW9uIHRvIGluY29ycG9yYXRlIGFuZCBncm93DQp0aGUgem9uZWQgc3RvcmFn
ZSBjb21tdW5pdHkgbWFraW5nIHN1cmUgdG8gbWVldCBldmVyeW9uZSdzIG5lZWRzIGFuZA0KZXhw
ZWN0YXRpb25zLiBGaW5hbGx5LCBpdCBpcyBhbiBleGNlbGxlbnQgb3Bwb3J0dW5pdHkgZm9yIGFu
eW9uZSBpbnRlcmVzdGVkIGluDQp6b25lZCBzdG9yYWdlIGRldmljZXMgdG8gbWVldCBhbmQgZGlz
Y3VzcyBob3cgd2UgY2FuIG1vdmUgdGhlIGVjb3N5c3RlbSBmb3J3YXJkDQp0b2dldGhlci4NCg0K
U3VnZ2VzdGVkIHRvcGljczoNCg0KICAgIC0gRWNvc3lzdGVtICYgQXJjaGl0ZWN0dXJhbCByZXZp
ZXcNCiAgICAtIFlvdXIgam91cm5leSB1c2luZyBvciBlbmFibGluZyB6b25lZCBzdG9yYWdlIGRl
dmljZXMNCiAgICAtIEN1cnJlbnQgYW5kIGZ1dHVyZSBrZXJuZWwgd29yayAobm9uLXBvd2VyIG9m
IDIgem9uZXMsIHN3YXAgDQpzdXBwb3J0LCByYWlkLCBsb2ctc3RydWN0dXJlZCBibG9jayBkZXZp
Y2VzIOKApikNCiAgICAtIFFlbXUgc3VwcG9ydCBub3cgYW5kIGxhdGVyDQogICAgLSBTUERLIHN1
cHBvcnQgbm93IGFuZCBsYXRlcg0KICAgIC0gRmlsZSBzeXN0ZW1zIHN1cHBvcnQgbm93IGFuZCBs
YXRlciAoZjJmcywgYnRyZnMsIHpvbmVmcywgLi4uKQ0KICAgIC0gQXBwbGljYXRpb24gc3VwcG9y
dCBub3cgYW5kIGxhdGVyIChDYWNoZUxpYiwgQ2Fzc2FuZHJhLCBDZXBoLCANCkhERlMsIFJvY2tz
REIsIE15U1FMLCBUZXJhcmtEQiwgeW91ciBmYXZvcml0ZSBhcHBsaWNhdGlvbiwg4oCmKQ0KICAg
IC0gVG9vbHMgYW5kIGxpYnJhcmllcyByZWxhdGVkIHRvIHpvbmVkIHN0b3JhZ2UgZGV2aWNlcyAo
Ymxrem9uZSwgDQpmaW8sIGxpYnpiZCwgbnZtZS1jbGksIHhudm1lLCB4enRsLCDigKYpDQogICAg
LSBEZWJ1Z2dpbmcgdG9vbHMgYW5kIGFwcHJvYWNoZXMNCg0KDQpJZiB5b3UgYXJlIGludGVyZXN0
ZWQgaW4gcGFydGljaXBhdGluZyBpbiB0aGlzIG1pY3JvY29uZmVyZW5jZSBhbmQgaGF2ZSANCnRv
cGljcyB0byBwcm9wb3NlLCBwbGVhc2UgdXNlIHRoZSBMUEMgQ0ZQIHByb2Nlc3MgWzFdLCBhbmQg
c2VsZWN0ICJab25lIA0KU3RvcmFnZSBNQyIgZm9yIHRoZSAiVHJhY2siLg0KDQpUaGUgc3VibWlz
c2lvbiBkZWFkbGluZSBpcyBKdW5lIDMwLg0KDQpDb21lIGFuZCBqb2luIHVzIGluIHRoZSBkaXNj
dXNzaW9uLiBXZSBob3BlIHRvIHNlZSB5b3UgdGhlcmUhDQoNCkZvciBtb3JlIGluZm9ybWF0aW9u
LCBmZWVsIGZyZWUgdG8gY29udGFjdCB0aGUgWm9uZWQgU3RvcmFnZSBNQyBMZWFkczoNCiAgICBB
ZGFtIE1hbnphbmFyZXMgPGEubWFuemFuYXJlc0BzYW1zdW5nLmNvbT4NCiAgICBMdWlzIENoYW1i
ZXJsYWluIDxtY2dyb2ZAa2VybmVsLm9yZz4NCiAgICBNYXRpYXMgQmrDuHJsaW5nIDxtYkBsaWdo
dG52bS5pbz4NCiAgICBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NCg0KWzFdIGh0dHBz
Oi8vbHBjLmV2ZW50cy9ldmVudC8xNi9hYnN0cmFjdHMvCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK


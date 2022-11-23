Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C87AC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 08:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669191961;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5AmNg1V/nUITN+0N/CcODQYUGEySNlielHle0RbiKXU=;
	b=O/PzSxvAus+MrTN4mQ9XJEjKwYKt/seNVaigkYUUpZEsurPrRkhatPlpGidX5UtqnpzPIS
	nC5Y8c9DxiLfX6ZsWkm7n1hHoFyJnE0gYItQJQjhFdEhZ9IkT68zViZQnVTXHECbE29IA4
	STm4XbMUQrDEUbSM/r2P3nnYASB5Uk4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-Y_jLKKijOp2IKcqZcHb0lA-1; Wed, 23 Nov 2022 03:25:59 -0500
X-MC-Unique: Y_jLKKijOp2IKcqZcHb0lA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74F2429DD999;
	Wed, 23 Nov 2022 08:25:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C19240C83D9;
	Wed, 23 Nov 2022 08:25:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC25D1946A45;
	Wed, 23 Nov 2022 08:25:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE2E7194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 06:21:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C21364A9256; Wed, 23 Nov 2022 06:21:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B925C4A9254
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 994941C05B0A
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:09 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-UTlSl6TiMOCcxUSiD6yR7w-1; Wed, 23 Nov 2022 01:21:07 -0500
X-MC-Unique: UTlSl6TiMOCcxUSiD6yR7w-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20221123061327epoutp02d2243508e478e501e1b5e8bb9d8a5ef1~qIgLC8q0D1821418214epoutp021
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:13:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20221123061327epoutp02d2243508e478e501e1b5e8bb9d8a5ef1~qIgLC8q0D1821418214epoutp021
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20221123061326epcas5p1885bf1308a88e8eff224df73c203fb5d~qIgKc2Z0n0806708067epcas5p1V;
 Wed, 23 Nov 2022 06:13:26 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4NH9mN24Txz4x9Pp; Wed, 23 Nov
 2022 06:13:24 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 AC.17.56352.40ABD736; Wed, 23 Nov 2022 15:13:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20221123061024epcas5p28fd0296018950d722b5a97e2875cf391~qIdhHT_sF0604106041epcas5p2s;
 Wed, 23 Nov 2022 06:10:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221123061024epsmtrp256f8d5870cea901380bcaafd9741ed60~qIdhGOQih0451404514epsmtrp2V;
 Wed, 23 Nov 2022 06:10:24 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-db-637dba0497f2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 FA.B2.18644.059BD736; Wed, 23 Nov 2022 15:10:24 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20221123061021epsmtip1ff00839ccb85553e37f8279ede1fac88~qIdd9k6Z32063320633epsmtip1C;
 Wed, 23 Nov 2022 06:10:21 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 james.smart@broadcom.com, kch@nvidia.com, damien.lemoal@opensource.wdc.com,
 naohiro.aota@wdc.com, jth@kernel.org, viro@zeniv.linux.org.uk
Date: Wed, 23 Nov 2022 11:28:21 +0530
Message-Id: <20221123055827.26996-5-nj.shetty@samsung.com>
In-Reply-To: <20221123055827.26996-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te1BUZRT3u/fu3QWkLo/0A8PWTWuAeCws8EEQTVJewwhoDMUmXOEGDMvu
 ug/FiHFNGBaK58SjhQkSI0EH4o2LMLQGyCJSw4hCIFIwBQ5QQYPNytAuF8r/ft/vd875nXO+
 OTzcvozrzEuWqhiFVCwRkNZE+01XVw9CnxHvPVTDQ43Gfhx9WriOo6tTBSQyDY/gqHupgoPG
 e69j6MalYgzVXe3DUNfXf2Lo18kVLurbWCTRzOoEgYoNYwDN3dVhqHvCHd3oHiTQqL6SRFW1
 c1xUNNDCQZ2zFwBqN1XhaOWbTC5qeLRMoFsTe9DI+gDndSdaNz1M0td1U1x65EETQY8Oq+nm
 +hySbrl8nu4a15B03sUlc0DWNIde7rlL0vmt9YBuGUqnV5r30tm9n2F08+wiFvlsbEpwEiNO
 YBR8RhovS0iWJoYIwt+LOxjn5+8t9BAGogABXypOZUIEYUciPd5Klpi3IeCfEUvUZipSrFQK
 vF4LVsjUKoafJFOqQgSMPEEiF8k9leJUpVqa6CllVEFCb28fP3PgyZSk9r+HCPkTQdpjTS2u
 AYbnc4EVD1IiuFZzh8wF1jx7qgvAS6UlmEWwp/4CUHtHxgorAJbd1+LbGdfmezmsoAdw8OFF
 gn1kYbBq/gnIBTweSbnDoQ2ehXek8jGo7erdzMYpEwZLixwt2IEKhf2azE07gjoAtTO3CAu2
 pYKgVnt7sw6kvGDBtJ2FtqJehbd/0mNsiB0c/HKWYEu+AC+2VeAWL0gZraB2NX+r0zA4W2Ak
 WOwAFwZauSx2hitL3SSLz8K6L66QbHImgLp7OsAKoTDLWIBbmsApV9io92JpF1hibMBY42dg
 nmkWY3lb2PnVNn4RXmus3qrvBMfWLmxhGtZX9gJ2WfkAlmRPcAoBX/fUQLqnBtL9b10N8Hrg
 xMiVqYmM0k/uK2XO/vfL8bLUZrB5IW7hneCXh394GgDGAwYAebjA0fb84U/i7W0TxOc+ZhSy
 OIVawigNwM+88CLc+bl4mfnEpKo4oSjQW+Tv7y8K9PUXCnbb1pS7xdtTiWIVk8IwckaxnYfx
 rJw1mI21qS1A+q20Ijpncj5MgrdVlx1f/v5+5ZmpkOb0mFe847wiPgj4cMFxo/Yot/xYsUPq
 jCHaVUuO+xJ9wTYdQL+jiZJk7dh1VLQ/9tAV3/Bj8u9gg9Ok+9wB9O7l+vAHXM97b7u877Pb
 5UgA3271x5bowkGfxQr/feUny3RReWvUKbeIwIyqnj1MeOKhHyIzcsqjag0dMb9vRMR85LqU
 +MbLml39Eq3poElu021sHyrtK+4ZTXvJdmex2mQlHTsd+pvT/GMsrfXRm6cy3zlXNzx7eP1E
 UmjU56NNx9eYggXF6XRPzt5ofF/Qif1YxGRLz828ne4ipUNHyc81sZ3/zGePBGkEhDJJLHTD
 FUrxv4FABlOqBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsWy7bCSnG7Aztpkgw/TVS3WnzrGbNE04S+z
 xeq7/WwWv8+eZ7bY+242q8XNAzuZLPYsmsRksXL1USaL3Qs/Mlk8vvOZ3eLo/7dsFg+/3GKx
 mHToGqPF06uzmCz23tK22LP3JIvF5V1z2CzmL3vKbjHx+GZWix1PGhkttv2ez2zxeWkLu8W6
 1+9ZLE7ckrY4//c4q4Okx6z7Z9k8ds66y+5x/t5GFo/LZ0s9Nq3qZPPYvKTeY/fNBjaP3uZ3
 QAWt91k93u+7yubRt2UVo8fm09UenzfJebQf6Gby2PTkLVMAfxSXTUpqTmZZapG+XQJXxrav
 p1kK/ihV/GhYxtzAeEimi5GTQ0LARGLNywOsILaQwA5GiRmPBSDikhLL/h5hhrCFJVb+e87e
 xcgFVNPMJPHswCLGLkYODjYBbYnT/zlA4iICC5gkLt97xQziMAu0M0t8mbsCrFtYwF7iWEML
 E4jNIqAq0fHwBAuIzStgJdHRcQZskISAvkT/fUGQMKeAtcSZi7uYQMJCQCV7lulAVAtKnJz5
 hAUkzCygLrF+nhBImFlAXqJ562zmCYyCs5BUzUKomoWkagEj8ypGydSC4tz03GLDAqO81HK9
 4sTc4tK8dL3k/NxNjOBkoKW1g3HPqg96hxiZOBgPMUpwMCuJ8NZ71iQL8aYkVlalFuXHF5Xm
 pBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwJQRt4P31NmVVg385ebXH9RNuh0q
 fbN0y5cz0We92IIXMbIc7Y8oVGk/K3Gh87DslpkPJ6x+snL9lRzrBR4b66XZpvF/2PhIXfxO
 pM0USe/z+Yr6SyRmb1A4G62UUrnC1jd855nV4k9DlDZ4zpiq59wSsui6f+zKQ3vn23MY7Kr8
 v/LmkuYsYc/wdbw5jye5O8g9TA3IZ18VU3o8VEX0z4RrFhsE/+/uWpRd/t+X59ZGz0v8UwVj
 xPh3ZrpGufRlnxLvW7RYwvP91t7lxfOzi38qTWPbtnEtw4kbrFVv43aozf108k3+FFmmwwGi
 R6Kbmr5z8nNceCpReTrraEyXzJ31fmeWTMgNetcRnt1lM1OJpTgj0VCLuag4EQDA19x3dQMA
 AA==
X-CMS-MailID: 20221123061024epcas5p28fd0296018950d722b5a97e2875cf391
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061024epcas5p28fd0296018950d722b5a97e2875cf391
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061024epcas5p28fd0296018950d722b5a97e2875cf391@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 23 Nov 2022 08:25:56 +0000
Subject: [dm-devel] [PATCH v5 04/10] block: Introduce a new ioctl for copy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
dGwuYyBiL2Jsb2NrL2lvY3RsLmMKaW5kZXggNjAxMjFlODkwNTJiLi43ZGFmNzYxOTkxNjEgMTAw
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
aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsCiAJCXZvaWQgX191c2VyICphcmdwKQogewpAQCAtNDgx
LDYgKzUxNSw4IEBAIHN0YXRpYyBpbnQgYmxrZGV2X2NvbW1vbl9pb2N0bChzdHJ1Y3QgYmxvY2tf
ZGV2aWNlICpiZGV2LCBmbW9kZV90IG1vZGUsCiAJCXJldHVybiBibGtfaW9jdGxfZGlzY2FyZChi
ZGV2LCBtb2RlLCBhcmcpOwogCWNhc2UgQkxLU0VDRElTQ0FSRDoKIAkJcmV0dXJuIGJsa19pb2N0
bF9zZWN1cmVfZXJhc2UoYmRldiwgbW9kZSwgYXJncCk7CisJY2FzZSBCTEtDT1BZOgorCQlyZXR1
cm4gYmxrX2lvY3RsX2NvcHkoYmRldiwgbW9kZSwgYXJnKTsKIAljYXNlIEJMS1pFUk9PVVQ6CiAJ
CXJldHVybiBibGtfaW9jdGxfemVyb291dChiZGV2LCBtb2RlLCBhcmcpOwogCWNhc2UgQkxLR0VU
RElTS1NFUToKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oIGIvaW5jbHVkZS91
YXBpL2xpbnV4L2ZzLmgKaW5kZXggOTI0OGI2ZDI1OWRlLi44YWYxMGI5MjZhNmYgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oCisrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9mcy5o
CkBAIC04Miw2ICs4MiwxNCBAQCBzdHJ1Y3QgcmFuZ2VfZW50cnkgewogCV9fdTY0IGNvbXBfbGVu
OwogfTsKIAorc3RydWN0IGNvcHlfcmFuZ2UgeworCV9fdTY0IG5yX3JhbmdlOworCV9fdTY0IHJl
c2VydmVkOworCisJLyogUmFuZ2VzIGFsd2F5cyBtdXN0IGJlIGF0IHRoZSBlbmQgKi8KKwlzdHJ1
Y3QgcmFuZ2VfZW50cnkgcmFuZ2VzW107Cit9OworCiAvKiBleHRlbnQtc2FtZSAoZGVkdXBlKSBp
b2N0bHM7IHRoZXNlIE1VU1QgbWF0Y2ggdGhlIGJ0cmZzIGlvY3RsIGRlZmluaXRpb25zICovCiAj
ZGVmaW5lIEZJTEVfREVEVVBFX1JBTkdFX1NBTUUJCTAKICNkZWZpbmUgRklMRV9ERURVUEVfUkFO
R0VfRElGRkVSUwkxCkBAIC0yMDMsNiArMjExLDcgQEAgc3RydWN0IGZzeGF0dHIgewogI2RlZmlu
ZSBCTEtST1RBVElPTkFMIF9JTygweDEyLDEyNikKICNkZWZpbmUgQkxLWkVST09VVCBfSU8oMHgx
MiwxMjcpCiAjZGVmaW5lIEJMS0dFVERJU0tTRVEgX0lPUigweDEyLDEyOCxfX3U2NCkKKyNkZWZp
bmUgQkxLQ09QWSBfSU9XUigweDEyLCAxMjksIHN0cnVjdCBjb3B5X3JhbmdlKQogLyoKICAqIEEg
anVtcCBoZXJlOiAxMzAtMTM2IGFyZSByZXNlcnZlZCBmb3Igem9uZWQgYmxvY2sgZGV2aWNlcwog
ICogKHNlZSB1YXBpL2xpbnV4L2Jsa3pvbmVkLmgpCi0tIAoyLjM1LjEuNTAwLmdiODk2ZjcyOWUy
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==


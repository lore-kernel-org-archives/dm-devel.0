Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46701C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 12:16:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-3lJRcU3qPHau2G3PkXum1g-1; Wed, 27 Apr 2022 08:16:44 -0400
X-MC-Unique: 3lJRcU3qPHau2G3PkXum1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D38371C0DF60;
	Wed, 27 Apr 2022 12:16:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF98140149A6;
	Wed, 27 Apr 2022 12:16:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 99B7D1947042;
	Wed, 27 Apr 2022 12:16:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81C541947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 12:24:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6627A14152FB; Tue, 26 Apr 2022 12:24:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6178814152F2
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 12:24:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 417812808573
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 12:24:39 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-IFZPaOVFPAqOVYO9cUjZAA-1; Tue, 26 Apr 2022 08:24:30 -0400
X-MC-Unique: IFZPaOVFPAqOVYO9cUjZAA-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20220426121506epoutp0259208e927a4b192598ff5b13901a900c~pcUspQRP_1557515575epoutp02E;
 Tue, 26 Apr 2022 12:15:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20220426121506epoutp0259208e927a4b192598ff5b13901a900c~pcUspQRP_1557515575epoutp02E
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20220426121505epcas5p28f1533d8e7a8ba2c0aa0f1f34e3145c7~pcUrxxzqD1792317923epcas5p2i;
 Tue, 26 Apr 2022 12:15:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4Kngn06WMBz4x9Py; Tue, 26 Apr
 2022 12:15:00 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 BE.13.10063.442E7626; Tue, 26 Apr 2022 21:15:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20220426101938epcas5p291690dd1f0e931cd9f8139daaf3f9296~pav4xODFD0348903489epcas5p24;
 Tue, 26 Apr 2022 10:19:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220426101938epsmtrp13afcc873554906dc561017b6e9ca4c13~pav4vqRwT2220522205epsmtrp1I;
 Tue, 26 Apr 2022 10:19:38 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-ae-6267e24452ea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 D8.49.08853.A37C7626; Tue, 26 Apr 2022 19:19:38 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220426101932epsmtip17cfd9cf53a0ae8b9d0dafb6e571d64c4~pavzUoAnQ3271432714epsmtip1Z;
 Tue, 26 Apr 2022 10:19:32 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Tue, 26 Apr 2022 15:42:31 +0530
Message-Id: <20220426101241.30100-4-nj.shetty@samsung.com>
In-Reply-To: <20220426101241.30100-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd297byHBXCvOD9hYU4YJOB5VKB8gKqLbNZpIpmaZxuAVroUB
 bdMWdEs2gYJmjIfgMFhEUTcJoBbBIchDngIVLFBAYeMhD5W58Q7IeDhKYfO/3/md8zvPHB7O
 7ySteSFSFauQMmFCwpxTVOPg4LRnQHLS9cKkCGl1j3FU1jXFRXk9yQS6ND6Ho7GqQS5KTU4n
 0XyzHkeGoXWofDSDi1reRmNosOAdhroqSzBUdiMVQzl5dRh6lX0ToNLrE8veP6ZItPBChF5M
 d3NQanUnQMMdGgyVd29BZeWNHGR4eIVA124Nk+inZ8UEqnhTjqPs+iUMPdUsECilvpCLioei
 ASqav4ajmt4ODrr7ZoyDGrptUFzCHIn0i/XcXfa0oX0/relrJugU9ShJl2h6SFrfe49DG5oj
 6ILcHwm68Jez9MXn2YAu7Yoi6JimOpxOn5wm6ET1KEGXxPVx6Ynhbg49VtFB+G86Gro9mGWC
 WIWAlQbKgkKkEh/h/kMBfgHuYleRk8gTeQgFUiac9RHuOeDv9HlI2PI2hYJIJiximfJnlEqh
 y47tClmEihUEy5QqHyErDwqTu8mdlUy4MkIqcZayKi+Rq+tW9+XAE6HBRSOb5dHCM4spTWQU
 eGkTD8x4kHKDUU35nHhgzuNTpQA2VGdxTcYkgG1tLaTJmAGwX1vBWZMkJNSsSsoBbDwfu+Lg
 U3EYvJPkEw94PILaAp+84xlpS4oDc2ZnV+JxKp8Hh6YTMKNjA7UT9mf2AyPmUPbwfrthBVtQ
 XvBW4QJpzAMpF5jct95Im1He8Ne6UcwUsh42Xh5aKYtTn0D1bxm4MT+kLpvDV2UvcVOje2BM
 ychq0xvgn/X3SRO2hiPJ51bxafjgXBZmEscCGK/TrQp2wtayRczYBE45QO1DFxP9MUzT3cVM
 hdfBxPkhzMRbwOKra9gO3tZmESZsBTtno1cxDRf+qQamxSUBqGnvIi8Agea9gTTvDaT5v3QW
 wHOBFStXhktYpbtcJGVP/3fkQFl4AVh5MMd9xaCnf9y5GmA8UA0gDxdaWqTZnzrJtwhivv2O
 VcgCFBFhrLIauC8vPAW33hgoW/5QqSpA5Obp6iYWi908t4lFwk0WTyT5DJ+SMCo2lGXlrGJN
 h/HMrKMwvmeN17i/79yufReLHkT6FU+8TtZN6CWGhsOJP3hmBPeLPHyb4lvyBc44vfXvY9e7
 HEeuftBGnJ2UH1JHHo2prT3org/jOXk/wlUnfmc+eyvqsMjMPNZdrD2fIa+xGpDsFjqJ1bYi
 xn1WNTB4SuylOPjR02jm01Jl6k3vHQce51/6MilnaarvuHTYdluoj8D/iNZLG4wmR6/c4X+9
 u5ZIi9QODP9c9U3Ko+eH99okzVh15qOFI3n6GGdL9Yd2nbKlG1803PNrdbDL5ffHRCQ7VG68
 7XGGr51psD3+fVBLbFprZGxRia4wXO6a01uZ61u4ubmqdQItfZVO6kr1MX89e00IOcpgRuSI
 K5TMvz9S7fTpBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxzGfc8dxlkORcOLzXTpBnKHEre9Q6YmW5bjzOauH3SJrsxDNXJp
 Whi4bKNdJdMOg2WBYEHwUiAFpwEUC7RuwmpFhOIKo22UQigQNSlyMYxRdBayzG9Pfs/v/3z6
 M7joLLmROZybLyhzZdkSKpRo75FsSkq3yzNTf6th0eXbN3Fkcc+TqPl+GYUqHy/haObGBInK
 y6potNzvwJHT9zKy+qtJNPi3BkMTrc8w5P69A0OW8+UYMjXbMDTdeAGgrnOzz9t78zQKjEvR
 +IKHQOXdfwE0OWzAkNWTgCzWXgI5O2soVNcwSaOfR8wUuv7IiqNG+1MMDRgCFNLb20hk9mkA
 al+uw1HP6DCBLj2aIdAtjxiVlC7RyLFiJ3dG886h3bzB20/xeq2f5jsM92neMdpC8M7+Ar61
 6QTFtxmL+V9cjYDvcqsp/sc7Npyvmlug+JNaP8V3lHhJfnbSQ/Az14epjyP3hWYcFLIPfyMo
 U7Z/FXqo/UGMQiMpWtHfodVgSqwDIQzktsLS0h5CB0IZEdcFYHvzSWqtiIINK3/gazkCmp5O
 08Es4rQYdGslOsAwFJcA+54xQbyeI6BpcXF1B+dcDLw25V+9jeB2wLEzYyCYCS4aXhlyrmaW
 S4cNbQE6uAO5FFjmDQ/iEG4brLf5sSAWPVdcy0VrdjjsPe0jghjntsDLtaIgxrnNUHu1Gj8F
 wg0vWIb/LcML1lmAN4EoQaHKkeeopApprlCYrJLlqApy5clf5+W0gtUnio8zg2tNj5O7AcaA
 bgAZXLKerYjOyhSxB2VHvxWUeQeUBdmCqhuIGUISyQ7qeg+IOLksXzgiCApB+V+LMSEb1dhn
 Ldt31NVPzhr7TB/e3RSfOMV23R7JIn+aJ1zvp3x+y/FKoJx4r6n0on9LCf2dsfBT3+s/VLa4
 j28L+OVPxEtvVL2TmEZe7IsQbbB9GRfIlBRuuFp7xOKP05gT0lJHAmF3Y1rTrBUS6a+x9Zl9
 HsPOMbXz4brKvXSs62b07hMfvDr+9rE/B3Tv3jhjLNl8fFei8cGbmrcGFa958yPJIlt6f/HC
 TMau89NbLansBGkq0jxxS7NUDpZ9GDk0/dLRT2q+uDQ3ELv3o32dYXHVc6eOxSBqUSyOMnfu
 uVIRFpaEJdm8+03C93tMIer9CaP6dffGM+Zr/8nzyU8zDs5X3Kbn7RJCdUgmjceVKtm/AyOj
 iLMDAAA=
X-CMS-MailID: 20220426101938epcas5p291690dd1f0e931cd9f8139daaf3f9296
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220426101938epcas5p291690dd1f0e931cd9f8139daaf3f9296
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101938epcas5p291690dd1f0e931cd9f8139daaf3f9296@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 27 Apr 2022 12:14:17 +0000
Subject: [dm-devel] [PATCH v4 03/10] block: Introduce a new ioctl for copy
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
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, msnitzer@redhat.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de,
 Nitesh Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 josef@toxicpanda.com, linux-block@vger.kernel.org, dsterba@suse.com,
 kbusch@kernel.org, Frederick.Knight@netapp.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, Arnav Dawn <arnav.dawn@samsung.com>,
 jack@suse.com, linux-fsdevel@vger.kernel.org,
 =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier.gonz@samsung.com>,
 lsf-pc@lists.linux-foundation.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
b2N0bC5jCmluZGV4IDQ2OTQ5ZjFiMGRiYS4uNThkOTNjMjBmZjMwIDEwMDY0NAotLS0gYS9ibG9j
ay9pb2N0bC5jCisrKyBiL2Jsb2NrL2lvY3RsLmMKQEAgLTEyMCw2ICsxMjAsMzYgQEAgc3RhdGlj
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
c3RhdGljIGludCBibGtfaW9jdGxfc2VjdXJlX2VyYXNlKHN0cnVjdCBibG9ja19kZXZpY2UgKmJk
ZXYsIGZtb2RlX3QgbW9kZSwKIAkJdm9pZCBfX3VzZXIgKmFyZ3ApCiB7CkBAIC00ODEsNiArNTEx
LDggQEAgc3RhdGljIGludCBibGtkZXZfY29tbW9uX2lvY3RsKHN0cnVjdCBibG9ja19kZXZpY2Ug
KmJkZXYsIGZtb2RlX3QgbW9kZSwKIAkJcmV0dXJuIGJsa19pb2N0bF9kaXNjYXJkKGJkZXYsIG1v
ZGUsIGFyZyk7CiAJY2FzZSBCTEtTRUNESVNDQVJEOgogCQlyZXR1cm4gYmxrX2lvY3RsX3NlY3Vy
ZV9lcmFzZShiZGV2LCBtb2RlLCBhcmdwKTsKKwljYXNlIEJMS0NPUFk6CisJCXJldHVybiBibGtf
aW9jdGxfY29weShiZGV2LCBtb2RlLCBhcmcpOwogCWNhc2UgQkxLWkVST09VVDoKIAkJcmV0dXJu
IGJsa19pb2N0bF96ZXJvb3V0KGJkZXYsIG1vZGUsIGFyZyk7CiAJY2FzZSBCTEtHRVRESVNLU0VR
OgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2ZzLmggYi9pbmNsdWRlL3VhcGkvbGlu
dXgvZnMuaAppbmRleCA4MjJjMjhjZWJmM2EuLmEzYjEzNDA2ZmZiOCAxMDA2NDQKLS0tIGEvaW5j
bHVkZS91YXBpL2xpbnV4L2ZzLmgKKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2ZzLmgKQEAgLTc4
LDYgKzc4LDE0IEBAIHN0cnVjdCByYW5nZV9lbnRyeSB7CiAJX191NjQgY29tcF9sZW47CiB9Owog
CitzdHJ1Y3QgY29weV9yYW5nZSB7CisJX191NjQgbnJfcmFuZ2U7CisJX191NjQgcmVzZXJ2ZWQ7
CisKKwkvKiBSYW5nZV9saXN0IGFsd2F5cyBtdXN0IGJlIGF0IHRoZSBlbmQgKi8KKwlzdHJ1Y3Qg
cmFuZ2VfZW50cnkgcmFuZ2VfbGlzdFtdOworfTsKKwogLyogZXh0ZW50LXNhbWUgKGRlZHVwZSkg
aW9jdGxzOyB0aGVzZSBNVVNUIG1hdGNoIHRoZSBidHJmcyBpb2N0bCBkZWZpbml0aW9ucyAqLwog
I2RlZmluZSBGSUxFX0RFRFVQRV9SQU5HRV9TQU1FCQkwCiAjZGVmaW5lIEZJTEVfREVEVVBFX1JB
TkdFX0RJRkZFUlMJMQpAQCAtMTk5LDYgKzIwNyw3IEBAIHN0cnVjdCBmc3hhdHRyIHsKICNkZWZp
bmUgQkxLUk9UQVRJT05BTCBfSU8oMHgxMiwxMjYpCiAjZGVmaW5lIEJMS1pFUk9PVVQgX0lPKDB4
MTIsMTI3KQogI2RlZmluZSBCTEtHRVRESVNLU0VRIF9JT1IoMHgxMiwxMjgsX191NjQpCisjZGVm
aW5lIEJMS0NPUFkgX0lPV1IoMHgxMiwgMTI5LCBzdHJ1Y3QgY29weV9yYW5nZSkKIC8qCiAgKiBB
IGp1bXAgaGVyZTogMTMwLTEzNiBhcmUgcmVzZXJ2ZWQgZm9yIHpvbmVkIGJsb2NrIGRldmljZXMK
ICAqIChzZWUgdWFwaS9saW51eC9ibGt6b25lZC5oKQotLSAKMi4zNS4xLjUwMC5nYjg5NmY3Mjll
MgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=


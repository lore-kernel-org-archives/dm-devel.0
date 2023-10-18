Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6A1BE5B
	for <dm-devel@lists.linux.dev>; Wed, 18 Oct 2023 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XxkA8ys2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697639129;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=XF29fHDNuXpDuH/JV5O0etb/Zd3E+TxXTUfRrXEX1jU=;
	b=XxkA8ys2vxaCrkM9p0Fao7LxfNLocIV3rIuB7NJoLvZeNnXsu3rBCkw6PZkSCTyrNFSx6+
	3WasuTXHknxTS0VyNiRW27ciVSx6l5xlH7tKjKF6KsoBXJ6MBlHyupZyqL+9eiLb81BJ7u
	yQpKbQOjOqcnHGa6QHltAMJGcEz5zes=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-o311-ihAOtaGMqOfEh9Xzg-1; Wed, 18 Oct 2023 10:25:28 -0400
X-MC-Unique: o311-ihAOtaGMqOfEh9Xzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C1223813BF1
	for <dm-devel@lists.linux.dev>; Wed, 18 Oct 2023 14:25:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 347032166B28
	for <dm-devel@lists.linux.dev>; Wed, 18 Oct 2023 14:25:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E53F619466F6
	for <dm-devel@lists.linux.dev>; Wed, 18 Oct 2023 14:25:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32EBC19465B3
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 Oct 2023 13:32:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1FDDE1C060B0; Wed, 18 Oct 2023 13:32:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 18BB91C060AE
 for <dm-devel@redhat.com>; Wed, 18 Oct 2023 13:32:02 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E525E91770D
 for <dm-devel@redhat.com>; Wed, 18 Oct 2023 13:32:01 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-w3YoTdzoMoqE0ugV6-75vg-1; Wed, 18 Oct 2023 09:31:56 -0400
X-MC-Unique: w3YoTdzoMoqE0ugV6-75vg-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20231018133152epoutp0165695d5f54d71de3070e8000d5fc66a5~PNt5JAzMn1481814818epoutp011
 for <dm-devel@redhat.com>; Wed, 18 Oct 2023 13:31:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20231018133152epoutp0165695d5f54d71de3070e8000d5fc66a5~PNt5JAzMn1481814818epoutp011
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20231018133151epcas5p32eee98f338fcffca106dc084b9405c3d~PNt3_9ePq1794217942epcas5p34;
 Wed, 18 Oct 2023 13:31:51 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4S9WwP5y9Yz4x9Pt; Wed, 18 Oct
 2023 13:31:49 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 1F.31.10009.54EDF256; Wed, 18 Oct 2023 22:31:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20231018101516epcas5p2ac132e21cc9f83edd819c7680a51487d~PLCPQwGhZ3226032260epcas5p2g;
 Wed, 18 Oct 2023 10:15:16 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20231018101516epsmtrp23a828f342d83585a91c501a654146b0c~PLCPPbHfq1426614266epsmtrp2K;
 Wed, 18 Oct 2023 10:15:16 +0000 (GMT)
X-AuditID: b6c32a4a-ff1ff70000002719-05-652fde45eb1a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 BA.0F.07368.430BF256; Wed, 18 Oct 2023 19:15:16 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20231018101513epsmtip27d59481a87c3dbfc474968108748ac3d~PLCMGR7Ek0062200622epsmtip2h;
 Wed, 18 Oct 2023 10:15:13 +0000 (GMT)
Date: Wed, 18 Oct 2023 15:38:48 +0530
From: Nitesh Jagadeesh Shetty <nj.shetty@samsung.com>
To: Jinyoung Choi <j-young.choi@samsung.com>
Subject: Re: [PATCH v16 04/12] block: add emulation for copy
Message-ID: <20231018100848.i26yrkuufv4koluq@green245>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230926100718.wcptispc2zhfi5eh@green245>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHd+4tt4VRdgGZpzAeueAiyqMFWg7KY4mPXMeysZCwqTNY22vL
 gLZry9zIkhUYQ94gzmARhYzxqFNGB6SIMASURxA3HTCIGMyAhIE8ZMgYAVdaWPzvc77n+z2/
 c37nHA7uZGS7chIUWkatECdRhB2ruct3r/+RJ4EM32TyR/X993C0tLLOQulFGzi6Pl5IoNmu
 5wBNdmQB1DZfZoNGO1owVHf9LobyC5sIdKFzGKCpIT2G2sb2o8pvq1jodlsfCz26dYVA16qn
 2Ch3xESgmp5NDP1RNAWQaTINoJuzCyzUO+aG/sw9D9CDjR6bd3h0i36cTT940sCiH91PoY2G
 bIL+ueprunVUR9DfF5TY0PkZ8wS9NDXGohfahwi6oNEA6GWjB22cfIbFcE8khssZsZRRezEK
 iVKaoJBFUNGx8YfihSK+wF8QhkIpL4U4mYmgDr8X4380IcncBMrrc3FSilmKEWs0VGBkuFqZ
 omW85EqNNoJiVNIkVYgqQCNO1qQoZAEKRntAwOcHCc3G04nymew1G9Ui+4vKqV8IHRgjcoAt
 B5IhcH0gDc8BdhwnshXAjrtz24PnADavNrGtgxcA6pavgJ1Iw1Uje4udyDYASy6praZpAB8/
 zGVtTbDIPTDrTprFRJBC2NqQYdY5nF2kH8w0eG/5cbKCA9tHblgWfY2MgsZ+oyXrTIbDpsLb
 liyXFMHpBhNmZUfYd3nS4rElQ6Eu657F40K+BUt/WLFsG5KDtrD8t9+3d3oYZv9azbKyM/yr
 p5FtZVe4PN+23YBzsO5iLWENfwOgfkS/HY6Cmf2F+BbjpBwO5OfZWHV3+F3/TcyqO8D89UnM
 qnOh6eoOe8Mf6yu2C/Dg8GoasXV6SNIw46dT1m5VYXBwdQIvAl76Vw6nf6WclQ/A7MX0bfaE
 GU1luN68FE66wZpNjhV9Yf2twApAGACPUWmSZYxGqApSMOf+fwkSZbIRWD7PvndN4OnEYkAn
 wDigE0AOTu3iymL9GCeuVPxlKqNWxqtTkhhNJxCaL7EYd3WRKM2/T6GNF4SE8UNEIlFIWLBI
 QO3mzmaWS51ImVjLJDKMilHv5DCOrasOa5laWXZ03njzUvJMsZQ9pLdrMcjlwXc8JLnKgdoC
 j4y87lOp0qc580T3J3m5zgmrXdrQ3tOlyx6f7i+vj+tJVhilIxcPufMuO7e+Ye8+vKeDVBac
 jIus8zn20W52qOiMr3PD4zVHF/5cJKUrXlup1B308+5rWOLVlt1IHeXOZDsMFklGHTy6B8U8
 kUHf+LLINWoDr3N7djYxwFRCt77wO/lQnRIkG//KVjA8vkId7/KprssH8e1H++sXrh0fyDkh
 4afdn4j+p5PnuRcznfn4yPvNH7z0HD//YWl61dtxQvvPfHphsOfrngejaoKoWIe/fc+6Rks0
 m/Wr9tOc2WP/zjlSLI1cLNiHqzXi/wBk9K1gxQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUwTURSFeTPT6YBpHBb1YY0kNSrBUm1EfcQFTIyOxsSlJiSYKEUmBaVY
 W+uWoIUGQRRpcMPWgAuC4MooylasFUFcaBBRQVCRVmOUpYhxgRalaOTfyTnnfvf+uBTup+NN
 phKSdrLqJHmiiPQhbt8XBYWG3ZjNzhngJOj6ozocOb8NEijV4MLR5Y5sEn2+3w+Q3ZIOkLnH
 xEOtlgoMFV9+gKGs7DIS5VhfAORoMWLI3DYLnTtYQKBqcwOBmivPkCi/0MFHh1+Wk6io3o2h
 VwYHQOX2FICufe4l0MM2Ieo6nAGQzVXPiwxkKowdfMb2ppRgmp9qGa7kEMncLDjAVLXqSObC
 0WM8JkvfQzJORxvB9Na0kMzRWyWA+cpNZTh7N7ZWEO2zKI5NTNjFqmcvifGJf91tw1QpvD3N
 JzsJHcggMoE3BekwWJrH8TOBD+VHVwFY+PMDPhoEwkJX7V/tD4vdH/+W7ABWvr3rmSbo6TD9
 Xgp/RJP0PFhVqv/jU1QALYZpJdNG+jh9iYLnzv/w9L3oCMg94jzan14Ey7KrPbMCej78UFqO
 jS4owGBebgcxGvjChtN2j8b/lPJuduIjC3BaCIvc1KgdBPVlJs+h3vQCqEuv8zAn0FNg7sVv
 uAH4G8eQjGNIxv8k4xjSWUCUgEBWpVEqlFukKmkSu1uikSs12iSFZMt2JQc8TxISXA7e5Lsl
 VoBRwAoghYsCBAqZmPUTxMn37mPV2zertYmsxgqEFCGaJJDmmuL8aIV8J7uNZVWs+l+KUd6T
 dZjY1/qra77a0m69ccX86WTkJi+Wy22ZOT0rojnra0JOjT5s8P3BdwEXVqTNdIq3hhv6uops
 nZprQj3fvcB/boSsQDrQtzQ+eNgy6FUhe5+z7yU8lVl8orGxrzWgTUIlLwz7NW8Ha+7tcjqi
 7cXcc/Ga46Zl+wVBK4VlMWlHaNOXd0OqvcdDmybW28PbU61NP7+4ur93nskZct1qGi87oOzZ
 +EkoWq4YsCVrr9oal0JZYUjs4tMbtHwUFd4PY1Jj8uNEsZQlwxBtebI+9vGwb+hqX+3bYGXR
 2XVRGZNqhwXjNsaLnXcsYHVy/pAh9Fj/s9r2SzXKqOeaVTOGU095R4oITbxcGoKrNfLfzLD+
 a5MDAAA=
X-CMS-MailID: 20231018101516epcas5p2ac132e21cc9f83edd819c7680a51487d
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081458epcas5p3a3e12d8b5661b5d6f4420316630b02e1
References: <20230920080756.11919-5-nj.shetty@samsung.com>
 <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081458epcas5p3a3e12d8b5661b5d6f4420316630b02e1@epcms2p6>
 <20230922130815epcms2p631fc5fc5ebe634cc948fef1992f83a38@epcms2p6>
 <20230926100718.wcptispc2zhfi5eh@green245>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
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
Cc: Vincent Kang Fu <vincent.fu@samsung.com>,
 "anuj1072538@gmail.com" <anuj1072538@gmail.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, SSDR Gost Dev <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----.DGRwfvtDKQaTon4q7jBZTz_rY-uYfv-SaOoriR32EfX1D_r=_12cae_"

------.DGRwfvtDKQaTon4q7jBZTz_rY-uYfv-SaOoriR32EfX1D_r=_12cae_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26/09/23 03:37PM, Nitesh Jagadeesh Shetty wrote:
>>>+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 write_bio->bi_i=
ter.bi_size =3D chunk;
>>>+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D submit_=
bio_wait(write_bio);
>>>+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(write_bio=
);
>>
>>blk_mq_map_bio_put(write_bio) ?
>>or bio_uninit(write_bio); kfree(write_bio)?
>>
>>hmm...
>>It continuously allocates and releases memory for bio,
>>Why don't you just allocate and reuse bio outside the loop?
>>
>
>Agree, we will update this in next version.
>
Reusing the bio won't work in cases where the bio gets split.
So we decided to keep the previous design.

Thank you,
Nitesh Shetty

------.DGRwfvtDKQaTon4q7jBZTz_rY-uYfv-SaOoriR32EfX1D_r=_12cae_
Content-Type: text/plain; charset="utf-8"


------.DGRwfvtDKQaTon4q7jBZTz_rY-uYfv-SaOoriR32EfX1D_r=_12cae_--


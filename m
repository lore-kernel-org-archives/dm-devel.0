Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DA7C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 08:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669191961;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fngJaFPg4K8bEeIiukEZ6KmT3TnUffMWbF0Py0cc1Jw=;
	b=Sv/hN/cQorxe9qbEY81vu8hdnGN3q2aDnnFCv+B0q+3aQH84rCmHREII+M6d2YusW8FW+6
	pdmzSh74f56tvYI1GlZn8N2ORKAfYt/P6tlDQJVvCVTXkAXJfoksvmD/Uz0UtGQRm+T02k
	c1lxrO70k14DtXWKq4zsr53rssE1tVc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-x7rPae9gOJOUMPxRosR8qg-1; Wed, 23 Nov 2022 03:25:59 -0500
X-MC-Unique: x7rPae9gOJOUMPxRosR8qg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FB4329DD998;
	Wed, 23 Nov 2022 08:25:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BB361402BDB;
	Wed, 23 Nov 2022 08:25:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA2BB1946A44;
	Wed, 23 Nov 2022 08:25:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D3D01946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 06:21:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5FA0FC1908B; Wed, 23 Nov 2022 06:21:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57D2FC1908A
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D47A833AEC
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:13 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-mBZ95fIqP72lsTy5c-cr4A-1; Wed, 23 Nov 2022 01:21:11 -0500
X-MC-Unique: mBZ95fIqP72lsTy5c-cr4A-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20221123061345epoutp02daf1a5eb5d8b62e71d2877943e7204d8~qIgcSKRMQ1783517835epoutp02Z
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:13:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20221123061345epoutp02daf1a5eb5d8b62e71d2877943e7204d8~qIgcSKRMQ1783517835epoutp02Z
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20221123061342epcas5p119115974f34a518d3b83d7dabac38e90~qIgZzf6Yo2805328053epcas5p1S;
 Wed, 23 Nov 2022 06:13:42 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4NH9mh4966z4x9Pp; Wed, 23 Nov
 2022 06:13:40 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 83.91.01710.41ABD736; Wed, 23 Nov 2022 15:13:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20221123061037epcas5p4d57436204fbe0065819b156eeeddbfac~qIdtZjzIm1387613876epcas5p4L;
 Wed, 23 Nov 2022 06:10:37 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221123061037epsmtrp29863525cb7f744d91a2508cf38d69191~qIdtYR1U20473504735epsmtrp2Q;
 Wed, 23 Nov 2022 06:10:37 +0000 (GMT)
X-AuditID: b6c32a49-c9ffa700000006ae-f4-637dba14c7fb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 B9.C2.18644.D59BD736; Wed, 23 Nov 2022 15:10:37 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20221123061034epsmtip15ed7fc7e8497363a6f994535aa0d13b8~qIdqfGl_e2064620646epsmtip1F;
 Wed, 23 Nov 2022 06:10:34 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 james.smart@broadcom.com, kch@nvidia.com, damien.lemoal@opensource.wdc.com,
 naohiro.aota@wdc.com, jth@kernel.org, viro@zeniv.linux.org.uk
Date: Wed, 23 Nov 2022 11:28:25 +0530
Message-Id: <20221123055827.26996-9-nj.shetty@samsung.com>
In-Reply-To: <20221123055827.26996-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTPvbf3tsVVLoXNj7JH6caMMGjLCvtwgIsyvOwVpskeGoNNuaFI
 X2nLAOOgFRiCEcTBhPIQxjTjEQgFFMuKFUSEiWQ6MOJ4jAGLIEVgT5GxlsLmf7/z+875nfM7
 Xw4L4+YyeaxElZ7WqqQKAeHGuNi9Y3ugl+VzmSjT4A6b+q9j8PjpVQzWjxYQcGVgEINWexkO
 79kuo7C2vgeFHdWLKOxZmyfgz7+NMOCZrmEETg+ZUGgdCYDfWfsY8I6lnIDnLkwzYWFvCw7b
 p4wIvLhyDoPL57OYsHFugQFvjPjAwdVe/K1tlGl8gKAum0aZ1OBYM4O6M5BMmetyCarlmwyq
 456BoE5l2h0J2eM4tdA5RFD5rXUItWx+kcqxnUQp89Q8Grv1QFK4nJbG01o+rZKp4xNVCRGC
 d/fH7YkLCRWJA8Vh8A0BXyVV0hGCqPdiA6MTFQ7/Av5nUkWyg4qV6nQCYWS4Vp2sp/lytU4f
 IaA18QqNRBOkkyp1yaqEIBWt3ykWiYJDHImHk+TGkuuIxoinXrpZgRuQEkYewmYBUgJuNZSj
 eYgbi0t2IOC2sRFzBUsIONMyvBEsI6Dh61lis6Rybg53Yi5pQcDMWrgrKRsFkzUPHFosFkEG
 gO/XWE7ei8xHwYkO27oSRpahYP7CE6az2pOMBtfGf1/HDNIPfNnyI+rEHHInOL9UhjuFACkE
 BeMeTppNvglu/mDZSPEAfaVT6x4w8iWQ2Va2rg/IGjYoauvBXZNGgYnF4xtTe4LZ3lamC/PA
 st26waeA2qJvCVdxFgJMd02I62EXyO4vwJxDYOQO0GQRuugXQHF/I+pqvBWcWplCXTwHtFdu
 4pdBQ1PVhr43GP7TSLi8UGDWoHQtKx8BkzlWxmmEb3rKj+kpP6b/O1chWB3iTWt0ygRaF6IR
 q+iU/35ZplaakfWb8I9pR0YnHgV1ISgL6UIACxN4cTJijsm4nHhp2lFaq47TJitoXRcS4th3
 IcZ7VqZ2HJVKHyeWhIkkoaGhkrDXQ8WCbZyaEn8Zl0yQ6ukkmtbQ2s06lMXmGVB22dkjtm5F
 Sv61Q/uqH6W83fdx7T57fae5+uhVn7vuYQrLJ1EJnelVlfb7bqk9B/OQZ9Jq5JO322fltSJe
 L/638pXyZt9Dxy51jcFdnKU/Sua+EuNKnwKD/ie/Ex+Wyh9WZD3ss0VHbk9leMyk+/r/82qG
 xC99y2KFsptbUf6a98m5ogOh7xcWHzZd+eUvLne/Kjv3oPGDq8F7mEd2C0frPI1e3tHmvQH3
 hb5euL9xiP5osNR3UcBWjc12GwKsONDe4sRIg5M67Y8T03Ju6J78ij0XGNXa31wcEQ2iCvgz
 W4RX3G22yOkHvBh+yTsLEZ9Kvmizn82fKNz7eCCQYXl+NU7A0MmlYn9Mq5P+C5JtjUecBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWy7bCSnG7sztpkg1NbDSzWnzrGbNE04S+z
 xeq7/WwWv8+eZ7bY+242q8XNAzuZLFauPspksXvhRyaLo//fslk8/HKLxWLSoWuMFk+vzmKy
 2HtL22LP3pMsFpd3zWGzmL/sKbvFxOObWS12PGlktNj2ez6zxeelLewW616/Z7E4cUva4vzf
 46wO4h6z7p9l89g56y67x/l7G1k8Lp8t9di0qpPNY/OSeo/dNxvYPHqb3wEVtN5n9Xi/7yqb
 R9+WVYwenzfJebQf6Gby2PTkLVMAXxSXTUpqTmZZapG+XQJXRuOMY4wFjawV28/MZW1gnMHS
 xcjJISFgIjHv9WvWLkYuDiGBHYwSS45OYoJISEos+3uEGcIWllj57zk7RFEzk0TPveNADgcH
 m4C2xOn/HCBxEYEFTBKX771iBnGYBZYyScy+cpcNpFtYwE3iyP2v7CA2i4CqxOTNV8A28ApY
 SSz9NJsVZJCEgL5E/31BkDCngLXEmYu7mEDCQkAle5bpQFQLSpyc+QTsaGYBeYnmrbOZJzAK
 zEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnAca2ntYNyz6oPeIUYm
 DsZDjBIczEoivPWeNclCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2C
 yTJxcEo1MO2yXhF2Qi7QSmuv6vK51VWXFj6ReNfcM/0V98NIubneVyI+66XeT7zvOWe7aPrD
 XMvn73N+ee9SUXL7uHzd49cMuhOMpn15W/G5vGffpKz0Ty61e5v9nv57JCbd/nLZloi9jowf
 Jm6cd01TYFlg5ZmiaLU9bf5Nr1j+Nv7wW+QjeSOGxfdb2ro793Jez1DUqTa6oPNELPm7uuSv
 G70MTNsWB0yTvMUUcqTkTLHpizfJHa4Hdd/GhL/f1ah5altL0nrTbxe93ljFPK97nGNxJsdi
 Z2/V1ognHP+O7f69fLNGw83TZ8tF5+5U3Sp+5zd7gUT2MmOh5C/231weiXzfzf398KRz3DV7
 Zmy+eEtkjcZFJZbijERDLeai4kQAu1HpnVIDAAA=
X-CMS-MailID: 20221123061037epcas5p4d57436204fbe0065819b156eeeddbfac
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061037epcas5p4d57436204fbe0065819b156eeeddbfac
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061037epcas5p4d57436204fbe0065819b156eeeddbfac@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 23 Nov 2022 08:25:56 +0000
Subject: [dm-devel] [PATCH v5 08/10] dm: Enable copy offload for dm-linear
 target
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
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Setting copy_offload_supported flag to enable offload.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-linear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3212ef6aa81b..b4b57bead495 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -61,6 +61,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->copy_offload_supported = 1;
 	ti->private = lc;
 	return 0;
 
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


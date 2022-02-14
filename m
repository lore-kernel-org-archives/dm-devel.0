Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F809C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-e9D2E9meMXeNW4d9F1qNRA-1; Mon, 14 Feb 2022 03:48:29 -0500
X-MC-Unique: e9D2E9meMXeNW4d9F1qNRA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BF37189DF5F;
	Mon, 14 Feb 2022 08:48:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81BAF607B6;
	Mon, 14 Feb 2022 08:48:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C9A318033F6;
	Mon, 14 Feb 2022 08:48:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8aMTr009271 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:36:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5A132492CAF; Mon, 14 Feb 2022 08:36:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55D93492CAE
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:36:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A8EA85A5BC
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:36:22 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-636-b5HUP3NnNISyDmbo7-seHQ-1; Mon, 14 Feb 2022 03:36:20 -0500
X-MC-Unique: b5HUP3NnNISyDmbo7-seHQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id
	20220214083616epoutp04bebac9c91502b22ec389367e354046aa~TmiXeG4Dy0136801368epoutp04Z;
	Mon, 14 Feb 2022 08:36:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
	20220214083616epoutp04bebac9c91502b22ec389367e354046aa~TmiXeG4Dy0136801368epoutp04Z
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20220214083615epcas5p139fdb7d151237f990c3306d6d6a1642a~TmiXJFcUW1332613326epcas5p1l;
	Mon, 14 Feb 2022 08:36:15 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4JxyHC4TqLz4x9QH;
	Mon, 14 Feb 2022 08:36:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C5.17.06423.7741A026; Mon, 14 Feb 2022 17:36:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20220214080656epcas5p31c80cce4f9638bccdf2bc225b339c37e~TmIwwT_j10612006120epcas5p3K;
	Mon, 14 Feb 2022 08:06:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220214080656epsmtrp13385868747ae487e254764d8bab6138b~TmIwve7fn0045300453epsmtrp1g;
	Mon, 14 Feb 2022 08:06:56 +0000 (GMT)
X-AuditID: b6c32a49-b01ff70000001917-a2-620a147714cb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	D9.B4.08738.0AD0A026; Mon, 14 Feb 2022 17:06:56 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080651epsmtip233c40a25e259e947cf3374c16faf4684~TmIsK1UTr2418624186epsmtip2k;
	Mon, 14 Feb 2022 08:06:51 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Mon, 14 Feb 2022 13:29:59 +0530
Message-Id: <20220214080002.18381-10-nj.shetty@samsung.com>
In-Reply-To: <20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd+/ltmXBXbCTD2Sx6WYWMGDrWvYhMnCiXqJsGLMtumVwgTsg
	QNu0ZTr9A1hHIzDk4VBWioAOkPdEZYzXEIKM12BDqBqesUSF8J4B5NFRis7/ft85v9/5nXO+
	HC5u185x5EbI1KxSxkQJSWuiusXZxfUM3zpYZCwUoMqOeziqf7hghUqHUkl0eXYZRzN3H1uh
	jNQsDuozbkMN09lWqHcpHkOPq0wYqr+WgaHi0lYMPSm6DlBd/hyGEjt7MbQ6JkatpikSZTQP
	ADTer8NQw6M9qL6hnUB9tXoS5RaOc1CyoYZEjZMNOCpqW8fQX7pVEtUY4wGqXsnFUctwP4Eq
	JmcIpL35HKCEH5c5qGetzcpHSPfdP0brRrpJOl0zzaF/1w1x6J7hmwStyRsk6L7uGLqqJJGk
	b/0SS196UATouodxJP19VytOZ83/S9IpmmmSnht/RNAzjf1kwI7TkQfCWSaUVQpYWYg8NEIW
	5iU8djLwUKDUXSR2FXugD4UCGRPNegl9jwe4HomI2tifUPAtExWzEQpgVCrh3o8OKOUxalYQ
	LlepvYSsIjRKIVG4qZhoVYwszE3GqveLRaJ90g1iUGT42HwzoXhKnM1suoLHAROeBHhcSElg
	3twASALWXDuqDsDlpDQrc8KOmgdwJmmnJbEAYMf9XPKlIj1xaotUC+B6HNdCSsBg8Y2LWBLg
	cklqD+w0cc0cPkXA4sVFwszBqQUS/lm2ssnZTh2BlQufmDkEtRv+ZpgDZmxDeUJtyWXM4vUu
	zB+7u+nF24g3TRbhFo4tbP/ZSJgxTu2CmjvZuLk+pF7wYHtjj5VF7AtHV3sIC94OJ9pucyzY
	ET5L1XIsgmQAl7pGMMsjC0BNmmZrTG/4d/3aZqc45Qwra/dawu/AzI4KzOK8DaasGLc6tYE1
	V42vui6rzNsq4wAHFuO3MA2fG8o4lm1dBLBhaolIAwLdaxPpXptI9791HsBLgAOrUEWHsSqp
	Qixjz7z65RB5dBXYvCkXvxowNDrr1gwwLmgGkIsL+TZfd/OC7WxCme/OsUp5oDImilU1A+nG
	ytNxx7dD5BtHKVMHiiUeIom7u7vE4wN3sdDepjPsV8aOCmPUbCTLKljlSx3G5TnGYTeu+686
	HVqvCPEuLvk8Uz9SfuqNhKGnyW/Kzg9PV8r0balfGtKKP5X25aQzef31hHRKqo3WHz3n4pm7
	FKxyMvIlvCj7/Mbyfe+ZDhZ0n/fGg3zeOhh44fSE9VjJFxqvItuGlUuDV78KERX/ZND8MIg3
	qjvjXhy+XflEUcZ2iCYiffX21zLD5NkSJ+2KIaes3bdavXt0/pTqZE5rStqVVoeaiPeXTuzw
	t/1Y45Xr5/NZk+lZRcIMOlrgzzs733ln3Fj+wL2lcOi4diX+j9gC7Uh+262u+HTx7D+lfoJ7
	zOqunYOeojEUf6I3NClW7/RNd7CWFfIjhp0Tg5CEX3Jhv25NSKjCGbELrlQx/wHDR1On3AQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf1CTdRzH7/t9nj3Ps3Wzx0HwaJzEkBQ4wHV2fSKyrjx9qtN+/FUeJ458
	DjkH0rORGlciK5JBh8yEuaHgj4MYAQk5STZvjCaHQtAtfqZ2S5B0OZiaQDlXE7vzv9d9Xq+7
	9z8fhlCEyOVMbr5OEPPVGiUlI209ytiUerkse03976ug7eIFAuzjdyTQfKWSgurZBQJmuq9J
	wFhposEzuQQcfosEhub3Y7jWHsJgP2HE0NTsxjDdeBJB1/EAhrJLQxjue1XgDt2iwOgaQTA1
	bMbgmEgGu6OPBM+5WgrqGqZoKB/tpOC8z0FAY+8DDD+Z71PQObkfge2fOgJ6rg6T0OqbIaH0
	9F8IvqhYoGEw2Ct5Vcl7fnmLN/82QPFVej/N/2C+QvODV0+TvL7+Msl7Bgr5dmsZxXec2scf
	GmtEfNd4McWX9LsJ3nT7LsV/pfdTfGBqguRnzg9T70RtkWVsFzS5Hwti2rptsh3e2y6y4A9y
	z2FnDVGMQoQBSRmOXctVld2SGJCMUbCdiKt0B/CiWMY1BH98FEVwTQ+m6cVIj7numqOkATEM
	xSZzl0JMuIlkSa5pbo4MNwR7lOb6ff10uIlgN3BtdzaHG5JN4M6OBlCY5exLXKm1+tFWPHfc
	2y0Js/S/u9PX+HBXwaZzpmEXvdgv5fqOTJJhJthYTn/GQhxErPkxZX5M1SNsRcuEAm1eTp5W
	VfBcvrA7VavO0xbm56R+uCuvHT38kaSkTmS3zqa6EGaQC3EMoYyUbx2QZivk29V7PxHEXVli
	oUbQutDTDKmMlg8Z+rIUbI5aJ+wUhAJB/N9iRrq8GL9tm+5+ofp6/8+HR8tft39UEhHo6Aie
	8woLNbrEwK8V358tjXvj5fSFZ++9yfdpPyeKlq7F6S1pDdS7iau/qa07mLTu+WaNUVzd5ivf
	F7eyOBpfyI2afdJ0stZ8zFM0NqaWPlV98bOthzKX3MxIcyQ4/ZVzcQLoeluiYv789sZAW7rh
	zIqWmA3uTclHvsvIdJR88ETXdX9wVc/G9SnxRTszDCa3bv6ZxDT3zXnvi+YKyxpn66fj5Cnj
	MVVUlcWqcji34KwRcWMwsuLrcVvsyN5t7pQvYyYGdyfcoHxgMd9bn9W6Z1r62nvvrzzQdbmB
	yZ6dFK3xLlv0gSC+G9Ss+PuVzZlKUrtDrUoiRK36X2mdGvKSAwAA
X-CMS-MailID: 20220214080656epcas5p31c80cce4f9638bccdf2bc225b339c37e
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080656epcas5p31c80cce4f9638bccdf2bc225b339c37e
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080656epcas5p31c80cce4f9638bccdf2bc225b339c37e@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E8aMTr009271
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
Subject: [dm-devel] [PATCH v3 09/10] dm: Enable copy offload for dm-linear
	target
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Setting copy_supported flag to enable offload.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-linear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 1b97a11d7151..8910728bc8df 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->copy_supported = 1;
 	ti->private = lc;
 	return 0;
 
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD55FC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:34:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557--P5uns5nNBeJVK0WzbO-HQ-1; Tue, 08 Feb 2022 17:34:32 -0500
X-MC-Unique: -P5uns5nNBeJVK0WzbO-HQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B86D87498E;
	Tue,  8 Feb 2022 22:34:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CDD6610F4;
	Tue,  8 Feb 2022 22:34:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5044D5ABFF;
	Tue,  8 Feb 2022 22:34:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217EWF5c012766 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 09:32:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 24F7853D4; Mon,  7 Feb 2022 14:32:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FBAD53D3
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:32:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB30A805A30
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:32:12 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-295-6lTu5EzVN-iqTaxovekfQA-1; Mon, 07 Feb 2022 09:32:10 -0500
X-MC-Unique: 6lTu5EzVN-iqTaxovekfQA-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id
	20220207142315epoutp03a8e65665f04dadd5872093af40fdf8cc~RhwVVnrpY0886008860epoutp03y
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 14:23:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
	20220207142315epoutp03a8e65665f04dadd5872093af40fdf8cc~RhwVVnrpY0886008860epoutp03y
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20220207142315epcas5p2be6dc0621dddd26ec2b31fe21213bdac~RhwUdb3uA2564925649epcas5p2B;
	Mon,  7 Feb 2022 14:23:15 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4JspJt0blLz4x9Pr;
	Mon,  7 Feb 2022 14:23:10 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6B.5F.06423.D4B21026; Mon,  7 Feb 2022 23:23:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20220207141953epcas5p32ccc3c0bbe642cea074edefcc32302a5~RhtYhzyQR0472404724epcas5p3T;
	Mon,  7 Feb 2022 14:19:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220207141953epsmtrp2942ef1027f5892f95340e5a0f3d86c36~RhtYgd2Ov0696106961epsmtrp2Y;
	Mon,  7 Feb 2022 14:19:53 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-5b-62012b4d1175
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	9E.43.08738.88A21026; Mon,  7 Feb 2022 23:19:53 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20220207141949epsmtip13c85572436db3ea86918946d1d20c13b~RhtUwTRkj1635016350epsmtip1f;
	Mon,  7 Feb 2022 14:19:49 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: mpatocka@redhat.com
Date: Mon,  7 Feb 2022 19:43:47 +0530
Message-Id: <20220207141348.4235-10-nj.shetty@samsung.com>
In-Reply-To: <20220207141348.4235-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxT3u/dyW8iQO8TwSUboarYMCNg6ih8MJnFgrkOgzvHPlsmucFee
	bdeWbT4COGThIe/HGGY8nCkTCDiQDoSCYNAgYJjQMggICD6oW2HgmAiuK7Q6//udc36/75zf
	+XK4uOMvHBdunFTFKqRMIp+0IzTX3d/xCvcExwXrJQB1jq/YoPqpfBKVLa3haLFnzgYV5Zdz
	0Mj8dqQ1nrdBw0/PYGiu2YShzgtFGLpU34ehh7U/AZQ1MIyhjVkh6jP9SaKiXj1A2glP1Knt
	J1CV+j4H5Yy1kajrsRZHtTf/xVBhpg5Dtys2SKRZr8LR9bs6AtVvIJRxbo2DDN3HglzpkdFQ
	ujDdyKHTqycJemQomW6uyyLploupdPHvtYDuGE8j6W8H+3C6fPkJSY8N/orRuelGkv7r/gRB
	a2ZzOfRil46k867UAbHTJwkBsSwTwyp4rDRaFhMnlQTyQ49GfRAl8hUIvYR+aB+fJ2WS2EB+
	8GGx18G4RPOS+LyvmMRkc0rMKJX8Pe8HKGTJKpYXK1OqAvmsPCZR7iP3VjJJymSpxFvKqvyF
	AsFekZn4eULs7HIvIX9EfFN67Xs8DZjwbGDLhZQPbMmvJbOBHdeR6gBQN1qJW4JlAPUPDRxL
	sAJgy8w4eCGZGe+ySq4C2DFpxCxBBgbb/3hirnC5JOUJB0zcTYET5Qw3hjVgk4NTKwTUj1Vw
	Ngs7qIOw/9Y4sYkJ6i14x9S+he0pf7hSq8Ys3XbDmtkem01sa86vbpRZOa/D/h/mtzBOucH0
	1vNbc0NKbws1eZWERRwMF55nW53ugIabVzgW7AJXjFrSIsgB8OngNGYJygFML0gnLaz98LfO
	59imHZxyh01X91jSrrD0ViNm6bwd5q7PWye1h22V8y+nbmiqtj6zC+r/OWPFNJwoLbWxrGsU
	QE2nligAvIpXHFW84qji/9bVAK8Du1i5MknCKkVyoZT9+uVHR8uSmsHW7XgcagNTM0vevQDj
	gl4AuTjfyf6NHBPjaB/DnDjJKmRRiuREVtkLROaVF+IuO6Nl5uOTqqKEPn4CH19fXx+/d32F
	fGf7AcllxpGSMCo2gWXlrOKFDuPauqRhIl1Iw9q5BP+SywtvZg3N9wkCP102tfMGQ0Rr6oJT
	Orthl8jw/YO2x0S121aDMzJ/Dtwo7gtveDskTnx3ahbnd3RM26Xk5kUdbpyIv6hudObdFquC
	kOvZ1dH3KIe21A9Tfuz+0rTTZ2E47FG8YaLkdP01qqfsRtqlB0MOzyQU8jjienS6RnNc084c
	CLinFHwU711fnhomSjp9tmmxOFR2bym+QDL5GASpW/c62YmcxTml0Z9FKG6cigjaltHx4Mjf
	vLyTwsI1d5HoUKRSHME/YNsZNuj2RfedwH0jRkEK70JZlb4ltApkqn2jv3MwND5rnas5OCuy
	e21c97HRLTLMcIJPKGMZoQeuUDL/ATJBsrHEBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsWy7bCSnG6nFmOSwdo7zBZ7bn5mtVh9t5/N
	YtqHn8wW7w8+ZrWY1D+D3eLyEz6Lve9ms1pc+NHIZPF4038miz2LJjFZrFx9lMni+fLFjBad
	py8wWfx5aGhx9P9bNotJh64xWuy9pW2xZ+9JFov5y56yW3Rf38Fmse/1XmaL5cf/MVlM7LjK
	ZHFu1h82i22/5zNbHL53lcVi9R8Li9aen+wWr/bHOch6XL7i7TGx+R27R/OCOywel8+Wemxa
	1cnmsXlJvcfkG8sZPXbfbGDzaDpzlNljxqcvbB7Xz2xn8uhtfsfm8fHpLRaPbQ972T3e77vK
	5tG3ZRVjgEgUl01Kak5mWWqRvl0CV8bDT4dYCl6wVEw9MJ25gfE/cxcjJ4eEgInEg5v72LoY
	uTiEBHYwSsw/3sMGkZCUWPb3CFSRsMTKf8/ZIYqamSTeLP4DVMTBwSagLXH6PwdIjYiAuMSf
	C9sYQWqYBaazSjScuswEkhAWcJM4eeomC4jNIqAqcen/TjCbV8BK4vPyZUwQC5QlFj48yApi
	cwLFv/2ZxgKxrIFRouHcClaIBkGJkzOfgDUzC8hLNG+dzTyBUWAWktQsJKkFjEyrGCVTC4pz
	03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCk4KW1g7GPas+6B1iZOJgPMQowcGsJMIr0/0/UYg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQamuSLugvUOQnum
	7n0VVJr/qeFg0LWK35NshS+d5DcuLPIw27ym5e2XWY+q0/Zp3XTnX5YYdtRzknWzZGRq6Ncm
	zZkb9EpC2yf835vOsCsgo+Nfn80VnuaPpaFZQW9Wr9ZkjXGX//PJOTnt/2qx2/O3On7g2+i5
	aFs81yyZu4rT1/7Tlerk3c9+LrOkTfjRhqaXZiJW7yvnGV1is2KYojU99Zu1nktJnoXZ31qr
	A47sRaH/lvzWruoJ+z/zHfvVNvFL/gsUz5mt638StnLu9V3NfA6tFZ8dBHc2TZvKNqf+l9kH
	uZkybYGfDRyzurK+vFCe7SGtwiF5zNr8yikm35XVHdLZf3afuv+4XXTJ1KtKLMUZiYZazEXF
	iQDOaJpbeQMAAA==
X-CMS-MailID: 20220207141953epcas5p32ccc3c0bbe642cea074edefcc32302a5
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220207141953epcas5p32ccc3c0bbe642cea074edefcc32302a5
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141953epcas5p32ccc3c0bbe642cea074edefcc32302a5@epcas5p3.samsung.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 217EWF5c012766
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
Subject: [dm-devel] [PATCH v2 09/10] dm: Enable copy offload for dm-linear
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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


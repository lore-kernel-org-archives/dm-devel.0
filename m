Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62251C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 05:50:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-a3I7V3SANYO5cGyN3C6QhQ-1; Wed, 15 Jun 2022 01:50:40 -0400
X-MC-Unique: a3I7V3SANYO5cGyN3C6QhQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C76F68001EA;
	Wed, 15 Jun 2022 05:50:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED796C44CC3;
	Wed, 15 Jun 2022 05:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA9801947B82;
	Wed, 15 Jun 2022 05:50:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC97519572D8
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 00:57:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A846B10725; Wed, 15 Jun 2022 00:57:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A438118EA4
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 00:57:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89747811E75
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 00:57:06 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-KhlUq9-cNZeMBmpyEGQB5A-1; Tue, 14 Jun 2022 20:57:04 -0400
X-MC-Unique: KhlUq9-cNZeMBmpyEGQB5A-1
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20220615005157epoutp01895a86f18170445b1a7f10970129bf7d~4pQgqbcM92462424624epoutp01Y
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 00:51:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20220615005157epoutp01895a86f18170445b1a7f10970129bf7d~4pQgqbcM92462424624epoutp01Y
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615005157epcas1p27069642b6bf9825e9785df3ae2115c00~4pQgLB18r0466904669epcas1p2j;
 Wed, 15 Jun 2022 00:51:57 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.36.225]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4LN6Fm4jH0z4x9QG; Wed, 15 Jun
 2022 00:51:56 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
 epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
 66.16.10063.C2D29A26; Wed, 15 Jun 2022 09:51:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220615005156epcas1p1c124873ba59260e6f94f3793ef8d3f3c~4pQfRvhA00664806648epcas1p18;
 Wed, 15 Jun 2022 00:51:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615005156epsmtrp2eddaa7ee70159dc923d741f3ba969013~4pQfQwAMp0298802988epsmtrp2S;
 Wed, 15 Jun 2022 00:51:56 +0000 (GMT)
X-AuditID: b6c32a35-1f1ff7000000274f-f5-62a92d2ce564
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 A5.DE.11276.B2D29A26; Wed, 15 Jun 2022 09:51:55 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.104]) by
 epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220615005155epsmtip2e8e37abe0294d2876d4fbe0ca107731a~4pQfCe6DW0333403334epsmtip25;
 Wed, 15 Jun 2022 00:51:55 +0000 (GMT)
From: JeongHyeon Lee <jhs2.lee@samsung.com>
To: snitzer@kernel.org
Date: Wed, 15 Jun 2022 09:51:51 +0900
Message-Id: <20220615005151.4907-1-jhs2.lee@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsWy7bCmga6O7sokg0V/lS3WnzrGbLH33WxW
 i0v377BaXN41h83ixC1pB1aPTas62Tze77vK5tG3ZRWjx+dNcgEsUdk2GamJKalFCql5yfkp
 mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2NkX5
 pSWpChn5xSW2SqkFKTkFZgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGZcXdbEVnGWvuL/uD3sD
 Yx9bFyMnh4SAicSqBZ9Yuxi5OIQEdjBKTFvWzAqSEBL4xCgxfZUuROIbo8T8SbNYYDrurm1n
 hEjsZZR4cf4cO4TzhVGi+8cLRpAqNgFtidstm9hBbBEBMYmG6xfBbGaBPInFL9qZQWxhAW+J
 VQuvgdksAqoSl47/A1vNK2AhsffEUaht8hL7D55lhogLSpyc+YQFYo68RPPW2cwQNfvYJQ5/
 VIGwXSSe9H1jhLCFJV4d38IOYUtJfH63F+rnbInrGw5BzS+R+L6uEWgOB5BtL/H+kgWIySyg
 KbF+lz5EhaLEzt9zGSG28km8+9rDClHNK9HRJgRRoiSx4t81qIESEhsOd0Mt8pDYuekOG0i5
 kECsxNczKRMY5WcheWUWkldmIexdwMi8ilEstaA4Nz212LDAEB6jyfm5mxjByU7LdAfjxLcf
 9A4xMnEwHmKU4GBWEuGdfHFZkhBvSmJlVWpRfnxRaU5q8SFGU2DgTmSWEk3OB6bbvJJ4QxNL
 AxMzIxMLY0tjMyVx3lXTTicKCaQnlqRmp6YWpBbB9DFxcEo1MN1TEIvr+7Jw05XyfqYS1dQp
 NTn6ztPuSN7N45lvYSL4w6N1Qytnxhz5Rv7toTs4On04FzX8bL5QscNiUZLmzIa9GQbSkhtK
 4tMSFXqzulheuPodt/nbv2+x1+9Hz/wKTO/d3mBy85h+MXPrQYst3Y0n3wbFqE06YaV8Yd60
 2XuMNuh3/xET+rPQ/LpEksG92PJ5C8wPLtfa6vAszuWVWKHa1PicKgXl0xtrVRJfrODrm3bG
 +rZNVK2T095p3AoOteYZ+heui0nyTljHmDWNe8KtF7uu3uCet/PUsrcHbZO78iLznxr1M6n8
 PfTQqmbFJoHT9/esnLowM/3So5h41tYlF4K0XvVeelZ3MyuiVYmlOCPRUIu5qDgRAF/uskH/
 AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsWy7bCSvK627sokg0PvLCzWnzrGbLH33WxW
 i0v377BaXN41h83ixC1pB1aPTas62Tze77vK5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
 lxd1sRWcZa+4v+4PewNjH1sXIyeHhICJxN217YwgtpDAbkaJaz+sIOISEhs2rWXvYuQAsoUl
 Dh8u7mLkAir5xCjx+9dqFpAaNgFtidstm9hBbBEBMYmG6xfBbGaBIonn+xaAzRcW8JZYtfAa
 M4jNIqAqcen4P1YQm1fAQmLviaMsELvkJfYfPMsMEReUODnzCQvEHHmJ5q2zmScw8s1CkpqF
 JLWAkWkVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZwCGpp7mDcvuqD3iFGJg7GQ4wS
 HMxKIryTLy5LEuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNT
 qoGJVdn88dZrjy6eT0g5m9Lz6CvrxPOenEt/u1j2BS3+ezfibcYqRrvn/gXiHsFfOOuv3qvd
 ccTo5sIF558fevFg9xPJ8mdl3nG7uM7GXgv8LeJ1/PS58LNu7xeFqUzuLThxZM/vuYVR3BdT
 5892Vzux4abWxfm1Uj0/+P7J/vrLcXWx5Np1Ip+n9XFdf/zg78WkXz/CL1/9onkqPfZuxxWF
 BQ8P62sbqK/nuNLcsqWKI3+7yJbD5nVffzbcf+P/95ja74unDkt71KtLih6PfuOU48lnXTQv
 r/sYy87vbRoflx7fevr5m+nW82uimWacX2Gvs3VbsvTtA/6nJWPETzz+f+NudPk+mbN7Njc0
 f+Bpfv1biaU4I9FQi7moOBEA5s5TWbACAAA=
X-CMS-MailID: 20220615005156epcas1p1c124873ba59260e6f94f3793ef8d3f3c
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220615005156epcas1p1c124873ba59260e6f94f3793ef8d3f3c
References: <CGME20220615005156epcas1p1c124873ba59260e6f94f3793ef8d3f3c@epcas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Wed, 15 Jun 2022 05:50:34 +0000
Subject: [dm-devel] [PATCH] dm verity: fixed ERROR: else should follow close
 brace '}'
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
Cc: JeongHyeon Lee <jhs2.lee@samsung.com>, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch fixes the following checkpatch error,
ERROR: else should follow close brace '}'

Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
---
 drivers/md/dm-verity-target.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index d6dbd47492a8..75b66dd67633 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -527,11 +527,10 @@ static int verity_verify_io(struct dm_verity_io *io)
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
 			continue;
-		}
-		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
-					   cur_block, NULL, &start) == 0)
+		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
+					   cur_block, NULL, &start) == 0) {
 			continue;
-		else {
+		} else {
 			if (bio->bi_status) {
 				/*
 				 * Error correction failed; Just return error
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


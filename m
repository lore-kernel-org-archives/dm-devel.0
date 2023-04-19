Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF30BC77B72
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973840;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C/o0Q4svmDVa81a/quIYdvp417fkvYu3F9MwBZxDAOs=;
	b=OHNvjjd+ipr3HTRsvd6URn7uMne/rlz1RghR6imkJC1+eN/EA1kreHNt8ViRxky0By7OsN
	1S54tnTYqtOlTi3bb6VZA17S3niHZPi3I9jDnVPxq35c/DNl15XMVIn3kDqt+JFFQ9eZlO
	OIZQ0G9QUHxA05FQULWgw88qO86/SxM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-4UKTn7S8MRaWlT0c5QmZHw-1; Thu, 20 Apr 2023 02:57:18 -0400
X-MC-Unique: 4UKTn7S8MRaWlT0c5QmZHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A148280604C;
	Thu, 20 Apr 2023 06:57:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA82C40BC799;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B160C19472D9;
	Thu, 20 Apr 2023 06:57:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A82C419465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 11:54:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 88CB851E3; Wed, 19 Apr 2023 11:54:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80A4D2958
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64707858F0E
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:59 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-8ZNkRjcYPNqolT7vMpf7vw-1; Wed, 19 Apr 2023 07:54:57 -0400
X-MC-Unique: 8ZNkRjcYPNqolT7vMpf7vw-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230419115454epoutp03544b33003019edc459def95e26f2ca6d~XU-Q5AVHT1365913659epoutp03L
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230419115454epoutp03544b33003019edc459def95e26f2ca6d~XU-Q5AVHT1365913659epoutp03L
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230419115453epcas5p38f000f783a08296ce1442ed383ed5af3~XU-QVDK4C2577325773epcas5p3M;
 Wed, 19 Apr 2023 11:54:53 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Q1fNW5y7Qz4x9Pr; Wed, 19 Apr
 2023 11:54:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 E4.9D.09540.B86DF346; Wed, 19 Apr 2023 20:54:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230419114801epcas5p2eb7e9c375817d827d5175468de34f0cb~XU5QHChIv1524715247epcas5p2l;
 Wed, 19 Apr 2023 11:48:01 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230419114801epsmtrp1476d5be0b44a2a0755f0370122e2d9eb~XU5QFxr0I1843518435epsmtrp1j;
 Wed, 19 Apr 2023 11:48:01 +0000 (GMT)
X-AuditID: b6c32a4a-70dfa70000002544-a1-643fd68b68b7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 4A.93.08609.0F4DF346; Wed, 19 Apr 2023 20:48:00 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230419114757epsmtip146c11a6792a756842f64d0b81903c6bf~XU5Mf0aLU2050920509epsmtip1S;
 Wed, 19 Apr 2023 11:47:57 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Wed, 19 Apr 2023 17:13:13 +0530
Message-Id: <20230419114320.13674-9-nj.shetty@samsung.com>
In-Reply-To: <20230419114320.13674-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd297W0iKl8LmR/ci3YNhR6EM6gfyMoq7QxbZiPxhNN1NewMM
 aJs+QHCLRR4BfPDSMQoTVIKzqASojIdlrAwRHDORARGDMFfYAxWBCSGusJbi5n+/8/vO7/zO
 OV8OF+cXcwTcVKWO0SjpdCHhzmrv8/cLOD4WrQjKHxKj5qEbODpWZsdR02Qpgeb6FgH66skq
 jqa/j0aWxzVsdLe3E0PXz1dg6FJTP4a6zy1gqH/9EYEqrGMAzYwaMWSZEKHrlkEWGumqJVBd
 4wwHWSvzMNRhywWo/Vkdjq7OzbPQzYlX0W37ADsGUiO/7KWMU8ME1Wmc5FC377ewqJFhPdVq
 KiaotoajVPddA0GdzHtMUPM9owR1ymwCVNutI9RS6xtUq+0RluBxIC0ihaEVjMaXUcpVilRl
 cqRwb6JslyxUGiQJkISh7UJfJZ3BRAp3xycE7ElNd2xA6JtJp+sdVAKt1QoDoyI0Kr2O8U1R
 aXWRQkatSFeHqMVaOkOrVyaLlYwuXBIUFBzqSPwsLaXKVMVW57IPz9p/IAzga1YJ4HIhGQJ7
 2hJKgDuXT3YDaLl8heMKFgG8s9ZIlAA3R7AEYFev3ImdgsrRuk2+C8C2p1yXoACDXfb2jaoE
 KYK31jd4b7IQhwszxSxngJN3MPiPeR53qr3IWDh4fo3lxCzyHbhwrXcD88hwWGZrIVztBcLS
 KU8n7UbugBd7KnFXiiccrLZtpOPkmzDvWg3urA/JOjdYZT5BuDrdDccNw5vYC/41YOa4sAD+
 WVq4ibPgpdPfEi5xPoDGcSNwPUTDgqFS3NkETvrD5q5AF/06PDN0FXMZe8CTz2yYi+fBjrPP
 8VvwcnP9pq8PHFvJ3ZyFgg1nRK5lnQJwYW6VXQZ8jS/MY3xhHuP/zvUANwEfRq3NSGa0oepg
 JZP13x/LVRmtYOMmtsV1gF+nn4itAOMCK4BcXOjN+yk2XMHnKejsHEajkmn06YzWCkId+y7H
 BS/LVY6jUupkkpCwoBCpVBoS9oFUItzK84sclPPJZFrHpDGMmtE812FcN4EB+47WZSUtfVyQ
 xEmSH2+hLk738xRMzJZvjm6J5qZ9aZ5iPaw4JIt5lz29JrFHLt970K23fLE8UYQO/ahM3LF2
 MHCrT8z99wqjgstPPBTON/dNdWtmpYGrT6kPDTm5WtuAELpNFyX18ffXAHoyy/z5cL7J+8LZ
 gwNRr436Uce48tPEhI+lc2dS277IcXH9in02YPGwx7nkcjr205Xfx4bcFWnc2oa/398z2UzL
 DDli4P0gu5oXX50iCEaviOKkff5FF/jR8S+JboZmNmVmCxLj8MyP1oPLl/9YXXs73NxBY2D7
 Pc+fE0zY/gOyTEPjziteEUc4nE+sv+3Lrp1jbiyIhCxtCi3Zhmu09L/Q6E0JnAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRzGe885Ox4Hs9MSfVObtehDSpZi8GqmVqiHkqwIArvYagcnzTk2
 LbMkbRBkmUMjdWam1cQl2TTFyyxb3pa38JJleaOZlTg198XErZwEfXt4fs/z/D/8KZxvJDyo
 BFkyq5CJpEKSS9S9FQp2zg+GiXdbi0JQ1bt2HN1Qr+Do2WgOiWbe/gLo/vwSjiZeh6FmSxEH
 fWppwJChLBdDFc/aMNRUuoChNvssiXKNHwCaGtJgqHnEFxmaTQQaaHxAohLtlBMy5qkwVG/O
 BKhuuQRHz2fmCNQ54on6Vjo44ZAZGDzMaMZ7SKZBM+rE9I3pCWagJ4Wp1t0imZon15mmTxkk
 k62ykMzcqyGSuftSB5iarqvMYrWAqTbPYkddYrkhYlaacIlV7Ao9x5Xk6/I58kxO6reVN2QG
 KCCygDMF6UCYN1RCZgEuxafrAfz+sRxbA5ugdqUVX9MbYYVt2mktpMLgzGjlX0BRJO0Lu+zU
 qu9Kq3HYP57hWMLpCQz2TVs5q+2NdAQ0ldkc5wh6O1yobXFoHh0M1WY9uToE6V0wZ3zDqu1M
 74Xlr/Ich/l/I3eMNrAW3wBNhWZHFae9oaq2CFcDWvMf0vyHHgFMBzaxcmVifKLSXx4gYy/7
 KUWJyhRZvN+FpMRq4Hizj089MOjm/YwAo4ARQAoXuvK6I4LFfJ5YdCWNVSTFKVKkrNIIPClC
 6M57n2WK49PxomT2IsvKWcU/ilHOHhlY59abr5fm08/GhCD7xMlrj3sq0iUhQT4zB7PFEcqX
 3sVF0vsCVlXu+8Z2Wuu0bfyA3SPotibetP78noLfWw5MVgmx4bljP7WD52vaR+CZL43Lbmxq
 IPQ+U+hle1ozdbU4/9SP9IAk16Z9tMRWuWT4udx3OTl0gccXp81N+Ftj9IV6uTRHgLoNOxYK
 Jq3am3pL/+eH97idA7cY21JvvnOBb7TF3a33+LRK3TGyOXQxHIwJetbx/LfebvULjj0S5akv
 OdFSK4mdtNmHItUpluj9L1KjSiWHjqmqIs05dd2HYABuGlQjN1nl8W+/JGUue6z9ix6jX4V5
 XieGXRrVQkIpEfn74Aql6A8UcQ2tVQMAAA==
X-CMS-MailID: 20230419114801epcas5p2eb7e9c375817d827d5175468de34f0cb
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230419114801epcas5p2eb7e9c375817d827d5175468de34f0cb
References: <20230419114320.13674-1-nj.shetty@samsung.com>
 <CGME20230419114801epcas5p2eb7e9c375817d827d5175468de34f0cb@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: [dm-devel] [PATCH v10 8/9] dm: Enable copy offload for dm-linear
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Setting copy_offload_supported flag to enable offload.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-linear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index f4448d520ee9..1d1ee30bbefb 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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


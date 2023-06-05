Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA0DC83005
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685968209;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C/o0Q4svmDVa81a/quIYdvp417fkvYu3F9MwBZxDAOs=;
	b=cSluSjpWoV7qct4BK5N9HsxCjm5oYl1eM8hqj/zI+k4LDazQJcWGl5cPCezfxTdBeOFaJQ
	3Y1jMl5y2J9ZOLh3hTughys8p82KaCRRr3qzuibkHZM71KpfHQz3cyt2usq0rYRuk7cLLE
	p5Sx9ygwJBq7if38yckXmm4/5TMSXs8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-cuqbCMpcND28KWiozP8iLg-1; Mon, 05 Jun 2023 08:30:07 -0400
X-MC-Unique: cuqbCMpcND28KWiozP8iLg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91C932A5957B;
	Mon,  5 Jun 2023 12:30:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7FEB0C154D3;
	Mon,  5 Jun 2023 12:30:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A68719465A3;
	Mon,  5 Jun 2023 12:30:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B5AEF1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 12:30:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A5E99C154D2; Mon,  5 Jun 2023 12:30:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DF80C154D1
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 12:30:00 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7278E185A7A8
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 12:30:00 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-XjtZsGIcNjKk6qdNZ3T4Kw-1; Mon, 05 Jun 2023 08:29:58 -0400
X-MC-Unique: XjtZsGIcNjKk6qdNZ3T4Kw-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230605122955epoutp04638a637b9b14004a6b4bc6add5207ab0~lwyQgvNji1876818768epoutp04e
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 12:29:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230605122955epoutp04638a637b9b14004a6b4bc6add5207ab0~lwyQgvNji1876818768epoutp04e
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230605122954epcas5p229827afd5b605331722ca1efe39ab864~lwyP7jP3I1471314713epcas5p22;
 Mon,  5 Jun 2023 12:29:54 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4QZXxF4ZS0z4x9Pv; Mon,  5 Jun
 2023 12:29:53 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 10.6D.16380.145DD746; Mon,  5 Jun 2023 21:29:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230605122402epcas5p2d2fc7493b04aaa70363324429411e689~lwtIQAFJl3244432444epcas5p2Y;
 Mon,  5 Jun 2023 12:24:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230605122402epsmtrp2ba078ddca865e8855cd175a22e7a9086~lwtIO99cp1056210562epsmtrp2j;
 Mon,  5 Jun 2023 12:24:02 +0000 (GMT)
X-AuditID: b6c32a4b-56fff70000013ffc-24-647dd541d8d3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 1B.BC.27706.2E3DD746; Mon,  5 Jun 2023 21:24:02 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230605122357epsmtip2c0fc194d4469fec3c69fc0db88c10697~lwtDg78hu2527325273epsmtip2o;
 Mon,  5 Jun 2023 12:23:57 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, James Smart
 <james.smart@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Date: Mon,  5 Jun 2023 17:47:24 +0530
Message-Id: <20230605121732.28468-9-nj.shetty@samsung.com>
In-Reply-To: <20230605121732.28468-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzeube9FCbkUtk8wobsOuYAgXZAPSD4GGhugE2MS+ZGFmjam0Io
 bdcHzhEzGqYbD4sgLwtBECZQpjgeXSl207LJQBk6XoHMiVi2AAsvcWgI2yiFzf++33e+3+s7
 +XFwbr2TJydVpmaUMqGUIlxYxi4/v8CDQ6fEvLZhCjX33sJR0/0CAs10LQJUOv8MR7YbXwA0
 YHND49/vR5bZCjYavdGBoeuXijDU2PQjhjprFjBUZB0GaHJIjyHLWACqOVPHQtctPSw0YK4k
 0MXLk04ob8REoPruvzFkPZ+NIZNNC5Bx5SKOrs7MsdBPY16of7WbjVaeVhIHXqEHBuNo/YM+
 gu7Q33ei+3/7hkW3NvjTA30ausWQQ9CtdZ/RnaNZBF2rO8+mz2bPEvTC5BiLnvtuiKB1bQZA
 t97OpB+3eCe4f5gWmcIIxYzSh5GJ5OJUmSSKijuWFJ0UJuDxA/nhaA/lIxOmM1FUTHxC4OFU
 6Zo7lE+GUKpZoxKEKhUVvC9SKdeoGZ8UuUodRTEKsVQRqghSCdNVGpkkSMaoI/g83ltha8Lk
 tJQyQxlboWV/8vvqTSILlLNygTMHkqHQbC7Gc4ELh0t2AninvxI4gkUAy6cfbbz8BaAxpwjb
 TKksyQZ2zCUtAOa3fewQncag9YnJKRdwOAQZAG//w7HzHmQDDrXLd1j2ACfrcNj45zzbLtpK
 HoIjC4fshVikL5yoXWLbsSsZAQef1q7XgWQwLHjgbqedyb1wqs+KOyTusOeCbX0FnNwBs9sr
 1geFZK8z1JZPAMegMTD7h7kNvBVOd7c5ObAnfDxrIRz4BGwsbiAcyZ8DqB/RbyTsh6d7C3D7
 EDjpB5vNwQ76VVjSexVzNHaDZ1dsG6a4QlPVJt4Jv26u3qi/HQ4vazcwDScGpzGHWToAu5a1
 2Dngo39uIf1zC+n/b10NcAPYzihU6RJGFaYIkTEn/vtlkTy9BaxfjH+cCUyMzwdZAcYBVgA5
 OOXhao7NFHNdxcKTnzJKeZJSI2VUVhC2Zngh7vmSSL52cjJ1Ej80nBcqEAhCw0MEfGqb666o
 HhGXlAjVTBrDKBjlZh7GcfbMwvIqMrYtst59mOjdHhGgTqZee8PjhZrqX0tjBpO73lve83bp
 y1dg1wXnAmaLdHS3r9PUsdwkE394OSe+fWJqxyIjEbiOyu95+M1X3qztQE8Oqhd0ZT+nrRCt
 q7VGlzboFvO+WR0XO976Zu5EZM7l8EpFptVblr/zGbAZX/fNC6kWuR817L5iOe7WlUiVa2yr
 19yD6r+sj9dc27XUTVa5/XGySHcv2mcmuOAdrx7jmG9m3N2jL36bUbKyL79plBR9FKtO5FJH
 brXnX+KNFicWBX+QLz6iOKU//LDQWdxT1bS3iDgwKZDMVBdGZy1ovzJ4HY+8a1U+2uLSpOvR
 /XKGXqoZpliqFCHfH1eqhP8CtvkgJboEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa1BMYRjHveecPXtqpNPGeCu5nFkZSyWMeYUtTDNnoqZcxuVLlo4y2m1n
 Twk7xmaJFmU0iW1da4qVS8UqabFyyc4KK03RUjaXot0w7oWtMePb//n/fvPM8+GhcNFzIpDa
 oMjgVApZGkN6E6ZbzLjQTvu25Gnl5unowv07ODrbnk+inlsfATrk/o4j543dANmdI9DL61Go
 vrdYgFpv1GLo2qmDGDpz9jaG6k72Yeig5SlAXc16DNW3TUEnc0oJdK2+kUD2qwYSHS/rEqK9
 LTUkKr87gCFLgRZDNc5sgEw/j+PofI+LQPfaglBT/10B+vnNQEaPYe1PFrH6FzaSrdW3C9km
 RyXBVp+WsHZbJltlzCXZ6tLtbF2rhmRL8goE7H5tL8n2dbURrMvcTLJ5l4yArbaq2U9VYxP8
 VnvPTebSNmziVOHSNd6pRcYigTJbsPl1/01SAw4TOuBFQXomNBRqgQ54UyK6DsB25zPhEAiA
 Zf0N+FD2h2cG3giHJC0GW8tcAh2gKJKeAq2/KU8/kr6EQ9uPAoFnwGkTDt3uz0KP5E/HwJa+
 GM8igp4IO0s+CzzZh46ET76VDCqQDof5L/w8tRc9B76zWXBPLfqrNLvmDtl+sPGIc/BmnB4H
 tZeL8QOA1v+H9P+hEwAzggBOyctT5HyEMkLBZYXxMjmfqUgJW5curwKDDyCZXAOuGN1hFoBR
 wAIghTMjfa7GqpNFPsmyLVs5VXqSKjON4y0giCKY0T4PdY1JIjpFlsFt5Dglp/pHMcorUIOt
 DPvi4B/9sGYERE/taBoeFxpkqFf3Pt1MpK51xSd0DyzQjKrYL5nXtcNyWlk7kGedlSscVhlp
 HsOIXf67EtQitzTJLI6ZFvD2w4qWQ0tmGczRzKpIuyN2wZrxo4Ivcl95e/yz+Uf5sTayZ6VG
 0R1evc8gyT3q7M6u2NjQLH6VI9WXV3zsEM6b8Wjp99i49cuCXNaQmUCtdO8ypiVm9WVN/iAN
 7A7NfjVaaF+YJbtQ/CDEt6G4srGi09ERvFy8I14n3unY5upMYuZMYkIem/oDj01I7CnKT19c
 rpIuySkM/oUvBXWZs2XRe1Zv+XpvZy8RZXoojzrn9d7XN4405MkZgk+VRUhwFS/7A62CYfhv
 AwAA
X-CMS-MailID: 20230605122402epcas5p2d2fc7493b04aaa70363324429411e689
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230605122402epcas5p2d2fc7493b04aaa70363324429411e689
References: <20230605121732.28468-1-nj.shetty@samsung.com>
 <CGME20230605122402epcas5p2d2fc7493b04aaa70363324429411e689@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v12 8/9] dm: Enable copy offload for dm-linear
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
Cc: linux-nvme@lists.infradead.org, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, djwong@kernel.org,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org, willy@infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
 gost.dev@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F45C001B0
	for <dm-devel@archiver.kernel.org>; Mon, 14 Aug 2023 13:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692018423;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=v8lApocmj5cFtaqiGCOdz4jQJDju/sH45b0aAz2k0RM=;
	b=b40Vj31nTEQ9bGQgp+81Whzlrd2u/Fz5vz/vKB2/vCm7JbF6vx3kNqq354xnrZStTnnJkR
	6+zahf0csgfq2rU118EFXLg6EZPgZdF+ppCWB4WqRKDrrVtHzB91rKXQD9E3rlhgotB6C/
	ZhAbBmZwgbOnFxXTLnfQ8mu+pNapLCA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-r0gohb1RMVW3VwGQl-oxJA-1; Mon, 14 Aug 2023 09:06:54 -0400
X-MC-Unique: r0gohb1RMVW3VwGQl-oxJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BC5384B07D;
	Mon, 14 Aug 2023 13:06:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26639C15A0B;
	Mon, 14 Aug 2023 13:06:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D44001946587;
	Mon, 14 Aug 2023 13:06:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B1071946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Aug 2023 13:06:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C76F14021C9; Mon, 14 Aug 2023 13:06:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE4D84021B9
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 13:06:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9969129DD9AD
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 13:06:30 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-JClS_lgjNaa3sjObnYW1fQ-1; Mon, 14 Aug 2023 09:06:27 -0400
X-MC-Unique: JClS_lgjNaa3sjObnYW1fQ-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230814130116epoutp04fe3aac3ecb8788392f25f1f321840a2a~7QXnc5ej81670516705epoutp047
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 13:01:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230814130116epoutp04fe3aac3ecb8788392f25f1f321840a2a~7QXnc5ej81670516705epoutp047
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230814130116epcas5p174c4ae8fa6883c326483da4c005b41ca~7QXm56LGG0176601766epcas5p1A;
 Mon, 14 Aug 2023 13:01:16 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RPZK61vZgz4x9Pq; Mon, 14 Aug
 2023 13:01:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 BE.21.57354.A952AD46; Mon, 14 Aug 2023 22:01:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230814122212epcas5p37453fdef19909077528971ee54ed26e7~7P1gNwF260611606116epcas5p3C;
 Mon, 14 Aug 2023 12:22:12 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230814122212epsmtrp14a1aafb5de1203698ae6790f4309bb83~7P1gMve2K1933719337epsmtrp1B;
 Mon, 14 Aug 2023 12:22:12 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-3f-64da259aa015
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 D1.07.64355.47C1AD46; Mon, 14 Aug 2023 21:22:12 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230814122209epsmtip2edb1c9a304e2560d48518e12f30945ff~7P1dR_UgZ0493104931epsmtip24;
 Mon, 14 Aug 2023 12:22:09 +0000 (GMT)
Date: Mon, 14 Aug 2023 17:48:53 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20230814121853.ms4acxwr56etf3ph@green245>
MIME-Version: 1.0
In-Reply-To: <3b1da341-1c7f-e28f-d6aa-cecb83188f34@acm.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfVDTdRi/7357A5v9HCDfzQpugaIGbDrmF4Ighe53acnlnV3xxxjsd4wY
 29qYUCcniBggCPkWG8ooMV6PwSREXmpCtgaRL8TEeRZXUAmCCAcCHaOxQfnf53mez+d5vYeJ
 sQsZXGaqIoNUKyRyHt2T2ta7PShYH2iX8s/e2ICMfT9g6HjZMoYaHpbS0UTvDEAXphcxNGr+
 DKCR76JR91QFDd03X6eguoabFHSmxwbQ2JCegrrtO9GXJ6upqKvbSkWDHRfpyPD1GAPVWBwU
 NFw2BlDTxBMq+tG+Bd1attBiNhODv+wnbv3aQiUGB7SEqb6QTlytPkZ03s+hE5dPn6URJXlT
 dOLpmJ1KPPl2iE6cbq0HxKzpFcI0OkmJZ32YFikjJVJS7U8qkpXSVEVKFG//IfE+cZiILwgW
 hKM9PH+FJJ2M4sUeiA9+K1XunJnnf0Qi1zpd8RKNhhf6RqRaqc0g/WVKTUYUj1RJ5SqhKkQj
 SddoFSkhCjIjQsDn7wpzEhPTZO1WHUNlZ2Q5/u7EcsBtehHwYEJcCJuXnoEi4Mlk450Amno6
 qG5jBsDpWdv/xrDFRluX5Fb/TF3FbPw6gFar2E36E8DylvMuEhUPhJWnzIwiwGTS8Z2wf4W5
 6vbGg+D8SI0rKYbraLCtsRJbDXjhaVD3wObqiYWL4InZhzQ33gStulFXMQ/8dXjj4oKL44O/
 BMuvzGGriSD+hQe8/Uc/WC0G8VjY9X2Qu1EvOG5pZbgxFz4qPbmGM2HduVq6W3sCQP09PXAH
 omF+X6mrIQyXwaJ7BWuCl+H5viaK278RlvwzSnH7WbC9ch2/ChuNVWtL5UDbs9w1TMDyqWsU
 94amAextKMbKgJ/+ueH0z9Vz4whYOH2cpnfOg+FbYI2D6YbbobEjtArQ6gGHVGnSU8jkMJVA
 QWb+d/FkZboJuH5iR2w7GDY4QnoAhQl6AGRiPG9WMcsuZbOkkk8+JdVKsVorJzU9IMx5rM8x
 rk+y0vlUigyxQBjOF4pEImH4bpGA58uayL8kZeMpkgwyjSRVpHpdR2F6cHMo/MW8OP7e2mWv
 vXX5nm8L75yytSWRFexS3e9dw2SxQSR4MaBumJNfNjc0GXro8KaqloitWZGc7NwQ7wDla7a8
 Rt9mSYzFGCeDhYMb5NkrWRRObWLFZXHCzK7Jgy8MFORVd8f3Jrb6VH7VdHNk1I9m4XKWzk08
 np+O6jL9thx46bBuYGXbNcf7ez6eR1s/esfcKN/t6Zta49/SXGJO7yzQMrOFuKFdcZV6cOOB
 C7PY5sdHOt40JWdb/e4u9S5GrzC01Plxx5Lxp6TOOG5uQsL4B2ZDwz7de0cXLLyWp0MBfyVN
 ZX6TYyw4OiHZ9kB55m6/d8yxO48QsVhoqEqYezfvygKPqpFJBDswtUbyL9O+GpucBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWy7bCSvG6JzK0UgyUT+SzWnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WTA+2MFg/221vsfTeb1eLmgZ1MFitXH2WymHToGqPF06uzmCz2
 3tK2WNi2hMViz96TLBaXd81hs5i/7Cm7xfLj/5gsbkx4ymix7vV7FosTt6Qtzv89zuog5nH5
 irfH+XsbWTwuny312LSqk81j85J6j903G9g8FvdNZvXobX7H5vHx6S0Wj/f7rrJ59G1Zxejx
 eZOcx6Ynb5kCeKO4bFJSczLLUov07RK4Mo6tbmQp6GGt2DbhLlMD4xyWLkZODgkBE4nGJeeA
 bC4OIYHtjBKXe5+yQSQkJZb9PcIMYQtLrPz3nB2i6AmjxP7bB5lAEiwCqhLzug8AJTg42AS0
 JU7/5wAJiwhoSHx7sBxsKLPAXFaJZb/Ps4MkhAWyJe4eWw+2gFfATKLl811WiKEfGCW+zbnE
 CpEQlDg58wnYecxARfM2P2QGWcAsIC2x/B/YAk4Ba4mDc36AzREVkJGYsfQr8wRGwVlIumch
 6Z6F0L2AkXkVo2hqQXFuem5ygaFecWJucWleul5yfu4mRnBcawXtYFy2/q/eIUYmDsZDjBIc
 zEoivD28t1KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yrndKYICaQnlqRmp6YWpBbBZJk4OKUa
 mDzCpxpc3h/7Y5X+wzeb9jlvt+M4Fh7brem0xSfksmxoImecvveU2fN5b32Ukm86HtVxrHRS
 x47vF4V7nvBcWLxIt1OsKbzqnmn8liknMjLNreu8uP7GR3GulX4iKa2q8+KWD18+t9bvFK1D
 Etvua1mr9l/k+7WiMG8qz9aQD2xqn6bEyf3/FG72Tt+SOU3WmmNL6DWPr3t6VbnypRoMjq01
 uyOmKXhkg7uVoFitUsbiXewddnfv33bZeWJ35ZnkIzHTN7q8WmPCoMK4YOqDHOFP4mz3hDqb
 unYtDJvX/9w1lumlXGsqn/SplOnnrNxD9uzwPXN6efaRyxscPC43PPc+vFHFP6zzzQoeYdZk
 JZbijERDLeai4kQAwZ9RKVoDAAA=
X-CMS-MailID: 20230814122212epcas5p37453fdef19909077528971ee54ed26e7
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d@epcas5p3.samsung.com>
 <20230811105300.15889-3-nj.shetty@samsung.com>
 <3b1da341-1c7f-e28f-d6aa-cecb83188f34@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v14 02/11] Add infrastructure for copy
 offload in block and request layer.
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 mcgrof@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_54933_"

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_54933_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/08/11 02:25PM, Bart Van Assche wrote:
>On 8/11/23 03:52, Nitesh Shetty wrote:
>>diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>>index 0bad62cca3d0..de0ad7a0d571 100644
>>+static inline bool op_is_copy(blk_opf_t op)
>>+{
>>+	return ((op & REQ_OP_MASK) == REQ_OP_COPY_SRC ||
>>+		(op & REQ_OP_MASK) == REQ_OP_COPY_DST);
>>+}
>>+
>
>The above function should be moved into include/linux/blk-mq.h below the
>definition of req_op() such that it can use req_op() instead of 
>open-coding it.
>
We use this later for dm patches(patch 9) as well, and we don't have request at
that time.

Thank you,
Nitesh Shetty

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_54933_
Content-Type: text/plain; charset="utf-8"


------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_54933_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_54933_--


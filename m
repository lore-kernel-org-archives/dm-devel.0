Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3321DEE7FF4
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 11:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694430800;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=czy9BFAjTYY7WM1aHAg43gc0zk5raS/M7xCptAOUxng=;
	b=FwNfUl0YDEXle4+A2j2SA8QNRi1t7NhxFmVkKxupkVdmRWRDMCt46v47pAIXzJ+NkutAsa
	zEI7R3HEMVW0/Sr+w/nrY8UasdhfPImj2ZQhY+j0LfiwecnbWpixSS/EyLYbDO7CVOJPVL
	bVBfu0kpUAMJjJKGjacj/647H+vlvd4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-SL4nFVS5NTay7dPfsQxl7Q-1; Mon, 11 Sep 2023 07:13:15 -0400
X-MC-Unique: SL4nFVS5NTay7dPfsQxl7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A1603C01BA4;
	Mon, 11 Sep 2023 11:13:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9F45D2024CAE;
	Mon, 11 Sep 2023 11:13:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 74F6A19465A0;
	Mon, 11 Sep 2023 11:13:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE3D91946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 11:13:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D5F6110005D4; Mon, 11 Sep 2023 11:13:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE5E910F1BE8
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 11:13:06 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC1DF916EE0
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 11:13:06 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-l3f3EjbHPw2-gJMnAgt1ww-1; Mon, 11 Sep 2023 07:13:04 -0400
X-MC-Unique: l3f3EjbHPw2-gJMnAgt1ww-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230911111301epoutp04640237cd7378369a4a15b610a0005810~D09F9vKtd2665626656epoutp04D
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 11:13:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230911111301epoutp04640237cd7378369a4a15b610a0005810~D09F9vKtd2665626656epoutp04D
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230911111301epcas5p1051fd04e6eaa20056ab0a6d1098f1299~D09FfFYzh0749607496epcas5p1m;
 Mon, 11 Sep 2023 11:13:01 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4RkkbG2NSNz4x9Px; Mon, 11 Sep
 2023 11:12:58 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 A5.5E.09635.A36FEF46; Mon, 11 Sep 2023 20:12:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230911102615epcas5p15b9cfa2c6817ea714cc133bf4ef010c1~D0URCYF2b2326023260epcas5p1K;
 Mon, 11 Sep 2023 10:26:15 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230911102615epsmtrp1ac75e977eb94c081885a477796d7e0d6~D0URBTKhF2477824778epsmtrp1S;
 Mon, 11 Sep 2023 10:26:15 +0000 (GMT)
X-AuditID: b6c32a4b-563fd700000025a3-77-64fef63a36bd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 19.BB.08649.74BEEF46; Mon, 11 Sep 2023 19:26:15 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230911102612epsmtip23a32d0526f1beeef4865e18f2fd80bbf~D0UOL6Nzl0239702397epsmtip2Z;
 Mon, 11 Sep 2023 10:26:12 +0000 (GMT)
Date: Mon, 11 Sep 2023 15:50:10 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20230911102010.nr5tvrcc754vo73r@green245>
MIME-Version: 1.0
In-Reply-To: <ec35111d-ba31-497b-ab01-b198d3feb814@suse.de>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH/d0+wXW7Kw9/4IsUTQQCtrOUC8Jgg7lrZAmZwyjGQEdvgFDa
 pg+dM0bkoaPKYzw2qALiOhAQ2IBVBAqsyEAc4OSlbAWEwhCkPAyMhQCjtCz+9/mdc77n/M45
 OXQSU0lzpMeI5IRUxBeyqNZkTauLq7vP8rqAPfaAgVV1/kbCEjLWSFi5Pp2KzbQuAszQch1g
 WuMtCvai5SGCNd7NRLDS8jYEy9QNAGyiX4Vg2iE3rOiamow1ah+Tsd7621SssHiChpW0ryPY
 84wJgFXOzJGxjqHd2PiNbwDWs9ZOCbDHe4Z/JuO9XQq8uiyFiteor+ANL+Kp+A9pWRQ8NdFI
 xRcmhsj4XFM/FU+rLQN4zZNL+JvqfXi1YRYJYYTF+kYTfAEhdSJEkWJBjCjKj3XiZHhguCeP
 zXHneGNeLCcRP47wYwUFh7gfixFuNs1yOs8XKjZNIXyZjHX4Q1+pWCEnnKLFMrkfi5AIhBKu
 xEPGj5MpRFEeIkLuw2GzP/DcDIyIjU4x6igSvcNXN26uIPEg304JrOgQ5cLK1A6aEljTmWgD
 gOuJBprJwUQXAdQ++8TsWAbwnvo+sq3ofWCwKLQA3s7rpJgfkwBmDWeTTFFk9CD89VUTVQno
 dCrqBp9s0E1mW5QFF67rtsQktIwC9YnDW+VsUF84O/k71cQMlAcrCo00M78PH+cZyCa2Qo/C
 7tHSrfx26B6Y++MSyZQIooVWsCiti2z+XhD8fkFDM7MNnG6vtbAjfJV+zcIXYGn2PapZnASg
 alAFzA5/mNyZvlWBhEbD4poaS897YU5nJWK2vwtTVw0WOwPWFWyzM7xfdYdqZgc48M9VC+Ow
 wfCcYh5qGwJH1OcywH7VW82p3ipnZh+YMp9AUW0Oj4TuhiXrdDO6wKr6w3cApQw4EBJZXBQh
 85QcEREX/t94pDiuGmwdheuJOjA2Ou+hAwgd6ACkk1i2DLluTcBkCPgXvyak4nCpQkjIdMBz
 c1nfkhztIsWbVyWSh3O43mwuj8fjeh/hcVi7GDPJ+QImGsWXE7EEISGk2zqEbuUYjwwWT+b+
 cSC3Y7zEmFshc/S4/Lr19Ud1tO8Cgn3K9Tncff6hvjlBAQbntG7bi18++iJ/5/HmkTfkwLaG
 7hj+ed2ZlQI39vC/1jdFYR0vL2Vx9ElTeZr3eh4F9IVNpe44cDauKHCwaWopLGQloKT+jN54
 2mu699jTq6fO/XJllz3tlvOfjcxngcLPDk2HRkTYz/Ysbpz+u+qpIF7x+R6bow8DU3dq/IaW
 Cro0cyFeWrayghh6+Wnt1PFTA/F9exPU6/VdPzFPEmCi+S9S16hm5Oz8x+9sHAqSNve1JK72
 Z4+P4ZJM5V3gH5wtXVVoXcZ6gpJdQpOW1Y2zB3VY2v7LeuOOxalVFlkWzee4kqQy/n9j1eHb
 nQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02RWUwTURSGc2emMwNaHQrqRQjGJiYIYWk0eFXcTRzUuMQ1YtRqR7a2YFtc
 MEFQAUUttRhUaqkiQoAoWogLCEIRKy7FpAGVCIJ2RNMA7jtFCxp9+3O+7z/n4dC46AExno5T
 ajiVUioXk57E1UbxhJBFTpcs3Jgehiru3cHRft0Ajso7ckjkbHwPkKM+C6DaPoMAPa2/gaGb
 hXoMlZY3YUhvaQOIb83HUG17MDqXWUSgm7XNBLJXnyGRqZinUInVhaEnOh6gS85+At1t90Mv
 jxwCqGXAKpg7lm3pvEKw9ofJrLnsMMlWFu1ja56mkex5ba6APXagj2Tf8e0E21/XSrLaqjLA
 Vt7fy34wB7BmRy+2QrjBM1LGyeN2cqqw2Vs8Y7tKq6iknHG7c8oq8DTwRpQNPGjITIX2aw4q
 G3jSIqYGwOqOEmoY+MLigdv4cPaGpa6eP5IDwIK8XOAGBDMJNrypI7MBTZNMMLw/SLvHPowY
 vsuyDPk4c0kAB3UNAjfwZiJh76sHpDsLmQh40dT3Z2kTBi+nv8aHgRdsPu0g3Bn/LRVUduPu
 AzjjB0tcQwc8mJnQ1lU6pI9h/OGpC59wHfDK/6+d/187/1/7LMDLgC+XpFbEKLZJkiRKbleo
 WqpQJytjQrclKsxg6OFBgddBp8kVagEYDSwA0rjYR6ixDMhEQpl0TwqnStysSpZzagvwownx
 OKHklEEmYmKkGi6B45I41V+K0R7j07DZ4mXPLcXA6JwyNZvpXzJrYnzeW76tudtnZE/ll31d
 ZzdvzZqZ0bIycAfenUC9aPpco92wsbDx1iyZ0tU32phLRa2ztr36HhE5bY7Nf7XBltoSd9yx
 MGKj/E5diHLPAfOVvJEd33jKNFlf85g3hhNjlmodH+dNX5wh6rY160TRxAg9pLzTVzun26ob
 okZ5b59XfzzXEJ6RGr0s6PkZZ0ja3rknq/iU2MHEBWGJ2hMhXvMlHWvsnRojxUuL/DJPhOuj
 U7Fycm1/j6+C+pnydZc99Pwmg391b7JTvmq9ZvnBwosBwZ1g4dcf8QFNj6gKynoatQpMFsMz
 s/WTfkbDUTGhjpVKgnCVWvoLo9a+hF8DAAA=
X-CMS-MailID: 20230911102615epcas5p15b9cfa2c6817ea714cc133bf4ef010c1
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230906164321epcas5p4dad5b1c64fcf85e2c4f9fc7ddb855ea7
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164321epcas5p4dad5b1c64fcf85e2c4f9fc7ddb855ea7@epcas5p4.samsung.com>
 <20230906163844.18754-5-nj.shetty@samsung.com>
 <e6fc7e65-ad31-4ca2-8b1b-4d97ba32926e@suse.de>
 <20230911070937.GB28177@green245>
 <ec35111d-ba31-497b-ab01-b198d3feb814@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v15 04/12] block: add emulation for copy
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
Cc: Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincent.fu@samsung.com>,
 Christian Brauner <brauner@kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>,
 Sagi Grimberg <sagi@grimberg.me>, martin.petersen@oracle.com,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-doc@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, mcgrof@kernel.org,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----ooWIhDQPe4iZ41CGDouWrWpJ8fGFR_EcoxWGaJuqOMoSQ.xs=_4ba1b_"

------ooWIhDQPe4iZ41CGDouWrWpJ8fGFR_EcoxWGaJuqOMoSQ.xs=_4ba1b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 11/09/23 09:39AM, Hannes Reinecke wrote:
>On 9/11/23 09:09, Nitesh Shetty wrote:
>>On Fri, Sep 08, 2023 at 08:06:38AM +0200, Hannes Reinecke wrote:
>>>On 9/6/23 18:38, Nitesh Shetty wrote:
>>>>For the devices which does not support copy, copy emulation is added.
>>>>It is required for in-kernel users like fabrics, where file descriptor is
>>>>not available and hence they can't use copy_file_range.
>>>>Copy-emulation is implemented by reading from source into memory and
>>>>writing to the corresponding destination.
>>>>Also emulation can be used, if copy offload fails or partially completes.
>>>>At present in kernel user of emulation is NVMe fabrics.
>>>>
>>>Leave out the last sentence; I really would like to see it enabled for SCSI,
>>>too (we do have copy offload commands for SCSI ...).
>>>
>>Sure, will do that
>>
>>>And it raises all the questions which have bogged us down right from the
>>>start: where is the point in calling copy offload if copy offload is not
>>>implemented or slower than copying it by hand?
>>>And how can the caller differentiate whether copy offload bring a benefit to
>>>him?
>>>
>>>IOW: wouldn't it be better to return -EOPNOTSUPP if copy offload is not
>>>available?
>>
>>Present approach treats copy as a background operation and the idea is to
>>maximize the chances of achieving copy by falling back to emulation.
>>Having said that, it should be possible to return -EOPNOTSUPP,
>>in case of offload IO failure or device not supporting offload.
>>We will update this in next version.
>>
>That is also what I meant with my comments to patch 09/12: I don't see 
>it as a benefit to _always_ fall back to a generic copy-offload 
>emulation. After all, that hardly brings any benefit.

Agreed, we will correct this by returning error to user in case copy offload
fails, instead of falling back to block layer emulation.

We do need block layer emulation for fabrics, where we call emulation
if target doesn't support offload. In fabrics scenarios sending
offload command from host and achieve copy using block layer
emulation on target is better than sending read+write from host.

>Where I do see a benefit is to tie in the generic copy-offload 
>_infrastructure_ to existing mechanisms (like dm-kcopyd).
>But if there is no copy-offload infrastructure available then we 
>really should return -EOPNOTSUPP as it really is not supported.
>
Agreed, we will add this in next phase, once present series gets merged.

>In the end, copy offload is not a command which 'always works'.
>It's a command which _might_ deliver benefits (ie better performance) 
>if dedicated implementations are available and certain parameters are 
>met. If not then copy offload is not the best choice, and applications 
>will need to be made aware of that.

Agreed. We will leave the choice to user, to use either block layer offload
or emulation.


Thank you,
Nitesh Shetty

------ooWIhDQPe4iZ41CGDouWrWpJ8fGFR_EcoxWGaJuqOMoSQ.xs=_4ba1b_
Content-Type: text/plain; charset="utf-8"


------ooWIhDQPe4iZ41CGDouWrWpJ8fGFR_EcoxWGaJuqOMoSQ.xs=_4ba1b_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------ooWIhDQPe4iZ41CGDouWrWpJ8fGFR_EcoxWGaJuqOMoSQ.xs=_4ba1b_--


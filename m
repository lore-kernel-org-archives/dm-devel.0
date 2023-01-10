Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87779C46467
	for <dm-devel@archiver.kernel.org>; Tue, 10 Jan 2023 09:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673341674;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p7fIB5smcOjQkAt01hNdEyuFqc0SJODApkVlr8z7cv0=;
	b=QkAuic/q6nT41h77kz/y04CEcaBE2dZrVvRnacaK3N+uVnjVyv14Qpf+dTvdFmvWE3Xlnz
	ozuzsz84ZL9u0Ae18Oqp4qUyaWRvWZg5cOEIhaCwNPmXlst38l5WluMUNSczSttVLL+i/c
	Xz3L4Pb/ykxhLVtXKMXhJ4Zk868+njs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-8TI5jQKEPbeTOh_qjECVew-1; Tue, 10 Jan 2023 04:07:50 -0500
X-MC-Unique: 8TI5jQKEPbeTOh_qjECVew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAFA338123A0;
	Tue, 10 Jan 2023 09:07:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B8C4B422F2;
	Tue, 10 Jan 2023 09:07:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 87473194037C;
	Tue, 10 Jan 2023 09:07:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E35641946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Jan 2023 09:07:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9A551121318; Tue, 10 Jan 2023 09:07:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B09621121314
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 09:07:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91EB7101A521
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 09:07:47 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-OADlKREoMnGt-R3RLHYb8Q-1; Tue, 10 Jan 2023 04:07:43 -0500
X-MC-Unique: OADlKREoMnGt-R3RLHYb8Q-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20230110090742euoutp01395f34af492542e9ffaa107709db80bf~452BK6Up92164421644euoutp013
 for <dm-devel@redhat.com>; Tue, 10 Jan 2023 09:07:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20230110090742euoutp01395f34af492542e9ffaa107709db80bf~452BK6Up92164421644euoutp013
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230110090741eucas1p268f7edd43ca3cc1add67c5d5414783c7~452A21kvo1958119581eucas1p2u;
 Tue, 10 Jan 2023 09:07:41 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 87.2B.56180.DDA2DB36; Tue, 10
 Jan 2023 09:07:41 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230110090741eucas1p1229ff3d8b068f9c57600dd66b17a8fee~452AgWK6E3000830008eucas1p1f;
 Tue, 10 Jan 2023 09:07:41 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230110090741eusmtrp25716c7022b1f247716cfe020d353d9d6~452AfequV0846108461eusmtrp2F;
 Tue, 10 Jan 2023 09:07:41 +0000 (GMT)
X-AuditID: cbfec7f2-ab5ff7000000db74-a3-63bd2adde7cf
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 07.B7.52424.DDA2DB36; Tue, 10
 Jan 2023 09:07:41 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230110090741eusmtip2bd7da5505bd54e69f59038dae194b4f0~452ASt--q1643616436eusmtip2P;
 Tue, 10 Jan 2023 09:07:41 +0000 (GMT)
Received: from [192.168.8.107] (106.210.248.241) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 10 Jan 2023 09:07:40 +0000
Message-ID: <35293c0c-2d72-c4ee-2296-079d56df7d5b@samsung.com>
Date: Tue, 10 Jan 2023 10:07:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To: Christoph Hellwig <hch@lst.de>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20230110065822.GF10289@lst.de>
X-Originating-IP: [106.210.248.241]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7djPc7p3tfYmG3xYbmGx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLPYsmMVmsXH2UyeLMy88sFntvaVtc3jWHzWL+sqfsFiduSTtwe1y+4u1x
 +Wypx6ZVnWwem5fUe+y+2cDmsbP1PqvH2ZWOHu/3XQUKn672+LxJLoArissmJTUnsyy1SN8u
 gStj4ZpbbAWLOCv2N1xia2Dcxt7FyMkhIWAiMXdhO3MXIxeHkMAKRomvHQ1QzhdGiQ+HZjBB
 OJ8ZJXq+/GGFaTn+7jgrRGI5o0TLm242uKpFe9rBBgsJ7GaUOL+0FMTmFbCTuPFxIguIzSKg
 KtGx4zQTRFxQ4uTMJ2BxUYEoiaYLP8FsYYFkiR1XdoPVMAuIS9x6Mh/MFhFQknj66iwjRHwF
 k8T8/bpdjBwcbAJaEo2dYGs5BXQkuk8sZIEo0ZRo3f6bHcKWl9j+dg4zxAPKEosvXGOEsGsl
 1h47ww5yv4TAZk6JE7862CASLhJrDt2FahCWeHV8CzTAZCT+74S4R0KgWuLpjd/MEM0tjBL9
 O9ezgRwkIWAt0XcmB6LGUWL/+RuMEGE+iRtvBSHu4ZOYtG068wRG1VlIITELycezkLwwC8kL
 CxhZVjGKp5YW56anFhvmpZbrFSfmFpfmpesl5+duYgSmtNP/jn/awTj31Ue9Q4xMHIyHGCU4
 mJVEeFdy7kkW4k1JrKxKLcqPLyrNSS0+xCjNwaIkzjtj6/xkIYH0xJLU7NTUgtQimCwTB6dU
 A5PaqoWyPz+ZHr3FZnpZ00bQKvrDpU2/7M4srVYpkfVg8tcKUG3I93+6bN6+rbY3aq/y/Oiq
 L9vReHGm/1K5W+9ZP9p+9El3ZlvywWlh9d/l+6YLqdtmTtBfF3x+mYfqF75Tx0StrKfKNvE9
 cd5dEJeWkOytm+seqXTCe7LsjAZhltIFu1qW9pbvqZ76YNm0m8LXjt7IESpzfF9ifallq7WQ
 iHjY//0rbSMXL5lx+yz/jte2r9JZtdZwqQluOlUS/9Qq3N9w3s1PsgZui4reLc45Xr6vQvhq
 L/PftVXaz2YVz487nn1M6UBhbsR+yd65aamf1N+KGcTL2vUw3PYwiEh6dPZqUsD0rJM8Pa9y
 XZRYijMSDbWYi4oTAcZw7AfYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t/xe7p3tfYmG9y/JGex+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLPYsmMVmsXH2UyeLMy88sFntvaVtc3jWHzWL+sqfsFiduSTtwe1y+4u1x
 +Wypx6ZVnWwem5fUe+y+2cDmsbP1PqvH2ZWOHu/3XQUKn672+LxJLoArSs+mKL+0JFUhI7+4
 xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS9j4ZpbbAWLOCv2N1xia2Dc
 xt7FyMkhIWAicfzdcdYuRi4OIYGljBJ3F81mhUjISHy68hGqSFjiz7UuNoiij4wSG1sbmCGc
 3YwSl67uYgKp4hWwk7jxcSILiM0ioCrRseM0VFxQ4uTMJ2BxUYEoiZvnH4LFhQWSJXZc2Q1m
 MwuIS9x6Mh/MFhFQknj66iwjRHwFk8T8/boQy+4ySnxYvBMowcHBJqAl0dgJdh2ngI5E94mF
 LBD1mhKt23+zQ9jyEtvfzmGG+EBZYvGFa4wQdq3Eq/u7GScwis5Cct4sJGfMQjJqFpJRCxhZ
 VjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgSmgm3Hfm7Zwbjy1Ue9Q4xMHIyHGCU4mJVEeFdy
 7kkW4k1JrKxKLcqPLyrNSS0+xGgKDKOJzFKiyfnAZJRXEm9oZmBqaGJmaWBqaWasJM7rWdCR
 KCSQnliSmp2aWpBaBNPHxMEp1cC0KqGz/pqQHYOEe8ptb8WVn2uOfdn1bUPhVfYXty8duedr
 95Nt51atRwVxC/d8L5UzKXhodCFxzZW39w99TDc3mBOc0XXl9V/92d4q6yQtRE40sk7Y7yfm
 tmDDkXcSu1d6N/I/f7jIXovNT9/yQGNr3Ia3XxoWBDKunRrud+IYh/4Hlnq/8t8yb37wF8oU
 RaiopjC++nLySoPokoc93bOFkqad7eU79GRlXHpDHbPxtcdr97C7HQ25v/l781ZxP7nNis90
 LwusdU11dP/Icknrwu20DQs0HPs6rRY/9/Zb+vOr3rvLX8zCfL1PNz5yfqr1UX0W5781T47/
 XrM+4XOxhOA9/9lvzvQdEtDqTzP9rMRSnJFoqMVcVJwIAHkoaTWOAwAA
X-CMS-MailID: 20230110090741eucas1p1229ff3d8b068f9c57600dd66b17a8fee
X-Msg-Generator: CA
X-RootMTR: 20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083323eucas1p2f0f6d5d5c1c3713be35b841157ae463e@eucas1p2.samsung.com>
 <20230106083317.93938-8-p.raghav@samsung.com>
 <20230110065822.GF10289@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 7/7] dm: call dm_zone_endio after the target
 endio callback for zoned devices
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
Cc: axboe@kernel.dk, bvanassche@acm.org, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2023-01-10 07:58, Christoph Hellwig wrote:
> On Fri, Jan 06, 2023 at 09:33:17AM +0100, Pankaj Raghav wrote:
>> dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
>> uses either native append or append emulation, and it is called before the
>> endio of the target. But target endio can still update the clone bio
>> after dm_zone_endio is called, thereby, the orig bio does not contain
>> the updated information anymore.
>>
>> Currently, this is not a problem as the targets that support zoned devices
>> such as dm-zoned, dm-linear, and dm-crypt do not have an endio function,
>> and even if they do (such as dm-flakey), they don't modify the
>> bio->bi_iter.bi_sector of the cloned bio that is used to update the
>> orig_bio's bi_sector in dm_zone_endio function.
>>
>> Call dm_zone_endio for zoned devices after calling the target's endio
>> function.
> 
> This looks sensible, but I fail to see why we need this or how it fits
> into the earlier block layer part of the series.
>


I just extracted the cleanup from my old series. Do you think it is better
to send it as a separate patch instead of adding it along in this series?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


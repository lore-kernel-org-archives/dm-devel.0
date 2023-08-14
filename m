Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2907DC001B0
	for <dm-devel@archiver.kernel.org>; Mon, 14 Aug 2023 11:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692011108;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=f4uKOTyi10liye7+rZvnvPSeJ/I1quEmoBnOMsCpIlU=;
	b=gMKRuU6/wCp+LOKjmlpVW1sNqkA8pTa3UBzQKMfhQCzcegU+1LJiO11FDhNtL5bQSXmuju
	sd+HT0GGObfuGjYPxdnl5gXIAydtnjCFPLZRnpymYA7Cg60FLe7wA0XOcenUT6SuOx9wEL
	t1KppjAAAHqlAcpr57oU2w1fhQlotPQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-JLFDffr3NqqdCaJovLjS0Q-1; Mon, 14 Aug 2023 07:05:00 -0400
X-MC-Unique: JLFDffr3NqqdCaJovLjS0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18E3538210AD;
	Mon, 14 Aug 2023 11:04:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BF3D2166B25;
	Mon, 14 Aug 2023 11:04:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18F54194658C;
	Mon, 14 Aug 2023 11:04:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5B4871946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Aug 2023 11:04:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E734C15BB8; Mon, 14 Aug 2023 11:04:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35CB3C15BAE
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 11:04:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E349D29AB3F7
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 11:04:52 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-g8a7KonBMEWLRsdoU9vYww-1; Mon, 14 Aug 2023 07:04:50 -0400
X-MC-Unique: g8a7KonBMEWLRsdoU9vYww-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230814110447epoutp02cb43da9247c4d20e32735cca89bae72b~7Ox6phekb3053430534epoutp02T
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 11:04:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230814110447epoutp02cb43da9247c4d20e32735cca89bae72b~7Ox6phekb3053430534epoutp02T
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230814110447epcas5p490379260eb7de32348ca4fc4b8d3cfc2~7Ox6IFwcC2024420244epcas5p4m;
 Mon, 14 Aug 2023 11:04:47 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4RPWkj4Rfpz4x9Pr; Mon, 14 Aug
 2023 11:04:45 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 88.39.44250.D4A0AD46; Mon, 14 Aug 2023 20:04:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230814103824epcas5p2e5155c861ab70bb8cca3e76bdd927a81~7Oa4VdjhG0954109541epcas5p2F;
 Mon, 14 Aug 2023 10:38:24 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230814103824epsmtrp1d65eec6dba8f8ada46fd5bd57ce2d5ee~7Oa4Ub3752451324513epsmtrp12;
 Mon, 14 Aug 2023 10:38:24 +0000 (GMT)
X-AuditID: b6c32a4a-c4fff7000000acda-9a-64da0a4d2535
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 83.B3.64355.0240AD46; Mon, 14 Aug 2023 19:38:24 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230814103821epsmtip27238edf5915e73a70212847347f4b676~7Oa1Opylv1721117211epsmtip2Q;
 Mon, 14 Aug 2023 10:38:21 +0000 (GMT)
Date: Mon, 14 Aug 2023 16:05:05 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20230814103505.rjcv4esakiqpndnl@green245>
MIME-Version: 1.0
In-Reply-To: <170b68ca-b24c-0723-cc54-7fcdc9004bcc@acm.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH9+u9vbTEkrsC+hOQ1RocYAotlnpRq0t8cINbIMFtCZkpld6U
 jtI2fQz1HxkMESIC4xFXGDJEy2MroTinPITgGFLmWFd5deBwFDIHCOI7DlhLgfjf53zP7/s7
 OefkMBD2Ba8AhkKlp7QqqZKLeaM37oSF8z7ydsj4k4vbiCbrLwiRVbSEEI3jhRgxc2cREOUL
 rxHC2ZULiInOg0TH4wo6Mdp1i0bUN/bQiJ6VOYz4unsIEFODRhrR4dhFfHeuFiXaO/pQwt5a
 iRGXr015EabeZRoxUjQFCPPMPErcdQQSA0u99A+2kPb7x8iBB80oab9nIC0NeRjZUnuWbBvN
 xMgrF0voZEH2Y4x8MuVAyfnbgxh58XoDIJ9agkmLc46WwEpK259KSWWUlkOpUtQyhUou5h5L
 lBySRIv4Ap4ghtjD5aik6ZSYe/jDBN5RhdLVOJfzhVRpcEkJUp2OG3lgv1Zt0FOcVLVOL+ZS
 GplSI9RE6KTpOoNKHqGi9HsFfH5UtOthclpq12Qf0IxipzprHF6ZYJSeDxgMiAvhq9ygfODN
 YONtAPbN9tA9wSKAL7NzwEZQPNiy4egeXtNvATj2vBh162x8GsDy2HzAZKB4CGyZKfdyyxi+
 C/avMNyyHx4KX0yYULcVwW/TYaF5CXEnfHElrCttx9zMwkXQbi5BPPwu7PvGibqZie+DZaOL
 q+yPB8FLV58j7o8gfoUJLQ4nzZ2A+GE41Jbr5WFf+G/v9TUOgI8Kz61xBqwvrcM85q8ANA4b
 gSdxEOZYC1crI3gqzJpeWdO3wTKrmebRfWDBm/ViLHizap13wO+bqjEPb4VDL79cYxKWnX+C
 eaa1AGBV0RxaBN4zvtWd8a16Ht4L8xay6EbX9BA8EJqWGR4Mg02tkdWA3gC2UhpdupzSRWui
 VFTGxr5T1OkWsHoW4XE3wcOJhYhuQGOAbgAZCNeP5YgdkrFZMunpM5RWLdEalJSuG0S7tlWM
 BPinqF13pdJLBMIYvlAkEgljdosE3C2smZxvZWxcLtVTaRSlobTrPhqDGZBJkwtP88HAm+XL
 xY2tIX0/ODifcEvif7SfjVu6MR1aNfH6xMIf88HRf+/cd21ZFW6zXcpoaXpHHDcb72Tjr1oU
 /Sa/IluFYNJin5IcKTA9MolrZvPCP8upffEgXmKLLL9ad//TKF6BbCT2zKGInyL+rBn7a+Q/
 6dHPmZVlysphOfP3Z9VFm6wlY4GHksYvhHTsEIdod2tO9rd1Jq9YBZyk5YJ/alOCHyZXBBXc
 zQ31PcLTGk4ossz+85tL32+qrB8wa+lZonwLes+htbN/c9jabYUjrRW/2jGrT+KpZ+cDTvIU
 2WHHnbWyxP6cPdvDjm/Cu4xjPk97D4wHNTfDnR//vHmSi+pSpYJwRKuT/g9IngSjnwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWy7bCSvK4Cy60Ug8MndSzWnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WTA+2MFg/221vsfTeb1eLmgZ1MFitXH2WyOPr/LZvFpEPXGC2e
 Xp3FZLH3lrbFwrYlLBZ79p5ksbi8aw6bxfxlT9ktlh//x2RxY8JTRot1r9+zWJy4JW1x/u9x
 Vgdxj8tXvD3O39vI4nH5bKnHplWdbB6bl9R77L7ZwOaxuG8yq0dv8zs2j49Pb7F4vN93lc2j
 b8sqRo/Pm+Q8Nj15yxTAG8Vlk5Kak1mWWqRvl8CV8eHDWuaCbpaKb9OWMDcwLmXuYuTgkBAw
 kTh0nbGLkYtDSGA7o8SKzoesXYycQHFJiWV/jzBD2MISK/89Z4coesIoceToDSaQBIuAqsTm
 19PYQQaxCWhLnP7PARIWEdCQ+PZgOQtIPbPAEVaJKY1PWEASwgI5Eium7GEDsXkFzCQur5vM
 DDH0A6PEwckr2CESghInZ0I0MAMVzdv8EOxSZgFpieX/wBZwClhLTL35CaxEVEBGYsbSr8wT
 GAVnIemehaR7FkL3AkbmVYyiqQXFuem5yQWGesWJucWleel6yfm5mxjB8a0VtINx2fq/eocY
 mTgYDzFKcDArifDecr+WIsSbklhZlVqUH19UmpNafIhRmoNFSZxXOaczRUggPbEkNTs1tSC1
 CCbLxMEp1cDE55XF06k678cOKYMt5Wt8I3o7Zx7jDNiosGSR4Syb3s8rs/un7vr702Jl2of+
 3ooWlqVX/iitPelgtffR5/12i6XemiV+O2mt2XMwQnZ3YdlHwwS17L7zNW8SjPtkmnaeevuM
 uzSj8VL1+4cqIqeTxRYtL/ppKXrqbvLNI8b3927Mc1Hnc+4Ml2NOn8l0sXDHpfy2tynffDk7
 bIXF9J9O3GVjl3NBPHCCRpay6ESLIhuFi0xxmSfiDZ/vzRb6VpP17q1YqO0Ch1PWN/7y6R7Z
 uUVQyD7w4TlXP9vDG97G1YRlpyR/yEg6yjqtsGBuE8dGa76jj/a8PCF2tVlxsqH2zkLZ2LMJ
 R3c07Qm/6K7EUpyRaKjFXFScCABloun2XgMAAA==
X-CMS-MailID: 20230814103824epcas5p2e5155c861ab70bb8cca3e76bdd927a81
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811105638epcas5p4db95584b6a432ea4b8b93e060a95e5f1
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105638epcas5p4db95584b6a432ea4b8b93e060a95e5f1@epcas5p4.samsung.com>
 <20230811105300.15889-2-nj.shetty@samsung.com>
 <170b68ca-b24c-0723-cc54-7fcdc9004bcc@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v14 01/11] block: Introduce queue limits and
 sysfs for copy-offload support
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
Cc: linux-doc@vger.kernel.org, linux-nvme@lists.infradead.org,
 dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dlemoal@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, martin.petersen@oracle.com,
 Kanchan Joshi <joshi.k@samsung.com>, linux-kernel@vger.kernel.org,
 mcgrof@kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----Ax27aEWlRRTyCTKvLJGz44CsYuK4yEI58Kfkn8Ic_yMAot59=_545b7_"

------Ax27aEWlRRTyCTKvLJGz44CsYuK4yEI58Kfkn8Ic_yMAot59=_545b7_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/08/11 02:56PM, Bart Van Assche wrote:
>On 8/11/23 03:52, Nitesh Shetty wrote:
>>+/* maximum copy offload length, this is set to 128MB based on current testing */
>>+#define COPY_MAX_BYTES		(1 << 27)
>
>Since the COPY_MAX_BYTES constant is only used in source file
>block/blk-settings.c it should be moved into that file. If you really
>want to keep it in include/linux/blkdev.h, a BLK_ prefix should
>be added.
>
We are using this in other files. So we will add a prefix BLK_.

Thank you,
Nitesh Shetty

------Ax27aEWlRRTyCTKvLJGz44CsYuK4yEI58Kfkn8Ic_yMAot59=_545b7_
Content-Type: text/plain; charset="utf-8"


------Ax27aEWlRRTyCTKvLJGz44CsYuK4yEI58Kfkn8Ic_yMAot59=_545b7_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------Ax27aEWlRRTyCTKvLJGz44CsYuK4yEI58Kfkn8Ic_yMAot59=_545b7_--


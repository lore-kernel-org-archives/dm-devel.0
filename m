Return-Path: <SRS0=l1SC=M5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90C5C4338F
	for <dm-devel@archiver.kernel.org>; Fri,  6 Aug 2021 03:54:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2FEAB611BF
	for <dm-devel@archiver.kernel.org>; Fri,  6 Aug 2021 03:54:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2FEAB611BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-WxRn5aM7O8yFX2ttOfGJ3w-1; Thu, 05 Aug 2021 23:54:24 -0400
X-MC-Unique: WxRn5aM7O8yFX2ttOfGJ3w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23E90107ACF5;
	Fri,  6 Aug 2021 03:54:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 571846A056;
	Fri,  6 Aug 2021 03:54:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E760181A2A6;
	Fri,  6 Aug 2021 03:54:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1763p1QL003255 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 23:51:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E1B55119D328; Fri,  6 Aug 2021 03:51:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC417119D327
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 03:50:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70BCA89C886
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 03:50:58 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-495-ZGcafyLxM2i81ohA9pCywg-1; Thu, 05 Aug 2021 23:50:54 -0400
X-MC-Unique: ZGcafyLxM2i81ohA9pCywg-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1762b2S2019102; Fri, 6 Aug 2021 02:38:58 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqubt0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 02:38:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1762Zfto163611; Fri, 6 Aug 2021 02:38:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
	by userp3030.oracle.com with ESMTP id 3a4un4x46x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 02:38:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB5547.namprd10.prod.outlook.com (2603:10b6:510:da::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16;
	Fri, 6 Aug 2021 02:38:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::153e:22d1:d177:d4f1]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026;
	Fri, 6 Aug 2021 02:38:55 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8abguw3.fsf@ca-mkp.ca.oracle.com>
References: <20210804095634.460779-1-hch@lst.de>
	<20210804095634.460779-3-hch@lst.de>
Date: Thu, 05 Aug 2021 22:38:52 -0400
In-Reply-To: <20210804095634.460779-3-hch@lst.de> (Christoph Hellwig's message
	of "Wed, 4 Aug 2021 11:56:21 +0200")
X-ClientProxiedBy: BYAPR07CA0056.namprd07.prod.outlook.com
	(2603:10b6:a03:60::33) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by
	BYAPR07CA0056.namprd07.prod.outlook.com (2603:10b6:a03:60::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16
	via Frontend Transport; Fri, 6 Aug 2021 02:38:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80656e9e-bb66-4ddb-a736-08d95883559c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5547:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5547B17EED92CA8790B9DD698EF39@PH0PR10MB5547.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: mHB7bGAu3dr15epxsRd41stobM9+hqxzpWqYRpa7sS2buDJSiIwPFqJ+rmInH8fAtgR3GCzwlanaol8G+VL1dw5VJwfkNyG2NLtwuUUVjYPyCk5SBgqLqzBbW33WfSDPEmgemB8HawITd44W3tybDc/BkYYfkXuPI0D6LXLGiQxkxxOdF8ZpjOI27YUNGVeFEbYrAWHQOtcm+uWcFg8S7a9VlHIiEHA6dIwNCxPwvmaATA5VUeP/nJPLMp8TRchc1g8MGE84JC7Zj4POaRgZvf+7e+kswB+o2OXDVGml+YCOzmd81QGl0zQsPek7/0YgNZtgAuIz3jN/G5pEWTnk7OjLn0TFvOkpKFnNrVwcnZ4z9ZB4koPcZ1WGSkrh6CmnxreI8hGR2DKzPaTnO2Pjn/VLDZc37UBif+EaGEAAkT4OJHT6WV9J9AK7z4+6mpFC4VJhCh0dZIEUTEguqNfrXTpF+FkiwLIuTwNz7cczkoj60BEScnEeoTw+mpWAaKK1xmNuFB8jE+FfJ6IVhgx57jdt5NfdT+l2n9UeTn80qL8jRWABlsYkMXldOisnAvMsRutMOKxbi6osnAenq/+uVJ9UHKN6cvqNsOFR66BU9HIu+cx/kzACHrmbtFQM9GT/3ih3UjsuulGUlKTMebZaK4Y8Yz31d5haz4VLQDOSRoAgR/WNY24v9s31VNLliCWD42Prrkd+Vh09jrOrpPCzOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(186003)(55016002)(8936002)(2906002)(8676002)(7696005)(52116002)(36916002)(38350700002)(38100700002)(6916009)(478600001)(956004)(54906003)(66946007)(66556008)(5660300002)(558084003)(316002)(26005)(7416002)(4326008)(66476007)(86362001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4nPm/WhIumX4gu8cibF/bATl3bGoQkWwNgSRqJlX1YKLZxxFs6e0jA9AU3TK?=
	=?us-ascii?Q?pihw9E8/jdO7lqg0ga4vjp7zOBQFe38Xv48G+BA0hLfZDa9Q9ygIdgrcqkXI?=
	=?us-ascii?Q?X2mYM3eG8U+rOTnaQMNh8JEjhVZrCACGzJHid/8UVwskKKb87PIwxdoEm4Yp?=
	=?us-ascii?Q?vONM2vq5+QAJILo3O1595HJm1VQkFU8JJ29MaWSq0jFohuzwg3YXstGANBcQ?=
	=?us-ascii?Q?TpztbGN577v7KiU/Pd8Ev07ihbckIbMCLik56uXFOXl/L1xbBuV1622JGf2T?=
	=?us-ascii?Q?3J4jYDr5pl54rck0qWMAfu+JUssOkruqTen2HipObtlKO12O/4SkcJAXJWph?=
	=?us-ascii?Q?ffJCXOW+huZNbBGUENbEkJLnurQPZm8in9wndf+iKfx63sR20JLsMWOBhn+5?=
	=?us-ascii?Q?ZVRrvMaWuPEIrtFpDGLy353wFP1Am6n9RG2GjfN4+8WSyBiBv+o2hsPg70/8?=
	=?us-ascii?Q?/cHk/68gmoJpw1c2RbULbg2ogOOhhLRVxtnALk169HD7ogv/hIShfgsLB5wf?=
	=?us-ascii?Q?Wn9f3nK9IIsg9mSc6hwVJr+7T3ein1s/WSI17ISzWvFStWy74joy/gQCf9w0?=
	=?us-ascii?Q?rSYEvCAeIfYhJp0u/Gsjz+ZlHkRX32l6TBFB0WHVWYFDtAqgf5auDGxuuopV?=
	=?us-ascii?Q?gwIbdj+5Csbx/g5dBCFqGlNgCW5x6RVh77qftxmDvpeQ99HzLHdOdhyx8Hnw?=
	=?us-ascii?Q?yQRELIFNBxE5ZjaeUamlL1Xx9O37924ue05FFPcUBs4vqD/R/SbTVQZSSgXs?=
	=?us-ascii?Q?yhpe8Fri54nq7loB6V02+rQmPYj+P5wHqLPfnLO/z6SivjMt7mNVQylv0AdT?=
	=?us-ascii?Q?nNPDksdBrreq1Y57a2nNs84zprKdtN2qmJyyA730JBJCS9Q2IVM9I1+YEBjt?=
	=?us-ascii?Q?qzk9+Xg7ovyYw/rUTQB9DQr13sy+tdHDiGe7y0FlMFJnyzqaaA5z9TBSg1nn?=
	=?us-ascii?Q?S5jICH2QtI9Xm4qHGAZpHu3Dcgjrr5gHQAbBis3MphlDUMcDI3rD+KfZ9uVQ?=
	=?us-ascii?Q?gQpKJunnSeDzzuxoElmS4eGWCkMz6MGiyr/4k06oVYx2zcGyOwA3CW7d2yVe?=
	=?us-ascii?Q?MESQL8SyeKQpSOROiYQzOOqKq5mmXzSOmEm4LQAP1x3c9jveIPz3scZxsrTR?=
	=?us-ascii?Q?D533r3OjBHP8d+3jU+2TsUwdLlzpKy30VL6Y6x5bBU44z2GbeeDgQlrppf4S?=
	=?us-ascii?Q?uwPJ9//ij0IqmdhipBPK3TufGN8+NHmJ3oWfMdBC2ooHAOvcO1TTO5nBFWyf?=
	=?us-ascii?Q?CybHaMUUcHr/Fqsv5B4Vknq/4q83R9uYjx3d+NoVlf7DRXw3nxYclFNBRysS?=
	=?us-ascii?Q?+hNeD7heBnOnEXJRdra9R8o8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80656e9e-bb66-4ddb-a736-08d95883559c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 02:38:55.0901 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKZRK5ac1beLv9++eYdbfswpaE30jL+ccAoKyUjJJwTQfbB25sNrgh6s22LdmVQ1zvhYMLG2BNUjvLvOD+C5iCCmpkkTlnDy4+y40ACTIaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5547
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 malwarescore=0
	suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060013
X-Proofpoint-GUID: I9rYJCVIPTniJ20GV4L9xRYzEmBj29-q
X-Proofpoint-ORIG-GUID: I9rYJCVIPTniJ20GV4L9xRYzEmBj29-q
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Ilya Dryomov <idryomov@gmail.com>, linux-um@lists.infradead.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, ceph-devel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Geoff Levand <geoff@infradead.org>,
	Phillip Lougher <phillip@squashfs.org.uk>
Subject: Re: [dm-devel] [PATCH 02/15] block: use bvec_virt in
	bio_integrity_{process, free}
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Use the bvec_virt helper to clean up the bio integrity processing a
> little bit.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


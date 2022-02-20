Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0F8C433EF
	for <dm-devel@archiver.kernel.org>; Sun, 20 Feb 2022 01:45:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-VcxyZU0HOMWuT4Urpz0CMQ-1; Sat, 19 Feb 2022 20:45:52 -0500
X-MC-Unique: VcxyZU0HOMWuT4Urpz0CMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D58502F45;
	Sun, 20 Feb 2022 01:45:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDB5F12E23;
	Sun, 20 Feb 2022 01:45:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 75A5F4BB7C;
	Sun, 20 Feb 2022 01:45:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21K1jddd026605 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 19 Feb 2022 20:45:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8D74140E7F13; Sun, 20 Feb 2022 01:45:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 886DF40E7F03
	for <dm-devel@redhat.com>; Sun, 20 Feb 2022 01:45:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A1323800503
	for <dm-devel@redhat.com>; Sun, 20 Feb 2022 01:45:39 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-150-qbB1o5QTOj6jVm_ee5GSzg-1; Sat, 19 Feb 2022 20:45:37 -0500
X-MC-Unique: qbB1o5QTOj6jVm_ee5GSzg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21JKRM9x006833; Sun, 20 Feb 2022 01:44:23 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3eaq5298fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Feb 2022 01:44:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21K1aKns051888;
	Sun, 20 Feb 2022 01:44:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by aserp3020.oracle.com with ESMTP id 3eb47x7p1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Feb 2022 01:44:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16;
	Sun, 20 Feb 2022 01:44:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c9f0:b3fb:25a6:3593]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.026;
	Sun, 20 Feb 2022 01:44:20 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135kefh5j.fsf@ca-mkp.ca.oracle.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-8-hch@lst.de>
Date: Sat, 19 Feb 2022 20:44:18 -0500
In-Reply-To: <20220209082828.2629273-8-hch@lst.de> (Christoph Hellwig's
	message of "Wed, 9 Feb 2022 09:28:28 +0100")
X-ClientProxiedBy: SN4PR0401CA0045.namprd04.prod.outlook.com
	(2603:10b6:803:2a::31) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15466686-29c0-4226-266b-08d9f41283aa
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502035F8FD4645B784D14668E399@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: mk5XE/LMrtHaWtjoDaBNV4Nt7vGJ1n7DC9JlupV4etyWVgNTem6/2pKEovthq7n99hWzQilIBohMw9qyFdp+txwemFUvJHWYpS1lOEi8+J7LkHLq9AkOXE3zlREzLWZanq5Fqwi5XFDQxB8MIdVUS26UFxYLMc7+pVoBTH7jB5Tgtd84f6hsdwsvamFNhQvsXUsn417g86jdVWrwseW90lV7ZVEZ9baXaxtx68n7s83M+rrO7SuLjh+SL6wVrr5ZeWQEOpSx5YGvXzvZvQ1BT/Ed0KsFeh8cxWUQwztXnC44ScHnXRTIZzA42X70+jWpipjygmPitlJI+gUztRzess1CTY1yohRNSTUwB2Y9nK2r8DT2kuFGoh5mgdqrpdGGywKpBtaM+X59LQXlrrepG240bi6rtDV77dUAyHVCosG9b33eoPP4SoRQqUw2bhT0WebXkf5XPQW+TqcC0RDLj6/hs/225e2FCDenYo8/qANz/d34zRpZuj7v3n47GD9QNApBMVw4F5Y8QiwA2sYxLO46jeuEqlhcvWgiCNZVOM/9kqL0EbErElsp2yGqRa6KreagHQGFcptRnbNKydqo1Uzv3khpE5JOzGrcdnEHksnKmfjzNn+P+4+AHJoeDNJdUJ9jwzJb3whasH2lBO99sdinUw78L5AePGST7N5kFd4ZU8X30NXyrqhOozHAEADASjW+exoiCXOB3TO+qHno3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(83380400001)(186003)(26005)(38100700002)(38350700002)(6486002)(2906002)(6512007)(86362001)(316002)(8936002)(6916009)(5660300002)(7416002)(4744005)(52116002)(66946007)(508600001)(8676002)(4326008)(66556008)(66476007)(6506007)(36916002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jU95vCxaEzihp6lWK+gLhHqnyYKuhJY6+WHIe0kVGDMPMixeT0gS+KqxSKEw?=
	=?us-ascii?Q?7KVVaRWs7GNbzLoX+lBf82ak2dlLy0Nl49icIsbzTGc5ypgOAM1FW63q265g?=
	=?us-ascii?Q?/hdhavE8+yox9bGLDSuQzHhWecr8C5adzWl7Ml8EKbDAPkE3ND2I57vglI6+?=
	=?us-ascii?Q?259A1rZOqT5DcENeZlovB79Q1srQO8ZDuRN0X0gQWwZLsbL240s56MkOV67Q?=
	=?us-ascii?Q?orYzTr/Xs7h4kuj9BzRFw3Ph93N+yLsEsHS4GWKeqE3nkmurhE74XxG0AUSc?=
	=?us-ascii?Q?Yz3AUiJ7M3UncviOxLaxcVG3kKFi3I/FIYEoiQBxbpNzH6yUKHvXQDU5Q9sb?=
	=?us-ascii?Q?3MzXdpttEbnWYnSHTdfqJ6eJx68A5j0nOqqQ2I0qIaTTzsAxlN2lOepSPCxY?=
	=?us-ascii?Q?2MTlj2m7zpdvYhUlgAS4DUnThibsOl38Z3M/jKGeuj/R9QMWF8oP9HxNwJT7?=
	=?us-ascii?Q?siDqSR+iukXbThuQiU1dRhmsSNRzibniug4LjhDbKMuliSL80+jXkfXECKUL?=
	=?us-ascii?Q?9HmAhYYyaGQwAYvt4yEnV4EHDCbDihDqi6Jq6zjrEDbGyVZoTebV3VQaHbmd?=
	=?us-ascii?Q?fhX3uIKTzL+nXIdVIOCVSN2RP/jT4zctKZvNls4hoSxj11AprUv6SvlxKCzC?=
	=?us-ascii?Q?wrDz9VsWdmx/UbyfUH0tq8lBR5HhWve8SNI0VKk2GgVYbV7674ZTlSoexhgU?=
	=?us-ascii?Q?+V+qO4KHzzViq4XpeGcFjwvPuWgx1GrHKddhCkV4JIV21jDp4TPQ2d+ExPJH?=
	=?us-ascii?Q?C6txB2gwMGvdohkPkXBqI1JdFE1jT/6a1J2DhT814FcaVundZ1eLlLcJrmqq?=
	=?us-ascii?Q?e1qb0637k2ziu5MtNW1Qp+AsWaBI4IMuEUyt+e035gPcrXmcEbPzVx+urA7Q?=
	=?us-ascii?Q?bxSevyGbj21P7ERlrifvD3qdgDIRvmGifMeKnfa+e2jEJMisF8cOsWYMT9Vq?=
	=?us-ascii?Q?+OBFyvj6jqGrw3Dpp6He5dKVEf/WS3HYzjC3Wp33H0Yqsua7dfMWw9AUniea?=
	=?us-ascii?Q?DsljVDD9CmE8IxQBCg+fvCmvz/XDUrh9c3MxofeaYDMQXxImASHdC36z9m18?=
	=?us-ascii?Q?nImkMo2s0tFEvJ7gNttNqqn3DfXvWhDMP3R+xE4y9F0Rc9QdeseKPwATwk3b?=
	=?us-ascii?Q?Cou3tNT7Mr+V+rH5x14M1P0mx+9oAL3cgO5NRqBzdY6dKgNM9c3YWYHswuaU?=
	=?us-ascii?Q?N94riCZVEAwGOTR6r0Jvk49C+zBMM8DKR2gTuVydPbM1w78sRhiQyKmp6fKh?=
	=?us-ascii?Q?iqHepXVKXNRNsJ3D4si4A1EBC42uew/askCfwp/03TpRhnBf8+WNSolPDgX9?=
	=?us-ascii?Q?t6uWGxPLyKDgiUX2CXxsvvRbkoo7qIFFH6EoZXKga7XUqh3C93yyMGl42DSL?=
	=?us-ascii?Q?0rKilsShMhRdzbM504yB3QO1u8+PHWN1R25RLlbAk924mLknGfVeh/DWM7kv?=
	=?us-ascii?Q?kdWnEpBbop8AG6HbFCd6wCXIXiDBrpUPz/V/pH/Y90iGu9Q44m39IJh2KcnC?=
	=?us-ascii?Q?lkqUs7nKIwEcA8Ts7aloBiYmUiUecsUn/57YFZOam+c4Wf9BtyOxerV9fTQP?=
	=?us-ascii?Q?29IwUImEPGMjKmR5BSCGGTAZZ+47ARUy7PSsjAYpf3wVf+sabkMlz6ki8W2u?=
	=?us-ascii?Q?xm1/ne0zqOpJhUj59RsfaXoghTfn9qdfeGMvme/haf1VOlrWrCBqO6cN2yOU?=
	=?us-ascii?Q?0BHDB0b9BV7KIWe5Y0i2rXWzx84=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15466686-29c0-4226-266b-08d9f41283aa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 01:44:20.6284 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fdtYXDcqyrai1DnVnMYuPhSZ4DJqXbLSwoaadvHowRDZNGjcZUCHLtnYb9mHdYyW2OAm/QmHcbrQ/UVSHcqR2q9t6ZZOJG+/PlsWEgp1G98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263
	signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	malwarescore=0
	mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202200008
X-Proofpoint-GUID: qu4w8eJL-GPCQf5irrJgsFF5PHCiJ2j1
X-Proofpoint-ORIG-GUID: qu4w8eJL-GPCQf5irrJgsFF5PHCiJ2j1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, philipp.reisner@linbit.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, haris.iqbal@ionos.com,
	ukrishn@linux.ibm.com, lars.ellenberg@linbit.com,
	drbd-dev@lists.linbit.com, jinpu.wang@ionos.com, mrochs@linux.ibm.com
Subject: Re: [dm-devel] [PATCH 7/7] block: remove REQ_OP_WRITE_SAME support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 9f32882ceb2f6..4a5bb47bee3ce 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -212,12 +212,6 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
>  	return queue_var_show(0, page);
>  }
>  
> -static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
> -{
> -	return sprintf(page, "%llu\n",
> -		(unsigned long long)q->limits.max_write_same_sectors << 9);
> -}
> -

This tripped one of my test scripts. We should probably return 0 here
like we did for discard_zeroes_data and leave the sysfs entry in place.

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


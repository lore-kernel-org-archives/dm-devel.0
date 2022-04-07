Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFA2C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:33:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-N9vrg_9lO1mWBf97humGfw-1; Wed, 06 Apr 2022 23:33:10 -0400
X-MC-Unique: N9vrg_9lO1mWBf97humGfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31DA5185A7B2;
	Thu,  7 Apr 2022 03:33:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D590B2166B4F;
	Thu,  7 Apr 2022 03:33:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53E84194034E;
	Thu,  7 Apr 2022 03:33:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 846881949763
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:33:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 69160C27E9A; Thu,  7 Apr 2022 03:33:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64391C1D38B
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:33:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 471C080418D
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:33:06 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-uy-ixM65O8iWkQK0vfXtPw-1; Wed, 06 Apr 2022 23:32:57 -0400
X-MC-Unique: uy-ixM65O8iWkQK0vfXtPw-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236LpIIu004895; 
 Thu, 7 Apr 2022 03:32:34 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6d932n34-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:32:34 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2373GgZ3035307; Thu, 7 Apr 2022 03:32:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f97y72sg5-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:32:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR10MB1618.namprd10.prod.outlook.com (2603:10b6:405:3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 03:32:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:32:30 +0000
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135iph8lc.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-25-hch@lst.de>
Date: Wed, 06 Apr 2022 23:32:28 -0400
In-Reply-To: <20220406060516.409838-25-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:13 +0200")
X-ClientProxiedBy: DS7PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 073c7bad-f00d-4d5b-ec41-08da18473efc
X-MS-TrafficTypeDiagnostic: BN6PR10MB1618:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1618B131F14E3475ECEF0ECF8EE69@BN6PR10MB1618.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: gIfFN6ZUD2su2U1lfuo26oFy3DXVBykbx0dwaYEGzK7BsICvXIUb2YHrfD6R1SpHzZLdoy60EygwHWUppYBHwYNhRvVGdJY9eV9cs6HWqGwjPhgeaWa49V5vtBExI24PdhtYTHWQo/9nx4xmpOvQRF9m9IqidD5y7tPVV2S2IREDO6vdIxew3Kx7h2FzpTGbrM9j8xlfVqXTHLEmAO9/4oVXKOI01Ju73rheURL2cy4KRtPHROSrpT1umFK+wQdh7o38LblS10zVIfr0/UEX2GMXj7nO43B8KT4l7PNLgheG5vOb0afIiE/1+RpMQjOrr4K60SxozwkiPwoNgdurI4VV6sQ6oWdeHPetek4WARqYGGSsbIQPPULIlwvZgKjwzNUsg8MCHx2c4CvhpY3hOPZeiXEIW9lr6jj95b1A3U+w87ea3wWRBoXccuO6jjFgNXemwnaUCXbOTiyFDPtBjZjCy89Pf5IPzDLxGNQDDq6wCqfZ/2oiA4Ktw3NEwfZmOPd7mhKXul+uW+iV2L3/bXZIWmec/8Z4QjsaFFd9Fpz9JMRisb6rpNPWwFTZfeFdHBAjYJ1Cmc2E3rmVTanNSxZ/M3rct21P5mE5Fx5XgAUbW1ut9l5Z2/W3KreCvEKSOcDy0oWWrzK98HizxC7ceQREIX+GfP2CgCmzP8PUmgry4YLwuBuD1OGqLemfGT8zTdq/KgGP98cRO/ylDdg3Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(7416002)(38350700002)(38100700002)(2906002)(6862004)(4326008)(8936002)(66946007)(66476007)(66556008)(52116002)(36916002)(5660300002)(54906003)(86362001)(6486002)(83380400001)(316002)(8676002)(26005)(186003)(508600001)(558084003)(6506007)(6512007);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8swuNszgtWladoaG2ebwZi/0ZzH6DeyV/bthpZusiDJQYxylmSbA5PRO7qqk?=
 =?us-ascii?Q?7VvYQHpjnVKcs4+A7satuAEMQnvnsFDCBEj3b9Xpgns3QrbvSvSb9sZ5U3NH?=
 =?us-ascii?Q?rLKuDQ+Zh4E1yctPsyKoTxG7Z8Wfd9A+O9dhc1Sf8LZJFWwB4wj1WwlJGVxD?=
 =?us-ascii?Q?lbSr6mSEEfD61JouYuRW6FIuYm5K2H5lync3tmP3xLxXx87mKS0HDKaDyBjo?=
 =?us-ascii?Q?wcuybuiUGt9Wx8qT26WAgBMFrqTcJdsc8PgWhdIu4Oe9xLgHg668qkHKTTRb?=
 =?us-ascii?Q?OcNN7Vp1iDl9y53W22ZMw1YmvjLlSda+Xi5WoupaTqeePxD4kJL8W8YrS9k1?=
 =?us-ascii?Q?5MXqgaFpz+k8zQdJ4k0XmIsJ2XFj9BEEY/W+f/w/QBJnlR+pQFhNsRZBV0gM?=
 =?us-ascii?Q?ArxFxFRQxVkbGi0aIEECqn+FcrzSuvkrDKu+uucg+uO96Z6zf4JOHeksq/98?=
 =?us-ascii?Q?nQl5ZPXqpG5hQlpbHtwNDhxigCd3tIjZkRvQnDxqshd5PwIrLj7xVNuet4mb?=
 =?us-ascii?Q?6pjlKHAOk71nkKVi//P6MvTQ7zIor0zVRqOxe2wIXnvRexAmssGDGM5dMX+U?=
 =?us-ascii?Q?bELptqKzy7PZJiXJ3GopBUHUSPrQnOqMQtiG98a7hxW0pPxHxGqgHf07BxGI?=
 =?us-ascii?Q?nCvZyyu95XACEbquobj7xaTgDa/GCCXswpbQCiN5WY56QrcktkedPaPc0/5p?=
 =?us-ascii?Q?huOfjf6smTgyU5IPoeHOE9zhn6b2jXJJO/CVw3ZrPW6TUWL68mQs+fhmNcUs?=
 =?us-ascii?Q?oPzRBn/D8gFKKFNnuyVbiMkS5FaZat3CKUzVNfWtlc0CzTq7SQbUJAYIKuak?=
 =?us-ascii?Q?Sa2On3EGoEZ/obAmO+/6SceIkNAA3YhQKuC6t/teDMxvwWrZfOEl0qSsnL4W?=
 =?us-ascii?Q?Xo7oA7d8Xx251pvSx4jLRe4uUFpXgpwT8aKmEsPl0YmQ0cXLEreV1OIkB028?=
 =?us-ascii?Q?ug4gAjeAdSw2lQHXB65EXyetLFaentH22o6QXieEgJ+9TtOfxjJsrgRMXT+E?=
 =?us-ascii?Q?0ZwTAuQRbojDATmBh77GnsRIpIbcbl8KL4sav6ScENnXR62MVs1ONADxT7QG?=
 =?us-ascii?Q?Zhtpe8/W5WF+hBlZ0m73lq+nZYQRHCZGi68sdgbC8bKOeY0IK/HQWbnuJRJl?=
 =?us-ascii?Q?JorA06/wHlXj1T/ESfgbaXGaW21mHefygocLmPQ/1tn+DSMiwAvrTjgfD/b5?=
 =?us-ascii?Q?Ttg3SEtVlfHizipMwVmb5G/9GfdS4r0jBJzNj3T6J+6f1KcnTS4lCTvFFXWu?=
 =?us-ascii?Q?Q2NzxQ6ABea2CN0LrYQzB6X1/n1/2195xk/ERh14WJAxy4cG5VeEB/BFLb14?=
 =?us-ascii?Q?V6qTl/T9g4k1KYp81ocVjLwT+kdI1Nkdk8/+DM7FQjXB2ZDnM6UVdWcWycc5?=
 =?us-ascii?Q?4uMburs8Vtf/K0E3huz8tFudnSkyK9MRPYRBLCc+M1a6Jz269Y9bGBdnSMNQ?=
 =?us-ascii?Q?xrDNjO9qEXwo7ptfJJFT/z4roRmVQ1pLKSzST1mqVbwXn0p5EEY+wtU1OgpK?=
 =?us-ascii?Q?FpCVF7PfWCM/JdiFeLIW4nAXOOix/uBy+PLdlzWzffh8XuheQXzJ4v2L6bDt?=
 =?us-ascii?Q?+oJpdFLVj/2VbaiG07pFBN4ZWNdaQV25c1I20QPtfCp1QPQQNvBgr25MqmD7?=
 =?us-ascii?Q?8tDSEMJnEykf7aewPfAJvdpYb1vU5CVTCV6IJGAWQX3Bd+kCvlBuVxZFqwfU?=
 =?us-ascii?Q?gXDlgusFFa6Oj78zk6O3u/uW64TR5IzzEu+lIQMOfrk1BUNGOraCJPRjgsxU?=
 =?us-ascii?Q?755pnrTMt+PRNTb6o2BFHe5QJY6jbZQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073c7bad-f00d-4d5b-ec41-08da18473efc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:32:30.6416 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwGzzH7OhkF8PNNh3yM9ri4dh2R9VUt7jXac7Lm4rAo/rmhpAzJ3fZmkBEtZO72lGTEl96s8zj4YXk68qPq0GSp3vjt9qNgWQQclO0sGZLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1618
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=926 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070017
X-Proofpoint-ORIG-GUID: i5ueGU4Do136tb5GM3VcintEL9nTn7F7
X-Proofpoint-GUID: i5ueGU4Do136tb5GM3VcintEL9nTn7F7
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [Ocfs2-devel] [PATCH 24/27] block: add a
 bdev_discard_granularity helper
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
 drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Abstract away implementation details from file systems by providing a
> block_device based helper to retreive the discard granularity.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


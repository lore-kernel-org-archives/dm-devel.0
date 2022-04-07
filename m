Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90256C4321E
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:25:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-NzaE6Us-PBGC0V7tNPAA1g-1; Wed, 06 Apr 2022 23:25:13 -0400
X-MC-Unique: NzaE6Us-PBGC0V7tNPAA1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AEB585A5BE;
	Thu,  7 Apr 2022 03:25:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F4C8C27E94;
	Thu,  7 Apr 2022 03:25:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0C12194034C;
	Thu,  7 Apr 2022 03:25:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 961931949763
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:25:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86E5641617E; Thu,  7 Apr 2022 03:25:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 825C5416178
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:25:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 652A01C0170E
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:25:09 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-h4WFNtoINvmv_l3QkKlcig-1; Wed, 06 Apr 2022 23:25:07 -0400
X-MC-Unique: h4WFNtoINvmv_l3QkKlcig-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236LT0rb006378; 
 Thu, 7 Apr 2022 03:19:40 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31jpgy-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:19:39 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2373FNjt015384; Thu, 7 Apr 2022 03:19:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f97uwamrp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:19:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 03:19:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:19:37 +0000
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h775ins6.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-16-hch@lst.de>
Date: Wed, 06 Apr 2022 23:19:34 -0400
In-Reply-To: <20220406060516.409838-16-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:04 +0200")
X-ClientProxiedBy: BY5PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bce8477-072f-4601-b4e7-08da184571d9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4408DAE994838FAB82473B3E8EE69@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: rjpbJIEZKnNEYKvuq6mDkATU/XSk8rTGWhmb5BtdQPXIoA12PnI264xUaR/rDlDVV+WBKqN46ZTvSslyjx+vvmVSavnTq+ToxU/lxZ7jwCM0jkRWS6565SYeRh54rE0dFknk774nCe4mFT4kxRJW4rISoJXfX4c8wbJoGp5v0wwqcH4JU7G16moP4wWn9rWOgIRfhBOwB1LuA93pH/xGSMRetF1bgbkziL9/ygQxpSE2uajI6pdYtdcdsWew1l1pv+/fFUO2zbgoicMFfsPWtx0PIki+XILDeVGZPwdSUDq53Fd9tapAqcEp3loBIjdMBb0UfTAhpnocXc+W1qv41QZq7+7KAI3lm7/gSmaSnoe5hbPZ07FRqYyZZ+/LLYsdG07rCd/VneFYYEDDvdulWVadiEsZ1wwRHndYdGyLL9xu6nplKlkJOnf7dL+hxO30blOO8AaZ+lOyBvqvLtDlXoiA/lKECDGrvAMWxiwtERcVPjR8NemBDXP0SX1oEjx5mO6URk+lR/Bmk59yrbCZx6fJAPMgarBNWzL1JYJm5UiWQeTg7a617m/3LT9d7lMH4LIBCNZ5iVN8sAtfq8R98eSBqPm/0FfXVV5CJK+RrC9qgdZshBuqRT9cViOcWQ3xitqcvP5D+i9t849caJMnshXNcwMAJkpJzA/DidseX96z/rOISWGxyab0giL9dGjWo6ZwK9hhF4BQqMVVo/PSYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(508600001)(6512007)(26005)(6666004)(6506007)(36916002)(52116002)(7416002)(186003)(5660300002)(2906002)(8936002)(4744005)(54906003)(316002)(66946007)(38350700002)(38100700002)(6486002)(6862004)(66556008)(4326008)(8676002)(66476007)(86362001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?otwK22u1FQL4H8p4tyeZC62SDKzQ2319TBwKD+0F5UmNPrBHHS4u0L6o2rWr?=
 =?us-ascii?Q?BdCuYhm2AiMo3Guj0AFAfewm0uazSezzFtLBMoDvh37dzt9lc99kNXH42YmG?=
 =?us-ascii?Q?ZSOeXycw6UPgFnYE6VQgzHH7lH3/eOqtm4S+7aSyK46h/AcoCl3LzHDZCjaN?=
 =?us-ascii?Q?FuVSwD8zgeOJ609VQQ62zQTPwh7+dVjDGpRojU38wJ6rZayrpeZaiSFbDq32?=
 =?us-ascii?Q?51kDYCIcVO23CVaL1If2RP3KziQzQJJ7M2bfk+ryCErPwZ6RaRj3wBcsnGVJ?=
 =?us-ascii?Q?yTegiaDAdy7fdvUVede7qNpal791NbXn4OQLOtUlkkft0eaxNhK3ZxmmPFzn?=
 =?us-ascii?Q?JTvm9ej/6pdqBL++5RATxdWTz5Df3z7J36ASOTWjjSkf3BcD6w3q0WS2AdGI?=
 =?us-ascii?Q?Z4AgqeeJTg2vkgjjPirXv7k+OhpowPR1tYlMG8NgliGRt8bC4IZvCwhXV1wW?=
 =?us-ascii?Q?R/LTR3xxNRo4hbqR7vrryQ8SM4Rv1kkBRQT/osU5Ivyw6DvQmYWK4GyvJnJG?=
 =?us-ascii?Q?/lgi6zxtBkpFkT4q1TLIbh7U7rh5KKGhEXtY51yjGeDtUfttvijKRI2xc42j?=
 =?us-ascii?Q?xN8x1B1zwTUTQkjePbxXhue3+JM1JcU+s4/EEOGl97MPxKpTI6PQvDmk8ILT?=
 =?us-ascii?Q?Jwcl2rD1xnpjGH4wXKOYvbvcpEb231x5hMBtbKQY5r/1/o1L6WAgwSSJvTNF?=
 =?us-ascii?Q?lOMnsIAAOBDMhVAqMCI2jOOcHbvxza6bSQ3NGQDXXbap6X9Y28Yyq3x2R+86?=
 =?us-ascii?Q?hovdBD/ZnL7xvGIPx4XwCSjPCcTet5+DxbB2FigmjYmLS4rjelW7V4d92EKP?=
 =?us-ascii?Q?CMW/91NOnWt1WqDG5yIOhQzcPdOws67BeoQM+gzurxCfVJMIY1kEgJfOnNkE?=
 =?us-ascii?Q?iyEPLhPfEzU/4SSEfYuMYD6kXoyqabl6TvbCovxQNHKTsZzZLlAWlF+LQbpZ?=
 =?us-ascii?Q?6v0Jcqj6Vv9D/fA1iZb9gelZYTTPNSLgtTeNXAOqI2UUqxe9RJHe4FF9lMEn?=
 =?us-ascii?Q?f6bZwNxMFFaaWHcc5aIFbm4+/sLXNDHqd+G6w/ywQLHZkJS6/Vu/k9e3xDoT?=
 =?us-ascii?Q?vug5WuyJo1lnQLnmFheQnARNkp4HeYIL1FrknslxhA6LQh/erpD3tNgo7vWg?=
 =?us-ascii?Q?JaiMvKKEhrOD/380Wb5Tf28f4SMOfOxKY9yVA4zLUcSA+rJx8AOk6aJd93Gl?=
 =?us-ascii?Q?DhNlK6OF8RnPjO9kkOo3ZPl3THdemigQ/7LL78QGlJA16s86an2DvDtD6Evv?=
 =?us-ascii?Q?EJAb7zDdA75RTRClkeU26zUQAd5UThlOw9U3jtIQTs/q3glc7vV+yHYn5FPv?=
 =?us-ascii?Q?Bq+sX52pOI1xJe4iWkfI5cUtiVSN76XMUiOrrGM4mNg3vJVwMFVbIzFCuB4Z?=
 =?us-ascii?Q?TXzp12MMNRG3rY7qCXW68s4Y2qtVYMBKFq1n4Wbxgk9HYe7CweRxtwcrl/TG?=
 =?us-ascii?Q?U10IlZXrd8kLdRypfjaEHhWwC/Bd28fJQiwa8rA6H6c05wB9OjRU1zyRJdgi?=
 =?us-ascii?Q?kww9ah519h8AE+kusJ/kIpzmR8+JaGwjhtORJIVIdgg48JPrg30buPZ63isM?=
 =?us-ascii?Q?fan3VsX71nsFWugPDz+MtxzpBMIFUALk+fjCLUzoa4ZQF/zS4h71ssrIQKDY?=
 =?us-ascii?Q?4kKJG+ghbLVRph8/80wYAQ6ZC7zyPOwMMVCmqVHfL/jaWd5oG2QLzk8o0wos?=
 =?us-ascii?Q?KaDNz3TI/FIAjzpDKo4lo8K285eBU+6L4CijIqnP3JAaf1HD32fV94E6u+OA?=
 =?us-ascii?Q?JU1Rv4Xgmgi17AEgwLo6SNA7cxvmtLI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bce8477-072f-4601-b4e7-08da184571d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:19:36.9967 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7z4HIuRW5zOTYnm/hMTpO4vuTWv+jkeYUlfnyT66exez8dXOJ7CIITksd8DVeQqY0+uYHTF7JUR/z8AslARHH0hcSzhm6hezqxwsLgDYqbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070017
X-Proofpoint-GUID: Cnauo41eLSEi8FKkodYmDkATtkwCXzp1
X-Proofpoint-ORIG-GUID: Cnauo41eLSEi8FKkodYmDkATtkwCXzp1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [Ocfs2-devel] [PATCH 15/27] block: use
 bdev_alignment_offset in part_alignment_offset_show
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Replace the open coded offset calculation with the proper helper.
> This is an ABI change in that the -1 for a misaligned partition is
> properly propagated, which can be considered a bug fix and maches what
> is done on the whole device.

Looks good.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


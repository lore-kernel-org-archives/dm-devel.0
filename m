Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6511C43217
	for <dm-devel@archiver.kernel.org>; Tue, 26 Apr 2022 04:17:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-uL1Z2UfgPMCxWugHnpbGAQ-1; Tue, 26 Apr 2022 00:17:20 -0400
X-MC-Unique: uL1Z2UfgPMCxWugHnpbGAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03BB9185A79C;
	Tue, 26 Apr 2022 04:17:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ABEBB400E400;
	Tue, 26 Apr 2022 04:17:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B6881947BBE;
	Tue, 26 Apr 2022 04:17:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9D8119451F2
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 04:17:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C14B447500A; Tue, 26 Apr 2022 04:17:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A49E2463E0E
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 04:17:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8355B3803902
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 04:17:12 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-mebwaxQNNtyrpcCyK-n4xw-1; Tue, 26 Apr 2022 00:17:08 -0400
X-MC-Unique: mebwaxQNNtyrpcCyK-n4xw-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PLV6sI022232;
 Tue, 26 Apr 2022 04:16:28 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4d0w8-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 26 Apr 2022 04:16:28 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23Q4AR5j012450; Tue, 26 Apr 2022 04:16:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3fp5yj4940-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 26 Apr 2022 04:16:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3129.namprd10.prod.outlook.com (2603:10b6:5:1a9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 26 Apr
 2022 04:16:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 04:16:24 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuagv5xw.fsf@ca-mkp.ca.oracle.com>
References: <20220418045314.360785-1-hch@lst.de>
Date: Tue, 26 Apr 2022 00:16:21 -0400
In-Reply-To: <20220418045314.360785-1-hch@lst.de> (Christoph Hellwig's message
 of "Mon, 18 Apr 2022 06:53:03 +0200")
X-ClientProxiedBy: BYAPR07CA0082.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 835a5865-72d0-4ac4-b537-08da273b86d0
X-MS-TrafficTypeDiagnostic: DM6PR10MB3129:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB31292380D74F76EFD145BA388EFB9@DM6PR10MB3129.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: X0D6KBg3dYE7LKh6WthP6tgUSgJnyXvQVuy37VB7bVFWKyTyZpiYPqKVs3Jzizuwg+Sf92KHStLxr+xa3JI22N1hfVbIdR+D/hINi8ev2jXI5RPeztSc9M7Pfv8wN/KlfccpqYFzZlCo5fZC0qJe9mn6+euobijLQ+ae3W1Q4ZSSK+k6g3gj1X9rr3ZFeCf9R4oOxgqjLqE//AGw5JJz14O+wIKv8oOUSl5DbPRYYE5pYch3DXESswFS7q0LgWDkyynxnMeCOwM3I+ZcXRp0HDOOw38bg1/UmGwk7R6kKoQT09BnhshRQptOGkKJbk1TqA3ojIMkvwsO3BvRvme7OKVzKhtfYOrpHTxE1nDe7oUu1zaDggjj9Hx+tUiT2rsXAHF4nqmCzuVh5sZx8O3Fr3KQAaZ0iGVMV17moVVHaqC7x0Ze//UiVG51Ku4RDI3eHLUHWoAnGy3IJzDuYBG/otHNI3ceEV+qLsmjxX8+cDTfHXvH4dK89dvlqS3ADewVSJmXUQBL3kRw79LXhxkRdbBZckOUrZjGYfDlE6UNpH3ka85nzwyCT15D+xxviw7SVLIkB+uYD47wiiadu9xCVEbX7c1Bbglyrs2g+wOET49yX+M04p188Ceo0MX4Z0s/fEANDpsEvkPbetZ+B9iMa8H7On2NO3ifD93u8aM1pkJwPcnEAW2NFb6Go6fxxHT6CptTyDO4NAfDFQ+CIZFuRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(52116002)(8936002)(186003)(4744005)(86362001)(7416002)(508600001)(2906002)(6666004)(6512007)(6506007)(26005)(36916002)(38100700002)(38350700002)(83380400001)(5660300002)(316002)(6916009)(4326008)(8676002)(6486002)(66476007)(66556008)(54906003)(66946007);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TB4tA924ES23Jbjeya1BYJTs1OvtA/zZv6THpxhMU79cce2hBvRPpiS49za3?=
 =?us-ascii?Q?mUONwmtJsiCknSg/EcY91oV51b/6kYP1mGaQV91M1HhGLu1bE/mmUjgXe5BE?=
 =?us-ascii?Q?SqqnyHd99Z6KyY5CLuitjo7OSNvyWpQ3ukZ8SyjQEJIcvnq3Gg3EkU5R+HG3?=
 =?us-ascii?Q?F8fUv9n6HOda4W/bB+HraU/tzreM8+EWPjk2HYGDdAC7U32s3JGn4V6pFdjc?=
 =?us-ascii?Q?EyZC/gXEK2RXovs+rqNtiXAn8Y1xnn5A0A4Nh1NIJFpuaTiTpo2VmTYmol6m?=
 =?us-ascii?Q?0UbCryYNd+ZCvW5dW/X4TU1Qv+oPKgMV9lqUzmk7xOYKt+9B/hPqNDcHBglp?=
 =?us-ascii?Q?XTeDDi8XHXO1D5P3WLajf6NjFpitG4XqaV9vmUxClpxedVXvRbi98PBuLTeF?=
 =?us-ascii?Q?BKRu/8UIxZUe9pthO/CO66KVDUBcGOnzELJEsoRFs08hY/UG2sqncy7tgt0t?=
 =?us-ascii?Q?nvA55r3YQu8SSkHhw50KmjFF706K/czmMyEdVi2HXCzcPiOxOs7KvhJywE1B?=
 =?us-ascii?Q?Eh1gGP/2tgTCaYhCTSs1zZ+ZFeoSw0ocq/HEgpIntTv6HJtpQx6KqSRGOXV7?=
 =?us-ascii?Q?JcDQxbe1XhEdhnAbfzp6vEcG6YCNbs0SIxKP6hS7jAteqV8nRLnAjLRy1Pph?=
 =?us-ascii?Q?H6E+hxLB1CInAKwRT0/+o/fAsfmcGgoDJAnIfVg8BZ67BgRdV2VALulbozvP?=
 =?us-ascii?Q?2wnmKY+uku255u0vK1dEoptoo6YpiOODxrPEKu2rm5dJklw426eL7Pcbf6mB?=
 =?us-ascii?Q?2jo0Q1xNQoM3RmwrrrIufsvxMNGmz1mWqLgExox8rn0CGer6iwJVzl7MHvtx?=
 =?us-ascii?Q?WSisn2XeQ31GZs2Ays3lwTmolcCHLf1sN39+oJQziOJg5iSOUBlrE3qY9ryn?=
 =?us-ascii?Q?Ddy2KZo9oGxfl0CzSidZvVjfHjOQuDCpI794Pucgfowl2w2KruGMXZS3GVgl?=
 =?us-ascii?Q?QB4KWlnDOPGRepoOY18EgaS2wd3XXbdWYFxh7NY0ySmiq96j9DUNERGzOtGP?=
 =?us-ascii?Q?ke8nRsN6Uts+l5dXLI1WLLJtOTOMskxZ5cqzXGXbWfs6cnqNc4N47g+MOOMi?=
 =?us-ascii?Q?khwSby0iMLA5fQsyRHYHr+Yt2+cgpCymS7woTMu5/GYc2Qz71IwKaYYrE0T4?=
 =?us-ascii?Q?yiHlseLzNfilBiXLRkBdCfz1quf0+RtPshsIz4+ucUYTNDgmJi75SEuIBUEP?=
 =?us-ascii?Q?Aqhzuj7AMa3Y9agTnz1W+7vd7+L4aj3Hz1KF6fS2W+PqHp6HVS757X8KtSDp?=
 =?us-ascii?Q?00DgbNPViQTRs9TQ//lU3PUutFq7odj+TM3IxVZlfds0Qyg3pxbOo0g4JNg1?=
 =?us-ascii?Q?sMXx2p6R35Wqw94RidfoO22d7QrxNBSa2tC5TV1fuA5Xo0CrGQkdrvgBTJVO?=
 =?us-ascii?Q?6YNaMJanUjQJVYnjGO6DkWgTuVC/n+nGFzYXeqdMymlT1wFUzJlaASPKrpyF?=
 =?us-ascii?Q?SQJvJ90b4tiE3DW5z5HBnA85+dXINGsNFxdRxipwE6F0s4T4sLeeFObSgiNe?=
 =?us-ascii?Q?0PU//rhhc23Negk43JrkvaDsNkInRzuILS80NmHqquWDI/2TR1/Jwq2acRt+?=
 =?us-ascii?Q?pDpZbxqRYu0dB0FOfOHQwMQMUtJXNwhRUEyyKvKFB1kh9YRCqY7Le4w8GOcL?=
 =?us-ascii?Q?68r28By/gaXsB3HU2N6tNEWEddQVidZzuQSCRzX6xxDgwLEGc1T4y59QDQ3m?=
 =?us-ascii?Q?XW6XaDzoV+2/HLCd7yg08CDJxvE5dwpDDIETeYfsVF8WLkmnrhL6SSnsWcHg?=
 =?us-ascii?Q?//ysxLiDUE8tILEWYPxrVO9Squzf3gk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835a5865-72d0-4ac4-b537-08da273b86d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 04:16:24.7224 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nf2TI3DEgT4qtSJndbWmRFqMGbzkMS2vq7+Y5mOBDAJDRs7oHXuyNKkAk9ybd0dRtdbzLEe54D/bHDq4bXF1AdU2cnvLzYXAEPCE3V3v7Ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3129
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-26_01:2022-04-25,
 2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260025
X-Proofpoint-GUID: 76EsLqdiuyTX3yre8fbQOOLA-RdU5MY-
X-Proofpoint-ORIG-GUID: 76EsLqdiuyTX3yre8fbQOOLA-RdU5MY-
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] fix and cleanup discard_alignment handling
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
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 linux-s390@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 xen-devel@lists.xenproject.org, linux-um@lists.infradead.org,
 Mike Snitzer <snitzer@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 nbd@other.debian.org, linux-block@vger.kernel.org,
 Stefan Haberland <sth@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>,
 linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Roger Pau =?utf-8?Q?Monn=C3=A9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> the somewhat confusing name of the discard_alignment queue limit, that
> really is an offset for the discard granularity mislead a lot of
> driver authors to set it to an incorrect value.  This series tries to
> fix up all these cases.

Not sure how I ended up with "discard_alignment" when I called the
corresponding I/O parameter "alignment_offset".

Anyway. All this looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


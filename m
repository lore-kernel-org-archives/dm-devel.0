Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605ADC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:35:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-YwtQfUZoNe2IF2dQZuTLXQ-1; Wed, 06 Apr 2022 23:35:11 -0400
X-MC-Unique: YwtQfUZoNe2IF2dQZuTLXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D32B185A5A8;
	Thu,  7 Apr 2022 03:35:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF98AC27E9B;
	Thu,  7 Apr 2022 03:35:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9258C194034B;
	Thu,  7 Apr 2022 03:35:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E1F9194034F
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:35:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 19C28145B96E; Thu,  7 Apr 2022 03:35:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 14D43145B96C
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:35:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECE9A101AA4D
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:35:07 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-cnKZeJT3MJqB3O0ET-wJBA-1; Wed, 06 Apr 2022 23:35:04 -0400
X-MC-Unique: cnKZeJT3MJqB3O0ET-wJBA-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2371SjDl024505; 
 Thu, 7 Apr 2022 03:34:34 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tas3d-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:34:34 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2373HEhx034877; Thu, 7 Apr 2022 03:34:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3f974dk6x6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:34:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR1001MB2200.namprd10.prod.outlook.com (2603:10b6:910:3f::28)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 03:34:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:34:30 +0000
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wng1fu00.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-26-hch@lst.de>
Date: Wed, 06 Apr 2022 23:34:27 -0400
In-Reply-To: <20220406060516.409838-26-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:14 +0200")
X-ClientProxiedBy: BYAPR01CA0045.prod.exchangelabs.com (2603:10b6:a03:94::22)
 To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d446413f-1c36-4dd0-b7ca-08da1847869f
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2200:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB220039B1E7C83FCF44C38F6F8EE69@CY4PR1001MB2200.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: kQXOcZRdSEjuaBtDcjetAtqBll8S+8aGRn8Hv9IKXz8u61VNfWBvl/0w2Xu2iHpc8otKBZJiSgSqudn9fjyPJ/XzZ524umM+F4BenIFUJ94hXXK9YNkXOyear3/COPiCq9u95FNMu1OT2/HdvfTXcRMjYpLKpOJa+98C0nFGD0vZlNlkRh6fwOHDhAssU2yu5hw8xvoaei78y9SMcvtsrkcMHHnL0G9Zz2gKNE+UZ2Wt2NI4X47yd7YTuRetVXDlbUNxu9tIGzxJo5E9QwCtt+Nc6Szv4l00dVHUCO+VE7e7fWSbxRcEX8ncD2f7Qvbt6b5Qk48qxl9M7pQmZMtu9QMXHQfty0LRIMbN3ipdrzwYHVTE7Uh6VqXLa01r7NcnPT38ik7iYy6J9jSZEvx3kUNjygySDJknKU/2x6EiOyxLE7d4qiBkDIXdXaHT5Owiy5Zgf21vpFqA0XBSRcNAYf1u5iKZKe1nE0MV1LH4CoTqpDVp/3VItQFuY3gfqX3Jm/aDpd9DAUJqYD7nr6TxlWCsWAwJ1DeV1fNJOMn4puOJ/hfN5mngEwxLLRxOjJW6K3ZoS5J1mjGFczi3V7yDy9Z6DFfoDdNKBXJb9yBLFtAPtNmFotrbcf5w0dX22BposfSbPQdfy73SLwPvoeo+ExRydbheeO6Ng7NJc1xaCCCUgYU5uO+wqLD/Vsqq3jtLsEsHPiZe8YA6DVAo16hkFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(7416002)(26005)(52116002)(186003)(2906002)(8936002)(8676002)(5660300002)(6862004)(4326008)(558084003)(38350700002)(66476007)(6486002)(38100700002)(36916002)(66946007)(66556008)(6512007)(6666004)(508600001)(316002)(54906003)(86362001)(6506007);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OClvsL1mJtH76eGWXfATOm5aZvAfetUXgIZor60KTFybLgfxxK/y07VPVSLS?=
 =?us-ascii?Q?a1FTh3dx8XuT2m2WqzHGDG69aZ8Fe6jYriY7iXIlNPErk3iEsOJRcFueuQrB?=
 =?us-ascii?Q?2g4XpyaowygMNy5TltYQ/7RMxb8CYfs4hSpXpqR3Txyk9egnq4JvffKEimKu?=
 =?us-ascii?Q?U6vJGNNRoZ5+UaVIvh4UnVOlkkXnQTkTuJ3KZT2znzQcTVJXCMqK05p24lVW?=
 =?us-ascii?Q?r3Ainz2tYkwHfKAcQkHs2Q5Os04vpI882kemelEApSxTIpV0ygGrdLS8IHCr?=
 =?us-ascii?Q?sTE4P4GHoKLJepSjLYIATT64pcZrOSQ3VjFtbx9nzTzMeJtUrkx/ROOWAZ9y?=
 =?us-ascii?Q?pBe/chsV/splOJccdHkOASWqgwMG6fhZML9fT9CgUcM/Fj1tRgyH959+J9UN?=
 =?us-ascii?Q?XrJspaaehtQTCsTqX8tPEL/E5e/Uvy5mZ4lyebNiBUgRhNvGZwHvU7HNr6mW?=
 =?us-ascii?Q?rlbHhAGvrPi2b7Se0rOUo4cF9Jl4UwUatBnyWzJhVw6xICiBQcnVKYNZ/J7c?=
 =?us-ascii?Q?np1TGbblrBIu5buBoPistvLnCb3VUyTNKcKtrg5nLFJsO/TlrcTEhcmGwWDV?=
 =?us-ascii?Q?Y9qO4u17CWMXhJH/eKVlu1hoYmWebi7jIEVILpBjK2CSH2fmdYTVM/sLbWKM?=
 =?us-ascii?Q?+gPHxQ7EJ6cYcrVW12f+v2GouYJKYWljh2xNzRN+CQnjnOqDDy7ZCa5kaM+q?=
 =?us-ascii?Q?6s/IhLCROIQzG+GUCYYWVA7c7j72Lc9uBzAwnxhLZwkLQEFleFsO3sCnj/mT?=
 =?us-ascii?Q?0ZflMKos4evIAWCiHZWcFlnRaRc74ILi/y/cndHD2SAoNI+zFg6DlIy4J1w8?=
 =?us-ascii?Q?LwX7IDk+ia0ArR0O/TXjHW+8KP0lVPw37QWATrN5BfqA+9RK/c3VVPE/BB34?=
 =?us-ascii?Q?s4Vx4RTkqxVic+DHa7M7DUJ2c5QTxL71AuoJ7Z2aW5J/wC6pXtC/hEXZfh74?=
 =?us-ascii?Q?juAiBmHnTsJLXvQL9qcTrZgf/85DSd6L+K6soXRvRaoXFs8PskMZQiNMuBGu?=
 =?us-ascii?Q?u4V/9zCS7fYyU8wG1yvbzkJ93NcjOldptn3JaNuYtTnxWFvja3GA/+fE83kJ?=
 =?us-ascii?Q?W01aUJtIljIonH+l3eOXxF8RRmxsQRa2NSobCM+GZ1Yzw3sB45PNUUGhFdJv?=
 =?us-ascii?Q?3iZBLkzd8AUEdL4ZSllZ383vttQhTg8UUEPbC5rWNYAl6R5RZk+7VMoXIgwG?=
 =?us-ascii?Q?FKDqrtvtUHaRPTjb7phi8rTVNWz+D5Nc+Irb7ig1QGNCspfmdzp7ZvEJzLmS?=
 =?us-ascii?Q?GF+t6Q9Buf41WxdwYHOYcDYdgr3I+eKvSdO9Jc+ORIrmeY/fuh/YY6kHt6x+?=
 =?us-ascii?Q?1bxXm0w/avAB8TqReBmm8pH8Vu7Jn+5tYjYSp1skFasrcr7Eu8Y3GDsig2sL?=
 =?us-ascii?Q?jB/CCOxr7hHWS6/K/zE/xa1Zpiz8kSZQBvvxQwUh37FdN/GfzJBOdxcIZUh/?=
 =?us-ascii?Q?bFuwglqOu6DCeR+UxcZYSPerXd19A4jsUS0u75w0Evv3dPLMXAI8PCK6lg+Y?=
 =?us-ascii?Q?09SXCdTua5x5Qttm0BUoALA+nrKF91G7E+9WNAMtYIq0SlhO+ezV0kCYBD5B?=
 =?us-ascii?Q?RLQL19cvDpoR9TISYvDiHUgWC+ayYSxwW2HaSPYHz8VNIxdw7pyVAgqGBuFD?=
 =?us-ascii?Q?sXR7Nn9Jjy78d/O2JwNRqNKz5etuVZs4Lm4pKmPcIJUUmJyhmem7Ays7N2w9?=
 =?us-ascii?Q?X9JFHY7xSYpC4nbVtOgzXbKEorxkJgALvQxkaLhJgXpInT1GlP/CceITi1Uv?=
 =?us-ascii?Q?il/H+EL5eoA4PPzqwctHlWgNEN8eZtw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d446413f-1c36-4dd0-b7ca-08da1847869f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:34:30.8111 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qi5ZBTiCMEHI0hzCpuN8Suykv6oircyOFfbm9FhjnlsASopNs/FgELDlEAXqhXKCWz04v0TbcTa07lyOWMxCueyQiz/XeHZ45dT9SsSwQvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2200
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070017
X-Proofpoint-ORIG-GUID: KYaZ3coqmCT5WsXPVPLzqm4zdv8P9wTl
X-Proofpoint-GUID: KYaZ3coqmCT5WsXPVPLzqm4zdv8P9wTl
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [Ocfs2-devel] [PATCH 25/27] block: remove
 QUEUE_FLAG_DISCARD
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

> Just use a non-zero max_discard_sectors as an indicator for discard
> support, similar to what is done for write zeroes.

Very happy to finally see this flag removed!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


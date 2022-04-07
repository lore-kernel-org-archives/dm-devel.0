Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 509A1C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:20:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-zg5_V9_nPraM459DJq65Rw-1; Wed, 06 Apr 2022 23:20:17 -0400
X-MC-Unique: zg5_V9_nPraM459DJq65Rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22EB3811E81;
	Thu,  7 Apr 2022 03:20:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C1A74066C9F;
	Thu,  7 Apr 2022 03:20:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A81C3194034B;
	Thu,  7 Apr 2022 03:20:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A2A951949763
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:20:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85F5440D2826; Thu,  7 Apr 2022 03:20:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80F4540D2822
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:20:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63F6A185A79C
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:20:13 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-RwrWWx8nNNyUzsnPi9B-7A-1; Wed, 06 Apr 2022 23:20:09 -0400
X-MC-Unique: RwrWWx8nNNyUzsnPi9B-7A-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2372avAf024455; 
 Thu, 7 Apr 2022 03:14:42 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tared-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:14:42 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23736QaM029516; Thu, 7 Apr 2022 03:14:41 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com
 (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3f97wqsj63-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:14:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB2698.namprd10.prod.outlook.com (2603:10b6:5:b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 03:14:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:14:38 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsmpk2jw.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-4-hch@lst.de>
Date: Wed, 06 Apr 2022 23:14:35 -0400
In-Reply-To: <20220406060516.409838-4-hch@lst.de> (Christoph Hellwig's message
 of "Wed, 6 Apr 2022 08:04:52 +0200")
X-ClientProxiedBy: DM6PR02CA0103.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::44) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd16d686-cc37-4a76-3d91-08da1844bfae
X-MS-TrafficTypeDiagnostic: DM6PR10MB2698:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB26985E3A4FCB8369FFD925C58EE69@DM6PR10MB2698.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: EWt/W6binc2eK/lECYWJ5MwOHdOLjtV+I63HmdvkMRPRB2htoEOcPRGRfBMW9tbPGBqlwpjpAkJkS41gbveQu/1ScCzlgh6qfX+5SUmKqzDqD9VCEurwxyL8ZDNRsdz7Dpk3QBzQh2SlIHtjGfQdTIdFlCS24a6OkGPBx1tSbQMGWlo+oMG+mJyyP90zI5KHK6+ICjV/1NE32IA8lIUzdKd2C502SWwtmefP0PT6F1HTtPFJYADznODzb1W9VN4bDPmdWuMeuD1jiGv+fTYDvXhGCSj308rqAwwzVVW9OdzGECRPxQ5aIjcCMSahoL9olDxMGzyrRM/8lHzaucrBhvV3NDQ1CMr6SMrzXb6fdYEDgt9/G5LqWRhdPIcNm226/JikUF5Nyn1bD14RhA6VSTmuILGHdcgAtVxRKnBDqWUDTQbwfZlFL9V7k2ssGgxHy4cR/k1cgqKf314TPQxIHL+KP0TLYM1MCYTgKqEAP+H7T26foljEU/ExTs8iuJ8lpIvqL1uZLZDefvYp7Nb+th6wIJtUXdnHcTL07mRkkGzPAA6VOo66s2Fa7rfuatRkW+KnPCZHskImIZcvDZGmNzG+W08C+CM6/1iZcDOS8U8RKtYpTaIs++MNs+syELQw6R/pto2AZPDxz6dSuzvVFt28XRVCfsI0SJSvgbhKdK9Cm0osZW5O2c+hf1fM6QCEexoFmHfDTRVUNFmBW1Acvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6506007)(316002)(66946007)(66476007)(66556008)(8676002)(4326008)(38100700002)(38350700002)(86362001)(83380400001)(6512007)(558084003)(6916009)(186003)(508600001)(7416002)(2906002)(36916002)(8936002)(6666004)(6486002)(26005)(5660300002)(52116002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0lCHWB5CBAfwxdmlYZdoZWcbAIAxhJ3LODYJThGmg7jDyutQne0bNBmdyDur?=
 =?us-ascii?Q?ByoGymw/Mop0IlkkOV+oyCY7nLNjITJCUSg9MCdcaq5JYJP24EqvYPFdX2rT?=
 =?us-ascii?Q?EpB4c5NM1fjYkwTZph+pufL8FGWp74GdC+JL5lX5qfhCMUSsxav9iHP4vAVx?=
 =?us-ascii?Q?YPHuc3hMHDhBFgSS9Uv7R4Nhr2wMr1sA8n/EiiJSjGEiEY76rJnCaI5w4fmh?=
 =?us-ascii?Q?q9tpd8DGH4QihSpZgc9issz6MhKD66MCp6iUv6aHIVCBvVxO/0JMonYZSYKl?=
 =?us-ascii?Q?enTfd9Zt7rKdhtOXydajK+3LT/QeppMoj4yefqPJQI3VFi3Rlzwy1E/Rvtwr?=
 =?us-ascii?Q?ee2wlH6PQY0/aM0wa5AAZklIXcDd8mCuuqzkpRTB5yI+iLslVVTR9uBhpt2p?=
 =?us-ascii?Q?JKf1DuCnMhXJcSAB5KsFDWqN/y0ddIUIQ8d+63k6nnPwDAm/wGesJIyzZNAU?=
 =?us-ascii?Q?gDu10O+HzN9khXj/iHdhVTB0iVmtP800x1T2SfH/qUbhyQyAhcLlQFqlizLE?=
 =?us-ascii?Q?3V/cg8VXQZ6p1ERUkv2z7PwmZ9rEBHnUjyvWa5u8btsWLsa6ebMCRDNW7it4?=
 =?us-ascii?Q?/BN3htjhk3MrHj4pHfYaAb2HwNCQRjrjXyc2pUBiiupu3XCJFC/vQYF79Xap?=
 =?us-ascii?Q?dhpiqCwmEsmHnXbhHMURJhmFqpFjGQM0rmE7VYtaS1azRH/zH2TqK8HW8pwz?=
 =?us-ascii?Q?TT/eH5/bYBYmb7JWQZn1K68lBk3v9ggLRJEPCM05Jk8LGsF5KpcGNVE4pgKg?=
 =?us-ascii?Q?4wU/icVJyufC99p/FPHbL+NihjwQjGYcPWFgcsisxTrRrMb2cGhmKTGbT6PW?=
 =?us-ascii?Q?RfNpNHvqtrgo3ANfvyR9Xp5jxXKUwch60zmR9Uk5vgfncScjbcjQ4HYYlUFd?=
 =?us-ascii?Q?vFddJTWKXkIkugR0EPcmXoyOvGme2SVnwY+Ib4pH00P8ZGZeIuH99iM6g/to?=
 =?us-ascii?Q?TFeJTH+Td/paquVRUEJuE7J0yMRrdV/Sax5+EtDFe98NIG+whyI/6Bj1pNqZ?=
 =?us-ascii?Q?wOxPRR6nGmWycCS0nKv9YSiVjwgtRnOxIg3NK+XcPi1oBfVz/TpbxEX4/kMg?=
 =?us-ascii?Q?m/AwBLjNevFMvwTFqmi23A5aK3TZhSU9TnAL3af9msEWxUzOH6FpqZqVvp8H?=
 =?us-ascii?Q?4Js9ZlIyr3E4FnvS9OguYjqKW5DJEs3mb/zBh97Dcj5LFyioMsPh/8mGnSYU?=
 =?us-ascii?Q?84UqYKNe5gS67rR4fEVKDrxZhu+GK1i3TNzQt/S+aCAyI4U+BA8muQftrtdb?=
 =?us-ascii?Q?hBWSXul3WwBbd16Hn/0meDVY7qCPBaaCbFxY47FSll6l3IOEUnLLT8iE3Wy1?=
 =?us-ascii?Q?gxVqtOXX1j27wClIJNcMn0ouYT/Q1ExScWcQUN4bzUk1qFHuu5M09nbQ3qa5?=
 =?us-ascii?Q?gglYD+TRIFgjl1PWuqnOT5xcm6L9/0iOYJZNoNwHYEAEB/Udrxiyea4lpBjV?=
 =?us-ascii?Q?aGMWobILBsEOQ8iI9tmBsMc8xwMkSRAsF1rgcFqTYWuR6TVkwV9h3cACztyj?=
 =?us-ascii?Q?n0v+y0ZGv+/DZqRDh8xCA2h3FYBxucCT6YVND0UGYifN2k1Vx00zY5fd6a8t?=
 =?us-ascii?Q?MjiolsTl/hoVVWbWtxtLdTlwrnjF+KNM0bgPhRpARfUs6Rtrb9rwaAJ38xl7?=
 =?us-ascii?Q?yF+BsrT69GYVCe3qoe0SHsjokAv9TmjFF4WJO2GFjaycWThlGLk1SuEx7ER9?=
 =?us-ascii?Q?yyg+pneArLHJOfX8+vAxAQNmqtL8Ut+fvQAF7I7RALWEuVD+PVU9mY0qqkS5?=
 =?us-ascii?Q?zJyf1w3vMz9oPxOtwim/64f7os3CZL8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd16d686-cc37-4a76-3d91-08da1844bfae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:14:38.0462 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xa7XDsF2TUSmbTPOLGTD/Asj3pN0wQx3E3uvOsKaxFNEGn5p6T6o4mitNxIXls+I9gNOdTohIBjq9Or2InsQZNGmqeEh2TEB3f7kd9F/mXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2698
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0
 phishscore=0 mlxscore=0 mlxlogscore=949 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070016
X-Proofpoint-ORIG-GUID: mizjd7EMRmxU8Dxf6z3sZxhlMV4xX3Ds
X-Proofpoint-GUID: mizjd7EMRmxU8Dxf6z3sZxhlMV4xX3Ds
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 03/27] target: fix discard alignment on
 partitions
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
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org, linux-raid@vger.kernel.org,
 linux-bcache@vger.kernel.org, ceph-devel@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 ocfs2-devel@oss.oracle.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Use the proper bdev_discard_alignment helper that accounts for partition
> offsets.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17DE5C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:30:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-xgaWLZO7OV21EitHU_UzmQ-1; Wed, 06 Apr 2022 23:30:22 -0400
X-MC-Unique: xgaWLZO7OV21EitHU_UzmQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8272F2999B3E;
	Thu,  7 Apr 2022 03:30:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 960DF2166B16;
	Thu,  7 Apr 2022 03:29:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F3F62194034E;
	Thu,  7 Apr 2022 03:29:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7C991949763
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:29:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12CAD40EC006; Thu,  7 Apr 2022 03:29:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CDA640EC003
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:29:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98BF9899ECD
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:29:42 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-TCDpR0lGOMaxWptAy9-7UA-1; Wed, 06 Apr 2022 23:29:38 -0400
X-MC-Unique: TCDpR0lGOMaxWptAy9-7UA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236M7gW2006371; 
 Thu, 7 Apr 2022 03:29:15 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31jptr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:29:14 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2373KQkh014152; Thu, 7 Apr 2022 03:29:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3f97wqsre0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:29:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (20.182.127.76) by
 SN6PR10MB2637.namprd10.prod.outlook.com (52.135.81.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Thu, 7 Apr 2022 03:29:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:29:11 +0000
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee29h8qx.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-23-hch@lst.de>
Date: Wed, 06 Apr 2022 23:29:08 -0400
In-Reply-To: <20220406060516.409838-23-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:11 +0200")
X-ClientProxiedBy: DM6PR02CA0141.namprd02.prod.outlook.com
 (2603:10b6:5:332::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8070910-ebee-4181-449c-08da1846c81d
X-MS-TrafficTypeDiagnostic: SN6PR10MB2637:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2637A3B76030A51B21A21FD68EE69@SN6PR10MB2637.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: KBpq+aayhUAT1pO7O7lX4YJ5rmC/ymbcYRAvX26Z08Y8oQ5OC2BPymwjj5K76vcB4dSLDTSUvvo/dRe6V34hT3xGMvNaAlMBELuNoxgHV1PnutkOiGEzImc3I6z6D2OmQWt3+fim8uCpdG1E9RLu6N5PMnuux6W3GoJju40aZ7yfo3+MILsD7kP2NO6XAMQ2dEMGyJnKxHsnvAzvzfZWOWqENSs+ynCpHoR18aBtqIy3dN35sSw66+tsZ061H7w/WMp/CTUSb08cv69Bmz0VjFAwK0gNSynz/0zt62AbfvCOBeKllzziqiVvUzVHgFPYOrAbAyMTsIHEcY9ZmRMAU1VHuh8DYWl+Tta11PGicV3k8U2E8ncwwKkdD9IlsPFLTI2Fu/r5Sb5o6i+taQdsmizoJv/lqV4j2EOjinm4YgFw8giw3fy66BNUvHNhtkmhvt3j6YDygf+jcNyWob2Krpwck1f8LaCYEpYl+1USJs96cXikOCFvzKZmgRIBR+pcpFj92BkXVlqfGzxIvqDoKGqCnqNrTSwo7/3N64Atz82uXNL4T13nJNSz+D2cP4pMd4g3PKTIxECxfvIhH/ETamwTnk3Cy1JnNwsh+DK6Yqi0VvKt7YReYH522aX0RMpAyRdZR2jFF13NevqludULWwUeSazJ0QN4xFwxhLDdYUPyJR6fD5qWQQDokpgT3Z7hHcQCXSrZSpTicAIf49Z3vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(83380400001)(54906003)(6506007)(52116002)(186003)(508600001)(6486002)(316002)(26005)(66556008)(8936002)(38350700002)(6862004)(66946007)(4326008)(2906002)(5660300002)(7416002)(38100700002)(66476007)(6512007)(6666004)(558084003)(86362001)(36916002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SPOdVXZ0+i+GnjawtDUnbmSAWLngszVdO5C8CxxotLuixJuu3IFgSAaoCNGb?=
 =?us-ascii?Q?ZWGlOaUTK+r96PcQ27XzpLW51NL4qPCdz+47SVqd/Lqggz/H2t7ChkbkuKjG?=
 =?us-ascii?Q?OZLSC7667yVg+hkfNKptOBLhNkX4js+75fK+3S1f3WqNzWujU/lCE0i4Jvff?=
 =?us-ascii?Q?orAP8outnZXpiR/+1jzkrdD1QyRdW03kQPjmex9NpTUkugW6dgaHMpfueVMJ?=
 =?us-ascii?Q?5lJe2nq9Pjx83JYh775/ujlJx/VA05ZgE1d0tA8uJ91vgm6PzUPO4n07s0mU?=
 =?us-ascii?Q?FHzcrTNHn5SfHHGBmoitQGOrzlscedQzeaQhjb3AuSGzyEePl0evWsBrYLyy?=
 =?us-ascii?Q?xBa0AJVANloyU1uKw1q1v444qulQFNGugIN0w+Cx/PCazy84MOTlxt9MWAsT?=
 =?us-ascii?Q?qmpwCAhbmJeyWLEwB1v1KpRhkvexr+XWWoNslPn+ScxmxQC8MiOwvjR5nzI3?=
 =?us-ascii?Q?Ywp7/BIcJh+9Bit58puiEHNf2W4Dulm66Dv4S+x9qJk5rxSXdzq5LJWychIY?=
 =?us-ascii?Q?tjMzrcyqm547+qJbjAODeE4re7w3ExzliRLIgGZsKalRxocNd7iS9zImfcjh?=
 =?us-ascii?Q?nX9IPOv6iIolhB7WhmWBH7l0n6ZpfSlNJgbgop0yg8OyBvKCrnKTXa7xc7Iy?=
 =?us-ascii?Q?+ivSktS1VAEnWYwY3j+sdL5AW6kBBgNWaTWh/s/8UsgEz0snP47I2sAeU2Ps?=
 =?us-ascii?Q?8WlPwpKTwKrTUg+miqG5AsBoWXjdjMPZBrwvHl57Qlr0ulHsZDTcDYYlmYJ8?=
 =?us-ascii?Q?SnmOqQiNcb6ZnPqB2YXSC/VhxJoXlT2v/rxvV9CZZjx9R84bSd/jVu2qLUMS?=
 =?us-ascii?Q?BYmKLAkGPuR2pXQwLT/3SdoRdcw0BlA8TvdrOB/04Cd+s1hMR4uaKr4lBV6O?=
 =?us-ascii?Q?PQMi3A8E+n3wyvmISSddSW0dcOl7p1ChxcRFBtTZS7fCqatTpAhGsJDPWcfb?=
 =?us-ascii?Q?30Bc7SXQn00ARZK3PMiVoIsaVKs/dbCQoSsZS+jH/AJxgVS9YzLQVzKj76WC?=
 =?us-ascii?Q?6uH1gsf1dCf0ACTdIQWGqN/nMLcVoHStsjWLbmAMtqtSo/+FluAVHFDfvHyC?=
 =?us-ascii?Q?9BqZ+LCirLAC0W6xOAua4O0X+RHlpPK6guZ8cS6RQEZVAlyDsTvNIdnmY1mc?=
 =?us-ascii?Q?LlnJ4GP/CV5Oj5DCEbMmQVv3Y8sWDtTMTx7pCnt9i4PGn3wIULCfDgKoG8Rt?=
 =?us-ascii?Q?QIW0qCQvZ6CVvp1sd/QWBs8yQa70FN/TyixcJRHvxsndkpab1ngIZDrgZlW7?=
 =?us-ascii?Q?OzmroAm6t1WWtX3vB/9sZypprpYrX4TOb6B1C2cFo9Oi7hZrw8L8+Cg8YYON?=
 =?us-ascii?Q?9ZAaGQB8tphUSKelFXFWeZqtFumcjQENNtlIk+O9xMNlKfTbVPiIcwOinw6q?=
 =?us-ascii?Q?fW0LXIARA2UgtbapzMggqC3CNr9HzGU2M+CYUY1402NTj591OG7ICbHg+nzW?=
 =?us-ascii?Q?/0NuOcbDG77Yd7lnm+mkaMZWG/AijhtgX3gtenoQzTd97CpcIMsgx5Uby9Zs?=
 =?us-ascii?Q?qUO6uisTDag8+yZNxjt9TAW6dO5QGaycBh9ehb2giX7AreedPRsgvmXr1g9I?=
 =?us-ascii?Q?FsGiOuQAnIhOsEo8RXrojUqn02esH7vPVmPSTQbQluRbCGUSx+d/tuslMbr7?=
 =?us-ascii?Q?3Yt7JknUR5F59Xl1SyifJrdH8GQnCLQljPGj7AxMFpLl7cTR/ee+O/kSyOZE?=
 =?us-ascii?Q?4Ul2IhyKbKmdok1Y/hYgp8TrtFudohXlhY48tibWOtgY2KGoSM0oV234lUU3?=
 =?us-ascii?Q?fSGDBOSWFoagbxS/Tzn4AD5YSlb00oE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8070910-ebee-4181-449c-08da1846c81d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:29:11.1892 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gi0BFA2Ok7V3tE3LFDdJiO5tuxtDLwrPwtU1KTZgJtOze8Mi+AtLFgp/5Z2pc2BPvLLQTZ5iuHjo0466k0W+Blb8S3MwLDwPCIAyDfcmlAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2637
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070017
X-Proofpoint-GUID: r6gyQw1VOXHdH7f3ZbK8XF6W2k4Rmy-H
X-Proofpoint-ORIG-GUID: r6gyQw1VOXHdH7f3ZbK8XF6W2k4Rmy-H
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [Ocfs2-devel] [PATCH 22/27] block: refactor discard
	bio size	limiting
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

> Move all the logic to limit the discard bio size into a common helper
> so that it is better documented.

Looks OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


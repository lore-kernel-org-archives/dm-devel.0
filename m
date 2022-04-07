Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE1C5C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:19:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-cw7XyIIcMLeKwbJhLDJ7sg-1; Wed, 06 Apr 2022 23:19:20 -0400
X-MC-Unique: cw7XyIIcMLeKwbJhLDJ7sg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EE23899EC5;
	Thu,  7 Apr 2022 03:19:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 76AF37C28;
	Thu,  7 Apr 2022 03:19:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5BEE21940372;
	Thu,  7 Apr 2022 03:19:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B58CE194036C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:19:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D3892166B5E; Thu,  7 Apr 2022 03:19:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67C7F2166B13
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:19:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4499B1C05152
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:18:53 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-lsQN3o2EORyGmlcCUPkIWw-1; Wed, 06 Apr 2022 23:18:51 -0400
X-MC-Unique: lsQN3o2EORyGmlcCUPkIWw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2372POVs012451; 
 Thu, 7 Apr 2022 03:18:27 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcjad5-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:18:27 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23736PuX029482; Thu, 7 Apr 2022 03:18:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3f97wqsm3k-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:18:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 03:18:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:18:23 +0000
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtgxintf.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-14-hch@lst.de>
Date: Wed, 06 Apr 2022 23:18:21 -0400
In-Reply-To: <20220406060516.409838-14-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:02 +0200")
X-ClientProxiedBy: SN1PR12CA0078.namprd12.prod.outlook.com
 (2603:10b6:802:20::49) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2ad1994-3c3d-4e6a-83b6-08da18454625
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4408F2AE0D298AF4ACC6B2E08EE69@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: SLUvISXJLjYUGupRQ2XT1s9tBnJewgVitQqt3VbaYK1TlsSRvia+IY6r1cACAlU0Wa9sgavIuhykxLRm2HHe0Pdr64qYaVsO1e2Y/l7KspFO8oSlqX4OsmfRnYdI20hlWEaGs4kWvsvm/5mVwcwnyEKRAF5RE9SHBE1Knr0mMH/zSmqo4bp3hkT82WooPA8N5riuntQXkoB/rNN7cnESYFFPL2asRWA+jwPCZVUphEvJ5XPFvyT1z2Eq+NQwtwzdcvgLA+IBZswJePmovMcCLym7FxouJeyk0vlpY3eLrZNZhP/6ECTKFt+JJ0PAaO6eArEkX+hClm4sYV6QFop66FauGhK2UYdYYA4opvhsBScbB5d4Ed8/cQCqQQ+dhdvW9pdbQoPmm06l/Ahmogsm7wLzTX0M+JEoODGs33L2YsXb/cL8UawqLEDKnXTkjWs2M1XmfwZ/zkzZFNgzArnuUVx7eIPt65HU/Tk1oJrY5ysSRqrw4b3w46oDSItf5KrU9Dp9eoCGmADWlTqdgPqBj3kN9pTb8d0Oc2PybL2XdJH8pDG1B1GumdgkmZjBrEvoXcN6aVgIojHhHdUHDGeGkGQtFkG19FJ6njKmifx5j1yJA5ZsiOBoHwLYh6Zi5wpftFEN5GFzmaxFhO7stvzBoqXlPrLN/M+oOPsEm60V21SQkSDCCwDKlkOodU+X+oC+TQ95BXh9aAkiCMJct1gRlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(508600001)(6512007)(26005)(6506007)(36916002)(52116002)(7416002)(83380400001)(186003)(5660300002)(2906002)(8936002)(54906003)(316002)(66946007)(38350700002)(38100700002)(6486002)(6862004)(66556008)(4326008)(8676002)(66476007)(86362001)(558084003);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xIsd0zLwcVDDnh7s1S0dJ4gppcaVSQwl81pqFbYz/+egH66fuo2Jc5jaKjrG?=
 =?us-ascii?Q?5iZ9E5EH+nYNwN8C6r3SBW1b9dbddV+7pieUtyv0jx1J2YD5Zzt/4MLaM/ko?=
 =?us-ascii?Q?I0nzssasq8sQbtr6/sAG7CmZrQpDLmiT+qpBj3wFUafqk85W+Drzww2xyEpz?=
 =?us-ascii?Q?wI0DSIThoePrDVlDDs8ivw9D3oeEGiNA1ioOAExJdUzArdsS8jer3gKF+rO2?=
 =?us-ascii?Q?ZvU220BzEAtzCOhzO8Ff/U2ZjsQ1TkmSKxflXEjpGHY0cJ6zhVVNNp3HB2iC?=
 =?us-ascii?Q?bX3J9jWoS4tsyz+wWwpJJrTnQJ4zPsO6+ki48PWPdsh2euaJ36jks7y94hZi?=
 =?us-ascii?Q?V/cN3QBs/4R9l81o4Uwurg0tzElEY/5T+H3wo6uTYg2ylkdH/Jmw+nqKzPGN?=
 =?us-ascii?Q?4YDGYkt9Sug99AMbl29IOHzCzYc1oUBMobgGJMbLklxYvuIgUIRrsWnRJuqi?=
 =?us-ascii?Q?ZIyHsyLPdR2QF6NwFaadAFAn1tjlB3IQVnjCjWkj7L+oJGFk7P8W/uJEo5Q5?=
 =?us-ascii?Q?T/c5ZzvwDW+94AZzbaWiENJI4Ctp/2vbovviAIZVOJEhMqaojguOJt2bRJMO?=
 =?us-ascii?Q?Y+748XcIrXL8IEUWvTiHgZYiOOsIhJzz0+hHIvk/yly9LJ1+hb4pRfxtnTC5?=
 =?us-ascii?Q?TMf3WWY/vby6rTVShdQNrzoNMGjnbcEHW7hNd4ZksoAX6LVufUAbUaL8PF6m?=
 =?us-ascii?Q?VBzXXc97sA+qu+HcVVA9PAVO5u2rWh6e0kIw7MFVLOcKd2Q/DqcKYobFs41O?=
 =?us-ascii?Q?qY1zIbQjB89zPwjOOdwl9orWX0fCdfuawnQpOhIToO1UVkhmzdymnn5Lkq+x?=
 =?us-ascii?Q?Xz3U/pDNM/7XXFjSc95PFNwEi/Rdc4l2bxSZMAdvqQZIGrzqapnBUMY4CD33?=
 =?us-ascii?Q?d5giA1c9NSqUUoQSi6SS3Oxsne/7mmvsWjGhDB02IB3O3qXiUVZGLVls3g1r?=
 =?us-ascii?Q?FGY3G0vC8ZetoHeQa8UMBfEYNwQ6KkCWJpwhGISTrgTb/Nq3vwYOP5kWdY3k?=
 =?us-ascii?Q?SAwF+RAnM4qU1Z4QNlCBrx662uuC9IawT2Kk9A+lXP16FAm8vQ9b6IOy2X3D?=
 =?us-ascii?Q?rQf3kx/nU4QPe2JannqJimA8cG+wIGuoTH0Xf7v8vbEIVt8dpGHnpSH6qIZj?=
 =?us-ascii?Q?sbTPBIThpBD6cDEiSSSjKMB9pZrBK1gwMWBy1kiw+T71IBnMkc0gjPpFkFO8?=
 =?us-ascii?Q?InOFEkVOZfl/2n5j8jRuyH8wA1H8KkddXKUwqZSERpwjVZmXvDo8Fp9laCpo?=
 =?us-ascii?Q?MmB40C2ECG/Cue6W8SMe5Y9zunHmiBcfxendBmJgFqnPzHwH65DkGs4y56eK?=
 =?us-ascii?Q?RU7FxGRN84qz5e01RViYgxspfOMT+NtQsKRINgp4oywm5U3jLnumrYnaYT1M?=
 =?us-ascii?Q?/sG2odArhsDNTeuPtDYCCTCKWNrFHuibcJ4SfhQVefycP+gdmnxHjEdB0p5e?=
 =?us-ascii?Q?wl3LG9BFWzfHBRcE24beJ2a60HJYtr5i51pQOOWU0+3NRhTcrkxMQarzn+o5?=
 =?us-ascii?Q?U6JvwGc1Sis+FYUsNIKJzbs07TCq2AeZmof1g/k779pG7UMHfg2oKC5dAD0o?=
 =?us-ascii?Q?0+diKePSeMM9CRHkEK58cTVlS+sTGDjnhSWvaOM2zOWO69Ny5CaatYLC+rAX?=
 =?us-ascii?Q?OHcId1N0UPO0A8mnGFLCCFEgJ72887m2LOfEr5JhHePt4eLhRXXQJ0jVUXrb?=
 =?us-ascii?Q?6Ag3ZB/97Kzn3SXO2TvruRccP3HpJnQWG/K+tS+j3t7o22HdESkN69evPfSL?=
 =?us-ascii?Q?kLkG+Yu6HtWm/SQFpdF0wHGl3iEZ90M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ad1994-3c3d-4e6a-83b6-08da18454625
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:18:23.6582 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZ9wn6/Z6Gqa+JKgYT944VbgDZ5imkniqjRmEsIQ1javdBvsN1/Na1raINqCIDzfpbrVWYGXUV59K401IhUHeyecdeVGfgDhGALhkfADxIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0
 phishscore=0 mlxscore=0 mlxlogscore=946 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070016
X-Proofpoint-ORIG-GUID: Yoj1mmlMui-AZzQWBd4yidsBNyVdnJfj
X-Proofpoint-GUID: Yoj1mmlMui-AZzQWBd4yidsBNyVdnJfj
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [Ocfs2-devel] [PATCH 13/27] block: add a
 bdev_stable_writes helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Add a helper to check the stable writes flag based on the block_device
> instead of having to poke into the block layer internal request_queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


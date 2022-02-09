Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186D2C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 21:12:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-ZWgQhL71Ot2J3jUCUX072Q-1; Wed, 09 Feb 2022 16:12:31 -0500
X-MC-Unique: ZWgQhL71Ot2J3jUCUX072Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 862161006AA8;
	Wed,  9 Feb 2022 21:12:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A9B861096;
	Wed,  9 Feb 2022 21:12:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C46F34BB7C;
	Wed,  9 Feb 2022 21:12:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 219LC9v9009767 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 16:12:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2D22D1121315; Wed,  9 Feb 2022 21:12:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 280C01121334
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 21:12:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3D3E1C05EBE
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 21:12:05 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-84-VQAfAx4vMm6bqUfjNkO7VQ-1; Wed, 09 Feb 2022 16:12:04 -0500
X-MC-Unique: VQAfAx4vMm6bqUfjNkO7VQ-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	219HIpeh017445; Wed, 9 Feb 2022 18:00:34 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28na86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Feb 2022 18:00:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219HaRk3167489;
	Wed, 9 Feb 2022 18:00:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by aserp3030.oracle.com with ESMTP id 3e1f9hs6bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Feb 2022 18:00:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by BN8PR10MB3489.namprd10.prod.outlook.com (2603:10b6:408:b0::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Wed, 9 Feb 2022 18:00:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::2d45:d1bd:ebb9:48d1]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::2d45:d1bd:ebb9:48d1%4]) with mapi id 15.20.4951.019;
	Wed, 9 Feb 2022 18:00:28 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wni3sz4k.fsf@ca-mkp.ca.oracle.com>
References: <20220209082828.2629273-1-hch@lst.de>
Date: Wed, 09 Feb 2022 13:00:26 -0500
In-Reply-To: <20220209082828.2629273-1-hch@lst.de> (Christoph Hellwig's
	message of "Wed, 9 Feb 2022 09:28:21 +0100")
X-ClientProxiedBy: BYAPR05CA0071.namprd05.prod.outlook.com
	(2603:10b6:a03:74::48) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33eadc43-ed54-4510-144c-08d9ebf60e56
X-MS-TrafficTypeDiagnostic: BN8PR10MB3489:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3489D3EA5A0539796B959C938E2E9@BN8PR10MB3489.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 53NeUEqzGzguB/mKdF21IbQfNjetWcow5zmdhi0ab56L0eC1gb33bNS2UQUso2mnN5ARJZjfB+UyBqndTFOXLFx7qG+QmKrl+0NDNehQOAQnq2ba1SfR7EPOb6rF5TETmeTz3K4VYu4sA4G4toRkEojRIMhci9za0oE/AQc/kLs++LwuDGJ0zkH6/XPijmEXYgYCKXdT5/4WvStPb+2cRixJ4eHy74QxqE+dHGpbUyzd71TPcaeP5o3leT8M5ADem+phuJ7pI6rFJW7pBRLNviUzdwUmiI6A9r8oIe+OPrijnIVkrrK3dr8HGeQRUd7oPOfqA/jgffwCubk1lLAg8LdXPyv8AfyJ3D+La0YdTn3mFofrx340vGG4uJGA61S9sntXuzkhFebypYUNVL+xb1DYiBCjwBEzxmmPmLoCah2taH8Rizlj810HD+ZqUEl+n5vK2Fq7L/hxAZLDJ4NoY/Z8vXUEhoiRhZmx+4l2NmhLuf5D7N83oApXcT7Xfd+rsh/65TWKFxoNps5jGzFcp5UDR3WJCN5fzunnmgYu0M75Jf8QOAPTFhS72L7RXtZDWAEtS+5rV2ogvUdvGaqRyfBiz3ltm4ZtvvOyzy8LT1lBQvZ6xDan32PmaLLoSo5vF7k4vFPHgEPL7EmPdBJMLYd8defDtFDoUYe0VC9It8bPvSA86XL/e6UhbW7UaivnFNSzomCh2WJmwk2doQqEtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(4326008)(66476007)(66556008)(8676002)(6486002)(6512007)(508600001)(66946007)(316002)(6916009)(7416002)(4744005)(6506007)(2906002)(36916002)(186003)(52116002)(83380400001)(26005)(38350700002)(38100700002)(86362001)(8936002)(5660300002)(7116003);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQ6l8k4S4HT0p8JtUY6mAKFPV37M5art+dpLclzCD+AI2ZzxiFAtehGAEr+q?=
	=?us-ascii?Q?wIZZsYqRt+T1np8TdxUTIbmHWwKzmG/CdIrAUlcCVGyMib4NjTXbx7Q/23iX?=
	=?us-ascii?Q?OBmEBa+5dowV2tSZbBTQbRo+vSMQcAH7CbCQv7Nk+NON4Kiy594lp07s2MUu?=
	=?us-ascii?Q?2k+j8hWlmSCi07CLwN0XatlkE6oqWtIFUeJQGmYPmn7guEDAcBU+kg/7Ul8P?=
	=?us-ascii?Q?6ID35Li4rOjSg/kPXaCxvDhQXdy2ZYtlqBBd1o8gu5lhEMK5lemnYf4rVZhy?=
	=?us-ascii?Q?d3odjbxF4KH64z0Nkja+KfURTDYYg8/PFX3A9X3VtxpVtqARbxgWoTSY1rg3?=
	=?us-ascii?Q?WutO6I69jjM+uvGOBuyfCTmuEQQVg/Mw+glMruH87Mc2bOEuq1GMQejWJSqI?=
	=?us-ascii?Q?gkkOWGCc70l39A2NfH2OOU+UnfNWOTlT9NREFZagUcp6q1hcL11SVQ57Ctmp?=
	=?us-ascii?Q?CC+ZnBYSB3+7e4oWZ7YWToRitT8A79EuxB9hffZs1RXRmnZYj3zkRVKwvCKg?=
	=?us-ascii?Q?pTkWjJMfgDQV18W/lkXv46oebDHQG68FnPtJV0u4FbWYogfpUztsOMoY2Zf9?=
	=?us-ascii?Q?Fpmun8buoOhynn1g7MYvUOmWbC4JSFFRObz3va6R+Tl8Nf10DtEzJhJb47oX?=
	=?us-ascii?Q?lnyjtVNK4/mJELkQC0F3v7kDVZmNn2pv4PC5B/znnCEigmcOgHLjQVyz24cf?=
	=?us-ascii?Q?7WzZ+JtSN3BRY9FjZo9HRdoD408VzFMn1duh281oMSFeYoY7en/Yulu3UXvq?=
	=?us-ascii?Q?8Gwh53rfoFh3+i3o1ftHikKzPFdqselPIPG1G5Y+o+CB8DVAlU9PwMZYl18D?=
	=?us-ascii?Q?Dlz8GPAXyAROlXT2VwSPEr4ufD/5pfWTNMR9wS6Bmoau5xLIpCt+lGZGDFoB?=
	=?us-ascii?Q?DNGxONZTZlgArufsi9dznzJfcRHzoIOwkP1ihUzVS78aXAaLzV8gLRUJy8qN?=
	=?us-ascii?Q?m1lIrSjFfmPR8iCoXhb76AsQ2iVnci8JZi+RUlVvQBnFln4KNk0WZcKjwPlu?=
	=?us-ascii?Q?b02oXYGeWyev9CuQJ0VMncvX46pf5ZzuQMKHXkQsftOsoo+J6ZkGBNo5eSEP?=
	=?us-ascii?Q?MK3iJMuUma0eJQ4VHRqhdjU7HD9KbcaHHhm2YQtTSQ9+OHhLBhZqBQv3VDK3?=
	=?us-ascii?Q?ey5fkWq9X2Vp8S2fb/KlNJVBfuiyFCvyhS7nNeKZ+8aP9KHLQ/q26pjEIEvQ?=
	=?us-ascii?Q?ss26QpBbH0vH12mYW9IibglEM0VDSqSLh+xdpBgD3xAFRhc2YD8ajlA81Rts?=
	=?us-ascii?Q?VdywWdd2559N8eMRlyU34A8dZ8LUOe+TUBel+Q1yhW3M8V0jatmnJFjQZvXf?=
	=?us-ascii?Q?kS3XEVrty/AE1AJ4Bc+VIrGbmiWk+z6SO7mC5Zlg7YuWRvePXabSqr2DjjeF?=
	=?us-ascii?Q?V57hx0txpoBfqy8ffS2xiY5uDhXZpI8RPFf1iaNYIRzlt+R9LOfscrnYFgeq?=
	=?us-ascii?Q?igylHzGcQmlEpMkqQwzzQzub3ZX19Q4STlvBZaocMPF7qbyf/pAKwaUG6MKw?=
	=?us-ascii?Q?CCAfcfhSCrUsbgU6KOy24TUZv1Q84PC3XDx+TJPSd6Xxyy8Hkbj8QWLm8A0n?=
	=?us-ascii?Q?h9XBQS273WZWIp7pTrQMamR09wwVFsBnEpZytOU6oPTOcE9fkc4KA60CTMG9?=
	=?us-ascii?Q?LO2WORpL3Fxy/B+BCREZwmfemu8iv8ILvwFZgO3SX9vNgpBhS1UaH+PZu3pF?=
	=?us-ascii?Q?3JyaVw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33eadc43-ed54-4510-144c-08d9ebf60e56
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 18:00:28.5746 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3cL/X2aVKFNPpD/uqEfMTZdT+sOhX5Dfiwzl5MGZPyPoZgFYZ9PYvLXzWSrriG0pw0WF2vLXF+WETA9fAb4gmhMApjpAEp5ODPcSOTZARE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3489
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252
	signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	mlxlogscore=410 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202090096
X-Proofpoint-ORIG-GUID: w4BwM9kTTxHYMQjzsq7CQYaX9qCI7hme
X-Proofpoint-GUID: w4BwM9kTTxHYMQjzsq7CQYaX9qCI7hme
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
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, philipp.reisner@linbit.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, haris.iqbal@ionos.com,
	ukrishn@linux.ibm.com, lars.ellenberg@linbit.com,
	drbd-dev@lists.linbit.com, jinpu.wang@ionos.com, mrochs@linux.ibm.com
Subject: Re: [dm-devel] remove REQ_OP_WRITE_SAME v2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Now that we are using REQ_OP_WRITE_ZEROES for all zeroing needs in the
> kernel there is very little use left for REQ_OP_WRITE_SAME.  We only
> have two callers left, and both just export optional protocol features
> to remote systems: DRBD and the target code.

No particular objections from me. I had a half-baked series to do the
same thing.

One thing I would like is to either pull this series through SCSI or do
the block pieces in a post merge branch because I'm about to post my
discard/zeroing rework and that's going to clash with your changes.

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C0FC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 18 Feb 2022 05:41:41 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-moklA7D7OmCZEnKj_WGu8w-1; Fri, 18 Feb 2022 00:41:34 -0500
X-MC-Unique: moklA7D7OmCZEnKj_WGu8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7054A1091DA1;
	Fri, 18 Feb 2022 05:41:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B18994EC8D;
	Fri, 18 Feb 2022 05:41:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 661831809CAA;
	Fri, 18 Feb 2022 05:41:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21I5fNcs003720 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Feb 2022 00:41:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 55D00145FBB3; Fri, 18 Feb 2022 05:41:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50532145FBAF
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:41:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3051E1C05ECE
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:41:23 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-53-kBZvPRvaOsWW4ry2QuXd_w-1; Fri, 18 Feb 2022 00:41:21 -0500
X-MC-Unique: kBZvPRvaOsWW4ry2QuXd_w-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21I3rMRj028289; Fri, 18 Feb 2022 04:28:05 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3e8ncb03hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Feb 2022 04:28:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21I4Gj5d139027;
	Fri, 18 Feb 2022 04:28:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by aserp3030.oracle.com with ESMTP id 3e9brd8xsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Feb 2022 04:28:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by CH2PR10MB3879.namprd10.prod.outlook.com (2603:10b6:610:f::20) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17;
	Fri, 18 Feb 2022 04:27:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c9f0:b3fb:25a6:3593]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.016;
	Fri, 18 Feb 2022 04:27:58 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r180iyu8.fsf@ca-mkp.ca.oracle.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<yq1wni3sz4k.fsf@ca-mkp.ca.oracle.com> <20220210055151.GA3491@lst.de>
	<2f3f1c98-e013-ee03-2ffb-3a14730b13b9@kernel.dk>
	<20220217064349.GA374@lst.de>
Date: Thu, 17 Feb 2022 23:27:56 -0500
In-Reply-To: <20220217064349.GA374@lst.de> (Christoph Hellwig's message of
	"Thu, 17 Feb 2022 07:43:49 +0100")
X-ClientProxiedBy: SN2PR01CA0080.prod.exchangelabs.com (2603:10b6:800::48) To
	PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d782960e-cdfc-4d21-9ddd-08d9f2970ac9
X-MS-TrafficTypeDiagnostic: CH2PR10MB3879:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3879DEF04E7D4E8CC678393D8E379@CH2PR10MB3879.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: FPb360cJclRtrtzrSH20bH0yjNjbW6PZyF6gcKu3FTHdqjkfsBOUT0WsL6sOod3TjoAQv/vfBRZB2zaxXpzllslkxHt7OuiD3y7w/42LEmhyiZTZavFurQO6S8D86RTPkJK5+QDve3lWpp3ZLdNQWZn/1C1pRru28S80CqqsAnNxGZrUhqHWCxRpsk4EGoHxtTt7PZP18X+2r8R79phicbZZ9eO8zZEsOOamnQv6izmIDJWtBpz32iuwQ2RphHzhRRBHwEJYDlPUgD4DtH6bydqyuM1x+obCfgSqME3B+/XzGc/uTpz6a8jfW5EXhSM8RBzg35TpXVwLA/Erug30s09fzESEtGPjWZfY4z1B/1OZiZvSapdI6b9r5WWqZGIACrcWogSufS9e5v7WLjRFtHN6F5iCc/sEK/lK49xa4Sz6+158PvDT6j/32jFgXDKQyc/rM9jxLGBgp0lXqdd3xGqftKLT1/cHxx6M9MlGrjPs1ogyUx0nYmvcL17fuUB00M1ZlWslHqwdLsDDSHzW8GBTEFGiqoEgSuphucyMnXl6nizazYOE+gbdRwrhVV1kGs2GMK3eJ5DMojqIix4uEwQ5KIgTd7KLmECCb7XzpalE2mN5N8t1sjBxaEwBG8jMEqGPDY+YjciefnTSHum/jTOKdFDsudgMMCVDxZnX9rQP4QxbYzvee3rB1/bK+fungE7NkGNe+NGXIoHrCyYL7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(508600001)(316002)(6486002)(6506007)(5660300002)(52116002)(7416002)(8936002)(4326008)(36916002)(66946007)(66476007)(66556008)(8676002)(7116003)(86362001)(83380400001)(4744005)(2906002)(6512007)(26005)(186003)(38100700002)(38350700002)(54906003)(6916009);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fL1D0e9PPiYkh9RieoTbPAP217SfYcNkj9wpkSdrzTyPEeBvyfAnbs26EYEs?=
	=?us-ascii?Q?FT0gcIZQvQZXTFHFh85Q4z3nTEgaurj9OfoA9erUdTIpIbVdFLUUWa8JF0GH?=
	=?us-ascii?Q?4AbGFk8b9X4lchbaUCLy23t5cXY6ejdht05gw8Zq0Ec/DkoYxoVlZdLWaGKg?=
	=?us-ascii?Q?7PwvVC1UH+CrWjF6D72WQjhPvVyQcTI0KhgsBcWITIDfa9Pxp/hwvGb2JKZK?=
	=?us-ascii?Q?ZyoySjEYoDXn+2Vb71zjr4mn5a3BvnLTEjCKa7c/OEYCKpGYPj+30Tse2Cdg?=
	=?us-ascii?Q?Cqz1MCh2NiNpe/JT8UF2qNS3hVkx9C59eDO7HSVNlFWy6rTGtl69FiCGmw4j?=
	=?us-ascii?Q?mOZ7zEdu/JT2vK2o4HF/KUBfz3Ot7xQvRcjgEa5JTxcVVT2FQYRnocAMJ2Hj?=
	=?us-ascii?Q?tzRMf/7mv1ztzQsIwv7DzGpfqu2bivry+2ywBp8Ww//HNchywTooOAEu0UeZ?=
	=?us-ascii?Q?Eyc/FWrXasmKWtbeEfpmpb6EwVX+N+AZ8/EJ5gWI+19h2yCkRQwzQPPdKsOd?=
	=?us-ascii?Q?mTYpd/cWce+DvUb6SdoiKjBddCrn15Ds/4VTDgBbaYajf8TUiAMArwjAX5Mb?=
	=?us-ascii?Q?1wL2TPeSZSXVVkGMdNKiC2QYke0aCY/LJ5op3KJKHK8tJLS97IlzM8UII7H5?=
	=?us-ascii?Q?Nyd6RnOHMtAjnBSQW6v/H6oBoRxRYM2eievojAVk6otVEB2wEWfUxEN1RICk?=
	=?us-ascii?Q?ApiZX/2yVfiapCpoG74yEg5u8NIUpYjrFlSQpvVYSutX0dWAReB1S31ZYBtq?=
	=?us-ascii?Q?GhmJwWYD1Lzm+6f6Kj85P+sjvMf/B7IMEP5u/dcx/A7/kwRYw6FYk8wBaGl6?=
	=?us-ascii?Q?91jM4m8AV3UuhKdFBc0RhUo5WM07iOMEnyXsZXjbJ2znYok7W+t7E6nYXVN1?=
	=?us-ascii?Q?kePEhmlFwX4D0ABOnTq0pE9/9NGN6m0zm6EXJ8NX1wlqm6ozmmgm4Hnqd1BN?=
	=?us-ascii?Q?gc/2iav6NsHcvVv5BUSwf5DtGVM/EMA/Sw4VMmDbHPhxjas1C8K4UC/p3mGw?=
	=?us-ascii?Q?vNAHGul2+loyT+0VN0r0QQA5z83iyf20bWJVrOXGe4htQ9Gdz4KOg98glumk?=
	=?us-ascii?Q?LXUji/aqPtvt9hcVn0QyN7nuZN71w+sz+kIwJCu0d1wv+YWi2g27z/A/8vtV?=
	=?us-ascii?Q?dRoMMqKxaIQqpWCyrFY285LlKo1JJzPOpCECBvYy3U/qVBeNVci/R/5nw5xr?=
	=?us-ascii?Q?KLh4xkLQPC7qHRen8WGsZ2ihxWtRK+VChq6P28oP8o2b08TF1CmZb26UIKB5?=
	=?us-ascii?Q?A/4R4hJ/AXYrEapwTC1Oa2OUH1N5y1HhVa5rHsz33xaLYmg/zFU+cwfK3JiB?=
	=?us-ascii?Q?r+uBVG5Bd9MIE86c/u4n/N3Fi+YwFyFjGoBQTHpDLuOm8Z56fKUqAq6tkZz0?=
	=?us-ascii?Q?NJeeDwfegkJFlkax47V2BSC2yis8tsEswst6DR9fT7TT0xc3bh38IhCkf/Ie?=
	=?us-ascii?Q?d4IBsR0f5lYWgRpTxz/XfbcYpZrsAa6z0bgHfGUJkbdvdH4T9FmJ//fg2ewt?=
	=?us-ascii?Q?n+0k0gA6+9rizztTnrcspvOvAH+Rp9BG7O2V7xsdwbSQ+Vv64yRkxIlRD44h?=
	=?us-ascii?Q?8+AHbcZy0BBqW4LJ1iDPpUh7m1ARs55lQujm/f8iuimsLsDW1CPeo3CMXvGN?=
	=?us-ascii?Q?OSpeHN4F/MLFUx/1C2QUWagLcbv4tMaby/HvyU7kpRpHNibMp97c0Ai+T2m8?=
	=?us-ascii?Q?ARqY9g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d782960e-cdfc-4d21-9ddd-08d9f2970ac9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 04:27:58.5854 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XMfvn8l7EWCZEBgzREk/AXEdWE5Sd8a236RDlFD09ouPnw1DGb7CVVAOiWzj16rKblLPd9aaSPhAs0gJn7Vo9ehrUalxARjWqcFgC/L7Fvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3879
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10261
	signatures=677564
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 phishscore=0
	suspectscore=0 mlxscore=0 mlxlogscore=735 malwarescore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202180023
X-Proofpoint-ORIG-GUID: PeGQWnfARAnOGHtT3uLaDL240LX1j5ow
X-Proofpoint-GUID: PeGQWnfARAnOGHtT3uLaDL240LX1j5ow
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, manoj@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	philipp.reisner@linbit.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	haris.iqbal@ionos.com, ukrishn@linux.ibm.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	jinpu.wang@ionos.com, mrochs@linux.ibm.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> There is a minor conflict because the __blkdev_issue_write_same
> function removed by this series is affected by the blk_next_bio calling
> convention change in the block tree, but the fixup is trivial.
>
> Martin: do you want to fix that up when applying, or do you want me
> to resend?  If you have your discard rework ready you can also send
> that now and I'll rebase on top of that.

I'll fix it up when applying. Will get this queued up tomorrow.

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


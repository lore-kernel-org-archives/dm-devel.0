Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2539DC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 02:58:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-uv2KuzuyOmGJQ1dVOqsjUg-1; Tue, 01 Mar 2022 21:58:27 -0500
X-MC-Unique: uv2KuzuyOmGJQ1dVOqsjUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E77C1091DA1;
	Wed,  2 Mar 2022 02:58:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96983100685E;
	Wed,  2 Mar 2022 02:58:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E9C511809C98;
	Wed,  2 Mar 2022 02:58:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2222wCW5017003 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 21:58:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 47D1840FF69A; Wed,  2 Mar 2022 02:58:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 422BC40FF694
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 02:58:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 240033804500
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 02:58:12 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-395-FiFWANd2Pv6P9hlk6a_vwQ-1; Tue, 01 Mar 2022 21:58:10 -0500
X-MC-Unique: FiFWANd2Pv6P9hlk6a_vwQ-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	2222mY8Y014686; Wed, 2 Mar 2022 02:58:00 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amgyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Mar 2022 02:57:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2222pZKW134903;
	Wed, 2 Mar 2022 02:57:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by userp3020.oracle.com with ESMTP id 3efdnp43qr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Mar 2022 02:57:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by SA2PR10MB4715.namprd10.prod.outlook.com (2603:10b6:806:fb::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22;
	Wed, 2 Mar 2022 02:57:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::180:b394:7d46:e1c0%8]) with mapi id 15.20.5038.014;
	Wed, 2 Mar 2022 02:57:55 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnhd12ox.fsf@ca-mkp.ca.oracle.com>
References: <20220301084552.880256-1-hch@lst.de>
	<20220301084552.880256-4-hch@lst.de>
Date: Tue, 01 Mar 2022 21:57:51 -0500
In-Reply-To: <20220301084552.880256-4-hch@lst.de> (Christoph Hellwig's message
	of "Tue, 1 Mar 2022 10:45:50 +0200")
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
	(2603:10b6:a03:1b8::28) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c26137fb-a0d9-437c-10d5-08d9fbf87331
X-MS-TrafficTypeDiagnostic: SA2PR10MB4715:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4715416A18396F5BAC1F0DD18E039@SA2PR10MB4715.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: MiIEf7LfKyvV6M0LKyC7xM+K3b5oYps9cVm41fFwWygELSGnFbqw8Cp4Llbfw0jIBwZopo6bpZFImRFZbq+33HSsvy88gXxU3TvWv8GlDVjjJnSxFrAhIVWla3X/hJYUhno6X6YLc9dR7bFvVmiQHNeTYyTmu6vJn6BU7uRfR+5bUCVT3wjT61m3IA0u7uChIr6H+ss6LJNTdRngTmMb3F8hgW5bJU0la4yJQBcyXwiGGrO4jf0YMAGTv2XqcROWqozTzYeKH5Fm5LQ6ZkTM3liymdxde/jwW+7vHcUGbUbZmJEmkJFhN4Y9R3KExvzdz7bpwdCFvQJ7E2SxdZCeCiz7fqqA3ZiPF/G+UnipTVNYPANWM43Iy5pft2Wu1bHJuehy2o5lNrXCIA/yRX1G1iLknK0SKK+QAFbrEVLwY6S0ugGsZkQWunoRpwFqStcQ8gF8kyW++2FTjcS2lwTlfbaCR9Vctx8QZmE94X5ORY4/WUA97hbRArammixUHCsYRVUYturkvekcNv9k0zsnZcax97T1xEhLp8vKsPxG2rFnSlzfJfifRZMfIYxgLZUxWUrmfl36Iuz/0YQgSY5NQeZN8gNiqItMRF17uVU1t57H+n7tu+HPJuYdecQXqlozIxOx0II1eyQRwrk0UA1k1CF9r27o4xtMOa+NLQWNwJH9Jd5S8zwcbHGiI52RkpGKIgF5VFeo43sUsgELHmLuzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(7416002)(66556008)(5660300002)(66476007)(8676002)(316002)(6916009)(66946007)(6666004)(6506007)(2906002)(6512007)(86362001)(54906003)(36916002)(52116002)(508600001)(6486002)(26005)(186003)(558084003)(4326008)(8936002)(38100700002)(38350700002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?875h7fhyQxrq4QED1uFBLMMDGKT1znnf6ly6RGjoTeW4XFTPP3sHjQGU0GzX?=
	=?us-ascii?Q?Fh/YpEqrkYmh1RQF7CdIPdXCgW232fIaRlcGgX8cbeDNnZEIs/xbMTUgr9Fl?=
	=?us-ascii?Q?1r4MXfFjMBG/L/DzfxO25Ff1ZNfh4UmG0Yxft8eI0Q8+mLeqrUxLnWT7mUp7?=
	=?us-ascii?Q?FPcMRy+e0JIRDl+nqZnxOFWaJOkjH1W71Mt6sdDt3JK3ATWATkx8mxyEPHbp?=
	=?us-ascii?Q?RSU5YH79xPTBVi0vnQCNqo7ToF96zTcfQBpmq+CX9F6Xa/O5XRaEnqa7V8A+?=
	=?us-ascii?Q?AVklpS/wk7wHBqSKWOPWfxkfzWHuayXDYJtZ+Q1rN54IRQgxIxNnj1J3Eifc?=
	=?us-ascii?Q?30H7aIKuv+IjRsgCqrk8PjWDdpG8hA5sBCR9Ps99JyvAsqHkBnHiXdt5UF6L?=
	=?us-ascii?Q?okrUA3LGNgfERjAQ43aL2KsvPwsxECfCppJJ8cZ0wdNKbEIfZ7ubv9L138st?=
	=?us-ascii?Q?Ba+g7k3bIcgzqTKNTb2bbM08olgNfmM0y4G/3+3lg+PlT0Gof/H1wZugHl5+?=
	=?us-ascii?Q?HXLApGsrZ3lFYw8s+xXrYQxUsiq+qLa0xTtJYzaPBosZU683gnJfLfba6fho?=
	=?us-ascii?Q?TFQH770GCWWxktlp8ppueWO+aea+vCjhxetpnnS5T3pJzzvMHbjkzqY09o8E?=
	=?us-ascii?Q?8dhH9RV0Wf6EfnLq4jkBcFaIHobPUQVJRWuMcKxtbC20lLaNdROY/PLP87mC?=
	=?us-ascii?Q?O7sau45BqHvfDCtKzm9JT2Og9NWMhujmbriTR1UzDY5JhAFgx9IsE1bOk6uO?=
	=?us-ascii?Q?zrPZDlSket039vIElDfmzW4TUpbSfneo/EDPP3lDw+mASoJFf0Bwyramwwad?=
	=?us-ascii?Q?6J1mYNXxA3ByV3J3IAhgTJH2SMx0U3M1McirQo6n6DVA3Fk/RSLBvPXJsTNl?=
	=?us-ascii?Q?LtPiwztAAXvm2+cNkMVH6Y7K+Bj+dgQODVagBSclrcMGhVgxmj6Y9uThe313?=
	=?us-ascii?Q?ZSvAoDImk5ENiKMK4IbK3nnkuKYJ8o/nnOUSDg8e5NoZ+kqQuHsRP0GojtBy?=
	=?us-ascii?Q?mjZf920aFIvkPBXWD3llTCMi9Bpk0x6Dk/M980CMMLjDjR48SV3vuxkZy6Rw?=
	=?us-ascii?Q?2TDIuamB3vdmHQ4Tbi0Zl2NiqZBF3ygyEAiFdO5JrIOi8AkYJ3xtFsyDBGDO?=
	=?us-ascii?Q?jrAS0aWwvfpXTUCr1hiA2EJzfwAZJtDj0H4BUmznJ6p4069AcPLky64uv/uI?=
	=?us-ascii?Q?sBnNGt5ByLd7yxfox05x1mzKB8UwMdqpP6G220pFlUOfBwshbhSizOTFip8N?=
	=?us-ascii?Q?MHtQOz7BwUQyKZ9Td6X4UTSVpsURm8kiLmhuubOQ39V2F1s7W++mKxMPpOMl?=
	=?us-ascii?Q?sxNRRV8TigxNiabpVKMzqkikeBcVIsENIHMjPTyriFwGQB5G5LGXZZOM+vK/?=
	=?us-ascii?Q?CW2/4RK7gq7E+JBb5qN37BEpGnuRIBSb9sfoZe/ZDviyrmn/FebjdOSl3j72?=
	=?us-ascii?Q?KZ2FuYwLQfMp7D9qBXY1h54aU/ajujEhHh3mdQgM45j4PFymbs2B+w26VTkr?=
	=?us-ascii?Q?bnzTX4fJC0AKPMVf7rAt29ibUcaDMwQh+J/H+3xoIOmCUD5XGqZJ3aqP7dwW?=
	=?us-ascii?Q?ot5Apwobi+R79pnwxsc4/IkadfsROFZO4YdBNQ89Hzlq8J0YKjGrDq5A+fEO?=
	=?us-ascii?Q?soTmnNSdWzDgZQlTJvDt7LJdjeGQjhYIPi6dUdH+xVI38mHjI9TTCysPo4B4?=
	=?us-ascii?Q?Uh6w4Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c26137fb-a0d9-437c-10d5-08d9fbf87331
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 02:57:55.3630 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUXJBOrh/Xs+6jY20VhfkPwTqrGXpkrTYce3D3j8AmV8JcY7dRzHXT87DOszRMNxA34lzcwJF0Bz4IgQo02CwzexeK83JE7hOnIZJraWSAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4715
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273
	signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	bulkscore=0
	adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2203020011
X-Proofpoint-ORIG-GUID: 8uz4cpshiBD04SVd12ec8rjv8t0GC1iY
X-Proofpoint-GUID: 8uz4cpshiBD04SVd12ec8rjv8t0GC1iY
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, Sterba <dsterba@suse.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-bcache@vger.kernel.org, David, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 3/5] target/pscsi: remove pscsi_get_bio
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Remove pscsi_get_bio and simplify the code flow in the only caller.

Looks good to me.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


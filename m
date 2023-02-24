Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA4CC7EE31
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481421;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6yrLfqLoci62rmRGIP7nXuS+nY27QnE4z4Go2YKE2Kc=;
	b=YnSzPTG8TDuBPtG4q+3l6hAHAH9yzbZpFYOY8QfRONmdgbkJYlCfjG1z1AEwo8shmmbKO5
	R2CyQBt00DmSFcayanYGWiwUXs/FFEUzkrYlStxrnf2VGpxwPDJqvNXlk2DPWwpPQ/JlzS
	Q/XOzXQpgLNGeFVTx/h+/WtFLW2isdk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-m1G2fa1IOmuuowlH7eTHjw-1; Mon, 27 Feb 2023 02:03:39 -0500
X-MC-Unique: m1G2fa1IOmuuowlH7eTHjw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82311C0432E;
	Mon, 27 Feb 2023 07:03:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5529492B10;
	Mon, 27 Feb 2023 07:03:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E5CCA19465A2;
	Mon, 27 Feb 2023 07:03:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D673519465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 18:50:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B696AC15BAD; Fri, 24 Feb 2023 18:50:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ADA79C15BA0
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 18:50:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E80885A5A3
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 18:50:26 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-gL3HqwMVMn6AJeLSfgAUGg-1; Fri, 24 Feb 2023 13:50:24 -0500
X-MC-Unique: gL3HqwMVMn6AJeLSfgAUGg-1
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHhpBQ003263; Fri, 24 Feb 2023 17:45:12 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpqcntj3-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:12 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OGRkS3000678; Fri, 24 Feb 2023 17:45:11 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3nxsb4ku0h-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:09 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:47 -0600
Message-Id: <20230224174502.321490-4-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:4:ad::44) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: f4105db5-56cc-4112-0e61-08db168edf7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: aFZkWf+n9cGnV4LYXZJ6WYVbEhsjX8sr3GGpbxzxg3ZsVF6CQh5ccEPRl0PEVkawf/TWYUTy8OE9ihpGbU4rPvPzM/8QA69b25rLMS/TU0IbISgn6pxkOvPQSQ+PDZDvrEkmdfYpNaGPYY6wlpXrW+h2ggQj2NRJQZAP9LR0jiyCCBFb8AasMZAXGMszeyIzDdgktEm4Ga1uqxFEfPPWakQaqCGgIzv75otOblyyTF63DcgT7IRtUsrdi+fY19szfkWG8QmgFvdgR5g1X1ga7IqvYDr9GumdKso9dfo1J6zeZYChruk6clGlWb+ETQ5fKiBMJRdDSUmthBWILJUe4eRhD9ZyjcIrwdAk6tnLjJk1KP/G976HQOdA1/PNyf3IJy2he6BPxTlO1P6c0mZLZhGbczUfQ66rwCzz+7iJCWSvHKLM/MzrQtWkUEJBLiouKS8INX7TTgbXJgH2LfDrGh0OKEYkLW1gmNd5QpRlNIsQggPVqXYJDXnab/NCrdnqwrhr/advBWA8ub2444oeBARdgFyZ/m+O6HY0ASB94ty2GEmCP6+sfRAJXICD0AGNyb0tq167YfC5iBupEhaEZ6z0FuZzCgPfC3MEkv6/KhFUP9LV+ET21LdMW2+RFy2+wQ+gEIYLC5kqsoriyLR0cUuMTpBpWLWhwdX/3rC7HPKkkvLXAB7wD1Oy8fa5fKv3
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(54906003)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Rmkz0DgGUsxhUIHb/q2IvViDBUaKpzUmR2aS93aot5KYa5QHNT4tDjlpzeE?=
 =?us-ascii?Q?VP63Urp4K0zVO92Cb3d2Mh9LwUv6bD6TP0jeAGRmAR4NeL74YGtBuC6C47Jc?=
 =?us-ascii?Q?RUWDPEVmeOqC2M21WS2heqNNzL8lw1Mch9qDwyrp1gqwkbeOvh51kR6rA2mY?=
 =?us-ascii?Q?LvJujgZJFb6q+g84hnBV9sWyRZBJ6pD5LBNDYUaLsaJfPbB2+fQsAICQpaS4?=
 =?us-ascii?Q?I6D9ZuMI1hjq+N4aW57Ccg1w+ObmJO8ssKfu6hcziBQacRYjrt0I6zigoNIO?=
 =?us-ascii?Q?9Ij6xBJzVnqUxIEU4POiyRdtFOi/xHxH3cKk1zhGsGM2+KwuKjtsuJILfCQo?=
 =?us-ascii?Q?JIP4fIDE1EP9G15Tf6qIut94rsIkyBGgVIupWs2EwZ7d4TeAvvyj4HnuMWkL?=
 =?us-ascii?Q?/AHtQpA/Rr4HBq/q4nqU75sMcFKn7mj7YLsgz2613QTEIYK13g4EOje6Wd4c?=
 =?us-ascii?Q?a7StJDAzZV4liNsoRmLaqP9AvfcoKpMRfq7Ko6vgjH0z7VaYq6wsqgjNEbh8?=
 =?us-ascii?Q?USz79cfjHG6Ehh9f6exsUkgb/h+xrjWCQOm4E/liBEBRFpDKgZHkJSrNtu3Z?=
 =?us-ascii?Q?fiqHSYEL/fh533zsQFbme2O9K6UkWeQVb7fYo7ZgdMOoIoedfFBR7xtzp09R?=
 =?us-ascii?Q?S2LSI87XzrgwrQVqv9NYbVIHAPFtpKt0Bo2EsSBePz+wojWI95lthStVVftS?=
 =?us-ascii?Q?j1b7OmDxlAljUBjNLTjx6SzCkbgWk1/Q1U8gc3VDDsUtxiE/r/hdqKw7nDpj?=
 =?us-ascii?Q?WxSzA6w7sxEiZGUfRI+7mLBwNqnWFJ2ZTZzFD5GTPoSRFXIW72xiXl8InJDk?=
 =?us-ascii?Q?pQsPpxAHyWkb9Mp7Vgw91LQErSWWOGahhFGEBh71WTVnSp9t8wNEg5KQJy58?=
 =?us-ascii?Q?sJdSDYl5Ec3VeLLmtu6l1mlqjhU/tCebN63OQHwFWOxGU+CeUYnfsZ/tbu2g?=
 =?us-ascii?Q?zNZgGKgOlqM4LGExyR80vvvb11/znymiA3eD41oL+JuuyvG5W7z8dQJE1Smg?=
 =?us-ascii?Q?HDQHGHHDmbyhtuy2as9qn0KcpO39FjbnaS/edOrniNHe+zNM+lRTTHsF27pP?=
 =?us-ascii?Q?akP+U9KGzyyKuXy+2RiJpQkQwrtPT3G3W9EEY8VWg5KZZ/5UIh8YKTzZxPpU?=
 =?us-ascii?Q?TL/b25aX6EduGsMHNFL8/yxGfVoF06gJCPuXSSv/a9bKnn04ZFrT9gvvwcyY?=
 =?us-ascii?Q?BIB3ZvhfyE3XM2woNEia9suXMnxZUhst4Ttwn6s88oyxMwG+/3MYfvZ08r48?=
 =?us-ascii?Q?Q4M7aGU4IZQJ+WCkeSk/G+SGIKYcnGQ8ch2etELjYrC42FkBYIXDMg4Dub7B?=
 =?us-ascii?Q?4f2qj19dib0A1UNMHHt67znnHOUma2vpCDCQZf67TPhciowQcOVFiSTuUYfc?=
 =?us-ascii?Q?QjRfuuqi228JvjRT1nX+vIk84p8Q4l5FCKvXuseMHx2x6TEEye2UpN9yPoS+?=
 =?us-ascii?Q?hsZRQ7TVImLgVb3bx9P+b2r1Z35BacT2A0L2vnd+AHBqL22j3bcG7ks7FdJm?=
 =?us-ascii?Q?0ePS+PuXhx0WhNrqXZfSJd4uluY08XOQDozs4vK2oT7G/+KafRHFGblTOk7L?=
 =?us-ascii?Q?4BG/BmCAPEkiP0EHOM0y9KH/8PU12rMz/H5NW0Uu9IZk63VfjXMjBjReQgyw?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?g40c9ch+povLCNrmvyzIwCpqLYqk1WmzYNS4oVfOcjYbgCSZ37/JyEwQOPpa?=
 =?us-ascii?Q?oKNGIq80C7DZL9N2j/64I4LbUXf2CC8yZ2so70++qa8snbSxdY1mzqzubVQK?=
 =?us-ascii?Q?hOYEVz9B5TzA2r5JNC282f0MFuH0ZmyEmMviwAMUMn1xiudl3OhBMr+XdrEC?=
 =?us-ascii?Q?PGH+1Vd9wngtTfWKjpk2qpjn9JKrtu0ml38LvYzU+e5JxkVqLTYqUIOKmLFp?=
 =?us-ascii?Q?zXHDYNhKATSCc4//AbPBye2cBJPj9jeOr2CgsumNGNKulbS3hct+Vod26Y+3?=
 =?us-ascii?Q?HbWBy1/ZdTJjMQbmN5l6QA6mqp8iut65/paiCG21wry2ADrGnAhapRX9AnK/?=
 =?us-ascii?Q?Hrb4NC+H9613RtvjMLf5IanyHL2NQ/H9Rs1j+EqTTlzFFKtyM0GK6EHH5Amz?=
 =?us-ascii?Q?zp3Z892c+AnVDzwEIXbvidtN+f5WV/RqOEQEHRFp1yKkenpBRM+xsgKoD+M4?=
 =?us-ascii?Q?e0b1cKsE6niccGPTXZpix7s3nVHPcpiPFxD1iyPhXPCOzGXJ1aeOEzLHjgaa?=
 =?us-ascii?Q?mkfKTlxtlS4VGbZfjb10RSwpkiKQzGGrzMKy9SY7xpTI2OuVHA/QUhxgcBDn?=
 =?us-ascii?Q?tNAEh60KHQk/I7x09ZOxbUr4Pz998wiG/eonll4D5+ZaPIsIeHB0B70iX55q?=
 =?us-ascii?Q?iUzpH22SlpaerlhrIpBmyQ1W8pelKBUFW98LUbdaO6gNE2Q4jtMt6SybffSj?=
 =?us-ascii?Q?BtKLM+g1ZQC0b8eQnVbHA3penCHLGGBaMtD2wm+fzsKciUE0sv7s5iI+r7V6?=
 =?us-ascii?Q?dPZcxPxRgwIJlvXqPjtIxlsnSTWYGHjCthKdhSbPPSfobUuuu7LuolJPa+4Q?=
 =?us-ascii?Q?Xj+eXyYJyzs/YHg1DkVo8FytqW0YWMeyVzICQcZscegFvb5dGep+KANBc/mI?=
 =?us-ascii?Q?HaMJWSlyHm56Ua1dG5Y4MZCRGq+X+JF29p6VfUFdMYJWe3ol0NHMiy+4JjQr?=
 =?us-ascii?Q?9QqqcGetdqMNKDIdnavhuHvzeEPPxFussgmmVYD1M1lCpeXlWBfmd63V7/1O?=
 =?us-ascii?Q?3hi7bmMZ8L0RqclO0Dxh7l2i7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4105db5-56cc-4112-0e61-08db168edf7b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:09.5014 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhVHLjizPpshIfTwv+AjazCgjmVh2A8KtqTbwvbB96w7PLXbzZEO0bpXvQcgv6b84uleGrk5f9VlFnVAm/LUlWHmPkZF0510cGvOMf6RWbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: GDke2XZ_n7qi13MLPRk7g-SoGrtj34nz
X-Proofpoint-ORIG-GUID: GDke2XZ_n7qi13MLPRk7g-SoGrtj34nz
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 03/18] scsi: Rename sd_pr_command
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
 Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Rename sd_pr_command to sd_pr_out_command to match a
sd_pr_in_command helper added in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/scsi/sd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a38c71511bc9..79377173f6a3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1743,7 +1743,7 @@ static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 	}
 }
 
-static int sd_pr_command(struct block_device *bdev, u8 sa,
+static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
@@ -1786,7 +1786,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
+	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
 			(1 << 0) /* APTPL */);
 }
@@ -1796,24 +1796,24 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
-	return sd_pr_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
+	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
 			     sd_pr_type(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
 {
-	return sd_pr_command(bdev, 0x03, key, 0, 0, 0);
+	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
 }
 
 static const struct pr_ops sd_pr_ops = {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


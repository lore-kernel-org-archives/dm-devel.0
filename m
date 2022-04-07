Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F797C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:27:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-oYHfMGmAOFe3H966EC7f9w-1; Wed, 06 Apr 2022 23:26:58 -0400
X-MC-Unique: oYHfMGmAOFe3H966EC7f9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E33D018A6582;
	Thu,  7 Apr 2022 03:26:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 83F297C4E;
	Thu,  7 Apr 2022 03:26:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD299194034E;
	Thu,  7 Apr 2022 03:26:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6F2A1194034B
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 03:26:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 397EF145BEE6; Thu,  7 Apr 2022 03:26:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 34954145BEE0
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:26:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5ACF899EC2
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 03:26:37 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-779jK6iqP86hL33ubtDzPw-1; Wed, 06 Apr 2022 23:26:36 -0400
X-MC-Unique: 779jK6iqP86hL33ubtDzPw-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2371bB8b014737; 
 Thu, 7 Apr 2022 03:21:10 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9td09-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:21:10 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2373FMdG015367; Thu, 7 Apr 2022 03:21:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f97uwanbv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Apr 2022 03:21:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 03:21:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 03:21:05 +0000
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ynlinou.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-19-hch@lst.de>
Date: Wed, 06 Apr 2022 23:21:03 -0400
In-Reply-To: <20220406060516.409838-19-hch@lst.de> (Christoph Hellwig via
 Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:07 +0200")
X-ClientProxiedBy: DM6PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:5:40::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a4e7c4e-e224-43c0-eb44-08da1845a688
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4748213FE9D4050DE86175748EE69@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: DjOT9NXGZpB3sgRJJcgUJ/BSS9uBxOPNforpn8fJk807ksHl/anICaf3eJNywVGAdFiXwLjSdw1DYG5Kz6W8IVurfBB826TDEBIuwKWEQO1yXm3j/X0bihSfBBWL3FAXy1rgQbCrj/j8BRUBc2IAiQRVDVgEgp5uIXfqlsnl8OnwVyFuX6Ce+3tIsYhMLuFGwCPMixdP5EXrMrMpBVxcgkpnoz6HWNy7sRAD76bXi+6Cfuc/1EL4HCod2AKGSwg6rorZ7Julw1sfS0RP0v+PkcruyX0eIPRv5ZX6yFxLwQFyJcFKjTGgufq7B8CRu6gtRuIW61oRS7e1w2XNGBDy6bay6KjJ0CAEy0jWVtNxNzj5YGwhcPz/NLSqO1i9AvmvPWYSOyzCCpJ4OxYoFV9sNlC0f8jbWNTFOtFiPBPNCCfDp4S5X+5LdKOAw9+OK402XXtGcyrbEdrOk1vVEP029PkhHS3dBEwk8sGA9lHUfqumq3fUhKyR8dsnA6rA6c0V5MEPTfIpR9mwxMXaUCZQuGbicHzLEQ3Bj3WLSdrBbG5in42MzL99flygFqM5ItkI0iRjcZ/B/Ydd48RM8/xO0SFYNvmQCgFku5XfQUJG658fY6LUwwh3QTvkLM9GvBnSrfn8VzdXPWQDzR/Hm1Gh0fQoJ5czdXWlVZS9wGgQnzFxmYxHtAn6xAowBwd+dXqxbzO52pCHdIYpQPgVcuqRxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6486002)(38100700002)(38350700002)(508600001)(7416002)(8936002)(5660300002)(2906002)(6862004)(66556008)(4326008)(316002)(86362001)(54906003)(36916002)(52116002)(26005)(6512007)(558084003)(66946007)(66476007)(186003)(8676002)(6506007);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ed8KfOdD8BWFvOLjceSlZe9U6fC/CRjmtYJvhqHgLWj1Qzi2JWDev8VVm9Dk?=
 =?us-ascii?Q?fX4TT0IjkA47nbTC07tXTBoxj92TWjmke60BtNzznvjMqlzj4H0pRESnGFcL?=
 =?us-ascii?Q?ReP/cud4XoGiGhylfNKhKoRB4LQtYFul/e6gUJWBysLbO6zg+csEizV3X7j2?=
 =?us-ascii?Q?oN0D7agXA8mJTmZAMmxOvXkSKlH28yrdPaabPn/A9jCli/xoJPTc5M83J5yL?=
 =?us-ascii?Q?mhuB3V3ss++8NtvwHmQRgz8iXR3WLcsKi/fwhrXCx7R+iJZVz1VFwlBYzLno?=
 =?us-ascii?Q?PInan0qNsvg36QXhREZUayPq3icDLQu64IsHfizxMnTw225ULdhnc6Q97J2B?=
 =?us-ascii?Q?EYwbByEAg0d1Qi79SEj3197IQ2tKdU0lUpFlcba/HBog9knHqqB07/cC97kG?=
 =?us-ascii?Q?dHhfNW6Ms6oyqxkWr7TfJQenmjw+Odu363ITfRXkoWiRYprtPuZg8wYAzT3q?=
 =?us-ascii?Q?HTGFQ58gjjJ1ivuGAy9jTqLkXBUzpcQAbmElQubR0D6w2b7kZ0ipHshvaVP1?=
 =?us-ascii?Q?ctT7airiTwDLFFvUy62g0ZL1n7hYzrpkuYDy6OfwIgB0HGXaKSgYuINLofY5?=
 =?us-ascii?Q?7S2CGX2SpLCKBgyRk9WgwX3r2Yek+oSjJW4wOzebtRbMV1I+pn3UmMxqH+qr?=
 =?us-ascii?Q?iyLQMiGUdTqQ+Rd5rUVB/8hgj4c6XViDbVrQVEgZbWEevHTQDtP1Qeoiy//F?=
 =?us-ascii?Q?F/UWf3TxqwkBReCMiGZAbwHpFUbUTGaqsOAc4OZX0bQ9wIifakpeVVhTT7LF?=
 =?us-ascii?Q?ZvkuPlVlYf/NCgqtlRLkufmvvSMkGWGm12JIg53lxJAOFdbnJ/8uhw4zbkac?=
 =?us-ascii?Q?IbfOAZhlWgiOgetIcC0Jz8uFX5eR0s5PpFze/u7+HIpw+PMI3JrdYz1NJXLJ?=
 =?us-ascii?Q?GG1Ydpf8waNPelCyu0bMpPn4KZIMuSfsapXcqs7iqu6pSAewuX41dFhHwmas?=
 =?us-ascii?Q?1qQ+2PYBc8N1tzw4lIxpIyANFL7TaSOgeYdEF7PrYGXHtMm0CawpZx1XZ1iy?=
 =?us-ascii?Q?/bBX4QgtT9+95VDqUTVF6tmjSyOH/CoELITwNKqCsqnIQZvVnGqm4/SjXfCN?=
 =?us-ascii?Q?PEEGMSnK8zFC9gdobEWDNhr7xKuVgxNSQ5HIJu+76gIuWJmZCM+T7jshrjJr?=
 =?us-ascii?Q?ZTsUsUrxNWnbWIKsmAelPeT9s6IKhO1dl4gEyJ5fGARnTT/qXpUlDFdMfv8E?=
 =?us-ascii?Q?fyQ+d5VfTTO3hlTM0fmibyZ/L6JWK3ggzJWI+xyHDlwE2TGt31vwKH0DLvtw?=
 =?us-ascii?Q?9/tqablQh1kZcndJni4723IEzlLjlPi7o8l/onyEwVxfAxzqjXj0+jr6WpbH?=
 =?us-ascii?Q?UHIth0EHdnXF6ueUg/1hQPkZq3Ldrla7fNQN05q1o/LkSoWpAc9N6o5xcASa?=
 =?us-ascii?Q?hTad7oYreU4T/WCuQIliJMeVcdESB3ai0n0SmUaAxGJPNok3MyqpqJGMDnTh?=
 =?us-ascii?Q?zKozK9ZeWq11HstdRq3OXexs+utwnwRBMb0V6U6DWaZR6mwek1QbrOR1you3?=
 =?us-ascii?Q?oRzKFW7hCCPHAO9KoWPU99SnlC0QRwmXDFZn2LfwO1W+IyQp2yf7jJHy4cC+?=
 =?us-ascii?Q?bnKE6ST8ltzVlbhHG6qjzMyRwCtLyrBqBYwskMFBos44TunRCxGJC1xaEVzy?=
 =?us-ascii?Q?reUZI3VZbBZD6WSgZT8nLvh6FCg0lJGvMLC7SHuHGvTez2xLxtaOtjfl4mlm?=
 =?us-ascii?Q?kmB7kkZSAQlIm6N+Oes/xh1eXWWDzhTUhcg0KiT38d53sryoHA8zvWpgSxco?=
 =?us-ascii?Q?Azb9HyFJxo9vqWlUYpWy4CXVjw40yxE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4e7c4e-e224-43c0-eb44-08da1845a688
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:21:05.3709 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/WlI7i40n4VOjlex5MfakSjplwXRvhr2/q9rsNGMZXOqMWjhXVBrAKp8zt1ZMqkDxKK+4gPVb28EAbtiZ++8LZxftn48EIY41evxMiUqNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_13:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070017
X-Proofpoint-GUID: 5fk5of0wXRiyNRb822P8bYa2EqANeN03
X-Proofpoint-ORIG-GUID: 5fk5of0wXRiyNRb822P8bYa2EqANeN03
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [Ocfs2-devel] [PATCH 18/27] block: move
 bdev_alignment_offset and queue_limit_alignment_offset out of line
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

> No need to inline these fairly larger helpers.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


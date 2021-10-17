Return-Path: <SRS0=LZZ/=PF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F016C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 17 Oct 2021 05:36:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5EA6E610E8
	for <dm-devel@archiver.kernel.org>; Sun, 17 Oct 2021 05:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5EA6E610E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-EDX9UNSyM9-FOfgvUq551Q-1; Sun, 17 Oct 2021 01:36:08 -0400
X-MC-Unique: EDX9UNSyM9-FOfgvUq551Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C257106B804;
	Sun, 17 Oct 2021 05:36:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EBFF6FEED;
	Sun, 17 Oct 2021 05:36:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC5CA1800B9E;
	Sun, 17 Oct 2021 05:35:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19H5ZsQp007324 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 17 Oct 2021 01:35:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 97DD2D7B08; Sun, 17 Oct 2021 05:35:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91A9CD7B12
	for <dm-devel@redhat.com>; Sun, 17 Oct 2021 05:35:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9346858287
	for <dm-devel@redhat.com>; Sun, 17 Oct 2021 05:35:51 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-289-684LVxUMPnSgtGA7DiAgtA-1; Sun, 17 Oct 2021 01:35:49 -0400
X-MC-Unique: 684LVxUMPnSgtGA7DiAgtA-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19GNRbBI014069; Sun, 17 Oct 2021 02:53:53 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bqqmasrmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 17 Oct 2021 02:53:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2pNdu067524;
	Sun, 17 Oct 2021 02:53:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
	by userp3030.oracle.com with ESMTP id 3bqkuts2mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 17 Oct 2021 02:53:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16;
	Sun, 17 Oct 2021 02:53:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::a457:48f2:991f:c349]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018;
	Sun, 17 Oct 2021 02:53:49 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ytwfjkp.fsf@ca-mkp.ca.oracle.com>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
	<20211015233028.2167651-3-mcgrof@kernel.org>
Date: Sat, 16 Oct 2021 22:53:47 -0400
In-Reply-To: <20211015233028.2167651-3-mcgrof@kernel.org> (Luis Chamberlain's
	message of "Fri, 15 Oct 2021 16:30:21 -0700")
X-ClientProxiedBy: BL0PR1501CA0010.namprd15.prod.outlook.com
	(2603:10b6:207:17::23) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by
	BL0PR1501CA0010.namprd15.prod.outlook.com
	(2603:10b6:207:17::23) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4608.14 via Frontend Transport;
	Sun, 17 Oct 2021 02:53:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0bfa92a-e7e4-442d-5367-08d99119585e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5530FB6FDCAAC407630802F68EBB9@PH0PR10MB5530.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: QsfLZfZig6woBatdGRDkFbq31aXp+FtDjZ22KG0u/EGf74TEgLQMnQ8fwVXMIG53SEp7ETZvSuwAj6Y4z3UE4fEsqieMYJWnstNbAxA7sJs/hJyanmu2jHI7wOeQ5Z4QVV8sqpVUIWhGm7+rcTgmYsryKHc1VR/Q0yEhCaV8k8ywh5tcEcHZKcDWl3LB7No4mjLxVD2n8KiPwxmL8vpZXBepFfZcwtMR1jKx+2ql+62ayBGG62x64ygXgkJKrqifRtc2JZvejCkd1tO9Xih6+zjqsKRxbXhm1Vqdb6oyvlggYv2vfidCn2AoDTdSn1zDMU4Ubi613ZwVREwNR9XmPIZbxWnZ2SyZsXBSitz7lmucZ1x+tXBSabs/feg4pZfrPTG74C958OqjGGgZ31E60WtUy9uYQealKXFf4kHyDKhf0hGpTFErkptPw9qu+xDKFjRpmSuQ+K87C1u5Cd2lQTn29vOHF0m2s+QdfCQKeZf0M7dJj18L18A2uNRj8WCh+hlJuP/wa+OQw4zGN4EGH5WJTE0zvrQBvhd6VmKDIQigpBiIT8yPDGR4Pt8xqsJSgkxJsMrBpNd/8fp63mKlLeAFVkd/BMJ8On9AnU+oHdx5/0Vs8AqA+lCS3YEGrn8q0y7dEb1bs2bkJFSzvs0E0/BkK2rPqHvqLIHvYS8yfV7ROdD7MazUWzSjcluYA/eMcUVBJ67D6pP7zQvPF6u15g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(86362001)(4326008)(7416002)(2906002)(7406005)(8936002)(186003)(55016002)(508600001)(8676002)(38100700002)(66946007)(4744005)(26005)(7696005)(956004)(38350700002)(36916002)(6916009)(66556008)(66476007)(5660300002)(316002)(52116002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?clQft+DB/cQ8EVhShXnj7YVUmpucmfWZRpuSu8mJ//Ky+BYesLu9ourropjG?=
	=?us-ascii?Q?RxSIHIpSCvwFSWxxIxfc/qr/8l5g0udTacPwjX+VpzIsf1R8WzQ7eBycW+ej?=
	=?us-ascii?Q?cCOPkh7KuMmBeAQLiSYysQd9gihuqhcNT2Oe2d6sTeYvCFtfeyRn9IUM4XCZ?=
	=?us-ascii?Q?gVzcpsSjY/8wpIamEkl/mXP6wt7nuNUXysbb7/GgzYUjHy0NxuauQW7HkM3y?=
	=?us-ascii?Q?GOS0/XZDZxIIrFtegT3sw2J2B8IMcKN1VgW7QbZrS6qpviFiYjyTEkUSOy0R?=
	=?us-ascii?Q?lHvHxqhFUztNFXdc287j4G+KNAj2hYgT6snPDdvGiShk32Rmbt6r71l0l8Yw?=
	=?us-ascii?Q?4HeLrfdg3748lAW+Lfyz+tGEwLpzP4VWivFDzL22/EuQ7OPi+RnBVp8Hpp4f?=
	=?us-ascii?Q?WtQj2tHyaNmU7Yo+naiUAZ6+rhmpASstZPO+W92RoddrOJliHnH8Q8rBWfrD?=
	=?us-ascii?Q?i4JJ42ridVUEETgrBjFQEb5A4QhNBT61sDrH6TXuMCUfb7OUTwUwwtURIBwt?=
	=?us-ascii?Q?sBOgY9MBo74eHnw3uthYfw3pGleEnVtR4thv+dSt0vlAESnTXeU1nGaAe51b?=
	=?us-ascii?Q?Y3b71DyF54UhxaDSAnNlTuA4HBvZQeJ9/IS2zTTGO7g4JFoJCXHEUM/9NV2m?=
	=?us-ascii?Q?JBcO2nnO3X/3Ie6jOleivATjdVjFJ8isZSnMfJzAP9GQt7bMCVFGCUSe/w4e?=
	=?us-ascii?Q?oEcRBAzVdqoxXGNy81LJ2MexpvsD1LLUkW1ezkTmorpD1Ubb/DlosXUkzvJQ?=
	=?us-ascii?Q?3SGIoBCxnVYxLdOu99LLoQKFUThfOBW5xc0ja5j/Jxrssb3FEa4vijSDE6Or?=
	=?us-ascii?Q?V5El65zm0gDXc+IF551YGzb+GMUfvJ4SHmbmOr4Wp00r+7tJPPy87Hy3Srjo?=
	=?us-ascii?Q?jwey5MAJvORBenuyMcbWgYN+ETyxmya/2m9HH6h4C2JQ5fLTpnvs18Wp74UY?=
	=?us-ascii?Q?exTtgHVuZ6Ardxmh7GyoBwilEUbu0z/Ud/J8Z/oM6JDbu83O5S5DSN78eiY4?=
	=?us-ascii?Q?jEUjOcUyf4YjaLNVugBSgZndjcnoiALFYEdGRD4QQmuTjib4yi/4Jy2cvjKl?=
	=?us-ascii?Q?7fZKcDRAtlPWZoeElS9XIBwKdQaZ0UIxs+XRqi14oJFZbM5Q5VaxaHwQSL8f?=
	=?us-ascii?Q?NNA+W1GC0Sef5Fn3G5Jd8lgHUgv22kRr5Abfwhlydx8LJ1fPzec9KaVQEcr1?=
	=?us-ascii?Q?GySCSiZ2G6B63xA+TVtsxIHt0YZEjmzwXoIrEfxnnaG2AAJC+0OUqzaM7eDA?=
	=?us-ascii?Q?Yopqf1ewabImciPqNvkFp6BoUNAo7BUZoFtgVoSJkJogbFQnudNDRPlgR5oZ?=
	=?us-ascii?Q?c9rWQY6EpSoBz7Nq+6CXH8Wm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bfa92a-e7e4-442d-5367-08d99119585e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:53:49.3676 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5OBFaaQD8apEfWdamOSQEWEVDWX+cI9u7UMWTM7JNXOFtbhYrtY0Q8jykOxQvswZFmGFguQdsrLejGQCVSIYWH//GHD/ncfle+IdRZ2dLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	suspectscore=0
	malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110170019
X-Proofpoint-ORIG-GUID: I9vDwYIJ4XUL_ytw0gWdScYgWipqJs0n
X-Proofpoint-GUID: I9vDwYIJ4XUL_ytw0gWdScYgWipqJs0n
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: ulf.hansson@linaro.org, vigneshr@ti.com, snitzer@redhat.com,
	linux-m68k@vger.kernel.org, dm-devel@redhat.com,
	haris.iqbal@ionos.com, miquel.raynal@bootlin.com,
	krisman@collabora.com, Christoph Hellwig <hch@lst.de>,
	agk@redhat.com, anton.ivanov@cambridgegreys.com,
	sstabellini@kernel.org, linux-scsi@vger.kernel.org,
	richard@nod.at, kent.overstreet@gmail.com, geert@linux-m68k.org,
	xen-devel@lists.xenproject.org, jinpu.wang@ionos.com,
	jdike@addtoit.com, jgross@suse.com, johannes.berg@intel.com,
	jejb@linux.ibm.com, linux-um@lists.infradead.org, colyli@suse.de,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	boris.ostrovsky@oracle.com, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
	thehajime@gmail.com, tj@kernel.org,
	linux-mtd@lists.infradead.org, chris.obbard@collabora.com,
	zhuyifei1999@gmail.com, roger.pau@citrix.com
Subject: Re: [dm-devel] [PATCH 2/9] scsi/sr: add error handling support for
	add_disk()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Luis,

> We never checked for errors on add_disk() as this function returned
> void. Now that this is fixed, use the shiny new error handling.
>
> Just put the cdrom kref and have the unwinding be done by
> sr_kref_release().

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


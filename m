Return-Path: <SRS0=l1SC=M5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE88AC4338F
	for <dm-devel@archiver.kernel.org>; Fri,  6 Aug 2021 02:52:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 171C3611B0
	for <dm-devel@archiver.kernel.org>; Fri,  6 Aug 2021 02:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 171C3611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-ObskLDpbNfKWEqEOf-Z0Aw-1; Thu, 05 Aug 2021 22:52:55 -0400
X-MC-Unique: ObskLDpbNfKWEqEOf-Z0Aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E347DA0C00;
	Fri,  6 Aug 2021 02:52:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D0E26091B;
	Fri,  6 Aug 2021 02:52:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 903A04BB7C;
	Fri,  6 Aug 2021 02:52:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1762qkq2030135 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 22:52:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3FA0320BB913; Fri,  6 Aug 2021 02:52:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3914F20BB917
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 02:52:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CECD89C7DC
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 02:52:41 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-589-q6qRV4d3PgCtRIHUxdEUYQ-1; Thu, 05 Aug 2021 22:52:37 -0400
X-MC-Unique: q6qRV4d3PgCtRIHUxdEUYQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1762bApn026555; Fri, 6 Aug 2021 02:38:19 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7hxpnj7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 02:38:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1762ZfOX163593; Fri, 6 Aug 2021 02:38:17 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
	by userp3030.oracle.com with ESMTP id 3a4un4x32e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 02:38:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB5547.namprd10.prod.outlook.com (2603:10b6:510:da::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16;
	Fri, 6 Aug 2021 02:38:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::153e:22d1:d177:d4f1]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026;
	Fri, 6 Aug 2021 02:38:15 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuk3guwk.fsf@ca-mkp.ca.oracle.com>
References: <20210804095634.460779-1-hch@lst.de>
	<20210804095634.460779-2-hch@lst.de>
Date: Thu, 05 Aug 2021 22:38:11 -0400
In-Reply-To: <20210804095634.460779-2-hch@lst.de> (Christoph Hellwig's message
	of "Wed, 4 Aug 2021 11:56:20 +0200")
X-ClientProxiedBy: SA9P223CA0025.NAMP223.PROD.OUTLOOK.COM
	(2603:10b6:806:26::30) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by
	SA9P223CA0025.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16
	via Frontend Transport; Fri, 6 Aug 2021 02:38:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37bc1a19-ab81-480a-98f8-08d958833dd1
X-MS-TrafficTypeDiagnostic: PH0PR10MB5547:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB554779D0BA37A158A6A51D278EF39@PH0PR10MB5547.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: vEip2dgbKdqZ4Asg58kgknokPP0VL7s2MhAl/RcCcR3taRwndoxL7E712HIVgx9LdTrlNqQ0diDJszAe4rBXJk0aVwB4arw0ONCn5cC8IUL9sSK3UMCgZLnKV7lpO89eSju6eWWfvlJQEqK1lub3+ocK+KhN7n1FeZLZEUr/Jcml06d2lfKNyRuYie2qXchAtGxkZhaM3Oi14SiJEFPvo4x7wzO9tSPy2JWJ4buZKJzVDWs6k/UtiK4ZbNorEjE4noZAOk1OMRLJ+zfjo5YDXN3poq5pvQxuatHatDIDUCjIuU/B8F8712qa5z4b/W1TCyX8HP6DitEZqK4xOVUJPlbPduP4hcCTaQLOYSrt1f896Rj5NeitTldF/8Vf0KpemAdcgbbJc+zuiUHMkDpuVNPH0p1jqnVCy700lBRvG/zenHMOo8Y/ib7OAH18tWE+uzrMnDed1DQBDeOGAzCG6YtX5QQnCW6W2OLjQUjC+hagRWtuXZRIP2MCQf4IVU/O3a8AL6Eir5IPQ2n6tFbukGHagq3zIcXBS6AB9VAqCR3I9QG9gPILlANRxk6n72qdZlWr9fSHZ4u1CzIRT8N/5MfBcmQLhLXu9PfqFcxjgd4zqPPCkm9/ksZ9hBvEBaL4Fi9mamrnqQMjFrgduQP02LqQp0myyr5mWsUAHmHnJAk0ta8XMlLNoatxGvdoGcFhCZ1Zj3PBZrCUAwyyfV3Eeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(186003)(55016002)(8936002)(2906002)(8676002)(7696005)(52116002)(36916002)(38350700002)(38100700002)(6916009)(478600001)(956004)(54906003)(66946007)(66556008)(5660300002)(6666004)(558084003)(316002)(26005)(7416002)(4326008)(66476007)(86362001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HwqZ6hDDLzRzX+a0nli8YIlaVQoXWqp5xHzf2aqWrJ3KUDo/c3Z+0fVLgg7q?=
	=?us-ascii?Q?7vHOTmdJPFqcfAu2fpD5jg51HVvw9a2CQOE4HPRPrzJqt9wFVr2Q7AfOON03?=
	=?us-ascii?Q?YjK8VkpbCU3nrWFAxYqJMeeczHdsl95+tbc6lUjSfzJLsrRgqJ6S79QciLgN?=
	=?us-ascii?Q?OKmg6/3qGpwmh3po3B3GPmKHSZkdTri7jadDwiOIZW8W2AKxx5bT1PbVJg9T?=
	=?us-ascii?Q?CRXExyff6w4rG4/Q8s3aDOCD3yPqZZ/pHPwSA5BENGHOcAPCR8AaLtwVKZOM?=
	=?us-ascii?Q?0HieGiehG3YEC8QboF86m+C6W3zMCK4zw7tUnsWAZVD6COzDyDQ8GPMU2rmu?=
	=?us-ascii?Q?+4dCsq6TY85PRALRHUy0G4pq3f0+6+KK+Gf8AgbYBLGj2jedtz3yTrJ17V4K?=
	=?us-ascii?Q?+xIyoun+VMyc8DU2RN7AE68VhGJIXo6a1Mc/qCCrKBYKNX37EO4kIziP11TJ?=
	=?us-ascii?Q?K7YosFfZMrIrMeEgRsW6AH1+vVoAd71uZ4GLxjT15quVWtU+Dy8zXjlmlf5E?=
	=?us-ascii?Q?+UUs6BwDodJIUdHzgLnxhwZAzfuQLc7VlmxVHz560DEgHMMsl18ES9YbmEHm?=
	=?us-ascii?Q?uMBPFez7qUHTpb8vVktdVE8eIEMDD7fJoVamg6W7nZYu2WnD0nTKEgskawiP?=
	=?us-ascii?Q?44VtjlUdvSRJxI0xkALX3mcwT7VNqoU9jH+sVI53gCNABV9G35ncG5JRGHYk?=
	=?us-ascii?Q?LePs+GQjGe3Y0EgbXR74UEP+YbwvRr8qDg6luS7kmAhCWX9wTK+q0O9JFl8P?=
	=?us-ascii?Q?g/bG5T6HvWy3Aw5YfS7R5bv2SgZkH75vYPxPJGEDxE/7QQeL9RkLuU+IZZKu?=
	=?us-ascii?Q?Z3eGJcTwzmcg/ESN7zKy92HK7TMl2ywgAHPgo5QPEz0Xo9LAAxqlr8I8Kj/O?=
	=?us-ascii?Q?EAZ1Y75kVbZKBSzurNCd1+dAsguu3XljvDtv5fsX0pEIMG0TRidcagMxozhr?=
	=?us-ascii?Q?3LunAsi5D8FM90Zmi/v/WG0sY+vtR1d0ytcFSRUXW2JzgWjhdoFlMVi7Njak?=
	=?us-ascii?Q?jEt5/8Dh1kcTdKsnklc5hjUx+kVQVLPNw7DayUcGCrHsH9CGGiCYBrZcAJeS?=
	=?us-ascii?Q?3yMTOPfEI4+yStNsR0FzMDKggjC9DbLWxPpF8JF4kk25L6J9c/g5Hnu3PPCh?=
	=?us-ascii?Q?P66okeQP5QxJJAam1nuti5Gi8YgGf/w+uj9BU2/2tLhzpAdTwe76fr/Bav5T?=
	=?us-ascii?Q?OLRaUkPqAigRs0g93Hyc1laafVT+gxEOTSamnJIYBBe7Uqs8sO0ImoK9GqYA?=
	=?us-ascii?Q?2UWltULOiOy71dumNVEd29A/nPXVs55U7EVadKMVwxx0V70I8iV2AK5cVE5r?=
	=?us-ascii?Q?8mcQOfVqXytTFulDz3EDUjnj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bc1a19-ab81-480a-98f8-08d958833dd1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 02:38:15.1817 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOpJtuq92ls4/s19y3U0YyIwZnm7Sz8XctOTqylByalLubpc2b21MWjny/0ph5WA1NsDPw4JOHzXCamm5VUf2qTmj7M7hjw9NY8Excl2LRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5547
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 malwarescore=0
	suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060013
X-Proofpoint-GUID: wK_tIywM9icsTQkrrZ80TX8d8LC0f_PT
X-Proofpoint-ORIG-GUID: wK_tIywM9icsTQkrrZ80TX8d8LC0f_PT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Ilya Dryomov <idryomov@gmail.com>, linux-um@lists.infradead.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, ceph-devel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Geoff Levand <geoff@infradead.org>,
	Phillip Lougher <phillip@squashfs.org.uk>
Subject: Re: [dm-devel] [PATCH 01/15] bvec: add a bvec_virt helper
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


Christoph,

> Add a helper to get the virtual address for a bvec.  This avoids that
> all callers need to know about the page + offset representation.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


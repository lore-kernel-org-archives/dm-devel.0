Return-Path: <SRS0=l1SC=M5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE299C4338F
	for <dm-devel@archiver.kernel.org>; Fri,  6 Aug 2021 02:44:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2FD93611B0
	for <dm-devel@archiver.kernel.org>; Fri,  6 Aug 2021 02:44:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2FD93611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-R1ER-D0cPIyEeq_M9qIAeA-1; Thu, 05 Aug 2021 22:44:18 -0400
X-MC-Unique: R1ER-D0cPIyEeq_M9qIAeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB60310060DC;
	Fri,  6 Aug 2021 02:44:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A7D45C1B4;
	Fri,  6 Aug 2021 02:44:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 770204BB7C;
	Fri,  6 Aug 2021 02:44:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1762heJD029546 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 22:43:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 60FFA115DE6; Fri,  6 Aug 2021 02:43:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AAFF11670F
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 02:43:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC79A96B053
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 02:43:36 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-111-fWdwkIqIOmWBDP7ppxyi8Q-1; Thu, 05 Aug 2021 22:43:30 -0400
X-MC-Unique: fWdwkIqIOmWBDP7ppxyi8Q-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1762gR5U022355; Fri, 6 Aug 2021 02:43:15 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a843pavj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 02:43:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1762a72e059738; Fri, 6 Aug 2021 02:43:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by aserp3020.oracle.com with ESMTP id 3a7r4atwy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 02:43:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15;
	Fri, 6 Aug 2021 02:43:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::153e:22d1:d177:d4f1]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026;
	Fri, 6 Aug 2021 02:43:10 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im0jguup.fsf@ca-mkp.ca.oracle.com>
References: <20210804095634.460779-1-hch@lst.de>
	<20210804095634.460779-11-hch@lst.de>
Date: Thu, 05 Aug 2021 22:43:08 -0400
In-Reply-To: <20210804095634.460779-11-hch@lst.de> (Christoph Hellwig's
	message of "Wed, 4 Aug 2021 11:56:29 +0200")
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
	(2603:10b6:a03:254::24) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by
	BY3PR05CA0019.namprd05.prod.outlook.com (2603:10b6:a03:254::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6
	via Frontend Transport; Fri, 6 Aug 2021 02:43:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ab521f1-794f-4814-8ad9-08d95883ede2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45526C638DFF4804D59D52F08EF39@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 2biKdQen9g36NLgMB9NpEFKwTBiWr2Gwfsgll439RF9lKoPvcUAIHYqG36JfPXDV2FR7URfRK1nZxA/q4S8f2R1Cq0iuf7KUpxau3cVA/vdXtma8p1xXEFxMCIDXuBPRewidBF3Rm9REYX+C7u0xAUrSaBo9JSUhMzhV+pmJxeFFBunCqY0nYVleyWtf+NvuaAbMDK336r+QFlfvki+ta6G+KnnuD7opZCTIfRFvogei78/S7ruqRPd+8n6RlYqyaEkD7QmGuyZcaP6e2f6+a2O9v6dktxKWCkHJMJF+F3tE1oYy0RauREtacck5QWyVbwgaehdhJ3AGIxCj0TVo+3rbT5MMJ3ty5sK+rJSL4Ab0I3K0WHCos+Nwav2x38kVNaAQjH6GKdNe6i9ng+sX6vYYCTp+V+FEYZTPJAdQKssoQiEJjoHWuFquslHepGEWNsbKRC8Yiv9A69gpL3/OMyHpTATLEYhSDVtD22Q7Afr/TdZFJmjK8J7qAUWgozTXaJAOJ6XA8Xd41JqIXGj5z/gySoIbCcj7AHkiNlytduCSrku7SOuz/0O6VzS8zXG8C/morxf2mbxk4e+/hbZxSzGNVKTQDeI2Yy6KHSWF2l2i98EczoI+HaSaMJWu+Nk3qQdmtlJh16WbltQKiHXUZRErStmEbgIy9bv8GzKKKYC0Tk+Ssej/muh6v/wHTW3sof8K9Wbi1Z6/kymdE13iRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(186003)(5660300002)(86362001)(7416002)(26005)(558084003)(2906002)(4326008)(8676002)(8936002)(956004)(38100700002)(38350700002)(66556008)(66476007)(66946007)(6916009)(55016002)(36916002)(52116002)(7696005)(316002)(478600001)(54906003);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d0IZT/r7RmhPQ3tBCdNNRIg3kRlcg/GhZwyftwygwoa8TrR+MKpsu9mJ0wzm?=
	=?us-ascii?Q?jmrB4D/QkSTeKWQto4gs8+7BePSsC5N9XppW6M1JPurDVUYlKjdWvBVEZ8O+?=
	=?us-ascii?Q?yxWwDM6XLnIjtP7uinZZWNnmHYPSV92OblVx/SVAaCo1Ql60NYYmfAnEAG46?=
	=?us-ascii?Q?cTrGRKj0s4PLIcfHLPJEYP9KpONEiH1dfN2ciCy4nafUUmIL1DxNNzL7N7oN?=
	=?us-ascii?Q?IUckk/1PgSwGorQTZI/iaxg3uerrrFmiSkTl5XPAvKFyM3uUmlFcAl2N06/B?=
	=?us-ascii?Q?WaV34m71jfzjz0WyKFC8u1WIYd511uR7qtkz/58emRw0vP5Ir0Il10RMq6AN?=
	=?us-ascii?Q?EpemLfHd5bWsKx26mkAb4+YU4F5/eeSXRt7xMqsn5XwoVcQ/YqVIoRTSMChm?=
	=?us-ascii?Q?YVeqqd+f9UjLxf9hboaZ7L4g3CXd5c6ge/T/T4h4/m9/nC3k2P5/y5uhfRs3?=
	=?us-ascii?Q?lLqv8Bd4d7h6XVrG/Dk4VZ466CUpYFycy6OeYr2q+co/0opkl+YG9NoLZ0dD?=
	=?us-ascii?Q?KY1rxRLh7l0jfoyX/maLU1V468VMwc3O7fSf8xy3PoJLHECMyio8d7zb3MwS?=
	=?us-ascii?Q?K4wFfAOxJibt8O/N4KT5yl6kxiL9HiIb8zOKf3g5Ay8evEvRLC05/RLUaXvo?=
	=?us-ascii?Q?LAUZnAFaWjX6+8VCq0YBbPSgMXYQnnJ8pSIBG7MQhDaJ5+JHV0YtGbuR0RoP?=
	=?us-ascii?Q?JEMc4MJUYQ4zpVfAg8LYBrmpYVfCesTThCc4dn46SNdXKk1Y/zHPwzzTfQnE?=
	=?us-ascii?Q?btPOrj6ue5jfGDdESAbHom840UQEUlIbYGBK8PUVndCkKKuSRcTUJfqjzesA?=
	=?us-ascii?Q?RkSnd8CO4RE/5ggCKMBku1b6+dji9bsRFn/kp2MrMg14LuWNpMZyJkg/KBm5?=
	=?us-ascii?Q?sGEq4aKxDDf7+r/LhaQPePa3n6kUcGG26t2HLKAhQrIChN9ykMDW+CQA53g3?=
	=?us-ascii?Q?fOZzGJAIWrdNQ3fsX/oNqz0uQ2XpuVvvpBthQi/l7RPEB0fUYRWr77Uceo/j?=
	=?us-ascii?Q?lsOpcE4V4k0FRYyZy27L57Ac0ujbp1TLKO5n/M6T2UFeE0oMZnrRMGIOrPL4?=
	=?us-ascii?Q?1dKwz8WyL2d7bA9YCDmROm1zfoU8aMvtMFiTZh9oxn7o5nRkd/RaIh+QE07u?=
	=?us-ascii?Q?FhJdivGDhxfyLxx6HHIUZ1rUyapGrw8MmfziJ70jCkrykkbZfSp2SsDXHsw7?=
	=?us-ascii?Q?wL3CPkKEnR4ryZHmYF958v6s0p3biSZa+xHNE1Nfy1a8mBDqhFe8+V3X/bNG?=
	=?us-ascii?Q?A35P9nCV1rh6wzry1qE9TV7AQlfqdjfHSo7xM+KL05fbY7GwbehFqoO85DVv?=
	=?us-ascii?Q?xjogAg4hxBjYzsWGGXj8gCEW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab521f1-794f-4814-8ad9-08d95883ede2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 02:43:10.5688 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIMfiozE5/gZPJvbKZVOc6/XGo1J8J5fd+V8vLrjFhFTrpc8gokWrQp1/fKnPlW+D1+dpqw9M8aRwa5wBwhvk8RWG41ogL439Nry9Jgb1e0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	malwarescore=0 adultscore=0
	suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060013
X-Proofpoint-ORIG-GUID: CStb6cVLeKmOmbEMeQn944Xlc9AD_zxg
X-Proofpoint-GUID: CStb6cVLeKmOmbEMeQn944Xlc9AD_zxg
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
Subject: Re: [dm-devel] [PATCH 10/15] sd: use bvec_virt
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Use bvec_virt instead of open coding it.

bv_offset is set to 0 right above but I'm OK with bvec_virt() for the
sake of consistency.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1942DC64ED8
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481420;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/Ulz7VGbqMcXFypuBIVwA0QiBGJidor8/cwrK+nL4iE=;
	b=CO4r6W+vcRDv8zj+z2yUn/W/w2U0/tDH7J+FLJfpylqSHAuB7Ju7GAC62ifn7se9RaJHpG
	3hM3+o9xZHvZhzwyf5P96UmE0ml69VYVV7yxCOfkNm47dfNgQYSuvzdl+iIfivKu75DWBl
	+xvmG7XQYnK2+2ZD6l2dW++w43NHYzg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-YYHv14ZzNiy8I-S124STKg-1; Mon, 27 Feb 2023 02:03:35 -0500
X-MC-Unique: YYHv14ZzNiy8I-S124STKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 364131C04325;
	Mon, 27 Feb 2023 07:03:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 53586140EBF6;
	Mon, 27 Feb 2023 07:03:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1F2D31946589;
	Mon, 27 Feb 2023 07:03:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E40F19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 717DC2166B2B; Fri, 24 Feb 2023 17:47:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 68C9A2166B29
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 371B218E0043
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:48 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-enSt5DIiOH2ZutWamhx6FQ-1; Fri, 24 Feb 2023 12:47:46 -0500
X-MC-Unique: enSt5DIiOH2ZutWamhx6FQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHiB80025485; Fri, 24 Feb 2023 17:45:25 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntq7unjq5-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:25 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OH9Lvk033950; Fri, 24 Feb 2023 17:45:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn4h5nu6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:21 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:55 -0600
Message-Id: <20230224174502.321490-12-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DS7PR03CA0321.namprd03.prod.outlook.com (2603:10b6:8:2b::6)
 To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: a47c984f-084c-4321-e13c-08db168ee6ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: mZxOy5v1jqm7AbSfBWm7O8y06GyrpVctYYqCyW24NIAF0xeMvKbKpsTTdzPCAfwekQKu45cyDTvf3rdVRKMCI+uQOW7kXHX6NnAte2HQOYZDMcbo/hALyUGZzSCi+wIoDADgwTHe5gnW1ynevNOWHV8+VFrPFkJhjbvgWxPbOHXXvhuGjGQLLYfJcBF2B26N6Kaf222BlpjaArdzuHrMOK5uhCQx7kTiyPnwbKiO0f1OujyZAap1DV1m0/9YdcPYxxUANeRoBXi31oEACh+VyleRp4DXpWtR7tuG5AHPFfbf2PSjjzErkKaHv2xmxS7x6oV13D9AJFEv0NTRsXD2KVbh74yuOn9CTMe3AiAaPVYUPRMt+TF3JcYFtCi/fOfGq/raHpOl+G57t4SCdfmhLuVNmCiLOfODn3RutqQoPgV86HARBEg6Joizu3zsLKCLhCZBvbKoRzwdbCsqmU/aMocIjTWdkTZGF1IndzH1DGjCnHW48eN27fpS1/SBRTUAIQS+iaoaLQOFUSJ3jZS9IkXfYj/QwK8wX41u7x91mTj0dUxeWw4xzK5B/z6iSv4FQkRcPe6xmLImpjxOjnlw3zSq3+nkocMgzQbv1KzFyrg/duvpi+EFfv4elWTvmVzh68Ao0rATIBquFcWnHDCZMaxHubD6JJh9fRzVFmybO5vLdIsTSGlSruAhFGT1x+Wn
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2bgd28cRfMuvTerpG0cWiaweecwkQRU4Un7Hp4H1wzcSYSSULa4LvcnohieH?=
 =?us-ascii?Q?swxtI524fWtfMkbmHj1EK9gpUiEuHBrM/Q9k/Zj9cBMM7o3DYnmlLD2tKD2f?=
 =?us-ascii?Q?vTyeS+Dnp8gTA15zNOwDzsZ3vTEtryzH6qWLbBencXoKpxSyqdjL/Nb3i5u6?=
 =?us-ascii?Q?Ra4pN/9M0ncGittd+LIogU/QZ44KHJGSsuZ0mQy15K8CyX6N/L1qU1+iuYsX?=
 =?us-ascii?Q?5g5oUTAI3dBQs8KxwJY/66cyx9MPhV0On1EzE4LvNMph/aqSrJnEWelw0UFB?=
 =?us-ascii?Q?3st6cYRpGB+13n/tf3WbY4QwZgTaEyr+OYgrPIo5GVYZQTBO1bmHipb7HmJf?=
 =?us-ascii?Q?LxBEyokfC7nuvNUm6pmffwZLvSyqaqTtbC8kdZptGbI4oZZlbI+d2tD8L/N9?=
 =?us-ascii?Q?RGK/FeD9tA/xDjNnFPf/uvm+V0X6+KiMsqbeMJrvCYFjBjVfrNiosngmVTm3?=
 =?us-ascii?Q?OnbsNRXA8ScBE120NzDfur3lXi2qFitbuv4GVhbYTiiWOAFG9Dy8sVKCslH9?=
 =?us-ascii?Q?F/Ez3piFo0HrlOHBKcJQ/m9TBpsn/1K2m8ZOEO3yMTK99TbIRVmvfeVlu3vj?=
 =?us-ascii?Q?0f5YBNJnIgDkEl5o1z6y+dOdjJTLonowEzaAlDryfa8YqPe42JMTyLzp+ObQ?=
 =?us-ascii?Q?drZ+7e3SThnQS3ftkh+woBYZHmND5rS3q+McZRSF0YNtG/bNh2MWHjkt0WIX?=
 =?us-ascii?Q?qoZ+mAqoXlMqiyMJFeVJVofQtMBXN4zfvk9ptJVmZylgQdMJyB3t55sL/5jW?=
 =?us-ascii?Q?VAvcUV07XeZbtmwNAKGhFG1NjSgukv7qUPw6e4QivgUhdt8qiQhZPfRL2zRL?=
 =?us-ascii?Q?l3R8YyNKjtThbb/0U+urgTgNJjIt1E33Rb0+1FoUCbv028i6YfBf6HBdebX/?=
 =?us-ascii?Q?FdqxFUR0Vuajn0+EKhxejyICufXonS62CLLp/DcsQyZp+6SDPTkAKBn52ESN?=
 =?us-ascii?Q?Up1VXv/WH17v9rNstTYxN4m8roiOqAlIUQaabatZXoiWWT/rUWYXa0qXQZVU?=
 =?us-ascii?Q?PUBOfhLmae4mJNsdiw885F50gCypEsN9xDTdoKeqR693M3sGYB4Ho9v0VPyi?=
 =?us-ascii?Q?vZabJ+zrzmfhPp/LCv4h7iFWrcjbxpe8p2vZIjCuM17ZEWFAKKxK/PZ7wGYM?=
 =?us-ascii?Q?E2uxVMCSccd7ToMWSPxsfUiR5zlNpdjVMPZYiFs+e0Z32cA4UPZoWJExh3A3?=
 =?us-ascii?Q?GUFRqeWRa2XP+dT/VfhhPf9NACrgm6BVONUI5WMsvK5yCEX12GjWwrhEzy8G?=
 =?us-ascii?Q?W6nIAax1j6yCbDRbrMMKXhjfJY5v3PRxoA7l4q+LGbvlFnU8t1k/Ja+w6Ogi?=
 =?us-ascii?Q?EwIIUPwTG0mnQKoGQXUzNfPDiQUji3AdM4ZBCobcaiiSSaJsHcWrN5BlJasT?=
 =?us-ascii?Q?6zthDG0Hv2oD768No3CDDAr4UAvB/nDJ0yQRryHJyAKX8aObWyTgqzgeJmG1?=
 =?us-ascii?Q?pRkand99xJc5NlwRk8jRM7mSfojpAfOXezBxd+vUjU0FpkhQuKUPpb70+dtl?=
 =?us-ascii?Q?ZNcoQDS4msxVjluh0lC6uPlNYgfcu9ad/XhOTccx4h7IxZqI3KS4FcfuGFiA?=
 =?us-ascii?Q?ez+U+sJo81kb4W6sKCd2Hwksw/OCd7MoiQXra6u1MyolbJYDMHnmiooIFHaJ?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?D0TAlDcGb7PJUe6Fr246n0S5cPZlLLcYxgnj269LSDdUpOMx2yS1yx8Jyrke?=
 =?us-ascii?Q?FwqV1tEKz1vKkT2xfjb4xeoSVfiXefMDcAaOG5t7ikkdHhvdKn7ACnpoWcV/?=
 =?us-ascii?Q?KTr5FOltMXcMiYKCjiqei5Rhj2zbm6LS1CrQj1s3FI04+3edtGRiYxiKxMvY?=
 =?us-ascii?Q?yV25OJsUlx4UM7ub0ONbAdofm+xu//luAZU7N6Tj6w9FFj9BLAUDycJ5bStW?=
 =?us-ascii?Q?EzjD/1gHRsp1xeUKahy+chNa7Y7SbVICP2XLdl4DiygTbR6sDPmnqFrTeo/W?=
 =?us-ascii?Q?zY/jLLy9rwuRO6TDWiUlVO/oINJ2ehJtMF8OV/OlqDKut0wbD6WPaRoZlhcq?=
 =?us-ascii?Q?4Dm2IfK/uUbuR3OvF9GtudCwPcEZyA83To204MM0PZq4vEq0jxFA5x1N7xNo?=
 =?us-ascii?Q?3ZZ/fPcp1dcTDbyavEBiwVYBYnUaoZQZF82J+VJD+X18qFouSej2nvgZnjaF?=
 =?us-ascii?Q?/wiDuNmz4V6a23vlmBYUxMjMWVWxfHJPgfoPKRJqWjF4YvlaL8KMP9AfMcdL?=
 =?us-ascii?Q?06Mm8LVflIK8BCy7EMA1vrl7WesQnbEosNls2rUvfsF2yJFsi50fma5W+Rq9?=
 =?us-ascii?Q?wsP58wTS6+sYTvWr35PewbPU+xQef5mr5RVuOtfkELg5Xbgmx8sILXCmhoyZ?=
 =?us-ascii?Q?zuh8iBSMUCIvgqvG1TxZrQ1WKPuICHqVeY5790c2xziRQXfUKV4OdevLdsAt?=
 =?us-ascii?Q?zHK0x76ltrnFp5GODXG/FLOn66JYKsCanpab0hSArHk0XIRApZzPtjK/Xfzy?=
 =?us-ascii?Q?bu0ZNOysUJ7NH28L1UEEu+1Gc4uF6M/mN3khOCTxjjVsnNmtHAgyYBV92ugG?=
 =?us-ascii?Q?zD1r0KmwL9nIjHXf8jUjXUKSRCqpoitf2+T4SUCT20w8Qk8Zo4lP/pY8tokF?=
 =?us-ascii?Q?OFhnuKS+Qj8Yjdguo5udMzxntXfPitXMBBfugi11s6PEx1sPR5MEgK6oc0LA?=
 =?us-ascii?Q?HPH+MCo95SHtBYa6Mj/G6bHVFjXDevp8uD2hB1n2crvq60PpvgEIJwrOjAN2?=
 =?us-ascii?Q?SM78n1wzFAg/yaKGDv2F28Wc9w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47c984f-084c-4321-e13c-08db168ee6ad
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:21.5629 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hVg8Ur1L8psmGOfTplsIHKLvhpJ54yObcNUFgwv0jyOZSiPsPNptS1QI2/4JpZZWQuEvupHsWQAGfMWcnXnyaji2z2yR49BX7zMJZ3XIFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: pgegBzSQWz35qRtYidfOy9r4kjmFVpwV
X-Proofpoint-ORIG-GUID: pgegBzSQWz35qRtYidfOy9r4kjmFVpwV
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 11/18] nvme: Add pr_ops read_keys support
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
Cc: Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds support for the pr_ops read_keys callout by calling the
NVMe Reservation Report helper, then parsing that info to get the
controller's registered keys. Because the callout is only used in the
kernel where the callers, like LIO, do not know about controller/host IDs,
the callout just returns the registered keys which is required by the SCSI
PR in READ KEYS command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/pr.c | 65 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/nvme.h   |  4 +++
 2 files changed, 69 insertions(+)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 7a1d93da4970..ac6b9008e7e1 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -151,10 +151,75 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
+static int nvme_pr_resv_report(struct block_device *bdev, void *data,
+		u32 data_len, bool *eds)
+{
+	struct nvme_command c = { };
+	int ret;
+
+	c.common.opcode = nvme_cmd_resv_report;
+	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
+	c.common.cdw11 = NVME_EXTENDED_DATA_STRUCT;
+	*eds = true;
+
+retry:
+	ret = nvme_send_pr_command(bdev, &c, data, data_len);
+	if (ret == NVME_SC_HOST_ID_INCONSIST &&
+	    c.common.cdw11 == NVME_EXTENDED_DATA_STRUCT) {
+		c.common.cdw11 = 0;
+		*eds = false;
+		goto retry;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	return nvme_sc_to_pr_err(ret);
+}
+
+static int nvme_pr_read_keys(struct block_device *bdev,
+		struct pr_keys *keys_info)
+{
+	u32 rs_len, num_keys = keys_info->num_keys;
+	struct nvme_reservation_status *rs;
+	int ret, i;
+	bool eds;
+
+	/*
+	 * Assume we are using 128-bit host IDs and allocate a buffer large
+	 * enough to get enough keys to fill the return keys buffer.
+	 */
+	rs_len = sizeof(*rs) +
+			num_keys * sizeof(struct nvme_registered_ctrl_ext);
+	rs = kzalloc(rs_len, GFP_KERNEL);
+	if (!rs)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, rs, rs_len, &eds);
+	if (ret)
+		goto free_rs;
+
+	keys_info->generation = le32_to_cpu(rs->gen);
+	keys_info->num_keys = get_unaligned_le16(&rs->regctl);
+
+	num_keys = min(num_keys, keys_info->num_keys);
+	for (i = 0; i < num_keys; i++) {
+		if (eds)
+			keys_info->keys[i] = le64_to_cpu(rs->regctl_eds[i].rkey);
+		else
+			keys_info->keys[i] = le64_to_cpu(rs->regctl_ds[i].rkey);
+	}
+
+free_rs:
+	kfree(rs);
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
 	.pr_release	= nvme_pr_release,
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
+	.pr_read_keys	= nvme_pr_read_keys,
 };
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index c8c504926462..50fc596ec888 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -759,6 +759,10 @@ enum {
 	NVME_LBART_ATTRIB_HIDE	= 1 << 1,
 };
 
+enum nvme_eds {
+	NVME_EXTENDED_DATA_STRUCT	= 0x1,
+};
+
 struct nvme_registered_ctrl {
 	__le16	cntlid;
 	__u8	rcsts;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


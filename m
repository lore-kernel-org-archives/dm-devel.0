Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D666C7EE2E
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481420;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LLIjYaymQPuJx/rrGq4Edz4HUfEYsh0jOML+K4+6LOo=;
	b=HCQ5XiAvc2onzoT+Cba9Uuh7r8lwDrt/BLhOoFy0B1Zln4MuYSh5MBHqLbZxIXlZkXFg0A
	F6RTPw+DcI2vAD0ZPBp//EU0KDg9ezCiuzg6uwLeqWJpLbkcXJbqGLRUFVE2Zn6gM8BZ7b
	3DS33BrlTCYwTaMEow+KZZQIUzTAj2w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-83-qfGhUrCxOym8gfFfnLz_Gg-1; Mon, 27 Feb 2023 02:03:37 -0500
X-MC-Unique: qfGhUrCxOym8gfFfnLz_Gg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BB5A2A5955A;
	Mon, 27 Feb 2023 07:03:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A72DDC16020;
	Mon, 27 Feb 2023 07:03:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4EB2519465B9;
	Mon, 27 Feb 2023 07:03:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B16B619465B2
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9CA88492B09; Fri, 24 Feb 2023 17:47:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94E69492B07
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7494D1C07552
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:52 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-hH45fNPAO6e79GZbEv_fRg-1; Fri, 24 Feb 2023 12:47:50 -0500
X-MC-Unique: hH45fNPAO6e79GZbEv_fRg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHhrEn013868; Fri, 24 Feb 2023 17:45:25 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnf3nqxu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:24 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OH9Lvl033950; Fri, 24 Feb 2023 17:45:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn4h5nu6-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:22 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:56 -0600
Message-Id: <20230224174502.321490-13-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DS7PR03CA0305.namprd03.prod.outlook.com
 (2603:10b6:8:2b::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 6540f1ab-ce3e-4f21-e941-08db168ee75b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: RCTYJAyx0bKD+c1NbuRN4BVAu+yCNlo0avCKIl16a3D3jYWth0r4mnVUcmLMMOm0UwnQPYmDDtZVY8S1cbiJ6z+j42f+Yw17B4gPkMPNidVIPlxt9eD7MwXtTJOrPWQS4e0qkFCm5taL3n+7uL59ya4brVIZ4vUUtWfWjGsNPMWCO6JDmHY03wD7VTIaBJzz3nCf82Ke/lhCe/HwnvNYA2Dkl2RNI/tVAWo7seMm4JLmgygrgPYnxi/rU7raPy4V6QTqcKlAB5Gbq/0oc+EFxhZ9KNZx7SdEkEKFeSfFKlpNmIubKsv2pUl4cs13eEcF8vWRJJNqHsMVsTjTRlnuPhhR7tqFpJUce2Dlhuxtp/E7lBu9u5tzsDxeqX0kRarSKuL3VAE8Fg0KLytnFigzP29sRl2BKKgXdL/Zhg4kSFLtFHpRH1MpDeLyEAdubhsG8jlI7GsYr5XWu+yHV86qhRf2mPFPBOfGe/NIAZv9jn7dhQXhOaTEPPQxzqd9PbB9ieLtjBwNTA+5THSFOqeB5yqM1nw6Xmsur5O00lp0TH7VDu4UMIKcHjRxcXqpJ7jN9z7l9g0PmatlGL3rCdXCuFYiZ697LmF59mo9lpzyLy6pyNv0DRnAkhEzc6FmaCdPD+79GZBMtBOrRIScX2rjDstWQ16NqqvGHgheFIE+OB09m10k+TTf68ryxQsDi8lQ
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SdgDFr+lkFeV2a9L3lKo9UJ/1O5AZukHUvN51Rx8lM3t5pSekp+kiREAtweH?=
 =?us-ascii?Q?TRGxBcfBwld13TduNEGgP19ZVNR1NQNkdAakCmaOHNiPP43XH0AGqqZV+ftT?=
 =?us-ascii?Q?UJ4mmAQm+sDn5+5sg/s2gUnTxm8sg/QV2yNKXr/jhXgiw4hZrwIH604xeudj?=
 =?us-ascii?Q?u5g7cUVLW1S7zc6qXaQEYPT4AQsVMXQt/+aItL4be+e1h6Ms75pxO4YtFW3J?=
 =?us-ascii?Q?BQbxDfb9hfmaxV/EeQ2xY2JCQPCv8qb7IHebH42ds1sJeQEof3/1DtOiLq+d?=
 =?us-ascii?Q?YCgwluxsES5lnY5qG+U4Wh3vGQyfz9Wj5k/KYTnbnuBzZa2aWTc3uFmYneuw?=
 =?us-ascii?Q?Uva0JoaEAHudrX+KkLVy5NwqNXMYc5wgPNvwv10UxzshkWFzYQ5NNhBCjDd/?=
 =?us-ascii?Q?BzyHXXs7V8lI5KHhdKxStR71uJnlidD88adOptqCIrMfBUsnILCBUhUjh3zI?=
 =?us-ascii?Q?f/mMzugaMHycunq0ghAs6BYHEA4vcUZvAv/D3Vs/lAPD2nwi0/NgvPyJJEn2?=
 =?us-ascii?Q?o77hpy8I+XOde4SMN2p+Ec/0dhAFLzMyrSCuE8HPsZDM47xOc+DGkA8fZDl4?=
 =?us-ascii?Q?7XVgUUHYrrrBFQySJV4udI/8v4QWa1NSaW8f69/Tt5zvJUWl/Wo0mf48Uk4A?=
 =?us-ascii?Q?3TI5ngEYyPZuWhWLj7kMvqa0M3lY/9WPc4zOzxARCCSnY1tD16DYOa7Z/dOd?=
 =?us-ascii?Q?Qp3rkCnObyDEjDtewa/hiSP5qKg8WRzOPNfE8qYv6HmPZhs0Vbel++3XTYtP?=
 =?us-ascii?Q?/cYjwBHpcuftJ7udLDofQalEqbNxxZGyxUaUiqX0jxKpzrP8o7F/XRfMt3Ve?=
 =?us-ascii?Q?wRt/c+jqieUZ8npseIHSXZqtmhJXPBGus7dzi2tyF+zCLbv0HLpUoUK2AkDW?=
 =?us-ascii?Q?q8FcvYIIE4+3QZtaPHkjKGISCklWMnJ2Ip4EuOJWQLMXVz3j4rEY+9TGp0D4?=
 =?us-ascii?Q?USi8kMnXxZRNY2ZvUxgSRuVkDr2Wgpm4GFBb1nKveqEGpuTMJMPecSExM5BI?=
 =?us-ascii?Q?63zg8wxDnplcN926JyeMtUPFFFb/D8qA6duvJ/Q1QSlLIqpWDy8q1qWikT1p?=
 =?us-ascii?Q?/J/wK5OoTaI/1SFaZkQ7lld6sQIlcH6Ajx0PGpmN7bq6LDg/9bfIRuLzJJwN?=
 =?us-ascii?Q?2rznSy93WLONyRzWF1nYwgw/29jKNrwPi64dmZdVU8ArdZwiB7ChZ/U/DBqn?=
 =?us-ascii?Q?Zc+JBBdNI+WVTbx81RNhLIZPhd2GJiOh9TWZ+uzYurKi0IlN6h0vcEsQzl/z?=
 =?us-ascii?Q?yfTu7WOmqacyAiDgCUogTEB+2HqoE2lL9qAp+UQbCIjFAgkUymy6MLNY5rF4?=
 =?us-ascii?Q?/eIQqrgUIyX7CMdAvX3YLFhRdhuzDU74lbLikFh8/vv3QazpLNFVHsiSDhrn?=
 =?us-ascii?Q?cWatssJiW9J0/wvrHcPDIz4xduYg8shxQUpDEtkZngpR3WiodAwH8nK7/yKk?=
 =?us-ascii?Q?4dsnFUG0rn6kgmPON7VNOF2+q16/lleZN7k40cqhQWlqL9PBXPndA5G54b3J?=
 =?us-ascii?Q?f4an20v8Qi0rXP9CIAq1BTgTzGBQYqozYxux3WopEfpgYKvA/VbnxEVydzBl?=
 =?us-ascii?Q?r0Gw90D3L1hLFBBvLcYUoe5pkG6SS4VhRdyJ4cMg5TTUOrZ94mlCuzfCfHEd?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?QcHvJBy+pUuSQrtMtjBYURlY18lqahhKZN9OzRhCASYRxhZv3Fl6oDcN0xg2?=
 =?us-ascii?Q?C/moQT8wBMUPgqCdT9HgKyl6nm7HYJqreGahxFSoLclxeJYCPQnE2AfqOPb6?=
 =?us-ascii?Q?9DDLdH+0SIOASFOR0hGuwDW+T2zElG7FmOa2uWgtkG3Sl6ppJ9EqF6ny6ELC?=
 =?us-ascii?Q?J0HpBO6/hx3exYvBBwyN/UBH58rTZr95wkuBVhspMQ8oV47OktLiIre4b6TK?=
 =?us-ascii?Q?1f5+GX4Dw6YMppOLcL/UyvTw5URN2AO99xc3+l0SadpRD6tmBxmcSq+bBFlo?=
 =?us-ascii?Q?1SBL7j35A/nE7mZCUjNbN1OpK+rwTxN1I8lULRQ2zjUbToTB2YaQWk4v+rWB?=
 =?us-ascii?Q?QJlHzOr8xcC+Oo3HkQrkTjjUab+wGzG6i5uj7edTtFq+VP4JCUY8oio5Bflg?=
 =?us-ascii?Q?Tb46D+6CaoGjGNiA+6PtxKBPyvCkcMmass5KrHXA4+FK5vZLO6/tEm1OHn9a?=
 =?us-ascii?Q?choUjWXbbZ5ZvvAAbAAp4elJ4MBIFuqOJtiwYe+uyR10/OA4W9utd3t9OorJ?=
 =?us-ascii?Q?BIgvT7/MhnkAsSPeysYcThXMkjf5DnhfYcf86oU6zAA9fennZnJudHiwnSew?=
 =?us-ascii?Q?ZHPKNHYxP9qTWz7WuUb1MGlUyFMbLa8//tC2U8h6XfKEcOBZRyFtL3iNEOU2?=
 =?us-ascii?Q?1vt5vpTtWa2/zCz8MhFZITJwt/M47CAuIjRSG4Vo0ZzoVAGSFK6PUxvWziMn?=
 =?us-ascii?Q?b3ba96jTMdWjgQYbkJC0VqxFkRTojmNhO6IfRG3BWb79b+r9kM2848tfe3KG?=
 =?us-ascii?Q?SDOacZnP/k47hpN+/7SGWnSaSgVBkIF5XUxKJH01Mz8VB4Y2gs9OLx7WMEsX?=
 =?us-ascii?Q?FM+ox4GllvOOyxb2pVjErlO9dISaDSNc2G2ody1CQmBlerFMwWM6BWS6ILPT?=
 =?us-ascii?Q?U2DzS0vUmHD5GCaCdtDz5XM2ilvvn5J2ZS0c5hKATOZgyk2p8jt+VOXTLwZc?=
 =?us-ascii?Q?9p8S0tQ60ttlDWp8EeWbDT3hWSOie5TEDJfc0u/GLW6dDRy0vRGVje/uci0j?=
 =?us-ascii?Q?5ECxk2Jpts7xXWlL6NECph+EtA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6540f1ab-ce3e-4f21-e941-08db168ee75b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:22.7503 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tI6dOiDvxIxE2QLRgldv7XH3/oI1hUD+4tYyboqekouZZ6fm+M7KscQJiyLe6jNXpxQMju18RTr6AxklQeqLS9HYn3swMsv+Va2qR3HGC8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 spamscore=0
 mlxlogscore=979 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: zVUGl1rlKG19WAKVedmC9ON4U3yZF7Na
X-Proofpoint-ORIG-GUID: zVUGl1rlKG19WAKVedmC9ON4U3yZF7Na
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 12/18] nvme: Add a nvme_pr_type enum
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The next patch adds support to report the reservation type, so we need to
be able to convert from the NVMe PR value we get from the device to the
linux block layer PR value that will be returned to callers. To prepare
for that, this patch adds a nvme_pr_type enum and renames the nvme_pr_type
function.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

Note for Chaitanya, Keith and Bart. For these patches where we convert
between block and nvme pr values, it seemed like Chaitanya and Keith
didn't have a strong preference. Bart had the suggestion to keep the
switch and drop the default so the compiler can warn us if new types
are added. This seemed like a nice benefit so I went that way.


 drivers/nvme/host/pr.c | 24 ++++++++++++------------
 include/linux/nvme.h   |  9 +++++++++
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index ac6b9008e7e1..66086369dbce 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -6,24 +6,24 @@
 
 #include "nvme.h"
 
-static char nvme_pr_type(enum pr_type type)
+static enum nvme_pr_type nvme_pr_type_from_blk(enum pr_type type)
 {
 	switch (type) {
 	case PR_WRITE_EXCLUSIVE:
-		return 1;
+		return NVME_PR_WRITE_EXCLUSIVE;
 	case PR_EXCLUSIVE_ACCESS:
-		return 2;
+		return NVME_PR_EXCLUSIVE_ACCESS;
 	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 3;
+		return NVME_PR_WRITE_EXCLUSIVE_REG_ONLY;
 	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 4;
+		return NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY;
 	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 5;
+		return NVME_PR_WRITE_EXCLUSIVE_ALL_REGS;
 	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 6;
-	default:
-		return 0;
+		return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
 	}
+
+	return 0;
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
@@ -124,7 +124,7 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
 
-	cdw10 = nvme_pr_type(type) << 8;
+	cdw10 = nvme_pr_type_from_blk(type) << 8;
 	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
 }
@@ -132,7 +132,7 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 		enum pr_type type, bool abort)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
+	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (abort ? 2 : 1);
 
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
 }
@@ -146,7 +146,7 @@ static int nvme_pr_clear(struct block_device *bdev, u64 key)
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
+	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (key ? 0 : 1 << 3);
 
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 50fc596ec888..bae08167735a 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -759,6 +759,15 @@ enum {
 	NVME_LBART_ATTRIB_HIDE	= 1 << 1,
 };
 
+enum nvme_pr_type {
+	NVME_PR_WRITE_EXCLUSIVE			= 1,
+	NVME_PR_EXCLUSIVE_ACCESS		= 2,
+	NVME_PR_WRITE_EXCLUSIVE_REG_ONLY	= 3,
+	NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 4,
+	NVME_PR_WRITE_EXCLUSIVE_ALL_REGS	= 5,
+	NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 6,
+};
+
 enum nvme_eds {
 	NVME_EXTENDED_DATA_STRUCT	= 0x1,
 };
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


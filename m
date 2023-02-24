Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E3EC7EE31
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481426;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3+KjeT23UVxk7S7l5VQScQZNYDeEpuuPpjXzRhCNFhs=;
	b=FcnDw7gUQ+xOhqqJBc4TqR4N6N6QaRLZSUn/35H47Z1aUHhNAAfXO1lhhrRzMqDjQEjN/s
	tcS430tFYE3YQPeX0QyRgnw+O6xAtzC3UboNsvseyynVgxUnFXfMMnvT3QqMC/FtYBbrF6
	tBS7YYJiOni2RvhF2nd5HAhHwPNCgqA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-BpAIHWs0OSSu5hCDDTz4_g-1; Mon, 27 Feb 2023 02:03:43 -0500
X-MC-Unique: BpAIHWs0OSSu5hCDDTz4_g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2EBD100F918;
	Mon, 27 Feb 2023 07:03:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE4FE1121314;
	Mon, 27 Feb 2023 07:03:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 010161946A62;
	Mon, 27 Feb 2023 07:03:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F3D0919465A0
 for <dm-devel@listman.corp.redhat.com>; Sat, 25 Feb 2023 00:31:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 90B3F1121318; Sat, 25 Feb 2023 00:31:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63FC81121314
 for <dm-devel@redhat.com>; Sat, 25 Feb 2023 00:31:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F0A13804060
 for <dm-devel@redhat.com>; Sat, 25 Feb 2023 00:31:34 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-Jg2SBmQBOoaZSzgxW604VQ-1; Fri, 24 Feb 2023 19:31:32 -0500
X-MC-Unique: Jg2SBmQBOoaZSzgxW604VQ-1
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHi7GS028907; Fri, 24 Feb 2023 17:45:23 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnkbwk2h-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:22 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OHJGXV031548; Fri, 24 Feb 2023 17:45:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn49wjuh-3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:18 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:53 -0600
Message-Id: <20230224174502.321490-10-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DS7PR03CA0302.namprd03.prod.outlook.com
 (2603:10b6:8:2b::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 15dd2854-af93-4977-37b9-08db168ee516
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: yv2TV2I8QLHSFQagwogQL2nUeofxWNLWMVdrQ7JBL3qS9jyRJ5wjVQJMxw7oQXpXMLWOpPD9k5dHdK2sM1gCBU+5Sd0iffVi7ZL5AtIeAax0kBog8fJva0cM8pujI1lndrnP9z4EhmR7xEhYNaYm3UBPgHWEas806H4TJgSE3EOSiYp5pOjIQp6hsMsS2N8gasrZ42JZwYdnGnicZ1juRnpHAeSjbv7epGMDvgZxgR42XJEyoMGDgiLj/FmYxIF+U3gZRDwhUwMYO0WdZOE3koSztRosNeRUb3B947wdJGLM7Yy+Hpjj/9ZWMMMIHSgafDNuVQ2P4Ug2gBz3tFTkMb1YTn2HBbRRZAxNy+I2CQhwsb51Wp6lZ/2NJwnxBKGQ4WttJ6HA3FefEdu1o3kg+lmha3Pms5gVy44fiAzp38Wd4sFhWfnPR+ubGdG3ndDyotvAcgSBNkFo4PKAQXuQ9+w8XS6f0zTRLjqo7Xr90dzHVkNZZgFLb4XwVesa5gH7zDTMJSMlVOA/z4dmH3oT277N03wFVU8sFCHAZ51ADJj6VsqzaSkrsycMeGbs7VUIwxZelMouDbVLRlDbI/zpAJAjsQQTKfXncfG5dpTLGdXrdtcgpTEpExi3gCUf8bcc5ycsNt8JrvCophNw9n+kFXcw/yTVcjFIaCcLxAli3LzxK61ghMmRgpZTgNyxkAu7
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(54906003)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JRG4QKuqH3UdJ5XRaYzwkry76YcOXZ8PflJLs29rr8724l3CShtaZjC7EGtU?=
 =?us-ascii?Q?lipXunxjpmWuPhI5iC6WtNeVEBbZ9uuv0uf951LuaMEJsF9QT1sNkdqHlDNq?=
 =?us-ascii?Q?jkNakd1hz5LHuGa0qqXlAIt4lfKiWKXLYKeb+VxjBDAiuO2K1bd8+ZxDOqqi?=
 =?us-ascii?Q?h7R58j6MgHOsKclCtn58vLt/g+qZ7Oeg41CLo67QNDUvhKQFRUIipML33QXl?=
 =?us-ascii?Q?AXVxjvbUyFgH0ytmk1asddgTPju5mkSfGEeslXM45PDPFGg2JY5sY+qUlHzA?=
 =?us-ascii?Q?mW5TM6Hh5le7BFFtwWw9kxrf1TdsgWdKkXRcGVXtSukhtj7UI16nB5bWiLUp?=
 =?us-ascii?Q?a58wgh5R9Rsdz0g432Lwzzh0WTXPDi+m9uTOPPmcXsCsYe2nF24KCjpFA1w4?=
 =?us-ascii?Q?BuVivopmq5zAKqp7NCWMg/R5tqM+0eMzqLjqYoGDvotFT63QJ8kI1N4PAupX?=
 =?us-ascii?Q?HWj65KCgNb34sx7gNAZQH9jClC5Ir6JRbfFGHnpi62WrJcih1/74bMZMB2Ym?=
 =?us-ascii?Q?eCpAcaqgDrCVXnNYwXvGXFHGFA54dmpDd3VGJJrWa2E6fZIqCa1iF5N8DYdl?=
 =?us-ascii?Q?UoILfWP6Oqc62uOySd3cOtJlIs/dhfrjNtvIubu08ry759caCHafqtviNXbG?=
 =?us-ascii?Q?Hbp5mX2idxPZKVncthmbRu/ZQAm4MWwO929dXZRAeDPo7d22vChXPHdQGl8N?=
 =?us-ascii?Q?A/zWIciA/UU6et0ZDNLdn6N29jzaJal/RGOkY17/kr6C62Lg6G7TYzNEFUAT?=
 =?us-ascii?Q?Jl77YWyYjeAjULWtBA5XLZA75pSbkHNt2eejZKbQPmx2AzD10thqALxuTdI4?=
 =?us-ascii?Q?TZ5Av/X5TCZrjR2U7AadbKyy0EdXOuh5KPTp6hj2Dor8HXuTjwG0bp+AR1c/?=
 =?us-ascii?Q?TAwBXxokgiVOF4tRIDRRC6QhKweGv+pFCKDCGhseNvi6X2vdZ5/8qHHnW1r3?=
 =?us-ascii?Q?vkKqnJPrWFh7+Q7IpniCpl2/wlXcEDDPZdgjj317NR6Y2IJtQCn9hCJeQydS?=
 =?us-ascii?Q?t3DzgQA2A2DF8DdP/tVUmDHUEwOKaWXsiz3hCbHMxq1X62VJN2ANy9hwGr56?=
 =?us-ascii?Q?RCaPHvo0trGOtit8m0WZ2hV3gmvKOQebwZJS8eKMJMBUNfGEzLurXjTL6qBx?=
 =?us-ascii?Q?z5H1Vm0o5e601mVyM+tinfYP5hu3qgbJUe183Ccdbmwpk4BWokQV9EL1ZR91?=
 =?us-ascii?Q?rjbXDfN9Tbo2AAWW8mWp/36zqvwR0Vv4ctA0IBKPUWXKNZB7oQiApAY4QQhF?=
 =?us-ascii?Q?i6M1MxhTYk45/T5LOuCFqEC6JM2Kpkyh9LNXLz4ylA7wcScx1jSx9wXS2J6K?=
 =?us-ascii?Q?KA+SlKluNEZJD/cBC26kSDkIdumMH2x7VwFHleJJUtp/9pcAamQRVQOgzW5/?=
 =?us-ascii?Q?oyk4xNpniHIOmgHjzHhCZ3JBlT4wl8CxcxKKzCivtfOVTteLKuECiLf/wcPE?=
 =?us-ascii?Q?I4o45OcEmzQgRMI/+iTnJrqy/3vjZ7iZjbVJ7d8vV4HZrjFUMpt+DbSZECoZ?=
 =?us-ascii?Q?wzYK8xly7S1JtU8K2PwnUrlKreDv6QbFdPtkXxRfoE6rhOwqKyzut+NU31me?=
 =?us-ascii?Q?PwAMqLnPDtrjT4cUQCAGLrtEp8YXWTe4RSZMtblJFFphzbfiZiNXaDpIjyg+?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?948xiIjkqqCK+96zlcCi7ES0zFxEkdIWUeyoVvWJ0ukD4OaYrs8jZg8RIz41?=
 =?us-ascii?Q?yo8jVtCPo37lzyxwZsCxJhZhplNhxUaIqWrWAQ6CAtYqFV9vzhgAykUQVD1T?=
 =?us-ascii?Q?E++y93O8emvs4Zebd88RAjXfREXzy7ZGBCtP9ryszcYJnuq0VdQB/q0BHKAF?=
 =?us-ascii?Q?m1H5WsI9EDyytIQMI5OEHM2UQnWojvvcG+XsIDUS7UGGSya/T0LKMGubjHcZ?=
 =?us-ascii?Q?L/I2SG7mLwZfTPo6uqU0ZyDj+V3RoO5WBotBUG/gw/rrTZwJTc8qK0oWIjjr?=
 =?us-ascii?Q?QN/0io/usVUAKwqn3BlMkeeyg2MWailxn9yyE+IkZCvyY45F0KLqWqcnqK9v?=
 =?us-ascii?Q?v5QWG3/bRMYQ4YDwqIArhqGRNnHras2swYjtd0qGWUO9U77LCljtbL4fiAiS?=
 =?us-ascii?Q?1pM0mQbUEUICeMz1O95iWZJEpsnzdqS94cHSFS36pbi/Im/olWej7fzrOu26?=
 =?us-ascii?Q?atBUm8/vI7kqcdorNfCnr8W0CCw4PfCrls7yqAnwwIiPHTNz2Zxx9EFB1aBB?=
 =?us-ascii?Q?k8BgbyFgYd1meETA6JYmdPejGNsaFIGnHE9QL/PVM5F+jTc+CJgPh6+FXx3e?=
 =?us-ascii?Q?Hlu3qlHNbwqF61jonnCISAsCbK1asZkUiB8SpNAWoiBis4Rv755AH6qnHULP?=
 =?us-ascii?Q?RJbsUbjFg0EE+lEnQ+xY/C9jICs6LyfeJ82a+yygC4WAU42pUtpYCuJdiYYm?=
 =?us-ascii?Q?lpwO20br4lTXeLOX7DKBWZ9Gm6JL9DC4NZjoSJIjqRN8IrYWA2sFnIk/MX/y?=
 =?us-ascii?Q?wEWvFSTKpvRpCXA51m4QU4I7EQ+9OTlUzG+D2POpvrd2eU4JX+bY7v7PPe7z?=
 =?us-ascii?Q?veWH3HiW1+wUyS1VoX4rO9PMywBlPFI3H1SInhAE/1F4NONwF3h3RgMokC6+?=
 =?us-ascii?Q?p1VGpThuDVW9aeEEatc21RjCHmbPQvNWj5nZfN0nWO1N/kLQgIKqPSizRUjI?=
 =?us-ascii?Q?fpsyi5HqwxDYwdlx1DD6JQhVcolqFaA4HyftDPuMqCWRXg7aGwHwVxC5SRxC?=
 =?us-ascii?Q?YsDCejiXHt9sl1WctgMak/uFjg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15dd2854-af93-4977-37b9-08db168ee516
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:18.8912 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ydEIrVfOGwAkb80P9aj/aHVJGsSDQBhOHAGxuy6pcpMUweTirq6uppYXO9cjwEBSPD+1HetbW3cup2d2QTaP49pMCySH09RfrScoZEm2E2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240139
X-Proofpoint-GUID: f8kULuxziioDkS9r2JctixtJqsNbP8cB
X-Proofpoint-ORIG-GUID: f8kULuxziioDkS9r2JctixtJqsNbP8cB
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 09/18] nvme: Move pr code to it's own file
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch moves the pr code to it's own file because I'm going to be
adding more functions and core.c is getting bigger.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/Makefile |   2 +-
 drivers/nvme/host/core.c   | 148 -----------------------------------
 drivers/nvme/host/nvme.h   |   2 +
 drivers/nvme/host/pr.c     | 155 +++++++++++++++++++++++++++++++++++++
 4 files changed, 158 insertions(+), 149 deletions(-)
 create mode 100644 drivers/nvme/host/pr.c

diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index e27202d22c7d..06c18a65da99 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_NVME_FC)			+= nvme-fc.o
 obj-$(CONFIG_NVME_TCP)			+= nvme-tcp.o
 obj-$(CONFIG_NVME_APPLE)		+= nvme-apple.o
 
-nvme-core-y				+= core.o ioctl.o
+nvme-core-y				+= core.o ioctl.o pr.o
 nvme-core-$(CONFIG_NVME_VERBOSE_ERRORS)	+= constants.o
 nvme-core-$(CONFIG_TRACING)		+= trace.o
 nvme-core-$(CONFIG_NVME_MULTIPATH)	+= multipath.o
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 6323ff79386a..69b7fe4aa0c8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2051,154 +2051,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 	}
 }
 
-static char nvme_pr_type(enum pr_type type)
-{
-	switch (type) {
-	case PR_WRITE_EXCLUSIVE:
-		return 1;
-	case PR_EXCLUSIVE_ACCESS:
-		return 2;
-	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 3;
-	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 4;
-	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 5;
-	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 6;
-	default:
-		return 0;
-	}
-}
-
-static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 *data, unsigned int data_len)
-{
-	struct nvme_ns_head *head = bdev->bd_disk->private_data;
-	int srcu_idx = srcu_read_lock(&head->srcu);
-	struct nvme_ns *ns = nvme_find_path(head);
-	int ret = -EWOULDBLOCK;
-
-	if (ns) {
-		c->common.nsid = cpu_to_le32(ns->head->ns_id);
-		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
-	
-static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 *data, unsigned int data_len)
-{
-	c->common.nsid = cpu_to_le32(ns->head->ns_id);
-	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
-}
-
-static int nvme_sc_to_pr_err(int nvme_sc)
-{
-	if (nvme_is_path_error(nvme_sc))
-		return PR_STS_PATH_FAILED;
-
-	switch (nvme_sc) {
-	case NVME_SC_SUCCESS:
-		return PR_STS_SUCCESS;
-	case NVME_SC_RESERVATION_CONFLICT:
-		return PR_STS_RESERVATION_CONFLICT;
-	case NVME_SC_ONCS_NOT_SUPPORTED:
-		return -EOPNOTSUPP;
-	case NVME_SC_BAD_ATTRIBUTES:
-	case NVME_SC_INVALID_OPCODE:
-	case NVME_SC_INVALID_FIELD:
-	case NVME_SC_INVALID_NS:
-		return -EINVAL;
-	default:
-		return PR_STS_IOERR;
-	}
-}
-
-static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
-				u64 key, u64 sa_key, u8 op)
-{
-	struct nvme_command c = { };
-	u8 data[16] = { 0, };
-	int ret;
-
-	put_unaligned_le64(key, &data[0]);
-	put_unaligned_le64(sa_key, &data[8]);
-
-	c.common.opcode = op;
-	c.common.cdw10 = cpu_to_le32(cdw10);
-
-	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
-	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		ret = nvme_send_ns_head_pr_command(bdev, &c, data,
-						   sizeof(data));
-	else
-		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
-					      data, sizeof(data));
-	if (ret < 0)
-		return ret;
-
-	return nvme_sc_to_pr_err(ret);
-}
-
-static int nvme_pr_register(struct block_device *bdev, u64 old,
-		u64 new, unsigned flags)
-{
-	u32 cdw10;
-
-	if (flags & ~PR_FL_IGNORE_KEY)
-		return -EOPNOTSUPP;
-
-	cdw10 = old ? 2 : 0;
-	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
-	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
-}
-
-static int nvme_pr_reserve(struct block_device *bdev, u64 key,
-		enum pr_type type, unsigned flags)
-{
-	u32 cdw10;
-
-	if (flags & ~PR_FL_IGNORE_KEY)
-		return -EOPNOTSUPP;
-
-	cdw10 = nvme_pr_type(type) << 8;
-	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
-}
-
-static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
-		enum pr_type type, bool abort)
-{
-	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
-
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
-}
-
-static int nvme_pr_clear(struct block_device *bdev, u64 key)
-{
-	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
-
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
-}
-
-static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
-{
-	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
-
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
-}
-
-const struct pr_ops nvme_pr_ops = {
-	.pr_register	= nvme_pr_register,
-	.pr_reserve	= nvme_pr_reserve,
-	.pr_release	= nvme_pr_release,
-	.pr_preempt	= nvme_pr_preempt,
-	.pr_clear	= nvme_pr_clear,
-};
-
 #ifdef CONFIG_BLK_SED_OPAL
 static int nvme_sec_submit(void *data, u16 spsp, u8 secp, void *buffer, size_t len,
 		bool send)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index bf46f122e9e1..c0762346b441 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -19,6 +19,8 @@
 
 #include <trace/events/block.h>
 
+extern const struct pr_ops nvme_pr_ops;
+
 extern unsigned int nvme_io_timeout;
 #define NVME_IO_TIMEOUT	(nvme_io_timeout * HZ)
 
diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
new file mode 100644
index 000000000000..26ad25f7280b
--- /dev/null
+++ b/drivers/nvme/host/pr.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/blkdev.h>
+#include <linux/pr.h>
+#include <asm/unaligned.h>
+
+#include "nvme.h"
+
+static char nvme_pr_type(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return 1;
+	case PR_EXCLUSIVE_ACCESS:
+		return 2;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return 3;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return 4;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return 5;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return 6;
+	default:
+		return 0;
+	}
+}
+
+static int nvme_send_ns_head_pr_command(struct block_device *bdev,
+		struct nvme_command *c, u8 *data, unsigned int data_len)
+{
+	struct nvme_ns_head *head = bdev->bd_disk->private_data;
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	int ret = -EWOULDBLOCK;
+
+	if (ns) {
+		c->common.nsid = cpu_to_le32(ns->head->ns_id);
+		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+	}
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
+}
+
+static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
+		u8 *data, unsigned int data_len)
+{
+	c->common.nsid = cpu_to_le32(ns->head->ns_id);
+	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+}
+
+static int nvme_sc_to_pr_err(int nvme_sc)
+{
+	if (nvme_is_path_error(nvme_sc))
+		return PR_STS_PATH_FAILED;
+
+	switch (nvme_sc) {
+	case NVME_SC_SUCCESS:
+		return PR_STS_SUCCESS;
+	case NVME_SC_RESERVATION_CONFLICT:
+		return PR_STS_RESERVATION_CONFLICT;
+	case NVME_SC_ONCS_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case NVME_SC_BAD_ATTRIBUTES:
+	case NVME_SC_INVALID_OPCODE:
+	case NVME_SC_INVALID_FIELD:
+	case NVME_SC_INVALID_NS:
+		return -EINVAL;
+	default:
+		return PR_STS_IOERR;
+	}
+}
+
+static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
+				u64 key, u64 sa_key, u8 op)
+{
+	struct nvme_command c = { };
+	u8 data[16] = { 0, };
+	int ret;
+
+	put_unaligned_le64(key, &data[0]);
+	put_unaligned_le64(sa_key, &data[8]);
+
+	c.common.opcode = op;
+	c.common.cdw10 = cpu_to_le32(cdw10);
+
+	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
+	    bdev->bd_disk->fops == &nvme_ns_head_ops)
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data,
+						   sizeof(data));
+	else
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+					      data, sizeof(data));
+	if (ret < 0)
+		return ret;
+
+	return nvme_sc_to_pr_err(ret);
+}
+
+static int nvme_pr_register(struct block_device *bdev, u64 old,
+		u64 new, unsigned flags)
+{
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	cdw10 = old ? 2 : 0;
+	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
+	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
+}
+
+static int nvme_pr_reserve(struct block_device *bdev, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	cdw10 = nvme_pr_type(type) << 8;
+	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
+}
+
+static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
+
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
+}
+
+static int nvme_pr_clear(struct block_device *bdev, u64 key)
+{
+	u32 cdw10 = 1 | (key ? 0 : 1 << 3);
+
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+}
+
+static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+{
+	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
+
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+}
+
+const struct pr_ops nvme_pr_ops = {
+	.pr_register	= nvme_pr_register,
+	.pr_reserve	= nvme_pr_reserve,
+	.pr_release	= nvme_pr_release,
+	.pr_preempt	= nvme_pr_preempt,
+	.pr_clear	= nvme_pr_clear,
+};
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


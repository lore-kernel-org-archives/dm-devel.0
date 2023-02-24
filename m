Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C620DC64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481459;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9xldGruzeXJrl58oAbFK61Ij6AdJSZGZx8QjEGN0uHA=;
	b=cLMcRDcV/bZ4ZznhXUusM+3QEGH82BtIss7ttsdajgKOLlaPcB137Mwms8fdYNt0WSDF34
	op2NVg2zkWK86dJa4aBbvcw14E4x696aOw1ZyXP2YL5rzQ1TDtGmIWXkQ3/cYqjDwBWukY
	HbTHFcFl9jKhaRIRv77j+dzwmlTxEHY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-QZKLrSqCNp2jkrX8LwtKSA-1; Mon, 27 Feb 2023 02:03:42 -0500
X-MC-Unique: QZKLrSqCNp2jkrX8LwtKSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C1C73C16E95;
	Mon, 27 Feb 2023 07:03:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA1EA1121314;
	Mon, 27 Feb 2023 07:03:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0EA421946A42;
	Mon, 27 Feb 2023 07:03:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3D35719465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 23:12:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7991D40C1106; Fri, 24 Feb 2023 23:12:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7086240C10FA
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 23:12:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5131E1C05AD2
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 23:12:09 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-8_iE1876PL-8ZxG4rklusA-1; Fri, 24 Feb 2023 18:12:02 -0500
X-MC-Unique: 8_iE1876PL-8ZxG4rklusA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHiQhe003590; Fri, 24 Feb 2023 17:45:18 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90wq2p-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:17 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OH2pqv034025; Fri, 24 Feb 2023 17:45:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn4h5npr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:14 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:50 -0600
Message-Id: <20230224174502.321490-7-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR07CA0053.namprd07.prod.outlook.com
 (2603:10b6:4:ad::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 59138c39-2cb2-40d0-3eae-08db168ee265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 1pyDQGUd5vVU4DWtvlAMMX9U9oaKkxcxSJXZNCTKHlEk8JtoAR0EeR5/i0SqPop/64rAxjf3kmKwO5sisZeDWuT7zw4ZrJ9FczaKqePguEt7Ybw+kHLlsC0Sf0oAGw7GGBYW9hBvLk/uzgVRHV0lNZjlae3G22lZhWKSlgn5/6ab3wAHEKmdnm0pLgroAqsmM/EOkm887+3porp69rf8twWcX1WEbiOfrw6gNE6xp0vUin3kNEQc4T6RaTy08SOr/BF22jPwWSwuY+ZCpj3SyoU+vvy1f+gXUAv2KQLaTGyALuPFviTdBMDNNAcULiXBhy35KtgLEgnqf0s8o72FzNSlEYMwgpFpos6egIQ2IQu4qa4AAeUw+ohcqjCEg4O9FhZrnRCPE/6MLdkJlRzDl+gHfy3ERmvRUxzbCiw8+abtujUQkF4XYh9RoB9PfpJd0TROimizt/YzVuMk7jMBngY8V1beY/gcpxDxv+YgSz6aIlcGINlOYjK5aQx+Cu936QHPdE7LyMpkWT0u9aoZpBtB+9L0+pfracdip7cy0GBoFTAFvnz/hFtpGfszDdDnW64GSI6bVPn0HYzN/fByplfhrh06Aghi4CFH6wpZdPkTKB/iDzOyHircZI8sHxY6+ZycUdps1JcmsBtXT7VA8ZY0n8poyIrOnh2fS3b5qF4TGzpZ1KRnDTct7CgwRMcV
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NL9rm/7SQ73RuDC+6RY13kSzRMss2XPbxwa2qTmP2TwEN/JKI1z00d9wDF/w?=
 =?us-ascii?Q?u0eKJopgQGoBALxU8qNlC8mrXPW37ZFpp2vBuG5PB6+lusoYpExc49SrIlhO?=
 =?us-ascii?Q?jQ8VcxpQX95z9g2HWuKGcL1DyXUlnB+5JnYH/J2hNRfwmY7fydzZxGwCfrIL?=
 =?us-ascii?Q?L5ojtCzOuevZHJHytb80wxMJfkHKJYmVYGZybwgTVpkMyXDW60bIvT7hxU87?=
 =?us-ascii?Q?zEawz8VnP5+vGsV/prQIBOjlNNAFLlW8giGo0kh3oGQQVd3y00xX0A5a7IGK?=
 =?us-ascii?Q?ojjNTnMn+uj38HNfOZQdFQv6nDU/SEboR5jcPRbEGZW62mlRDpKP7i0tSHi9?=
 =?us-ascii?Q?KFSLOrXZNqiEBXLiSS7ebz8bZZH/Mss2Ejd4HJrJRSI4EK+ekJ4D4zC2O+Z2?=
 =?us-ascii?Q?JyDMmg5B5YQ5KjJXYC9Ee3qm/ZhQL1D5BbIwvOzXoxtIJZAvNuAQjGOcpKCX?=
 =?us-ascii?Q?uq/AZfCWqgoaMQDmBQCScmHqjDvIDec3V3gpQSTtSQuH5X6N2Q2AuCohovgh?=
 =?us-ascii?Q?F2VqJGjHfcsAsm0Hn2CGHWbYbH1sadbPaUPqdJJYbecziaRZ8QIJicUDscp0?=
 =?us-ascii?Q?wIM8qZBmj71HL4SbTIHZ962+GHsLG3QLvEFGO6tC3EFUMek7wRKdxGfB0nQs?=
 =?us-ascii?Q?4TGeKnduGhGSvd3mI9+fSWbLLS4KnKCVfhOAPFsMmsS4ZpeDI8+NRVqgUtdi?=
 =?us-ascii?Q?wbpW8T11hkwaIzF7md75DoekPpMSF9ciPV3xG3gWA88wIbrLbLNVF9imUGcs?=
 =?us-ascii?Q?TDLhhwNHqLrN6K1U050/dTn2LAwGjM9+tXKL2EDdh9wXZtOwmmKJQE957BIW?=
 =?us-ascii?Q?nbsWQgu/1VIBAk7uhUpvOSyziRaRdRnhZAfWaVKgo+zyZKO7SQ142jvQW2HH?=
 =?us-ascii?Q?KphY0JsOaPs6BZCH6MBGW9BlvF5NJ9MbMnknGe6aGO3rs1bL537FeqTV+V1Y?=
 =?us-ascii?Q?BqNwDY2MIgJnXS0PX+QJZzHyjF5XEiLviciU5CYQYluFUuvaYmw4632er3FC?=
 =?us-ascii?Q?cE5nUq4E+eWWBvcHBhr17JKff3/0tvzcnQuE4wDvCBbFp1omSFWbwgDDH1Zp?=
 =?us-ascii?Q?XOwcxblOYo521qUC2JYvgFZsQMWXyhpLBx664ALHEubJa4ypuTfSU4iOxIEY?=
 =?us-ascii?Q?3rozKel6oxLFGMgjWkRDNhkEoSm/ofHjM2ByK9qLsiQpEB9NoIoMWBTfB+qQ?=
 =?us-ascii?Q?ah+Kz7aLMUgwwWU8QJyRLVqvztQUd1ACzh1PoRjaIYfzbciO9XCoOhEaB1mw?=
 =?us-ascii?Q?Giieu0nlQXhlvA02q0IMDhXot9+TTsX1UBhVKUhJRzdNEuQsv8ylkG3nxL83?=
 =?us-ascii?Q?S0I+D1mpULVd+eOFmxQc7Wefw1fOEg6GxIltkteTvzhQ03wHseyNVIYSgyPK?=
 =?us-ascii?Q?VKLbzqx0ggc5Es037VSDdbnZhgA9PbPjjaZWgcuCsOxTfnvccRFVmTaZLOB3?=
 =?us-ascii?Q?DPdlzUVENmJ2+Be0HM6cmCcf5SrMcTon8MnyKYTENcgeBKC4pIr88FlhvWLa?=
 =?us-ascii?Q?t19ZtoQy58hjeLnyJlZ5LxPqdOTkddwEf3OXdVNjXqyOxymlyszDK9dn6cEz?=
 =?us-ascii?Q?CaXoCBys2OwPexjCFJhNQhONHwnrnXJL6klAfReaMc7LG7PfIHN/JeIcbsZY?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?gtFI4exu8jcgcD38gs9C/0LCO+U+NNAzj6e/r9mZNFohHr/KOqkHlun6Kxf8?=
 =?us-ascii?Q?ZOTp90n3jlh+KYSeczMQNF9QKRLg6zk7X++8jIJSPoK211rnaQdNNbV2BO6C?=
 =?us-ascii?Q?jDs16qMez4CLOh+IW1KGBwrqM2H0i2sfODKN4sraw9NEoq7XO5W2mwgzoyDm?=
 =?us-ascii?Q?p4MYikz76H6O3dtVQ0uPU5ZLPYi00OMXYiotZUD8BhiAwP7tsUBUP8KvnpAR?=
 =?us-ascii?Q?zXxxZZd1/YU1+hbcXQbcHecTe2pb65wfthMVEy2wqpeeVrsjRhmjDimRAkOt?=
 =?us-ascii?Q?HDS+umj+/y5/kRMIQUm5zZuh5bNlyjILQWqt3ja9DN+pPoMceiMdNfCAZsBL?=
 =?us-ascii?Q?4rprnT/xOIr4W9r0x6Wxj0p2/LA9npCRkM79hJvpjt8Ue20MaOJ5T5GpLpws?=
 =?us-ascii?Q?1KzBv7OxMH75aud6zt6/uoUJt/oxsjLlnjbZfym50IZ/ApmO1pMT+JUaznBg?=
 =?us-ascii?Q?/fE/cq2JCbm7gy4RdxWXhFHsBmCU3s1P2NSIEYPxYF2ZFd2OfvCG+Agvlvrg?=
 =?us-ascii?Q?hz9QpEK+n+k7SpOfc6HNh9MfslRBXb6UB+/DKzGTjK7lRPeTxBZiQgcDnQKZ?=
 =?us-ascii?Q?VD+O2abJmupj8ebKOqKPVzhher+dUQrOnMDScXs9VHzPX9sseb1poqyaGirS?=
 =?us-ascii?Q?Nj91AYWhpLtogT36aKtiyi3S+2dJ97SAen7vBHuF1axG0Iv41p9OV07wZFoh?=
 =?us-ascii?Q?SNyrvZao0LcImZCuNKp2hl4TtsudqI6ZqFTInaFyP4KwK8hlHBWUE0aujg8A?=
 =?us-ascii?Q?87mnbSauLWPz1tQJd2BKTTkuxeIIhMRcD4jURRlRBIiC6ScTCvaQV5QiwORV?=
 =?us-ascii?Q?GGhupMYR6Sd6+lIx3UU4+pJg6ksFRuZfPPe9q6XCbhxiYLa1NF//Ok/+oVE2?=
 =?us-ascii?Q?FyX+gwi1A0jpZ7v18XZdVrgesMIEl811EoF8jv9WlSH934vGPXU3/aNCyA5u?=
 =?us-ascii?Q?ZbW7S3kVW0BdsLYepIIexA5LsX449w6w9Pp0y4B38W9j8w1k3kfnoOm9nUKy?=
 =?us-ascii?Q?N9o6fdv+HEhBKh0pDVZnfb7INA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59138c39-2cb2-40d0-3eae-08db168ee265
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:14.3916 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvGP/UAqOKOzO0q6eNhhLsEaLp+3csU02rgiG8zFXGTgMlVL0r21agvCMa8lnhsWZy/AlkYjzuK1gGoH9KwOJKNS5Qtfo6ZPjHfN6dwh0ro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: JvnnRt9eNraiwUJGuqKyW1z2G7sTTUg4
X-Proofpoint-GUID: JvnnRt9eNraiwUJGuqKyW1z2G7sTTUg4
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 06/18] dm: Add support for block PR read
 keys/reservation
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds support in dm for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index eace45a18d45..4abf640f1e7e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3346,12 +3346,55 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	return r;
 }
 
+static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_keys)
+		r = ops->pr_read_keys(bdev, keys);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
+static int dm_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_read_reservation)
+		r = ops->pr_read_reservation(bdev, rsv);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
 	.pr_release	= dm_pr_release,
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
+	.pr_read_keys	= dm_pr_read_keys,
+	.pr_read_reservation = dm_pr_read_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


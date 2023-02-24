Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F4BC64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481418;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6XFTDIuSczieoL3YyS/tFWQYz4dO42c+8Y+qRtJdQCg=;
	b=GbEs6i8VsHiPcfwMZ8O5lw9w245qnw2zFZ7dh+VzmF83cRzQjOMVQA/bcLbwE+HSKWwmJG
	Oo/V4MwRHYlJbe4P0c2MupLenio0vSM0iDwcXPVr2y5aWCeLCh1UVxsanIXPTyUAmpYnTm
	FJMG4ZjFkqh9yhf7V3BdfjQg/UFACKQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-ekwNjWDCPDOxTTWXhSGdSg-1; Mon, 27 Feb 2023 02:03:36 -0500
X-MC-Unique: ekwNjWDCPDOxTTWXhSGdSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33B728828C2;
	Mon, 27 Feb 2023 07:03:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E2C92026D68;
	Mon, 27 Feb 2023 07:03:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 485AE19465B6;
	Mon, 27 Feb 2023 07:03:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E069519465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C71D82166B2C; Fri, 24 Feb 2023 17:47:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEB4A2166B29
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A257395D605
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:51 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-wK3A2CDOOeaMjIc7zAHPvw-1; Fri, 24 Feb 2023 12:47:49 -0500
X-MC-Unique: wK3A2CDOOeaMjIc7zAHPvw-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHhqUn013474; Fri, 24 Feb 2023 17:45:29 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnf3nqxy-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:28 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OGpeDL030248; Fri, 24 Feb 2023 17:45:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn49sstj-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:25 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:58 -0600
Message-Id: <20230224174502.321490-15-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DS7PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:8:2f::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cef3e57-260b-401c-92c6-08db168ee8f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: VeOl28SmvnPK1pGcyf/mPW7qP78sGfuuICINECzlmeRj7KDT9AZn4dBGUFzIBwtsKg2fIBAY7My3tQ2tHN/6NUp+yTfrLphBGxKn88BnXqqr1nLWKB0FdgRvb6KmxtkU6yGsAcKVz+0NG4dyUy1JcAhRU881ajNzWGvWUztywAwIGncwaZdRWa/B8dRDQpsOZeGsZs006NKsVsDclDSuYoYchRPKQahU1etNQb9scHv5lk6aCI0088UkSIdHVCHy7VFFAOKrNmtrP6lMr/tj0dtoa9FnxAdGXcQxmHvP0/E5DERdeKR2D//o9qBja7RcBglSvdRE2gv/NEG5NGr48Fc9cH2vZu+K5N8L/zRnm498CHWegxp3+JQUXVG9NBZZNpmMMx9NhWPF8NaanTQqr22SdwveLt9xYQp5gELNzEJh4V3DSlOlv1TEm5aHalMjpOkaO98tTWSs3J9Xi+XYQDhAsbw8QZXPDEY5BX1fXZj4BZJRf63CE/fk5OynB2p+z5cHK3kw3sl8Sx5unM+y3VO8b1goE3fPVJw8rD0yyTxjxO4j3MM3wR4eidaGCFer8HGx3TKcAvvnUSDs80adLiOi16eeDrAsOGhBrXhQyzNfsPD3Y4e+dM9EF8ub8OEODxhl9kf9vWx415pNmp36H4DRM78H1X8QLICT/RKuHhjZbfI1xZfEQZzMWh1SUqgrTCZ3rm+lUEds/OW3Ybv1pQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004)(309714004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YKCHuBXsi6g0QgqoCmZlaU/4EdulvuehuIpMeq6FsDqRDSs5rPFxredC9JW7?=
 =?us-ascii?Q?pRf94Yv0yKPrJGFefDP+l2Eojjs/yrOaDvFUUmxZvZrt1KZZVJ84StJt1oo1?=
 =?us-ascii?Q?zgG0PYKsa6kXKkfh4+DNwy87uj+bIwNM0WL3gH2rSFSvx+qGWB1seDZWnt7O?=
 =?us-ascii?Q?R53J4F5CXp4Pc3+/14JOePjHNwhH8juomBUIs9ZFPIwutXiyfeSa49SUiVHw?=
 =?us-ascii?Q?CAANSn+ckhFYiJWO6YLyUkaTZq2W+uCnJ6lF0QzuZHNqpxfBLkOkOkN0gIsV?=
 =?us-ascii?Q?TiHEGx6wbv6qCrYB6biEBejjCbks2M8l+3rRmdYbpXN5dMS0ooNUycpbAv7J?=
 =?us-ascii?Q?H4XyW2PbOPkoGvFPePODFuWw72LOXc9Tc6vpe+h+JOJmsZiNyjcd2FfSaf8V?=
 =?us-ascii?Q?Fi1leSqQSz0di1AhW1odY26s3wfZv0yjMKSCkcDEznMGsg7nr1MIy51atXgC?=
 =?us-ascii?Q?D/uoEUdwePyWFpY4RjzlDbKYClWi0adFYFlLnD6kti36mjR/Y4nCbx4Wer7t?=
 =?us-ascii?Q?ZOFyTTCIgPVGk7901kSMPHSiYeXxlJgENGEA1KYDRYdUxELPkvPhON/0SMm3?=
 =?us-ascii?Q?3IFsE4VHsoSyhSQwflembD2tjmmh4ygxoNqa4UShj/SILYKs+T91N6rggXrD?=
 =?us-ascii?Q?MgGWDj2ganOQJs/mYxZ3OFLGQ59ahtsIE8hIEOHdZSGJJqsSU7P6f6/0Pu2L?=
 =?us-ascii?Q?qCKwpYh+ve0RDt12V6nUCBAJ5kxkYEesIpobbJfm/3aQjawcpicoiWTHra6z?=
 =?us-ascii?Q?dFHd8f8Hc1vsJI+Q09qxl9BdVp3r0yLn7gSvhQlXkI0+2xMuS5JLL6qP6lPE?=
 =?us-ascii?Q?snnJeAdP5ymvzvyO2tBN1vHep+nfj28sKq8okOpKxFz6IFJ727rTQW3clWyo?=
 =?us-ascii?Q?3blCQSL2c2lE4HoSsXeIXK0nklBASEEp1zcTwbwOojJm6KdP8igCMkmVkTFO?=
 =?us-ascii?Q?bArun0V18GAPsJKjBj1ck2GUwogM5La4wvJQqPPUtTimbgg2lFBBqKURFDaK?=
 =?us-ascii?Q?4DFZS2GtP9wcW/rtGm4Uc/S+Z9KegElRlXb35xV2Zx4qQpAPYqvgmyqvwFfX?=
 =?us-ascii?Q?/CUH4mFwwI9Gf0EyWVup1XRMJkBNnW6SXhC3oUAkAZVf29oC0TXpqDK27Qv0?=
 =?us-ascii?Q?KBKxM+ABHbfLCy0U20Rf9s3d1lc3YuwJJ2jQNweY/soB0j5bCzulazhAzTbd?=
 =?us-ascii?Q?HwVMTFmLi9OR4iS3Nt/xLNAzSmNXTaiSqI7LtJ6YFKfU2jXOdoDFmghBy+qZ?=
 =?us-ascii?Q?bvtU+/CqrwERQgeR59v5dRFmBlKOTupBlLKqkdBFfw8BJwz4xEWmMvNqdX9h?=
 =?us-ascii?Q?t0x/7pA+uld3Vo9dHfBqU2KcKNpKbQwvTLslA7j8ke0j+GMLZBxeLOn7CadN?=
 =?us-ascii?Q?bLRpKCLbe3iVcNxMRDNra1eM4m2Ld/0KQVKXh6FpA/+w+3ETZawftd+W8rfd?=
 =?us-ascii?Q?ZqS4bKt/aJ4Zofjs7EbdobFrbNSSIzu+15nxDP4sct/6a5p5lvThzmoPssfC?=
 =?us-ascii?Q?td7DU9A20/MsKkhmEEDH9OhcH/Gg7LGb1kuJTOWNed8C5R//zaPd8HfApMqm?=
 =?us-ascii?Q?juqdCaQlZGNBMNtGDwmxcutIcb4grDzAz9j15la2EE9fYE7iy7Som8T5mXhm?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?TwK901Rbg2MjxuTBDiV9jX94m6+YUgx4T8EXJjgp0pzDjjPbXOK4sTUYdHA/?=
 =?us-ascii?Q?BfurBFHPj/jrmrve3Adk7FcVz/65typJjqImugDiciOxFEeHVgFomaSJaXaG?=
 =?us-ascii?Q?4uAYQXHOayDxfJAi/wlbW0og4gXFW5rtJ/8Medj9xAzvNv40HyDfNBRKsxb1?=
 =?us-ascii?Q?3L7Fqs034JbYMvRFos/2mkwDF3gt41y0nPoCe9smkGWpDUuxo6VDYSL5RUJE?=
 =?us-ascii?Q?rQFK9LYQ9VHuyPNY+XP94x3rVsO32p15AbwY80evGhGOBlKpZfgaso3tKr38?=
 =?us-ascii?Q?G01kXRQOA2BDbp/n7L8lTR7YI8IN/FSnpSODgc3ksj2fmPXO1pdm8X8hxzq2?=
 =?us-ascii?Q?30rlQKLKa+GowtOxJQ3DODPeCmDAQac8NVtTZTneXTnrvrzxL6S5qAoYqdjb?=
 =?us-ascii?Q?+O9qs+2nlin0GJ+jOqFAfYMzNdlhpdPNWfG18F8+rxh7q4VyN8BZSFZfQw6F?=
 =?us-ascii?Q?eqHNSOSmCMsc4bDdTIg6WvzGenOXKU+mfDhy6yqeb8ywCKIwGuEcpy4f2d3h?=
 =?us-ascii?Q?aVgsq8i9AGOOtssrY6VS9pkSaxvDTa9pAcaCOINBDJ9bRLUdbcRX3Tnop8uY?=
 =?us-ascii?Q?HYhgTxwR8v25uD2t+l6wDfcfCUHLURJhxG5AGb8L+e5WKJr6D3of48i4iJUC?=
 =?us-ascii?Q?vlXeJpzcajuoySXVhGfCNd2zZkwgijF1qRlDgPgFN1W42QNojwlXYArCDaPN?=
 =?us-ascii?Q?1I/PoV9ShFjx+s30Jp3dH4EgkUxeK8P1iA8erSNQ4mCG5FXWc5Z+5H5jW6l6?=
 =?us-ascii?Q?9QqwPJYbQjFlg8C+vhe/E8IJjXN+W0N3sVUpftV1xvbMEnqG2ux8xB64qwPR?=
 =?us-ascii?Q?2RRpuXwJHdbWgE+JG0Jnaj+KtU1icF5bA0a6QBK88X7iMOsseuQXwhpbzH2U?=
 =?us-ascii?Q?6CX//0+R5OIPQ3GlhtMdDDfy4g7hIXM8OoGJ0souMFFQPPoNFG9IpDK20mZ+?=
 =?us-ascii?Q?neUh8ClXw+ad8Omzsr5HxEonFFd7Yx1C4iQUaKmzBj3YYoOOz9tZ9r0KETc7?=
 =?us-ascii?Q?UBrrUFJ4sY6GKltJ6fJAbsi/VA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cef3e57-260b-401c-92c6-08db168ee8f3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:25.4219 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Az+amU+flHM5oqLNBMUED3wV8Pk4kTWt1N1Y0+iOVhastxU4g0pPWoY5rEgurpaXfJ3sDUxp93Xj/K2d3I4yYyMaZE4VzKXUgY9r7QZkLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: i9TUW7fQHvuZhenNvcZv5DvzBLXZCRW6
X-Proofpoint-ORIG-GUID: i9TUW7fQHvuZhenNvcZv5DvzBLXZCRW6
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 14/18] scsi: target: Rename sbc_ops to
 exec_cmd_ops
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The next patches allow us to call the block layer's pr_ops from the
backends. This will require allowing the backends to hook into the cmd
processing for SPC commands, so this renames sbc_ops to a more generic
exec_cmd_ops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c    |  4 ++--
 drivers/target/target_core_iblock.c  |  4 ++--
 drivers/target/target_core_rd.c      |  4 ++--
 drivers/target/target_core_sbc.c     | 13 +++++++------
 drivers/target/target_core_spc.c     |  4 ++--
 include/target/target_core_backend.h |  4 ++--
 6 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index ce0e000b74fc..4d447520bab8 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -896,7 +896,7 @@ static void fd_free_prot(struct se_device *dev)
 	fd_dev->fd_prot_file = NULL;
 }
 
-static struct sbc_ops fd_sbc_ops = {
+static struct exec_cmd_ops fd_exec_cmd_ops = {
 	.execute_rw		= fd_execute_rw,
 	.execute_sync_cache	= fd_execute_sync_cache,
 	.execute_write_same	= fd_execute_write_same,
@@ -906,7 +906,7 @@ static struct sbc_ops fd_sbc_ops = {
 static sense_reason_t
 fd_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &fd_sbc_ops);
+	return sbc_parse_cdb(cmd, &fd_exec_cmd_ops);
 }
 
 static const struct target_backend_ops fileio_ops = {
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index cc838ffd1294..d93f24f9687d 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -869,7 +869,7 @@ static unsigned int iblock_get_io_opt(struct se_device *dev)
 	return bdev_io_opt(bd);
 }
 
-static struct sbc_ops iblock_sbc_ops = {
+static struct exec_cmd_ops iblock_exec_cmd_ops = {
 	.execute_rw		= iblock_execute_rw,
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
@@ -879,7 +879,7 @@ static struct sbc_ops iblock_sbc_ops = {
 static sense_reason_t
 iblock_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &iblock_sbc_ops);
+	return sbc_parse_cdb(cmd, &iblock_exec_cmd_ops);
 }
 
 static bool iblock_get_write_cache(struct se_device *dev)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 6648c1c90e19..6f67cc09c2b5 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -643,14 +643,14 @@ static void rd_free_prot(struct se_device *dev)
 	rd_release_prot_space(rd_dev);
 }
 
-static struct sbc_ops rd_sbc_ops = {
+static struct exec_cmd_ops rd_exec_cmd_ops = {
 	.execute_rw		= rd_execute_rw,
 };
 
 static sense_reason_t
 rd_parse_cdb(struct se_cmd *cmd)
 {
-	return sbc_parse_cdb(cmd, &rd_sbc_ops);
+	return sbc_parse_cdb(cmd, &rd_exec_cmd_ops);
 }
 
 static const struct target_backend_ops rd_mcp_ops = {
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 7536ca797606..6a02561cc20c 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -192,7 +192,7 @@ EXPORT_SYMBOL(sbc_get_write_same_sectors);
 static sense_reason_t
 sbc_execute_write_same_unmap(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	sector_t nolb = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
 
@@ -271,7 +271,8 @@ static inline unsigned long long transport_lba_64(unsigned char *cdb)
 }
 
 static sense_reason_t
-sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *ops)
+sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags,
+		     struct exec_cmd_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
@@ -340,7 +341,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *op
 static sense_reason_t
 sbc_execute_rw(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 
 	return ops->execute_rw(cmd, cmd->t_data_sg, cmd->t_data_nents,
 			       cmd->data_direction);
@@ -566,7 +567,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 static sense_reason_t
 sbc_compare_and_write(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 	int rc;
@@ -764,7 +765,7 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 }
 
 sense_reason_t
-sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
+sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
@@ -1076,7 +1077,7 @@ EXPORT_SYMBOL(sbc_get_device_type);
 static sense_reason_t
 sbc_execute_unmap(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf, *ptr = NULL;
 	sector_t lba;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index fcc7b10a7ae3..00d34616df5d 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1431,7 +1431,7 @@ static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
 
 static bool tcm_is_ws_enabled(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 
 	return (dev->dev_attrib.emulate_tpws && !!ops->execute_unmap) ||
@@ -1544,7 +1544,7 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
 
 static bool tcm_is_unmap_enabled(struct se_cmd *cmd)
 {
-	struct sbc_ops *ops = cmd->protocol_data;
+	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 
 	return ops->execute_unmap && dev->dev_attrib.emulate_tpu;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index a3c193df25b3..c5df78959532 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -62,7 +62,7 @@ struct target_backend_ops {
 	struct configfs_attribute **tb_dev_action_attrs;
 };
 
-struct sbc_ops {
+struct exec_cmd_ops {
 	sense_reason_t (*execute_rw)(struct se_cmd *cmd, struct scatterlist *,
 				     u32, enum dma_data_direction);
 	sense_reason_t (*execute_sync_cache)(struct se_cmd *cmd);
@@ -86,7 +86,7 @@ sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
 sense_reason_t	spc_emulate_inquiry_std(struct se_cmd *, unsigned char *);
 sense_reason_t	spc_emulate_evpd_83(struct se_cmd *, unsigned char *);
 
-sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops);
+sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops);
 u32	sbc_get_device_rev(struct se_device *dev);
 u32	sbc_get_device_type(struct se_device *dev);
 sector_t	sbc_get_write_same_sectors(struct se_cmd *cmd);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


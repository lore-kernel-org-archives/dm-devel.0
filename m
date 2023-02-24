Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13BA9C7EE2F
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481427;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V2iwBRi7A84ET6Hq/9CQvLV7khGwNlw7xJ2sz0LSTuE=;
	b=gYXmk7guSc/BAFZzuszF4bQdKpXqQTV3nIVVc3C8o1HGsVTZ5mg1SiTL+RVqRdbI9Md+zs
	2GOz0n6ZDkWaq+jPTBNFbiyrErpd52bs518HbKpSOTbJavNo50JgipFc2+GBOGXAqme8DS
	qlv+pQTBSKoMOxqdVBm9mx28yU/fLng=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-C5J5vTKpMLatUg3HIbcHUA-1; Mon, 27 Feb 2023 02:03:43 -0500
X-MC-Unique: C5J5vTKpMLatUg3HIbcHUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FC0888B7A2;
	Mon, 27 Feb 2023 07:03:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B43240C6EC4;
	Mon, 27 Feb 2023 07:03:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C2C81946589;
	Mon, 27 Feb 2023 07:03:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 71B9E19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 583EC2166B2B; Fri, 24 Feb 2023 17:47:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 27AE92166B29
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02CF3101A521
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:58 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-18dF4XISMauS2s751EPhzg-1; Fri, 24 Feb 2023 12:47:48 -0500
X-MC-Unique: 18dF4XISMauS2s751EPhzg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHiefq003747; Fri, 24 Feb 2023 17:45:31 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90wq33-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:30 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OGY1aU000677; Fri, 24 Feb 2023 17:45:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3nxsb4kud4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:27 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:59 -0600
Message-Id: <20230224174502.321490-16-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DS7PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:8:2f::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 285362d2-2404-48b8-e245-08db168eea0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: oVgdryvOEQXlk3E+F2lSP/t1zLjB8+QOVJ9qCunX9YY+ZRU2AFzFS/wi6ZzhgIoZsD55RpU8O9640acgJgfitBvDSetqNY1Owg9Bijx6RkRDV4kq6nd5xW2gbJKJ5UPd8slgSWDvQZPJN1aIlaeJRw+4CgyubhbnzY122En5MgnMPG8pNdWSwJ8/rj658jH0lzZg87LQIe+JFxCl/gPj1Z+Lcb4EtwBns/0+CEtfGFHWc/deoZrI7OKFrerdFoMOdknm+KF5sz8FHTSmlooMj6xHiXGqA5sBm5LI/xdf2Fisi6MtUyEGRaScWz0aYZOp1HvLEbrnOvE6nhGPQpBpEzjS+Ay026taY/NXuZsIE5FEUzzRza2dyUqcrm+Tu6FLUnfW7jH0HRDer4nfTBA9+tjOVwl9jMPtpKtsj55EDN+5X2s7EksMSyddKdgS94dS9Wy9zqBBDjj0wW8lmcDEf5vlBE8w2ty01dKkU245r064wL2inp+2EmfaAaregZc0ZSK5I+fkI24za5tUHsd/KULsb4XtzuCNxJStwBHCDwBMOSuAk7zPwoQgE2DhFKyZYtEs95Jrsrwq2wnGN+SfwwgH29C/HlKNFmYFNyGOhRVZtGI8w8n8GcLNX2CMTIqYvFKsRlf20dfzHGCQ9j2a5h4tZMW7iXoFtOjoJNcMHJtW6cAKjDUdLg8fgpJote6v
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J22mbhDHVbf0grECr3l2Bkennp2Fg1ONRhEmefLGX4dypTp6mYQx18GytEak?=
 =?us-ascii?Q?+zZCOdElvMG60n6MI2axD8L6ETwbng/jsw1D1LIDG8I78mP0DHqjLyG2y32q?=
 =?us-ascii?Q?+89V1Tag0HpDHf1gSOJu44TC5TpUJLV9GK5AV+4lh6Z5oO3ee/poOy6QHUYg?=
 =?us-ascii?Q?IzvYsJnXKcWM/CUo78OKO2dzW4OWPQIJmg/z9E1+yibuqFM9ZjRq4MKz1pTd?=
 =?us-ascii?Q?YzFYFNDgjt0QLQLzsL0pn8fuufBumMV/HH8jaJw3LwrtSbujF/urPhqpmXwZ?=
 =?us-ascii?Q?6mLBq3tM/kiG12tT7dlqElTJhxZcnFvzC37jDBhUpq2gkHWmiXZdNyq4MbxQ?=
 =?us-ascii?Q?Dph31SF9zaZpqcslLNPBUF6DIOGBiFvcZSn0/aj2J97OSH2o5Jr9hP/Ru6YD?=
 =?us-ascii?Q?xuuekNzOmEytCGotrtx02uTKMtubEoOASzb/l5SQ223+3Cv+xWqcSJuOOXvV?=
 =?us-ascii?Q?rt1XJ1HzQGNEMV6hDE5FnOf5gZCM8csb7thw5IIi+dYkXaROqhmdnaNJzGGu?=
 =?us-ascii?Q?PDSDOdbsTI1ehDpw76hJhUcuf1HtyauTzOvd4xF6bkurcIlSl8XnRMAzmufu?=
 =?us-ascii?Q?iBak7sCgLA+9z8Dy6BjrHa9aAMl0yrYeNh5ppVcFaZWLfDL3m6dg+pFXgdFU?=
 =?us-ascii?Q?5JGNbz4udKj5I7yoShZC1NxEua5exnmrcX/L+onM0jBl6A6+mwjiW7nvJ5cW?=
 =?us-ascii?Q?5Igan+1twugzSy/cNSlJE90bZYZOx537882Pm55teh3F+wnxmuTZYYtRcSX9?=
 =?us-ascii?Q?HeePlT7QGgOR1P3sYXiB2C5VLHvWRiOSe2FnS6d4V6fbx9foLPT9VgsjZhNP?=
 =?us-ascii?Q?Sy0Ns0Af5pDI202r3Fwedb0JLKMqY+gxYXG5DCjmlYPoqUctBHX5XRc073x8?=
 =?us-ascii?Q?ZH1Q6OKK79qSD+LY19VyfT7FofBCs3FnoTXnZmwNWEyFvWHhEo70T2RF1tbb?=
 =?us-ascii?Q?Zav9Cp4aLcZATqlw7Duw/OoYSlCF96A/QGc+onQ9SrmJ+5ZkYbtCkEYOTKrU?=
 =?us-ascii?Q?QiipAHgt4S1ZGTrdyd/GmF+a+eUptSXMkD8ObnZCUWjmD0n6eWaFGPbRjmqR?=
 =?us-ascii?Q?pfBu+P4lPsgGYXxiiJfHxYtrab5b7GTYiLb/Bh2+1sW3xFOrofkL00pnjJEJ?=
 =?us-ascii?Q?T+9Qa3abI6uK2/wWurWi3wUYTillgERmdHiyiuxdTLIuaEaP2XmU/PxlOIgO?=
 =?us-ascii?Q?OpKguZnMfPOqnJjnZFiuGmbzFVU8wt5ebfvS0900QUPut3ooitfcphJMEBJW?=
 =?us-ascii?Q?su7UbR0L058/RrkgY70tSbwizGJKOMzKkDK7Y6B1wp8ipW+FV27S5cm/ugDE?=
 =?us-ascii?Q?qQOiPZThukoiHPZIsuBsQh1P4YhGKHJN6HBHyn/NuFscwvSubVbb3Laccrj6?=
 =?us-ascii?Q?CN5XENgK3Ejv2fShPFdPxAQj61qeMfWj6s6Ui24bfV7YNOGRMPPNRwAMhXNO?=
 =?us-ascii?Q?ZXI1OupIiMuznMmbX7YqCNwxZwToA6Ljtz7F7nQWS9Vfm5vy3KLKRY28ekp6?=
 =?us-ascii?Q?5Qdo05z7C4OoxeIUMINLz96wojP3ztY07pGnTHmPX1Yw/jG2xDTIM8VfNSRN?=
 =?us-ascii?Q?NexT/g3upAxiVxzsiYaT2gYLa8LiKJ/i98SK2rBWRmnl9u6617sFJXV2JnmX?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?9KjtbR8JWDsTlWKCasyjy+83cGiunRNmTwV3jgN20eWHZWZzFFT1SKgmgBww?=
 =?us-ascii?Q?y2/cIYF/39fXgfopAtkK2NoTUJYNkKkDXnbWKuptxQg6unvvPZa2uLtbzTEh?=
 =?us-ascii?Q?5KkASyqrqXV/u2U1pt2jcZpPNLJu4P2c96Se/s+EAJnSveHVkp/jSNIvKXw/?=
 =?us-ascii?Q?RF0+w5WC+eUz2XRI6qCFV8Xg3eWSl7piHW21AUC0DxS/I8gwf8nJ+tXSUGZK?=
 =?us-ascii?Q?OJ7lPdEEYO0q+ECE1j6B8Z4rLexIWZ+A5KEjkV7Udwc319Kt2eYm3w7y0kqu?=
 =?us-ascii?Q?ECppurpna/H1MqSHjulNThahGoKdLjiNGHf6t6At6BE2apPq9xwO0jQJ6Cuf?=
 =?us-ascii?Q?X7m456nAfAtL0URgjRfGIVP1qLv8J9XLO+SOTY8XU1dB8ynoaqrCHxPzEMed?=
 =?us-ascii?Q?mN+SiEdaCFlKEdB/bXb7pPvzTrat3hPjilIjkxy7tmWiZlgxmUiyjZYYnpY+?=
 =?us-ascii?Q?mwnHnia8dyffnKZbemGVGACA36Lw3na3vNtM1M+ez9HomufsOmgtqIWPtBC7?=
 =?us-ascii?Q?ogeh14oIjHY4HUQuemAoerDcuI4N0YiEzdGvqnUDEkbec8o72DeeL0JkB1n0?=
 =?us-ascii?Q?9hv8oR1Ew9DceEhsCm9a6a5LvP1Fl+DWd4rdwbP12RO0CAusLazyIKR1GaGy?=
 =?us-ascii?Q?BL5Je6LItpk1eSV4wS2C1WBlCoT1ZfTwgvPKK+pkHSkUx8u9qxcSPUcxTTEg?=
 =?us-ascii?Q?rp9whjAyNZej/yLK6h2x8GO/NYK+u2JZ8uUXJnkcWqhFaHOhuKz9FQGDq6eG?=
 =?us-ascii?Q?1WG55855/0Q4+fWmuwZrOG177Pu3alngCNp7x8NduBXreTkcca77Nmz6QXk1?=
 =?us-ascii?Q?+lhB763KeTlqChFzJi6EoG9FJaMyF1L6FuaPgZfoaiuvxzcBvL8QFnf82HGd?=
 =?us-ascii?Q?LzvCld8T7D3zqVai9NcqZJfeIApE+IQxPp7uuvI1dGrbhwNB+oKv+iSlW9Z2?=
 =?us-ascii?Q?zqYxYSW9ZDTcdTMff3SQf+vbVjPa4IbXrTim4uKlflae7INaYwyilxZaHPTQ?=
 =?us-ascii?Q?5JwkaCpR2NnIH8z8F0uk5Wc1oA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285362d2-2404-48b8-e245-08db168eea0c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:27.2343 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zl2NCOXCrbWaVVP+i1htnu1n5rISXN0JKLb9RPUqwXEnSh2VnvuQkP1l3td4kh4xu0EShLp0KR/4VCJtZaF+ekAzze3EdCatHnfn3BaBmoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: 38P5-lKG-6sON0AgWk2VisCtPxgpEdP9
X-Proofpoint-GUID: 38P5-lKG-6sON0AgWk2VisCtPxgpEdP9
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 15/18] scsi: target: Allow backends to hook
 into PR handling
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For the cases where you want to export a device to a VM via a single
I_T nexus and want to passthrough the PR handling to the physical/real
device you have to use pscsi or tcmu. Both are good for specific uses
however for the case where you want good performance, and are not using
SCSI devices directly (using DM/MD RAID or multipath devices) then we are
out of luck.

The following patches allow iblock to mimimally hook into the LIO PR code
and then pass the PR handling to the physical device. Note that like with
the tcmu an pscsi cases it's only supported when you export the device via
one I_T nexus.

This patch adds the initial LIO callouts. The next patch will modify
iblock.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_pr.c      | 62 +++++++++++++++++++++++++++-
 include/target/target_core_backend.h |  4 ++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1493b1d01194..e16ef7d676af 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3538,6 +3538,25 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	return ret;
 }
 
+static sense_reason_t
+target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
+		     u8 type, bool aptpl, bool all_tg_pt, bool spec_i_pt)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	if (!ops->execute_pr_out) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ops->execute_pr_out(cmd, sa, res_key, sa_res_key, type, aptpl);
+}
+
 /*
  * See spc4r17 section 6.14 Table 170
  */
@@ -3641,6 +3660,12 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_out_pt(cmd, sa, res_key, sa_res_key, type,
+					   aptpl, all_tg_pt, spec_i_pt);
+		goto done;
+	}
+
 	/*
 	 * (core_scsi3_emulate_pro_* function parameters
 	 * are defined by spc4r17 Table 174:
@@ -3682,6 +3707,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
@@ -4039,9 +4065,37 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd, u8 sa)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+	unsigned char *buf;
+	sense_reason_t ret;
+
+	if (cmd->data_length < 8) {
+		pr_err("PRIN SA SCSI Data Length: %u too small\n",
+		       cmd->data_length);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (!ops->execute_pr_in) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	ret = ops->execute_pr_in(cmd, sa, buf);
+
+	transport_kunmap_data_sg(cmd);
+	return ret;
+}
+
 sense_reason_t
 target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 {
+	u8 sa = cmd->t_task_cdb[1] & 0x1f;
 	sense_reason_t ret;
 
 	/*
@@ -4060,7 +4114,12 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 	}
 
-	switch (cmd->t_task_cdb[1] & 0x1f) {
+	if (cmd->se_dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_in_pt(cmd, sa);
+		goto done;
+	}
+
+	switch (sa) {
 	case PRI_READ_KEYS:
 		ret = core_scsi3_pri_read_keys(cmd);
 		break;
@@ -4079,6 +4138,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index c5df78959532..739df993aa5e 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -69,6 +69,10 @@ struct exec_cmd_ops {
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
 				sector_t lba, sector_t nolb);
+	sense_reason_t (*execute_pr_out)(struct se_cmd *cmd, u8 sa, u64 key,
+					 u64 sa_key, u8 type, bool aptpl);
+	sense_reason_t (*execute_pr_in)(struct se_cmd *cmd, u8 sa,
+					unsigned char *param_data);
 };
 
 int	transport_backend_register(const struct target_backend_ops *);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


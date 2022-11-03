Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB53CC433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462247;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UF+10+0mnB/cWUBSFn+fWA9xBgDevuo+4VVlC6GvQ1k=;
	b=P3G3uCW6aZ7cenj/lGqzqgiEBEI1tuO9/WnViJE+h9F4QNTzsQFSk7OzmQJA7rWFKvTgmv
	mtVhcFxOLDanpZbrmuW0n0iUbaeFp+19vAe6j/JBG0hCPt2aEYkPci47R+zzE5GTKOQP6d
	t3xEyT1AaetrWccOCHSrsNDfHub7hiw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-YFWOYGtOP2iorSeN444pzA-1; Thu, 03 Nov 2022 03:57:23 -0400
X-MC-Unique: YFWOYGtOP2iorSeN444pzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7C68857F90;
	Thu,  3 Nov 2022 07:57:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C2FA140C2086;
	Thu,  3 Nov 2022 07:57:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B94251946A62;
	Thu,  3 Nov 2022 07:57:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF7261946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 02:13:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38CEE40C835A; Thu,  3 Nov 2022 02:13:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3035840C2086
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 02:13:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FE4F1C06EEE
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 02:13:51 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-IatnFrrDOECsTeEvAEF_0A-1; Wed, 02 Nov 2022 22:13:49 -0400
X-MC-Unique: IatnFrrDOECsTeEvAEF_0A-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2MlvHd029528;
 Thu, 3 Nov 2022 02:13:35 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussuf28-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 03 Nov 2022 02:13:35 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 2A31JhQc027210; Thu, 3 Nov 2022 02:13:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3kgtm65s8r-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 03 Nov 2022 02:13:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ2PR10MB7013.namprd10.prod.outlook.com (2603:10b6:a03:4c0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Thu, 3 Nov 2022 02:13:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 02:13:32 +0000
Message-ID: <7b8cdc82-0aca-2f41-2eed-299dacf95771@oracle.com>
Date: Wed, 2 Nov 2022 21:13:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To: Bart Van Assche <bvanassche@acm.org>, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-4-michael.christie@oracle.com>
 <0123db70-6217-135a-4101-0609512e723b@acm.org>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <0123db70-6217-135a-4101-0609512e723b@acm.org>
X-ClientProxiedBy: CH0P221CA0041.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ2PR10MB7013:EE_
X-MS-Office365-Filtering-Correlation-Id: 2641cca6-7dd2-4563-0b21-08dabd410143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: f/5a1oNXTsl9Oks3XiHDcwkNoLBA1bfUbaF56STiBxHw8lUB0o2FIPKaEDW/lh2X7P1rgVh595g9doR9XW4iR+bRSFJMbDLPbVc/ot7PSkGPeN3OhHE4YLoWyiLS1V0Dn4Vt1IX8rfAWxUB/jQDPLMRAaOoveZBQGDXHtnYe4aYkwDUZKYQ622kX4bRUMsrg255kfovFMq8gPiGI+QGXRgH0QF1bk1Oy+eX1W2GLTw5Hczpm5qiCVeoJzxvrLtLIuXA4LVIM/6XBQa5sCuTTSlA3w1B78XDJAYlwoIoQrSyUGQXCh5mFPA1XpFKJ5ZZHHylKXpE8TKGLz4pNdKPaxeI05Q2HMaDgTCUjWMr/4gnTJ2HkZm0/LdbddHQO2R8hWm6vtHMaIDbEwP5+z+VP41kc13trAjHFcJbaOldJYeLWtoMT09af5SvvJcgex+27U6zKAKvoOtwYcRvAOO+7l8AjwXU0I3OvlJ29yojoG7M2L+aC0caDdotVCyQSsbAsOLXTbOrXAnYD8WSJJ+OEoSJZnNSLAMBeCFoI1uXt0wWRiJdD1GpeikTvwRkyWkv1tkI2sppr7YUNY7vs3oz5rDI4/GG8IvO8YhcqaELSz6hKL5+164hbZedmlo7h2fsOLbILJ4nBUeycImFHa8LgZtzELZ/19897b/jLqWleDxdS5Z2ojJvOZdxZy2IwYvrUEzm2Yr1E0h661Pocc742Oh7lyHvmZCR0SoDCCMBroe8t8LzYyv+r9ucau6CwIFvwTXyj9mpAw473qeqtfXeFpJrJ20QyTBV93qQVo9y4Hzr7fmvmTLr64hX7zMx6reui
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(31686004)(38100700002)(5660300002)(2906002)(86362001)(83380400001)(6512007)(7416002)(31696002)(921005)(2616005)(26005)(66946007)(186003)(6506007)(6486002)(53546011)(478600001)(66556008)(66476007)(316002)(41300700001)(8676002)(8936002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFdNUTlnNlRJUmpPMklCckl2Q3hNVGtWZ1BFcDRCOWUvNTFVWnV2SmFWSFNG?=
 =?utf-8?B?SUtoQnBWZ2VSU0I2N08rdCtyR24rR1RPR3hzY2FMeWUyQndrL3dvNlpKb0N0?=
 =?utf-8?B?WVIrVU5zYWUwdlYwR3k4b010enNEczNqM2w1ck05STdzRE5leVphQmdxZXB6?=
 =?utf-8?B?Y2ZnRnZpSXlaNWJyMzVuRUM5QzlnUi9jU2s4d2hPNm1iUk9RVi9CQzFBQ1BH?=
 =?utf-8?B?UGZvU1g4dzJsWmpmUFJJdEhmVGRNVW9UMm1pYUtQdVlCZEdoSzdObXFXL0Z1?=
 =?utf-8?B?dHVGSjJ4RDZrNGVmaFBoNFU5UlErWnVsQzQ3NWpHb2ZCclhZMlpuNzFRR041?=
 =?utf-8?B?cGJ0RWduSkQ5WDVkR01TTmdqOHIrdU1OaXVuWHR2aGk1OHB3TVluRlh4VEMz?=
 =?utf-8?B?NDB6a1FSS0RFenEvV2p1MWEyR1hMZno1anM5RU40bmhlQTd4cDBxYlhpUC96?=
 =?utf-8?B?T2pSTmVTZ2V3KzV6UXU3K2NYMUlPbTBNQ0lYNWRRdjB1cnFKSWc5MS9YYXNi?=
 =?utf-8?B?cTlkZ1dLOU8zcFROS25MN2tLN3R6b1pCN0UvNkxWVGFOdXFuTTNXaXJVNU5N?=
 =?utf-8?B?UWs2cVV5cDBEbHlqQzRXZDlGdllxQzcya2JnbWhjR2tzaU1EUjUySyttaVFO?=
 =?utf-8?B?Yk5iSmxIZVZ3aDR5RFdTaHMxVytjWXR4T0I0QUdnWVJ6cDZkS1FpTnZoeWcy?=
 =?utf-8?B?ZFBBR1VybTlzcUppY04yQllpVzVZREREakEzcVZ0K2RpOEdhNVovQXJNQVdG?=
 =?utf-8?B?Z2IvUlhoZU9EZG00V2xXSVdEaUNOdk1FdGhRVitPU0t2bWJqandYSytFN2RZ?=
 =?utf-8?B?ZVB1OG1SZUlmTFducXBBMUVWa3QwTlY1Uy9UcWVJdUpNTGcrYXh2SFRha2Zk?=
 =?utf-8?B?M1pLTTlmd2lQOTB5Szg5TDB4UFF3bElSVzhhZGVnMWZycHAxd0FaYXJjcDNY?=
 =?utf-8?B?eTV4bGJ6cHZ6OEczWVUvQlNwaWhQZnpYY25wNEphZTNMVStacUVJWUlCNmZI?=
 =?utf-8?B?ZGYzdEMraXNtOTJ6NG9JWXJLVkpsUDc3WE8vM0xPencxOGFFTE9Sd0IrQU1u?=
 =?utf-8?B?K0dYTFVEb2tMQjRVQTlaU1MyNERmMGd3QUF4OWxzUW1FZUhIZ2R6YlVDR1dS?=
 =?utf-8?B?bjEvRFRncWlYRWhWWjJFMXZ6N1R5Szd4bVFtcnY0SXprNHFPaVNVSGpOTHpP?=
 =?utf-8?B?b1g2RkZhbUtGQXhqcko5RWpjNGNXL0FlMTFXdm5JanFnREYyK0d3N2s0bkZQ?=
 =?utf-8?B?dXhjTmN4UklzKzRZQWI0Q3VScWdPYjBybXVLTkpaMnNHS2l6TDV1ZUtsM3pS?=
 =?utf-8?B?QzJpNCtmTDAwYmJFTlBRdUZ6dllvUHByKzJ4aXNkMUxGMnd2NDNQRnVOcGFx?=
 =?utf-8?B?d0NKRm55SDhBaHRFT3RVQnNLeDg0bVJsNnIya2FLbTR5MWxmNDhqekdwYlhm?=
 =?utf-8?B?eGxpbTZ6dU9xN05VcGUrczBtTDJRS2FSKzR1L0tORnJCTnRZdXlwbUxValA5?=
 =?utf-8?B?MXIraGtUZzREeGc4aEEyTkxBc1JKRzdyRU4wNHg0bW1lNWlBZ2RwblE4NzNp?=
 =?utf-8?B?VWpwcDF3aUZNWVFnc0JMTzJsN2dqYkE2RTJJaElub3ViRHVtdEduTEtJbXUr?=
 =?utf-8?B?WHNnUzBWU3pMS0daNmVtVGw2aHIrT25KT0RSZVY1YXdxZDlpZnFIUldDUnIw?=
 =?utf-8?B?NEtXclNKanA5eWxKN25qelBVWVBHVnBMSnl6Z2N1cDYxTkhweTBtWWdFdFYz?=
 =?utf-8?B?Mzh4bFJSaWg0ZW00dFc1M2d4ZFg1UnVzQzVQM28zRnhRWHNITEpydUgveXph?=
 =?utf-8?B?cEZ6TFJnUENFS1pLVHhiaEJxeWFPQXR4WVlwUWw0VmIyWUhabm04bzBsR21I?=
 =?utf-8?B?OUlUZG9qZjBrZlJTZFB2SDNQRlJCS1J2OTdmSXI3MlZyMkN5UkNiWW1CWjFm?=
 =?utf-8?B?S0ZnbndCclhGb1haaWRJOURhTXJ0STVrcHpybDFvYjRwQVNWNFA1TGpsUWht?=
 =?utf-8?B?czgvdk02WUtHeEtGS1lkZ1NkdXNlZDRFRnhQQXN2RXZmV2JWaXpsWEdsdGFo?=
 =?utf-8?B?WU82aWZBWFB4WFgxVk5sK1dBWENvRnRXQ2pzejVxVVc5cHpxZXR1L0tDa3Z5?=
 =?utf-8?B?SE9yRUh4OU9MazFqbld3MnRSQWxxSmgycUhqa2tocjBnTnI0aDRES2RKU201?=
 =?utf-8?B?K3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2641cca6-7dd2-4563-0b21-08dabd410143
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 02:13:31.9447 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlkwOfWnNUSwa22bOpfXITFfdv9eQCmLiR9solKc3ArpkAuKy5TAv3l6ljrJMlva9FBsTE6GjyB1+aF093/6jyGrmEnLfCsG7kCdTQkpmm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7013
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 adultscore=0 phishscore=0
 mlxlogscore=961 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030014
X-Proofpoint-ORIG-GUID: dtKzmkg7tRhmQ2o6sy0YFq2nili9uuSi
X-Proofpoint-GUID: dtKzmkg7tRhmQ2o6sy0YFq2nili9uuSi
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-00069f02.pphosted.com id 2A2MlvHd029528
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:17 +0000
Subject: Re: [dm-devel] [PATCH v3 03/19] scsi: Move sd_pr_type to header to
 share
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMTEvMi8yMiA1OjQ3IFBNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6Cj4gT24gMTAvMjYvMjIg
MTY6MTksIE1pa2UgQ2hyaXN0aWUgd3JvdGU6Cj4+ICtzdGF0aWMgaW5saW5lIGVudW0gc2NzaV9w
cl90eXBlIGJsb2NrX3ByX3R5cGVfdG9fc2NzaShlbnVtIHByX3R5cGUgdHlwZSkKPj4gK3sKPj4g
K8KgwqDCoCBzd2l0Y2ggKHR5cGUpIHsKPj4gK8KgwqDCoCBjYXNlIFBSX1dSSVRFX0VYQ0xVU0lW
RToKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBTQ1NJX1BSX1dSSVRFX0VYQ0xVU0lWRTsKPj4g
K8KgwqDCoCBjYXNlIFBSX0VYQ0xVU0lWRV9BQ0NFU1M6Cj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1
cm4gU0NTSV9QUl9FWENMVVNJVkVfQUNDRVNTOwo+PiArwqDCoMKgIGNhc2UgUFJfV1JJVEVfRVhD
TFVTSVZFX1JFR19PTkxZOgo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIFNDU0lfUFJfV1JJVEVf
RVhDTFVTSVZFX1JFR19PTkxZOwo+PiArwqDCoMKgIGNhc2UgUFJfRVhDTFVTSVZFX0FDQ0VTU19S
RUdfT05MWToKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBTQ1NJX1BSX0VYQ0xVU0lWRV9BQ0NF
U1NfUkVHX09OTFk7Cj4+ICvCoMKgwqAgY2FzZSBQUl9XUklURV9FWENMVVNJVkVfQUxMX1JFR1M6
Cj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gU0NTSV9QUl9XUklURV9FWENMVVNJVkVfQUxMX1JF
R1M7Cj4+ICvCoMKgwqAgY2FzZSBQUl9FWENMVVNJVkVfQUNDRVNTX0FMTF9SRUdTOgo+PiArwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIFNDU0lfUFJfRVhDTFVTSVZFX0FDQ0VTU19BTExfUkVHUzsKPj4g
K8KgwqDCoCBkZWZhdWx0Ogo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7Cj4+ICvCoMKgwqAg
fQo+PiArfTsKPiAKPiBQbGVhc2UgbGVhdmUgb3V0ICJkZWZhdWx0OiByZXR1cm4gMDsiIGZyb20g
dGhlIHN3aXRjaCBzdGF0ZW1lbnQgYW5kIGFkZCAicmV0dXJuIDA7IiBhZnRlciB0aGUgc3dpdGNo
IHN0YXRlbWVudC4gVGhhdCB3aWxsIG1ha2UgdGhlIGNvbXBpbGVyIGVtaXQgYSB3YXJuaW5nIGlm
IGEgdmFsdWUgaXMgYWRkZWQgaW4gZW51bSBwcl90eXBlIGJ1dCBub3QgaW4gdGhlIGFib3ZlIGZ1
bmN0aW9uLgpIZXkgQmFydCwKCkRpZCB5b3Ugd2FudCB0aGF0IGNvbXBpbGVyIHdhcm5pbmcgZnVu
Y3Rpb25hbGl0eSBpbiB0aGUgZnV0dXJlIGNvZGUKb3IgYXJlIHlvdSBhc2tpbmcgbWUgdG8gZG8g
dGhlIGFib3ZlIG9ubHkgaWYgd2UgZ28gdGhlIHN3aXRjaCBiYXNlZApyb3V0ZT8KCkNoYWl0YW55
YSByZXF1ZXN0ZWQgbWUgdG8gbWFrZSB0aGlzIGFycmF5IGJhc2VkIGluIG52bWUvc2NzaS4gRm9y
IHRoaXMKYXBwcm9hY2gsIEkgY2FuIGFkZCBhIFdBUk4gb3IgcHJpbnRrIHdhcm5pbmcgaWYgdGhl
IHByX3R5cGUgcGFzc2VkIGluCmRvZXMgbm90IG1hdGNoIGEgdmFsdWUgaW4gdGhlIGFycmF5LiBJ
IGRvbid0IHRoaW5rIEkgY2FuIGRvIGEgY29tcGlsZXIKd2FybmluZyB0aG91Z2guCgpJIGRpZG4n
dCBjYXJlLCBidXQgSSB0aGluayB0aGUgY29tcGlsZXIgd2FybmluZyByb3V0ZSBtaWdodCBiZSBi
ZXR0ZXIKdGhvdWdoLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5j
b20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=


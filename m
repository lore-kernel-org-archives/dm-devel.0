Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3619C25B07
	for <dm-devel@archiver.kernel.org>; Tue,  9 Aug 2022 18:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660068521;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dG11pZXaBHtDfCCNetI4eRwJCtHnKQsx0aRtRTktwEc=;
	b=c26dxj5OUgoTiW/VYQm38xUjuyil3yH2cHpdto5TXF9TWnial8IizV2ljCGB+EElc9yvRp
	9vX25NqJkiw8HQ86FF3pCwg697sGspSZoPTUw8yiLtC5F3LFGIpj7Zakl9rUl3xKu6SPHr
	aFLvm7lM7kZlH+KJbrGwnlTRLeq+j74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-RcASdSoaOgyFv5irhfW97w-1; Tue, 09 Aug 2022 14:08:38 -0400
X-MC-Unique: RcASdSoaOgyFv5irhfW97w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F178118A6526;
	Tue,  9 Aug 2022 18:08:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95678492C3B;
	Tue,  9 Aug 2022 18:08:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53D371946A4C;
	Tue,  9 Aug 2022 18:08:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D9B751946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 18:08:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD11E1415125; Tue,  9 Aug 2022 18:08:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7A9A140EBE3
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 18:08:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C1738039AD
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 18:08:33 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-gi8q5aiQMWiHvUUWzesL6A-1; Tue, 09 Aug 2022 14:08:32 -0400
X-MC-Unique: gi8q5aiQMWiHvUUWzesL6A-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 279GdULn022309;
 Tue, 9 Aug 2022 18:08:18 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsfwsq9d2-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 18:08:17 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 279GPB4I038112; Tue, 9 Aug 2022 18:08:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com
 (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hu0n3stft-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Aug 2022 18:08:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.17; Tue, 9 Aug 2022 18:08:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 18:08:11 +0000
Message-ID: <4af2a4d3-04d1-966a-5fd5-5e443b593c8b@oracle.com>
Date: Tue, 9 Aug 2022 13:08:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
To: Christoph Hellwig <hch@lst.de>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-13-michael.christie@oracle.com>
 <20220809072155.GF11161@lst.de>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220809072155.GF11161@lst.de>
X-ClientProxiedBy: CH2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:610:54::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbd4379d-fa16-46ed-50c0-08da7a321eaa
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: ZhGLHpLhDb95d9VIAtfJCH0D9Nup3Jk6aFswV8WR2MPkxhph2vhXpEbnh2KQtecUGk7qHpsS50MZI9zns0RxMiDXRFOrZgwlE5PSyRZjMyp2oqKJc3GagLp7JgHSGWxzp0vBsl21Q+4I+hzkFILak61ANMQkChOddrKPofhTGbvYDEqpLWdRNj95xknF5COT3XW3ezk1bLnX2DRKy+QqTmDlTYXejKouWnnfu/ycH2rvKK7QfJhSyo0mXolPnqqpTxbT6MU7UQKEOQu7GxOy20wlVCC2RI0uo94JQunnwKh5XHsfqg+45xEDAIy8EGfKS9ambsMT7jf8JScXoJ/+ULoGQiqo5UKvecZVPN7oaiiouRB96hClnoeZQLosds8y0zuiqBoJm6/vP6EWUi2m9JWar+MDDWUicBDjRkaQiZ9p8XNCdZb9PgFhevZlSdP20vquSQ+PDda2HB4MghtzC2GahM2uy26CJlNnAJokoB/BGkUATqlFmEW6UFDJkqjxcihZApBcF0Taw+GzS3HXWSggbgbX2cMm7b/2SIl5D/XWnoAOHkVR35UieXg8nYTiap1m5kQeWp+ET+4diFzJrjxhM2mpjw5b3q0xHjgq07Kd0Vh9yjFrfupCmVsNY21LY2hnl0ZM7VQV5uZHO447uZ+JXEoKZWXf53wVEEhH3kN0xvLW0W3FfahCkoKi5dNJlTaTObspLoYqYTudDVp5C778Up10qC07szb1BUMRv6jYK1m6w8Dm14aCsk6cn06uOxRHB4JzlEIvLinD8it4tjjOBCi/G+ujxomXHTHCfNIQdWbqdjSRcPyP65/pDKUdmm/mkGcfkG+WGcOOj3BynA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(39860400002)(376002)(366004)(346002)(396003)(136003)(4326008)(31686004)(66946007)(66556008)(66476007)(478600001)(6916009)(36756003)(316002)(6486002)(8676002)(5660300002)(2906002)(8936002)(6506007)(6512007)(53546011)(41300700001)(6666004)(31696002)(26005)(186003)(83380400001)(86362001)(2616005)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TU91QnJ3N0xldS9DZGtzOWhyaUZBSlNHTnd6TFFjK0xLWis1RmY2Mzcvb2px?=
 =?utf-8?B?cytBekxBUmUxWjFFZlFLSGdhOCtleGt4cXg3MnQ5TzdTMzdHTFNTeUVjbmxx?=
 =?utf-8?B?OTRWVGRvdEg0aWtRWmowUE44WnBmRVczLzlydlBFN016VGRyWVhRWVI5RFdu?=
 =?utf-8?B?ak1zWjZKNnE2cGJqOWQyNnprOEhXb2VDalRrNlhqb1dRVVltSWE4UnpTQ1g0?=
 =?utf-8?B?bHlFSmlUOHdheUxJVlpjOUlIaThnUldQUit5bm5LVStyQ2NjbitKc0ZXTXVL?=
 =?utf-8?B?N2c3THl1SWo5dEUwNHlaL256WlJCekhKSExsUVVSRzh3RUU5NktET0NoR1Vk?=
 =?utf-8?B?ZjNxcXo5OEY4U3NxMThqaEtiNUdUQkVlMnA4dVkwR0c3UXZxZkhaZ3FHVWpQ?=
 =?utf-8?B?RUJvNTFPcGRhWVAvK1F0cmd3Rkd4OFYyNnh0Z3RrM0wzUnNqd0JhL2V3eHQ1?=
 =?utf-8?B?QWxod242TStURzBGTDBoU1JnOEprTlFRamsxQ1UzWUtkQnNmZVJHSS9jbmpD?=
 =?utf-8?B?amR4SGQ5UTluSDh0aTJ4RlBvSENLbWxkcEFKdkFwcHlkN3JuQmdFMytoNmpw?=
 =?utf-8?B?Nit5M3RnUVpFTkJVOEZyTVkwUmtlc09SWVRPS2FScTkydTlwOWtZOHZMdmhJ?=
 =?utf-8?B?WDY5RjM0NXZ4SEVxNnVvTTk4cXV6Zmc2U3VIYmRyMXQ0Nk1OcVJObEJoN0Zi?=
 =?utf-8?B?cVo1bmZRNWQ4OFlET2VNalJzb3Y5SVZWYkU0TC9OeXF6UzRBWUI0Q0NlR0tM?=
 =?utf-8?B?bGRVNGRmKzBxeHlod3B2enNaOGxyOHJSem5IN1o4OG5mVGpTOEZLMEw0Uk1m?=
 =?utf-8?B?NEhPZWkwazNZdEJMRnF1ZVpCY2JMZC9td0ppckRUM0x0NXZJNWNMODdpaVBp?=
 =?utf-8?B?NTJGanY4UVVBQWkzVUhpZThWelpaaUtUb3EzdkJqWjk5Qko1RlJFdFRSNzJy?=
 =?utf-8?B?L04yT2h3b3cwZnhJWTZKY1YvTkt5TlVmN0lvVGVlNFdURG93Y3c0ZVdoVEVP?=
 =?utf-8?B?ZnhsVXJ3bmt3aWlKUzRjK1IyY2RXNlFUZ1BjbjRkbTlFa0lDOWRTb2V4TWFz?=
 =?utf-8?B?L0Q2YWw0em9xZlJMZG12aDFGYkk0SlpIb08vTlNNT2VTalBPTFNLdmdUWG52?=
 =?utf-8?B?Y0xMbjlGdmNmQ2w4ZVNaSzE4R0d0dll6QWVqZUxpTlFLU1FFQ3lSM3RkcjVk?=
 =?utf-8?B?YTVhT2dPNHY1NEllMkFRUndGNjJQelRidWZ1enFTMDVmVGptblJ4SVl3bFZ1?=
 =?utf-8?B?VmZHRHFwM0JZSVVNOXliNGxpMStzVnZrbnBQMUxia2paWllEZ1dOdGhzQUNr?=
 =?utf-8?B?eEpGaGZkZDBTN0ZDV25mZE5MQ3FmdXcwUW5IRHpLamFSYUdMSWRGZFRGbTJM?=
 =?utf-8?B?NUN4ZzRNaVEwa0RtZEtCTVQwRjN3eTNGUUZyN0pveUFGTTJmaU4xUkxlRTh1?=
 =?utf-8?B?aWRqZVRVM1FnYlVPZG9nTnM3R1VISHhLQ0J5TFRWR0kxZFRtdzdPUTRWTFVR?=
 =?utf-8?B?OHJNankrVExjL3MyL0ZpWU9GZGp3aWo3WUMzZFNtVzdqWnBIcHVPbXo1dU9X?=
 =?utf-8?B?Vk4rRUVTOGJ3SXIrWVZyOW02aDM1a25NREw2b2QvMWtBNktpcU96SkJnTnpT?=
 =?utf-8?B?YllZT2U0SjV6aU5HODVINmhDeDEwellGcUpGWGkzTmxXaWVsTnBsbzduNXY4?=
 =?utf-8?B?eDRTYWc0ZWl0cm81Vk4ybVExNmNnek02TUwrUGIySElvQld3VHBGakY2ZFN2?=
 =?utf-8?B?akZ4d3RuMlJ5T21zSVQ1R2E2T3FqVkp3cjBoMWs0ZVEzT3ZneFlGS0NGYjh1?=
 =?utf-8?B?MFRrT0dUUW4xMU9FL3Z0ZUlKUUJlNDRCTGFlUUVtNkhJaFhkb1lCZExuMTZM?=
 =?utf-8?B?N1NZcjNEbkZ5WkJBZHZPQSt2WFhybkJYN2N5ekJZbkRCU0E4ZEZ6V2kyVERj?=
 =?utf-8?B?YXpvYkllc3h1dDhhdzk5VjJpQkpheGhaS2VjellXd0VQNFBBazAxV2F6TEpq?=
 =?utf-8?B?dDVlNlppeGFjczFjMkxkS0JpRERBSmp0ZHZIYklObUJpTmowN29DUHF4enFj?=
 =?utf-8?B?cDFVRGZIR1pPeFR3V3FySzQwZ283U0RGUXV3dmE5Ylk2WHB5MTBHK2xPL3VZ?=
 =?utf-8?B?NDRrdTdwT0JwajNTdGdrNzVEUk4xRThDT2g1ZVpFQjVYdG1nR1dLUkVEdzdk?=
 =?utf-8?B?bGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd4379d-fa16-46ed-50c0-08da7a321eaa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 18:08:10.9184 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHUH5UKO6mfkGp47udnvzgUQxR5d/+vtZI427eOQJ/a2JnWIfPu8cA9sMg+i/hNPedJG9Cbj3VdXouCgfYIhq8N4QxPjOTNL7UKx46+H8XM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=891
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208090070
X-Proofpoint-ORIG-GUID: lvecxgrGdZr22FKwcXfg2UX9SwzlxX2z
X-Proofpoint-GUID: lvecxgrGdZr22FKwcXfg2UX9SwzlxX2z
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2 12/20] block, nvme, scsi,
 dm: Add blk_status to pr_ops callouts.
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com, bvanassche@acm.org,
 martin.petersen@oracle.com, snitzer@kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/9/22 2:21 AM, Christoph Hellwig wrote:
> On Mon, Aug 08, 2022 at 07:04:11PM -0500, Mike Christie wrote:
>> To handle both cases, this patch adds a blk_status_t arg to the pr_ops
>> callouts. The lower levels will convert their device specific error to
>> the blk_status_t then the upper levels can easily check that code
>> without knowing the device type. It also allows us to keep userspace
>> compat where it expects a negative -Exyz error code if the command fails
>> before it's sent to the device or a device/tranport specific value if the
>> error is > 0.
> 
> Why do we need two return values here?

I know the 2 return values are gross :) I can do it in one, but I wasn't sure
what's worse. See below for the other possible solutions. I think they are all
bad.


0. Convert device specific conflict error to -EBADE then back:

sd_pr_command()

.....

/* would add similar check for NVME_SC_RESERVATION_CONFLICT in nvme */
if (result == SAM_STAT_CHECK_CONDITION)
	return -EBADE;
else
	return result;


LIO then just checks for -EBADE but when going to userspace we have to
convert:


blkdev_pr_register()

...
	result = ops->pr_register()
	if (result < 0) {
		/* For compat we must convert back to the nvme/scsi code */
		if (result == -EBADE) {
			/* need some helper for this that calls down the stack */
			if (bdev == SCSI)
				return SAM_STAT_RESERVATION_CONFLICT
			else
				return NVME_SC_RESERVATION_CONFLICT
		} else
			return blk_status_to_str(result)
	} else
		return result;


The conversion is kind of gross and I was thinking in the future it's going
to get worse. I'm going to want to have more advanced error handling in LIO
and dm-multipath. Like dm-multipath wants to know if an pr_op failed because
of a path failure, so it can retry another one, or a hard device/target error.
It would be nice for LIO if an PGR had bad/illegal values and the device
returned an error than I could detect that.


1. Drop the -Exyz error type and use blk_status_t in the kernel:

sd_pr_command()

.....
if (result < 0)
	return -errno_to_blk_status(result);
else if (result == SAM_STAT_CHECK_CONDITION)
	return -BLK_STS_NEXUS;
else
	return result;

blkdev_pr_register()

...
	result = ops->pr_register()
	if (result < 0) {
		/* For compat we must convert back to the nvme/scsi code */
		if (result == -BLK_STS_NEXUS) {
			/* need some helper for this that calls down the stack */
			if (bdev == SCSI)
				return SAM_STAT_RESERVATION_CONFLICT
			else
				return NVME_SC_RESERVATION_CONFLICT
		} else
			return blk_status_to_str(result)
	} else
		return result;

This has similar issues as #0 where we have to convert before returning to
userspace.


Note: In this case, if the block layer uses an -Exyz error code there's not
BLK_STS for then we would return -EIO to userspace now. I was thinking
that might not be ok but I could also just add a BLK_STS error code
for errors like EINVAL, EWOULDBLOCK, ENOMEM, etc so that doesn't happen.


2. We could do something like below where the low levels are not changed but the
caller converts:

sd_pr_command()
	/* no changes */

lio()
	result = ops->pr_register()
	if (result > 0) { 
		/* add some stacked helper again that goes through dm and
		 * to the low level device
		 */
		if (bdev == SCSI) {
			result = scsi_result_to_blk_status(result)
		else
			result = nvme_error_status(result)


This looks simple, but it felt wrong having upper layers having to
know the device type and calling conversion functions.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


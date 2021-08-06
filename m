Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E04AC432BE
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D2DBC60234
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D2DBC60234
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-BFDIHghHPp-3ksUGSCGuKg-1; Mon, 09 Aug 2021 02:53:37 -0400
X-MC-Unique: BFDIHghHPp-3ksUGSCGuKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85AF1180FCBC;
	Mon,  9 Aug 2021 06:53:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C3856A05F;
	Mon,  9 Aug 2021 06:53:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 402304A7C9;
	Mon,  9 Aug 2021 06:53:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1760xTaW020049 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 20:59:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0DF3820B6624; Fri,  6 Aug 2021 00:59:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 07FD520A8DDC
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 00:59:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 586418D1390
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 00:59:26 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-121-PEmLy2GSN9O2TlygyQqGVA-1; Thu, 05 Aug 2021 20:59:22 -0400
X-MC-Unique: PEmLy2GSN9O2TlygyQqGVA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1760pss5002855; Fri, 6 Aug 2021 00:59:11 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0e290-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 00:59:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1760oEEg111448; Fri, 6 Aug 2021 00:59:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by aserp3030.oracle.com with ESMTP id 3a78d9m0ga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 00:59:09 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2792.namprd10.prod.outlook.com (2603:10b6:a03:87::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16;
	Fri, 6 Aug 2021 00:59:06 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434%3]) with mapi id 15.20.4373.027;
	Fri, 6 Aug 2021 00:59:06 +0000
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-6-ruansy.fnst@fujitsu.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <d53c2d1e-16c6-5540-fdcb-e89adf7f4dec@oracle.com>
Date: Thu, 5 Aug 2021 17:59:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <20210730100158.3117319-6-ruansy.fnst@fujitsu.com>
X-ClientProxiedBy: SA9PR11CA0027.namprd11.prod.outlook.com
	(2603:10b6:806:6e::32) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by
	SA9PR11CA0027.namprd11.prod.outlook.com (2603:10b6:806:6e::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16
	via Frontend Transport; Fri, 6 Aug 2021 00:59:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1344e312-974d-4323-a95e-08d9587563eb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2792:
X-Microsoft-Antispam-PRVS: <BYAPR10MB279221773DDC3EE63CE66BAEF3F39@BYAPR10MB2792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: HSHGh4e81wk9Z2A+qeUr46AGi2xfyg3V2HQUDVuBoUbTPulO8TmcIVl2MoBZvPkfh29s05HbWEQ8QOWIJzKav2VENLH4XXzSmbH6pbjzox2bWPhBMPRmgAlQ2HNnGys5hO0cOqRTxeldy+NGfAXUJLcKdHsgrvk6WG+oFMFT07FJDvRXL+MpJ+KGCwkkfwB8RwHMwpQDtH63HwzJZ52rmUkJZlV9Jdk2kNPQzrR4Glvhjd78XUkHyAYnAh8tz1OQbb4sBwVlyAT5DM5ONS9Ejhmi2QAz5xavLMScKA7uvxdKQ+Jcc4xshBMhNbxdMDjTYBfm/Dmcxp1Wj2dQWtiXNBviDsuQtKulYb+YVTkxotnTE9JccI/XJ1IXFErZLhdh4NUpOxAr2hSZggjt+c9vWWXXvsGWwr2n0+5JuNy3f9f2MySgtJWyjmJ3QSLTqwliRtu0nDkXY77zw/wvmU9KIP67AAGrFHeEhix0ysHg8ksCguyyE6A2qiA+NbGpJqbnRUaVJZu7qQzfup23LbqGiNTmkaI4AnTCnsi5y/lQH8yb/o3QjoYUlDmfwEABuZoLU6FIJW6iNov+FAXCduOkPifCRg+LcEC3Nqy0Q65umBiH6fWXRxqfJ+sckmzhYuva83YUkf3SVOCI9vuhK9JdUyxz7gkmum0s0jH5QB9bxGskRibEJencHxTGj7bI5i2Ddmw/dzuzwIMjReGC6Gy7p9RU7QMkBTAgGc+Ulbw4ZkY=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(136003)(366004)(396003)(376002)(39860400002)(31696002)(4326008)(6666004)(36756003)(36916002)(38100700002)(86362001)(16576012)(66476007)(5660300002)(2616005)(2906002)(31686004)(316002)(26005)(478600001)(44832011)(66946007)(66556008)(4744005)(8936002)(6486002)(7416002)(83380400001)(186003)(8676002)(956004)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkNXUUViWWpHdzQrVVpGTEdWWmh5RXBxS0Q3a2grSnI0cG1jTVBQVXREckxB?=
	=?utf-8?B?UzNOZ1BDUHdFOTJTdEFNU25wSzZReTdCQzQ1RFpGYXlLMXdEK09IcTlHREVT?=
	=?utf-8?B?ZzFNay9YRmwvSlJISDdrdnFhUktkOGVGditDd2Nhd0JPTFFZWnM1OVlndElT?=
	=?utf-8?B?bWtPcmE5UjJhK0ZVa21BcERRSWZyUXozenNUMTNqcFhZdFZEUkNLNFhpRFFv?=
	=?utf-8?B?dmxOZG9EWG1sYjB1Vi9UM2Z6dWtGeUJvTDlNSXdua1dSOEFnME1MVFRMREJM?=
	=?utf-8?B?d2poZ3RuQ2ZwSVM0OGE2M1AwWUg2SnFpd05rQ1dmWExiMXgwa2FEUDVOKzd4?=
	=?utf-8?B?MzNHdktJZ3JNSzlwM1dXTk5FNkp4L1RyenZZS0pPT3dtTW5EbkFXQ3kzb3Nw?=
	=?utf-8?B?QzhjelZBVW1oQ0hiL1hGc1czWHVhOWpWVWtiZjJwNG1jdndDZjFJQXY3dWRE?=
	=?utf-8?B?TFVERzhnS2VzQlBwVUowZTIwcmdRWEZvWTIyZlVZRDVDR3J6bllNZkhqRENl?=
	=?utf-8?B?Vzl1enRHTTdZb2E4dDhUVUNNaEhTeTllRUdJTCtvVlU5UHRIWHJHL3ZMMlJM?=
	=?utf-8?B?Y0ZyYkF1QllWSkw2aTRESjdhVkZ0UzA0NHk3SC92K3FoMlFWQUtuUWFyd3Bw?=
	=?utf-8?B?R1RueWJjaDBkZlJOcmQ5REg0TXg1bGtYMk1wMy9ZNnlyTm80Y2xPS0ljWFU0?=
	=?utf-8?B?M3NVNG9udklkS1RDUjQ4c2p0LzIvTUlxNTVwM1VjWnJmVWtIVWlXZHoxNzdu?=
	=?utf-8?B?bVRiQnEyWkhpYXJQNit1c0Q1ejlmd09zTjh1R2tyMklqc05xMXhramVTaWVZ?=
	=?utf-8?B?Rk84WEgvd0pmQzRNS2tNeUl2c2dpT2ZoRS85UHhXYVNrdWVWcWVoUlJQZCt1?=
	=?utf-8?B?dWpnbFc2VWhLcWhaNytGVzRBczdUT2JrMDl6SWJmaFM1WXhjK1lBQWg4K2xu?=
	=?utf-8?B?eEdjT3kxZjV3eExHSENtbXVrSi9jdWJCUU96M3JJeU0xdDh3UHdBN0xFOHEy?=
	=?utf-8?B?czJ4cHJIZkw5U1FUQkY5cHcwRGROSUd1eVRwU2xXdlB6cWpFaXNaQnVZNlR4?=
	=?utf-8?B?WVZ6MkZaYTYyS1ovMWV0aDZ6T0hScEk5YktGZGxEZ2ZuTnBHNEtmUXg4MFlN?=
	=?utf-8?B?emZPUzRmT0lYWjF2SWdFaDN1bTFmaG9DUkdTdjhoMGFJWWE0SnpPVUVueXAy?=
	=?utf-8?B?T1BGa1hJVDZ6NklyajFwWmVJbG1rdW1hc3FOU0JRM0E0dTVwK29iamF1K2NO?=
	=?utf-8?B?dVFEdk14MTVtcm01UVBNY3ppOFRESkx0QjBwV09XcHFadjBWQmRLdk5vSWVw?=
	=?utf-8?B?RFRobC9rU0lia1lHY1lmNjQwVnBVZE1sUWZpV2I2MTFwTExXTXhudHhvb0kz?=
	=?utf-8?B?MjVsTUc0V0ZYTXh3ZHdXOHZla09oTWJ6RWpYZTljZ2ZWa1dlVy9pbUhoK0t6?=
	=?utf-8?B?L0ZDM2N4bHpLdnU2Um4zbXgrVDdndW9XSDV4bTNQZDRDVm1SZHB6SFUxRGRS?=
	=?utf-8?B?VU1iM056SXlwdGdsTVpROHdjeUE3VW80SndiSG11LzcyZmwreWVYVHFBTE51?=
	=?utf-8?B?UGJFNi9IQXZDQTJQWWFDM0lRdWtzaVc1RGw1OUpwWVBiQ0VMc281NEd6c0NT?=
	=?utf-8?B?VUVub0lkNW05WmRWN1VpVkVRejVtMEs0TkU2bE5KNkFiblFpVXpjZWM1UUpj?=
	=?utf-8?B?UUZrOFZLWlhLaXN5ck1NRUw5QTRkUklIR0JZenRBK3NYUzFHN1RVd01vVlZP?=
	=?utf-8?Q?ieDZD/rIkLFG0GMtDb1GmgMhL3+tOa5koPUAVQL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1344e312-974d-4323-a95e-08d9587563eb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:59:06.2622 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfPYPC8470b2V4l46wHV+YF8QRFsroiOM0PJUI4ajqmem7UTRrG9aeO61aBgHjiPsiZOLISR978H+NzvKMRLEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2792
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060003
X-Proofpoint-ORIG-GUID: KEV4xFjBEwvZVqWns7lp20QsbdRUkRLB
X-Proofpoint-GUID: KEV4xFjBEwvZVqWns7lp20QsbdRUkRLB
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 09 Aug 2021 02:53:04 -0400
Cc: snitzer@redhat.com, djwong@kernel.org, david@fromorbit.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v6 5/9] mm: Introduce
 mf_dax_kill_procs() for fsdax case
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
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

> @@ -134,6 +134,12 @@ static int hwpoison_filter_dev(struct page *p)
>   	if (PageSlab(p))
>   		return -EINVAL;
>   
> +	if (pfn_valid(page_to_pfn(p))) {
> +		if (is_device_fsdax_page(p))
> +			return 0;
> +	} else
> +		return -EINVAL;
> +

Just curious, what is the rational for preventing dax pages from
participating in hwpoison_filter test?

> +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index, int flags)
> +{
> +	LIST_HEAD(to_kill);
> +	/* load the pfn of the dax mapping file */
> +	unsigned long pfn = dax_load_pfn(mapping, index);
> +
> +	/* the failure pfn may not actually be mmapped, so no need to
> +	 * unmap and kill procs */
> +	if (!pfn)
> +		return 0;

what if a process has mapped the file but never faulted in, but did ask
for early signal, will it be excluded due to lack of the 'pfn' association?

thanks,
-jane

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51188C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:54:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6C876103B
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C6C876103B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-iY-_MrvpO22cOheQoaewTw-1; Mon, 09 Aug 2021 02:53:45 -0400
X-MC-Unique: iY-_MrvpO22cOheQoaewTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16AA2180FCD1;
	Mon,  9 Aug 2021 06:53:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB2105D6CF;
	Mon,  9 Aug 2021 06:53:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C07424A705;
	Mon,  9 Aug 2021 06:53:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1761Hveh023061 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 21:17:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C88E620B663F; Fri,  6 Aug 2021 01:17:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C26AF20B663B
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 01:17:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C5A3185A794
	for <dm-devel@redhat.com>; Fri,  6 Aug 2021 01:17:55 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-291-xM7bO71BOVCosRqjPiXzTA-1; Thu, 05 Aug 2021 21:17:53 -0400
X-MC-Unique: xM7bO71BOVCosRqjPiXzTA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	1761FvMR005072; Fri, 6 Aug 2021 01:17:41 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0e2rv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 01:17:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1761FgY7161090; Fri, 6 Aug 2021 01:17:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
	by userp3030.oracle.com with ESMTP id 3a4un4u2pn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Aug 2021 01:17:39 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB2759.namprd10.prod.outlook.com (2603:10b6:a02:b5::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25;
	Fri, 6 Aug 2021 01:17:37 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::51f7:787e:80e5:6434%3]) with mapi id 15.20.4373.027;
	Fri, 6 Aug 2021 01:17:37 +0000
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
Date: Thu, 5 Aug 2021 18:17:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
X-ClientProxiedBy: BY5PR17CA0066.namprd17.prod.outlook.com
	(2603:10b6:a03:167::43) To SJ0PR10MB4429.namprd10.prod.outlook.com
	(2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by
	BY5PR17CA0066.namprd17.prod.outlook.com (2603:10b6:a03:167::43)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15
	via Frontend Transport; Fri, 6 Aug 2021 01:17:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7c5cec6-3247-4400-201b-08d95877fa1a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2759:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2759C9D650ACA2AC0DDED94FF3F39@BYAPR10MB2759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: HKhk0KoBWdg43/Kxl9So08KHqd6H/PuqHPERjTYq/qfZ521Snu2M9I4l8uzZjmKU9fzd2DpeVTHFAMXDDcNMATAXUCqSAEXPyOfRie4yabWoLZ5a7ZHLqUYy6HfIwsX9oaD4FBoz844IlOLJxaC2fb0PQLu0llZ4Ytz+iCekOtS6xwsJ4tEbp35wfIa2SDJq1W2COAXsSX3d+AgRYzqa4GtiGT14qcEzciixPe6N5qhm3yhhTLQIpmYMjiHsyf3QNDRGQpTVWPJR+/xH+AG7ofLkoJO254AkpBrrfbf0GF1h11zUYJ+B0qITF8J2TMq9eftocU4dnLS01eGPnTwbiFh7qCaA7JpnwfrUTRFhAtcaRxT3/UIIWKhpGAWxa8ipkAIXuUdwoqpXSrdWNw+09Irb51bXxQr30KnYZXPh/zkPST30zdUAFN08P+VL3XXw/mwA/C0sUG2g9emQA6J0+dpYXeEoUgJzrEzsN7JQSG9ZAu1W21ccGmZwlI70iI784FHraIHLGcEVQy8iuSdUc7evmkCGPc37T04h/XKXpkG9b1Z7GXiarwVIKyaewcJqYrTOfIsLrwBAdlxAzT2viEcx8YTzkTNZUuBJwNexhHfCf/krf6v7X40FB5C3aEC5QvmpxUxkimpxAAqB/piLcgUi+hhNh47NLsWSZyDhml51Sa1sCKNgpgT45IlldLPTyIyCnpUcQhQC8oIjbOvoByS2n6dXMLSrlVgaid2kFxc=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(478600001)(6666004)(38100700002)(31686004)(8936002)(2906002)(6486002)(8676002)(4326008)(7416002)(36756003)(16576012)(44832011)(5660300002)(316002)(956004)(31696002)(66946007)(66556008)(66476007)(36916002)(2616005)(83380400001)(186003)(86362001)(53546011)(26005)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFdpYllmN1Jxa2kzVGN0UjFZTjdQa1oxT0JNUEpDRlBZN2VEb0t3VU9xUzN5?=
	=?utf-8?B?cTZxZmxBR3JiUDU3Z2p2T2o3bXU1UDhaWVEzTFcyNUxpSHJxdGFNd2NTcUZz?=
	=?utf-8?B?UjBCMzBpRVFrYTdaR3RnTFNZOFBPUEVJWnpVOWh2Tk1FVEdGVnVFRlNOK0JT?=
	=?utf-8?B?WHBQTnk2VHRFQjdCdE5aNEdMbW1SdzdVTjM5YjErYVFNcWFFTW9xby9lRVJC?=
	=?utf-8?B?UTRNYmJvZGMrdUFEMmZEVjVZSUc2LzREMVdBbWdxU3VnV3BNOE0rSnN5bElP?=
	=?utf-8?B?c2lJQStFTVlhK2RBODd3bEFMbjUveStpMzd1dE1saFpUYlVBcmMzczRobFlp?=
	=?utf-8?B?YXNTUTRVamIxNjVaNnkrRHc2ZFQ0RTJVMytscHVHcFQwUFJoa3ZxNTE5NGVP?=
	=?utf-8?B?OEgvTlRhcHlHbVFFMVEwcE5wbGIyOW1rbDUzL1MwZEROR0FRczJqUmdrVXQ5?=
	=?utf-8?B?d1dnZEY5c1pvWjhQbzA5blUrNlRacllrTTVnR2NQNndqWktzUzRacXdrZFBH?=
	=?utf-8?B?V0ZSYU5wSWpSVVg0YXdTQ2JjK3ZMN3BtQTlJczNRWWJ5andaOTNDNkp1UDJP?=
	=?utf-8?B?djliRjR6QXR0MkNpTDF5bHFuL240ZklnRU1NREZMck9QRGExN2Zpak9rNmlG?=
	=?utf-8?B?UENxYXFyUzdBRlpySEFBTWg4Zyt6VXM4STZkdHpYakQrT1JReEZSS2h1YktY?=
	=?utf-8?B?ZFNtMzA3cTl6OS82YkNRZ05HTU5nS2h3ZVBiZUZJNWloODR1TnNpVHJmM2xC?=
	=?utf-8?B?NHduSjZaZ0t6YmtVc2FmTEtiQlhhdHVUTkxpUjVaRkR4ZmUvNDdHT21DczRB?=
	=?utf-8?B?QlNrNXM5WE5MTGx2Wi8zK2RVWWEzR2lvbnBZeC9mVVQ0QVF1SEdkSnVlOWo4?=
	=?utf-8?B?QXVkSDFtNVlRVnk0MnNkUTZlVmxnb1VZQzQ0bytKVTFCRDBOWSs2UVhTYTgv?=
	=?utf-8?B?M1dLdWFCODY1ZDV0RTFxOFVrRGN0aUxXeWFUTnVjNEh5SVFCTElYZXJLQXFI?=
	=?utf-8?B?QkM2WEd3Szg4U2hMeXY2ajd1ZkZ6NzlHZmQyenBTRTltUTNoTGpXa1pYS2E3?=
	=?utf-8?B?MDFqblVOOXNLSkdvSXRWcUpFVEVvaFAxVmFZVWthQTJwZkttWWlwWFkwNU9M?=
	=?utf-8?B?MVoybVlwTXJBcUQxaWFIT3hVZVpiWTlZenN1cUtpMmlDamVvSm0rbGJacEYz?=
	=?utf-8?B?MncxSlc3RldWTWl3UExWNWtXZjFhL1QyNS82aS9sWGprOUk1c0lVaEIxN0c3?=
	=?utf-8?B?YUFKOStZY0h1dlozWTVOb05PbEpqL2NpOWlRd09wNGpuRWJTYTlNNHliM1pD?=
	=?utf-8?B?eFVITkZ3cmR0K09BLzB3ckJCaElKbkZvZ0JmaGNKQUR5ckY0cG1ZU0U3VVJW?=
	=?utf-8?B?d29WeUxsU1ltbXVvWXA0WFNWU1Q2cW5IWStyazVpeEwybjg3WGsxVUxMajV3?=
	=?utf-8?B?SE92OURrSHovMW1UWEMrTGRrZW1vdjhYY21HOWFrV21kU3IyV0VxNXRyc2dj?=
	=?utf-8?B?ajc2ZjFiV3JIajNsc1M2TjNzVEJTcVZwMHZrMTh5NmxKdWwxVUxOYndVRVd6?=
	=?utf-8?B?MEJTRVgxK1FOZjVpcGZoRFFrRlB1YjZGWSs0YnRZYXVaaFJuWFQ5dGQrcTEw?=
	=?utf-8?B?Z1ZIeE81cm1VakdRTitiK0JwWkVMbVVqK1l6b0NPL2VTM0lBcWgzQ01zY3Ez?=
	=?utf-8?B?YmZLVENjSklrTGc2TjlRYUdFeUJXRGZQV1UyT2hoRk0zT1hQZjhEc0I3d1Fr?=
	=?utf-8?Q?UZLRS7Tv5GqWE9D1xN+EhyjoAVbNzHuiv1+Huvj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c5cec6-3247-4400-201b-08d95877fa1a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 01:17:37.1975 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJ0UFJfnHxTubhg2VDGW1SixkmdGceu5m4D7eU9i/P9BWO8HHYmihmdDVYgsaGdXIMjZBHFmSh6mdmQaq5lTkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2759
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 malwarescore=0
	suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108060006
X-Proofpoint-ORIG-GUID: iwqIXf6cCbK537Zcio4y0mLUaJ0KmU09
X-Proofpoint-GUID: iwqIXf6cCbK537Zcio4y0mLUaJ0KmU09
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
Subject: Re: [dm-devel] [PATCH RESEND v6 1/9] pagemap: Introduce
	->memory_failure()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

The filesystem part of the pmem failure handling is at minimum built
on PAGE_SIZE granularity - an inheritance from general memory_failure 
handling.  However, with Intel's DCPMEM technology, the error blast
radius is no more than 256bytes, and might get smaller with future
hardware generation, also advanced atomic 64B write to clear the poison.
But I don't see any of that could be incorporated in, given that the
filesystem is notified a corruption with pfn, rather than an exact
address.

So I guess this question is also for Dan: how to avoid unnecessarily
repairing a PMD range for a 256B corrupt range going forward?

thanks,
-jane


On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the filesystem in which
> the corrupted page located in.  And finally call filesystem handler to
> deal with this error.
> 
> The filesystem will try to recover the corrupted data if necessary.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


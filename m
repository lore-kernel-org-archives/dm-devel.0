Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A81C2B9F7
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 86A53613F9
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86A53613F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-NWeTeEspOEKC1O5t6YzP3w-1; Wed, 26 May 2021 07:00:25 -0400
X-MC-Unique: NWeTeEspOEKC1O5t6YzP3w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 324F2802938;
	Wed, 26 May 2021 11:00:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11A1578625;
	Wed, 26 May 2021 11:00:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D157D180B463;
	Wed, 26 May 2021 11:00:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PJiPx7026468 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 15:44:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CF99429ED; Tue, 25 May 2021 19:44:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C968E778C
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:44:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 073DC83395E
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:44:23 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-329-gVXdjU7zNbeKbTEJVAcdwg-1; Tue, 25 May 2021 15:44:20 -0400
X-MC-Unique: gVXdjU7zNbeKbTEJVAcdwg-1
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJad4e145832; Tue, 25 May 2021 19:44:18 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by aserp2120.oracle.com with ESMTP id 38rne42pku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:44:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJe4ox078617; Tue, 25 May 2021 19:44:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by aserp3030.oracle.com with ESMTP id 38pr0c2v1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:44:17 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
	by SN6PR10MB3086.namprd10.prod.outlook.com (2603:10b6:805:d6::28)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27;
	Tue, 25 May 2021 19:44:16 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 19:44:16 +0000
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-12-damien.lemoal@wdc.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <741e2d83-34d5-72d1-d671-f870476d9a90@oracle.com>
Date: Tue, 25 May 2021 14:44:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.1
In-Reply-To: <20210525022539.119661-12-damien.lemoal@wdc.com>
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA0PR11CA0153.namprd11.prod.outlook.com
	(2603:10b6:806:1bb::8) To SN6PR10MB2943.namprd10.prod.outlook.com
	(2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by
	SA0PR11CA0153.namprd11.prod.outlook.com (2603:10b6:806:1bb::8)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26
	via Frontend Transport; Tue, 25 May 2021 19:44:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3144214-c4a7-4505-92a0-08d91fb57af0
X-MS-TrafficTypeDiagnostic: SN6PR10MB3086:
X-Microsoft-Antispam-PRVS: <SN6PR10MB308661903258DC150280A275E6259@SN6PR10MB3086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: hKk0kEHnJoLNrwf8+J7wo+gTKcFHdz4j6Lxffs25Hx2tpKCCNICrHKLlO2nRzyxjeEDfY7V6nKzFI1w7Eeuk6zYuKaQSuYs15Goxtx34pCAGoy7NRM7RCBq21G9tNRd9cIiHcQKUPXsUEaxjI/ZIUsJXqbSFNohrySav/z4lIeATVunnuipqzHEZhiCRllJF8vomN1vmJCAVfk/3HnJ848EudyhK3b4LC0UXCPEhOgK9w56675aPA3e+0FizYQl3ct7tRs3O/PZX4VDahQ7LIYfhMLhqLxp9m5C4aReA1nj+JK0wULTEj91+kjkyseBpkCiYHG3+5cVckDzIp81ZnoOj3YZDY2V46N6gH468jzHoGD2gHPzu2h5iuZ5B/vHBxBz7apFj/meq0Fta3v31kkd255o+5o5/TJp4yId1TyevB0kiBlgmH4UQ3ETjVfHEk+HkXv0IT9j2adrCWwevWJ+YeM0T7GTC595boU3lzHl+wL18MAESt3hsSF1hXRzvrZ/Ucbu6CQe6ygHDmdsemkYgDlQUCFws7T8NrWm7NxpnGlMLYMWPnmEZOE8z2eSGTK3t9L8PnT19j8Uf7zt84VuSIFz5Eg5D7FR+2T96yKOQSN0iYcyT1evcrGlYNRmySy7a3BUvKjTlcNdwmmznpjwU7RhvG2TuX5LzN6YAmsdADjkCxTaYE/stvdWuki0r
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN6PR10MB2943.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(39850400004)(346002)(136003)(396003)(366004)(83380400001)(66556008)(53546011)(110136005)(36756003)(31686004)(26005)(66946007)(186003)(16526019)(8936002)(8676002)(478600001)(36916002)(31696002)(2906002)(66476007)(5660300002)(38100700002)(956004)(86362001)(2616005)(16576012)(316002)(44832011)(6486002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UURpcFR5OHIweTlHR1NsZUROVUNMZTIxVnV4SFlZaC9RTmw3ZHJRQnVNNmR5?=
	=?utf-8?B?V0FQWVNVU0Vta2tEWWJFWDZCd0ZyalNtOWNMZEJ5TW9DbWgyRC9TbkZ1aDk3?=
	=?utf-8?B?bko2cWVJWEdEdU5ZVmRFbFEzemo3dGdLU3ZOL0VHVTBXUlpGcmg2L1R2UXFL?=
	=?utf-8?B?d0VmRGUyV2Fqd01KS3hKY3dxYy9wNmNzUUxHekFvU3N5NFF2MWg2cnBpOTRG?=
	=?utf-8?B?M2RvVXFEdGplZHpSdW1yalVOZWlvbjY4Z3RaQ0ZaWnZzSGxsTCtBMDFkSFV0?=
	=?utf-8?B?cXdqUzRJVVlPV0NBaDhOYTc2U1R2aTIyUjdwekZUaXNtVDRTYnJEQ1RKdnNZ?=
	=?utf-8?B?eEVxdnBVRDl3a09LY2FVMXFvZzdRUWgzZTV3QVYrMXZUdnZWb1UvMUY4Sjc1?=
	=?utf-8?B?Y2lDVG5NdkI0YTBIN3dWTGJnL1d3RjhZRzk0MlZqbmM3c2ZLaTRlVVhBaGxK?=
	=?utf-8?B?YXl0SER3SHluL1J3VHl3aTk0U2dwbFQ4NnM5SThzYnBkd0RITExOL2RmOTQ2?=
	=?utf-8?B?Y2Iza3ZwaDZvd2c2Skg0THJCajFVd2VWRWFjbWV6cE9GUGNZMFFyUGxFNXpZ?=
	=?utf-8?B?R2JRRTlRVFNuN2plMXp1alVMR2l2alVQMjVNV3pFWDdxSE8rOXVRbjZvWlRr?=
	=?utf-8?B?MXpVRVJaLzdDZ2dtQkFKbnJEUXdESG9JclVQRWpaUjdCVEhDaTlMNm1zbWdZ?=
	=?utf-8?B?V0ZIdTA2Z3R6Yld0cUpYcjVBMnhWZnVlT2hqQ2h5SFR1MGE0YVF1b3ViR0ly?=
	=?utf-8?B?enc3eFc1bVN2QXIyMkoveTlNSjMvdzdZcGNBK0tBUHZtYXJva0ttM3h6THBR?=
	=?utf-8?B?Tk40NXVtZjNnaklQeWlZcXlydkpiU21vK1VaelZYRTF6WGZpREQ1K0I5Yks5?=
	=?utf-8?B?RkhNaFQwUFZXekppUnhUZ3FZeVJkSk1BOHgyVmd2aE5PaEVhbnpjeVVRNzJR?=
	=?utf-8?B?RU9xeGdhSTJQY25wRlNYdjVRM1huaUlCODJhQTR4K1F5ZUxIaUpydE1NQ1Jv?=
	=?utf-8?B?aHRxV3pJMjR0THRuaFVjOWNoWW5FbmJMbS9GWFBKZHFKb29FNzdGZXBTZWxF?=
	=?utf-8?B?ZWcrQWwxM29PY2RCaXpLRzhqdkpnRjdRc0lFTENEOCtzUEY5ZkZ5VFhMWThz?=
	=?utf-8?B?V2dXNGp0Y3dwOXp1azNHU1FPK3B5SXFIS0RFY0ZoamMzNE5BK0o5aUxPbC9x?=
	=?utf-8?B?cGVZMUt2SjFtWSsvL2swQ3VuME8yOWs2YUU3R0RtbWRHTVZoaFM3ckFjMVhI?=
	=?utf-8?B?YVMycHdqQjl0U05LSXlJVHYrK21Yd1RKOE5PUTBLV3piTFNaUGVMN09YVVBW?=
	=?utf-8?B?QmVTRXZVOE45Y2lDVlFEemV5WUhodGxQby8rQmRUTmNOSXdtZHVHN1dKZTBM?=
	=?utf-8?B?WTF3czhRbkQvcXpDc2Fwcmd0aU0yeEhXeVdJZVJkTDhuTE03aGJkVDd4NkFh?=
	=?utf-8?B?K0FHSTBOWGk5ZUo1NkNzVHV6eVZOeHhsSllJOUpmcnNES2lBczQ4M21SMTZp?=
	=?utf-8?B?V2VMU2FpRzljVkxqMk5XMDZ1TkdrRWRMQnZnSXZmZ1dFTEtCQ08ydEtPdHRZ?=
	=?utf-8?B?blNHWnJNd01rVC82OHZpcllIYTM1MEFHT1QwK2cyUXVIbUE4Q0N2TS9YVTR3?=
	=?utf-8?B?Q2ZLRUZnOUpiWEpCeHBNZzFUTnIvWWRDSVFuZ0o2Y0I4RWVLWmNtd21KbUVC?=
	=?utf-8?B?eVpUMWpWTWRRS003TTVncm1nRkVvVVZFbkl3REpKL3piQytlTGxOQUlRalg0?=
	=?utf-8?Q?khtMhRfEWYFFKY/rTsbF5NMvKK89WSQIvL4Le4c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3144214-c4a7-4505-92a0-08d91fb57af0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:44:16.2423 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QeRIiZGWHuIiY7sCgZTWb8aq08C/2rMNv5gce9wxP3c2M+7HqImZLC2JBz/aKZQvbITmlXv9WIvxBkTmpVSAQQUOLYjuk0YLLSzyTXkk5p8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	bulkscore=0 spamscore=0
	mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250120
X-Proofpoint-ORIG-GUID: rgB2ipQQU4zh_5E73dmXF7pQjQHrQ07E
X-Proofpoint-GUID: rgB2ipQQU4zh_5E73dmXF7pQjQHrQ07E
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	bulkscore=0 phishscore=0
	mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
	lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250119
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 26 May 2021 06:59:53 -0400
Subject: Re: [dm-devel] [PATCH v4 11/11] dm crypt: Fix zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 5/24/21 9:25 PM, Damien Le Moal wrote:
> Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector
> of the zone to be written instead of the actual sector location to
> write. The write location is determined by the device and returned to
> the host upon completion of the operation. This interface, while simple
> and efficient for writing into sequential zones of a zoned block
> device, is incompatible with the use of sector values to calculate a
> cypher block IV. All data written in a zone end up using the same IV
> values corresponding to the first sectors of the zone, but read
> operation will specify any sector within the zone resulting in an IV
> mismatch between encryption and decryption.
> 
> To solve this problem, report to DM core that zone append operations are
> not supported. This result in the zone append operations being emulated
> using regular write operations.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/md/dm-crypt.c | 24 +++++++++++++++++++-----
>   1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index f410ceee51d7..50f4cbd600d5 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3280,14 +3280,28 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>   	}
>   	cc->start = tmpll;
>   
> -	/*
> -	 * For zoned block devices, we need to preserve the issuer write
> -	 * ordering. To do so, disable write workqueues and force inline
> -	 * encryption completion.
> -	 */
>   	if (bdev_is_zoned(cc->dev->bdev)) {
> +		/*
> +		 * For zoned block devices, we need to preserve the issuer write
> +		 * ordering. To do so, disable write workqueues and force inline
> +		 * encryption completion.
> +		 */
>   		set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
>   		set_bit(DM_CRYPT_WRITE_INLINE, &cc->flags);
> +
> +		/*
> +		 * All zone append writes to a zone of a zoned block device will
> +		 * have the same BIO sector, the start of the zone. When the
> +		 * cypher IV mode uses sector values, all data targeting a
> +		 * zone will be encrypted using the first sector numbers of the
> +		 * zone. This will not result in write errors but will
> +		 * cause most reads to fail as reads will use the sector values
> +		 * for the actual data locations, resulting in IV mismatch.
> +		 * To avoid this problem, ask DM core to emulate zone append
> +		 * operations with regular writes.
> +		 */
> +		DMDEBUG("Zone append operations will be emulated");
> +		ti->emulate_zone_append = true;
>   	}
>   
>   	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


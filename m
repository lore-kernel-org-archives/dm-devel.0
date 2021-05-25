Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41D0C47082
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7AF61613F4
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AF61613F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-NpZFfVRlPJO7rTDmj66VWg-1; Wed, 26 May 2021 07:00:32 -0400
X-MC-Unique: NpZFfVRlPJO7rTDmj66VWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B4BB107ACF3;
	Wed, 26 May 2021 11:00:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71A8F1F0CF;
	Wed, 26 May 2021 11:00:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3D46255358;
	Wed, 26 May 2021 11:00:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PM8TSU006290 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 18:08:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 36D70114B2EB; Tue, 25 May 2021 22:08:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 319A210F8E3A
	for <dm-devel@redhat.com>; Tue, 25 May 2021 22:08:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CA631857F2B
	for <dm-devel@redhat.com>; Tue, 25 May 2021 22:08:26 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-454-ZvT_8OVxNaOWvaXjXNfRGA-1; Tue, 25 May 2021 18:08:23 -0400
X-MC-Unique: ZvT_8OVxNaOWvaXjXNfRGA-1
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJ5tI5179139; Tue, 25 May 2021 19:09:21 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 38q3q8xge7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:09:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJ5GJu009027; Tue, 25 May 2021 19:09:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by userp3030.oracle.com with ESMTP id 38pq2ugqa3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:09:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
	by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Tue, 25 May 2021 19:09:16 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 19:09:16 +0000
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-3-damien.lemoal@wdc.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <d1a56459-9ea9-86e9-9af0-48d2461cce21@oracle.com>
Date: Tue, 25 May 2021 14:09:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.1
In-Reply-To: <20210525022539.119661-3-damien.lemoal@wdc.com>
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA9PR13CA0026.namprd13.prod.outlook.com
	(2603:10b6:806:21::31) To SN6PR10MB2943.namprd10.prod.outlook.com
	(2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by
	SA9PR13CA0026.namprd13.prod.outlook.com (2603:10b6:806:21::31)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11
	via Frontend Transport; Tue, 25 May 2021 19:09:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb3ef0f1-f928-431c-7ca6-08d91fb09785
X-MS-TrafficTypeDiagnostic: SA2PR10MB4793:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4793851FB5DFA77E31CA60B8E6259@SA2PR10MB4793.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: urjXKTg5DNb4oifLPbOHvzni5L2M0ifg8wjG1JNQz4kA2E6/8XynpZ3csy70km1yd+220FfbS+RqiGBuO5gBDnSqdppqnpKA2ggCgjXhqjAf35bhPVnIlA/rMsh8hjfga/lRWVJgew5bSTzTgG67ziSWQmuLTUxjSIAj2ebI6VLJZ7Z4z0f80gLy/aAGLwRRfGKfWFLMg6isXnjeTLU6Rj6GJokd++psuEBeoX6ESH4K7VOOMHhCYIHg6chedFZxIjHxF5IMtTlT2h1I/kyyqH2kebUBjWBiVmECh1lTYKjlJ3drjmNvW7Ej3SJF1X2wzi/PC+aNUNAl5iaroKbC887vmPDv/IJs1KfMiyh4Vh0ArCJBjdTDfJyDHWVMopt2OEv2Z876xJD7gI+3HSSdmBBo35cK1RHdgPTnhI0b8q9iX7PcJ8ZpUF36OYRIV8D36mJ0amFkQW9pHJ6iIHE+DGybJOW1EudcL8qZeHtJPEI6PA3xnUjTf0KgtMo84Ix2FzpPjs2QgrcureUHm2Xz4IfZWVXhODBDbRRKvPC3kz7lJx0fzigWYa3ZRv2ZpQ/iN/fiagqxrS2SmXRo7RVI25hboLUWWMqEifYbqcCERPzvHqYHKj+NJ6nns6AnvB5wkT2BvEEtR/v0e1rI2u7hCWdoKw31BHwojYKgxXRkIfoavcRxRH1X/T7zLK5Y1aYACaIBq5XrsLrs/bxR0NSMIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN6PR10MB2943.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39860400002)(376002)(366004)(136003)(346002)(396003)(38100700002)(110136005)(31686004)(66946007)(16526019)(8936002)(36756003)(8676002)(86362001)(478600001)(66556008)(66476007)(83380400001)(31696002)(6486002)(956004)(53546011)(5660300002)(26005)(44832011)(316002)(16576012)(2616005)(186003)(36916002)(2906002)(21314003)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cnFLL20zV1ZSc29WVGF6akxIUWZ5ekt2OUVQWGsxbDlsTS9ZdCtERG12elVD?=
	=?utf-8?B?Z0pqdSttU1crdXdQVzV2VGVaMitQbk94NlNOLzJ4Z1lDNkwyYWhEUnFjUDJN?=
	=?utf-8?B?c2xjZG40TzZHcXo1WS83NVc0TG5BcUNsY3U2ektCWHFINFgrQmZ6cU14Z2g1?=
	=?utf-8?B?d1B4am0xSHRmV24zUHlHVkZPdE5iUC9PQlZmczM4eEEzZG42MEtJNjhkU0Vj?=
	=?utf-8?B?dzhSN0V6bEZub1BKM2ZzK1ltY2h4THI4QXkwYzQ4Qyt4NUMzSmRUcjIrTXNw?=
	=?utf-8?B?RWF2Wk5yNWhBQUUxVXE4ZEMwbHpKZ3dQQ2poTkxZek5pZDJsZ3RWMlhsMmc1?=
	=?utf-8?B?YTdScDhEWnQzaFA4aDcyL2EveXJnQmxOSmhnbktPZSttVHplbi9XbitITy9P?=
	=?utf-8?B?MHNIMG1NOGtVOFJzM2lCVzI2dElqUHNhbUNwblRuTnlnU0hBYllvNTFsL2VD?=
	=?utf-8?B?ZFRFOEhNcW5LMjVWTnFWWlByYVBWV1haSmpsN0hNVWI3ZlR5cllxMUxscFdk?=
	=?utf-8?B?QVpkT25qTWJDL2Jwd3kyaVBUdm8zS0kxaTY5OXJoV0J0ZlhUS29sTi9CZUQx?=
	=?utf-8?B?akVhcGJWMGcwTEw3TFlpcnZ4OW9TRTBQME50RFIrQmNQY09CbkhOa2pmZVJF?=
	=?utf-8?B?eWZjZ1craytaQmNtNUtsajM5cDlUN2JCbFdjVlBGc1ZVSUlIV0pXeHRpQXFh?=
	=?utf-8?B?encyZjFWNkM4NG1OSnZGc2hsYmZLc2RCVkNPSVZoZ0t4NzF0Z0cvVi9DNWFp?=
	=?utf-8?B?OGt5WG5aVnlodFhsUzEvWHYwblRJcENCMGNxMjlVMjYxVGJVSVVkSndTQzNa?=
	=?utf-8?B?dDRTMHBvL0FBSGJ0bDBORS8zbWdZT3BJeGFtbk01NURkcmIwMmYwUFZjWFNN?=
	=?utf-8?B?emZZQ2NHbUlTMDFMZUZ4Q0FFOXh6YXc5S0pqVFM3SU03VEt4VlIveU5KVGNz?=
	=?utf-8?B?M2FOYTE0SW5SUER0KzNMVWEzYU1LMXptUFI5VVVGSHZub3lxeUM1R0M5WldN?=
	=?utf-8?B?YmoxRVAwYTJWS29aK1ZMRVBqZDVmUlJyWjRPU0MrUDd5Mlp0RDZUWkFKNVlG?=
	=?utf-8?B?aGx1ZlhDNkdLM09OTnp3M2NPTW1MRm44cVhBdURteVVzdEppeUVFMktaemt1?=
	=?utf-8?B?SE9wN2N3TndyRzdLTEVTa0p5cjFGZzlUOHZVV2FQVzU2eUc0REsyMlN5N0FG?=
	=?utf-8?B?Z1hjQUcrTU0welFtTWl2Vy9wd2R3bGJ0OWNMcnR1WkJHT1BQMWNFemJxMnpM?=
	=?utf-8?B?RlBKRmV1VS9wbkhGT3hySEZML21LeStXVTJOa21KWkZyYUp0TSttRlVIVUtN?=
	=?utf-8?B?VkRFWENmaGRxQ1A1MWJlNmJrTU5qTTlZUkZndzlvMGs0OVJKM2VmNEIwVHJG?=
	=?utf-8?B?RUpQdVRFUi85M2piQVg3NHVadDBBbE1zRzVoSG1hZmVjMVNSQ2NZdU4zVTlP?=
	=?utf-8?B?bW9LOVBWak1OTGxkQkJwVHlWWnZCZm5vcFhlcEgvUy8vSDJWd3dlZlZBWVly?=
	=?utf-8?B?VWJuNTJIbW1CMStqdkU0WUw4b3cxRVhPV0w3NUhzMDhZd01jRGVkdzUrQWhS?=
	=?utf-8?B?a3lzdzNja1lZazliSWNoL0RHWTMycWFtOURSbFQrMUVKN1I1N0sxQ25jUmdT?=
	=?utf-8?B?VC9LSnhnd3hLRjF0NCtFYXljdVdKclR0TkZuUWRqRWZZV3M4Z2NaV0lXbFYv?=
	=?utf-8?B?cTdsZG05MnJsaURFcGRTTGMrL2N2UWhkOE93RVQ1ZUlCMnB6QVV4NUpsaFFt?=
	=?utf-8?Q?WU7/gqJYzng2s6jpSt/ZGQwfS8bPrhmRuRS0buy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3ef0f1-f928-431c-7ca6-08d91fb09785
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:09:16.7148 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmnMuRMcUiBDGqRYAaBiOPxbkz86tcu5Av8i+Dpoebr7SGUhRivG6aXyuJgRJM0M+wVoirw34VvF1lRxUIlduDUCM09dUo7M/m1daFKeUWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	malwarescore=0 spamscore=0
	adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250117
X-Proofpoint-GUID: YGSOB72yRvIgedu4FXeTg0mkCSM8pr8L
X-Proofpoint-ORIG-GUID: YGSOB72yRvIgedu4FXeTg0mkCSM8pr8L
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	mlxscore=0 clxscore=1015
	malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
	adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250117
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 26 May 2021 06:59:53 -0400
Subject: Re: [dm-devel] [PATCH v4 02/11] block: introduce bio zone helpers
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 5/24/21 9:25 PM, Damien Le Moal wrote:
> Introduce the helper functions bio_zone_no() and bio_zone_is_seq().
> Both are the BIO counterparts of the request helpers blk_rq_zone_no()
> and blk_rq_zone_is_seq(), respectively returning the number of the
> target zone of a bio and true if the BIO target zone is sequential.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>   include/linux/blkdev.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f69c75bd6d27..2db0f376f5d9 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1008,6 +1008,18 @@ static inline unsigned int blk_rq_stats_sectors(const struct request *rq)
>   /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
>   const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
>   
> +static inline unsigned int bio_zone_no(struct bio *bio)
> +{
> +	return blk_queue_zone_no(bdev_get_queue(bio->bi_bdev),
> +				 bio->bi_iter.bi_sector);
> +}
> +
> +static inline unsigned int bio_zone_is_seq(struct bio *bio)
> +{
> +	return blk_queue_zone_is_seq(bdev_get_queue(bio->bi_bdev),
> +				     bio->bi_iter.bi_sector);
> +}
> +
>   static inline unsigned int blk_rq_zone_no(struct request *rq)
>   {
>   	return blk_queue_zone_no(rq->q, blk_rq_pos(rq));
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


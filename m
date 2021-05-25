Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DA7C2B9F7
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 97C8E613F5
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97C8E613F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-eLpdWQNyOT2C4GIpZaozrQ-1; Wed, 26 May 2021 07:00:04 -0400
X-MC-Unique: eLpdWQNyOT2C4GIpZaozrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B951100945E;
	Wed, 26 May 2021 11:00:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A75BF36DE;
	Wed, 26 May 2021 10:59:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 74BBC9987;
	Wed, 26 May 2021 10:59:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PJDmNI023616 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 15:13:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 599D42087A35; Tue, 25 May 2021 19:13:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 546392087A31
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:13:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B901918E092D
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:13:45 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-379-DXGclRpuMFyPXVumjtnBGg-1; Tue, 25 May 2021 15:13:41 -0400
X-MC-Unique: DXGclRpuMFyPXVumjtnBGg-1
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJ5q9w132403; Tue, 25 May 2021 19:13:38 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 38ptkp70cp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:13:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJ5G7D009020; Tue, 25 May 2021 19:13:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
	by userp3030.oracle.com with ESMTP id 38pq2ugup2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:13:38 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
	by SA2PR10MB4683.namprd10.prod.outlook.com (2603:10b6:806:112::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27;
	Tue, 25 May 2021 19:13:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 19:13:36 +0000
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-9-damien.lemoal@wdc.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <e7f1d9c8-c0f5-424e-fa41-25fa6c7eb21d@oracle.com>
Date: Tue, 25 May 2021 14:13:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.1
In-Reply-To: <20210525022539.119661-9-damien.lemoal@wdc.com>
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN2PR01CA0064.prod.exchangelabs.com (2603:10b6:800::32) To
	SN6PR10MB2943.namprd10.prod.outlook.com
	(2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by
	SN2PR01CA0064.prod.exchangelabs.com (2603:10b6:800::32) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20
	via Frontend Transport; Tue, 25 May 2021 19:13:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72461ce1-9157-4539-064d-08d91fb13257
X-MS-TrafficTypeDiagnostic: SA2PR10MB4683:
X-Microsoft-Antispam-PRVS: <SA2PR10MB46833D97A2D167882BE980AEE6259@SA2PR10MB4683.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: XPjOuZh6wg4BF8qGbVptRm8q3DYvwUDQqUmTAxmFU7EdkGpEK2TXoSWE8S56cxQ4ilJfD6VptY6UhWy98VdIHG15DMDaolHCbTebYhB3QV5hBA9jQesORH7Qou74EimKAQNbWuDHhsf3hU6bZwIKqWI2cfj+ioLXg8hizjrCrVrdkNRWFzGfT1E9LNmf0HwmRX8CSHBIX2Oll31wJUOnxkP9dkpbc5MxFTnXcvkKrgmB0T+NnP/73r+qiVAkydU4LGOQliue9UtdIv88x1jxXmrNB72o97+KWm41cRKhQpk3T0O+Nm9ZwdyC3lLKSWLxohp89M6mBgGWILGPuOz+nESeDr08oax5I81C8KgPaANsDjGoSnuzdn6Vxqoh+PYhPV9SH8cDCZpWPXsWrzmI8LoEcR2iEgsS/GyL+tpQO5xyo3tWDYuXdTm0/Z0pVC0f69zO/rgGtfCzwHJfIPKum5NuUUE8YprlVFE5kU4ujR5VXuRqcsloq1pG7XkI78Dq+duEdSg3wRqH+n1orrq4mDt5V9gXjxQQMj8yjRIUpWHzkEnHdAjpBtaxUrwLz41MgJf3Zw9k4LT2RhIoih0I+GGQuJPsnp4HHo+k86gTN/aZxk3IJ4H5+qnzdPx4lG5RGuIMfFI2ap3HGXmD1GZo+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN6PR10MB2943.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(31686004)(44832011)(53546011)(956004)(16576012)(2906002)(2616005)(186003)(6486002)(36916002)(316002)(8936002)(16526019)(478600001)(36756003)(26005)(110136005)(83380400001)(8676002)(31696002)(66556008)(66476007)(66946007)(5660300002)(38100700002)(86362001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RVVjZWZ5Qk5CbzhYdm9OMG9FUUdtMFBiYjJZT2JvNUNjSGp5MENyUHk2U3M3?=
	=?utf-8?B?b1lqYXZKY255WXZkT3l5UlVBeGpTRklaOWNab2ZibkhxSE5pbmEycmlNelRW?=
	=?utf-8?B?eGhLNno5eXJiMXZFazcvSkpnSFpyRWJvZFJUTit4Qk5LR0dHeFhIc05FQ2Fj?=
	=?utf-8?B?cENPWUYzL0I2TTJmd3RzdkY2WHRyd2JXVjRaWEgxb1B0UlQrNlpLYXoveEY2?=
	=?utf-8?B?Yi9rUkNJWEROb2xoV0ZuV2hYNDhLVHJsTGZZcGtmczg1di9kTGlmNWpyekN6?=
	=?utf-8?B?bVZpZXJrNGthNld1QzRyME1zeVlhOFdjRnN6TEl5andTQzFxVG4xaWlxNXhL?=
	=?utf-8?B?MUVRZlFETFN4dmJCZEljMnl6NEV3TEtBUXV4TVN1Z0pHYUZ2OTdLRm82Lzlx?=
	=?utf-8?B?dW9JUmNyVlNQNmpMVDRBZGdIQVgxdHlwVTJJYUlsVHh6cjZRRVRQeHdMR2Z5?=
	=?utf-8?B?bitzeXJGbFBoZE9iU0VwT3NxWC9Db01GVkhGYlBzeGVleDZiYkZEdEFJaUZZ?=
	=?utf-8?B?VnVnZXJ4azFHazZ1aGhXb3J2WVlYeGNzMHovS3VtYU5rWlR3MzBmb1FEM2tT?=
	=?utf-8?B?QURFdTZndWFGNWxQR2YvOFA1NFNHQzh3S1NqV2R1U3lKK2poc094b0FWRWtL?=
	=?utf-8?B?SWhSODU3TExTd2ZOZ2hlZDlTc3ZRR2pScy9wMlpIUExqWktZeWt2ck9LUUo4?=
	=?utf-8?B?QzMxMlFpdnloQXJQdENnOTdDUC94eUhBWjZCanNzSVRyT3RIWjl4WTVhWS8x?=
	=?utf-8?B?KzFadFZnbFdNUEFwRVJOcVdMUndtbkc2L2dKeC9vOUxVSkp2ZHgwdCtXTk9H?=
	=?utf-8?B?aXFnbThPS0M5YVZiNmdXYmJUNDQ0OGlNOWhvaTQyYXRTWE9MRnVod1N3TkY0?=
	=?utf-8?B?NmxxNDFTcUpFRDlPTDlzZmFlSlV5SWYvZld1RFBEWVdVOU95aW5sSzdtNGRD?=
	=?utf-8?B?cU1qTlVEQ3R0cm9hMnQ0R0J5V3lVYzZmL1BTUW81SjZ2dk1qb2dmMUFETHJX?=
	=?utf-8?B?bXYvM1lYM2M3K2pCZ3VOcGw3cTNodEdiVWNBWktJUmxNcnkrL1FzVXpIcTNx?=
	=?utf-8?B?MHZkSlVuOTBkZmRDaTFkNHgycjNqQSs1ODVsb2kzSXpzaGx2TjZKcStNaFYy?=
	=?utf-8?B?TUQxM0g0NXhEV09ObjhqN0o5YnNPVEMxMjBaSkloUm1JSk5FM1p5RXE0a0JP?=
	=?utf-8?B?UXhpYi9pb2NYUHczbnEwaysrRUdVZWp0QzBsQStaOVc3VEEyWWdRODdEOHNE?=
	=?utf-8?B?U0Fsa29jTUxvcUxUVWVrWDZDVDhkYkwwOEpvcjhKY1JjK0t6VjVJVTZpKzJq?=
	=?utf-8?B?SlVpWnNWUjNXbnNnR3NuZXZnTE5FZWFlL0dINUR4bitKREg2QXVQclhSZEZm?=
	=?utf-8?B?a3lybWQ1YlozbG1sUEZ5WlYwNktBWUIvR0NyYit3SWJ5MDc3bnlHVWJVOE56?=
	=?utf-8?B?Q2FtZC9xeXp6TmNVSmJ1Z1pRbVhYWnB6aHBWeTVtT0hFQUdUc2pUZUdOK3lF?=
	=?utf-8?B?SDN3SlZVNlJtSkdqUDdCUU9zdHZ5b1FtcHFEaXMwSmZyUlBhcG93Q1FXMUVx?=
	=?utf-8?B?OHk5dExkamJZWWNHOUhqeVBhd1M4QjlyY1NHWnpTMnQ3a1oxQ0R3QWNyR2dt?=
	=?utf-8?B?dUk1a25tYVpwTEQ0ajFzMStHV3lvTzFPNnI5Z2ozb2tKZDlMWkg1Q1NKNXo4?=
	=?utf-8?B?NzgrNHBWbFFEdmVHanFPSVVpT1JwQ0todjQwQm5ITy8wczJ4WnpCYkdNZ01D?=
	=?utf-8?Q?E0/zh8WMycSxJt6dtpdJUXEppzRzzr71tGHin/I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72461ce1-9157-4539-064d-08d91fb13257
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:13:36.4961 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JsA1ADwuxUDaNAquB0q2SifGIsRhuxy3Jo2pj/NSXRBGawcg7Z09inWtWomtJY1wu9aCIO/Q3G3UxSVYBvOoxmT2YskEqya/hlnjW7OVbFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4683
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	malwarescore=0 spamscore=0
	adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250117
X-Proofpoint-GUID: LsySq-wGEeOZuAEXyzGZW2cPK1Q_TKw2
X-Proofpoint-ORIG-GUID: LsySq-wGEeOZuAEXyzGZW2cPK1Q_TKw2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
	mlxscore=0
	suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
	malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
	priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250117
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
X-Mailman-Approved-At: Wed, 26 May 2021 06:59:53 -0400
Subject: Re: [dm-devel] [PATCH v4 08/11] dm: Forbid requeue of writes to
	zones
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 5/24/21 9:25 PM, Damien Le Moal wrote:
> A target map method requesting the requeue of a bio with
> DM_MAPIO_REQUEUE or completing it with DM_ENDIO_REQUEUE can cause
> unaligned write errors if the bio is a write operation targeting a
> sequential zone. If a zoned target request such a requeue, warn about
> it and kill the IO.
> 
> The function dm_is_zone_write() is introduced to detect write operations
> to zoned targets.
> 
> This change does not affect the target drivers supporting zoned devices
> and exposing a zoned device, namely dm-crypt, dm-linear and dm-flakey as
> none of these targets ever request a requeue.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/md/dm-zone.c | 17 +++++++++++++++++
>   drivers/md/dm.c      | 18 +++++++++++++++---
>   drivers/md/dm.h      |  5 +++++
>   3 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index b42474043249..edc3bbb45637 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -104,6 +104,23 @@ int dm_report_zones(struct block_device *bdev, sector_t start, sector_t sector,
>   }
>   EXPORT_SYMBOL_GPL(dm_report_zones);
>   
> +bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
> +{
> +	struct request_queue *q = md->queue;
> +
> +	if (!blk_queue_is_zoned(q))
> +		return false;
> +
> +	switch (bio_op(bio)) {
> +	case REQ_OP_WRITE_ZEROES:
> +	case REQ_OP_WRITE_SAME:
> +	case REQ_OP_WRITE:
> +		return !op_is_flush(bio->bi_opf) && bio_sectors(bio);
> +	default:
> +		return false;
> +	}
> +}
> +
>   void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>   {
>   	if (!blk_queue_is_zoned(q))
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 45d2dc2ee844..4426019a89cc 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -846,11 +846,15 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>   			 * Target requested pushing back the I/O.
>   			 */
>   			spin_lock_irqsave(&md->deferred_lock, flags);
> -			if (__noflush_suspending(md))
> +			if (__noflush_suspending(md) &&
> +			    !WARN_ON_ONCE(dm_is_zone_write(md, bio)))
>   				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
>   				bio_list_add_head(&md->deferred, io->orig_bio);
>   			else
> -				/* noflush suspend was interrupted. */
> +				/*
> +				 * noflush suspend was interrupted or this is
> +				 * a write to a zoned target.
> +				 */
>   				io->status = BLK_STS_IOERR;
>   			spin_unlock_irqrestore(&md->deferred_lock, flags);
>   		}
> @@ -947,7 +951,15 @@ static void clone_endio(struct bio *bio)
>   		int r = endio(tio->ti, bio, &error);
>   		switch (r) {
>   		case DM_ENDIO_REQUEUE:
> -			error = BLK_STS_DM_REQUEUE;
> +			/*
> +			 * Requeuing writes to a sequential zone of a zoned
> +			 * target will break the sequential write pattern:
> +			 * fail such IO.
> +			 */
> +			if (WARN_ON_ONCE(dm_is_zone_write(md, bio)))
> +				error = BLK_STS_IOERR;
> +			else
> +				error = BLK_STS_DM_REQUEUE;
>   			fallthrough;
>   		case DM_ENDIO_DONE:
>   			break;
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index fdf1536a4b62..39c243258e24 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -107,8 +107,13 @@ void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q);
>   #ifdef CONFIG_BLK_DEV_ZONED
>   int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
>   			unsigned int nr_zones, report_zones_cb cb, void *data);
> +bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
>   #else
>   #define dm_blk_report_zones	NULL
> +static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
> +{
> +	return false;
> +}
>   #endif
>   
>   /*-----------------------------------------------------------------
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


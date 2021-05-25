Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49619C47082
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 993E96109E
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 993E96109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-aE97qnViOraJpIyhg-j1Ug-1; Wed, 26 May 2021 07:00:04 -0400
X-MC-Unique: aE97qnViOraJpIyhg-j1Ug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BE3C180FD66;
	Wed, 26 May 2021 11:00:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A225E61094;
	Wed, 26 May 2021 10:59:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 76313180B463;
	Wed, 26 May 2021 10:59:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PJAONI023412 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 15:10:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 224C1FC72B; Tue, 25 May 2021 19:10:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BE10F9AAD
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:10:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42B0C8339A6
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:10:20 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-534-yCLvutkbPdGSQDZ8qEcXqg-1; Tue, 25 May 2021 15:10:16 -0400
X-MC-Unique: yCLvutkbPdGSQDZ8qEcXqg-1
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJ56mO109942; Tue, 25 May 2021 19:10:14 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38rne42m8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:10:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJ6CxW105796; Tue, 25 May 2021 19:10:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by userp3020.oracle.com with ESMTP id 38qbqshmn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:10:13 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
	by SN6PR10MB3024.namprd10.prod.outlook.com (2603:10b6:805:d1::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28;
	Tue, 25 May 2021 19:10:11 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 19:10:11 +0000
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-6-damien.lemoal@wdc.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <fc584a3e-12f7-6ecb-1e38-98e69b93849f@oracle.com>
Date: Tue, 25 May 2021 14:10:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.1
In-Reply-To: <20210525022539.119661-6-damien.lemoal@wdc.com>
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA9PR13CA0004.namprd13.prod.outlook.com
	(2603:10b6:806:21::9) To SN6PR10MB2943.namprd10.prod.outlook.com
	(2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by
	SA9PR13CA0004.namprd13.prod.outlook.com (2603:10b6:806:21::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12
	via Frontend Transport; Tue, 25 May 2021 19:10:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12757a94-0870-49fa-e73e-08d91fb0b844
X-MS-TrafficTypeDiagnostic: SN6PR10MB3024:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3024C9E2CD98942D577D364AE6259@SN6PR10MB3024.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: CTCveVA2QqfVTmJ82XsjbwbpQrKAkuawBuZmg5uj7ebC/B0VpBudKsrSWfWUblsbiyqM0k+JXNeUUMuAIQoyAyDbIvwWfKuWioFar8ISw+SpZKBis82RUcKM9UL8m5GcJd/ZBdpqqA04/HQi97l0F5WJbcOD2eiDq3wmibkVxpYvhpJXEP/TiBwr5H9ZB8m/+2IQ+JE/0orwT9geuZTJJddzzKVTtQWU9LlFbAPy3DEIfVujzYV+FLDfVF6UFjQJN+eCeouCRvnxp8B7z+2kkXFmeDXTadFouHXith28O9sQTi4cejOvO/oHCiI/GHoWX6V4et8PHrfQZi2qlPr4r09sjfl6gBxRBPA/d3rMTOhotBh0ZtEVik1LRsDEo8Hh5FlYiVXo6naarqu0WyjuMyFFvBApBWqbg7XTQgmN1yuR8wbR4yaUw5D1KdRHuNAsVn3+GyAAUMcGgJ/X3ZTKEusXG4c9iVmTr4KfVYgEas2ITuqJdX09SgJfRVq1M4URq0CURHY+GaPEKhSfZxs3Z/s710ShskRMEH34KmFjSfZzRXfPzST3jlYclyRYjowBPfX4djTkTmdBO2uV9bxlSsyokpjpMkiFmnS3MsSQShjbLuUruJzpqAAaSxtvzmibAtEuSy2SrHUdgITNL1nykFwtWUyiVOr4SOwrIdz6hQYCTMm+wEoFG7oNsW427eCK
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN6PR10MB2943.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(39860400002)(346002)(366004)(136003)(376002)(2616005)(66556008)(66476007)(110136005)(8936002)(26005)(2906002)(83380400001)(6486002)(31696002)(66946007)(31686004)(38100700002)(956004)(186003)(53546011)(86362001)(8676002)(36916002)(44832011)(478600001)(16526019)(16576012)(36756003)(316002)(5660300002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NnppNGUvNmtQam5MSHYvWFZhOTB2dGNuei91UHZlOXBLL2plM2xmQkJ3eVR4?=
	=?utf-8?B?aGhMekFHTHZxVVUrYWRVVS9wZHM5eFJXNXluTjZrMmw0WEx3a3ZkSTNPR2ls?=
	=?utf-8?B?Y2xkdUk5VWk1REFMZmNHYjFTTUFHaVNnRkpQMVEraUpjNmU4OGZaaWIwc0V6?=
	=?utf-8?B?aDY2VG0ydjJCQXdiU2R3a0xBWU14eGF6Z200azJEV0tIc1RnVUtIa1RqcjhJ?=
	=?utf-8?B?Y24raENoeTVOc3h2RGJ2OVdmRDM3UTFnM1ljSWRoUkR3ajJwMm5URU5laFF1?=
	=?utf-8?B?ZklCdmZKUFM2K1gwaHdFblBHZVVyR2ViWlA4dDVrRzBlMzc4ZndpZTA2MVdM?=
	=?utf-8?B?TWtGRlRSRW5nemJ2R0krZW5haTBHM3pZci9vQ2Q1c1NlTTFQeFkrdy96QnhP?=
	=?utf-8?B?YnF3em50N240dmdYMTgxeE8wZzBsVHM3V2V4TjFMS1BYOVhLcXNreTZweng0?=
	=?utf-8?B?RE1YWitjRlFlMmpyenVXSTRLdUlkbTNTYlpTN0g1djgzODdMR0FRUVg1RXRz?=
	=?utf-8?B?WFJ3VWRlZytKelRDMDNFbWtHbWs1dkM0TUdpWFNPak4yMzRNdmdDQnEyK0Q2?=
	=?utf-8?B?RXJXb2VXOGMvQnJ6Y1NERG5Db3RvK1B5L3dMNFc5ZEZWTkthM2NHYjg3RFJy?=
	=?utf-8?B?TjN5SGlVaU8vcVo3MzZwQnVGd0NUdk1Kd0dvU0VIUGE1am1Wb2xjb2YzS1dn?=
	=?utf-8?B?bnV3d09DYjdNcWx1eHA4dHZINHhGOXJ4OFpGbVEwL1ZCa1doYU9tTVQ2R2VD?=
	=?utf-8?B?TjFydVYvWkErN0hyYWVIdVF5eW5RQnlFQXhDV3QrTUlyR2tuUUJFaXlxa0Vl?=
	=?utf-8?B?bmRUSEU2Z2FlcUw0c3hOTjVMeFk4VmhnSEF2MFAyOGttNnc2NjFuYjBhRkxF?=
	=?utf-8?B?SXExZlNaMHZKTWlnTkQ5UytwRlpQcVdaQUNKTzVxckkzOG95dGZIMlBISitV?=
	=?utf-8?B?V2lvdWdDeWpjK3MvU0ZLZ2pkcnFpYzNYb2IyKzU2R1F1WWkwUVFYWGM0N01E?=
	=?utf-8?B?THRQZURGVXk0VDQ4dVdOV25pRjFsallFMlNoaDBtNzVyS1ZJWloydmQ5aWxO?=
	=?utf-8?B?USs0L0ZHQzYwM3hXR1NiYVkwOTFYYnVNWnpwTEhYSmdFa29ZcUFHbk9JcVhR?=
	=?utf-8?B?RDU4Z1RJcDQxNzZxazBXeldiTjhPTEkvamNaWmMwb3JsdnhjL01mMUhqK0Qz?=
	=?utf-8?B?bDdqSjRvbFZXL2FoTm1ibThDdVNTRnNTeDcwb3d3Y3dmUVhXRXZXN2F5UDMy?=
	=?utf-8?B?b25XTVJValV5SE5zVm9HdTZqZEtjTHhLeWJ3ZlkvWGtwaVhaSm5OeUxPSTFp?=
	=?utf-8?B?TmtMY3pmUjcxYXVQdkZkc2FSeG5UTGlBd0JPM3lNblFSU285L3UzUklWMjRZ?=
	=?utf-8?B?VSt1RE1sWWQzejhnL2tOdXA1ZnFERC9UZTlIbk41YmdYYkdrTmxIeHhSRUZZ?=
	=?utf-8?B?RnBuclBha1pDaitlSVVtZ2ZIWCtFcWNiSTVIWjdVTDg1MllUUnZ4ekVqZXdv?=
	=?utf-8?B?OW9IMWJmS0NLYnRGYy9TQ0sySzZVejRuR2x5VVBCbW8yNENtckVqVjlERmNh?=
	=?utf-8?B?d2ZjUHg5eVJ0enVTeHkzK2tINHU5Ym45MlJTVlVsSmxtMk9VMmFrcFlKYmZX?=
	=?utf-8?B?bE1NSXJSS2tWWnpyNzY3TlQ0Z2tOWHNHemJaUGFhd1ZjeGZqcWIya3MrUElN?=
	=?utf-8?B?TkdaYVFnUkk2UUM4WDF3M3NST2VEZ3FXd1ZSY0RqbG05cHVuK3NEelBZNHZD?=
	=?utf-8?Q?flEK9XXI4JRXqryhigfwtLV9iqrCb1BIxM93w2I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12757a94-0870-49fa-e73e-08d91fb0b844
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:10:11.6603 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0kaSrdf2ZLQMre3gmWKUaykxiTD4Deb0GGNbvj9uchhWLnjyuS3cTvbjGCKcN2/xFRYD8Tmkq+ZKF+IiYoIc0226ssxfu1l5FOMOU9+5kE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3024
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	phishscore=0 bulkscore=0
	mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250117
X-Proofpoint-ORIG-GUID: q55Xpm4_IX5uMrf0BrUlcTld9CcTp0YM
X-Proofpoint-GUID: q55Xpm4_IX5uMrf0BrUlcTld9CcTp0YM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	bulkscore=0 phishscore=0
	mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
	lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250117
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
Subject: Re: [dm-devel] [PATCH v4 05/11] dm: cleanup device_area_is_invalid()
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
> In device_area_is_invalid(), use bdev_is_zoned() instead of open
> coding the test on the zoned model returned by bdev_zoned_model().
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/md/dm-table.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index ee47a332b462..21fd9cd4da32 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -249,7 +249,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>   	 * If the target is mapped to zoned block device(s), check
>   	 * that the zones are not partially mapped.
>   	 */
> -	if (bdev_zoned_model(bdev) != BLK_ZONED_NONE) {
> +	if (bdev_is_zoned(bdev)) {
>   		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>   
>   		if (start & (zone_sectors - 1)) {
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


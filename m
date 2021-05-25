Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4943EC47089
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B77926109E
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 11:00:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B77926109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-wBURl_ALN1mDa98gubSV9w-1; Wed, 26 May 2021 07:00:27 -0400
X-MC-Unique: wBURl_ALN1mDa98gubSV9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3CAE1009478;
	Wed, 26 May 2021 11:00:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 99E8419718;
	Wed, 26 May 2021 11:00:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6630355351;
	Wed, 26 May 2021 11:00:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PJeg7O026249 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 15:40:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 891751033C69; Tue, 25 May 2021 19:40:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81DCD1033C70
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:40:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59C4A80D0E1
	for <dm-devel@redhat.com>; Tue, 25 May 2021 19:40:39 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-482-pMMa6B_GOZ-eudPIbsu3Ww-1; Tue, 25 May 2021 15:40:34 -0400
X-MC-Unique: pMMa6B_GOZ-eudPIbsu3Ww-1
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJZfW2167708; Tue, 25 May 2021 19:40:32 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by userp2120.oracle.com with ESMTP id 38ptkp7256-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:40:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14PJe4C8078575; Tue, 25 May 2021 19:40:31 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com
	(mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
	by aserp3030.oracle.com with ESMTP id 38pr0c2s98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 May 2021 19:40:30 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
	by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27;
	Tue, 25 May 2021 19:40:28 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
	([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 19:40:28 +0000
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-11-damien.lemoal@wdc.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <3cae5436-ad50-e777-6cd6-e7891c152ffd@oracle.com>
Date: Tue, 25 May 2021 14:40:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.1
In-Reply-To: <20210525022539.119661-11-damien.lemoal@wdc.com>
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0701CA0035.namprd07.prod.outlook.com
	(2603:10b6:803:2d::25) To SN6PR10MB2943.namprd10.prod.outlook.com
	(2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by
	SN4PR0701CA0035.namprd07.prod.outlook.com
	(2603:10b6:803:2d::25) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4150.24 via Frontend Transport;
	Tue, 25 May 2021 19:40:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d2a19d8-7055-4d5e-b79a-08d91fb4f329
X-MS-TrafficTypeDiagnostic: SA2PR10MB4537:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4537E2354DE19FDFABF62702E6259@SA2PR10MB4537.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:800
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Ovg/m/NfXPE2TlklwFaw00+lEKOFs08g3jZTvI5DjPvrdA+1udbBbDBmQSdaqVJ6kGXq2CspXcwbb1YEq5Q1QNKQFNYYfdZqpjdjwsbejtNm10qxUP4hEp10jRTSEItgcgl8MXRO4S2KtNw/3qYVoq6shGg9Yfo2R4v3dfh801HfeaoQ/XvnZi4TmWA4ePvYljxKL66rhhgt71DlklHclzVgVfL/oVu+RBEgHf1mjn0rPeg/K/2T84D2bfBcylvMg/0iXhnzgyGL/w1wYFH8inY/5m3xIWAfunJR/hrc44BaWzoi3vnIoW4fNzgiL00XBew23EUMRN4VlM2jjwD0IDnNKbkcZePc0SBpXfAM851Qg+7dFE97ibZykxeexU0rh92AtconDtDd1h4o7QL2ALvZauWOwWjncbghcsGlQ+i+w8yXbTqUfywa1Qi6R9CueG09B+lWgf24MZGS3OGURt66UCg4iiamoFrn4IB9PC14U2vU2t5nCw4ceptvvzHEIR0NofoDfY8RZWKS/li4HJVEa2WUV3dPLNcH+QXbwYOERtZqKqreaol8FzLV5gnlr8brxvlk2pjXR4eq6TaGmo46reqkc8cJd0OPbuKqvctHFOKZROIzQby+CPq8PsgGJVyVGTa4YJBPuF6EUPO8pBWCs3yR2umYZ19MVmwmbI6PANayYB98Scf8+EPRCDFc
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN6PR10MB2943.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(396003)(136003)(39860400002)(376002)(366004)(31686004)(8936002)(36916002)(36756003)(8676002)(2906002)(83380400001)(66946007)(5660300002)(38100700002)(53546011)(478600001)(31696002)(66476007)(6486002)(44832011)(2616005)(30864003)(16526019)(66556008)(26005)(86362001)(186003)(110136005)(316002)(16576012)(956004)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dC8vc2dOT3dPQkRnVStnak1hVGd3RUxSZ2U2ZzdlWklQOUJrSmRFYTh1NDBr?=
	=?utf-8?B?SXdRWU5xTHRlbXM1ME1vck8vNXJFVlVmZVVpZGFGWjJ6blhaQkhlWDlDNjR5?=
	=?utf-8?B?MFE3aGRrQjNSOXp0RURicmQwZWJINUlNWVBsamZ2TC91azh6RWhGdy9FK1o0?=
	=?utf-8?B?YlFldm1uWWd6YXlzWWRiZERRdTNFbnhrYVhpNVBiVXl3VXpQVi9aUW9pUVlz?=
	=?utf-8?B?VXFKQllQckdocEJQOU5lSURIb3BxcGJTR2JCYWJ0eWNycGkzaGxlV2lIbWhU?=
	=?utf-8?B?ODJ4NlNnYmtvR1RvTjV2MjhIdGd1UEpOR04yNDliVElTb3VSMXNSUFdrRlRT?=
	=?utf-8?B?c2diQjRUdk02TEZCV3FIZzdVMUlQWGR0MTRRU0cxclJMR0FHY3VOSDl3cFQ3?=
	=?utf-8?B?QXZYdnVaUmJ2UnNxVTlubGYvcWgvTllJNGJlN29Dd2g5VU5hVEREWlNjdDlv?=
	=?utf-8?B?WStCRWV4TXZFNmJ4bXQ3RGdmNVZQSCsrTFpYdkVzT3MrSmRIWk1PZ0puMTFt?=
	=?utf-8?B?YTR4dm5Qa3RPRGVVTEdmSWpKMS9uc0k3bVFyWEp5djkraWwxRjRycUZINUds?=
	=?utf-8?B?UlZtaWlobndIcERzS0pmWkFMaGczVXJXQ0p6WlJJNVVFaFhYWWIyRHBYd0Mz?=
	=?utf-8?B?WVRsbVJFOEhhYmpoWTVBejdndzRXZVV2TmwzbEhHY3FMMXlNeTBIdXA0T05L?=
	=?utf-8?B?R0o0T3drNGR0L25ncm4reWhJS2p4dEMyTURndklubVpDOTlnRGtFbW9RR3FM?=
	=?utf-8?B?bmtzbjhzbHNXZGNEcm1nMEloWHFiSDhCR29OU2o2a3krNUFZQ2IxRzNzOGlk?=
	=?utf-8?B?Y21VTzI1aFUwVWZxWjk3by9IMDViMXBoS0p2Tm02V0JTKzNVZTZoZzNxbWxO?=
	=?utf-8?B?eUxRckFreUxEQ1J6a3B4UFpsNHFiS3JLL1VoNU0vNzRCYXNvSVp1Zm1ZaGJj?=
	=?utf-8?B?Zk5GeSs0by9HNkhrb2FhVWYrdTVOM0ZHNjhORXZXSFRWTGkzTHg2V0tkYXJ3?=
	=?utf-8?B?N2I4T3ZGVXp4TDl3YnF0OHNhTDdoQzVEL091QVoyeHRDQndFYmJQY2gzcXNa?=
	=?utf-8?B?MmUxcVBWNnJRWmF6bVM4Mld5djdSZUh5OE9oNnQ2UHQvYWlxU1Yyajl1TnRs?=
	=?utf-8?B?anBSa2ZCbktGQ1hZOGNGbHo0Unh5djVnem03L1lYbmlPcWUxTnh1OG1udFRG?=
	=?utf-8?B?T3hmTzlseVFRdGJ1N0V1OXNxUTJ5RTBNZGhyM1EwYXUvbXhvelJXMVJIeDEr?=
	=?utf-8?B?R2VBVU1tWFRJNlNEaTNlbm1qTTA2TytRdVFKemZnRnBIQkt2em5HczdoRis0?=
	=?utf-8?B?VWdWaG9IL2c1SlpidU02R040S2kybXJseGxMaEplNXc1L0IzaGs0MERwSDA2?=
	=?utf-8?B?YnowMWV5R1BLYVRPK250WEM4d1pOSFNHUjFKNXdkTndLMFdVUmgxMlJ6cXox?=
	=?utf-8?B?cnk2b3RzQytFQXlVcHIxSGFHeHFNVUJYbUpNMlJHVEZaVXhyWGc2YXVHRnBC?=
	=?utf-8?B?dVdNMDVRbllodWh4MnRTZDdpNXdGSlhsUEc2RWR3aDI1V3QyMzlPV255WEZC?=
	=?utf-8?B?NmZoeHl4MmpreHJ6ZGZsMytGZUpQaWE3a3V3dmpIVGZoNUxTZDlEakM4VUtz?=
	=?utf-8?B?QzFCQVFsWnA2dEVrU04zZ1pSSm94OWdQTTJCQ2dIaXpnZ3I4WmtOa2VuVGZK?=
	=?utf-8?B?ZUhuSXgxUndXeW1MNVphbWpYMnRBRXFDQVNGMUl5SFBHUGhmOTBBL0RydjlL?=
	=?utf-8?Q?RAEXxS7Byn7HwWWchSS86C8+1U8J9PrSBgk1SZi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d2a19d8-7055-4d5e-b79a-08d91fb4f329
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:40:28.4877 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0aXB8yBEWFIQPygnPWOq6OI/JNOu2KUceNMkDS6qpm8wRH7vyybpjy7O5kactFSVZ3bu2X7qGYJGrrkD5SgMlqpEnr9dw0r03IxuGO0X3AA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	bulkscore=0 spamscore=0
	mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250120
X-Proofpoint-GUID: YMY1euU4M9a6W3ynfcvo98lLJOFKmj4g
X-Proofpoint-ORIG-GUID: YMY1euU4M9a6W3ynfcvo98lLJOFKmj4g
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0
	mlxscore=0
	suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
	malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
	priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105250119
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
Subject: Re: [dm-devel] [PATCH v4 10/11] dm: introduce zone append emulation
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
> For zoned targets that cannot support zone append operations, implement
> an emulation using regular write operations. If the original BIO
> submitted by the user is a zone append operation, change its clone into
> a regular write operation directed at the target zone write pointer
> position.
> 
> To do so, an array of write pointer offsets (write pointer position
> relative to the start of a zone) is added to struct mapped_device. All
> operations that modify a sequential zone write pointer (writes, zone
> reset, zone finish and zone append) are intersepted in __map_bio() and
> processed using the new functions dm_zone_map_bio().
> 
> Detection of the target ability to natively support zone append
> operations is done from dm_table_set_restrictions() by calling the
> function dm_set_zones_restrictions(). A target that does not support
> zone append operation, either by explicitly declaring it using the new
> struct dm_target field zone_append_not_supported, or because the device
> table contains a non-zoned device, has its mapped device marked with the
> new flag DMF_ZONE_APPEND_EMULATED. The helper function
> dm_emulate_zone_append() is introduced to test a mapped device for this
> new flag.
> 
> Atomicity of the zones write pointer tracking and updates is done using
> a zone write locking mechanism based on a bitmap. This is similar to
> the block layer method but based on BIOs rather than struct request.
> A zone write lock is taken in dm_zone_map_bio() for any clone BIO with
> an operation type that changes the BIO target zone write pointer
> position. The zone write lock is released if the clone BIO is failed
> before submission or when dm_zone_endio() is called when the clone BIO
> completes.
> 
> The zone write lock bitmap of the mapped device, together with a bitmap
> indicating zone types (conv_zones_bitmap) and the write pointer offset
> array (zwp_offset) are allocated and initialized with a full device zone
> report in dm_set_zones_restrictions() using the function
> dm_revalidate_zones().
> 
> For failed operations that may have modified a zone write pointer, the
> zone write pointer offset is marked as invalid in dm_zone_endio().
> Zones with an invalid write pointer offset are checked and the write
> pointer updated using an internal report zone operation when the
> faulty zone is accessed again by the user.
> 
> All functions added for this emulation have a minimal overhead for
> zoned targets natively supporting zone append operations. Regular
> device targets are also not affected. The added code also does not
> impact builds with CONFIG_BLK_DEV_ZONED disabled by stubbing out all
> dm zone related functions.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   drivers/md/dm-core.h          |  13 +
>   drivers/md/dm-table.c         |  19 +-
>   drivers/md/dm-zone.c          | 580 ++++++++++++++++++++++++++++++++--
>   drivers/md/dm.c               |  38 ++-
>   drivers/md/dm.h               |  16 +-
>   include/linux/device-mapper.h |   6 +
>   6 files changed, 618 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index cfabc1c91f9f..edc1553c4eea 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -114,6 +114,11 @@ struct mapped_device {
>   	bool init_tio_pdu:1;
>   
>   	struct srcu_struct io_barrier;
> +
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	unsigned int nr_zones;
> +	unsigned int *zwp_offset;
> +#endif
>   };
>   
>   /*
> @@ -128,6 +133,7 @@ struct mapped_device {
>   #define DMF_DEFERRED_REMOVE 6
>   #define DMF_SUSPENDED_INTERNALLY 7
>   #define DMF_POST_SUSPENDING 8
> +#define DMF_EMULATE_ZONE_APPEND 9
>   
>   void disable_discard(struct mapped_device *md);
>   void disable_write_same(struct mapped_device *md);
> @@ -143,6 +149,13 @@ static inline struct dm_stats *dm_get_stats(struct mapped_device *md)
>   	return &md->stats;
>   }
>   
> +static inline bool dm_emulate_zone_append(struct mapped_device *md)
> +{
> +	if (blk_queue_is_zoned(md->queue))
> +		return test_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +	return false;
> +}
> +
>   #define DM_TABLE_MAX_DEPTH 16
>   
>   struct dm_table {
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index dd9f648ab598..21fdccfb16cf 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1981,11 +1981,12 @@ static int device_requires_stable_pages(struct dm_target *ti,
>   	return blk_queue_stable_writes(q);
>   }
>   
> -void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> -			       struct queue_limits *limits)
> +int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> +			      struct queue_limits *limits)
>   {
>   	bool wc = false, fua = false;
>   	int page_size = PAGE_SIZE;
> +	int r;
>   
>   	/*
>   	 * Copy table's limits to the DM device's request_queue
> @@ -2064,12 +2065,20 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>   	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
>   		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
>   
> -	/* For a zoned target, setup the zones related queue attributes */
> -	if (blk_queue_is_zoned(q))
> -		dm_set_zones_restrictions(t, q);
> +	/*
> +	 * For a zoned target, setup the zones related queue attributes
> +	 * and resources necessary for zone append emulation if necessary.
> +	 */
> +	if (blk_queue_is_zoned(q)) {
> +		r = dm_set_zones_restrictions(t, q);
> +		if (r)
> +			return r;
> +	}
>   
>   	dm_update_keyslot_manager(q, t);
>   	blk_queue_update_readahead(q);
> +
> +	return 0;
>   }
>   
>   unsigned int dm_table_get_num_targets(struct dm_table *t)
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index edc3bbb45637..c2f26949f5ee 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -4,55 +4,72 @@
>    */
>   
>   #include <linux/blkdev.h>
> +#include <linux/mm.h>
> +#include <linux/sched/mm.h>
> +#include <linux/slab.h>
>   
>   #include "dm-core.h"
>   
> +#define DM_MSG_PREFIX "zone"
> +
> +#define DM_ZONE_INVALID_WP_OFST		UINT_MAX
> +
>   /*
> - * User facing dm device block device report zone operation. This calls the
> - * report_zones operation for each target of a device table. This operation is
> - * generally implemented by targets using dm_report_zones().
> + * For internal zone reports bypassing the top BIO submission path.
>    */
> -int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
> -			unsigned int nr_zones, report_zones_cb cb, void *data)
> +static int dm_blk_do_report_zones(struct mapped_device *md, struct dm_table *t,
> +				  sector_t sector, unsigned int nr_zones,
> +				  report_zones_cb cb, void *data)
>   {
> -	struct mapped_device *md = disk->private_data;
> -	struct dm_table *map;
> -	int srcu_idx, ret;
> +	struct gendisk *disk = md->disk;
> +	int ret;
>   	struct dm_report_zones_args args = {
>   		.next_sector = sector,
>   		.orig_data = data,
>   		.orig_cb = cb,
>   	};
>   
> -	if (dm_suspended_md(md))
> -		return -EAGAIN;
> -
> -	map = dm_get_live_table(md, &srcu_idx);
> -	if (!map) {
> -		ret = -EIO;
> -		goto out;
> -	}
> -
>   	do {
>   		struct dm_target *tgt;
>   
> -		tgt = dm_table_find_target(map, args.next_sector);
> -		if (WARN_ON_ONCE(!tgt->type->report_zones)) {
> -			ret = -EIO;
> -			goto out;
> -		}
> +		tgt = dm_table_find_target(t, args.next_sector);
> +		if (WARN_ON_ONCE(!tgt->type->report_zones))
> +			return -EIO;
>   
>   		args.tgt = tgt;
>   		ret = tgt->type->report_zones(tgt, &args,
>   					      nr_zones - args.zone_idx);
>   		if (ret < 0)
> -			goto out;
> +			return ret;
>   	} while (args.zone_idx < nr_zones &&
>   		 args.next_sector < get_capacity(disk));
>   
> -	ret = args.zone_idx;
> -out:
> +	return args.zone_idx;
> +}
> +
> +/*
> + * User facing dm device block device report zone operation. This calls the
> + * report_zones operation for each target of a device table. This operation is
> + * generally implemented by targets using dm_report_zones().
> + */
> +int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
> +			unsigned int nr_zones, report_zones_cb cb, void *data)
> +{
> +	struct mapped_device *md = disk->private_data;
> +	struct dm_table *map;
> +	int srcu_idx, ret;
> +
> +	if (dm_suspended_md(md))
> +		return -EAGAIN;
> +
> +	map = dm_get_live_table(md, &srcu_idx);
> +	if (!map)
> +		return -EIO;
> +
> +	ret = dm_blk_do_report_zones(md, map, sector, nr_zones, cb, data);
> +
>   	dm_put_live_table(md, srcu_idx);
> +
>   	return ret;
>   }
>   
> @@ -121,16 +138,517 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
>   	}
>   }
>   
> -void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
> +void dm_cleanup_zoned_dev(struct mapped_device *md)
>   {
> -	if (!blk_queue_is_zoned(q))
> -		return;
> +	struct request_queue *q = md->queue;
> +
> +	if (q) {
> +		kfree(q->conv_zones_bitmap);
> +		q->conv_zones_bitmap = NULL;
> +		kfree(q->seq_zones_wlock);
> +		q->seq_zones_wlock = NULL;
> +	}
> +
> +	kvfree(md->zwp_offset);
> +	md->zwp_offset = NULL;
> +	md->nr_zones = 0;
> +}
> +
> +static unsigned int dm_get_zone_wp_offset(struct blk_zone *zone)
> +{
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_IMP_OPEN:
> +	case BLK_ZONE_COND_EXP_OPEN:
> +	case BLK_ZONE_COND_CLOSED:
> +		return zone->wp - zone->start;
> +	case BLK_ZONE_COND_FULL:
> +		return zone->len;
> +	case BLK_ZONE_COND_EMPTY:
> +	case BLK_ZONE_COND_NOT_WP:
> +	case BLK_ZONE_COND_OFFLINE:
> +	case BLK_ZONE_COND_READONLY:
> +	default:
> +		/*
> +		 * Conventional, offline and read-only zones do not have a valid
> +		 * write pointer. Use 0 as for an empty zone.
> +		 */
> +		return 0;
> +	}
> +}
> +
> +static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
> +				 void *data)
> +{
> +	struct mapped_device *md = data;
> +	struct request_queue *q = md->queue;
> +
> +	switch (zone->type) {
> +	case BLK_ZONE_TYPE_CONVENTIONAL:
> +		if (!q->conv_zones_bitmap) {
> +			q->conv_zones_bitmap =
> +				kcalloc(BITS_TO_LONGS(q->nr_zones),
> +					sizeof(unsigned long), GFP_NOIO);
> +			if (!q->conv_zones_bitmap)
> +				return -ENOMEM;
> +		}
> +		set_bit(idx, q->conv_zones_bitmap);
> +		break;
> +	case BLK_ZONE_TYPE_SEQWRITE_REQ:
> +	case BLK_ZONE_TYPE_SEQWRITE_PREF:
> +		if (!q->seq_zones_wlock) {
> +			q->seq_zones_wlock =
> +				kcalloc(BITS_TO_LONGS(q->nr_zones),
> +					sizeof(unsigned long), GFP_NOIO);
> +			if (!q->seq_zones_wlock)
> +				return -ENOMEM;
> +		}
> +		if (!md->zwp_offset) {
> +			md->zwp_offset =
> +				kvcalloc(q->nr_zones, sizeof(unsigned int),
> +					 GFP_NOIO);
> +			if (!md->zwp_offset)
> +				return -ENOMEM;
> +		}
> +		md->zwp_offset[idx] = dm_get_zone_wp_offset(zone);
> +
> +		break;
> +	default:
> +		DMERR("Invalid zone type 0x%x at sectors %llu",
> +		      (int)zone->type, zone->start);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Revalidate the zones of a mapped device to initialize resource necessary
> + * for zone append emulation. Note that we cannot simply use the block layer
> + * blk_revalidate_disk_zones() function here as the mapped device is suspended
> + * (this is called from __bind() context).
> + */
> +static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
> +{
> +	struct request_queue *q = md->queue;
> +	int ret;
> +
> +	/*
> +	 * Check if something changed. If yes, cleanup the current resources
> +	 * and reallocate everything.
> +	 */
> +	if (!q->nr_zones || q->nr_zones != md->nr_zones)
> +		dm_cleanup_zoned_dev(md);
> +	if (md->nr_zones)
> +		return 0;
> +
> +	/* Scan all zones to initialize everything */
> +	ret = dm_blk_do_report_zones(md, t, 0, q->nr_zones,
> +				     dm_zone_revalidate_cb, md);
> +	if (ret < 0)
> +		goto err;
> +	if (ret != q->nr_zones) {
> +		ret = -EIO;
> +		goto err;
> +	}
> +
> +	md->nr_zones = q->nr_zones;
> +
> +	return 0;
> +
> +err:
> +	DMERR("Revalidate zones failed %d", ret);
> +	dm_cleanup_zoned_dev(md);
> +	return ret;
> +}
> +
> +static int device_not_zone_append_capable(struct dm_target *ti,
> +					  struct dm_dev *dev, sector_t start,
> +					  sector_t len, void *data)
> +{
> +	return !blk_queue_is_zoned(bdev_get_queue(dev->bdev));
> +}
> +
> +static bool dm_table_supports_zone_append(struct dm_table *t)
> +{
> +	struct dm_target *ti;
> +	unsigned int i;
> +
> +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> +		ti = dm_table_get_target(t, i);
> +
> +		if (ti->emulate_zone_append)
> +			return false;
> +
> +		if (!ti->type->iterate_devices ||
> +		    ti->type->iterate_devices(ti, device_not_zone_append_capable, NULL))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
> +{
> +	struct mapped_device *md = t->md;
>   
>   	/*
>   	 * For a zoned target, the number of zones should be updated for the
> -	 * correct value to be exposed in sysfs queue/nr_zones. For a BIO based
> -	 * target, this is all that is needed.
> +	 * correct value to be exposed in sysfs queue/nr_zones.
>   	 */
>   	WARN_ON_ONCE(queue_is_mq(q));
> -	q->nr_zones = blkdev_nr_zones(t->md->disk);
> +	q->nr_zones = blkdev_nr_zones(md->disk);
> +
> +	/* Check if zone append is natively supported */
> +	if (dm_table_supports_zone_append(t)) {
> +		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +		dm_cleanup_zoned_dev(md);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Mark the mapped device as needing zone append emulation and
> +	 * initialize the emulation resources once the capacity is set.
> +	 */
> +	set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +	if (!get_capacity(md->disk))
> +		return 0;
> +
> +	return dm_revalidate_zones(md, t);
> +}
> +
> +static int dm_update_zone_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
> +				       void *data)
> +{
> +	unsigned int *wp_offset = data;
> +
> +	*wp_offset = dm_get_zone_wp_offset(zone);
> +
> +	return 0;
> +}
> +
> +static int dm_update_zone_wp_offset(struct mapped_device *md, unsigned int zno,
> +				    unsigned int *wp_ofst)
> +{
> +	sector_t sector = zno * blk_queue_zone_sectors(md->queue);
> +	unsigned int noio_flag;
> +	struct dm_table *t;
> +	int srcu_idx, ret;
> +
> +	t = dm_get_live_table(md, &srcu_idx);
> +	if (!t)
> +		return -EIO;
> +
> +	/*
> +	 * Ensure that all memory allocations in this context are done as if
> +	 * GFP_NOIO was specified.
> +	 */
> +	noio_flag = memalloc_noio_save();
> +	ret = dm_blk_do_report_zones(md, t, sector, 1,
> +				     dm_update_zone_wp_offset_cb, wp_ofst);
> +	memalloc_noio_restore(noio_flag);
> +
> +	dm_put_live_table(md, srcu_idx);
> +
> +	if (ret != 1)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +/*
> + * First phase of BIO mapping for targets with zone append emulation:
> + * check all BIO that change a zone writer pointer and change zone
> + * append operations into regular write operations.
> + */
> +static bool dm_zone_map_bio_begin(struct mapped_device *md,
> +				  struct bio *orig_bio, struct bio *clone)
> +{
> +	sector_t zsectors = blk_queue_zone_sectors(md->queue);
> +	unsigned int zno = bio_zone_no(orig_bio);
> +	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
> +
> +	/*
> +	 * If the target zone is in an error state, recover by inspecting the
> +	 * zone to get its current write pointer position. Note that since the
> +	 * target zone is already locked, a BIO issuing context should never
> +	 * see the zone write in the DM_ZONE_UPDATING_WP_OFST state.
> +	 */
> +	if (zwp_offset == DM_ZONE_INVALID_WP_OFST) {
> +		if (dm_update_zone_wp_offset(md, zno, &zwp_offset))
> +			return false;
> +		WRITE_ONCE(md->zwp_offset[zno], zwp_offset);
> +	}
> +
> +	switch (bio_op(orig_bio)) {
> +	case REQ_OP_ZONE_RESET:
> +	case REQ_OP_ZONE_FINISH:
> +		return true;
> +	case REQ_OP_WRITE_ZEROES:
> +	case REQ_OP_WRITE_SAME:
> +	case REQ_OP_WRITE:
> +		/* Writes must be aligned to the zone write pointer */
> +		if ((clone->bi_iter.bi_sector & (zsectors - 1)) != zwp_offset)
> +			return false;
> +		break;
> +	case REQ_OP_ZONE_APPEND:
> +		/*
> +		 * Change zone append operations into a non-mergeable regular
> +		 * writes directed at the current write pointer position of the
> +		 * target zone.
> +		 */
> +		clone->bi_opf = REQ_OP_WRITE | REQ_NOMERGE |
> +			(orig_bio->bi_opf & (~REQ_OP_MASK));
> +		clone->bi_iter.bi_sector =
> +			orig_bio->bi_iter.bi_sector + zwp_offset;
> +		break;
> +	default:
> +		DMWARN_LIMIT("Invalid BIO operation");
> +		return false;
> +	}
> +
> +	/* Cannot write to a full zone */
> +	if (zwp_offset >= zsectors)
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
> + * Second phase of BIO mapping for targets with zone append emulation:
> + * update the zone write pointer offset array to account for the additional
> + * data written to a zone. Note that at this point, the remapped clone BIO
> + * may already have completed, so we do not touch it.
> + */
> +static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
> +					struct bio *orig_bio,
> +					unsigned int nr_sectors)
> +{
> +	unsigned int zno = bio_zone_no(orig_bio);
> +	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
> +
> +	/* The clone BIO may already have been completed and failed */
> +	if (zwp_offset == DM_ZONE_INVALID_WP_OFST)
> +		return BLK_STS_IOERR;
> +
> +	/* Update the zone wp offset */
> +	switch (bio_op(orig_bio)) {
> +	case REQ_OP_ZONE_RESET:
> +		WRITE_ONCE(md->zwp_offset[zno], 0);
> +		return BLK_STS_OK;
> +	case REQ_OP_ZONE_FINISH:
> +		WRITE_ONCE(md->zwp_offset[zno],
> +			   blk_queue_zone_sectors(md->queue));
> +		return BLK_STS_OK;
> +	case REQ_OP_WRITE_ZEROES:
> +	case REQ_OP_WRITE_SAME:
> +	case REQ_OP_WRITE:
> +		WRITE_ONCE(md->zwp_offset[zno], zwp_offset + nr_sectors);
> +		return BLK_STS_OK;
> +	case REQ_OP_ZONE_APPEND:
> +		/*
> +		 * Check that the target did not truncate the write operation
> +		 * emulating a zone append.
> +		 */
> +		if (nr_sectors != bio_sectors(orig_bio)) {
> +			DMWARN_LIMIT("Truncated write for zone append");
> +			return BLK_STS_IOERR;
> +		}
> +		WRITE_ONCE(md->zwp_offset[zno], zwp_offset + nr_sectors);
> +		return BLK_STS_OK;
> +	default:
> +		DMWARN_LIMIT("Invalid BIO operation");
> +		return BLK_STS_IOERR;
> +	}
> +}
> +
> +static inline void dm_zone_lock(struct request_queue *q,
> +				unsigned int zno, struct bio *clone)
> +{
> +	if (WARN_ON_ONCE(bio_flagged(clone, BIO_ZONE_WRITE_LOCKED)))
> +		return;
> +
> +	wait_on_bit_lock_io(q->seq_zones_wlock, zno, TASK_UNINTERRUPTIBLE);
> +	bio_set_flag(clone, BIO_ZONE_WRITE_LOCKED);
> +}
> +
> +static inline void dm_zone_unlock(struct request_queue *q,
> +				  unsigned int zno, struct bio *clone)
> +{
> +	if (!bio_flagged(clone, BIO_ZONE_WRITE_LOCKED))
> +		return;
> +
> +	WARN_ON_ONCE(!test_bit(zno, q->seq_zones_wlock));
> +	clear_bit_unlock(zno, q->seq_zones_wlock);
> +	smp_mb__after_atomic();
> +	wake_up_bit(q->seq_zones_wlock, zno);
> +
> +	bio_clear_flag(clone, BIO_ZONE_WRITE_LOCKED);
> +}
> +
> +static bool dm_need_zone_wp_tracking(struct bio *orig_bio)
> +{
> +	/*
> +	 * Special processing is not needed for operations that do not need the
> +	 * zone write lock, that is, all operations that target conventional
> +	 * zones and all operations that do not modify directly a sequential
> +	 * zone write pointer.
> +	 */
> +	if (op_is_flush(orig_bio->bi_opf) && !bio_sectors(orig_bio))
> +		return false;
> +	switch (bio_op(orig_bio)) {
> +	case REQ_OP_WRITE_ZEROES:
> +	case REQ_OP_WRITE_SAME:
> +	case REQ_OP_WRITE:
> +	case REQ_OP_ZONE_RESET:
> +	case REQ_OP_ZONE_FINISH:
> +	case REQ_OP_ZONE_APPEND:
> +		return bio_zone_is_seq(orig_bio);
> +	default:
> +		return false;
> +	}
> +}
> +
> +/*
> + * Special IO mapping for targets needing zone append emulation.
> + */
> +int dm_zone_map_bio(struct dm_target_io *tio)
> +{
> +	struct dm_io *io = tio->io;
> +	struct dm_target *ti = tio->ti;
> +	struct mapped_device *md = io->md;
> +	struct request_queue *q = md->queue;
> +	struct bio *orig_bio = io->orig_bio;
> +	struct bio *clone = &tio->clone;
> +	unsigned int zno;
> +	blk_status_t sts;
> +	int r;
> +
> +	/*
> +	 * IOs that do not change a zone write pointer do not need
> +	 * any additional special processing.
> +	 */
> +	if (!dm_need_zone_wp_tracking(orig_bio))
> +		return ti->type->map(ti, clone);
> +
> +	/* Lock the target zone */
> +	zno = bio_zone_no(orig_bio);
> +	dm_zone_lock(q, zno, clone);
> +
> +	/*
> +	 * Check that the bio and the target zone write pointer offset are
> +	 * both valid, and if the bio is a zone append, remap it to a write.
> +	 */
> +	if (!dm_zone_map_bio_begin(md, orig_bio, clone)) {
> +		dm_zone_unlock(q, zno, clone);
> +		return DM_MAPIO_KILL;
> +	}
> +
> +	/*
> +	 * The target map function may issue and complete the IO quickly.
> +	 * Take an extra reference on the IO to make sure it does disappear
> +	 * until we run dm_zone_map_bio_end().
> +	 */
> +	dm_io_inc_pending(io);
> +
> +	/* Let the target do its work */
> +	r = ti->type->map(ti, clone);
> +	switch (r) {
> +	case DM_MAPIO_SUBMITTED:
> +		/*
> +		 * The target submitted the clone BIO. The target zone will
> +		 * be unlocked on completion of the clone.
> +		 */
> +		sts = dm_zone_map_bio_end(md, orig_bio, *tio->len_ptr);
> +		break;
> +	case DM_MAPIO_REMAPPED:
> +		/*
> +		 * The target only remapped the clone BIO. In case of error,
> +		 * unlock the target zone here as the clone will not be
> +		 * submitted.
> +		 */
> +		sts = dm_zone_map_bio_end(md, orig_bio, *tio->len_ptr);
> +		if (sts != BLK_STS_OK)
> +			dm_zone_unlock(q, zno, clone);
> +		break;
> +	case DM_MAPIO_REQUEUE:
> +	case DM_MAPIO_KILL:
> +	default:
> +		dm_zone_unlock(q, zno, clone);
> +		sts = BLK_STS_IOERR;
> +		break;
> +	}
> +
> +	/* Drop the extra reference on the IO */
> +	dm_io_dec_pending(io, sts);
> +
> +	if (sts != BLK_STS_OK)
> +		return DM_MAPIO_KILL;
> +
> +	return r;
> +}
> +
> +/*
> + * IO completion callback called from clone_endio().
> + */
> +void dm_zone_endio(struct dm_io *io, struct bio *clone)
> +{
> +	struct mapped_device *md = io->md;
> +	struct request_queue *q = md->queue;
> +	struct bio *orig_bio = io->orig_bio;
> +	unsigned int zwp_offset;
> +	unsigned int zno;
> +
> +	/*
> +	 * For targets that do not emulate zone append, we only need to
> +	 * handle native zone-append bios.
> +	 */
> +	if (!dm_emulate_zone_append(md)) {
> +		/*
> +		 * Get the offset within the zone of the written sector
> +		 * and add that to the original bio sector position.
> +		 */
> +		if (clone->bi_status == BLK_STS_OK &&
> +		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
> +			sector_t mask = (sector_t)blk_queue_zone_sectors(q) - 1;
> +
> +			orig_bio->bi_iter.bi_sector +=
> +				clone->bi_iter.bi_sector & mask;
> +		}
> +
> +		return;
> +	}
> +
> +	/*
> +	 * For targets that do emulate zone append, if the clone BIO does not
> +	 * own the target zone write lock, we have nothing to do.
> +	 */
> +	if (!bio_flagged(clone, BIO_ZONE_WRITE_LOCKED))
> +		return;
> +
> +	zno = bio_zone_no(orig_bio);
> +
> +	if (clone->bi_status != BLK_STS_OK) {
> +		/*
> +		 * BIOs that modify a zone write pointer may leave the zone
> +		 * in an unknown state in case of failure (e.g. the write
> +		 * pointer was only partially advanced). In this case, set
> +		 * the target zone write pointer as invalid unless it is
> +		 * already being updated.
> +		 */
> +		WRITE_ONCE(md->zwp_offset[zno], DM_ZONE_INVALID_WP_OFST);
> +	} else if (bio_op(orig_bio) == REQ_OP_ZONE_APPEND) {
> +		/*
> +		 * Get the written sector for zone append operation that were
> +		 * emulated using regular write operations.
> +		 */
> +		zwp_offset = READ_ONCE(md->zwp_offset[zno]);
> +		if (WARN_ON_ONCE(zwp_offset < bio_sectors(orig_bio)))
> +			WRITE_ONCE(md->zwp_offset[zno],
> +				   DM_ZONE_INVALID_WP_OFST);
> +		else
> +			orig_bio->bi_iter.bi_sector +=
> +				zwp_offset - bio_sectors(orig_bio);
> +	}
> +
> +	dm_zone_unlock(q, zno, clone);
>   }
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 563504163b74..6c570abc1417 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -875,7 +875,6 @@ static void clone_endio(struct bio *bio)
>   	struct dm_io *io = tio->io;
>   	struct mapped_device *md = tio->io->md;
>   	dm_endio_fn endio = tio->ti->type->end_io;
> -	struct bio *orig_bio = io->orig_bio;
>   	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
>   
>   	if (unlikely(error == BLK_STS_TARGET)) {
> @@ -890,17 +889,8 @@ static void clone_endio(struct bio *bio)
>   			disable_write_zeroes(md);
>   	}
>   
> -	/*
> -	 * For zone-append bios get offset in zone of the written
> -	 * sector and add that to the original bio sector pos.
> -	 */
> -	if (bio_op(orig_bio) == REQ_OP_ZONE_APPEND) {
> -		sector_t written_sector = bio->bi_iter.bi_sector;
> -		struct request_queue *q = orig_bio->bi_bdev->bd_disk->queue;
> -		u64 mask = (u64)blk_queue_zone_sectors(q) - 1;
> -
> -		orig_bio->bi_iter.bi_sector += written_sector & mask;
> -	}
> +	if (blk_queue_is_zoned(q))
> +		dm_zone_endio(io, bio);
>   
>   	if (endio) {
>   		int r = endio(tio->ti, bio, &error);
> @@ -1213,7 +1203,16 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>   		down(&md->swap_bios_semaphore);
>   	}
>   
> -	r = ti->type->map(ti, clone);
> +	/*
> +	 * Check if the IO needs a special mapping due to zone append emulation
> +	 * on zoned target. In this case, dm_zone_map_begin() calls the target
> +	 * map operation.
> +	 */
> +	if (dm_emulate_zone_append(io->md))
> +		r = dm_zone_map_bio(tio);
> +	else
> +		r = ti->type->map(ti, clone);
> +
>   	switch (r) {
>   	case DM_MAPIO_SUBMITTED:
>   		break;
> @@ -1711,6 +1710,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
>   	mutex_destroy(&md->swap_bios_lock);
>   
>   	dm_mq_cleanup_mapped_device(md);
> +	dm_cleanup_zoned_dev(md);
>   }
>   
>   /*
> @@ -1956,11 +1956,16 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>   		goto out;
>   	}
>   
> +	ret = dm_table_set_restrictions(t, q, limits);
> +	if (ret) {
> +		old_map = ERR_PTR(ret);
> +		goto out;
> +	}
> +
>   	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
>   	rcu_assign_pointer(md->map, (void *)t);
>   	md->immutable_target_type = dm_table_get_immutable_target_type(t);
>   
> -	dm_table_set_restrictions(t, q, limits);
>   	if (old_map)
>   		dm_sync_table(md);
>   
> @@ -2079,7 +2084,10 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>   		DMERR("Cannot calculate initial queue limits");
>   		return r;
>   	}
> -	dm_table_set_restrictions(t, md->queue, &limits);
> +	r = dm_table_set_restrictions(t, md->queue, &limits);
> +	if (r)
> +		return r;
> +
>   	blk_register_queue(md->disk);
>   
>   	return 0;
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index 39c243258e24..742d9c80efe1 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -45,6 +45,8 @@ struct dm_dev_internal {
>   
>   struct dm_table;
>   struct dm_md_mempools;
> +struct dm_target_io;
> +struct dm_io;
>   
>   /*-----------------------------------------------------------------
>    * Internal table functions.
> @@ -56,8 +58,8 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
>   bool dm_table_has_no_data_devices(struct dm_table *table);
>   int dm_calculate_queue_limits(struct dm_table *table,
>   			      struct queue_limits *limits);
> -void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> -			       struct queue_limits *limits);
> +int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> +			      struct queue_limits *limits);
>   struct list_head *dm_table_get_devices(struct dm_table *t);
>   void dm_table_presuspend_targets(struct dm_table *t);
>   void dm_table_presuspend_undo_targets(struct dm_table *t);
> @@ -103,17 +105,25 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
>   /*
>    * Zoned targets related functions.
>    */
> -void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q);
> +int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q);
> +void dm_zone_endio(struct dm_io *io, struct bio *clone);
>   #ifdef CONFIG_BLK_DEV_ZONED
> +void dm_cleanup_zoned_dev(struct mapped_device *md);
>   int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
>   			unsigned int nr_zones, report_zones_cb cb, void *data);
>   bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
> +int dm_zone_map_bio(struct dm_target_io *io);
>   #else
> +static inline void dm_cleanup_zoned_dev(struct mapped_device *md) {}
>   #define dm_blk_report_zones	NULL
>   static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
>   {
>   	return false;
>   }
> +static inline int dm_zone_map_bio(struct dm_target_io *tio)
> +{
> +	return DM_MAPIO_KILL;
> +}
>   #endif
>   
>   /*-----------------------------------------------------------------
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index caea0a079d2d..7457d49acf9a 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -361,6 +361,12 @@ struct dm_target {
>   	 * Set if we need to limit the number of in-flight bios when swapping.
>   	 */
>   	bool limit_swap_bios:1;
> +
> +	/*
> +	 * Set if this target implements a a zoned device and needs emulation of
> +	 * zone append operations using regular writes.
> +	 */
> +	bool emulate_zone_append:1;
>   };
>   
>   void *dm_per_bio_data(struct bio *bio, size_t data_size);
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


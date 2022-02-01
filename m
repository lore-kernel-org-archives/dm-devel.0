Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C560C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 06:19:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-FB2yCMTqPwiTZ8pSjMg4Uw-1; Wed, 02 Feb 2022 01:18:53 -0500
X-MC-Unique: FB2yCMTqPwiTZ8pSjMg4Uw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BF222F25;
	Wed,  2 Feb 2022 06:18:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CC38108D4;
	Wed,  2 Feb 2022 06:18:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01CB01809C88;
	Wed,  2 Feb 2022 06:18:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2118ConE017213 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 03:12:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6AEE6492D19; Tue,  1 Feb 2022 08:12:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66640492D18
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 08:12:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46F2B803DDA
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 08:12:50 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-eopbgr70102.outbound.protection.outlook.com [40.107.7.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-639-LE4NNdYjPoSc0bsF1DKaIw-2; Tue, 01 Feb 2022 03:12:48 -0500
X-MC-Unique: LE4NNdYjPoSc0bsF1DKaIw-2
Received: from DB6PR0802MB2374.eurprd08.prod.outlook.com (2603:10a6:4:8a::21)
	by VI1PR0801MB1853.eurprd08.prod.outlook.com (2603:10a6:800:5a::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18;
	Tue, 1 Feb 2022 08:12:43 +0000
Received: from DB6PR0802MB2374.eurprd08.prod.outlook.com
	([fe80::57c:1b85:7b36:55bf]) by
	DB6PR0802MB2374.eurprd08.prod.outlook.com
	([fe80::57c:1b85:7b36:55bf%5]) with mapi id 15.20.4930.022;
	Tue, 1 Feb 2022 08:12:43 +0000
Message-ID: <2cc43142-eefd-eff8-2e26-31a4ea6b9835@virtuozzo.com>
Date: Tue, 1 Feb 2022 11:12:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	"agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com"
	<snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <315cd58c-7605-ed88-23c4-a9509169231c@virtuozzo.com>
	<4872a450-de83-9751-e463-422ee0cc9f9a@opensource.wdc.com>
From: Kirill Tkhai <ktkhai@virtuozzo.com>
In-Reply-To: <4872a450-de83-9751-e463-422ee0cc9f9a@opensource.wdc.com>
X-ClientProxiedBy: FR3P281CA0041.DEUP281.PROD.OUTLOOK.COM
	(2603:10a6:d10:4a::17) To DB6PR0802MB2374.eurprd08.prod.outlook.com
	(2603:10a6:4:8a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3be48442-eb92-496a-91bd-08d9e55a9efe
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1853:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0801MB185357C61D55FA05B2725BE1CD269@VI1PR0801MB1853.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: d4uj/bX4bH4LoZZyefHO8k4admdv+1QJetr8cCdFYKr5dQiK+KHRLMxNvfVIxOeVin62pEdKQLWIX6ksUkAZztxC1dwr0f10s0BKl9UYvq0NGcc8fcKKCNnUVEbmSSe7o2tpcHr6VkfDwZghN7IVhekKKhEijtPGjKgfjMI73dz66IcMn6aBHn3wN02ivdyfBFqiEr8vyF3CeylgpqW0WPuwVbb0B34tyLpbVZmw+SawdAIinV7sirU7Hb9jzrHFeGLJKt14wQrsv7u9UuoBbYEzb7RdkAsT8BHH88ZPLsJgq6diZE//CN5DZenruJ1DfEHu0FCXyy6O36bHlu/ACSoPfmwAAwLitzDCFagQQfHKa1mCOKtLK+yULZke6ucAc23eqYIkAgmlNQq8mX+Jb1gcLTQcDhJordPtMjxPJcAA+BvYnJoPTBXYXrNgdQyFHpfvtTbfR8OGollAbwRiRyb4PK6T0wX4y6fWotQkUSKF38YN6N/BZm4dOVWZ4VX3CF0BRRL0kqpNtUqOZfHlL3SstTmUYiUWU0u0P2L/jJK19ijIt9JdBtnbLeTkn3/S1o08jp3x/aGPWe9qEsD50MpAlZOvl6VXrfI6/SxJz4aoC89vu5Y2kfepHrb2jcE79yj30O/McHT1CReozZPDg2APM0ctfLQmnuEu8+oKT9SQXU+jvYK9M9LJzJ7F3005gp2ErmuPnJsKQ3Oi0P5jyageAg2evhoXz8mgX1RLvgvsHWNRTf+fd/QY9kJF0KYHctJl9tAhQSkfylmdqw6ceg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB6PR0802MB2374.eurprd08.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(316002)(110136005)(6486002)(508600001)(38100700002)(8936002)(2616005)(31686004)(36756003)(2906002)(6512007)(5660300002)(31696002)(66476007)(38350700002)(26005)(53546011)(52116002)(186003)(83380400001)(6506007)(8676002)(86362001)(66946007)(66556008)(43740500002)(45980500001)(20210929001);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnRhTFl0SWE2bW9PbG1wRENiRGFkREhsS085T1Jnb0ZVK21Ic2wzQ3kwVFpB?=
	=?utf-8?B?NzdCVkdnb01Pc2djaWVpbGZCTTNHbXJSZDZFb0dWZXltVENpenI0U0NCUEEr?=
	=?utf-8?B?akJuSGV1Qm9iR2drM1NFYzJkWE5GYVZyeGNCRlo5bkpaUGdqZE9YalZUcXlI?=
	=?utf-8?B?MEJTV1pDbDhRNngwMHA2UnBDTkFGbFJQbERHODM3b3B5ejd0em81YURjYkVM?=
	=?utf-8?B?RnhlalpwbTBzT2dnWjlWOURnWDFwZ3V5RDNJMmE2VlZTSi8xN0hTUVZqcDlM?=
	=?utf-8?B?UDBka0NqS25JQmVRenJNWnpCbHFaelVZTitaamw1ZTdTYnloaWExKzdVc2c5?=
	=?utf-8?B?cVNMSjI5Y0YxODVoSmkxUjl1Zmk3OXVSN3RydFBma2VTR0RIdUZtbXk0RmZE?=
	=?utf-8?B?RVFoQ3hJb2pLMEdUMU00amt2L1N4cTBzdDVMakdXTGpUamI4bGQ2UGpmWFcz?=
	=?utf-8?B?dW9DQ1hvRmFhRkNNbkQ1UFdZNzNvVmU4cTFUQ2d3UXcrNEtXZEdqbUcxMDc2?=
	=?utf-8?B?NUZWMXNhOGN2QmdvWGc0c1Era2VtbnltRU9xcnIwVjdRQTJiT0gvTkJQbTZM?=
	=?utf-8?B?Y2lmSTlLMDEzMlFrdzZYb1Q3RDcwSzZZczJwYVVJa1Q0aTNqVitZSXFoLzA0?=
	=?utf-8?B?cGovbm52WGt5bkR2dTBjdkQxSTNVVlFJUUNRLzZNQVcweTR6bnUxMVczcFZv?=
	=?utf-8?B?Znh0b0ZDWlg3elZ1aWhJaHo1OFMzRXFvMU5Nd0dXMVVSUXJIZVh2TWZEM3dP?=
	=?utf-8?B?V0JHbWdrWWZrNkJoL0t1SUFpMStKNWJjMVJaKzQxT1BIaGxzYVNISUdmNk9v?=
	=?utf-8?B?b3djM3hVMG12SmpTWHpOakJ4MWVxNkl2WUp4OWR5VkQzRUZkSURjci9wYldJ?=
	=?utf-8?B?VjkyTjVIYUE2b1VHUHAvUUI1a2VDbHJCeWN3dW1EbytVMExiR0dTZEhzVUYy?=
	=?utf-8?B?dzNnYlp2SDFuMTczbDZMd3JhWmtmSFBUWUZpMGxiVkxIcW5hU2xySmEwdkly?=
	=?utf-8?B?V25BVEFBazNqcmpCQkJIdnVid0p3QWV2OTFndko1R0w5aUpWUHVHUThjTTll?=
	=?utf-8?B?bS91RDNyOG5zaUJyaWZrdVZaYnE0SFJ0QmtIbXlKUUpjbGkzcytqbnRQekRF?=
	=?utf-8?B?cm1xakl6aUVzOGs4Z0ZVaVJEWjZRUmNoSnlMc1NQZHpsUkZoZVFsN05wQ0VV?=
	=?utf-8?B?U2xwTURlWU1OQTR6dFFXZWdiemw5dE9jaERtZVExa1VreTFKZnEvOWRaSGZQ?=
	=?utf-8?B?TWkrc3NVNnppTUQyUzdmQ2xVRSsrVTA0bU1oK3RGeGUzTXcrOURGV2k4WWpP?=
	=?utf-8?B?aElDa3pkWkNDcEJTUmVjOEJmWmxQTVYycVJTUUxHYWJCL2pJQjdralN0UGlY?=
	=?utf-8?B?a2lmQWdqblBDVy8xOG43bHZCNm5wZVE2aWY1UmtuVVcrVHZmaFZHYlcvU0Q4?=
	=?utf-8?B?Vit5MGwvS0VHS1QrQ0s3Wi9uNmRQU1V2T04wR1c2Z2sxRFZPUmE2VGtQNHNC?=
	=?utf-8?B?V0hZcUJtbGVYeENNN2ZuTW5uYzhENE15VVllcndTQlBrNTg0Y2NMcVl6OXNr?=
	=?utf-8?B?ME5wbjhkM0diR3VYZWltRHN6Rnhub0V2TnpqTU0vK2hGaFFQOXBPRFRmRmZW?=
	=?utf-8?B?MEZHL0VxK1V6azBCU1FaMm9raUhNenlvcXFFV2d1cldQVDMxbEhmS09Od3k1?=
	=?utf-8?B?bWtoWU4yUHk5VXhpYTlGZkt2SmhTcnlaQnViSUxwRUN2Q3BFem5semM3QnBG?=
	=?utf-8?B?OFNaWXQrdlNGYWpORTk5eUNSZGgzTWJmb0NQanVqYTlOeXVNSndUdDd2V3gv?=
	=?utf-8?B?VUhvS0RvYnhzMEs1WkdTQjk2VUdPaFZIdytlalhXRVorSTQrUG5qT25FK3A4?=
	=?utf-8?B?Vzk4SGROOXhvS2NmeHJKaDFUdDhUNU0zbm5EanExUFJRcURnWnpEaVdpVTRD?=
	=?utf-8?B?TFZrcUtsNHYrTnp5enpBOEhiTUtNWnFCZGZVL3liUU5lZkJ4bmVjQXRGN3U3?=
	=?utf-8?B?cEswYk5ZK3BTajI1ZGNWMGd5cytTNzVnMC82ODB5YUxZdk94UWxhUGxualdw?=
	=?utf-8?B?WGpkRjVLcmp2eFRuaXZ0QlM4RzBVRE9Ma1dJdWlrNzlFYTJXNS95L09tSFJ2?=
	=?utf-8?B?dG84S0dkNzlOVjVwcUltdzMyZHB1bmVIY1VxRjlxNDYzanEyQmRETmZORjFH?=
	=?utf-8?Q?m6EvRwC/lSzYgK66v2Uh6E8=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be48442-eb92-496a-91bd-08d9e55a9efe
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0802MB2374.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 08:12:43.0842 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KL7i6owOB0T8Yujo+YsiGNSnG665g1gw0zhPsf314EWAcxC6BdIG5H4Xl4JnyU6DsRMz4IcdXbUt7W2yufmng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1853
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Feb 2022 01:18:44 -0500
Subject: Re: [dm-devel] dm: Fix use-after-free in dm_cleanup_zoned_dev()
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 01.02.2022 02:37, Damien Le Moal wrote:
> On 2022/02/01 1:21, Kirill Tkhai wrote:
>> dm_cleanup_zoned_dev() uses queue, so it must be called before blk_cleanup_disk() starts its killing:
>>
>> blk_cleanup_disk->blk_cleanup_queue()->kobject_put()->blk_release_queue()->...RCU...->blk_free_queue_rcu()->kmem_cache_free()
>>
>> Otherwise, RCU callback may be executed first, and dm_cleanup_zoned_dev() touches freed memory:
>>
>> [   85.074005] BUG: KASAN: use-after-free in dm_cleanup_zoned_dev+0x33/0xd0
>> [   85.075448] Read of size 8 at addr ffff88805ac6e430 by task dmsetup/681
>>
>> [   85.076102] CPU: 4 PID: 681 Comm: dmsetup Not tainted 5.17.0-rc2+ #6
>> [   85.076570] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>> [   85.077150] Call Trace:
>> [   85.077332]  <TASK>
>> [   85.077478]  dump_stack_lvl+0x57/0x7d
>> [   85.077763]  print_address_description.constprop.0+0x1f/0x150
>> [   85.078229]  ? dm_cleanup_zoned_dev+0x33/0xd0
>> [   85.078579]  kasan_report.cold+0x7f/0x11b
>> [   85.078910]  ? dm_cleanup_zoned_dev+0x33/0xd0
>> [   85.079219]  dm_cleanup_zoned_dev+0x33/0xd0
>> [   85.079499]  __dm_destroy+0x26a/0x400
>> [   85.079781]  ? dm_blk_ioctl+0x230/0x230
>> [   85.080090]  ? up_write+0xd8/0x270
>> [   85.080364]  dev_remove+0x156/0x1d0
>> [   85.080639]  ctl_ioctl+0x269/0x530
>> [   85.080910]  ? table_clear+0x140/0x140
>> [   85.081209]  ? lock_release+0xb2/0x750
>> [   85.081518]  ? remove_all+0x40/0x40
>> [   85.081796]  ? rcu_read_lock_sched_held+0x12/0x70
>> [   85.082166]  ? lock_downgrade+0x3c0/0x3c0
>> [   85.082468]  ? rcu_read_lock_sched_held+0x12/0x70
>> [   85.082833]  dm_ctl_ioctl+0xa/0x10
>> [   85.083094]  __x64_sys_ioctl+0xb9/0xf0
>> [   85.083350]  do_syscall_64+0x3b/0x90
>> [   85.083595]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [   85.083955] RIP: 0033:0x7fb6dfa95c27
>> [   85.084277] Code: 00 00 00 48 8b 05 69 92 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 92 0c 00 f7 d8 64 89 01 48
>> [   85.086009] RSP: 002b:00007fff882c6c28 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
>> [   85.086914] RAX: ffffffffffffffda RBX: 00007fb6dfb73a8e RCX: 00007fb6dfa95c27
>> [   85.087607] RDX: 00007fb6e01d7ca0 RSI: 00000000c138fd04 RDI: 0000000000000003
>> [   85.088272] RBP: 00007fff882c6ce0 R08: 00007fb6dfbc3558 R09: 00007fff882c6a90
>> [   85.088956] R10: 00007fb6dfbc28a2 R11: 0000000000000206 R12: 00007fb6dfbc28a2
>> [   85.089477] R13: 00007fb6dfbc28a2 R14: 00007fb6dfbc28a2 R15: 00007fb6dfbc28a2
>> [   85.090038]  </TASK>
>>
>> [   85.090348] Allocated by task 673:
>> [   85.090625]  kasan_save_stack+0x1e/0x40
>> [   85.090978]  __kasan_slab_alloc+0x66/0x80
>> [   85.091336]  kmem_cache_alloc_node+0x1ca/0x460
>> [   85.091742]  blk_alloc_queue+0x33/0x4e0
>> [   85.092112]  __blk_alloc_disk+0x1b/0x60
>> [   85.092464]  dm_create+0x368/0xa20
>> [   85.092764]  dev_create+0xb9/0x170
>> [   85.093118]  ctl_ioctl+0x269/0x530
>> [   85.093521]  dm_ctl_ioctl+0xa/0x10
>> [   85.093921]  __x64_sys_ioctl+0xb9/0xf0
>> [   85.094177]  do_syscall_64+0x3b/0x90
>> [   85.094420]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> [   85.094868] Freed by task 0:
>> [   85.095062]  kasan_save_stack+0x1e/0x40
>> [   85.095319]  kasan_set_track+0x21/0x30
>> [   85.095569]  kasan_set_free_info+0x20/0x30
>> [   85.095858]  __kasan_slab_free+0xfb/0x130
>> [   85.096141]  slab_free_freelist_hook+0x7d/0x150
>> [   85.096502]  kmem_cache_free+0x13c/0x340
>> [   85.096778]  rcu_do_batch+0x2d9/0x820
>> [   85.097049]  rcu_core+0x3b8/0x570
>> [   85.097330]  __do_softirq+0x1c4/0x63d
>>
>> [   85.097792] Last potentially related work creation:
>> [   85.098226]  kasan_save_stack+0x1e/0x40
>> [   85.098549]  __kasan_record_aux_stack+0x96/0xa0
>> [   85.098951]  call_rcu+0xc4/0x8f0
>> [   85.099220]  kobject_put+0xd9/0x270
>> [   85.099557]  disk_release+0xee/0x120
>> [   85.099864]  device_release+0x59/0xf0
>> [   85.100208]  kobject_put+0xd9/0x270
>> [   85.100509]  cleanup_mapped_device+0x12b/0x1b0
>> [   85.100910]  __dm_destroy+0x26a/0x400
>> [   85.101247]  dev_remove+0x156/0x1d0
>> [   85.101555]  ctl_ioctl+0x269/0x530
>> [   85.101859]  dm_ctl_ioctl+0xa/0x10
>> [   85.102198]  __x64_sys_ioctl+0xb9/0xf0
>> [   85.102527]  do_syscall_64+0x3b/0x90
>> [   85.102811]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> [   85.103347] The buggy address belongs to the object at ffff88805ac6e180
>> 	    which belongs to the cache request_queue of size 2992
>> [   85.104338] The buggy address is located 688 bytes inside of
>> 	    2992-byte region [ffff88805ac6e180, ffff88805ac6ed30)
>> [   85.105255] The buggy address belongs to the page:
>> [   85.105633] page:000000000837df3c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5ac68
>> [   85.106363] head:000000000837df3c order:3 compound_mapcount:0 compound_pincount:0
>> [   85.106948] flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
>> [   85.107494] raw: 000fffffc0010200 0000000000000000 dead000000000122 ffff888001e58280
>> [   85.108091] raw: 0000000000000000 00000000800a000a 00000001ffffffff 0000000000000000
>> [   85.108695] page dumped because: kasan: bad access detected
>>
>> [   85.109257] Memory state around the buggy address:
>> [   85.109625]  ffff88805ac6e300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [   85.110178]  ffff88805ac6e380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [   85.110973] >ffff88805ac6e400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [   85.111891]                                      ^
>> [   85.112353]  ffff88805ac6e480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [   85.113036]  ffff88805ac6e500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [   85.113800] ==================================================================
>>
>> Fixes: bb37d77239af "dm: introduce zone append emulation"
>> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
>>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index dcbd6d201619..d472fe5dbc1d 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1607,6 +1607,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
>>  		md->dax_dev = NULL;
>>  	}
>>  
>> +	dm_cleanup_zoned_dev(md);
>>  	if (md->disk) {
>>  		spin_lock(&_minor_lock);
>>  		md->disk->private_data = NULL;
>> @@ -1627,7 +1628,6 @@ static void cleanup_mapped_device(struct mapped_device *md)
>>  	mutex_destroy(&md->swap_bios_lock);
>>  
>>  	dm_mq_cleanup_mapped_device(md);
>> -	dm_cleanup_zoned_dev(md);
>>  }
>>  
>>  /*
>>
> 
> The commit message format is strange (long lines).
> Apart from that, the fix looks good to me.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

This is for a reviewer convenience. All KASAN trace may be cut on commit if not needed.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


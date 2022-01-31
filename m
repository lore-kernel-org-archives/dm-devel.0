Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A98E5C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 06:19:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-cl-TrzhoN_WY484ZYsE8Ew-1; Wed, 02 Feb 2022 01:19:13 -0500
X-MC-Unique: cl-TrzhoN_WY484ZYsE8Ew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4574802930;
	Wed,  2 Feb 2022 06:19:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C216E5E496;
	Wed,  2 Feb 2022 06:19:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 998E34A7CA;
	Wed,  2 Feb 2022 06:19:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20VGL2gk012457 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 31 Jan 2022 11:21:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B8F761454546; Mon, 31 Jan 2022 16:21:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B36E01454537
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 16:21:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96A303C01B88
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 16:21:02 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-eopbgr80123.outbound.protection.outlook.com [40.107.8.123]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-518-9eFGcQL9NgGO7KXmhnZvGA-1; Mon, 31 Jan 2022 11:20:58 -0500
X-MC-Unique: 9eFGcQL9NgGO7KXmhnZvGA-1
Received: from DB6PR0802MB2374.eurprd08.prod.outlook.com (2603:10a6:4:8a::21)
	by AM0PR08MB3058.eurprd08.prod.outlook.com (2603:10a6:208:5a::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17;
	Mon, 31 Jan 2022 16:20:55 +0000
Received: from DB6PR0802MB2374.eurprd08.prod.outlook.com
	([fe80::57c:1b85:7b36:55bf]) by
	DB6PR0802MB2374.eurprd08.prod.outlook.com
	([fe80::57c:1b85:7b36:55bf%5]) with mapi id 15.20.4930.021;
	Mon, 31 Jan 2022 16:20:55 +0000
Message-ID: <315cd58c-7605-ed88-23c4-a9509169231c@virtuozzo.com>
Date: Mon, 31 Jan 2022 19:20:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
To: agk@redhat.com, snitzer@redhat.com, damien.lemoal@wdc.com,
	ktkhai@virtuozzo.com, dm-devel@redhat.com
From: Kirill Tkhai <ktkhai@virtuozzo.com>
X-ClientProxiedBy: FR0P281CA0062.DEUP281.PROD.OUTLOOK.COM
	(2603:10a6:d10:49::23) To DB6PR0802MB2374.eurprd08.prod.outlook.com
	(2603:10a6:4:8a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 619b15d5-99f2-47b6-7757-08d9e4d5a853
X-MS-TrafficTypeDiagnostic: AM0PR08MB3058:EE_
X-Microsoft-Antispam-PRVS: <AM0PR08MB3058B5BF2B41F5AD6E9182ECCD259@AM0PR08MB3058.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: brWT4pzt8AcohTmRFVagdEyQCDAT5z2fOagz6ATT+OXVJL8WoiF7ic2bR/v9q5NcisvhxhkReykVUYoxzonKPGVDB/BFmTHXVyOX0Y4UL6vsLRTPsEubVkk4WZGyk0bjAZ9Me0aermf/v8OemSgLXe7qqSLYTcSUhmWpdgnl6GsuQNjkTmNdzRrYR0dNtx8/VHDsbDbAj2SyWhcthdOVNBU8ae6jDVSuXDGAIIt+eMhpGyh8rbPPrv+7PwZ0HPTE4mewMWFNwMDLm92rdPNbVITVsti30P4fPO9eF5OTr8YtF/pSWXNFR+gt70idzURt8ZOtxMFz5ntoOnalyaO3rI9mal/czAvI+iybwPAYD+WmEOKeFd+irOQYyTGlh6Wh8qNfDfhaLP3VyxrTwqCiI6oZazvf/zwgOemqspZy7NwPE/rS73qfhaA5xtCnjfHDR7xIIe7soqSOZlDrcHuV2HQC8l3EI6MTmkfk9akWAvcTWaqdYb2g1R/FKT9vGuxc8CkxzCW84ZVoJdFJ0K5c0noNzkFFG7Bpc2gygcblTbEqieO0JVB6ps3X3uVmCn2KQ6VoHl7KxPHSLrTMyWsyj2YaWrvu75OGYZdlySQ/HaheKVRFrMz6rPho97CXwZSWWiOxSml1z3SpW+H9zgvfyMcU+P+y20/j5lnyaZwC/Wy7AhZp7LkwjlNnfPhar8tFSNn86JVDEsarCb/4q7Lf8yk0sGat/I4LD3xmUWV8I2rcVvTEmBlWDthqwTln1GWnpTCKgZJlylD6ae7PMscbrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB6PR0802MB2374.eurprd08.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(508600001)(86362001)(83380400001)(31696002)(6486002)(31686004)(38100700002)(38350700002)(8676002)(8936002)(36756003)(66556008)(66476007)(66946007)(316002)(52116002)(186003)(5660300002)(26005)(6506007)(2616005)(2906002)(6512007)(45980500001)(43740500002)(20210929001);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2xic1VITEgvRmwwNFR0VWUraWpsQjV5eFpuV2x2L0o3bi9idDNFR2QxWXls?=
	=?utf-8?B?NjZnT3Z2aE9wejA3Q0lkSzJUZmE3d25RMkZoU1cyanUycGZ1dWxzUkU0OWRt?=
	=?utf-8?B?YXNEd1BFZGxmVU12WU0xN3dSZTRPZkdHNHVLU2hGZ0lEVGRJSkpKZnFLd3pJ?=
	=?utf-8?B?cm5KWXpsNjRTOFNNOEZCd2kzbkxzVEFlaUZSY2hSZ3VCWkdVMUNKL3krNG1x?=
	=?utf-8?B?bCt4ZFdBZFVFcDUyK1Y5bnl1blJjNGtSaEhZMTdqWXNmN09oTEIvWGpzQkJH?=
	=?utf-8?B?Sk1nRTQveWdRZkFUQ2M3THg2dkZtak9sY3hPVzFGaVoySEJiN1JGcWNJb2xE?=
	=?utf-8?B?U01HbFh5WmdOQ3RrVTUzNVExZGJvNWhNYTZxVUE1RHNtVnl3NlVnR1Zkd2l4?=
	=?utf-8?B?RXd5ZFhtZEdnaUlBaWoxLzhBaXlzaDZrb1NhdG9iaUFzRmg5ZXAxaDBkck9m?=
	=?utf-8?B?eTBIT2dVanVhUGJqOExMVVZxTUVxVG45NEFjYmVmZHdvWG4yS2NrT0N5TFVE?=
	=?utf-8?B?cUdQRkY1OFJ4Q01mR1ZyZ0x3WHBjalhPY3dqSUNGUFlTakFpaDBKMVF6R1VH?=
	=?utf-8?B?R1VqSDB1cWJ1S2FHZm5BZzVPTXFiRGE4WC8vUFdLSVJlRlVhaG5wRW0xM3c2?=
	=?utf-8?B?Rk1OQ1Ntb0Q1elBDY2d5WXZra0QzZ0lyTlFFeDFHNjVMM0s0Q1o3bTBoRFhs?=
	=?utf-8?B?ako3eDZ4Vzc5cUd1bERzME1ya05MTGl6TXBkZGtBelJSdHZKekdZQWcxR3BW?=
	=?utf-8?B?SGFGbmdJdTNaYSs5NTlhMFZxZmZxbElHS3FUOUhwVGZQWUhQMUlicjJaaE5z?=
	=?utf-8?B?R2ZKTHBvcTJTeittdVFsUlFWaWZTc2MxTWVpVkd2d2o0MmJ2VmxFcjA1Y3lt?=
	=?utf-8?B?QlVzM0JDTXRyYVJLVnkwSzF4Vml4NUNMaFhVOGtxMkEzOFd3KzFDWURqRDFQ?=
	=?utf-8?B?M3ZBSm9KZE1HcHo5OU1DM0FQeEY0anpsY0N4UXBCL2Z1VnhXakRlbjVSSEFZ?=
	=?utf-8?B?T0NPU3lLZDhlU3VuL2NMWkt5MU5reGJPTTJ6MGt2bU1NaGVxUmxCaERnQyta?=
	=?utf-8?B?cStMRVZyT3lYUEJndnpLVmlLOXRJQ1dQQnRJQnhxc3cwZlZ5MnZvam5LY2Vw?=
	=?utf-8?B?L2UwdnpuRGp2bFVCc3FSVnZVZnUyc2pncjluYnJDY1NLSHI5VThrN21qWlVS?=
	=?utf-8?B?cEpwRVZOT0V6WEJIRzk3c3Vyc2JOcVNUUXdwUUFjNU9NNHJzd25XWmFSZG1q?=
	=?utf-8?B?bGVnUmFrYTA3NUdEWjNmblNzUGdwcTNUYmNnZEE1YmtOajNVZ0tjTG4xRTRv?=
	=?utf-8?B?UndEU0g1c0lXd2JDcmNCTTI3SmVPVU9zTWQ4cTl0SkdYbXI2WS9iNW1UM0Z5?=
	=?utf-8?B?bUN6ZnhadkR5TFNnVWJiUE5uL0gvMnQ5YWErQUxSY21rSEN4Zi9PUmpKZkts?=
	=?utf-8?B?Yy9Nbk9UcFJnZUVKbjFCVVdCbFVRUTdIZGVTWWJpaDNjeUFkREZ2R0puV3ZN?=
	=?utf-8?B?cEFPL09sWVpWTkVKNkNFelFFaUp6bHNlWjNlUjJmdGMvNExSWE1JNk9lcnpj?=
	=?utf-8?B?L3JBSDRuN1QxSVk0QzVVclFkdHVneHlBTjVOMnJFTXBuaVhaUGZ4Mk9McFU2?=
	=?utf-8?B?N015ekR3bGROSnlIcXZpZ3Q1dktRekFnS1I2bENqNlhBN1hwdWZrMnBwMGdU?=
	=?utf-8?B?NGFzYS9vR2wvbFN6N3FUd1lBVnZ0bzdaRGNnN0tCZzdQanRkdWxxK0NtamI2?=
	=?utf-8?B?Mm8zaFJFMWlLRzhkaDhiVmlVWmR1bzAyejVHdTMrTExxaWdrODNQSXJXYnNM?=
	=?utf-8?B?KzQvVjZyWFFZb0dLYnJYZUM5STNOWnJjMmcyMzJHWFZQYnNzK0NoQ1ZYeTdv?=
	=?utf-8?B?YjVxK1paV1A3SHRRckNOUGRGVkZ3MUQ0K0VWa1Z0U3h3WG9WUi84SjhsdFk2?=
	=?utf-8?B?WDFKSXBzL1hUU3FWaFR4NCtoUjRPWmt6bk5UVjdmWnRHR3M0NWVoNkYyN25U?=
	=?utf-8?B?dXNtMmpqOWxicmU0Mlg4Tkc0a1RLbHNIRExCeDUxYkprUU43WDVsYmlRTDgx?=
	=?utf-8?B?WU9PNnhnRlNna2NpRUFoWUNZMU5IVnZRV09XK2llQnZNT0dsczllcVh3Smtu?=
	=?utf-8?B?WnorK2NtQWRLYVNyeUphMmprTkxvaWRRMWhOSWVFMkRndkMyeTYrdE1HNjRM?=
	=?utf-8?Q?GNMXEg4NG0d36Dwor9TNzug=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 619b15d5-99f2-47b6-7757-08d9e4d5a853
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0802MB2374.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 16:20:55.5188 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFvU2j+HKT4NH56fAYSEoakhYDkHg1aQqeL5s08Dna8A0A0G+BKGbU5yxb2VjnkBy6CbQumGe1IUt+aZJjZKaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3058
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Feb 2022 01:18:44 -0500
Subject: [dm-devel] dm: Fix use-after-free in dm_cleanup_zoned_dev()
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_cleanup_zoned_dev() uses queue, so it must be called before blk_cleanup_disk() starts its killing:

blk_cleanup_disk->blk_cleanup_queue()->kobject_put()->blk_release_queue()->...RCU...->blk_free_queue_rcu()->kmem_cache_free()

Otherwise, RCU callback may be executed first, and dm_cleanup_zoned_dev() touches freed memory:

[   85.074005] BUG: KASAN: use-after-free in dm_cleanup_zoned_dev+0x33/0xd0
[   85.075448] Read of size 8 at addr ffff88805ac6e430 by task dmsetup/681

[   85.076102] CPU: 4 PID: 681 Comm: dmsetup Not tainted 5.17.0-rc2+ #6
[   85.076570] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[   85.077150] Call Trace:
[   85.077332]  <TASK>
[   85.077478]  dump_stack_lvl+0x57/0x7d
[   85.077763]  print_address_description.constprop.0+0x1f/0x150
[   85.078229]  ? dm_cleanup_zoned_dev+0x33/0xd0
[   85.078579]  kasan_report.cold+0x7f/0x11b
[   85.078910]  ? dm_cleanup_zoned_dev+0x33/0xd0
[   85.079219]  dm_cleanup_zoned_dev+0x33/0xd0
[   85.079499]  __dm_destroy+0x26a/0x400
[   85.079781]  ? dm_blk_ioctl+0x230/0x230
[   85.080090]  ? up_write+0xd8/0x270
[   85.080364]  dev_remove+0x156/0x1d0
[   85.080639]  ctl_ioctl+0x269/0x530
[   85.080910]  ? table_clear+0x140/0x140
[   85.081209]  ? lock_release+0xb2/0x750
[   85.081518]  ? remove_all+0x40/0x40
[   85.081796]  ? rcu_read_lock_sched_held+0x12/0x70
[   85.082166]  ? lock_downgrade+0x3c0/0x3c0
[   85.082468]  ? rcu_read_lock_sched_held+0x12/0x70
[   85.082833]  dm_ctl_ioctl+0xa/0x10
[   85.083094]  __x64_sys_ioctl+0xb9/0xf0
[   85.083350]  do_syscall_64+0x3b/0x90
[   85.083595]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   85.083955] RIP: 0033:0x7fb6dfa95c27
[   85.084277] Code: 00 00 00 48 8b 05 69 92 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 92 0c 00 f7 d8 64 89 01 48
[   85.086009] RSP: 002b:00007fff882c6c28 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[   85.086914] RAX: ffffffffffffffda RBX: 00007fb6dfb73a8e RCX: 00007fb6dfa95c27
[   85.087607] RDX: 00007fb6e01d7ca0 RSI: 00000000c138fd04 RDI: 0000000000000003
[   85.088272] RBP: 00007fff882c6ce0 R08: 00007fb6dfbc3558 R09: 00007fff882c6a90
[   85.088956] R10: 00007fb6dfbc28a2 R11: 0000000000000206 R12: 00007fb6dfbc28a2
[   85.089477] R13: 00007fb6dfbc28a2 R14: 00007fb6dfbc28a2 R15: 00007fb6dfbc28a2
[   85.090038]  </TASK>

[   85.090348] Allocated by task 673:
[   85.090625]  kasan_save_stack+0x1e/0x40
[   85.090978]  __kasan_slab_alloc+0x66/0x80
[   85.091336]  kmem_cache_alloc_node+0x1ca/0x460
[   85.091742]  blk_alloc_queue+0x33/0x4e0
[   85.092112]  __blk_alloc_disk+0x1b/0x60
[   85.092464]  dm_create+0x368/0xa20
[   85.092764]  dev_create+0xb9/0x170
[   85.093118]  ctl_ioctl+0x269/0x530
[   85.093521]  dm_ctl_ioctl+0xa/0x10
[   85.093921]  __x64_sys_ioctl+0xb9/0xf0
[   85.094177]  do_syscall_64+0x3b/0x90
[   85.094420]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[   85.094868] Freed by task 0:
[   85.095062]  kasan_save_stack+0x1e/0x40
[   85.095319]  kasan_set_track+0x21/0x30
[   85.095569]  kasan_set_free_info+0x20/0x30
[   85.095858]  __kasan_slab_free+0xfb/0x130
[   85.096141]  slab_free_freelist_hook+0x7d/0x150
[   85.096502]  kmem_cache_free+0x13c/0x340
[   85.096778]  rcu_do_batch+0x2d9/0x820
[   85.097049]  rcu_core+0x3b8/0x570
[   85.097330]  __do_softirq+0x1c4/0x63d

[   85.097792] Last potentially related work creation:
[   85.098226]  kasan_save_stack+0x1e/0x40
[   85.098549]  __kasan_record_aux_stack+0x96/0xa0
[   85.098951]  call_rcu+0xc4/0x8f0
[   85.099220]  kobject_put+0xd9/0x270
[   85.099557]  disk_release+0xee/0x120
[   85.099864]  device_release+0x59/0xf0
[   85.100208]  kobject_put+0xd9/0x270
[   85.100509]  cleanup_mapped_device+0x12b/0x1b0
[   85.100910]  __dm_destroy+0x26a/0x400
[   85.101247]  dev_remove+0x156/0x1d0
[   85.101555]  ctl_ioctl+0x269/0x530
[   85.101859]  dm_ctl_ioctl+0xa/0x10
[   85.102198]  __x64_sys_ioctl+0xb9/0xf0
[   85.102527]  do_syscall_64+0x3b/0x90
[   85.102811]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[   85.103347] The buggy address belongs to the object at ffff88805ac6e180
	    which belongs to the cache request_queue of size 2992
[   85.104338] The buggy address is located 688 bytes inside of
	    2992-byte region [ffff88805ac6e180, ffff88805ac6ed30)
[   85.105255] The buggy address belongs to the page:
[   85.105633] page:000000000837df3c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5ac68
[   85.106363] head:000000000837df3c order:3 compound_mapcount:0 compound_pincount:0
[   85.106948] flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
[   85.107494] raw: 000fffffc0010200 0000000000000000 dead000000000122 ffff888001e58280
[   85.108091] raw: 0000000000000000 00000000800a000a 00000001ffffffff 0000000000000000
[   85.108695] page dumped because: kasan: bad access detected

[   85.109257] Memory state around the buggy address:
[   85.109625]  ffff88805ac6e300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   85.110178]  ffff88805ac6e380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   85.110973] >ffff88805ac6e400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   85.111891]                                      ^
[   85.112353]  ffff88805ac6e480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   85.113036]  ffff88805ac6e500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   85.113800] ==================================================================

Fixes: bb37d77239af "dm: introduce zone append emulation"
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index dcbd6d201619..d472fe5dbc1d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1607,6 +1607,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
 		md->dax_dev = NULL;
 	}
 
+	dm_cleanup_zoned_dev(md);
 	if (md->disk) {
 		spin_lock(&_minor_lock);
 		md->disk->private_data = NULL;
@@ -1627,7 +1628,6 @@ static void cleanup_mapped_device(struct mapped_device *md)
 	mutex_destroy(&md->swap_bios_lock);
 
 	dm_mq_cleanup_mapped_device(md);
-	dm_cleanup_zoned_dev(md);
 }
 
 /*

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


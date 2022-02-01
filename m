Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CB9C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 06:18:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-xEAWY-W4PsmCE4yzZuIltA-1; Wed, 02 Feb 2022 01:18:53 -0500
X-MC-Unique: xEAWY-W4PsmCE4yzZuIltA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CC1B2F26;
	Wed,  2 Feb 2022 06:18:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E9885E491;
	Wed,  2 Feb 2022 06:18:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 173624CA9B;
	Wed,  2 Feb 2022 06:18:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2118e0NA019056 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 03:40:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 97324C0809C; Tue,  1 Feb 2022 08:40:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9223BC0809B
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 08:40:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 536AE3C01C09
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 08:40:00 +0000 (UTC)
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
	(mail-eopbgr10128.outbound.protection.outlook.com [40.107.1.128]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-541-2hAKhlmSOAOZO3R2zv6WDw-1; Tue, 01 Feb 2022 03:39:58 -0500
X-MC-Unique: 2hAKhlmSOAOZO3R2zv6WDw-1
Received: from DB6PR0802MB2374.eurprd08.prod.outlook.com (2603:10a6:4:8a::21)
	by VE1PR08MB4751.eurprd08.prod.outlook.com (2603:10a6:802:a8::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20;
	Tue, 1 Feb 2022 08:39:54 +0000
Received: from DB6PR0802MB2374.eurprd08.prod.outlook.com
	([fe80::57c:1b85:7b36:55bf]) by
	DB6PR0802MB2374.eurprd08.prod.outlook.com
	([fe80::57c:1b85:7b36:55bf%5]) with mapi id 15.20.4930.022;
	Tue, 1 Feb 2022 08:39:54 +0000
Message-ID: <c64d2143-284e-7621-440c-971e3405b4d8@virtuozzo.com>
Date: Tue, 1 Feb 2022 11:39:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	"agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com"
	<snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <315cd58c-7605-ed88-23c4-a9509169231c@virtuozzo.com>
	<4872a450-de83-9751-e463-422ee0cc9f9a@opensource.wdc.com>
	<2cc43142-eefd-eff8-2e26-31a4ea6b9835@virtuozzo.com>
	<b2bcf890-a611-d57b-a023-77aaf65a18de@opensource.wdc.com>
From: Kirill Tkhai <ktkhai@virtuozzo.com>
In-Reply-To: <b2bcf890-a611-d57b-a023-77aaf65a18de@opensource.wdc.com>
X-ClientProxiedBy: FR3P281CA0053.DEUP281.PROD.OUTLOOK.COM
	(2603:10a6:d10:4a::6) To DB6PR0802MB2374.eurprd08.prod.outlook.com
	(2603:10a6:4:8a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a472f64d-89a5-4178-90fe-08d9e55e6b8f
X-MS-TrafficTypeDiagnostic: VE1PR08MB4751:EE_
X-Microsoft-Antispam-PRVS: <VE1PR08MB4751F6236BA29AAAC65F402ECD269@VE1PR08MB4751.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: W8YYUV9ogSRInpDTgndcM70uhvJya/xISNU3SfahJXGabT9/RorSuWgheSoMBZGRKSog0/0pZlr0LsH0zN2jSMOb+F6ewOw/6VW4lg0q+W2Hy/HP96PM46ezGf18TnWKpUqrDbgCno5aTsacL/LMj56OEVnXhw2VwfwK14Ta97tzmsoDODxHWh65foFOSs557pkyngdVeXU0Wqi7MvE0F24VWPt2owKVlfRsDn8x0iLXsBzrK6oC3jXnUvEwqjx5PudDi3sBYkDZJ/P/qyqU8rmxDYLTMxqKAERnU5sMBCtnSo3D4eF0eD81Lx+Yzvbsnk9hFYM/sZPN2YUEBzfGUHm7SirovVWsg15mMD/ovYDg5r08/+ZeatQOjHgTltu2ig+JU+G9A82iNOaqr1qq5D74WgNmYoC/O67vgdSGymhbVQ1zzRTq7jT5npesMtkTsIrd8u+zxoV47/dxgoBNaTf0cLzYxy//hyu+hxz2tAMdgDv9EWelvi2/C4HX9kAFw6nbrAT/Dhl/QcckjF2y4LyQsgdLV5zKMOa98d9SOPZyr4xFv8N82iQXsPXdOWoqazZPEymOlXB+LjT3JlN/5HWVYoWc+RGeJI//MkrzPjAYfdJnfbIWtgJPpbgw0NzalRA3sndPDfYj6KFdit7iyIqDOisH9MQmnvjZdcBZDrbRs82+CQR/plCT0xsfptBcI9v02fBo8eA1bqkjwgJxteTFbMxTfR0VPCbtD86nsIHMIsu56ajLc20WI/5K6yT9L22L9zJboFnt1LxcyST5b2slIzgXgGgWjDy6nPJf1PU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB6PR0802MB2374.eurprd08.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(86362001)(31696002)(38100700002)(316002)(110136005)(38350700002)(6512007)(83380400001)(6506007)(2906002)(186003)(26005)(6486002)(508600001)(8676002)(52116002)(66476007)(66946007)(66556008)(5660300002)(31686004)(8936002)(36756003)(2616005)(21314003)(45980500001)(43740500002)(20210929001);
	DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXU5Q0tremlqaGx4L3JKbUMzbDM3SXI5TCt1dUpIbzJpZUdqeWR2RVZKK25P?=
	=?utf-8?B?TEw2bkJEelE3Q0JBMW95Y1RPN3FsbFkzVXZ1bmVVOXlONm9XbFpWK0g3VVFF?=
	=?utf-8?B?b0Y2TEVqeitEVjBuVEJnQ2MxMEZteTc3L3ZDVmxOUkJqSGtGdzBGTWRraU9n?=
	=?utf-8?B?QlVsSCtFV3NLMi9qUEs5YUVIWEI4Kzhzc3dlaVhDankzbEIxaG12VXFvWWtu?=
	=?utf-8?B?b3B2RlJJWE5TQVB0dEdBNTlqaTh2S1NLdi9MM2FzUXJHRVgzL2wvems0bjdE?=
	=?utf-8?B?SHVOVUtlWlFvc2g3NGFuNjVub3pTUlpoS1I2aW00S3RCVkx2TmllQWVpZ3Jw?=
	=?utf-8?B?WkVzQ2YzZnp3VmE0U0ZyUVNUeXBWQkhkak9ZUHFDbFpzNVcrdXhLK3NKQjVh?=
	=?utf-8?B?bm1lVzRvazZIdTU0dFU5VnFCVWpqV3gxVmVXdE41KzNsbmZoNHpGaUlObE1q?=
	=?utf-8?B?YUNMRzVUaGFiT25WQXpVRnh3Q2VGcnU3YytEL3Bob1RtaGN5bStnak1MSzR2?=
	=?utf-8?B?VGM4cjFrZWptclF3Z2htVU5aNGdXd1ZBZ0lBTXBHRzN2YlY5dExuVTNSbTgw?=
	=?utf-8?B?TnVGdTlnTytvdjJUY05ZYkRZbHpMU2sxa2pzR1crNlN1NUNLampTaEhRdUxW?=
	=?utf-8?B?dEhsZTFyTHZWV29GV1FQOVJNK1FKUXQ4YzNUQzZHRDNXMjdIdWpvaTg4bVI3?=
	=?utf-8?B?N3dOUHh5QXd0Rlk3NXg0YW13THVoNWpDSHp2NVFwNHNlUGczMU4wS09XejhG?=
	=?utf-8?B?Vk96cW9FczQ2aEpDVnFza01yZWJldEpFL0UzTEdDU3Jvb1dmelAvWW1NUjVq?=
	=?utf-8?B?MURsYlozdTNZRzhNbFE4VTl3RzNEMTVjVmdWOXVteGhuUy81eUMvZDlIMHhS?=
	=?utf-8?B?RXE4dFlHZVJ1UHNGMWh1My92clJEUnlIWWs5VDlNcjhmYUJFajB5UU1YN1RO?=
	=?utf-8?B?Ri9JMGg2bUc5ZTZ2MUR0VU5PeFNqeEc1dGllRmdrYVR1U0NPZmg2dUNwa2kz?=
	=?utf-8?B?QTRlT015NGZFQ1g1ZlpsYUZuNUZOaldldW51OXEzUm1vRjJJN0RwU0wvbXli?=
	=?utf-8?B?ZkxBZ0h0OWNWakhoa0xsUmlZdjRQZjhydzBtQ0NBcHREdEwydmViOHpZU0Nw?=
	=?utf-8?B?Nm9zNStXdTJRNGxDWW84cXNORDAyR3RCYmVCSGhnOVhLang2ZGxzNGxuTTJJ?=
	=?utf-8?B?MC9WT1ZXSmEvUmptSnh2UkROTjQvOGRLNnYrTkp5QkVGZTRSdWQreFdCWWQ1?=
	=?utf-8?B?TXpjbVZmUXFaRXp5YWk2QmxiS0JScmJObXkraGZZZVd0OUZZZDc0b0tGcjY1?=
	=?utf-8?B?dEpqbnBsZ1lCSmpoUmsva3FVS0pOR1VpY3JvNFE3TmQ3RGI1dWxCbzN2Nzdj?=
	=?utf-8?B?bXQzME5Db2xsRE5LTVNINHhUVDBLM2VVQ0VzRkprL1RHcFNCSUU5L09MQWpP?=
	=?utf-8?B?ZnRic0dqU0JoNWZRWnBodXpoYUNiVllrVnV0WDZkL1lqakR2bTU2N1RGZ0dt?=
	=?utf-8?B?ZEk2YURQRHVCUjE0VDZmYXJqWUdraDA2Q1FlNW1VVHBSZkJuWkliVVlRUXFi?=
	=?utf-8?B?T3FSRVJJN3VvRDBoRFZ2b3REUk9GNzFQRnEyb0NuMHhlMU8wMWxkcVdZcEhl?=
	=?utf-8?B?VnlPVkF3d0R6MU5SL2tQTW5FWk5Ubk9LNURhUFpwTU1RMzZhUVBOS2xsVnRh?=
	=?utf-8?B?MzFOTW5WNUpvVzVramtENEE5eWxHN2NJSEJqRlR4TmluQ0xGUEg1dDNsd0oz?=
	=?utf-8?B?WStEaCtEam1mNmhTNVBWUGl5bzBmRmpVMTFWeEZKamRTWk5rTkxrSmJRYzhL?=
	=?utf-8?B?UXYzYWtZMkIrZG1vQzdTdzQyNmlOYUw5ZitBR0tETDAwQXpJeWhDMUtzWGNx?=
	=?utf-8?B?ckhxc01EeGE3Yk5BVzdidUpQKzJjYjU5eUF1RnZNcFBsa0tsdWlvbjhFNUpj?=
	=?utf-8?B?REVMNTR4WmFoWjJEWlVqNk5yVEwwYkxqdDZIVlYzUGtUd1YzYVhURndPREdK?=
	=?utf-8?B?amJnYityRWozbTJmV21ITG5pTUpNSWQ5YmI3U092ODZkc2RJSFlnbUNXOWVa?=
	=?utf-8?B?TzFvdGV4eCtWbDhPS3dxN2dheDN0RUJYQ2txRVRPVWFWYW5qU1FDR0g4TUNr?=
	=?utf-8?B?MEg4bmJUQ29sLzlRVzdycWo2S2trcjFjbGhQL1pseDVjY1pBZWNjZytqRkYz?=
	=?utf-8?Q?Ka+VaVeURf7vAs505CNfjTo=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a472f64d-89a5-4178-90fe-08d9e55e6b8f
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0802MB2374.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 08:39:54.5299 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hvSf/rZHfK3rW8DGUdKYDdrSXqzuxR7fDk56wHimHmrqZMP6BbLAmAv8aLKCqeRB/Tiveo/iAAtBt2PpLws/Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4751
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Feb 2022 01:18:44 -0500
Subject: [dm-devel] [PATCH v2] dm: Fix use-after-free in
	dm_cleanup_zoned_dev()
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

dm_cleanup_zoned_dev() uses queue, so it must be called
before blk_cleanup_disk() starts its killing:

blk_cleanup_disk->blk_cleanup_queue()->kobject_put()->blk_release_queue()->
->...RCU...->blk_free_queue_rcu()->kmem_cache_free()

Otherwise, RCU callback may be executed first,
and dm_cleanup_zoned_dev() touches freed memory:

 BUG: KASAN: use-after-free in dm_cleanup_zoned_dev+0x33/0xd0
 Read of size 8 at addr ffff88805ac6e430 by task dmsetup/681

 CPU: 4 PID: 681 Comm: dmsetup Not tainted 5.17.0-rc2+ #6
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x57/0x7d
  print_address_description.constprop.0+0x1f/0x150
  ? dm_cleanup_zoned_dev+0x33/0xd0
  kasan_report.cold+0x7f/0x11b
  ? dm_cleanup_zoned_dev+0x33/0xd0
  dm_cleanup_zoned_dev+0x33/0xd0
  __dm_destroy+0x26a/0x400
  ? dm_blk_ioctl+0x230/0x230
  ? up_write+0xd8/0x270
  dev_remove+0x156/0x1d0
  ctl_ioctl+0x269/0x530
  ? table_clear+0x140/0x140
  ? lock_release+0xb2/0x750
  ? remove_all+0x40/0x40
  ? rcu_read_lock_sched_held+0x12/0x70
  ? lock_downgrade+0x3c0/0x3c0
  ? rcu_read_lock_sched_held+0x12/0x70
  dm_ctl_ioctl+0xa/0x10
  __x64_sys_ioctl+0xb9/0xf0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7fb6dfa95c27
 Code: 00 00 00 48 8b 05 69 92 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 92 0c 00 f7 d8 64 89 01 48
 RSP: 002b:00007fff882c6c28 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00007fb6dfb73a8e RCX: 00007fb6dfa95c27
 RDX: 00007fb6e01d7ca0 RSI: 00000000c138fd04 RDI: 0000000000000003
 RBP: 00007fff882c6ce0 R08: 00007fb6dfbc3558 R09: 00007fff882c6a90
 R10: 00007fb6dfbc28a2 R11: 0000000000000206 R12: 00007fb6dfbc28a2
 R13: 00007fb6dfbc28a2 R14: 00007fb6dfbc28a2 R15: 00007fb6dfbc28a2
  </TASK>

 Allocated by task 673:
  kasan_save_stack+0x1e/0x40
  __kasan_slab_alloc+0x66/0x80
  kmem_cache_alloc_node+0x1ca/0x460
  blk_alloc_queue+0x33/0x4e0
  __blk_alloc_disk+0x1b/0x60
  dm_create+0x368/0xa20
  dev_create+0xb9/0x170
  ctl_ioctl+0x269/0x530
  dm_ctl_ioctl+0xa/0x10
  __x64_sys_ioctl+0xb9/0xf0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 Freed by task 0:
  kasan_save_stack+0x1e/0x40
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  __kasan_slab_free+0xfb/0x130
  slab_free_freelist_hook+0x7d/0x150
  kmem_cache_free+0x13c/0x340
  rcu_do_batch+0x2d9/0x820
  rcu_core+0x3b8/0x570
  __do_softirq+0x1c4/0x63d

 Last potentially related work creation:
  kasan_save_stack+0x1e/0x40
  __kasan_record_aux_stack+0x96/0xa0
  call_rcu+0xc4/0x8f0
  kobject_put+0xd9/0x270
  disk_release+0xee/0x120
  device_release+0x59/0xf0
  kobject_put+0xd9/0x270
  cleanup_mapped_device+0x12b/0x1b0
  __dm_destroy+0x26a/0x400
  dev_remove+0x156/0x1d0
  ctl_ioctl+0x269/0x530
  dm_ctl_ioctl+0xa/0x10
  __x64_sys_ioctl+0xb9/0xf0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 The buggy address belongs to the object at ffff88805ac6e180
  which belongs to the cache request_queue of size 2992
 The buggy address is located 688 bytes inside of
  2992-byte region [ffff88805ac6e180, ffff88805ac6ed30)
 The buggy address belongs to the page:
 page:000000000837df3c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5ac68
 head:000000000837df3c order:3 compound_mapcount:0 compound_pincount:0
 flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
 raw: 000fffffc0010200 0000000000000000 dead000000000122 ffff888001e58280
 raw: 0000000000000000 00000000800a000a 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff88805ac6e300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88805ac6e380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 >ffff88805ac6e400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                      ^
  ffff88805ac6e480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88805ac6e500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

Fixes: bb37d77239af "dm: introduce zone append emulation"
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
v2: Split long commit message line and delete [xxx] time prefix from kernel output.

 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


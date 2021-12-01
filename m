Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F080C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 08:17:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-555-0WtJ8mVqOXqPP543aA3Pag-1; Thu, 02 Dec 2021 03:17:04 -0500
X-MC-Unique: 0WtJ8mVqOXqPP543aA3Pag-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CEF718460E6;
	Thu,  2 Dec 2021 08:17:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 491D360C4A;
	Thu,  2 Dec 2021 08:17:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B33D71809C89;
	Thu,  2 Dec 2021 08:16:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1BqOmt004910 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 06:52:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 69E261410DD8; Wed,  1 Dec 2021 11:52:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 64E021410DD5
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 11:52:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47374800882
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 11:52:24 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-318--YkypBaaMQqNxfoEXAbupg-1; Wed, 01 Dec 2021 06:52:22 -0500
X-MC-Unique: -YkypBaaMQqNxfoEXAbupg-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-17-I13DmbMGPYqV2F7LT0Znrw-1; Wed, 01 Dec 2021 12:52:20 +0100
X-MC-Unique: I13DmbMGPYqV2F7LT0Znrw-1
Received: from DB9PR04MB9426.eurprd04.prod.outlook.com (2603:10a6:10:36a::14)
	by DU2PR04MB8661.eurprd04.prod.outlook.com (2603:10a6:10:2dc::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23;
	Wed, 1 Dec 2021 11:52:19 +0000
Received: from DB9PR04MB9426.eurprd04.prod.outlook.com
	([fe80::ed16:bc50:4079:9286]) by
	DB9PR04MB9426.eurprd04.prod.outlook.com
	([fe80::ed16:bc50:4079:9286%9]) with mapi id 15.20.4734.023;
	Wed, 1 Dec 2021 11:52:19 +0000
Message-ID: <a2320b53-8af2-575b-9589-faf1f1bb41a6@suse.com>
Date: Wed, 1 Dec 2021 19:52:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.2
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <20211201051756.53742-1-wqu@suse.com>
	<20211201051756.53742-3-wqu@suse.com>
In-Reply-To: <20211201051756.53742-3-wqu@suse.com>
X-ClientProxiedBy: BYAPR06CA0024.namprd06.prod.outlook.com
	(2603:10b6:a03:d4::37) To DB9PR04MB9426.eurprd04.prod.outlook.com
	(2603:10a6:10:36a::14)
MIME-Version: 1.0
Received: from [0.0.0.0] (149.28.201.231) by
	BYAPR06CA0024.namprd06.prod.outlook.com (2603:10b6:a03:d4::37)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22
	via Frontend Transport; Wed, 1 Dec 2021 11:52:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcd10129-c6d3-48d3-bd13-08d9b4c10701
X-MS-TrafficTypeDiagnostic: DU2PR04MB8661:
X-Microsoft-Antispam-PRVS: <DU2PR04MB86611D0A8DEDD06C3C939782D6689@DU2PR04MB8661.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: dwjXlWY7OaAX3FjmnRDOMJyL7DCpucG331v1aOomUjcf5zg4w2py+fW9ZwY0DkglSxOr+ActtsYOWAesINSBvgqAPGOWO/oTVpb14+oe+640+4trHBP7Ep+gjMlUwqtGCs8Yv6xZz1ctVts9zL7VhVlt6zSnEDUJM2/EsOxAMRHzqMQlfXR1bB9JB5N4WBFlbxg0b7x1PSJf1athBU6Ai4rVLOtIVP6sguRJFktfTu0/jo56fl+yNtvOXLt8dRieyHag70kBXUPo1pLypzrgUSNKuUzFyU3AP7x76Q5AbOLE0RtlTVyYSV9Cgd1zvlJIN2mSN6ugTTwXJe6rhaUbWX+cZP/QDePHpYVKQoYIRhZJSy1aw7J4wSbEqAEISirOuA+QFA+JiBfC+rOAz/XVbu+Y6VSx/Xmrvd2p9oovCoXYRpJhBLqqac8Ar0sS6wctt7HpRhHJtmcBfyWfglIuXa1AQEN032OwpHh6qcy1EicOWp6K4BX0eCgRK0mkOME8FkVo3n6Dwv/eXfeLsI0QPRXEky9nNCK76UdBjF0zJN7maGLPYxOGJtP46wrSmU9vRA2d5RDBuU+8kVIoPxgsrUH6ED+R2dIx+th0TFFoB20Ty+Q/HoZNLbpXGfF3Vk58wWDOOcJ1lqXlXMAprJQC4Rt+9iVeArPLgPD7WfUQ02zdaMpVfZaFl4BV+A/rThJS2qb419JBMbgUqj9N0+AkbEuGscgItJggZsEI8JOFn8xLLdH8M2M8XmbvQf36wip3
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB9PR04MB9426.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(6706004)(66556008)(26005)(2906002)(16576012)(31696002)(83380400001)(8676002)(53546011)(36756003)(5660300002)(316002)(508600001)(8936002)(86362001)(6486002)(66476007)(38100700002)(6916009)(6666004)(31686004)(956004)(66946007)(2616005)(186003)(4326008)(78286007)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHBBS2xEOStJeFBMY0E1Lzc2RE5uYS8xY095T3NnZEZ4cFBobE5XRGxtUW92?=
	=?utf-8?B?cllqWGljSXZPOHlqYXhRZDE4ZWV6cWZzSUlUTUROR0YxNGw2RHpzemwyOGoy?=
	=?utf-8?B?c3RyaWE3UUE4THRBWERPZ3FLR3pnZVNtS1RuYUNHeHlFZm9vanltT0lwYTBD?=
	=?utf-8?B?WFNPMStRSjZlUkdvRnBzZVZPc3JnK01IR09UajlTdWtsL3VCeXZVYjE5Y3Zy?=
	=?utf-8?B?RFFwMC9uWDJjdEIxTmtoU1l4OGVaS1kySXlzNElYU2J3b2I2cHlOWlZtUGEx?=
	=?utf-8?B?MEpROVE3TTVmZGk0c21TWkw2RFFjaENjaTdTN3ZaVUJTNHU0cXhEMldnWE5N?=
	=?utf-8?B?WkxHUUpPYW1CeGRRaFo2a2R6YVBaSytqMFU1eWxFYWEySmxRM0lmMTAvNGV3?=
	=?utf-8?B?TzMyZDJ5SlA0N0EvU09KRHNEVHk5SkUwU09zRzJtVzF5dm5OUGNCSUtRSmtK?=
	=?utf-8?B?RllmL09xc0lOT0RsWXM5VkJja1NlRC9Jb2E2UGc0UjdnZlNHQkdHaUszRzYy?=
	=?utf-8?B?WGVIQjBiYlBMdTg0Tlk1RVhxUk5LaW45KzU0MS93L1BNd3llSnhDS1VrbVdG?=
	=?utf-8?B?NWhIQTB1UFZzcWJFNjcrZUkyclprQ05WaSs1NFg2YndwUVN6NjIvanFYWUly?=
	=?utf-8?B?NzRSbGVnSU5MUVFOZ0VIb0NzSTEvQ1ppZXdtOWg0SEYvamc3RXRvVmJjSmJ0?=
	=?utf-8?B?K1l6U0M1aUtqQmpKR3NJVy9KL2l4MmNjck5JeWF1N0VJeWQzMGUxcHNTOFgw?=
	=?utf-8?B?THVwNlFRYmIxeTJtSDJRcGVIVFVUWjhYeDVzSkxyT2FETGFBUnEyQ3YrV3Ay?=
	=?utf-8?B?NmM5WFlWTjZNVDlGb3A3NXRPUnAzaExiN2FHMUY5V0M1MXQyZUNxc1FFSHpl?=
	=?utf-8?B?VXdMeEYvRHh2Uk5SM01adWg3cXRzZm9TWnp1ZTVKa24zQjVmZ0ZmSUlzQ1VG?=
	=?utf-8?B?ZzVFcnMxeTM2TkRTWHpXeTJubTY0Z3EyS2V2cnVPdFJyYnpHSklLNUcyQ3Fj?=
	=?utf-8?B?aDc2TUZEd0JMbE53VzVNNi9uNHl0WmVDY3doVVlvWkFWUHl0d0pSOU9oM3FG?=
	=?utf-8?B?Tk5DbmVyTVpFY2xFem5DVSs1Wjkvc3daa1lycWhSQ3FZZXJJYXRIWmRLMU1U?=
	=?utf-8?B?Q0xwaS9FaU9wV3RrUW0rVFFNZ0RsVUZyNEhsbm9vMGd0alNDdDR4UkxQWnZI?=
	=?utf-8?B?OFBPMTRFbDl6dGtCZ2hnZE1jc1pVU2xOT3dnVnN2Ykp3WlJOZ0tJa21rUDk3?=
	=?utf-8?B?RUhFcXVVYXhJUkd0MFlOOUMrZm5lR2pqQWUxVmV0WTNKRUNLMEJOZ00xcm5n?=
	=?utf-8?B?YVRZdHBRN0V6My9MT3lZcUVxcHp4VjhnbXZtWHRZMzg5TkFCdkpJbjRTb2o5?=
	=?utf-8?B?RWtWWVhZRXdxdVhXQ21BRzMrdG45Y2FobFdTK0N6TndWZlZ4TEY1WnZLTWpC?=
	=?utf-8?B?UUlTQkpzaVlPU2FhTlJkZXdmdElZZ3dkRnJWSEFYaGtjMFUvQ0JmQWVjb3Y5?=
	=?utf-8?B?Y3ExckE3bHQ4TC9SOUozTTFYbzMrZ2ZYaXE2SjFzL0VqOXNuZnhxa2UwODU2?=
	=?utf-8?B?TmJPN0UybzVWRXpFS0RrbmVnbW1DMTc5aVMvcU8xMHlONmhCVm43Q2tsMUo0?=
	=?utf-8?B?elpESVJuYUpIR2VxbC9TbytwSEZNNzRlQi9oeng5S0VTSFZVNDdzMmtXQjlM?=
	=?utf-8?B?REhPR3VQa0EyMUNiNGhndDhxem5oS1pVcmtYbGhnM1kvRS9LVzBmelRyUDNn?=
	=?utf-8?B?eTZtV0hnSkcvMWVXU0VRWmVZUUhsaGZqUkszNGVBVUwxdHZxRGhPb2dRb0NL?=
	=?utf-8?B?Q1JORjdzdDJNY2xBRDV3SEpOQzA2Y25kOWVIb3REZUEwSnlJeW5wUWNpTmll?=
	=?utf-8?B?M0hMTnNuL1d2NEdlbExtaGkrOFZiZ3p1Q0NwbUtIWTZldkJTSUlBc0N5SE4r?=
	=?utf-8?B?NldBQkwwQWFlS1dzbUc5Vk1UdzBiVjM4bEtTN0w4MnFORGxkYTgwc0NiZGNh?=
	=?utf-8?B?NEhBQ240a3J6R25HekNQd2NCMGxZVmN2dU9PelVnV3Nmdk9obFZWZi9wK1pa?=
	=?utf-8?B?OGxZdEx0ejgxMVdmNWdkeHRtRkZDQ1Z2RVpGbE9yNUVpQzBiUExrZTljY05i?=
	=?utf-8?Q?tWKI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd10129-c6d3-48d3-bd13-08d9b4c10701
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9426.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 11:52:19.1705 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGskQKR/eJSDmWmTLXbwUf75ntrWOTmPL8hvksaeYUIPL2cZ5tAETnYGNUfr8D7K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8661
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
X-Mailman-Approved-At: Thu, 02 Dec 2021 03:16:58 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 02/17] btrfs: save bio::bi_iter into
 btrfs_bio::iter before submitting
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



On 2021/12/1 13:17, Qu Wenruo wrote:
> Since block layer will advance bio::bi_iter, at endio time we can no
> longer rely on bio::bi_iter for split bio.
> 
> But for the incoming btrfs_bio split at btrfs_map_bio() time, we have to
> ensure endio function is only executed for the split range, not the
> whole original bio.
> 
> Thus this patch will introduce a new helper, btrfs_bio_save_iter(), to
> save bi_iter into btrfs_bio::iter.
> 
> The following call sites need this helper call:
> 
> - btrfs_submit_compressed_read()
>    For compressed read. For compressed write it doesn't really care as
>    they use ordered extent.
> 
> - raid56_parity_write()
> - raid56_parity_recovery()
>    For RAID56.
> 
> - submit_stripe_bio()
>    For all other cases.

These are not enough.

There are cases where we allocate a bio but without going through 
btrfs_map_bio(), and error out.

In that case, those bios don't have bbio::iter, and can cause errors in 
generic/475 related to data/metadata writeback failure.

Fixed in my github repo, by just adding more btrfs_bio_save_iter() calls 
in error paths.

Thanks,
Qu
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/compression.c |  3 +++
>   fs/btrfs/raid56.c      |  2 ++
>   fs/btrfs/volumes.c     | 14 ++++++++++++++
>   fs/btrfs/volumes.h     | 18 ++++++++++++++++++
>   4 files changed, 37 insertions(+)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index e776956d5bc9..cc8d13369f53 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -870,6 +870,9 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>   	/* include any pages we added in add_ra-bio_pages */
>   	cb->len = bio->bi_iter.bi_size;
>   
> +	/* Save bi_iter so that end_bio_extent_readpage() won't freak out. */
> +	btrfs_bio_save_iter(btrfs_bio(bio));
> +
>   	while (cur_disk_byte < disk_bytenr + compressed_len) {
>   		u64 offset = cur_disk_byte - disk_bytenr;
>   		unsigned int index = offset >> PAGE_SHIFT;
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 0e239a4c3b26..13e726c88a81 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1731,6 +1731,7 @@ int raid56_parity_write(struct bio *bio, struct btrfs_io_context *bioc,
>   		return PTR_ERR(rbio);
>   	}
>   	bio_list_add(&rbio->bio_list, bio);
> +	btrfs_bio_save_iter(btrfs_bio(bio));
>   	rbio->bio_list_bytes = bio->bi_iter.bi_size;
>   	rbio->operation = BTRFS_RBIO_WRITE;
>   
> @@ -2135,6 +2136,7 @@ int raid56_parity_recover(struct bio *bio, struct btrfs_io_context *bioc,
>   
>   	rbio->operation = BTRFS_RBIO_READ_REBUILD;
>   	bio_list_add(&rbio->bio_list, bio);
> +	btrfs_bio_save_iter(btrfs_bio(bio));
>   	rbio->bio_list_bytes = bio->bi_iter.bi_size;
>   
>   	rbio->faila = find_logical_bio_stripe(rbio, bio);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f38c230111be..b70037cc1a51 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6829,6 +6829,20 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
>   		BUG();
>   	}
>   
> +	/*
> +	 * At endio time, bi_iter is no longer reliable, thus we have to save
> +	 * current bi_iter into btrfs_bio so that even for split bio we can
> +	 * iterate only the split part.
> +	 *
> +	 * And this has to be done before any bioc error, as endio functions
> +	 * will rely on bbio::iter.
> +	 *
> +	 * For bio create by btrfs_bio_slit() or btrfs_bio_clone*(), it's
> +	 * already set, but we can still have original bio which has its
> +	 * iter not initialized.
> +	 */
> +	btrfs_bio_save_iter(btrfs_bio(bio));
> +
>   	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
>   		dev = bioc->stripes[dev_nr].dev;
>   		if (!dev || !dev->bdev || test_bit(BTRFS_DEV_STATE_MISSING,
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 3b8130680749..f9178d2c2fd6 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -334,6 +334,12 @@ struct btrfs_bio {
>   	struct btrfs_device *device;
>   	u8 *csum;
>   	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
> +	/*
> +	 * Saved bio::bi_iter before submission.
> +	 *
> +	 * This allows us to interate the cloned/split bio properly, as at
> +	 * endio time bio::bi_iter is no longer reliable.
> +	 */
>   	struct bvec_iter iter;
>   
>   	/*
> @@ -356,6 +362,18 @@ static inline void btrfs_bio_free_csum(struct btrfs_bio *bbio)
>   	}
>   }
>   
> +/*
> + * To save bbio::bio->bi_iter into bbio::iter so for callers who need the
> + * original bi_iter can access the original part of the bio.
> + * This is especially important for the incoming split btrfs_bio, which needs
> + * to call its endio for and only for the split range.
> + */
> +static inline void btrfs_bio_save_iter(struct btrfs_bio *bbio)
> +{
> +	if (!bbio->iter.bi_size)
> +		bbio->iter = bbio->bio.bi_iter;
> +}
> +
>   struct btrfs_io_stripe {
>   	struct btrfs_device *dev;
>   	u64 physical;
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


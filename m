Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2100.outbound.protection.outlook.com [40.107.96.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FA91DDC0F
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736185773; cv=fail; b=Nzz3oV6n6VxltMe7HCT83s68dRTKjCrOXc6j8dsUEfHbcYriIKNZdrUe/HKV5U1QQ6GwZ1nAWq2uckTElw9vsTV8ABMJs+AJ79fods7PQMrspLorVnSVrNB09oCjAoGqXAodB9nrRLVyf3hP/3SK3JcIwbRsgXq5PnA8uMZW3BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736185773; c=relaxed/simple;
	bh=TMyFvtS/zt1avGxxuYdN4CkV+qiNh3vzXAuXbDK9OqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C0jejOG6SZKKNm9rL/tS8xzfZkcQdIR1hGqPYTtym4md3zedDipjZDK9ZMwClr6CxZCRi/XOqX/OGPtS2bp4wMtfB4s88dY7nkVc/4h/hzWJiRsYfQQWwjQPQU71By+rWBhQraZR7pUNDRr9rtgyMmOhXiLqlVNYUpuZ7caErqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hammerspace.com; spf=pass smtp.mailfrom=hammerspace.com; dkim=pass (1024-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b=Yo1H/Eyr; arc=fail smtp.client-ip=40.107.96.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b="Yo1H/Eyr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uwzIr0gp/tA4svk+va30hePaalnxx8LdKrkoK7T1X8kR3C2SwbrGGp51D1D+MdfJ1zvkgfoVri3uc445GcKHYRvMgCcYjlFSe9XwazpzWl/8waQwFWFnqHoBpMBFIKkNEcZDXiZoNVrZIZEBnfB9ldeU85OXeMdTCtyj3OJlgYBPhXwbqPbq/x+55PawXutLQF/DjkqVIXAVLSxhIx1y9OVtXGNNGR6YLfKqxsMB7vvcXjAyZ/ruUq6+gW/Di6ASCXAX06n3E3pouyCGQ3YgP1izN5EBMXlob9x6D8a7g/iKjkDQpUFULspWTg8oOZ9mM9WAnnYry7r8C3UipTrqjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoCtOYcac8GP3h2Ugx/CdiY9FWHaohrHVBoB8qYvvK4=;
 b=KppTQMqQPaPkuHLTF9HMv1l7mu2U/EdW8RwhqYsVGaEBYFGlpV8AIIZW4E7Trg1MSaNC072YNb5rs5y4mYC3vvLyxaIBovmVTE+UDRyytbZ91U9WLIMihQXfwa2JVNRYHP5yJgkPsTat1OQ2w6uJ11EYCdkJjg/AVGvsQjqHOLLwgNORbRweT11YXvfIHBLF55dLYIKKnn+fWw4yGPLLW4SHz4LSFcDql+73cb9qayfn0RkcHHNe2iF9tuKSdE5/ud2jfbaqk/lRpIj25WTC+e9H1dzPVtMSEJ85I2LV9c9MTQ+AWOiqOdqfxsFV/cwP95CjWaMOHNs9FKR9HGqcNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoCtOYcac8GP3h2Ugx/CdiY9FWHaohrHVBoB8qYvvK4=;
 b=Yo1H/EyrSJ9JzdP5cIIhNZXQbTvyYc4ZIa7bCLPs6sknys+qzzGLAcK87J5t7MmfxLzJGou4DmHSnQxCx9dbj52W+XeHnnt4VgMpiqhRGdDNUiYaofEa/Y0pkY07he8yBRtBoRru5NnfuWinUy3ZuS751J7W/Qpa6B9l7AUb5W0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
Received: from DM6PR13MB4036.namprd13.prod.outlook.com (2603:10b6:5:2a7::14)
 by CO1PR13MB5048.namprd13.prod.outlook.com (2603:10b6:303:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 17:49:24 +0000
Received: from DM6PR13MB4036.namprd13.prod.outlook.com
 ([fe80::2a78:7a0:a33:cecd]) by DM6PR13MB4036.namprd13.prod.outlook.com
 ([fe80::2a78:7a0:a33:cecd%7]) with mapi id 15.20.8314.018; Mon, 6 Jan 2025
 17:49:24 +0000
Date: Mon, 6 Jan 2025 12:49:23 -0500
From: Mike Snitzer <snitzer@hammerspace.com>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, agk@redhat.com, hch@lst.de, mpatocka@redhat.com,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 3/5] dm-table: Atomic writes support
Message-ID: <Z3wXoytvSU96ZAHj@hammerspace.com>
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
 <20250106124119.1318428-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106124119.1318428-4-john.g.garry@oracle.com>
X-ClientProxiedBy: MN2PR14CA0004.namprd14.prod.outlook.com
 (2603:10b6:208:23e::9) To DM6PR13MB4036.namprd13.prod.outlook.com
 (2603:10b6:5:2a7::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4036:EE_|CO1PR13MB5048:EE_
X-MS-Office365-Filtering-Correlation-Id: 08fbf6a2-fc2a-45b0-bf9a-08dd2e7a753c
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2nghJ8kupdQw4OVgBKvANm5wWKxBMGdXuQ1DTD6lOhgO1NoBEx5RpUjpmzE/?=
 =?us-ascii?Q?SjZERD0PeccuMemySxX8v/85wt+fUMzSdiKhJ09gEgbqdyx+6KJHwZuT182M?=
 =?us-ascii?Q?XMrS8wTfOs8Nw5seFgIjWP1u/DANMiAdzEz7cGk0esc6hZC9lQj23zYSQYQ9?=
 =?us-ascii?Q?CC+Rvhjj4cpIAiZBG3GVXfMY4i78dD3uVhaMJCHXe+47+BBJwIc+HOMTVY3A?=
 =?us-ascii?Q?WUR6IT9x7SA51LVY0LUm19wU+wXrpMO9xfbZsj1orCyuEn5VMLuhuqfQToTt?=
 =?us-ascii?Q?qgHbnb2WCqshScsd6xOUR/GMw0/p7H9O/YITqOQYiDK6k7P0iSuTA45BUsQU?=
 =?us-ascii?Q?l+tqojZnAV7mcQQOk/4IGp8MNoKo4RQsbECsIbDJ4S0IJAAUupBwGYWp4HzV?=
 =?us-ascii?Q?DH3eHdhEYvXHIXQ39wrTNsuLDX4MVLu7XHuaq6TXhvcJ/daj9wJypG0Wnn7I?=
 =?us-ascii?Q?UiSjqUxySod01UVJafzf7xbchvnu/ARyjxMjQZ79A2gz58e9HoBmm3R/c+y2?=
 =?us-ascii?Q?ZbGwTVYPsLwuaR2qsSYPukfy4BFSNaMjAmhMDuHrHifWaBO0T7/YWGLObmLs?=
 =?us-ascii?Q?gcq+/nNA0MzIzLUkcTgRW5AkgD9nOLlgwpRmk7na0dARk4pA0NGkUr889sFd?=
 =?us-ascii?Q?iMFURH4EdNA08QG26YXr4Ifcd2ULBe900ZzVxnIPgLSSY8+U0GNWniZc3kZa?=
 =?us-ascii?Q?CGJ5kOXB+RjCNtPX5T6KU5BuFj8VqDZ2MASJtsoxPJuTjx9kRueaIBoVD8cm?=
 =?us-ascii?Q?YeaWUtYFqo53HLvUgOvRApE45vJp2tT2TAHAIYd+Sw5RPbMny5QBq6JDMlpm?=
 =?us-ascii?Q?1Ejx0Vw9ol/zbLTtHu/rzrJ6HjX4NlYaUwiZKL00q98GR7JHlb8yeOwOdP9A?=
 =?us-ascii?Q?89o2afhkow0aEMDhJjgsdsVEIrhJ4VuOqKWT0Txomk5c+3scZhNPtC4tyz4d?=
 =?us-ascii?Q?yOT2O9ZLoJRErW/iQNldO65jwoqV7r6XhHuyS3tvrjCVOoygL3Bf+ZIkWQNn?=
 =?us-ascii?Q?KnZiyB/jYUqkZyZuryTgKQV4pSLQMaOVBD2s9f8a7Gw7xwc4oZFhDZxjSFb6?=
 =?us-ascii?Q?XULpshOR4Q8SBHkQNOgJqEG7RPPx8wp9J5REcesoqBba5iYfSsKBG68MAUOu?=
 =?us-ascii?Q?f4ysjzmS/u6UKGjjC/FuMLoVSYZbPaw3Uh1ErQ8aQ5Gkb+m0ecaYeLHdRivV?=
 =?us-ascii?Q?2iwXMp3CVJH7sDQLHbUe90jFXCh6U82QCtaPN0ttg2ymPHpXJHN++wx/3/J1?=
 =?us-ascii?Q?nF4mMvqClOSESrFND8IqIbJkndmis6pFp43nHuowTBt17m5TjLQc6BSskZsH?=
 =?us-ascii?Q?94GNl6RaIu71B4wAqotgFTmmAdyrtp3H5Q9bVzdt0i0MvbEq9zrmtDlIVLQm?=
 =?us-ascii?Q?960VSTopsC7Erva4o80T+tVegLNX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4036.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZpckkoAA6uAduKvPQJE84Aq6McBRFaspCSIbLjD3CwrJs8eeKc8OD8yNXdB9?=
 =?us-ascii?Q?k8fmerD3uBD8spyzagvTn3m5i83kkgBNkCxwhJyJhxbU608f3Bhq+e4QRBRy?=
 =?us-ascii?Q?NpS0dLYHhy0sSIlY66jtgrw3dWKNVlSFv0PVVNpADrdulB+RdjKvjPSSVJ7G?=
 =?us-ascii?Q?5koruNAfLb/FI+Zm3F7C9FHbRrlf1xgea195gqwphJIn2RCmxLaXB106iUf0?=
 =?us-ascii?Q?8Bk3W/3getIPRIM8ikTAhCfx5UAcMQEt3pNiQKHNhXLSOI+CTmGBvIO8oT0x?=
 =?us-ascii?Q?Bd0pbKYWnNw4d6coThkR8d1O19QWnC3rXNjIwG+AZeZoSf6I4siWoAL5V6SA?=
 =?us-ascii?Q?YFp00JC27IHczC/sXpoGQCTrzZvWDaTpUzjSsbo5axgLdop//wDhxS7DU0PJ?=
 =?us-ascii?Q?xbTIXOA8tW3JBhs55OGztHSjvBew2rudT3f6GB7XTzwI95Qx/4O/h++Z705Y?=
 =?us-ascii?Q?gXTHkdf/+qDBhJ25V6BUvE/ytxIb/EJo9EPVQ8MrldB80lNt4dj0t/LKfFDT?=
 =?us-ascii?Q?E9FYAtXtd1KgdOolni1BGVonSrGC3860Y5aTNnx8Lh4OTH3Exz2FvUu1Ugae?=
 =?us-ascii?Q?sjUrZoXSCXy9ZHfTvywp0XhyYgh8kMbQzPR56vyJ7+AAES96y7a4mb8sDzT3?=
 =?us-ascii?Q?nCAHxHbaIMhslkCYXIXGlbuh5A7TK9SY7xmiF8Gz457kcHpIBsiSE04BjE58?=
 =?us-ascii?Q?i6YqdcqR2aAuZxC4/0BP2a4fgwFSoIecy1MTMXp5HEXmm3d27FmLSCOdMRPU?=
 =?us-ascii?Q?icMDoHTANi7UU5dLb4LhgxgOQnDSO9uFQnLyS7hFsRJ/YzzC8jaIttvgaeMq?=
 =?us-ascii?Q?DO2lcqtXXQkhl2+b7na5VEUQyGmDCc0E5ZkNuIl+FG0amVYBYB54JJ0verYN?=
 =?us-ascii?Q?UDGFX/4oDS13VG8sNt9laV2jNQ30U6UBPAvO1jJaqRPfWsckkBzjIz0Yz4SQ?=
 =?us-ascii?Q?es9uU9vl9VFwveZWbvkAKCRcjKITZN7R/VaeLpBc4oVaVqfkeBWcgTuT4YMq?=
 =?us-ascii?Q?XdgOh49iYxGYkmkmG41aSuG1hNb0NWTjxdUizsdcKrpYFdTz7HRocWPKyEln?=
 =?us-ascii?Q?N3ITs8C8IZ/lujeNvN/FWn1APilJDMuvijMnx3blNSHLXWgj0JjxTtA9STzR?=
 =?us-ascii?Q?P3p/LL405lAo1mNv3nJguO6sx+T5eoj9FD0gl53BF3mKagwyEpATeSuH74Dg?=
 =?us-ascii?Q?V3OA+OCQqYEAxFV6MJlxPczeF2eWReidvPwjIjiKf1WFb5C8QJcKayWHcuSf?=
 =?us-ascii?Q?wFHYHjLNlqOhc4OrQr+CPr/pSWs8CQ4R2DY9MVCLxbDsW0P1Jrcjo6tKE7Ws?=
 =?us-ascii?Q?3413xtoX8cBi6VhkpADbTiPAUOTcRcM0xP7Af8PoAYuISoZVMGjidSifr67W?=
 =?us-ascii?Q?VrWMn80kmtCVU/pNcyDVhNoD5A1miLYwoPZC7VZed9kgD3DAhGefwYZlwltO?=
 =?us-ascii?Q?iDMoHzUYo4e8BChg4Qtoud+CHl5GlMqdY3WlCZRqZlBqH6+f+JZMk7egjmGD?=
 =?us-ascii?Q?ai59Dh4Ns0xUZA5+cVJjwLOJ0xqG0KvizwykSVSsZBw5oudAGPdfsvm86/1E?=
 =?us-ascii?Q?oHm++7Bc+X5NgwEJG0wAo3TF9vrWQIbgQ4An27NeGkpx7WTcNcRkG57kK31m?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08fbf6a2-fc2a-45b0-bf9a-08dd2e7a753c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4036.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 17:49:24.5608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2GuwZksGxGGEqCdrw/4U1MU3vtOpPS/T97vku0tsPL2o5daJdY3Ye4M1wS2Rb8Ostkv6gzFMxy7FrgP8NymOCZrQB8sCJv769v2wlaMLc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB5048

On Mon, Jan 06, 2025 at 12:41:17PM +0000, John Garry wrote:
> Support stacking atomic write limits for DM devices.
> 
> All the pre-existing code in blk_stack_atomic_writes_limits() already takes
> care of finding the aggregate limits from the bottom devices.
> 
> Feature flag DM_TARGET_ATOMIC_WRITES is introduced so that atomic writes
> can be enabled on personalities selectively. This is to ensure that atomic
> writes are only enabled when verified to be working properly (for a
> specific personality). In addition, it just may not make sense to enable
> atomic writes on some personalities (so this flag also helps there).
> 
> When testing for bottom device atomic writes support, only the bdev
> queue limits are tested. There is no need to test the bottom bdev
> start sector (like which bdev_can_atomic_write() does), as this would
> already be checked in the dm_calculate_queue_limits() -> ..
> iterate_devices() -> dm_set_device_limits() -> blk_stack_limits()
> callchain.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/md/dm-table.c         | 12 ++++++++++++
>  include/linux/device-mapper.h |  3 +++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index bd8b796ae683..1e0b7e364546 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1593,6 +1593,7 @@ int dm_calculate_queue_limits(struct dm_table *t,
>  	struct queue_limits ti_limits;
>  	unsigned int zone_sectors = 0;
>  	bool zoned = false;
> +	bool atomic_writes = true;
>  
>  	dm_set_stacking_limits(limits);
>  
> @@ -1602,8 +1603,12 @@ int dm_calculate_queue_limits(struct dm_table *t,
>  
>  		if (!dm_target_passes_integrity(ti->type))
>  			t->integrity_supported = false;
> +		if (!dm_target_supports_atomic_writes(ti->type))
> +			atomic_writes = false;
>  	}
>  
> +	if (atomic_writes)
> +		limits->features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
>  	for (unsigned int i = 0; i < t->num_targets; i++) {
>  		struct dm_target *ti = dm_table_get_target(t, i);
>  
> @@ -1616,6 +1621,13 @@ int dm_calculate_queue_limits(struct dm_table *t,
>  			goto combine_limits;
>  		}
>  
> +		/*
> +		 * dm_set_device_limits() -> blk_stack_limits() considers
> +		 * ti_limits as 'top', so set BLK_FEAT_ATOMIC_WRITES_STACKED
> +		 * here also.
> +		 */
> +		if (atomic_writes)
> +			ti_limits.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
>  		/*
>  		 * Combine queue limits of all the devices this target uses.
>  		 */

You're referring to this code that immediately follows this ^ comment
which stacks up the limits of a target's potential to have N component
data devices:

                ti->type->iterate_devices(ti, dm_set_device_limits,
                                          &ti_limits);

Your comment and redundant feature flag setting is feels wrong.  I'd
expect code comparable to what is done for zoned, e.g.:

                if (!zoned && (ti_limits.features & BLK_FEAT_ZONED)) {
                        /*
                         * After stacking all limits, validate all devices
                         * in table support this zoned model and zone sectors.
                         */
                        zoned = (ti_limits.features & BLK_FEAT_ZONED);
                        zone_sectors = ti_limits.chunk_sectors;
                }

Meaning, for zoned devices, a side-effect of the
ti->type->iterate_devices() call (and N blk_stack_limits calls) is
ti_limits.features having BLK_FEAT_ZONED enabled.  Why wouldn't the same
side-effect happen for BLK_FEAT_ATOMIC_WRITES_STACKED (speaks to
blk_stack_limits being different/wrong for atomic writes support)?

Just feels not quite right... but I could be wrong, please see if
there is any "there" there ;)

Thanks,
Mike


> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 8321f65897f3..bcc6d7b69470 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -299,6 +299,9 @@ struct target_type {
>  #define dm_target_supports_mixed_zoned_model(type) (false)
>  #endif
>  
> +#define DM_TARGET_ATOMIC_WRITES		0x00000400
> +#define dm_target_supports_atomic_writes(type) ((type)->features & DM_TARGET_ATOMIC_WRITES)
> +
>  struct dm_target {
>  	struct dm_table *table;
>  	struct target_type *type;
> -- 
> 2.31.1
> 

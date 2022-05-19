Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09315C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 07:02:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-W7yV80KlOHSyuRuMdlq8hQ-1; Fri, 20 May 2022 03:01:59 -0400
X-MC-Unique: W7yV80KlOHSyuRuMdlq8hQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4AEF296A62F;
	Fri, 20 May 2022 07:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDB7240D2822;
	Fri, 20 May 2022 07:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B4E58194EBB2;
	Fri, 20 May 2022 07:01:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B125194704A
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 04:14:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64E871121319; Thu, 19 May 2022 04:14:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F0631121314
 for <dm-devel@redhat.com>; Thu, 19 May 2022 04:14:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FB8F3C01B82
 for <dm-devel@redhat.com>; Thu, 19 May 2022 04:14:37 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-yroXFd1sO-6E6P3Bg-V4DQ-1; Thu, 19 May 2022 00:14:35 -0400
X-MC-Unique: yroXFd1sO-6E6P3Bg-V4DQ-1
X-IronPort-AV: E=Sophos;i="5.91,236,1647273600"; d="scan'208";a="205617609"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
 by ob1.hgst.iphmx.com with ESMTP; 19 May 2022 12:13:28 +0800
Received: from DM8PR04MB7765.namprd04.prod.outlook.com (2603:10b6:8:36::14) by
 DM6PR04MB6699.namprd04.prod.outlook.com (2603:10b6:5:241::10) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Thu, 19 May 2022 04:13:29 +0000
Received: from DM8PR04MB7765.namprd04.prod.outlook.com
 ([fe80::f9ca:774a:df15:c95b]) by DM8PR04MB7765.namprd04.prod.outlook.com
 ([fe80::f9ca:774a:df15:c95b%4]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 04:13:29 +0000
From: Naohiro Aota <Naohiro.Aota@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Thread-Topic: [PATCH v4 07/13] btrfs: zoned: use generic btrfs zone helpers to
 support npo2 zoned devices
Thread-Index: AQHYaUWsYuDhrEl/OEabFy4UgQ7IPq0lmwkA
Date: Thu, 19 May 2022 04:13:29 +0000
Message-ID: <20220519041328.rcfd2jk6pslwvyfm@naota-xeon>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165428eucas1p1374b5f9592db3ca6a6551aff975537ce@eucas1p1.samsung.com>
 <20220516165416.171196-8-p.raghav@samsung.com>
In-Reply-To: <20220516165416.171196-8-p.raghav@samsung.com>
Accept-Language: ja-JP, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5eacd7ba-6c1c-438a-ff09-08da394dedf2
x-ms-traffictypediagnostic: DM6PR04MB6699:EE_
x-microsoft-antispam-prvs: <DM6PR04MB6699792867014CCA50272A2E8CD09@DM6PR04MB6699.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ac3bO6xAvwRXALm6j+HksnDQxdrxxiyPnOi+nTqxj4XFL4wHa6Y4Fr5BLUhVkiA804m07ZJwVHoBXjUg4RAaHGrHL53sR7sVwMhAPCkCGw0dDZoFNn43ZKD1v2W5QYpeyTh9eBZSvHtXo2T5HgTsh0fQuZHy3bowLycHeknDoO7QVxWkK7XBezqJ/xlubrplJKS1Nuv5X/ycJfFN/thWMT7NKM8RQ6cVgA3hYw3Sey7PErjB3b2jq7+aUALQut5IMwO/4zFs5UBD8fLZFTm8DFdwPa2ruJWirdw/90jyarSSOudmaDkIXzNMEUHCh6jbuMHHQC5tPJx4PAXnqM8wmctNb7akByS86gLaBlQnmGHSv3t2Q0d7S+rADCH5LDEcoBBa7/bRHAreZ2n+YyTVyhjH5LAmrX1TwoRxBPvtLBU/tQ+sEAM52YxpuDxlRUgWJWy8rYJCKFzIbK6BTr1OD4HrdoW5fQs3AsaIN5rOwlMTXghkb0O0T2mUGDxkKvbId5wzUGZIUOYA2bi/nKe9jMAKZA6PEzuqJjwtEJ3sEiZsqJ8aAPxOz/SqkwRPRLnPg1/V67Mu8hlWitU2CemB/wFyCOjs4T4arf1T4qt1UajiOIbLYCMLV+S99LjyDbElPyIMgihUo80XvUySu7FUn8vpDR+CXV8v7gWZXWRHn+DQ5P4gd628bsjgmnK8eDoieWZRpYq/dOEZMv132CutLQ0+hcFDnZX8TLUdcdl9fsw=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB7765.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(4636009)(366004)(8676002)(38100700002)(4326008)(6512007)(38070700005)(9686003)(26005)(33716001)(186003)(76116006)(66556008)(66946007)(66446008)(66476007)(64756008)(91956017)(1076003)(83380400001)(8936002)(508600001)(6486002)(6506007)(86362001)(82960400001)(71200400001)(7416002)(316002)(5660300002)(122000001)(54906003)(2906002)(6916009)(41533002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2kY03wkwYbIrQsmWF+X4p6cYZANYjyUYtGg2j1EAeDZDGON/Pv1jUtp7lEFg?=
 =?us-ascii?Q?mkIZ1x+VkJ1t5uQsi90wGvd4BoqLKJBE0CBEHg9l3HAG+Os7RbLcVzsTEQaB?=
 =?us-ascii?Q?UbGFrTfoMMflbV1ULfXR3pYQ4n6Zkzl7M/HvQyzvUffEO5RI95H6dKuJg5+7?=
 =?us-ascii?Q?vXCr/3IhyjbiP80jJG0eefSZfaQfG/RIiOkaJTCZEzWexH6QYKXz1m5m2bOF?=
 =?us-ascii?Q?UyYtuRbygNEmV3nZoW0Cpgm1N/TF+U08Q9VOv22wJw8CXnQ/U+ffDve/rGSW?=
 =?us-ascii?Q?9AOH6BEJZUoPq5IIi1qZeSu4JlsgJNN8XZreVa9iNcc4IHqGXqah/I4zyALv?=
 =?us-ascii?Q?ggAo0vBAq0WkiO1HpmZZwd9WdrujUaG6RDnmykeOcKQrYxmcILSk+HUOaOwd?=
 =?us-ascii?Q?cXQbPJdxnLVlgvM7wHNmodKSuuxJNFZLjv+z9HDVh9M9xaDm7YBIAwgkksz+?=
 =?us-ascii?Q?f/FiGVnGdEiWmDTTo7e6pghqUzJCseD5R01eW1WYU5svUtMHKXyQWlXctHqB?=
 =?us-ascii?Q?3nJflAmNcoRSuwc8t1DVGHygZMZlwpdMOtrxcfgh34HVI4WblcdwWb2ioCvf?=
 =?us-ascii?Q?01Si2DEtO68+EzT8/uAh3ZLZEsvnTAVjbi7WPvDi6R8bobh/tITIfw0ydKS9?=
 =?us-ascii?Q?qqU9lojf2q+s4WlHTvQCwkfrs9yN5zPDv70yc/CWYmqxuyFOBXa9OWby43s3?=
 =?us-ascii?Q?+Wje56B5fRw4AcwHDC/q0TBMq7KjxJbU+WzZjA1j2LSTkEF+oM/nhGx9m07y?=
 =?us-ascii?Q?NCKZsKFJFkqBLzo+jvdZOYkcl18D6A8B0zZpDI0ceWEMwqBdn5FvW/19mglv?=
 =?us-ascii?Q?HY+G2Dt3Z4rnk9rVhdWjveSlCL7C5sCZCc1N0TPrWm4sIrjguG8WBK63hETH?=
 =?us-ascii?Q?rmlOgfoYCMBbC9C5W6iJmhZzvL6N92Q8SrBU6YgP/qltl6Btdee+smuI2Ov+?=
 =?us-ascii?Q?wZK7k5O/hUf8L9eSjofMWcrk2pebzp+Y8G6TUnycd1FBUmtUfp5S0tPufJ+H?=
 =?us-ascii?Q?cHov+aqB/zuUyVu8Smpb7g36yzeX70CZFH8NFHb6sWJOqQ07d4zB2CNlMwtR?=
 =?us-ascii?Q?HY8K5NSYcLqTgSWdtY0bQcqGXaeB7o8HVlbVfY/omYdkZ9yMPYGgWytBR00Y?=
 =?us-ascii?Q?egJ3v4jvkP/MjvYnki3B+ny6LJIbHXBe+mavmN3fJoVxCE5nuun8MBpDUuwa?=
 =?us-ascii?Q?q4jgM3cPUYZdBlooJSMH+i5nzZnf/P7KnpySRz2zVkED6Qmh5mmEr7jHQjtk?=
 =?us-ascii?Q?SO12rKdaV+EXwTOWvWvknXm6MKS27MOX+hlNx9DKvNdEfe2iJk2B356wKpuu?=
 =?us-ascii?Q?YpMSQWlJqSgaQLJVeWzVxv7p/OJP+vwojL6dgo5iDKI+R+ya5MmGpNUo2I6L?=
 =?us-ascii?Q?S+vY+nFYc4bB0T1wbZtqC3yx3CCRMOJUT4EFlkV1fl8kRiii3iNzPelo7/7D?=
 =?us-ascii?Q?z9hE/EBjiskvqAPfImDi+aTyMgNMz+V/1j3mFNMg9zjAtcQh6hVvJQku7VQx?=
 =?us-ascii?Q?6asdGkwb9wRYtkplsRMOPzPoRS7mT9kWe+cRcCgBWtO9d0A0h+sZnWcrXHVH?=
 =?us-ascii?Q?KshjTFRG3B5fnOXmbr1PeZaVncBrbh99K5dtt3G3qJVQ1dgYa9aZFlOt96fs?=
 =?us-ascii?Q?1y0u/jl7/oObNFlbW/appWbHw76uXOyI7cQUo7HynMU0ff1bVjvxW65giEHp?=
 =?us-ascii?Q?zy/ygL1vEdvGyGRD5HQNu2sKT1J+tDLhgXQ54+rpZFfEJxiL3zKvtFgUVsjD?=
 =?us-ascii?Q?PJN5AHGa+RGbDgajlAgHM/tP6w1Zz38=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB7765.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eacd7ba-6c1c-438a-ff09-08da394dedf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 04:13:29.3268 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0KGOWvXXJAf9YGRkC19Z0RQcXYJndFHSZkmdKiSOWt/NMs0mcVAgdXn0qgR4AMW2H1nD3dhcMe/8CEp+19Ic9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6699
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Fri, 20 May 2022 07:01:49 +0000
Subject: Re: [dm-devel] [PATCH v4 07/13] btrfs: zoned: use generic btrfs
 zone helpers to support npo2 zoned devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Luis Chamberlain <mcgrof@kernel.org>, "dsterba@suse.com" <dsterba@suse.com>,
 "hch@lst.de" <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <FB1D8211A2248D4D9C8FDEB51CAEB0DB@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 16, 2022 at 06:54:10PM +0200, Pankaj Raghav wrote:
> Add helpers to calculate alignment, round up and round down
> for zoned devices. These helpers encapsulates the necessary handling for
> power_of_2 and non-power_of_2 zone sizes. Optimized calculations are
> performed for zone sizes that are power_of_2 with log and shifts.
> 
> btrfs_zoned_is_aligned() is added instead of reusing bdev_zone_aligned()
> helper due to some use cases in btrfs where zone alignment is checked
> before having access to the underlying block device such as in this
> function: btrfs_load_block_group_zone_info().
> 
> Use the generic btrfs zone helpers to calculate zone index, check zone
> alignment, round up and round down operations.
> 
> The zone_size_shift field is not needed anymore as generic helpers are
> used for calculation.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/btrfs/volumes.c | 24 +++++++++-------
>  fs/btrfs/zoned.c   | 72 ++++++++++++++++++++++------------------------
>  fs/btrfs/zoned.h   | 43 +++++++++++++++++++++++----
>  3 files changed, 85 insertions(+), 54 deletions(-)
> 
><snip>
> diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
> index 694ab6d1e..b94ce4d1f 100644
> --- a/fs/btrfs/zoned.h
> +++ b/fs/btrfs/zoned.h
> @@ -9,6 +9,7 @@
>  #include "disk-io.h"
>  #include "block-group.h"
>  #include "btrfs_inode.h"
> +#include "misc.h"
>  
>  #define BTRFS_DEFAULT_RECLAIM_THRESH           			(75)
>  
> @@ -18,7 +19,6 @@ struct btrfs_zoned_device_info {
>  	 * zoned block device.
>  	 */
>  	u64 zone_size;
> -	u8  zone_size_shift;
>  	u32 nr_zones;
>  	unsigned int max_active_zones;
>  	atomic_t active_zones_left;
> @@ -30,6 +30,36 @@ struct btrfs_zoned_device_info {
>  	u32 sb_zone_location[BTRFS_SUPER_MIRROR_MAX];
>  };
>  
> +static inline bool btrfs_zoned_is_aligned(u64 pos, u64 zone_size)
> +{
> +	u64 remainder = 0;
> +
> +	if (is_power_of_two_u64(zone_size))
> +		return IS_ALIGNED(pos, zone_size);
> +
> +	div64_u64_rem(pos, zone_size, &remainder);
> +	return remainder == 0;
> +}
> +
> +static inline u64 btrfs_zoned_roundup(u64 pos, u64 zone_size)
> +{
> +	if (is_power_of_two_u64(zone_size))
> +		return ALIGN(pos, zone_size);
> +
> +	return div64_u64(pos + zone_size - 1, zone_size) * zone_size;
> +}
> +
> +static inline u64 btrfs_zoned_rounddown(u64 pos, u64 zone_size)
> +{
> +	u64 remainder = 0;
> +	if (is_power_of_two_u64(zone_size))
> +		return round_down(pos, zone_size);
> +
> +	div64_u64_rem(pos, zone_size, &remainder);
> +	pos -= remainder;
> +	return pos;
> +}
> +

This is just a preference, but how about naming these helpers not related
to "zoned"? While they take "zone_size" as an argument, it does not do
anything special on zoned things. For my preference, I would take
btrfs_device or btrfs_zoned_device_info for "btrfs_zoned_*" function.

Actually, I was a bit confused seeing the part
below. btrfs_zoned_is_aligned() takes "sector_t" values while the arguments
are often byte granularity address. Yeah, actually sector_t == u64 and the
code does not relies on the unit ... so, it is OK as long as the values are
in the same unit.

    @@ -409,9 +409,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
            }
    
            nr_sectors = bdev_nr_sectors(bdev);
    -       zone_info->zone_size_shift = ilog2(zone_info->zone_size);
    -       zone_info->nr_zones = nr_sectors >> ilog2(zone_sectors);
    -       if (!IS_ALIGNED(nr_sectors, zone_sectors))
    +       zone_info->nr_zones = bdev_zone_no(bdev, nr_sectors);
    +       if (!btrfs_zoned_is_aligned(nr_sectors, zone_sectors))
                    zone_info->nr_zones++;
    
            max_active_zones = bdev_max_active_zones(bdev);

BTW, aren't these helpers used in other subsystems? Maybe adding these in
include/linux/math64.h or so?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel


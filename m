From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 03/10] dm-table: Check block devices zone
 model compatibility
Date: Sat, 29 Apr 2017 03:15:28 +0000
Message-ID: <1493435728.2698.2.camel@sandisk.com>
References: <20170421035558.2657-1-damien.lemoal@wdc.com>
	<20170421035558.2657-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170421035558.2657-4-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <F2255BEB91180541BF336925A2FABE2A@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Fri, 2017-04-21 at 12:55 +0900, damien.lemoal@wdc.com wrote:
> [ ... ]
> +static int validate_hardware_zone_model(struct dm_table *table,
> +					struct queue_limits *limits)
> +{
> +	[ ... ]
> +	unsigned int i = 0;
> +	[ ... ]
> +	while (i < num_targets) {
> +             [ ... ]
> +		i++;
> +	}

Hello Damien,

A minor comment: maybe it's more appropriate to implement this loop as a
for-loop?

Thanks,

Bart.

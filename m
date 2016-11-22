From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] New device mapper target ZDM
Date: Tue, 22 Nov 2016 15:08:02 +0000
Message-ID: <BLUPR02MB1683056A1D78B1A481A38CC181B40@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <20161121192311.14539-1-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shaun Tancheff <shaun@tancheff.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: Michael T Lombardi <michael.t.lombardi@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, dm-devel <dm-devel@redhat.com>, Vineet Agarwal <vineet.agarwal@seagate.com>
List-Id: dm-devel.ids

On 11/21/16 11:23, Shaun Tancheff wrote:
> +/* -------------------------------------------------------------------------- */
> +/* --ProcFS Support Routines------------------------------------------------- */
> +/* -------------------------------------------------------------------------- */
> +
> +#if defined(CONFIG_PROC_FS)
> +
> +/**
> + * struct zone_info_entry - Proc zone entry.
> + * @zone: Zone Index
> + * @info: Info (WP/Used).
> + */
> +struct zone_info_entry {
> +	u32 zone;
> +	u32 info;
> +};
> +
> +/**
> + * Startup writing to our proc entry
> + */
> +static void *proc_wp_start(struct seq_file *seqf, loff_t *pos)
> +{
> +	struct zdm *znd = seqf->private;
> +
> +	if (*pos == 0)
> +		znd->wp_proc_at = *pos;
> +	return &znd->wp_proc_at;
> +}

Hello Shaun,

Does this mean that you are not aware that it is considered unacceptable 
for new drivers to create procfs entries?

Bart.

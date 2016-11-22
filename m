From: Shaun Tancheff <shaun@tancheff.com>
Subject: Re: [PATCH] New device mapper target ZDM
Date: Tue, 22 Nov 2016 09:35:28 -0600
Message-ID: <CAJ48U8VwTCofzOC6n_RaG93WfxAxW2USy3dZ6w4Us_tx_Z3r1A@mail.gmail.com>
References: <20161121192311.14539-1-shaun@tancheff.com>
	<BLUPR02MB1683056A1D78B1A481A38CC181B40@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BLUPR02MB1683056A1D78B1A481A38CC181B40@BLUPR02MB1683.namprd02.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Vineet Agarwal <vineet.agarwal@seagate.com>, dm-devel <dm-devel@redhat.com>, Michael T Lombardi <michael.t.lombardi@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 22, 2016 at 9:08 AM, Bart Van Assche
<Bart.VanAssche@sandisk.com> wrote:
> On 11/21/16 11:23, Shaun Tancheff wrote:
>> +/* -------------------------------------------------------------------------- */
>> +/* --ProcFS Support Routines------------------------------------------------- */
>> +/* -------------------------------------------------------------------------- */
>> +
>> +#if defined(CONFIG_PROC_FS)
>> +
>> +/**
>> + * struct zone_info_entry - Proc zone entry.
>> + * @zone: Zone Index
>> + * @info: Info (WP/Used).
>> + */
>> +struct zone_info_entry {
>> +     u32 zone;
>> +     u32 info;
>> +};
>> +
>> +/**
>> + * Startup writing to our proc entry
>> + */
>> +static void *proc_wp_start(struct seq_file *seqf, loff_t *pos)
>> +{
>> +     struct zdm *znd = seqf->private;
>> +
>> +     if (*pos == 0)
>> +             znd->wp_proc_at = *pos;
>> +     return &znd->wp_proc_at;
>> +}
>
> Hello Shaun,
>
> Does this mean that you are not aware that it is considered unacceptable
> for new drivers to create procfs entries?

I understood that it was frowned on.

I can move all but the 'status' to debugfs and move 'status' to sysfs
and reformat
the output as appropriate.... would that suffice?

> Bart.

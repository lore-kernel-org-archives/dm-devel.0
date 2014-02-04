From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/7] dm mpath: remove process_queued_ios()
Date: Tue, 4 Feb 2014 08:55:44 +0000
Message-ID: <11AF7C027C4C02408624617A498607840105ED37@BPXM12GP.gisp.nec.co.jp>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
	<1391459326-21569-5-git-send-email-snitzer@redhat.com>
	<11AF7C027C4C02408624617A498607840105D5F0@BPXM12GP.gisp.nec.co.jp>
	<52F0A24F.6050408@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52F0A24F.6050408@suse.de>
Content-Language: ja-JP
Content-ID: <E7CCC31FCB939D4EA6627D17CEE24499@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 02/04/14 17:18, Hannes Reinecke wrote:
>>> @@ -1591,8 +1563,17 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
>> ...
>>> +		if (m->current_pg && m->pg_init_required)
>>> +			__pg_init_all_paths(m, 0);
>>> +		spin_unlock_irqrestore(&m->lock, flags);
>>> +		dm_table_run_md_queue_async(m->ti->table);
>>> +	}
>>
>> What happens if "!m->current_pg && m->pg_init_required"?
>>
>>From the current logic it means that no valid pg was found, so
> calling pg_init would be pointless.
> We're calling __choose_pgpath() before that, so if that returns
> with current_pg == NULL all paths are down, and calling
> pg_init would be pointless.
> 
> But I think I see to have pg_init_required handling cleared up;
> I'll be doing a patch to unset it at the start of __choose_pgpath(),
> this we we can be sure that it'll be set correctly.

I think it is possible that __choose_pgpath() being called twice
before pg_init_required is checked.

For example,

  multipath_ioctl()
    __choose_pgpath()
      clear pg_init_required
      select a new pg
      __switch_pg()
        set pg_init_required

  map_io()
    __choose_pgpath()
      clear pg_init_required
      select the same pg
      (pg_init_required is not set)
      ...

In this case, pg_init should be submitted to the pg but not.

-- 
Jun'ichi Nomura, NEC Corporation

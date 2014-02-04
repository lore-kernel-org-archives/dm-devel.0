From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/7] dm mpath: remove process_queued_ios()
Date: Tue, 4 Feb 2014 09:27:37 +0000
Message-ID: <11AF7C027C4C02408624617A498607840105EF58@BPXM12GP.gisp.nec.co.jp>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
	<1391459326-21569-5-git-send-email-snitzer@redhat.com>
	<11AF7C027C4C02408624617A498607840105D5F0@BPXM12GP.gisp.nec.co.jp>
	<52F0A24F.6050408@suse.de>
	<11AF7C027C4C02408624617A498607840105ED37@BPXM12GP.gisp.nec.co.jp>
	<52F0AE28.1070702@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52F0AE28.1070702@suse.de>
Content-Language: ja-JP
Content-ID: <7565223ADCD7BF49BCEAF31CDBB33A6A@gisp.nec.co.jp>
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

On 02/04/14 18:08, Hannes Reinecke wrote:
> On 02/04/2014 09:55 AM, Junichi Nomura wrote:
>> On 02/04/14 17:18, Hannes Reinecke wrote:
>>>>> @@ -1591,8 +1563,17 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
>>>> ...
>>>>> +		if (m->current_pg && m->pg_init_required)
>>>>> +			__pg_init_all_paths(m, 0);
>>>>> +		spin_unlock_irqrestore(&m->lock, flags);
>>>>> +		dm_table_run_md_queue_async(m->ti->table);
>>>>> +	}
>>>>
>>>> What happens if "!m->current_pg && m->pg_init_required"?
>>>>
>>> >From the current logic it means that no valid pg was found, so
>>> calling pg_init would be pointless.
>>> We're calling __choose_pgpath() before that, so if that returns
>>> with current_pg == NULL all paths are down, and calling
>>> pg_init would be pointless.
>>>
>>> But I think I see to have pg_init_required handling cleared up;
>>> I'll be doing a patch to unset it at the start of __choose_pgpath(),
>>> this we we can be sure that it'll be set correctly.
>>
>> I think it is possible that __choose_pgpath() being called twice
>> before pg_init_required is checked.
>>
>> For example,
>>
>>   multipath_ioctl()
>>     __choose_pgpath()
>>       clear pg_init_required
>>       select a new pg
>>       __switch_pg()
>>         set pg_init_required
>>
>>   map_io()
>>     __choose_pgpath()
>>       clear pg_init_required
>>       select the same pg
>>       (pg_init_required is not set)
>>       ...
>>
> But why should 'map_io' calling __choose_pgpath()?
> 
> Either __choose_path() from ioctl was able to set ->current_pg
> (in which case __choose_pgpath() wouldn't be called in map_io)
> or it was not, in which case pg_init_required would need to be reset
> during __choose_pgpath() when called from map_io().

__choose_pgpath() is a function to select "path".
Even if current_pg is set, map_io() may call the function
to select a path. (Please look at the repeat_count check)

So, I suggested the followings:
  Call __pg_init_all_paths() regardless of current_pg.
  __pg_init_all_paths() returns whether pg_init has started.
  If !current_pg, it returns 0.
  (https://www.redhat.com/archives/dm-devel/2014-February/msg00013.html)

The semantics is clear:
  - if pg_init_required, call __pg_init_all_paths()
  - __pg_init_all_paths() might fail to start pg_init (= returns 0).
    Then caller should take some action or give up.

-- 
Jun'ichi Nomura, NEC Corporation

From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 29 of 30] DM Snapshot:  utilize snapshare
Date: Mon, 23 Mar 2009 14:00:31 -0500
Message-ID: <DBCFDE1C-1945-4281-8F44-20BD8F94A9DD@redhat.com>
References: <200903192137.n2JLbUJm008496@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200903192137.n2JLbUJm008496@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Woops,

Do not use 'ss' after it has been used as a list iterator.  Besides,  
each snapshare needs to have its associated table notified of the event.

Will send replacement patch shortly.

Bug was caught by QA department's snapshot tests - specifically,  
overfilling the snapshot.

  brassow


On Mar 19, 2009, at 4:37 PM, Jonathan Brassow wrote:

> static void __invalidate_snapshot(struct dm_snapshot *s, int err)
> {
> +	struct dm_snapshare *ss;
> 	char *tmp_str = "ES_INVALIDATE";
>
> 	if (!s->valid)
> @@ -734,12 +823,15 @@ static void __invalidate_snapshot(struct
> 	else if (err == -ENOMEM)
> 		DMERR("Invalidating snapshot: Unable to allocate exception.");
>
> -	if (s->store->type->message)
> -		s->store->type->message(s->store, 1, &tmp_str);
> +
> +	/* Invalidating the snapshot will invalidate all snapshares. */
> +	list_for_each_entry(ss, &s->shared_list, shared_list)
> +		if (ss->store->type->message)
> +			ss->store->type->message(ss->store, 1, &tmp_str);
>
> 	s->valid = 0;
>
> -	dm_table_event(s->store->ti->table);
> +	dm_table_event(ss->store->ti->table);
> }

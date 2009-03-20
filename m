From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-snap-persistent-fix-dtr-cleanup.patch
Date: Fri, 20 Mar 2009 09:01:01 -0500
Message-ID: <7F767AC4-1874-4AA9-87E8-B842D97977A2@redhat.com>
References: <1236202436.28664.8.camel@hydrogen.msp.redhat.com>
	<20090319224231.GX3063@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090319224231.GX3063@agk.fab.redhat.com>
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
Cc: Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids


On Mar 19, 2009, at 5:42 PM, Alasdair G Kergon wrote:

> On Wed, Mar 04, 2009 at 03:33:56PM -0600, Jon Brassow wrote:
>> @@ -481,10 +484,17 @@ static void persistent_dtr(struct dm_exc
>> {
>> 	struct pstore *ps = get_info(store);
>>
>> -	destroy_workqueue(ps->metadata_wq);
>> -	dm_io_client_destroy(ps->io_client);
>> -	vfree(ps->callbacks);
>> +	/* Created in read_header */
>> +	if (ps->io_client)
>> +		dm_io_client_destroy(ps->io_client);
>> 	free_area(ps);
>> +
>> +	/* Allocated in persistent_read_metadata */
>> +	if (ps->callbacks)
>> +		vfree(ps->callbacks);
>> +
>> +	/* Don't need to check these, because they are done in ctr */
>> +	destroy_workqueue(ps->metadata_wq);
>> 	kfree(ps);
>> }
>
> I presume it's safe to reorder those operations as the workqueue is
> guaranteed to be empty?  It needs an inline comment though.
> (Or can we just keep the original, logical, order?)

The patch puts them in the order they /should/ have been in in the  
first place; that is, the reverse order in which they are created.   
The inline comments I put in state where/when those items are created,  
and hence why they need checks before being freed.  Perhaps you are  
suggesting the comments could be better. (?)

  brassow

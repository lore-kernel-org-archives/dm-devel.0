From: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Subject: Re: Calltrace in dm-snapshot in 2.6.27 kernel
Date: Wed, 26 Nov 2008 08:38:04 +0100
Message-ID: <492CFCDC.7050702@poczta.onet.pl>
References: <48FC23DE.5040000@poczta.onet.pl> <48FC4498.5070706@redhat.com>
	<48FD7911.1000705@poczta.onet.pl>
	<Pine.LNX.4.64.0810210953560.12983@hs20-bc2-1.build.redhat.com>
	<48FDFF53.5080007@poczta.onet.pl>
	<Pine.LNX.4.64.0810211319330.13319@hs20-bc2-1.build.redhat.com>
	<48FE22A0.30005@poczta.onet.pl>
	<Pine.LNX.4.64.0810211736230.24588@hs20-bc2-1.build.redhat.com>
	<48FF2C91.4080401@poczta.onet.pl>
	<Pine.LNX.4.64.0810221140440.28028@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0810221238030.3985@hs20-bc2-1.build.redhat.com>
	<4900603C.2090508@poczta.onet.pl>
	<Pine.LNX.4.64.0810230938280.3939@hs20-bc2-1.build.redhat.com>
	<4923CEF8.5060103@poczta.onet.pl>
	<Pine.LNX.4.64.0811240550530.8466@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0811240550530.8466@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi


Yes, I am sure that I used 2.6.27.6. I checked it again.

When I tested 2.6.27 without "dm snapshot: fix primary_pe race" I
brought to call trace after a few minutes but with use "dm snapshot: fix
primary_pe race" bring to call trace is very hard.Sometimes even after a
few days test. I don`t have reproducible scenario :(. I tested kernel
with use Bacula, Rsync, LVM, Snapshot together and very heavy load.It
happened only 2 times through four weeks test.How can I help in this
case? Thanks and best


Mikulas Patocka wrote:
> Hi
>
> This was supposed to be fixed with "dm snapshot: fix primary_pe race" 
> patch in 2.6.27.4. Are you sure that you really see it on 2.6.27.6? If so, 
> it looks like the bug wasn't fixed yet.
>
> How often does it happen? Do you have some reproducible scenario for this 
> bug?
>
> Mikulas
>
>   
>> Hi 
>>
>> I tested kernel 2.6.27.6 with patch from 2.6.28rc (wait for chunks in destructor,fix register_snapshot deadlock,) and I identified next problem with kernel and dm but repeatability this problem is very small.I got call trace:
>>
>>
>> Pid: 26230, comm: kcopyd Not tainted (2.6.27.6 #36)
>> EIP: 0060:[<c044d485>] EFLAGS: 00010282 CPU: 1
>> EIP is at remove_exception+0x5/0x20
>> EAX: ca3b5908 EBX: ca3b5908 ECX: 00200200 EDX: 00100100
>> ESI: f7b489f8 EDI: e92ad980 EBP: 00000000 ESP: f29c7ec0
>> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> Process kcopyd (pid: 26230, ti=f29c6000 task=e8512430 task.ti=f29c6000)
>> Stack: c044e03f 0000000d 00000000 c85948c0 00000000 c044f2e7 0009bc30
>> 00000000
>>       0000e705 00000000 e8e41288 e92ad980 00000000 c044e0f0 e8e41288
>> c7800ec8
>>       00000000 c0449224 00000000 c7800fb4 00000400 00000000 00000000
>> f2bdfbb0
>> Call Trace:
>> [<c044e03f>] pending_complete+0x9f/0x110
>> [<c044f2e7>] persistent_commit+0xc7/0x110
>> [<c044e0f0>] copy_callback+0x30/0x40
>> [<c0449224>] segment_complete+0x154/0x1d0
>> [<c0448e55>] run_complete_job+0x45/0x80
>> [<c04490d0>] segment_complete+0x0/0x1d0
>> [<c0448e10>] run_complete_job+0x0/0x80
>> [<c0449014>] process_jobs+0x14/0x70
>> [<c0449070>] do_work+0x0/0x40
>> [<c0449086>] do_work+0x16/0x40
>> [<c013502d>] run_workqueue+0x4d/0xf0
>> [<c013514d>] worker_thread+0x7d/0xc0
>> [<c01382e0>] autoremove_wake_function+0x0/0x30
>> [<c0526583>] __sched_text_start+0x1e3/0x4a0
>> [<c01382e0>] autoremove_wake_function+0x0/0x30
>> [<c0121a2b>] complete+0x2b/0x40
>> [<c01350d0>] worker_thread+0x0/0xc0
>> [<c0137db4>] kthread+0x44/0x70
>> [<c0137d70>] kthread+0x0/0x70
>> [<c0104c57>] kernel_thread_helper+0x7/0x10
>> =======================
>> Code: 4b 0c e8 cf ff ff ff 8b 56 08 8d 04 c2 8b 10 89 13 89 18 89 5a 04
>> 89 43 04 5b 5e c3 8d 76 00 8d bc 27 00 00 00 00 8b 48 04 8b 10 <89> 11
>> 89 4a 04 c7 00 00 01 10 00 c7 40 04 00 02 20 00 c3 90 8d
>> EIP: [<c044d485>] remove_exception+0x5/0x20 SS:ESP 0068:f29c7ec0
>> ---[ end trace 834a1d3742a1be05 ]---
>>
>>
>>
>> addr2line returned include/linux/list.h:93 for EIP c044d485:
>>
>>
>> static inline void __list_del(struct list_head * prev, struct list_head
>> * next)
>> {
>>         next->prev = prev;
>>         prev->next = next;      //line 93
>> }
>>
>>
>>
>>
>> A few weeks ago I got similar call trace with plain kernel 2.6.27 and
>> patches from mail thread:
>>
>>
>> BUG: unable to handle kernel paging request at 00200200
>> IP: [<c044bf65>] remove_exception+0x5/0x20
>> *pdpt = 0000000029acc001 *pde = 0000000000000000
>> Oops: 0002 [#1] SMP
>> Modules linked in: iscsi_trgt mptctl mptbase st sg drbd bonding
>> iscsi_tcp libiscsi scsi_transport_iscsi aacraid sata_nv forcedeth button
>> ftdi_sio usbserial
>>
>> Pid: 31375, comm: kcopyd Not tainted (2.6.27 #21)
>> EIP: 0060:[<c044bf65>] EFLAGS: 00010282 CPU: 1
>> EIP is at remove_exception+0x5/0x20
>> EAX: f276da88 EBX: f276da88 ECX: 00200200 EDX: 00100100
>> ESI: c79a4a58 EDI: c9268cc0 EBP: 00000000 ESP: ecbcbec0
>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> Process kcopyd (pid: 31375, ti=ecbca000 task=e6d9d220 task.ti=ecbca000)
>> Stack: c044cb1f 0000000e 00000000 c916b480 00000000 c044dde3 00018f47
>> 00000000
>>        00002870 00000000 c70cba48 c9268cc0 00000000 c044cbd0 c70cba48
>> c720aec8
>>        00000000 c0447d04 00000000 c720afb4 00000400 00000000 00000000
>> efc65580
>> Call Trace:
>>  [<c044cb1f>] pending_complete+0x9f/0x110
>>  [<c044dde3>] persistent_commit+0xe3/0x110
>>  [<c044cbd0>] copy_callback+0x30/0x40
>>  [<c0447d04>] segment_complete+0x154/0x1d0
>>  [<c0447935>] run_complete_job+0x45/0x80
>>  [<c0447bb0>] segment_complete+0x0/0x1d0
>>  [<c04478f0>] run_complete_job+0x0/0x80
>>  [<c0447af4>] process_jobs+0x14/0x70
>>  [<c0447b50>] do_work+0x0/0x40
>>  [<c0447b66>] do_work+0x16/0x40
>>  [<c013509d>] run_workqueue+0x4d/0xf0
>>  [<c01351bd>] worker_thread+0x7d/0xc0
>>  [<c0138350>] autoremove_wake_function+0x0/0x30
>>  [<c0524f2c>] __sched_text_start+0x1ec/0x4b0
>>  [<c0138350>] autoremove_wake_function+0x0/0x30
>>  [<c0121a9b>] complete+0x2b/0x40
>>  [<c0135140>] worker_thread+0x0/0xc0
>>  [<c0137e24>] kthread+0x44/0x70
>>  [<c0137de0>] kthread+0x0/0x70
>>  [<c0104c57>] kernel_thread_helper+0x7/0x10
>>  =======================
>> Code: 4b 0c e8 cf ff ff ff 8b 56 08 8d 04 c2 8b 10 89 13 89 18 89 5a 04
>> 89 43 04 5b 5e c3 8d 76 00 8d bc 27 00 00 00 00 8b 48 04 8b 10 <89> 11
>> 89 4a 04 c7 00 00 01 10 00 c7 40 04 00 02 20 00 c3 90 8d
>> EIP: [<c044bf65>] remove_exception+0x5/0x20 SS:ESP 0068:ecbcbec0
>> ---[ end trace 25afcedfe7eb0a2b ]---
>>
>> Is this known problem or something new? Thanks
>>
>>
>> Mikulas Patocka wrote:
>>     
>>> On Thu, 23 Oct 2008, aluno3@poczta.onet.pl wrote:
>>>
>>>   
>>>       
>>>> I used dm-snapshot-fix-primary-pe-race.patch and last patch related with
>>>> pending_exception.After the same test and workload everything work
>>>> correctly so far.Is it final patch?
>>>>     
>>>>         
>>> Yes, these two patches are expected to be the final fix. Thanks for the 
>>> testing. If you get some more crashes even with these two, write about 
>>> them.
>>>
>>> Mikulas
>>>
>>>   
>>>       
>>>> best and thanks
>>>>
>>>>
>>>> Mikulas Patocka wrote:
>>>>     
>>>>         
>>>>> Oh, sorry for this "struct struct" in the patch in free_pending_exception, 
>>>>> replace it just with one "struct". I forgot to refresh the patch before 
>>>>> sending it.
>>>>>
>>>>> Mikulas
>>>>>
>>>>> On Wed, 22 Oct 2008, Mikulas Patocka wrote:
>>>>>
>>>>>   
>>>>>       
>>>>>           
>>>>>> On Wed, 22 Oct 2008, aluno3@poczta.onet.pl wrote:
>>>>>>
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>>> Hi
>>>>>>>
>>>>>>> I used your patch and I ran test the same workload. After a few hours
>>>>>>> test, everything is OK. Is it possible? Test is still running.When I get
>>>>>>> something wrong from kernel I write to You again.
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>> Hi
>>>>>>
>>>>>> That's good that it works. So try this. Keep the first patch (it is this 
>>>>>> one --- 
>>>>>> http://people.redhat.com/mpatocka/patches/kernel/2.6.27/dm-snapshot-fix-primary-pe-race.patch 
>>>>>> --- I think Milan already sent it to you and you have it applied). Undo 
>>>>>> the second patch (that one that hides deallocation with /* */ ). And apply 
>>>>>> this. Run the same test.
>>>>>>
>>>>>> Mikulas
>>>>>>
>>>>>> ---
>>>>>>  drivers/md/dm-snap.c |   10 +++++++++-
>>>>>>  drivers/md/dm-snap.h |    2 ++
>>>>>>  2 files changed, 11 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> Index: linux-2.6.27-clean/drivers/md/dm-snap.c
>>>>>> ===================================================================
>>>>>> --- linux-2.6.27-clean.orig/drivers/md/dm-snap.c	2008-10-22 15:41:24.000000000 +0200
>>>>>> +++ linux-2.6.27-clean/drivers/md/dm-snap.c	2008-10-22 15:51:33.000000000 +0200
>>>>>> @@ -368,6 +368,7 @@ static struct dm_snap_pending_exception 
>>>>>>  	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
>>>>>>  							     GFP_NOIO);
>>>>>>  
>>>>>> +	atomic_inc(&s->n_pending_exceptions);
>>>>>>  	pe->snap = s;
>>>>>>  
>>>>>>  	return pe;
>>>>>> @@ -375,7 +376,10 @@ static struct dm_snap_pending_exception 
>>>>>>  
>>>>>>  static void free_pending_exception(struct dm_snap_pending_exception *pe)
>>>>>>  {
>>>>>> -	mempool_free(pe, pe->snap->pending_pool);
>>>>>> +	struct struct dm_snapshot *s = pe->snap;
>>>>>> +	mempool_free(pe, s->pending_pool);
>>>>>> +	smp_mb__before_atomic_dec();
>>>>>> +	atomic_dec(&s->n_pending_exceptions);
>>>>>>  }
>>>>>>  
>>>>>>  static void insert_completed_exception(struct dm_snapshot *s,
>>>>>> @@ -601,6 +605,7 @@ static int snapshot_ctr(struct dm_target
>>>>>>  	s->valid = 1;
>>>>>>  	s->active = 0;
>>>>>>  	s->last_percent = 0;
>>>>>> +	atomic_set(&s->n_pending_exceptions, 0);
>>>>>>  	init_rwsem(&s->lock);
>>>>>>  	spin_lock_init(&s->pe_lock);
>>>>>>  	s->ti = ti;
>>>>>> @@ -727,6 +732,9 @@ static void snapshot_dtr(struct dm_targe
>>>>>>  	/* After this returns there can be no new kcopyd jobs. */
>>>>>>  	unregister_snapshot(s);
>>>>>>  
>>>>>> +	while (atomic_read(&s->n_pending_exceptions))
>>>>>> +		yield();
>>>>>> +
>>>>>>  #ifdef CONFIG_DM_DEBUG
>>>>>>  	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
>>>>>>  		BUG_ON(!hlist_empty(&s->tracked_chunk_hash[i]));
>>>>>> Index: linux-2.6.27-clean/drivers/md/dm-snap.h
>>>>>> ===================================================================
>>>>>> --- linux-2.6.27-clean.orig/drivers/md/dm-snap.h	2008-10-22 15:45:08.000000000 +0200
>>>>>> +++ linux-2.6.27-clean/drivers/md/dm-snap.h	2008-10-22 15:46:49.000000000 +0200
>>>>>> @@ -163,6 +163,8 @@ struct dm_snapshot {
>>>>>>  
>>>>>>  	mempool_t *pending_pool;
>>>>>>  
>>>>>> +	atomic_t n_pending_exceptions;
>>>>>> +
>>>>>>  	struct exception_table pending;
>>>>>>  	struct exception_table complete;
>>>>>>  
>>>>>>
>>>>>> --
>>>>>> dm-devel mailing list
>>>>>> dm-devel@redhat.com
>>>>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>>>>
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>   
>>>>>       
>>>>>           
>>>   
>>>       
>
>   

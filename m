From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 1/2] dm-snapshot: fix crash with the realtime kernel
Date: Tue, 12 Nov 2019 13:45:37 +0200
Message-ID: <a6f588d3-2403-d50a-70a1-ed644082cc83@arrikto.com>
References: <alpine.LRH.2.02.1911110811060.28408@file01.intranet.prod.int.rdu2.redhat.com>
 <c9a772e9-e305-cf0b-1155-fb19bdb84e55@arrikto.com>
 <20191112011444.GA32220@redhat.com>
 <alpine.LRH.2.02.1911120240020.25757@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1911120240020.25757@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On 11/12/19 9:50 AM, Mikulas Patocka wrote:
> 
> 
> On Mon, 11 Nov 2019, Mike Snitzer wrote:
> 
>> On Mon, Nov 11 2019 at 11:37am -0500,
>> Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>
>>> On 11/11/19 3:59 PM, Mikulas Patocka wrote:
>>>> Snapshot doesn't work with realtime kernels since the commit f79ae415b64c.
>>>> hlist_bl is implemented as a raw spinlock and the code takes two non-raw
>>>> spinlocks while holding hlist_bl (non-raw spinlocks are blocking mutexes
>>>> in the realtime kernel, so they couldn't be taken inside a raw spinlock).
>>>>
>>>> This patch fixes the problem by using non-raw spinlock
>>>> exception_table_lock instead of the hlist_bl lock.
>>>>
>>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>> Fixes: f79ae415b64c ("dm snapshot: Make exception tables scalable")
>>>>
>>>
>>> Hi Mikulas,
>>>
>>> I wasn't aware that hlist_bl is implemented as a raw spinlock in the
>>> real time kernel. I would expect it to be a standard non-raw spinlock,
>>> so everything works as expected. But, after digging further in the real
>>> time tree, I found commit ad7675b15fd87f1 ("list_bl: Make list head
>>> locking RT safe") which suggests that such a conversion would break
>>> other parts of the kernel.
>>
>> Right, the proper fix is to update list_bl to work on realtime (which I
>> assume the referenced commit does).  I do not want to take this
>> dm-snapshot specific workaround that open-codes what should be done
>> within hlist_{bl_lock,unlock}, etc.
> 
> If we change list_bl to use non-raw spinlock, it fails in dentry lookup 
> code. The dentry code takes a seqlock (which is implemented as preempt 
> disable in the realtime kernel) and then takes a list_bl lock.
> 
> This is wrong from the real-time perspective (the chain in the hash could 
> be arbitrarily long, so using non-raw spinlock could cause unbounded 
> wait), however we can't do anything with it.
> 
> I think that fixing dm-snapshot is way easier than fixing the dentry code. 
> If you have an idea how to fix the dentry code, tell us.
> 

I too think that it would be better to fix list_bl. dm-snapshot isn't
really broken. One should be able to acquire a spinlock while holding
another spinlock.

Moreover, apart from dm-snapshot, anyone ever using list_bl is at risk
of breaking the realtime kernel, if he or she is not aware of that
particular limitation of list_bl's implementation in the realtime tree.

But, I agree that it's a lot easier "fixing" dm-snapshot than fixing the
dentry code.

>> I'm not yet sure which realtime mailing list and/or maintainers should
>> be cc'd to further the inclussion of commit ad7675b15fd87f1 -- Nikos do
>> you?

No, unfortunately, I don't know for sure either. [1] and [2] suggest
that the relevant mailing lists are LKML and linux-rt-users and the
maintainers are Sebastian Siewior, Thomas Gleixner and Steven Rostedt.

I believe they are already Cc'd in the other thread regarding Mikulas'
"realtime: avoid BUG when the list is not locked" patch (for some reason
the thread doesn't properly appear in dm-devel archives and also my
mails to dm-devel have being failing since yesterday - Could there be an
issue with the mailing list?), so maybe we should Cc them in this thread
too.

Nikos

[1] https://wiki.linuxfoundation.org/realtime/communication/mailinglists
[2] https://wiki.linuxfoundation.org/realtime/communication/send_rt_patches

>>
>> Thanks,
>> Mike
> 
> Mikulas
> 

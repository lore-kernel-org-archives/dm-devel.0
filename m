From: Busby <chaimvy@gmail.com>
Subject: Re: Does dm-thin support GC (garbage collection) ?
Date: Tue, 8 May 2012 15:21:31 +0800
Message-ID: <CAJv3x-U1VRyq1m6oJQ0X8nn4WSiAzVnqm7CLuPGj-xmDh8c1AQ@mail.gmail.com>
References: <CAJv3x-Xk-aODfJtqCEBKPM1jkwXEFVN40EEu_hnnDZB9o4dBWw@mail.gmail.com>
	<20120507132242.GA27715@redhat.com>
	<CAJv3x-USC=8z7Kz_-p8uOiQkdE21Oe0isMeDOBKRc4semHbLCA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJv3x-USC=8z7Kz_-p8uOiQkdE21Oe0isMeDOBKRc4semHbLCA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

   I have tested that the blocks were reused in the other thin-lun of
this pool  when deleted a thin-lun .
   How can the blocks allocated for the thin-lun be dynamically
reclaimed? (use some method like 'discard' to tell the pool which
block should be reclaimed and whether the pool can reclaim it ?).
   When I mounted a filesystem on a thin-lun, create 4G bytes file
firstly, the pool have decreased  4G space, then I deleted the file,
the pool did not increase the size as I thought, after this, create a
5G file, then the pool would decrease 1G size. So I think if the
thin-lun max size was allocated, the blocks will never be reclaimed
till the lun be deleted?
    Sorry for my ignorance.

Regards,
Busby



2012/5/8, Busby <chaimvy@gmail.com>:
> Hi Mike,
>             Thank you for your reply. Does the thin pool can reuse the
> blocks that the thin-lun freed( like ssd 's discard/trim , the lun
> will discard the blocks to the pool ). As the filesystem  creates a
> file (3 G bytes big, etc.) will cause the block allocation of the thin
> pool (thin lun), if delete the file, will the space(the blocks,3 G
> bytes ,etc. ) dynamically be reused now (as we think thin-lun knows
> the blocks delete by the FS )? or have to delete the thin-lun then the
> space will be reused (just thin provision only once, not support block
> reclamation from thin-lun to pool while lun is using )? I want to know
> something about the 'block (page) reclamation' before my test :)
>            Thanks.
>
> Regards,
> Busby
>
>
> 2012/5/7, Mike Snitzer <snitzer@redhat.com>:
>> On Mon, May 07 2012 at  3:28am -0400,
>> Busby <chaimvy@gmail.com> wrote:
>>
>>> Hi All,
>>>          The dm-thin supports 'discard' now?Can I think this function
>>> likes SSD's 'TRIM'? If it just discard the block mapped but not
>>> remap(reallocate), the Pool's space will soon be used up . I want to
>>> know whether it supports block reuse ( can use ext4 with '--discard'
>>> test this? ) now or in the future.
>>
>> thinp discard support was added during upstream's most recent 3.4 merge
>> window.  See:
>> http://git.kernel.org/linus/104655fd4dcebd500
>> http://git.kernel.org/linus/67e2e2b281812b5ca
>>
>> As you can see in the commit header for this last commit, you have
>> control over how the discard (as issued by ext4, etc) is handled by
>> thinp.  It should be noted that if the underlying storage does not
>> support discard then the thin-pool will default to no_discard_passdown
>> -- otherwise it does default to passing discards down to the underlying
>> storage.
>>
>> But you'll need 2 late fixes for thinp issues that have been found
>> during the 3.4-rcX development (these will be sent upstream shortly):
>> http://www.redhat.com/archives/dm-devel/2012-April/msg00027.html
>> http://www.redhat.com/archives/dm-devel/2012-April/msg00071.html
>>
>> (I'll bounce both of these patches to your email so you have them,
>> please apply them before building/testing the latest 3.4-rcX kernel).
>>
>> Regards,
>> Mike
>>
>

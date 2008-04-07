From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Mon, 7 Apr 2008 19:38:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0804071932340.3742@porkchop.devel.redhat.com>
References: <47DEC402.10309@redhat.com>
	<Pine.LNX.4.64.0803171611430.31803@porkchop.devel.redhat.com>
	<20080317215631.GG29322@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181921380.10939@porkchop.devel.redhat.com>
	<20080318233955.GA12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
	<20080403091936.GA9901@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080403091936.GA9901@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mauelshagen@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 3 Apr 2008, Heinz Mauelshagen wrote:

>
> See below [HM].
>
> On Wed, Apr 02, 2008 at 04:23:41PM -0400, Mikulas Patocka wrote:
>> Hi
>>
>> Unfortunatelly, the bug with desychnronizing raid1 that someone pointed out
>> on Monday, is real. The bug happens when you modify the page while its
>> being written to raid1 device --- old version can be written to one mirror
>> leg, the new versions to the other mirror leg. Raid1 code does not notice
>> this, marks the region clean after the writes finish, and the volume stays
>> desynchronized.
>>
>> The possibilities, how data can be modified while they are being written.
>>
>> 1. an application does O_DIRECT IO and modifies the memory underway.
>>
>> --- this is a problem of the application and we don't have to care about
>> it.
>>
>> 2. an application maps file for writing. pdflush or kswapd daemon writes
>> the page on background while the application is modifying it.
>>
>> 3. an application writes to a page with write() syscall. This syscall can
>> race with pdflush or kswapd as well.
>>
>> 4. a filesystem modifies the buffer while its being written by pdflush or
>> kswapd daemons.
>>
>>
>> The pdflush and kswapd daemons run in background and do periodic writes of
>> the modified data. pdflush is triggered regularly and writes data in
>> specified interval (about 30 seconds), so that in case of crash, the image
>> on disk is not too old. kswapd is triggered when the free memory goes low
>> --- it writes file pages and filesystem buffers too.
>>
>> In cases 2,3,4 the data may be modified while they are being written, but
>> the kernel writes them later again. The sequence is something like:
>> clear dirty bit
>> submit IO
>> --- if the data are modified while the IO is in progress, the dirty bit is
>> turned on again and the data will be written later and possible data
>> corruption is corrected. --- so as long as the system does not crash, there
>> can't be desynchronized mirror.
>>
>> But if the system crashes before the data are written second time, the
>> blocks may stay desynchronized.
>>
>> An example of data corruption on ext2:
>>
>> We have a dirty bitmap buffer
>> Pdflush clears the dirty flag and starts writing the buffer
>> The write is submitted to dm-raid1, it makes two requests and submits them
>> to two mirror devices
>>
>> This operation races with another thread allocating a block on ext2 and
>> doing:
>
> [HM] And taking out a copy unlocked in the RAID driver ain't help
> application data integrity, because it could still change the data while
> the RAID driver is copying, hence leading to coherency on the
> RAID set but holding incorrect application data.
> One can argue that this is ok in case of a crash, because the application
> failed to flush any page changes

The application has no way of knowing that it's data is being written. you 
call write(); fsync(); --- and if write() races with pdflush, the data may 
be very well written on that write() call. You, as an application 
developer, never know. You can only be sure that the data is certainly 
written when fsync() returns. But it may be written earlier.

> and hence has to be capable to recover from this.

Applications (such as databases) well recover from the situation that the 
data were written or from the situation that the data were not written.

But they don't recover from the situation when read() to the same data 
after a crash returns randomly old data on new data (depending on which 
mirror leg was selected for read).

> We always will end up with consistent mirrors (either on multiplicated
> successful writes to all legs or after resynchronization of the mirror)
> at the cost of internal caching of pages.

The problem is that we turn off the dirty bit after we finish write to 
both legs and never resync this region after a crash.

Mikulas

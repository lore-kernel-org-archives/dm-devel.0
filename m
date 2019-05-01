From: "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Subject: Re: [RFC] [PATCH V2 0/1] Introduce emergency raid0 stop
 for mounted arrays
Date: Wed, 1 May 2019 15:00:27 -0300
Message-ID: <2823f928-d0b6-9049-73ab-b2ce0ef5da83@gpiccoli.net>
References: <20190418220448.7219-1-gpiccoli@canonical.com>
	<CAPhsuW4k5zz2pJBPL60VzjTcj6NTnhBh-RjvWASLcOxAk+yDEw@mail.gmail.com>
	<b39b96ea-2540-a407-2232-1af91e3e6658@canonical.com>
	<CAPhsuW65EW8JgjE8zknPQPXYcmDhX9LEhTKGb0KHywqKuZkUcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPhsuW65EW8JgjE8zknPQPXYcmDhX9LEhTKGb0KHywqKuZkUcA@mail.gmail.com>
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
To: Song Liu <liu.song.a23@gmail.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, kernel@gpiccoli.net, "Guilherme G. Piccoli" <gpiccoli@canonical.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Jay Vosburgh <jay.vosburgh@canonical.com>, gavin.guo@canonical.com
List-Id: dm-devel.ids

 > On 5/1/19 12:33 PM, Song Liu wrote:
>> [...]
>> Indeed, fsync returns -1 in this case.
>> Interestingly, when I do a "dd if=<some_file> of=<raid0_mount>" and try
>> to "sync -f <some_file>" and "sync", it succeeds and the file is
>> written, although corrupted.
> 
> I guess this is some issue with sync command, but I haven't got time
> to look into it. How about running dd with oflag=sync or oflag=direct?
> 

Hi Song, could be some problem with sync command; using either 
'oflag=direct' or 'oflag=sync' fails the dd command instantly when a 
member is removed.


>> Do you think this behavior is correct? In other devices, like a pure
>> SCSI disk or NVMe, the 'dd' write fails.
>> Also, what about the status of the raid0 array in mdadm - it shows as
>> "clean" even after the member is removed, should we change that?
> 
> I guess this is because the kernel hasn't detect the array is gone? In
> that case, I think reducing the latency would be useful for some use
> cases.
> 

Exactly! This is the main concern here, mdadm cannot stop the array 
since it's mounted, and there's no filesystem API to quickly shutdown 
the filesystem, hence it keeps "alive" for too long after the failure.

For instance, if we have a raid0 with 2 members and remove the 1st, it 
fails much quicker than if we remove the 2nd; the filesystem will 
"realize" the device is flaw quickly if we remove the 1st member, and 
goes to RO mode. Specially, xfs seems even faster than ext4 in noticing 
the failure.

Do you have any suggestion on how could we reduce this latency? And how 
about the status exhibited by mdadm, shall it move from 'clean' to 
something more meaningful in the failure case?

Thanks again,


Guilherme

> Thanks,
> Song
> 
>>
>>
>>> Also, could you please highlight changes from V1 (if more than
>>> just rebase)?
>>
>> No changes other than rebase. Worth mentioning here that a kernel bot
>> (and Julia Lawall) found an issue in my patch; I forgot a
>> "mutex_lock(&mddev->open_mutex);" in line 6053, which caused the first
>> caveat (hung mdadm and persistent device in /dev). Thanks for pointing
>> this silly mistake from me! in case this patch gets some traction, I'll
>> re-submit with that fixed.
>>
>> Cheers,
>>
>>
>> Guilherme
>>
>> [0] https://marc.info/?l=linux-block&m=155666385707413
>>
>>>
>>> Thanks,
>>> Song
>>>

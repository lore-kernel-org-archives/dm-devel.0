From: Markus Hentsch <markus.hentsch@cloudandheat.com>
Subject: Re: dm-era: metadata reuse after reboot possible?
Date: Thu, 20 Apr 2017 13:55:35 +0200
Message-ID: <0597d116-14b5-a326-a962-8047a9d7eff7@cloudandheat.com>
References: <c06844f1-bed2-7de3-5338-67f6a9d84f5a@cloudandheat.com>
	<20161031113749.GA27906@roamer.bos.redhat.com>
	<8f623e41-9a70-9b09-41c0-de9f6e590fee@cloudandheat.com>
	<a6f20994-56f4-2169-61d5-f2c3c748cd0e@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a6f20994-56f4-2169-61d5-f2c3c748cd0e@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

Dear Somu,

thanks for your quick response!

I applied your patch to the 4.4 kernel of a Ubuntu 16.04.2 VM and can
now confirm that the dm-era metadata survived every subsequent reboot so
far. Thank you!


Best regards,

Markus Hentsch
Cloud&Heat Technologies


On Apr 19, 2017 at 18:18 Somasundaram Krishnasamy wrote:
> I have sent a patch recently for review.
>
> https://www.redhat.com/archives/dm-devel/2017-April/msg00138.html
>
> It should fix this issue.
>
> Regards,
> Somu.
>
> On 4/19/2017 6:32 AM, Markus Hentsch wrote:
>> Hello, it's been a while. I've also been busy with other stuff in the
>> last months but now I'm back stuck at this issue. Has there been any
>> progress on this?
>>
>> On Mo, Oct 31, 2016 at 12:37, Edward Thornber wrote:
>>> On Fri, Oct 21, 2016 at 11:29:26AM +0200, Markus Hentsch wrote:
>>>> Hello,
>>>>
>>>> is it possible for the dm-era metadata to survive reboots?
>>> No, you certainly should be able to continue using the metadata.  I
>>> don't have time to look at this for the next couple of weeks, but
>>> after that will definitely fix.
>>>
>>> - Joe
>>
>> For reference, my original message from Fri, Oct 21, 2016 was:
>>> Hello,
>>>
>>> is it possible for the dm-era metadata to survive reboots?
>>>
>>> The official dm-era documentation states under "Resilience":
>>>
>>>     Metadata is updated on disk before a write to a previously
>>> unwritten
>>>     block is performed.  As such dm-era should not be effected by a
>>> hard
>>>     crash such as power failure.
>>>
>>> That's why I initially assumed that I may continue (re)using the
>>> metadata after reboots without wiping it (i.e. resetting the eras
>>> and block tracking). But is that actually the case?
>>>
>>>
>>> Using a Ubuntu trusty x64 VM with 2 additional virtual HDDs (sdb and
>>> sdc, 256MB each), I set up dm-era after bootup like this:
>>>
>>>     root@alice:~# dmsetup create era-meta --table "0 256 linear
>>> /dev/sdb 0"
>>>     root@alice:~# dmsetup create era --table "0 524288 era
>>> /dev/mapper/era-meta /dev/sdc 4096"
>>>     root@alice:~# dmsetup create era-access --table "0 256 linear
>>> /dev/mapper/era-meta 0"
>>>
>>>
>>> When I reboot and repeat the commands above, the layout is recreated
>>> correctly (according to lsblk). However, taking a metadata snapshot
>>> and trying to access the metadata using era_dump or
>>> era_invalidate fails, e.g.:
>>>
>>>     root@alice:~# dmsetup message era 0 take_metadata_snap
>>>     root@alice:~# era_dump /dev/mapper/era-access
>>>     <superblock uuid="" block_size="4096" nr_blocks="128"
>>> current_era="3">
>>>     metadata contains errors (run era_check for details).
>>>     perhaps you wanted to run with --repair ?
>>>
>>>     root@alice:~# era_check /dev/mapper/era-access
>>>     examining superblock
>>>     missing eras from writeset tree
>>>       value size mismatch: expected 12, but got 8.  This is not the
>>> btree you are looking for.
>>>
>>>     era_check: /usr/include/boost/optional/optional.hpp:1004:
>>> boost::optional<T>::reference_const_type
>>>       boost::optional<T>::get() const [with T = unsigned int;
>>> boost::optional<T>::reference_const_type =
>>>       const unsigned int&]: Assertion `this->is_initialized()' failed.
>>>     Aborted
>>>
>>>
>>> It doesn't matter if I take and drop any metadata snapshots or write
>>> to the era device before the reboot or not.
>>> Do I have to start over and wipe the metadata device directly after
>>> reboot or is there some way to continue using it, i.e. recovering
>>> its state when recreating the previous dmsetup layout?
>>
>> Best regards,
>>
>> Markus Hentsch
>> Cloud&Heat Technologies
>>
>>
>> -- 
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

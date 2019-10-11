From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: Fix "dm kcopyd: Fix bug causing workqueue stalls"
 causes dead lock
Date: Fri, 11 Oct 2019 14:39:01 +0300
Message-ID: <b8246b84-957d-1903-4ab0-3f4b940b779d@arrikto.com>
References: <CAHSpA58dehDfou0ogCYnkziBt4oU5yo1SGHLhJb7vFKy9HhJPQ@mail.gmail.com>
	<db9a2b56-244b-1285-208c-14944f559f36@arrikto.com>
	<CAHSpA58H_Vuhub6Eqqmi2QZ2g4AAUX8KCCUMzMvyc87hDaVDKg@mail.gmail.com>
	<1b2b06a1-0b68-c265-e211-48273f26efaf@arrikto.com>
	<CAHSpA59rG7qhEDjtUUTNv5evyWHS_iTL0o8utRCr9MQvMDsEgw@mail.gmail.com>
	<e15bb4d9-d19b-f954-f71d-2985dd6e455a@arrikto.com>
	<20191009141308.GA1670@redhat.com>
	<d6aaebd8-ed3e-2e6a-14ea-33bf023ee4bb@arrikto.com>
	<20191009160446.GA2284@redhat.com>
	<CAHSpA59T+JCR+_3ZCYShXa6GtQddAcaQE0OP5GWbSEG0qMAQOg@mail.gmail.com>
	<CAHSpA5_miJX74Th-_hinLr_q-sVR2G3M-_aS2c2fJBSr1eDnfg@mail.gmail.com>
	<ecf3c2cc-a0c0-ec34-7a74-8d715f774df9@arrikto.com>
	<CAHSpA5-wbyaNmnOMq+rTbuXh2eJ6y=iVjVR52OvmWLbLnUkTAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAHSpA5-wbyaNmnOMq+rTbuXh2eJ6y=iVjVR52OvmWLbLnUkTAw@mail.gmail.com>
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
To: Guruswamy Basavaiah <guru2018@gmail.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, iliastsi@arrikto.com
List-Id: dm-devel.ids

On 10/11/19 1:17 PM, Guruswamy Basavaiah wrote:
> Hello Nikos,
>  Applied these patches and tested.
>  We still see hung_task_timeout back traces and the drbd Resync is blocked.
>  Attached the back trace, please let me know if you need any other information.
> 

Hi Guru,

Can you provide more information about your setup? The output of
'dmsetup table', 'dmsetup ls --tree' and the DRBD configuration would
help to get a better picture of your I/O stack.

Also, is it possible to describe the test case you are running and
exactly what it does?

Thanks,
Nikos

>  In patch "0002-dm-snapshot-rework-COW-throttling-to-fix-deadlock.patch"
> I change "struct wait_queue_head" to "wait_queue_head_t" as i was
> getting compilation error with former one.
> 
> On Thu, 10 Oct 2019 at 17:33, Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>
>> On 10/10/19 9:34 AM, Guruswamy Basavaiah wrote:
>>> Hello,
>>> We use 4.4.184 in our builds and the patch fails to apply.
>>> Is it possible to give a patch for 4.4.x branch ?
>> Hi Guru,
>>
>> I attach the two patches fixing the deadlock rebased on the 4.4.x branch.
>>
>> Nikos
>>
>>>
>>> patching Logs.
>>> patching file drivers/md/dm-snap.c
>>> Hunk #1 succeeded at 19 (offset 1 line).
>>> Hunk #2 succeeded at 105 (offset -1 lines).
>>> Hunk #3 succeeded at 157 (offset -4 lines).
>>> Hunk #4 succeeded at 1206 (offset -120 lines).
>>> Hunk #5 FAILED at 1508.
>>> Hunk #6 succeeded at 1412 (offset -124 lines).
>>> Hunk #7 succeeded at 1425 (offset -124 lines).
>>> Hunk #8 FAILED at 1925.
>>> Hunk #9 succeeded at 1866 with fuzz 2 (offset -255 lines).
>>> Hunk #10 succeeded at 2202 (offset -294 lines).
>>> Hunk #11 succeeded at 2332 (offset -294 lines).
>>> 2 out of 11 hunks FAILED -- saving rejects to file drivers/md/dm-snap.c.rej
>>>
>>> Guru
>>>
>>> On Thu, 10 Oct 2019 at 01:33, Guruswamy Basavaiah <guru2018@gmail.com> wrote:
>>>>
>>>> Hello Mike,
>>>>  I will get the testing result before end of Thursday.
>>>> Guru
>>>>
>>>> On Wed, 9 Oct 2019 at 21:34, Mike Snitzer <snitzer@redhat.com> wrote:
>>>>>
>>>>> On Wed, Oct 09 2019 at 11:44am -0400,
>>>>> Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>>>>
>>>>>> On 10/9/19 5:13 PM, Mike Snitzer wrote:> On Tue, Oct 01 2019 at  8:43am -0400,
>>>>>>> Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>>>>>>
>>>>>>>> On 10/1/19 3:27 PM, Guruswamy Basavaiah wrote:
>>>>>>>>> Hello Nikos,
>>>>>>>>>  Yes, issue is consistently reproducible with us, in a particular
>>>>>>>>> set-up and test case.
>>>>>>>>>  I will get the access to set-up next week, will try to test and let
>>>>>>>>> you know the results before end of next week.
>>>>>>>>>
>>>>>>>>
>>>>>>>> That sounds great!
>>>>>>>>
>>>>>>>> Thanks a lot,
>>>>>>>> Nikos
>>>>>>>
>>>>>>> Hi Guru,
>>>>>>>
>>>>>>> Any chance you could try this fix that I've staged to send to Linus?
>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=633b1613b2a49304743c18314bb6e6465c21fd8a
>>>>>>>
>>>>>>> Shiort of that, Nikos: do you happen to have a test scenario that teases
>>>>>>> out this deadlock?
>>>>>>>
>>>>>>
>>>>>> Hi Mike,
>>>>>>
>>>>>> Yes,
>>>>>>
>>>>>> I created a 50G LV and took a snapshot of the same size:
>>>>>>
>>>>>>   lvcreate -n data-lv -L50G testvg
>>>>>>   lvcreate -n snap-lv -L50G -s testvg/data-lv
>>>>>>
>>>>>> Then I ran the following fio job:
>>>>>>
>>>>>> [global]
>>>>>> randrepeat=1
>>>>>> ioengine=libaio
>>>>>> bs=1M
>>>>>> size=6G
>>>>>> offset_increment=6G
>>>>>> numjobs=8
>>>>>> direct=1
>>>>>> iodepth=32
>>>>>> group_reporting
>>>>>> filename=/dev/testvg/data-lv
>>>>>>
>>>>>> [test]
>>>>>> rw=write
>>>>>> timeout=180
>>>>>>
>>>>>> , concurrently with the following script:
>>>>>>
>>>>>> lvcreate -n dummy-lv -L1G testvg
>>>>>>
>>>>>> while true
>>>>>> do
>>>>>>  lvcreate -n dummy-snap -L1M -s testvg/dummy-lv
>>>>>>  lvremove -f testvg/dummy-snap
>>>>>> done
>>>>>>
>>>>>> This reproduced the deadlock for me. I also ran 'echo 30 >
>>>>>> /proc/sys/kernel/hung_task_timeout_secs', to reduce the hung task
>>>>>> timeout.
>>>>>>
>>>>>> Nikos.
>>>>>
>>>>> Very nice, well done.  Curious if you've tested with the fix I've staged
>>>>> (see above)?  If so, does it resolve the deadlock?  If you've had
>>>>> success I'd be happy to update the tags in the commit header to include
>>>>> your Tested-by before sending it to Linus.  Also, any review of the
>>>>> patch that you can do would be appreciated and with your formal
>>>>> Reviewed-by reply would be welcomed and folded in too.
>>>>>
>>>>> Mike
>>>>
>>>>
>>>>
>>>> --
>>>> Guruswamy Basavaiah
>>>
>>>
>>>
> 
> 
> 

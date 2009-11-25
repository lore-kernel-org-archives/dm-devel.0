From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Wed, 25 Nov 2009 10:43:26 -0500
Message-ID: <4B0D509E.9090001@redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>	<20091123055835.GA28981@us.ibm.com>	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>	<20091124191704.GB7971@us.ibm.com>
	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/25/09 08:19, Mikulas Patocka wrote:
> 
> 
> On Tue, 24 Nov 2009, malahal@us.ibm.com wrote:
> 
>> I need to look at the code again, but I thought any new writes to a
>> failed region go to a surviving leg. In that case, we end up returning
>> I/O's to the application after writing to a single leg.
> 
> Writes always go to all the legs, see do_write(). Anyway, dmeventd removes 
> the failed leg soon.

Is it correct? When the region is in the state of out of sync (NOSYNC), 
I/Os are not processed by do_write() but generic_make_request() in the
do_writes().

>>>> Also, we do need to do the above work only if "primary" leg fails. We
>>>> can continue to work just like the old code if "secondary" legs fail,
>>>> right? Not sure if this is worth optimizing though, but I would like to
>>>> see it implemented as it is just a few extra checks. We can have
>>>> primary_failure field like log_failure field.
>>  
>>> I thought about it too, but concluded that we need to hold bios even if 
>>> the primary leg fails.
>>>
>>> Imagine this scenario:
>>> * secondary leg fails
>>> * write fails on the secondaty leg and succeeds on the primary leg 
>>> and is successfully complete
>>> * the computer crashes
>>> * after a reboot, the primary leg is inaccessible and the secondary leg is 
>>> back online --- now raid1 would be returning stale data.
>>
>> The software can detect this case. We can fail this completely or use
>> the data from the secondary that could be "stale" with help from admin. 
>> Let us call this method 1.
> 
> You can't detect it because the computer crashed *before* you write the 
> information that the secondary leg failed to the metadata.
> 
> So, after a reboot, you can't tell if any mirror leg failed some requests 
> before the crash.
> 
>>> If we hold the bios if the secondary leg fails (as the patch does), one of 
>>> these two scenarios happen:
>>>
>>> * secondary leg fails
>>> * write succeeds on the primary leg and is held
>>> * the computer crashes
>>> * after a reboot, the primary leg is inaccessible and the secondary leg is
>>> back online --- but we haven't completed the write, so the transaction 
>>> wasn't reported as committed
>>>
>>> or
>>>
>>> * secondary leg fails
>>> * write succeeds on the primary leg and is held
>>> * dmeventd removes the secondary leg and the write succeeds
>>> * the computer crashes
>>> * after a reboot, the primary leg is inaccessible, the secondary leg was 
>>> already removed by dmeventd, so the array is considered inaccessible. So 
>>> it doesn't work but at least it doesn't revert already committed 
>>> transaction.
>>
>> How is this latter case (it doesn't need a crash anyway)
>> different/better from the case where we detect that 'primary' is missing
>> and ask admin if he wants to use the data on the secondary or not. At
>> least, the admin has a choice with "method 1" and this doesn't have that
>> choice.
> 
> If you ask the admin always if primary leg failed and wait for his action, 
> you lose fault-tolerance --- the computer would wait until the admin does 
> an action.
> 
> The requirements are:
> * if one of legs fail or log fails, you must automatically continue 
> without human intervention
> * if both legs fail, you must shut it down and not pretend that something 
> was written when it wasn't (this would break durability requirement of 
> transactions).

I agree with this point. lvm mirror could be used on filesystems such as
ext3 and each filesystem and application needs to take care those situation
to prevent data corruption. I don't think that it is realistic, and the
underlying layer should prevent data corruption. I now understand primary
and secondary disks need to be blocked.

Thanks,
Taka

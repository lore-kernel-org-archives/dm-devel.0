From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Improving mirror fault handling.
Date: Tue, 13 Jan 2009 11:50:48 -0600
Message-ID: <7E749D3B-99C5-42C7-97D5-BE2C0A83DBB5@redhat.com>
References: <1231802846.10230.65.camel@hydrogen.msp.redhat.com>
	<20090113032652.GA27493@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090113032652.GA27493@us.ibm.com>
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


On Jan 12, 2009, at 9:26 PM, malahal@us.ibm.com wrote:

>> 4) Transient fault handling
>> - Since we can't just assume "wait 5 seconds and then see if the  
>> failure
>> still exists", we are going to have to make this configurable.
>> Discussion should proceed on this in parallel with #2 and #3, since  
>> this
>> phase will take a long time for everyone to agree.  We have to  
>> determine
>> where the user specifies the configuration - lvm.conf?  CLI?  We also
>> have to determine /what/ their configuration will be based on - time?
>> percentage of mirror out-of-sync?
>
> Thank you Jonathan for the nice write up. Transient failure are
> generally recoverable after a period of time. The 'time' may vary from
> device to device though. lvm.conf based configuration is a good  
> place to
> start. Do we really need LV or PV based configuration for this
> 'timeout'?
>
> The recovery itself doesn't depend on the %of out-of-sync regions, but
> that is a good place to start looking for re-allocating the regions if
> configured for re-allocation.
>
> Here are my thoughts:
> 	handle_mirror_transient_failure()
> 	{
> 		do {
> 			if (device-came-back-to-life()) {
> 				start-resynchronization();
> 				break;
> 			}
>
> 			if (reallocation-timeout exceeded or
> 			    re-allocation-too-much out-of-sync) {
> 				re-allocate();
> 				break;
> 			}
> 			if (some-other-timeout exceeded) {
> 				log a message and break;
> 			}
> 			sleep(for-few-seconds);
> 			timeout =- few-seconds;
> 		} while (1)
> 	}

If we put the configuration in lvm.conf, then it would globally apply  
to all volume groups and all logical volumes.  I might be willing to  
accept that for a while, but others may want a plan for something  
better going forward.  We don't want to pollute the conf file with new  
fields that will be useless shortly into the future.  If you look in  
LVM2/doc/example.conf and search for _fault_policy, you can see that  
there are already some configuration options there.  We might stick  
the new ones there as well.  (Although this somewhat confuses me,  
because they apply only to our default DSO, and you can change the DSO  
you want to use in a completely different section of the config  
file...  So now you have settings that are worthless because a custom  
DSO is being used.)

What I meant in regards to "/what/ their configuration will be based  
on", is that the user may not care about the time they wait for a  
device to come back, but how far the mirror has gone out of sync while  
the device has been gone...  If one of the legs fails and the mirror  
is 75% out of sync before the device comes back, the user may just  
want the device removed and stop waiting.  If the user specifies "5  
minutes" wait time, but there have been no writes to the mirror in  
that time, then we could probably wait longer.  You see what I mean?   
A user may wish to use a combination of the two methods... "Wait 20  
minutes for the device to come back, but only if the mirror stays >  
95% in-sync".

As for the pseudo-code...  I wouldn't use a 'while(1)' there... leave  
the thread free to continue.  We could use dmeventd's timer events to  
trigger the next check for the device coming back (I hope).  Your code  
seems to suggest that you understand my point in the preceding  
paragraph, but I am a bit confused by the use of '[re-]allocation'.   
In this piece of code, we are only concerned about whether or not to  
take action.  The action is user defined (see the example.conf  
mentioned above), so the space may or may not be reallocated.

brassow

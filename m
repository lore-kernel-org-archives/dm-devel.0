From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 04 Nov 2011 12:26:02 -0400
Message-ID: <4EB4121A.1060102@cfl.rr.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com> <4EB2E4B7.7000103@cfl.rr.com>
	<CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
	<4EB407DC.8070307@cfl.rr.com> <20111104155228.GY4417@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111104155228.GY4417@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

On 11/4/2011 11:52 AM, Tejun Heo wrote:
>> Could you clarify what issues you refer to?  Moving a drive to
>> another machine?
>
> Yeah, that or hotplugging, or changing BIOS config, updating BIOS,
> and, some (rare) BIOSen even fail to set up things consistently across
> reboots.

I'm asking for a clarification not just a restatement.  What problem 
occurs when you move a drive to another machine, or hotplug the drive?

> Exposing alt size should be enough for md/dm no matter how hpa is
> setup.

So you are saying that mdadm should store the metadata for 0.9 and 1.0 
relative to the locked end of the disk, even if it is currently 
unlocked?  I suppose then grub also will need to be able to detect if 
the disk has been unlocked and adjust to using the locked size.

>> Being able to defeat the heuristic would help, but I still don't see
>> why the heuristic should be implemented in the kernel instead of
>> user space?
>
> Because sans raids, it was good enough and doesn't recent md's have
> metadata at the beginning anyway?

It isn't about whether it is good enough or not, it's about whether the 
kernel should be using heuristics to make decisions, or leaving it up to 
user space, where distros can come up with all kinds of complex logic to 
handle all of the goofy cases.  You complain that the block layer does 
not have enough information to get it right, so why not let user space 
decide, where it has access to all of the information it needs.

> The thing is that you have your problem, and other people have other
> issues w/ HPA.  At this point, it's a misfeature abused by some silly
> BIOSen mostly for silly BIOS raids.  I think we should expose the most
> we can to our users and if some BIOSen are screwed on soft reboot,
> well, just accept it or turn off HPA unlocking manually.

It is actually not used FOR the bios raid.  The bios is using the HPA 
for unrelated reasons and it just happens that unlocking it breaks the 
bios raid ( and mdadm with format 0.9 or 1.0 ).

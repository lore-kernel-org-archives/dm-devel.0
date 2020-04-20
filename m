From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH 0/3] dm raid/raid1: enable discard support
 when any devices support discard
Date: Mon, 20 Apr 2020 09:35:38 +0200
Message-ID: <6bbf9d94-2fbb-f96f-ea85-a480ba109c55@redhat.com>
References: <20200419073026.197967-1-pabs3@bonedaddy.net>
	<20200419131908.GA22398@redhat.com>
	<9cb6a39a43178be29af2f47a92c2e84754b62b69.camel@bonedaddy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9cb6a39a43178be29af2f47a92c2e84754b62b69.camel@bonedaddy.net>
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
To: dm-devel@redhat.com
Cc: Paul Wise <pabs3@bonedaddy.net>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 4/19/20 4:48 PM, Paul Wise wrote:
> On Sun, 2020-04-19 at 09:19 -0400, Mike Snitzer wrote:
> 
>> You went overboard with implementation before checking to see if your
>> work would be well received.  Your 2/3 patch header shows you're
>> capable of analyzing past commits to explain the evolution of code,
>> etc.  But yet you make no mention of this commit header which explicitly
>> speaks to why what you're proposing is _not_ acceptable:
>>
>> commit 8a74d29d541cd86569139c6f3f44b2d210458071
>> Author: Mike Snitzer <snitzer@redhat.com>
>> Date:   Tue Nov 14 15:40:52 2017 -0500
>>
>>      dm: discard support requires all targets in a table support discards
> 
> I do remember seeing this commit while working on this, I guess I
> ignored it in my attempts to get fstrim working on my rootfs, woops.
> 
>> I haven't looked closely at MD raid in this area but if you trully think
>> underlying MD raid can cope with issuing discards to devices that don't
>> support them (or that it avoids issuing them?) then please update
>> dm-raid.c to conditionally set ti->discard_supported (if not all devices
>> support discard).  That is how to inform DM core that the target knows
>> better and it will manage discards issued to it.  It keeps the change
>> local to dm-raid.c without the flag-day you're proposing.
> 
> On my system I have a HDD and an SSD, with /boot on MD RAID and / on
> ext4 on DM RAID on 2 DM crypt volumes. In this setup fstrim works on
> /boot but does not work on / and with my patches it works on / again.
> In addition I don't see any messages in dmesg or other issues when
> doing fstrim / with my patches.

Did you have discard allowed on both dm-crypt devices? dm-crypt (kernel) 
does not allow discards by default.

Regards O.

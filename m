From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: dm-loop status
Date: Fri, 09 Jan 2009 09:59:57 +0000
Message-ID: <4967201D.8050103@redhat.com>
References: <772ddc350901081410q7c095416h2e2c280e0e47b818@mail.gmail.com>
	<20090108223543.GA12299@mars.virtualiron.com>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090108223543.GA12299@mars.virtualiron.com>
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

Konrad Rzeszutek wrote:
> On Thu, Jan 08, 2009 at 04:10:40PM -0600, Salah Coronya wrote:
>> Anyone know the status of dm-loop? The wiki page hasn't been update in
>> a year, and there hasn't been any mention of it on the mailing list
>> for longer than that, and it doesn't appear to have ever been merged
>> in the Linux kernel.
> 
> I believe the LKML guys thought there was no need for a second
> type of loop device - that instead the loop device should have its
> bugs fixed instead.
> 
> Look on LKML for dm-loop and loop discussions.

I don't think that was ever fully resolved. Neither of the block-mapped 
loop implementations that have been proposed were ready for merging last 
year (see Christoph's comments regarding the need for an API to keep the 
file systems informed of what we are doing behind their backs).

There is a clear demand for device-mapper integrated loopback support 
(see numerous threads on this list and several kernel.org bugzillas) and 
I think this is something that we should still be aiming at.

My preferred approach is to have a single implementation of loopback 
block device support that can be exposed via both the /dev/loop and 
device-mapper interfaces. Sharing code between these two subsystems 
seems an obvious net win but I haven't had any time to work on this over 
the last year.

Regards,
Bryn.

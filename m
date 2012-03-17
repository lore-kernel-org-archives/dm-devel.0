From: Mark Hills <mark@pogo.org.uk>
Subject: Re: RFC: dm-ssdcache
Date: Sat, 17 Mar 2012 19:47:06 +0000 (GMT)
Message-ID: <alpine.LNX.2.01.1203171740180.2038@stax.localdomain>
References: <4F635E69.3070901@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F635E69.3070901@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 16 Mar 2012, Hannes Reinecke wrote:

> Hi all,
> 
> to through some more confusion in an already heated debate, here is
> the 'dm-ssdcache' module I recently wrote.
> And held a talk about at LinuxCon Europe 2011 :-)
> 
> Upon request I'll be generating a proper patch ...
> 
> Not saying it's perfect, and surely doesn't have all the nifty
> features bcache has, but it should serve as a 'minimal'
> implementation. And probaly will start yet another discussion,
> if nothing else.
> 
> So, comments etc are welcome.

Thanks for sharing this. I gave it a try with mixed but promising 
resulting. I'll share my observations in case they are useful.

Writethrough mode worked as expected, as did 'readcache'. But I found the 
caching would stop after a short time; data already in the cache was read 
from there, but no new data written. dmesg no longer prints "flush start", 
"flush done", but no other indication; possibly some lock is taken in some 
way?

It took me a while to work out how to switch to LRU behaviour, as I had to 
give the number of option arguments, for reference here it is:

  dmsetup create test --table "0 625137282 ssdcache /dev/sdc1 /dev/sdb1 options 1 lru"

In writeback I found I was quickly getting ext4 reports of corruption. 
Even just between formatting the device and using it. Possibly it 
by-passes the cache a little too readily under some reasons (eg. large bio 
size) when data is in the cache?

In all cases I zeroed the front of the cache device before use, but I 
couldn't see quickly from the code whether the cache device is intended to 
be persistent and if I need a better way to initialise it, I assume not?

"dmsetup remove" seems to take along time (several minutes), not spinning 
on CPU or disk. But it does eventually complete. Possibly this is linked 
to the non-caching issue and some kind of lock. But then that doesn't 
explain why it eventually completes.

Thanks

-- 
Mark

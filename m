From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH 0/9] Generate uevents for all DM events
Date: Wed, 5 Oct 2016 08:26:41 +0200
Message-ID: <44186175-0dd5-dc23-b411-aaa9b897745f@suse.de>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
 <20161004072015.GA11216@kroah.com>
 <fe185eba-f802-6731-8da7-736c117db135@redhat.com>
 <20161005004004.GC28416@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161005004004.GC28416@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On 10/05/2016 02:40 AM, Alasdair G Kergon wrote:
> On Tue, Oct 04, 2016 at 04:39:28PM -0700, Andy Grover wrote:
>> devicemapper is using uevents for:
>> a. dm-verity detected corruption
>> b. dm-multipath: path failed or reinstated
>> c. dm device renamed
>> d. there's also some use in md and bcache.
>>
>> devicemapper uses DM_EVENT ioctl (yuck) for:
>> 1. dm-thin pool data/metadata filling up (hit a threshold)
>> 2. dm-cache is now clean
>> 3. dm-log flushed or log failed
>> 4. dm-raid error detected or sync complete
> 
>> there doesn't seem to be much technical differentiation between the  
>> two lists.
> 
> The distinction in dm is that events in the first category may affect
> the availability of the device: they represent major (and hopefully
> rare) changes.
> 
> Events in the second category are just notifications: no impact on /dev,
> no need to trigger udev rules, and their use will continue to be
> extended, and (rarely at the moment) could be frequent (which is no
> problem for the existing polling-based mechanism).
> 
>> Instead of using uevent for everything, we could go to a separate  
>> genetlink for 1-4 instead of making them use uevent like a-d, but we'd  
>> end up with two different userspace notification techniques.
> 
> We see these as two different categories of notifications, and prefer
> the greater flexibility a mechanism independent of uevents would
> provide.  The team has discussed several alternatives over the years but
> didn't make a decision as we've not yet reached a point where we're
> straining the existing mechanism too far.
> 
I would love to remove the dm-event usage from multipathing.
As it stands using dm-events from multipathing is a massive resource
drain (we have to allocate a waiting thread for each device), and we
more-or-less disregard that information anyway as it is an ex-post
notification made _after_ someone modified the table.
Given that in most cases it was actually _us_ doing the reconfiguration
it has very little value.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm-cache: dirty state of blocks in writethrough mode
Date: Wed, 24 Jul 2013 19:05:59 +0200
Message-ID: <51F00977.7060802@redhat.com>
References: <C91EDD5251EDF44CB434B1039B0DEEB82A8D0762@SACEXCMBX02-PRD.hq.netapp.com>
	<51EE8470.6070302@redhat.com> <20130724102452.GA6963@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130724102452.GA6963@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kumar amit mehta <gmate.amit@gmail.com>
Cc: dm-devel@redhat.com, o@gmail.com
List-Id: dm-devel.ids


On 07/24/2013 12:24 PM, Kumar amit mehta wrote:
> On Tue, Jul 23, 2013 at 03:26:08PM +0200, Heinz Mauelshagen wrote:
>> On 07/23/2013 08:44 AM, Vijarnia, Anil wrote:
>>> Hello,
>>> In Documentation/cache.txt, section 'Updating on-disk metadata' mentions that "If the system crashes all cache blocks will be assumed dirty when restarted".
>>> I am assuming that the above line is relevant for writeback mode only, and in writethrough mode the cache will always be coherent after a crash.
>>> Can someone confirm/reject this assumption?
>> That's correct
>>
>> Reason being that the cache never holds any dirty pages in
>> writethrough mode.
> I'm new to storage and would like to know the linux implementation of
> writeback policy of disk cache. In case these disk caches are stored in
> volatile RAM and we hit system crash, so that cache is gone, but somehow
> we have to flush those pending writes to the backend storage, once the
> system comes up. How this is achieved in general, Is it through some
> kind of metadata that is maintained in a separate area of the disk or it
> relies on the file system's journalling capability?

dm-cache maintains it's own metadata keeping track of any cached blocks 
properties
such as a block being dirty in case of writeback.

If any write in writeback mode hits a cache block, the cache metadata will
reflect that dirty state before the write's being reported to the 
application.

After a crashed system rebooted, that information is available to flush a
dirty block out on eviction.

Heinz

>
> !!amit

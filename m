From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm-cache: dirty state of blocks in writethrough mode
Date: Thu, 25 Jul 2013 12:45:31 +0200
Message-ID: <51F101CB.20900@redhat.com>
References: <C91EDD5251EDF44CB434B1039B0DEEB82A8D0762@SACEXCMBX02-PRD.hq.netapp.com>
	<51EE8470.6070302@redhat.com> <20130724102452.GA6963@gmail.com>
	<51F00977.7060802@redhat.com> <20130724130220.GC6963@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130724130220.GC6963@gmail.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


On 07/24/2013 03:02 PM, Kumar amit mehta wrote:
> On Wed, Jul 24, 2013 at 07:05:59PM +0200, Heinz Mauelshagen wrote:
>> dm-cache maintains it's own metadata keeping track of any cached
>> blocks properties
>> such as a block being dirty in case of writeback.
>>
>> If any write in writeback mode hits a cache block, the cache metadata will
>> reflect that dirty state before the write's being reported to the
>> application.
>>
>> After a crashed system rebooted, that information is available to flush a
>> dirty block out on eviction.
> Ahh, so It is the metadata device. Maybe overkill, but is it
> possible to keep redundant copies of this metadata, like user space
> utilities such as LVM2 does?

You can set up a mirrored metadata device to be resilient against SSD 
failures.

Plus you can take metadata snapshots at arbitrary points in time;
see the targets kernel documentation in thin-provisioning.txt for this
and the recent thin_dump support metadata snapshots  in the rawhide
device-mapper-persistent-data package.

Either is subject to future LVM2 support and isn't supported as yet.

Heinz

>
> !!amit

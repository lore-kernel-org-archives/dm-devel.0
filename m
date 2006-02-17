From: "Allen Jack" <AJACK@novell.com>
Subject: Re: Opening a dm device reads from cache, not the device.
Date: Fri, 17 Feb 2006 11:18:19 -0700
Message-ID: <43F5B0FB.8B4D.000D.0@novell.com>
References: <43F35F58.8B4D.000D.0@novell.com>
	<20060217175601.GB23651@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060217175601.GB23651@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids

This is my own RAID0 and RAID5 plugin, not one that ships with
device-mapper.  I have already put in the logic within the plugin to not
use my cache when using clustering.  That is not the problem.  The
problem is that if an application in user space opens the RAID5 device
that was created (using open("/dev/evms/.nodes/r5", O_RDWR | O_SYNC |
O_DIRECT)) it will open successfully.  If I read sector 0 (the first 512
bytes) it will return data that is cached somewhere (I don't know
where).  I have a print statement in the map routine of my plugin, and
it never gets hit during the read.  If I then read some random sector
out, my plugin map code does get hit, and I return the data.

So, the problem is that somewhere the data is being cached when the
device is being opened. This happens above my plugin.   In a cluster,
this is bad because I cannot even return the current data on the disk.

Is there something I need to do to disable this caching outside from my
plugin?  Is the data being cached by reiser or device-mapper?  That is
the question.

Allen

Allen Jack
email - ajack@novell.com
Novell, Inc., the leading provider of information solutions
http://www.novell.com

>>>> Heinz Mauelshagen <mauelshagen@redhat.com> 2/17/2006 10:56 am >>>
>
>Is this dm-raid45 ?
>
>If so, you'll need to add cluster logic to it (ie. taking locks
>out on stripe cache accesses, invalidating stripes etc).
>
>>On Wed, Feb 15, 2006 at 05:05:28PM -0700, Allen Jack wrote:
>> I have a RAID5 plugin that is also used with clustering.  I open
the
>> raid device (created in device-mapper) using the O_SYNC and
O_DIRECT
>> flags, but it seems to read the data from a cache somewhere.  I put
a
>> printk in my plugin map function, but it doesn't get hit.  If
another
>> node in the cluster changes the data on the disk, it never gets
>> refreshed on this node because of the caching.
>> 
>> Is there any way to turn off the caching so that all read requests
come
>> to my plugin?  And where is the caching taking place?
>> 
>> Thanks,
>> 
>> Allen
>> 
>> Allen Jack
>> email - ajack@novell.com 
>> Novell, Inc., the leading provider of information solutions
>> http://www.novell.com 
>> 
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com 
>> https://www.redhat.com/mailman/listinfo/dm-devel 

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

--
dm-devel mailing list
dm-devel@redhat.com 
https://www.redhat.com/mailman/listinfo/dm-devel

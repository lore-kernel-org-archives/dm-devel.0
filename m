From: david@lang.hm
Subject: Re: WANTED: kernel projects for CS students
Date: Mon, 15 Oct 2007 17:51:36 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710151740000.3949@asgard.lang.hm>
References: <20071014190128.6e3cdb44@bree.surriel.com>
	<1192468232.8642.39.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1192468232.8642.39.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zan Lynx <zlynx@acm.org>
Cc: dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>
List-Id: dm-devel.ids

On Mon, 15 Oct 2007, Zan Lynx wrote:

> On Sun, 2007-10-14 at 19:01 -0400, Rik van Riel wrote:
>> The kernel newbies community often gets inquiries from CS students who
>> need a project for their studies and would like to do something with
>> the Linux kernel, but would also like their code to be useful to the
>> community afterwards.
>>
>> In order to make it easier for them, I am trying to put together a
>> page with projects that:
>> - Are self contained enough that the students can implement the
>>   project by themselves, since that is often a university requirement.
>> - Are self contained enough that Linux could merge the code (maybe
>>   with additional changes) after the student has been working on it
>>   for a few months.
>> - Are large enough to qualify as a student project, luckily there is
>>   flexibility here since we get inquiries for anything from 6 week
>>   projects to 6 month projects.
>>
>> If you have ideas on what projects would be useful, please add them
>> to this page (or email me):
>>
>> http://kernelnewbies.org/KernelProjects
>
> How about this in the Device Mapper raid-1/mirror code?
> 	/* FIXME: add read balancing */
>
> That comment has been in there for many releases.  I've wanted read
> balancing for several servers and had all sorts of ideas about it, like
> adding functions to the underlying device queues to return a "queuing
> cost" to determine which is the best queue to add the read request.  I
> think that could work better for queues like CFQ than the MD
> closest-head.
>
> An implementation would also need to be benchmarked against the MD
> raid-1.
>
> Along with the time to submit it to LKML, get it reviewed and polish it
> up, it might make a good student project.

another couple of raid enhancements would be:

1. teach the system that a raid456 stripe is handled most efficiantly if 
treated as a single block of data

by this I mean that if you read one block from the stripe the system reads 
the entire stripe, so it should take this into account when doing 
read-ahead and not always throw away most of the data it read becouse it's 
outside the current readahead window (if nothing else, look at putting it 
on the tail of the LRU list instead of just forgetting it)

if you write one block of the stripe the system must read the stripe, then 
update two blocks of the stripe (the data block and the parity block), but 
if you are going to write the entire stripe out you can ignore whatever's 
there and just calculate the parity block from the data you are writing. 
this should make writing to a raid456 stripe as fast as writing to a raid0 
stripe (well, almost, you have one more block to write).


2. not directly a kernel project, create userspace tools that make 
managing raid and partitioning on linux as easy as the zfs tools


3. there is currently the ability to grow a raid56 array by adding a disk, 
but there is not the ability to take a raid5 array, add a disk and make 
the result a raid6 array.

David Lang

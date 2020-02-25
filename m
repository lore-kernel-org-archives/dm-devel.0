From: Jane Chu <jane.chu@oracle.com>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept
 arbitrary offset and len
Date: Tue, 25 Feb 2020 15:26:13 -0800
Message-ID: <f4085f6f-8305-2e50-fffc-07f5fc116017@oracle.com>
References: <20200218214841.10076-1-vgoyal@redhat.com>
 <20200218214841.10076-3-vgoyal@redhat.com>
 <x49lfoxj622.fsf@segfault.boston.devel.redhat.com>
 <20200220215707.GC10816@redhat.com>
 <x498skv3i5r.fsf@segfault.boston.devel.redhat.com>
 <20200221201759.GF25974@redhat.com>
 <20200223230330.GE10737@dread.disaster.area>
 <CAPcyv4ghusuMsAq8gSLJKh1fiKjwa8R_-ojVgjsttoPRqBd_Sg@mail.gmail.com>
 <x49blpop00m.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gCA_oR8_8+zhAhMnqOga9GcpMX97S+x8_UD6zLEQ0Cew@mail.gmail.com>
 <x49sgizodni.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gUM47QgGKvK4ZVUek6f=ABT7hRFX47-DQiD6AcrxtRHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gUM47QgGKvK4ZVUek6f=ABT7hRFX47-DQiD6AcrxtRHA@mail.gmail.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2/24/2020 4:26 PM, Dan Williams wrote:
> On Mon, Feb 24, 2020 at 1:53 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>>>> Let's just focus on reporting errors when we know we have them.
>>>
>>> That's the problem in my eyes. If software needs to contend with
>>> latent error reporting then it should always contend otherwise
>>> software has multiple error models to wrangle.
>>
>> The only way for an application to know that the data has been written
>> successfully would be to issue a read after every write.  That's not a
>> performance hit most applications are willing to take.  And, of course,
>> the media can still go bad at a later time, so it only guarantees the
>> data is accessible immediately after having been written.
>>
>> What I'm suggesting is that we should not complete a write successfully
>> if we know that the data will not be retrievable.  I wouldn't call this
>> adding an extra error model to contend with.  Applications should
>> already be checking for errors on write.
>>
>> Does that make sense? Are we talking past each other?
> 
> The badblock list is late to update in both directions, late to add
> entries that the scrub needs to find and late to delete entries that
> were inadvertently cleared by cache-line writes that did not first
> ingest the poison for a read-modify-write. So I see the above as being
> wishful in using the error list as the hard source of truth and
> unfortunate to up-level all sub-sector error entries into full
> PAGE_SIZE data offline events.

Sorry, don't mean to distract the discussion, but I'm wondering if
anyone has noticed SIGBUS with si_code = MCEERR_AO in a single process 
poison test over a dax-xfs file?  There is only 1 poison in the
file which has been consumed, it's the recovery code path (hole punch/
munmap/mmap/pwrite/read) that encounters the _AO. I'm confident that
latent error isn't the scenario per ARS scrub. Also, the _AO appears
rarely. This is un-explainable given the kernel MCE pmem handling
implementation.

> 
> I'm hoping we can find a way to make the error handling more fine
> grained over time, but for the current patch, managing the blast
> radius as PAGE_SIZE granularity at least matches the zero path with
> the write path.

Maybe the new filesystem op for clearing pmem poison should insist on
4K alignment? because in hwpoison_clear() the starting pfn is given
by PHYS_PFN which rounds down to the nearest page, so we might inadvertently
clear the poison bit and 'noce' bit from a page when we only cleared a
poison e.g. in the second half of the page.

BTW, set_mce_nospec() doesn't seem to work in 5.5 release,
   [ 2321.209382] Could not invalidate pfn=0x1850600 from 1:1 map
I will see if I can find more information.

> 
>>> Setting that aside we can start with just treating zeroing the same as
>>> the copy_from_iter() case and fail the I/O at the dax_direct_access()
>>> step.
>>
>> OK.
>>
>>> I'd rather have a separate op that filesystems can use to clear errors
>>> at block allocation time that can be enforced to have the correct
>>> alignment.
>>
>> So would file systems always call that routine instead of zeroing, or
>> would they first check to see if there are badblocks?
> 
> The proposal is that filesystems distinguish zeroing from free-block
> allocation/initialization such that the fsdax implementation directs
> initialization to a driver callback. This "initialization op" would
> take care to check for poison and clear it. All other dax paths would
> not consult the badblocks list.

thanks!
-jane


> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
> 

From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 1/2] dm-unstripe: unstripe RAID 0/dm-striped device
Date: Fri, 15 Dec 2017 11:55:26 -0800
Message-ID: <bcb46f56-fd24-5352-8006-8e30c8e2ad72@infradead.org>
References: <20171213213332.2914-1-scott.bauer@intel.com>
 <20171213213332.2914-2-scott.bauer@intel.com>
 <4540fbf0-81e3-57b4-91e6-e33d5b5c578b@infradead.org>
 <20171215152710.djma3jau7dbdrnjr@sbauer-Z170X-UD5>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171215152710.djma3jau7dbdrnjr@sbauer-Z170X-UD5>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Bauer <scott.bauer@intel.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On 12/15/2017 07:27 AM, Scott Bauer wrote:
> [snip]
> On Wed, Dec 13, 2017 at 04:11:44PM -0800, Randy Dunlap wrote:
>>
>> 	                                  >=
>>
> 
> Thanks, good catch.
> 
> 
>>> +	tot_sec = i_size_read(bbdev->bd_inode) >> SECTOR_SHIFT;
>>> +	mod = tot_sec % target->chunk_sectors;
>>
>> Did you build this on 32-bit also?  Is that '%' OK on 32-bit?
> 
> I've looked at this a bit and still can't figure out why this
> modulo operation would operate differently on a 32 versus a 64
> bit platform? I know sector_t is config dependent but the
> sector_t should be promoted to 64 bit width during the modulo
> operation.
> 
> Are you wondering whether sector_t is the right type for any of
> the math in this file? Perhaps we should be safe and only use
> u64s?

Just wondering if it causes a call to some glibc __mod() function
and if so, the code should be using sector_div() -- oops, that's
a divide and you want a modulus.  Oh well, we can address it if
it becomes a problem.


-- 
~Randy

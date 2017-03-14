From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [bug report] dm crypt: add cryptographic data
 integrity protection (authenticated encryption)
Date: Tue, 14 Mar 2017 17:47:20 +0100
Message-ID: <2c154feb-2bfd-0235-1355-141a414a1bcd@gmail.com>
References: <20170313141909.GA25761@mwanda>
	<20170313160814.GA11174@redhat.com> <20170313161558.GA11245@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170313161558.GA11245@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: dm-devel.ids

On 03/13/2017 05:15 PM, Mike Snitzer wrote:
> On Mon, Mar 13 2017 at 12:08pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
...

>>>   1385	return_clone:
>>>   1386		if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
>>>   1387			mutex_unlock(&cc->bio_alloc_lock);
>>>   1388	
>>>   1389		/* Allocate space for integrity tags */
>>>   1390		if (dm_crypt_integrity_io_alloc(io, clone)) {
>>>                                                     ^^^^^
>>> Oops inside new function call.
>>>
>>>   1391			crypt_free_buffer_pages(cc, clone);
>>>   1392			bio_put(clone);
>>
>> Thanks for the report.  This code makes no sense as is.
>>
>> Milan, please help me understand why you're allocating memory needed for
>> integrity tags in this 'return_clone' error path.
> 
> I folded in a fix for this, Milan please review crypt_alloc_buffer()
> changes in this revised commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.12&id=8896496efaef45ca1a734782a8d7f9082299fa5d

Yes, it should be ok.

TBH I have no idea how this happened, that error path was clearly wrong, perhaps copy&paste error :-)

Thanks!
Milan


 

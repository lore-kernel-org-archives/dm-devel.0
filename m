From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: Array-driven persistent-data structure
Date: Thu, 10 Mar 2016 01:15:00 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603100019280.13488@mail.ewheeler.net>
References: <alpine.LRH.2.11.1603090444590.15354@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1603090444590.15354@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikolay Borisov <n.borisov@siteground.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 9 Mar 2016, Nikolay Borisov wrote:
>>On Wed, 9 Mar 2016, Eric Wheeler wrote:
>> Hello all,
>> 
>> I'm considering writing an array-driven persistent-data structure for 
>> arbitrary metadata.  The implementation is intended to be trivial but 
>> reusable:
>> 
[...]
>
> Have you checked the existing:
> http://lxr.free-electrons.com/source/drivers/md/persistent-data/dm-array.h

Interesting, I hadn't, looking now.  dm-bitset looks useful too.

It is neat to see a transactional array; that provides some correctness 
guarantees.  Having the ability to hold multiple roots could be useful 
too.

While the transactional correctness guarantee outweighs the need for O(1) 
IMHO, it would be neat to see O(1) since btree is O(lg(n)).  O(1) should 
be attainable since the chunksize is known, so offset=chunksize*index 
---but then one would need to manage their own crash recovery.

I'll look at using dm-array and/or dm-bitset for our purpose.  I think it 
will do nicely.

Thank you for the hint!

-Eric

--
Eric Wheeler

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

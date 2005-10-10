From: Patrick Caulfield <pcaulfie@redhat.com>
Subject: Re: PATCH - pvmove doesn't terminate sometimes on 64-bit
	bigendian machines
Date: Mon, 10 Oct 2005 08:27:55 +0100
Message-ID: <434A17FB.9040004@redhat.com>
References: <17191.43003.616513.15285@cse.unsw.edu.au>	<20050928174827.GS18976@agk.surrey.redhat.com>
	<17225.56945.115400.390314@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <17225.56945.115400.390314@cse.unsw.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Neil Brown wrote:
> On Wednesday September 28, agk@redhat.com wrote:
> 
>>On Wed, Sep 14, 2005 at 02:32:59PM +1000, Neil Brown wrote:
>>
>>> It is worth noting that the code uses the same bitsets for in-memory
>>> and on-disk logs.  As these bitsets are host-endian and host-sized,
>>> this means that they cannot safely be moved between computers with
>>> different architectures.  I don't know if the dm doco makes this
>>> clear...
>>
>> 
>>Are you able to try out the (untested) patch from Patrick below?
>>Since the current implementation is broken for 64-bit BE we might
>>as well fix both problems at the same time.
>>
> 
> 
> I've ask the person who reported the problem to test this patch.  I'll
> let you know what eventuates.

Thanks

> ... it's a pity about the 'ext2' appearing in there instead of a more
> sensible 'set_le_bit', isn't it :-(
> 

yes. In some (well, the big-endian) architectures it's called set_le_bit and
#defined to ext2_set_bit, bit the LE architectures just define ext2_set_bit to
be set_bit :(

-- 

patrick

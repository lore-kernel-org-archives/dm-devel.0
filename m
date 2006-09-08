From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: 1st of 2 patches for dm_emc.c and dm-multipath
	hardware handler interface
Date: Fri, 08 Sep 2006 12:59:50 -0500
Message-ID: <4501AF96.9030502@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1397@CORPUSMX40A.corp.emc.com>
	<4501A68F.8050708@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4501A68F.8050708@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids

Mike Christie wrote:
> Edward Goggin wrote:
>> +
>> +	rq->buffer = rq->data = h->buffer;
>> +	rq->data_len = len;
>> +	rq->bio = rq->biotail = NULL;
>>  
> 
> I think I only suggested that you use the block layer map functions in
> the previous review. Now I will say, use them and fix the core code to
> not allocate memory or use a mempool since it will also fix the path
> testers at the same time :) The reason is that the scsi layer is trying
> to make every thing run with scatterlists. In 2.6.18, every place is
> converted (they should be at least), so you should not be adding another
> place where we send down a data buffer like this.
> 

And if we are going to continue to do some scsi processing in dm I
already did some helpers you could base yourself off of here

http://www.cs.wisc.edu/~michaelc/block/dm/v4/


In dm_scsi_end_rq, you could handle errors like transient transport
failures for all hw handlers at one tine.

http://www.cs.wisc.edu/~michaelc/block/dm/v4/02-dm-scsi-helpers.patch

And in fact a lot of your patch has already been done with this patch

http://www.cs.wisc.edu/~michaelc/block/dm/v4/03-emc.patch a year ago.

We really need to change how dm-multipath development works IMHO.
Alasdair is just too overworked. It is not fair to him to have so much
work piled on top of him and not fair to the community to have problems
like this sit around for so long.

The basics of the hw handler framework were done when I did my pg group
callouts that improved on Joe's idea to put everything in the path
selectors. It took a year after that to get hw handlers, which made some
of the same architectural mistakes as well as odd coding choices that I
made, in the kernel. And now for another year we have been sitting on
these type of bugs and problems where we need some of the hw handler
functionality in the scsi layer as well as dm layer.

With Alasdair having to maintain every driver that dm handles and those
drivers increasing in complexity the work load is too large for one
person and this makes coordination with other subsystems impossible.
This is a large problem, when for something like dm-multipath it needs
help from the block layer, and low levels like scsi.

We really need a system like in the scsi layer where there are driver
maintainers and then one core maintainer of the subsystem. The core
maintainer has final (well ok community has final say I guess) say but
trusts the low level driver maintainers to some extent. The low level
driver maintainers still have to post patches for review to the
community and maintainer but the core maintainer does not have to do a
line by line review of the dm target module and learn all the lower
level details of the sub-subsytem/lld/dm target module/transport/spec
unless it affects dm core or it is a suspicious patch.

Just my 2 cents.

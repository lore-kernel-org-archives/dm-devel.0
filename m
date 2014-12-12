From: Spelic <spelic@shiftmail.org>
Subject: Re: [PATCH v2] staging: writeboost: Add dm-writeboost
Date: Fri, 12 Dec 2014 23:18:23 +0100
Message-ID: <548B69AF.7070403@shiftmail.org>
References: <54883195.1060304@gmail.com>
	<20141211152626.GA8196@redhat.com>	<548A39E7.80508@gmail.com>
	<548AB172.4000103@acm.org>	<548AB6E4.2020302@gmail.com>
	<548AD461.1020707@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <548AD461.1020707@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/12/2014 12:41, Bart Van Assche wrote:
> On 12/12/14 10:35, Akira Hayakawa wrote:
>> Writeboost batches number of writes into a log (that is 512KB large) 
>> and submits to SSD
>> which maximizes the throughput and the lifetime of the SSD.
>
> Does this mean that dm-writeboost is similar to btier ? If so, this 
> makes me wonder which of these two subsystems would be the best 
> candidate for upstream inclusion. As far as I know btier doesn't split 
> bio's. The source code of btier can be downloaded from 
> http://sourceforge.net/projects/tier/.

No, Btier is a caching (tiering actually but there is little difference) 
software like bcache or dm-cache, which are are open source software 
reimplementations of things like LSI CacheCade.

OTOH dm-writeboost is an open source software reimplementation of a BBWC 
(battery backed write cache) of disk controllers.

For this reason dm-writeboost was unique in its class and no doubt it 
could be blazing fast (untested by me) if correctly implemented, orders 
of magnitude faster than caching softwares, and I was looking forward to 
see dm-writeboost into the kernel.

But me too I think that dm-writeboost really needs not to split BIOs 
(whoever thinks differently has probably never looked at perf while a 
very fast raid system was writing data), and as much as possible not 
perform memcopy, and would need to detect and skip sequential I/O 
(adding logic to still be safe on sync + power loss) and use 
writethrough for that which I think it also doesn't do. These are 
absolute requirements for high performance storage systems in the 2-20 
gigabytes per second range. If Akira doesn't see the need to not perform 
memcpy or not split BIOs or not skip sequential I/O it is most certainly 
because he hasn't tried to build a high performance storage system. 
Unfortunately I think that high performance storage systems are indeed 
the main market for writeboost, so that's why these things are needed.

Another important missing feature is  way to decommission writeboost or 
put it into writethrough mode, so to be able to snapshot the underlying 
device. This is totally needed in an industrial-grade production system.

OTOH read caching would have been useless for writeboost btw imho, and 
hence counterproductive. Layer dm-cache or bcache on top of writeboost 
if you need that.

S.

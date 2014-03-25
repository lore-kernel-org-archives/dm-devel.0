From: Takashi HOSHINO <hoshino@labs.cybozu.co.jp>
Subject: Re: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for
 open firmware SSDs
Date: Tue, 25 Mar 2014 20:38:42 +0900
Message-ID: <53316AC2.2050304@labs.cybozu.co.jp>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>	<1395383538-18019-2-git-send-email-m@bjorling.me>
	<20140321153749.GA17155@infradead.org>
	<532FCCFB.7010007@acm.org> <5330F84C.8090803@bjorling.me>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5330F84C.8090803@bjorling.me>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matias Bjorling <m@bjorling.me>, Bart Van Assche <bvanassche@acm.org>, device-mapper development <dm-devel@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, agk@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

Hi Matias,

(2014/03/25 12:30), Matias Bjorling wrote:
> On 03/23/2014 11:13 PM, Bart Van Assche wrote:
>> On 03/21/14 16:37, Christoph Hellwig wrote:
>>> Just curious:  why do you think implementing this as a block remapper
>>> inside device mapper is a better idea than as a blk-mq driver?
>>>
>>> At the request layer you already get a lot of infrastructure for all the
>>> queueing infrastructure for free, as well as all kinds of other helpers.
>>> And the driver never remaps bios anyway but always submits new ones as
>>> far as I can tell.
>>>
>>> Does it even make sense to expose the underlying devices as block
>>> devices?  It surely would help to send this together with a driver
>>> that you plan to use it on top of.
>>
>> There might be some overlap between the functionality available in the
>> lightnvm driver and the WalB driver announced last year. That last
>> driver might have a wider user base and hence may have received more
>> testing. See also http://thread.gmane.org/gmane.linux.file-systems/75124.
>>
>
> Hi Bart,
>
> Thanks! There seems to be a little bit that can be reused. It does seem
> from the github page that there haven't been any development since its
> been posted. Maybe the development is moved elsewhere?

I'm one of WalB developers and the github site is currently official.
The latest code seems work with Linux kernel 3.13 but the code does not 
support the latest block-layer features like blk-mq.
Its code is currently a bit legacy... I will rework with it but I'm 
developing related userland tools and having no time for kernel code.

WalB is being developed for incremental backup and asynchrounous 
replication with legacy block devices. Its code will not be used for 
dm-lightnvm directly but its algorithm may be useful for some purposes 
because it is similar to FTL.

It must be nice if dm-lightnvm software will have incremental backup and 
replication functionality with FTL management.

>> Bart.
>>
>
>

Takashi

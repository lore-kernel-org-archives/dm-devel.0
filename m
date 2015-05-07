From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Thu, 7 May 2015 12:19:14 +0200
Message-ID: <554B3C22.4060305@sandisk.com>
References: <5548CDE5.9@sandisk.com> <20150506022332.GA12096@redhat.com>
	<5549C68E.2050705@sandisk.com> <20150506182942.GA15545@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150506182942.GA15545@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/06/15 20:29, Mike Snitzer wrote:
> On Wed, May 06 2015 at  3:45am -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>
>> On 05/06/15 04:23, Mike Snitzer wrote:
>>> On Tue, May 05 2015 at 10:04am -0400,
>>> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>>>> While retesting my SRP initiator patches on top of kernel v4.1-rc2
>>>> with DM_MQ_DEFAULT=y I ran into the kernel warning below. Does this
>>>> mean that I'm missing any device mapper related patches ? This
>>>> warning was reported shortly after scsi_remove_host() had been
>>>> invoked.
>>>
>>> I put the warning in place because, to me, if it triggers it speaks to
>>> unsafe teardown occuring (request is still completing but the queue it
>>> was issued from no longer exists).
>>>
>>> Like I said before I'm open to removing the WARN_ON_ONCE() if this
>>> scenario is perfectly valid.  But I just haven't had time to revisit
>>> what appears to be a potentially serious problem with the underlying
>>> paths' teardown vs upper level mpath IO.
>>>
>>> I'll try to revisit this week.  But I welcome input from others too.
>>>
>>> (Just thinking about it further now, it could be that the way the clone
>>> request is allocated in the case of blk-mq DM is as part of the original
>>> request's pdu... meaning there isn't a proper get_request() call against
>>> the underlying queue.. so the expected refcounting likely isn't
>>> happening.  And given the request won't be free'd from that underlying
>>> request_queue there really isn't a need to artificially link these
>>> cloned requests with the underlying request_queue... so I'm now leaning
>>> toward just removing the WARN_ON_ONCE.. but I'll look closer tomorrow)
>>
>> Hello Mike,
>>
>> With CONFIG_SCSI_MQ_DEFAULT=y and CONFIG_DM_MQ_DEFAULT=n I just ran into
>> the bug report below. I will continue my v4.1-rc2 tests with SCSI_MQ=n.
>
> What were you doing when this happened?  Quite a strange place to get a
> NULL pointer (it should be noted that for 4.2 hch's patch does away with
> cloning the request's bios).  Is there an easy reproducer (unlikely
> considering I've tested CONFIG_SCSI_MQ_DEFAULT=y and
> CONFIG_DM_MQ_DEFAULT=n a fair amount).
>
> BTW, my "Just thinking about it further now" above was relative to
> CONFIG_DM_MQ_DEFAULT=y and CONFIG_SCSI_MQ_DEFAULT=n.

Hello Mike,

With kernel v4.1-rc2, with CONFIG_SCSI_MQ_DEFAULT=y and 
CONFIG_DM_MQ_DEFAULT=n if I run "for p in /sys/class/srp_remote_ports/*; 
do echo 1 > $p/delete; done" if no I/O is running that command works 
fine. That command triggers a call of scsi_remove_host(). But if I run 
the same command while I/O is running the message "BUG: unable to handle 
kernel NULL pointer dereference at 0000000000000068 / IP: 
blk_rq_prep_clone+0x87/0x160" appears. I just reproduced this after 
having rebuilt the kernel after a "make clean".

Bart.

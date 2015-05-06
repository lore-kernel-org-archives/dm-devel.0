From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Tue, 5 May 2015 22:23:32 -0400
Message-ID: <20150506022332.GA12096@redhat.com>
References: <5548CDE5.9@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5548CDE5.9@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, May 05 2015 at 10:04am -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Hello Mike,
> 
> While retesting my SRP initiator patches on top of kernel v4.1-rc2
> with DM_MQ_DEFAULT=y I ran into the kernel warning below. Does this
> mean that I'm missing any device mapper related patches ? This
> warning was reported shortly after scsi_remove_host() had been
> invoked.

I put the warning in place because, to me, if it triggers it speaks to
unsafe teardown occuring (request is still completing but the queue it
was issued from no longer exists).

Like I said before I'm open to removing the WARN_ON_ONCE() if this
scenario is perfectly valid.  But I just haven't had time to revisit
what appears to be a potentially serious problem with the underlying
paths' teardown vs upper level mpath IO.

I'll try to revisit this week.  But I welcome input from others too.

(Just thinking about it further now, it could be that the way the clone
request is allocated in the case of blk-mq DM is as part of the original
request's pdu... meaning there isn't a proper get_request() call against
the underlying queue.. so the expected refcounting likely isn't
happening.  And given the request won't be free'd from that underlying
request_queue there really isn't a need to artificially link these
cloned requests with the underlying request_queue... so I'm now leaning
toward just removing the WARN_ON_ONCE.. but I'll look closer tomorrow)

Mike

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: Fix a dm_blk_ioctl() deadlock
Date: Tue, 28 Jun 2016 14:59:14 -0400
Message-ID: <20160628185913.GA8185@redhat.com>
References: <c987a4ca-4b55-0b3a-a414-2608f2ded132@sandisk.com>
	<20160628181526.GA8013@redhat.com>
	<f2f4fe18-b3e0-30f6-5f4f-0fee385bade8@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f2f4fe18-b3e0-30f6-5f4f-0fee385bade8@sandisk.com>
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

On Tue, Jun 28 2016 at  2:29pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 06/28/2016 08:15 PM, Mike Snitzer wrote:
> > This patch doesn't make sense.
> > 
> > In the context of dm-mpath.c:multipath_prepare_ioctl, *bdev is only
> > valid if r == 0.  But r == -ENOTCONN so how can *bdev be valid?
> 
> Sorry but the dm code is not my area of expertise. How about the patch
> below? Please note that so far only the queue-length path selector has
> been tested.

Can we go back to what it is you've experienced?  is it that you have
'queue_if_no_path' enabled and are issuing ioctls to an mpath device
(while removing underlying paths) you'll experience a live-lock (_not_
deadlock) once no valid paths exist?

If that isn't what you're hitting then I'd like to better understand how
a request_queue that is "dying" isn't able to keep itself up enough to
fail IO issued to it (to allow normal error handling to trap the IO
failure).

Mike

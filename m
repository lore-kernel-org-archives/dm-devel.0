From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: Fix a dm_blk_ioctl() deadlock
Date: Tue, 28 Jun 2016 15:33:03 -0400
Message-ID: <20160628193302.GB8300@redhat.com>
References: <c987a4ca-4b55-0b3a-a414-2608f2ded132@sandisk.com>
	<20160628181526.GA8013@redhat.com>
	<f2f4fe18-b3e0-30f6-5f4f-0fee385bade8@sandisk.com>
	<20160628185913.GA8185@redhat.com>
	<873d69e4-f668-b0f0-0e87-3e2cf9b92fca@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <873d69e4-f668-b0f0-0e87-3e2cf9b92fca@sandisk.com>
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

On Tue, Jun 28 2016 at  3:16pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 06/28/2016 08:59 PM, Mike Snitzer wrote:
> >Can we go back to what it is you've experienced?  is it that you have
> >'queue_if_no_path' enabled and are issuing ioctls to an mpath device
> >(while removing underlying paths) you'll experience a live-lock (_not_
> >deadlock) once no valid paths exist?
> >
> >If that isn't what you're hitting then I'd like to better understand how
> >a request_queue that is "dying" isn't able to keep itself up enough to
> >fail IO issued to it (to allow normal error handling to trap the IO
> >failure).
> 
> Hello Mike,
> 
> Since I started testing kernel v4.7-rc<n> I noticed about twenty
> times that systemd-udevd got stuck in truncate_inode_pages(). I have
> not yet seen this with any older kernel version. queue_if_no_path is
> indeed enabled in my tests. The test I run consists of running fio
> on top of an mpath device and repeatedly removing and restoring the
> underlying devices. The test script is available at
> https://github.com/bvanassche/srp-test/blob/master/tests/02. Please
> let me know if you need more information.

I'm not going to be able to setup this test and chase this in the
near-term.  If you want this fixed soon then I'll need you to continue
chasing this.

Something else must be going on.  I fail to see how avoiding dying
queues, like your 2nd path selectors patch does, should be needed.

A dying queue, and the underlying device that is being torn down, still
needs to complete (fail) any of its outstanding IO -- or IO issued to it
e.g. via __blkdev_driver_ioctl -- right?

Could your driver's queue maybe not be getting torn down like it did in the
past? -- if it lingers in this "dying" state then that could start to
explain why this is happening all of a sudden in v4.7-rc<n>.  Would be
nice to know if that is what is happening.

But you've definitely seen that your path selector patch, that skips
selecting paths with dying queues, avoids this live-lock issue?

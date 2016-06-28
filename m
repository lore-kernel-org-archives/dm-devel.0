From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm mpath: Fix a dm_blk_ioctl() deadlock
Date: Tue, 28 Jun 2016 21:16:51 +0200
Message-ID: <873d69e4-f668-b0f0-0e87-3e2cf9b92fca@sandisk.com>
References: <c987a4ca-4b55-0b3a-a414-2608f2ded132@sandisk.com>
	<20160628181526.GA8013@redhat.com>
	<f2f4fe18-b3e0-30f6-5f4f-0fee385bade8@sandisk.com>
	<20160628185913.GA8185@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160628185913.GA8185@redhat.com>
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

On 06/28/2016 08:59 PM, Mike Snitzer wrote:
> Can we go back to what it is you've experienced?  is it that you have
> 'queue_if_no_path' enabled and are issuing ioctls to an mpath device
> (while removing underlying paths) you'll experience a live-lock (_not_
> deadlock) once no valid paths exist?
>
> If that isn't what you're hitting then I'd like to better understand how
> a request_queue that is "dying" isn't able to keep itself up enough to
> fail IO issued to it (to allow normal error handling to trap the IO
> failure).

Hello Mike,

Since I started testing kernel v4.7-rc<n> I noticed about twenty times 
that systemd-udevd got stuck in truncate_inode_pages(). I have not yet 
seen this with any older kernel version. queue_if_no_path is indeed 
enabled in my tests. The test I run consists of running fio on top of an 
mpath device and repeatedly removing and restoring the underlying 
devices. The test script is available at 
https://github.com/bvanassche/srp-test/blob/master/tests/02. Please let 
me know if you need more information.

Bart.

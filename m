From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Device mapper support for more than one target ?
Date: Mon, 22 Dec 2008 18:50:33 +0000
Message-ID: <20081222185033.GA17119@agk.fab.redhat.com>
References: <37d33d830812220922l5a0bc36et5dd1f9853f9cd33@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <37d33d830812220922l5a0bc36et5dd1f9853f9cd33@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sandeep K Sinha <sandeepksinha@gmail.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Dec 22, 2008 at 10:52:08PM +0530, Sandeep K Sinha wrote:
> After looking at the complete implementation of device mappers, I
> figured out that we can have more than one target for a mapped device
> then why do we have a check for the number of target to be equal to
> one , in dm_blk_ioctl ( ) in drivers/md/dm.c
> 
> http://lxr.linux.no/linux+v2.6.27.10/drivers/md/dm.c#L337

Because whether or not it makes sense to send any specific ioctl to more
than one target in parallel depends on what that ioctl does.  When we
added that code we said that we could add hard-coding for specific
ioctls if the need arose, but so far it hasn't.

Alasdair
-- 
agk@redhat.com

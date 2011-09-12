From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-block-manager: use spinlocks that don't
 disable interrupts
Date: Mon, 12 Sep 2011 15:11:00 +0100
Message-ID: <20110912141059.GD14861@ubuntu>
References: <Pine.LNX.4.64.1109120723560.15190@hs20-bc2-1.build.redhat.com>
	<20110912135742.GA23492@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110912135742.GA23492@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 12, 2011 at 09:57:42AM -0400, Christoph Hellwig wrote:
> On Mon, Sep 12, 2011 at 07:24:48AM -0400, Mikulas Patocka wrote:
> > dm-block-manager: use spinlocks that don't disable interrupts
> > 
> > This will never be called in an interrupt context, so we don't have to use
> > spinlocks that disable interrupts.
> 
> The code looks like a re-implementation of rw_semaphores to me.
> 
> Is there any good reason to do this? (hint: normally there isn't :))

Yes, largely it is.  The major difference is it errors on recursive
use (which can occur due to malicious metadata as well as programming
errors).  This is far better than deadlocking (which rwsemaphores to),
livelocking (which no-locking may do), or not noticing something's
wrong (which no-locking may do).

I can understand that people may well want to turn locking off to get
the better performance.  So there's a Kconfig option for this.

- Joe

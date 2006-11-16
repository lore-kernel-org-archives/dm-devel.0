From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Fri, 17 Nov 2006 00:40:53 +0100
Message-ID: <20061116234053.GC6757@elf.ucw.cz>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061110103942.GG3196@elf.ucw.cz>
	<20061112223012.GH11034@melbourne.sgi.com>
	<200611122343.06625.rjw@sisk.pl>
	<20061116232349.GI11034@melbourne.sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061116232349.GI11034@melbourne.sgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri 2006-11-17 10:23:49, David Chinner wrote:
> On Sun, Nov 12, 2006 at 11:43:05PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, 12 November 2006 23:30, David Chinner wrote:
> > > And how does freezing them at that point in time guarantee consistent
> > > filesystem state?
> > 
> > If the work queues are frozen, there won't be any fs-related activity _after_
> > we create the suspend image. 
> 
> fs-related activity before or after the suspend image is captured is
> not a problem - it's fs-related activity _during_ the suspend that
> is an issue here. If we have async I/O completing during the suspend
> image capture, we've got problems....

fs-related activity _after_ image is captured definitely is a problem
-- it breaks swsusp invariants.

During image capture, any fs-related activity is not possible, as we
are running interrupts disabled, DMA disabled.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

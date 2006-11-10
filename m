From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Fri, 10 Nov 2006 11:54:36 +1100
Message-ID: <20061110005436.GN8394166@melbourne.sgi.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611091652.34649.rjw@sisk.pl>
	<20061109160003.GA24156@elf.ucw.cz>
	<200611092059.48722.rjw@sisk.pl> <20061109211722.GA2616@elf.ucw.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061109211722.GA2616@elf.ucw.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 09, 2006 at 10:17:22PM +0100, Pavel Machek wrote:
> Why not simply &~ PF_NOFREEZE on that particular process? Filesystems
> are free to use threads/work queues/whatever, but refrigerator should
> mean "no writes to filesystem" for them...

Freezing the filesytem is the way to tell the filesystem "no more
writes to the filesytem".

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

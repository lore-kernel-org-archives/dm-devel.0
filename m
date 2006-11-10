From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Fri, 10 Nov 2006 11:57:49 +1100
Message-ID: <20061110005749.GO8394166@melbourne.sgi.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611092218.58970.rjw@sisk.pl> <20061109214159.GB2616@elf.ucw.cz>
	<200611092321.47728.rjw@sisk.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200611092321.47728.rjw@sisk.pl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Pavel Machek <pavel@ucw.cz>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 09, 2006 at 11:21:46PM +0100, Rafael J. Wysocki wrote:
> I think we can add a flag to __create_workqueue() that will indicate if
> this one is to be running with PF_NOFREEZE and a corresponding macro like
> create_freezable_workqueue() to be used wherever we want the worker thread
> to freeze (in which case it should be calling try_to_freeze() somewhere).
> Then, we can teach filesystems to use this macro instead of
> create_workqueue().

At what point does the workqueue get frozen? i.e. how does this
guarantee an unfrozen filesystem will end up in a consistent
state?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

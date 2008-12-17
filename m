From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-target.c: simplify target_type to avoid
	kmalloc
Date: Wed, 17 Dec 2008 11:48:07 +0000
Message-ID: <20081217114807.GD25976@agk.fab.redhat.com>
References: <1228822355-12674-1-git-send-email-crquan@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1228822355-12674-1-git-send-email-crquan@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: crquan@gmail.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Dec 09, 2008 at 07:32:35PM +0800, crquan@gmail.com wrote:
> Move the list_head from tt_internal into struct target_type embedded,
> The struct tt_internal is totally unneeded, and the kmalloc is avoided,
> block of memory copy is also avoided
 
> The only defect is that dm_register_target users cannot use const
> target_type anymore.
 
Target registrations should be rare one-off events.  The existing trade-off is
in favour of a cleaner interface (that does not expose private fields).  The
struct target_type passed to dm_register_target is always static read-only data
and perhaps that could be enforced and a pointer stored in tt_internal instead
of making a copy.

> the function of tt_internal's use field is replaced by the module's
> reference count.
 
That is an independent change I think: please submit it as a separate patch.
When this was first written, the module reference count was managed differently
by this code so I can well believe 'use' is now superfluous.

Alasdair
-- 
agk@redhat.com

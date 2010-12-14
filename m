From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] dm: update workqueue usages
Date: Tue, 14 Dec 2010 14:16:56 +0100
Message-ID: <4D076E48.7010508@kernel.org>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
	<1292329171.30045.2.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1292329171.30045.2.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

Hello,

On 12/14/2010 01:19 PM, Heinz Mauelshagen wrote:
> what's the rational behind dropping create_singlethread_workqueue() in
> favor of alloc_ordered_workqueue(...WQ_MEM_RECLAIM..) which are
> semantically identical?

create[_singlethread]_workqueue() implies WQ_MEM_RECLAIM which is
usually only necessary in the block IO path, so I'm going through all
usages and either making them use system*_wq or make use of only the
necessary features (often droppping WQ_MEM_RECLAIM), so the use of new
API basically indicates that it went through workqueue usage review
and determined to actually require a separate workqueue with the
described features.

create_*workqueue() interfaces will be deprecated once all in-kernel
users have been converted to encourage new and external code to study
and apply the new workqueue features as necessary.

For dm, this looks rather spruious as basically all workqueues in dm
need WQ_MEM_RECLAIM but as shown with the later patches, there still
are adjustments which can be made with the new API to make the
workqueues behave more efficiently.

Thanks.

-- 
tejun

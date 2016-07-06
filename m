From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/3] offload bios to a thread
Date: Wed, 6 Jul 2016 11:23:14 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607061123010.8474@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1607041846020.16388@file01.intranet.prod.int.rdu2.redhat.com>
	<20160706133656.GA28547@redhat.com>
	<alpine.LRH.2.02.1607060946530.27982@file01.intranet.prod.int.rdu2.redhat.com>
	<20160706135513.GB28547@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160706135513.GB28547@redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Wed, 6 Jul 2016, Mike Snitzer wrote:

> > > I'd much preferred you just send an incremental fix that built on the
> > > tree you know I started, here:
> > > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
> > 
> > You need to change three patches in your git:
> > * block: flush queued bios when process blocks to avoid deadlock
> > * block: prepare for timed offload of queued bios to workqueue
> > * block: use timed offload of queued bios to a workqueue
> > because this bug is present in all of them.
> > 
> > When these patches are sent to Linus, the bug should not be present in any 
> > of them.
> 
> Yes, I'm aware.  Please review:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

Yes, It's OK.

Mikulas

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1 of 2] DM Exception Store: return zero when
	empty
Date: Tue, 29 Sep 2009 11:38:12 -0400
Message-ID: <20090929153812.GA30538@redhat.com>
References: <200909231524.n8NFOw03029884@hydrogen.msp.redhat.com>
	<20090924125148.GJ3866@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090924125148.GJ3866@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2009 at  8:51am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Wed, Sep 23, 2009 at 10:24:58AM -0500, Jon Brassow wrote:
> > When the snapshot is empty, return 0 as the number of allocated sectors.
> > This will be needed to properly notify userspace that merging is finished.
> 
> A kernel/userspace interface change and visible to the user in their tools.
> Needs discussion.

I'd be quite surprised if any users' scripts had the intelligence that
the persistent exception store always used the first 2 chunks.

I view this patch as a fix and would like to see it pushed for
2.6.32-rcX

This patch is also a prerequisite for some patches I just posted to
lvm-devel:
http://www.redhat.com/archives/lvm-devel/2009-September/msg00145.html

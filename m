From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mirroring: [patch 6 of 6] device failure tolerance
Date: Fri, 1 Jul 2005 20:16:12 +0100
Message-ID: <20050701191612.GE12721@agk.surrey.redhat.com>
References: <01e61ce296a442e0f399a4bf4864b79e@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <01e61ce296a442e0f399a4bf4864b79e@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan E Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 30, 2005 at 03:04:21AM -0500, Jon Brassow wrote:
> This patch changes how suspend works in dm.c (dm_suspend).  As a 
> result, it breaks multipath.  It is necessary for cluster mirroring to 
> ensure that a suspend happens before other nodes have a chance at 
> getting an inconsistent read.
 
Proposing something like:
  ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/00016.patch
(not compile-tested)

Can you find a way to make it cope without an 'undo presuspend' function to
call on error?  It might be OK to add a call to 'resume' on error if you can 
make that work correctly when not preceded by postsuspend.

Alasdair

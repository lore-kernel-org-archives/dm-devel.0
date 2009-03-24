From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 14/14] barriers
Date: Tue, 24 Mar 2009 14:24:23 +0000
Message-ID: <20090324142423.GH13664@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0902231422490.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902231422490.23293@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 23, 2009 at 02:23:00PM -0500, Mikulas Patocka wrote:
> DM_ENDIO_REQUEUE doesn't work and I doubt that it can be made work with
> barriers.
 
Didn't we discuss this before?
We *require* DM_ENDIO_REQUEUE functionality - I can't apply a patch that
breaks it.  But it is not something that can be used arbitrarily - it is
only used in situations where core dm is firmly in control (and I/O cannot get
through to the device e.g. all paths down in multipath) and I don't see why it
can't continue to work with barriers.

I hope it's just the comment that is wrong here - or does the patch need
updating?

Alasdair
-- 
agk@redhat.com

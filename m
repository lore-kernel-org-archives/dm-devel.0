From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 14/14] barriers
Date: Tue, 24 Mar 2009 10:30:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903241027590.29968@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0902231422490.23293@hs20-bc2-1.build.redhat.com>
	<20090324142423.GH13664@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090324142423.GH13664@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 24 Mar 2009, Alasdair G Kergon wrote:

> On Mon, Feb 23, 2009 at 02:23:00PM -0500, Mikulas Patocka wrote:
> > DM_ENDIO_REQUEUE doesn't work and I doubt that it can be made work with
> > barriers.
>  
> Didn't we discuss this before?
> We *require* DM_ENDIO_REQUEUE functionality - I can't apply a patch that
> breaks it.  But it is not something that can be used arbitrarily - it is
> only used in situations where core dm is firmly in control (and I/O cannot get
> through to the device e.g. all paths down in multipath) and I don't see why it
> can't continue to work with barriers.
> 
> I hope it's just the comment that is wrong here - or does the patch need
> updating?

Oh, sorry, that is old comment for the old version of that patch. I fixed 
the code but forgot to remove the comment. The code in the patch should be 
correct w.r.t. DM_ENDIO_REQUEUE.

Mikulas

> Alasdair
> -- 
> agk@redhat.com
> 

From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 44/54] libmultipath: adopt_paths(): don't
 bail out on single path failure
Date: Wed, 05 Aug 2020 14:05:00 +0200
Message-ID: <7a92c06bdbfdcfd3530607f4b8dbce7a5c9330a5.camel@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
	<20200709103623.8302-3-mwilck@suse.com>
	<20200717212525.GR11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200717212525.GR11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2020-07-17 at 16:25 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 12:36:13PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > If pathinfo fails for one path to be adopted, we currently
> > fail the entire function. This may cause ev_add_path() for a valid
> > path to fail because some other path is broken. Fix it by just
> > skipping paths that don't look healthy.
> 
> This looks problematic to me.  While I agree that we shouldn't make
> ev_add_path fail because some other path failed, but what about if
> the
> path we are trying to add fails in pathinfo().  In this case
> multipathd
> won't orphan the path and it will report "path added to devmap", even
> though it wasn't. Also what is the correct response for when you try
> to create a multipath device but none of the paths can be added.
> Should multipathd create a device with no paths? 

There are 3 callers of adopt_path():

 1 add_map_with_path()
 2 ev_add_path()
 3 update_map()

adopt_paths() only ever adds new paths to a map, so in case 3), the map
would not come out without paths unless it had been empty before
already. For this caller, my patch is definitely an improvement.

For 1) and 2), we are adding a specific path, so we should test in the
caller whether that specific path was successfully added, and fail
otherwise. Would that address your concern?

Regards,
Martin

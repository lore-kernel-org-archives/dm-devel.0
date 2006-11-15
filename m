From: Dave Wysochanski <dave.wysochanski@redhat.com>
Subject: RE: patch to discovery.c to still get
	pathpriorityforpaths with path state of PATH_DOWN
Date: Wed, 15 Nov 2006 15:28:35 -0500
Message-ID: <1163622515.5844.4.camel@linux-cxyg.rtp.netapp.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1552@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1552@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

On Wed, 2006-11-15 at 14:48 -0500, Edward Goggin wrote:
> On Wednesday, November 15, 2006 1:49 AM, Dave Wysochanski wrote
> 
> > One other thought I had was the notion of a "priority valid" 
> > flag (or a
> > special priority value) in the path for the case of 
> > group_by_prio.  Set
> > it to invalid in alloc_path(), then just don't add the path to the
> > multipath struct in coalesce_paths() if the priority value 
> > was invalid.
> > Then over in checkerloop(), add the path to the multipath map when you
> > get a valid priority.
> > 
> > It is more complicated than that I'm sure (e.g. checkerloop() assumes
> > pp->mpp is non-null in places, etc) but seemed like a half-decent
> > approach to at least consider.
> > 
> > This approach doesn't take into consideration the general case of a
> > change in path priority though.
> 
> I very much like the first part of your "priority valid" idea
> mentioned above.
> 
> I've enclosed a patch for the first part of your idea.  The patch
> should address the concern you had about recalculating priority
> for a path when its path state changes from not PATH_DOWN to
> PATH_DOWN.  It now only retrieves the priority for PATH_DOWN
> paths if the path's priority has never been successfully
> retrieved before.
> 
Great.  Your patch looks fine.

> I've punted for now on the reloading of the map if a path priority
> change has caused a path group membership change.  This is kind of
> complex, has lots of down sides, and there doesn't seem to be a
> need for it as of now.

Sure that's fine.  That would be extreme and I'm all for simplicity.

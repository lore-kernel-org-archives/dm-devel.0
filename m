From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH]multipath-tools: prevent unnecessary
 reinstate of stand-by paths with implicit tpgs mode and no active array
 paths.
Date: Fri, 26 Feb 2016 12:55:35 -0600
Message-ID: <20160226185535.GD2915@octiron.msp.redhat.com>
References: <065E3B7B-8F7D-48D9-BCB9-DFE13F8F3923@nimblestorage.com>
	<20160225204953.GA2915@octiron.msp.redhat.com>
	<D2F4DA4B.879E%Shiva.Krishna@nimblestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D2F4DA4B.879E%Shiva.Krishna@nimblestorage.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shiva Krishna <Shiva.Krishna@nimblestorage.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 26, 2016 at 12:32:51AM +0000, Shiva Krishna wrote:
> 
> 
> On 2/25/16, 12:49 PM, "Benjamin Marzinski" <bmarzins@redhat.com> wrote:
> 
> >On Sat, Feb 20, 2016 at 08:23:29PM +0000, Shiva Krishna wrote:
> >
> >I understand your problem, but this isn't the right patch to fix it. For
> >one this check
> >
> >+		if (newstate != PATH_GHOST || pp->mpp->nr_active > 0 ||
> >+		    pp->tpgs != TPGS_IMPLICIT) {
> >
> >is pretty problematic.  Every path that isn't alua or doesn't enable
> >detect_prio will have pp->tpgs != TPGS_IMPLICIT (because this will be
> >zeroed out on path creation for all paths, and TPGS_IMPLICIT == 0x1). If
> >you need special handling for PATH_GHOST, and you don't want to copy and
> >modify an existing checker, then you should probably go with a config
> >option to enable this on your device, perhaps ghost_is_standby.  Then
> >you (and anyone else who needs this) can set that in your builtin device
> >config, and you don't need to try to craft a complicated check to get
> >this right.
> That was exactly my intention. To allow reinstate in all those cases and
> prevent this only if pp->tpgs == TPGS_IMPLICIT. Even if we add a new config
> parameter to avoid this, I think a check like this is still needed, because
> Even if ghost is stand-by we want reinstate when there are other active
> paths
> present in the map. That is to get them out of the failed state. My
> intention
> was to keep them failed as long as there are no active paths
> present/discovered.

I have no objection to the (pp->mpp->nr_active > 0) check.  My point is
that with your code (pp->tpgs != TPGS_IMPLICT) does not correctly weed
out the implicit alua paths.  Since you set pp->tpgs in detect_prio, all
implict alua devices that don't use detect_prio (and this is most of
them), will not have pp->tpgs set to TPGS_IMPLICIT. I also wonder if
this way of dealing with PATH_GHOST paths would be useful to other
device setups, not just ones where you have standby paths with implicit
alua. In this case, making it a seperate config option would make it
available to any device. If this is really only useful for this specific
case, then I'm not against doing some alua specific checks in
select_prio.

-Ben

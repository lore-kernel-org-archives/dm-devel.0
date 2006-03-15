From: egoggin@emc.com
Subject: RE: path group failback
Date: Wed, 15 Mar 2006 11:06:37 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B104@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Monday, March 13, 2006 12:18 PM, Christophe Varoqui wrote

> > > In such a scenario, wouldn't the priorizer catch priority 
> changes ?
> > 
> > No, not necessarily, and certainly not for CLARiiON.  None of these
> > 3 use cases involves changing which path group is the 
> highest priority
> > path group so each path in the 2 groups continue to have the same
> > priority as before the externally initiated change of the 
> active path
> > group.  For each use case, only the identity of the active 
> path group
> > has been changed.
> > 
> I guess the priorizer *should* catch priority changes ...

> > > 
> > > ie, paths to owning SP are heavier than paths to not owning SP, so
> > > changing the owning SP in navisphere would shuffle the path group
> > > priorites.
> > 
> > CLARiiON path priority is dependent solely on 2 factors -- (1) the
> > path must be active (or ghost) and (2) the path must connect to its
> > logical unit's "default" (not necessarily active) owning service
> > processor.
> > 
> > > 
> > > If it is the case I would imagine the failback target to be the
> > > externally designated one, which seems right.
> > 
> > No.  The CLARiiON's highest priority path group is defined to be
> > the default owning service processor instead of the active service
> > processor (they may or may not be the same at any given instant)
> > in order to maintain the manually established distribution of
> > logical units across the 2 service processors.
> > 
> Would it be unreasonable to teach the prioritizer about this case ?

This will be difficult if not unreasonable.  We don't want to blindly
have the priority follow the currently active path group.  Doing so
will eliminate the ability to maintain the statically assigned balance
of logical units to SCSI targets.  I find it difficult to believe that
the CLARiiON is the only case of this issue given the 5 active/passive
arrays listed in libmultipath/hwtable.c that have both priority based
path group membership and immediate path group failback configured.

Ideally we would be able to differentiate an externally initiated path
group switch from an internal one.  This will be difficult without
some kernel changes to the EMC hardware handler and more involved changes
to multipathd which I wanted to avoid proposing.

The prioritizer interface does not facilitate state maintenance which
I think would be needed to make an intelligent decision about what to
do.  This would be state like path active/failed state for each path
and the total number of paths and path groups for each mapped device.
Since multipathd already tracks this state, it seems reasonable to have
this logic enforced within a path group failback mode -- especially if
it is an issue common to other arrays in addition to CLARiiON.

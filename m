From: egoggin@emc.com
Subject: path group failback
Date: Mon, 13 Mar 2006 10:37:28 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B0E4@SRMANNING.eng.emc.com>
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

On Monday, March 13, 2006 8:53 AM cvaroqui@averon.dyndns.org wrote

> > (4) The patch contains several changes in order to minimize 
> the number of
> > events that will cause a failback to a device's highest 
> priority path group.
> > The major
> > reason to do this is to minimize the likelihood of changing 
> the currently
> > active path group for an active/passive storage system back 
> to the highest
> > priority path
> > group if a path group which is not the highest priority 
> path group has been
> > made the active path group by means external to the 
> multipathing software on
> > that host.
> > This could be done by SAN storage management software running on a
> > management station, storage array software, or by the 
> multipathing software
> > running on
> > a peer host in a cluster.  Whenever this happens, it is best for the
> > multipathing software to not change the active path group 
> (back to the
> > highest priority one for
> > instance) unless absolutely necessary, e.g., all paths in 
> the non-default
> > path group are failed.
> > 
> > It will be significantly difficult to eliminate all 
> unnecessary failbacks
> > without kernel changes and more upheaval to the failback 
> mechanism.  I'm
> > thinking that this compromise solution is sufficient.
> > 
> > (a) The path priority refresh code in checkerloop in 
> multipathd now checks
> > if a path group failback needs to happen IFF the path's priority has
> > actually changed.
> > 
> > (b) If update_multipath sees that a path's dmstate is down 
> and that the user
> > multipath state does not reflect this, update_multipath now 
> calls the path
> > checker for the path to verify the path's state instead of 
> simply marking
> > the user multipath state as down.  If the path tests 
> successfully, the
> > dmstate for
> > the path is reinstated.  This is particularly useful for 
> the active/passive
> > storage systems (which are not making use of the ghost path 
> state keeping)
> > where
> > an IO has failed due to the fact that what had previously 
> been an active
> > path has been changed to an passive path by external means. 
>  The path's
> > state
> > (user and kernel) is still active in this case.
> > 
> > (c) There is a new path group failback option 
> FAILBACK_IMMEDIATE_AND_FOLLOW
> > and it is set this up as the default for the clariion.  The 
> difference
> > between
> > FAILBACK_IMMEDIATE_AND_FOLLOW and FAILBACK_IMMEDIATE is that
> > FAILBACK_IMMEDIATE_AND_FOLLOW will only failback to the 
> highest priority
> > path group when the highest priority path group transitions 
> from having no
> > active paths to having a single active path.
> > 
> I'm still strugling to understand what this new mode does.
> If you can help with an example, I'd appreciate :/

I'm sorry for the confusion.  I was not clear as to the purpose.
The purpose is to only do "automatic" failback when the active path
group was "automatically" changed from the highest priority path
group.

At a more detailed level, the purpose of this new mode is to
restrict the use cases where automatic path group failback is
applied to the two events which resolve the conditions under
which the active path group is automatically changed away from
the highest priority path group in the first place.  To the best
of my knowledge these events are (1) a change in some path's
priority leading to a change in which path group is now the
highest priority path group and (2) a failure of all paths in
the default path group leading to a failover induced change of
the active path group away from the highest priority path group.

I am assuming that all other cases of having the active path
group changed to not be the default path group are externally
(external to the dm-multipathing code on this host) initiated
and should therefore be externally failed back to the default
path group.  The current time based alternatives (none,
immediate, or deferred) do not satisfy these goals.

I'll reference a CLARiiON for the example use case but I think
the mode could apply universally to lots of the active/passive
arrays.

An example of this would be having the active path group for a
CLARiiON logical unit changed from its highest priority path
group (its default owning CLARiiON service processor) to the
other path group (the passive CLARiiON service processor) via 
Navisphere, the CLARiiON SAN management utility.  Without this
change, the multipathd process will failback to the logical unit's
highest priority path group within 5 seconds (or the deferred
fail back timeout if one was to be configured).

Other use cases for the CLARiiON involve a multi-node cluster where
one of the nodes initiates a failover of a logical unit to its
non-default path group (due to an all-paths-down use case) while
all other nodes in the cluster insist on automatically failing the
logical unit back to its highest priority path group.  Another use
case comes about in a remote replication use case at the array level
where a failover of a logical unit to its non-default path group
(due to an all-paths-down use case at the local site) will be
defeated (remote mirror must be located on same (default or
non-default) path group at both sites) at the remote site by the
multipathd automatic path group failback.

The multipathd should not be doing path group failback at all in
these cases and it is not sufficient to just setup a long deferred
time for the failback.  Yet, it is also desirable for multipathd
to immediately failback a CLARiiON logical unit whenever the first
path in the default path group tests successfully after all paths
in that path group have failed.  This is the case where one or
more paths in the highest priority path group have been restored
after a failure of all of these paths.

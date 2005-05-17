From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [RFC] multipathd recent evolutions
Date: Wed, 18 May 2005 00:28:59 +0200
Message-ID: <1116368939.9352.86.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Well, the git HEAD has seen quite a lot of multipathd structural changes
recently. It has come to a point where I would like to collect reviews
and opinions about the direction I'm heading to.

These directions are :

1) suppress the multipath -> multipathd signaling

Replaced by a uevent listener in the daemon which gathers events at the
source, benefiting from full info rather than a generic signal.

The listener reacts on 4 event types :

o path add : start checking this path
o path remove : stop checking this path
o multipath map add : start listening to DM events for that map
o multipath map remove : stop listening to DM events for that map

This new model brings a lot of clean ups at the code level too :

o kill all inter thread signaling
o kill the wait_thr altogether, with all its waiter vector housekeeping,
since DM event waiter thread data blobs are now embedded into struct
multipath

2) suppress all multipath configurator execs from the daemon.

The daemon is now a lot more predictable, as we now for sure it can only
reinstate path or switch group. The daemon can no longer be responsible
for a map reload.

As a result, the reinstate code path, now being fork/exec-free, can now
be fine tuned as a critical path for "return to service in adverse
situation" scenarii.

The checker logic now is : upon path state change from "down" to "up" 

o reinstate the path
o if daemon driven failback is selected, compute the path groups prio
and do the failback. Deffered failback was asked by Lars and could be
added quite easily now.


That's it. I expect there will be some glitchs here and there, but the
HEAD is quite stable for me in ISCSI testing/torturing.

Hope to receive sizeable reviews and comments.

PS: Edward, Dave, I updated
http://christophe.varoqui.free.fr/graphics/macroflux.png to reflect
these changes if you are interested in merging it in the OLS paper.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

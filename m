From: "goggin, edward" <egoggin@emc.com>
Subject: pg failback
Date: Mon, 20 Jun 2005 14:05:28 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AAD9@SRMANNING.eng.emc.com>
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Two things with path group failback seem flawed right now.

(1) Looks like it might be possible for a currently disabled path group
which is not the highest priority path group to remain disabled even
when paths in the group test successfully.  This seems to be possible
because the code in switch_pathgroup() called by checkerloop() in
multipathd only fails back to the highest priority path group.  Granted
that the problem is primarily (__only__) cosmetic since the other group(s)
are not being actively used anyway, but it is still misleading to a viewer
of
"multipath -l" to see disabled path groups which should not be in this
state.

(2) Seems to me that currently disabled path groups should be enabled
before switching to one anyway.  Doing so will enable the kernel code to
simply
reenable a group without initiating a pg_init of "a possibly newly
determined"
highest priority path group as is currently done.  Instead, as a performance
Improvement over the way things are now, the multipathd code can reenable
path
groups as need be, and only initiate a switch path group when it determines
that this is necessary.

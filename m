From: "goggin, edward" <egoggin@emc.com>
Subject: RE: [RFC][mpath-tools] path info cache
Date: Wed, 3 Aug 2005 10:07:14 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ABA3@SRMANNING.eng.emc.com>
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

On Fri, 22 Jul 2005 00:02:57 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote

> I just merged a quite invasive patch that needs commenting.
> 
> The patch explore a new solution to /sbin/multipath inefficiency wrt
> systems with lots of paths.
> 
> What did we have :
> ==================
> The previous attempt was the cache file plus hot/cold policy, 
> which was
> suboptimal in many ways :
> 
> - hard to get the security right
> - early userspace annoyances wrt umounted FS
> - needs to allocate a few bytes on FS
> - the 5 seconds hot to cold policy is not adequate for everyone (see
> recent Adic post)
> - hard to settle on an a consensual FS location for the file
> 
> 
> The proposed solution is : "/sbin/multipath asks the path cache to
> multipathd through its unix socket" (the same used for the CLI).
> When the ademon doesn't run, multipath has to do a full rescan.
> 
> What do we get :
> ================
> - security is easy
> - no more FS allocation to satisfy

> - The daemon has its pathvec always up-to-date, thanks to its
> event-driven model. No more hot/cold policy.

Sounds like a big win for multipath(8), both in terms of
device coherency and performance on large SANs.  Although,
you must now maintain both the slow and fast device discovery
code paths.

Also, this will increase the need to have the device portion
of the event-driven model work correctly, since simply
invoking multipath(8) will no longer simply restore paths
for which multipathd has no knowledge.  May want to have a
way to manually poke multipathd to get it to re-evaluate its
device configuration from scratch without having to simply
kill and restart it.  May have this feature already with the
UNIX domain socket interface.

> 
> What should be debated :
> ========================
> - settle on a FS socket location (currently 
> /var/cache/multipath/uxsock)
> - people who care about early userspace have now 2 options :
> 
> 	- No daemon in early userspace, and disable hotplug-triggered
> 	  multipath. /sbin/multipath is ran once.
> 
> 	- Start the daemon in early userspace, let multipath be
> 	  hotplug-triggered

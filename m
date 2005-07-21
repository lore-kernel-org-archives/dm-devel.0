From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [RFC][mpath-tools] path info cache
Date: Fri, 22 Jul 2005 00:02:57 +0200
Message-ID: <1121983377.19015.103.camel@zezette>
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

I just merged a quite invasive patch that needs commenting.

The patch explore a new solution to /sbin/multipath inefficiency wrt
systems with lots of paths.

What did we have :
==================
The previous attempt was the cache file plus hot/cold policy, which was
suboptimal in many ways :

- hard to get the security right
- early userspace annoyances wrt umounted FS
- needs to allocate a few bytes on FS
- the 5 seconds hot to cold policy is not adequate for everyone (see
recent Adic post)
- hard to settle on an a consensual FS location for the file


The proposed solution is : "/sbin/multipath asks the path cache to
multipathd through its unix socket" (the same used for the CLI).
When the ademon doesn't run, multipath has to do a full rescan.

What do we get :
================
- security is easy
- no more FS allocation to satisfy
- The daemon has its pathvec always up-to-date, thanks to its
event-driven model. No more hot/cold policy.

What should be debated :
========================
- settle on a FS socket location (currently /var/cache/multipath/uxsock)
- people who care about early userspace have now 2 options :

	- No daemon in early userspace, and disable hotplug-triggered
	  multipath. /sbin/multipath is ran once.

	- Start the daemon in early userspace, let multipath be
	  hotplug-triggered



Comments and critics are welcome.
Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

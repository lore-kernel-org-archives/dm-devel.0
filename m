From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm multipath kernel driver version too old - 2.6.32
Date: Fri, 1 Jan 2010 19:24:20 -0500
Message-ID: <20100102002420.GA25814@redhat.com>
References: <1262246366.8333.13.camel@jaspav.ssiservices.biz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1262246366.8333.13.camel@jaspav.ssiservices.biz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Thu, Dec 31 2009 at  2:59am -0500,
John A. Sullivan III <jsullivan@opensourcedevel.com> wrote:

> Hello, all.  We are attempting to upgrade our kernel on our VServer
> hosts from 2.6.28 to 2.6.32.1.  After some initial grief, we thought we
> were successful until multipath kicked in and we received an error
> message:
> 
> DM multipath kernel driver version too old
> 
> In the RAID and LVM section of our kernel configuration, we have enabled
> Multipath I/O support.  We have then created modules for Multipath
> target and both I/O Path Selectors (in-flight I/Os and service time).
> 
> We are running fully patched CentOS 5.4.  What have we done wrong?
> Thanks - John

Linux >= 2.6.31 has a DM multipath target version that was bumped to >=
1.1.0 (for request-based multipath et al).

The device-mapper-multipath in 5.4 has:
multipath/main.c:     if (dm_prereq(DEFAULT_TARGET, 1, 0, 3))

But 5.4's dm_prereq() is too simplistic to handle the higher DM target
version numbers that Linux >= 2.6.31 has for the DM multipath target.

Upstream multipath-tools can handle the newer DM target versions
properly.  5.4's device-mapper-multipath-tools can be patched with
something like the following (note this is white-space damaged, but you
get the idea):

@@ -107,10 +107,10 @@ dm_prereq (char * str, int x, int y, int z)
 
                if (!strncmp(str, target->name, strlen(str))) {
                        r--;
-                       
-                       if (target->version[0] >= x &&
-                           target->version[1] >= y &&
-                           target->version[2] >= z)
+
+                       if ((target->version[0] > x) ||
+                           ((target->version[0] ==  x) && (target->version[1] > y)) ||
+                           ((target->version[0] == x) && (target->version[1] == y) && (target->version[2] >= z)))
                                r--;

			break;

But again: upstream multipath-tools already has a nicer fix.

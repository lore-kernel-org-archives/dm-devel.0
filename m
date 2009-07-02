From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: [RFC] directio and aio-max-nr
Date: Thu, 02 Jul 2009 18:12:19 +0100
Message-ID: <1246554739.20189.156.camel@breeves.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-SrrbIBgyDIloVKhLrnxz"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-SrrbIBgyDIloVKhLrnxz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The number of available aio contexts is limited by the fs.aio-max-nr
sysctl. This means it's possible for the io_setup() call that the
directio path checker uses in its libcheck_init() to fail with EAGAIN if
there are already aio-max-nr outstanding event contexts allocated.

On a system with several users of the aio interface it's possible for
this to happen, e.g. when running multipath -ll, leading to output like
this:

sdb: ownership set to 200a0d1c5f449bf01
sdb: not found in pathvec
sdb: mask = 0xc
sdb: path checker = directio (config file default)
io_setup failed
sda: ownership set to 200a0d1c5f449bf01
sda: not found in pathvec
sda: mask = 0xc
sda: path checker = directio (config file default)
io_setup failed
[...]
create: 200a0d1c5f449bf01 n/a Inventec,IX3150-FS200
[size=1.6T][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:0:0 sdb 8:16  [undef][faulty]
\_ round-robin 0 [prio=0][undef]
 \_ 0:0:0:0 sda 8:0   [undef][faulty]

There's nothing wrong with the paths but since the checker cannot
allocate an aio context it is unable to determine the path status and
reports them as faulty.

Of course, the administrator should be monitoring the use of aio on the
system and setting fs.aio-max-nr to an appropriate value but we're
seeing quite frequent reports of this problem (particularly for Oracle
users with NetApp storage as the NetApp defaults to the directio
checker) and the use of aio by the directio checker is not currently
documented.

I think it's worth documenting this interaction in the FAQ (patch
attached). It think it may also be worth trying to make this more robust
or at least warning the administrator of the problem.

So far, the reports I've seen of this problem have affected users
running multipath -ll manually since this will create new checkers for
each path. Since multipathd starts before most aio-using applications
will start it's able to grab the contexts that it needs. In principal
though it would be possible for multipathd to run into problems if for
e.g. a user added new storage to the system post-boot.

In this situation I'm not sure if it's best to keep trying to allocate
an aio context indefinitely in the checker thread or to fail immediately
and warn the administrator of the situation?

Regards,
Bryn.


--=-SrrbIBgyDIloVKhLrnxz
Content-Disposition: attachment; filename=document-aio-max-nr-in-FAQ.patch
Content-Type: message/rfc822; name=document-aio-max-nr-in-FAQ.patch

From: Bryn M. Reeves <bmr@redhat.com>
Date: Thu, 2 Jul 2009 16:39:31 +0100
Subject: [PATCH] Document aio-max-nr in FAQ
Message-Id: <1246551173.20189.152.camel@breeves.fab.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

The fs.aio-max-nr parameter interacts with the directio path checker
and other users of the aio interfaces on the system. Document the
parameter and the errors seen when it is set too low in the FAQ.
---
 FAQ |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/FAQ b/FAQ
index 35dc2f9..5ceb32b 100644
--- a/FAQ
+++ b/FAQ
@@ -63,3 +63,34 @@ current/default config like so:
 lvm dumpconfig > /etc/lvm/lvm.conf
 
 (tip from Christophe Saout)
+
+4. I see a lot of "io_setup failed" message using the directio checker
+======================================================================
+
+The directio path checker makes use of the asynchronous I/O API (aio) provided
+by modern Linux systems. Asynchronous I/O allows an application to submit I/O
+requests asynchronously and be notified later of their completion status. To
+allow this, we must allocate an asynchronous I/O context (an object of type
+aio_context_t) and this task is handled by the io_setup system call.
+
+A system wide limit on the number of AIO contexts that may be active
+simultaneously is imposed via the aio-max-nr sysctl parameter.
+
+Once this limit has been reached further calls to io_setup will fail with the
+error number EAGAIN leading to the "io_setup failed" messages seen for e.g. when
+running "multipath -ll".
+
+To avoid this problem the number of available aio contexts should be increased
+by setting the aio-max-nr parameter. This can be set on a one-time basis via the
+/proc file system, for e.g.:
+
+        # echo 131072 > /proc/sys/fs/aio-max-nr
+
+Doubles the number of available contexts from the default value of 65536.
+
+To make this setting persistent a line may be added to /etc/sysctl.conf:
+
+        fs.aio-max-nr = 131072
+
+Consult appropriate application and operating system tuning recommendations for
+guidance on appropriate values for this parameter.
-- 
1.6.0.6


--=-SrrbIBgyDIloVKhLrnxz
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-SrrbIBgyDIloVKhLrnxz--

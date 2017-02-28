From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 16/33] multipath: ignore -i if find_multipaths is
	set
Date: Tue, 28 Feb 2017 17:23:12 +0100
Message-ID: <20170228162329.14517-17-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

multipath's logic for detecing new multipath devices with find_multipaths
currently doesn't work reliably. If paths for a new device are added
sequentially, the first one will be classified as non-multpath (and passed on
to systemd for further processing) while subsequent ones will be seen as
multipath devices. If the paths are added simultaneously (such as at udev
trigger time after switching from the initrd to the rootfs, if device
detection is already finished), whether or not additional paths will be seen
when the udev rules for a given paths are processed is random.
A proper implementation of this device detection would require some sort of
information passing between multipathd and multipath, timeouts waiting for
additional paths to appear when a single one is detected, retriggering of
uevents if the status of a given paths changes, and more fine-grained
treatment of "orphaned" paths in multipathd. All of that is currently
non-existent.

Currently, our only option is to rely on the wwids file for device setup with
find_multipaths. In practice, that means that multipath maps will only be
set up for such devices that have been set up manually by the user before.
This is the behavior of multipath [-c|-u] without the "-i" option.

But "-i" is useful for the !find_multipaths case, where the expectation is
that all non-blacklisted devices are multipathed by default. Because we
can't change the multipath invocation in the udev rules file
depending on the find_multipaths setting, just ignore "-i" if find_multipaths
is set.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index 8ce87a08..ed57135a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -619,6 +619,16 @@ main (int argc, char *argv[])
 		}
 	}
 
+	/*
+	 * FIXME: new device detection with find_multipaths currently
+	 * doesn't work reliably.
+	 */
+	if (cmd ==  CMD_VALID_PATH &&
+	    conf->find_multipaths && conf->ignore_wwids) {
+		condlog(2, "ignoring -i flag because find_multipath is set in multipath.conf");
+		conf->ignore_wwids = 0;
+	}
+
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
 		exit(1);
-- 
2.11.0

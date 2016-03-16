From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 5/5] dm: Update dm-uevent.txt
Date: Wed, 16 Mar 2016 16:27:47 -0700
Message-ID: <1458170867-429-6-git-send-email-agrover@redhat.com>
References: <1458170867-429-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1458170867-429-1-git-send-email-agrover@redhat.com>
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

Document the current dm uevent API, as modified by this patchset.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 Documentation/device-mapper/dm-uevent.txt | 48 ++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/Documentation/device-mapper/dm-uevent.txt b/Documentation/device-mapper/dm-uevent.txt
index 07edbd85..ee6610e 100644
--- a/Documentation/device-mapper/dm-uevent.txt
+++ b/Documentation/device-mapper/dm-uevent.txt
@@ -1,18 +1,52 @@
 The device-mapper uevent code adds the capability to device-mapper to create
 and send kobject uevents (uevents).  Previously device-mapper events were only
-available through the ioctl interface.  The advantage of the uevents interface
-is the event contains environment attributes providing increased context for
+available through the ioctl interface.  The advantages of the uevents interface
+are the event contains environment attributes providing increased context for
 the event avoiding the need to query the state of the device-mapper device after
-the event is received.
+the event is received, and uevents are poll()-able in userspace, whereas the
+ioctl event interface is not.
 
-There are two functions currently for device-mapper events.  The first function
-listed creates the event and the second function sends the event(s).
+There are five functions DM targets should use.
 
-void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
-                    const char *path, unsigned nr_valid_paths)
+struct dm_uevent *dm_build_uevent(struct mapped_device *md,
+					 struct dm_target *ti,
+					 enum kobject_action action,
+					 const char *dm_action)
+
+Construct a dm uevent.
+
+int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
+
+Optionally add event-specific data to the generated uevent. e.g. dm-mpath's
+PATH_FAILED and PATH_REINSTATED uevents add path and number-of-remaining-paths
+vars.
+
+void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
+
+Hand off the uevent to the device's list of pending events.
+
+void dm_uevent_free(struct dm_uevent *event)
+
+Something went wrong, free the uevent instead of queueing it.
+
+void dm_table_event(struct dm_table *t)
+
+Triggers sending of queued uevents as well as waking up processes waiting on
+the ioctl.
+
+
+The device-mapper uevent code also supplies three functions for device-mapper core
+to call:
+
+int dm_uevent_init(void)
+void dm_uevent_exit(void)
+
+Setup and teardown.
 
 void dm_send_uevents(struct list_head *events, struct kobject *kobj)
 
+Actually send the uevents (called indirectly from dm_table_event, above).
+
 
 The variables added to the uevent environment are:
 
-- 
2.5.0

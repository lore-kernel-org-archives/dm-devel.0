From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/6] multipath: add comments
Date: Thu, 29 Mar 2018 22:36:59 -0500
Message-ID: <1522381023-15262-3-git-send-email-bmarzins@redhat.com>
References: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This commit simply adds a number of comments based on suggestions by
Martin Wilck.

Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/dmevents.c |  4 ++-
 tests/dmevents.c      | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 tests/util.c          |  2 ++
 3 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 2281a10..0b0d0ce 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -122,6 +122,8 @@ static int arm_dm_event_poll(int fd)
 	dmi.version[0] = DM_VERSION_MAJOR;
 	dmi.version[1] = DM_VERSION_MINOR;
 	dmi.version[2] = DM_VERSION_PATCHLEVEL;
+	/* This flag currently does nothing. It simply exists to
+	 * duplicate the behavior of libdevmapper */
 	dmi.flags = 0x4;
 	dmi.data_start = offsetof(struct dm_ioctl, data);
 	dmi.data_size = sizeof(dmi);
@@ -189,7 +191,7 @@ fail:
 	return -1;
 }
 
-/* You must call update_multipath() after calling this function, to
+/* You must call __setup_multipath() after calling this function, to
  * deal with any events that came in before the device was added */
 int watch_dmevents(char *name)
 {
diff --git a/tests/dmevents.c b/tests/dmevents.c
index 4442fc2..bba51dc 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -33,10 +33,13 @@
 /* I have to do this to get at the static variables */
 #include "../multipathd/dmevents.c"
 
+/* pretend dm device */
 struct dm_device {
 	char name[WWID_SIZE];
+	/* is this a mpath device, or other dm device */
 	int is_mpath;
 	uint32_t evt_nr;
+	/* tracks the event number when the multipath device was updated */
 	uint32_t update_nr;
 };
 
@@ -48,6 +51,9 @@ struct test_data {
 
 struct test_data data;
 
+/* Add a pretend dm device, or update its event number. This is used to build
+ * up the dm devices that the dmevents code queries with dm_task_get_names,
+ * dm_geteventnr, and dm_is_mpath */
 int add_dm_device_event(char *name, int is_mpath, uint32_t evt_nr)
 {
 	struct dm_device *dev;
@@ -77,6 +83,7 @@ int add_dm_device_event(char *name, int is_mpath, uint32_t evt_nr)
 	return 0;
 }
 
+/* helper function for pretend dm devices */
 struct dm_device *find_dm_device(const char *name)
 {
 	struct dm_device *dev;
@@ -88,6 +95,7 @@ struct dm_device *find_dm_device(const char *name)
 	return NULL;
 }
 
+/* helper function for pretend dm devices */
 int remove_dm_device_event(const char *name)
 {
 	struct dm_device *dev;
@@ -103,6 +111,7 @@ int remove_dm_device_event(const char *name)
 	return -1;
 }
 
+/* helper function for pretend dm devices */
 void remove_all_dm_device_events(void)
 {
 	struct dm_device *dev;
@@ -122,7 +131,9 @@ static inline void *align_ptr(void *ptr)
 	return (void *)align_val((size_t)ptr);
 }
 
-/* copied off of list_devices in dm-ioctl.c */
+/* copied off of list_devices in dm-ioctl.c except that it uses
+ * the pretend dm devices, and saves the output to the test_data
+ * structure */
 struct dm_names *build_dm_names(void)
 {
 	struct dm_names *names, *np, *old_np = NULL;
@@ -199,12 +210,16 @@ int __wrap_open(const char *pathname, int flags)
 	return mock_type(int);
 }
 
+/* We never check the result of the close(), so there's no need to
+ * to mock a return value */
 int __wrap_close(int fd)
 {
 	assert_int_equal(fd, waiter->fd);
 	return 0;
 }
 
+/* the pretend dm device code checks the input and supplies the
+ * return value, so there's no need to do that here */
 int __wrap_dm_is_mpath(const char *name)
 {
 	struct dm_device *dev;
@@ -216,6 +231,8 @@ int __wrap_dm_is_mpath(const char *name)
 	return 0;
 }
 
+/* either get return info from the pretend dm device, or
+ * override it to test -1 return */
 int __wrap_dm_geteventnr(const char *name)
 {
 	struct dm_device *dev;
@@ -257,6 +274,8 @@ int __wrap_dm_task_run(struct dm_task *dmt)
 	return mock_type(int);
 }
 
+/* either get return info from the pretend dm device, or
+ * override it to test NULL return */
 struct dm_names * __wrap_dm_task_get_names(struct dm_task *dmt)
 {
 	int good = mock_type(int);
@@ -299,6 +318,9 @@ void __wrap_remove_map_by_alias(const char *alias, struct vectors * vecs,
 	assert_int_equal(purge_vec, 1);
 }
 
+/* pretend update the pretend dm devices. If fail is set, it
+ * simulates having the dm device removed. Otherwise it just sets
+ * update_nr to record when the update happened */
 int __wrap_update_multipath(struct vectors *vecs, char *mapname, int reset)
 {
 	int fail;
@@ -325,6 +347,9 @@ int __wrap_update_multipath(struct vectors *vecs, char *mapname, int reset)
 	return fail;
 }
 
+/* helper function used to check if the dmevents list of devices
+ * includes a specific device. To make sure that dmevents is
+ * in the correct state after running a function */
 struct dev_event *find_dmevents(const char *name)
 {
 	struct dev_event *dev_evt;
@@ -336,14 +361,19 @@ struct dev_event *find_dmevents(const char *name)
 	return NULL;
 }
 
+/* null vecs pointer when initialized dmevents */
 static void test_init_waiter_bad0(void **state)
 {
+	/* this boilerplate code just skips the test if
+	 * dmevents polling is not supported */
 	struct test_data *datap = (struct test_data *)(*state);
 	if (datap == NULL)
 		skip();
+
 	assert_int_equal(init_dmevent_waiter(NULL), -1);
 }
 
+/* fail to open /dev/mapper/control */
 static void test_init_waiter_bad1(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -354,6 +384,7 @@ static void test_init_waiter_bad1(void **state)
 	assert_ptr_equal(waiter, NULL);
 }
 
+/* waiter remains initialized after this test */
 static void test_init_waiter_good0(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -364,6 +395,7 @@ static void test_init_waiter_good0(void **state)
 	assert_ptr_not_equal(waiter, NULL);
 }
 
+/* No dm device named foo */
 static void test_watch_dmevents_bad0(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -373,6 +405,7 @@ static void test_watch_dmevents_bad0(void **state)
 	assert_ptr_equal(find_dmevents("foo"), NULL);
 }
 
+/* foo is not a multipath device */
 static void test_watch_dmevents_bad1(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -384,6 +417,7 @@ static void test_watch_dmevents_bad1(void **state)
 	assert_ptr_equal(find_dmevents("foo"), NULL);
 }
 
+/* failed getting the dmevent number */
 static void test_watch_dmevents_bad2(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -396,6 +430,8 @@ static void test_watch_dmevents_bad2(void **state)
 	assert_int_equal(watch_dmevents("foo"), -1);
 	assert_ptr_equal(find_dmevents("foo"), NULL);
 }
+
+/* verify that you can watch and unwatch dm multipath device "foo" */
 static void test_watch_dmevents_good0(void **state)
 {
 	struct dev_event *dev_evt;
@@ -407,16 +443,20 @@ static void test_watch_dmevents_good0(void **state)
 	assert_int_equal(add_dm_device_event("foo", 1, 5), 0);
 	will_return(__wrap_dm_geteventnr, 0);
 	assert_int_equal(watch_dmevents("foo"), 0);
+	/* verify foo is being watched */
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
 	assert_int_equal(dev_evt->evt_nr, 5);
 	assert_int_equal(dev_evt->action, EVENT_NOTHING);
 	assert_int_equal(VECTOR_SIZE(waiter->events), 1);
 	unwatch_dmevents("foo");
+	/* verify foo is no longer being watched */
 	assert_int_equal(VECTOR_SIZE(waiter->events), 0);
 	assert_ptr_equal(find_dmevents("foo"), NULL);
 }
 
+/* verify that if you try to watch foo multiple times, it only
+ * is placed on the waiter list once */
 static void test_watch_dmevents_good1(void **state)
 {
 	struct dev_event *dev_evt;
@@ -445,6 +485,7 @@ static void test_watch_dmevents_good1(void **state)
 	assert_ptr_equal(find_dmevents("foo"), NULL);
 }
 
+/* watch and then unwatch multiple devices */
 static void test_watch_dmevents_good2(void **state)
 {
 	struct dev_event *dev_evt;
@@ -480,6 +521,7 @@ static void test_watch_dmevents_good2(void **state)
 	assert_ptr_equal(find_dmevents("bar"), NULL);
 }
 
+/* dm_task_create fails */
 static void test_get_events_bad0(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -493,6 +535,7 @@ static void test_get_events_bad0(void **state)
 	assert_int_equal(dm_get_events(), -1);
 }
 
+/* dm_task_run fails */
 static void test_get_events_bad1(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -505,6 +548,7 @@ static void test_get_events_bad1(void **state)
 	assert_int_equal(dm_get_events(), -1);
 }
 
+/* dm_task_get_names fails */
 static void test_get_events_bad2(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -518,6 +562,7 @@ static void test_get_events_bad2(void **state)
 	assert_int_equal(dm_get_events(), -1);
 }
 
+/* If the device isn't being watched, dm_get_events returns NULL */
 static void test_get_events_good0(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -534,6 +579,11 @@ static void test_get_events_good0(void **state)
 	assert_int_equal(VECTOR_SIZE(waiter->events), 0);
 }
 
+/* There are 5 dm devices. 4 of them are multipath devices.
+ * Only 3 of them are being watched. "foo" has a new event
+ * "xyzzy" gets removed. Nothing happens to bar. Verify
+ * that all the events are properly set, and that nothing
+ * happens with the two devices that aren't being watched */
 static void test_get_events_good1(void **state)
 {
 	struct dev_event *dev_evt;
@@ -577,6 +627,8 @@ static void test_get_events_good1(void **state)
 	assert_int_equal(VECTOR_SIZE(waiter->events), 3);
 }
 
+/* poll does not return an event. nothing happens. The
+ * devices remain after this test */
 static void test_dmevent_loop_bad0(void **state)
 {
 	struct dm_device *dev;
@@ -603,6 +655,7 @@ static void test_dmevent_loop_bad0(void **state)
 	assert_int_equal(dev->update_nr, 5);
 }
 
+/* arm_dm_event_poll's ioctl fails. Nothing happens */
 static void test_dmevent_loop_bad1(void **state)
 {
 	struct dm_device *dev;
@@ -624,6 +677,7 @@ static void test_dmevent_loop_bad1(void **state)
 	assert_int_equal(dev->update_nr, 5);
 }
 
+/* dm_get_events fails. Nothing happens */
 static void test_dmevent_loop_bad2(void **state)
 {
 	struct dm_device *dev;
@@ -646,6 +700,8 @@ static void test_dmevent_loop_bad2(void **state)
 	assert_int_equal(dev->update_nr, 5);
 }
 
+/* verify dmevent_loop runs successfully when no devices are being
+ * watched */
 static void test_dmevent_loop_good0(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -663,6 +719,11 @@ static void test_dmevent_loop_good0(void **state)
 	assert_int_equal(dmevent_loop(), 1);
 }
 
+/* Watch 3 devices, where one device has an event (foo), one device is
+ * removed (xyzzy), and one device does nothing (bar). Verify that
+ * the device with the event gets updated, the device that is removed
+ * gets unwatched, and the device with no events stays the same.
+ * The devices remain after this test */
 static void test_dmevent_loop_good1(void **state)
 {
 	struct dm_device *dev;
@@ -717,6 +778,10 @@ static void test_dmevent_loop_good1(void **state)
 	assert_ptr_equal(find_dm_device("xyzzy"), NULL);
 }
 
+/* watch another dm device and add events to two of them, so bar and
+ * baz have new events, and foo doesn't. Set update_multipath to
+ * fail for baz. Verify that baz is unwatched, bar is updated, and
+ * foo stays the same. */
 static void test_dmevent_loop_good2(void **state)
 {
 	struct dm_device *dev;
@@ -762,6 +827,8 @@ static void test_dmevent_loop_good2(void **state)
 	assert_ptr_equal(find_dm_device("baz"), NULL);
 }
 
+/* remove dm device foo, and unwatch events on bar. Verify that
+ * foo is cleaned up and unwatched, and bar is no longer updated */
 static void test_dmevent_loop_good3(void **state)
 {
 	struct dm_device *dev;
@@ -790,6 +857,8 @@ static void test_dmevent_loop_good3(void **state)
 	assert_ptr_equal(find_dm_device("foo"), NULL);
 }
 
+
+/* verify that rearming the dmevents polling works */
 static void test_arm_poll(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
@@ -799,6 +868,7 @@ static void test_arm_poll(void **state)
 	assert_int_equal(arm_dm_event_poll(waiter->fd), 0);
 }
 
+/* verify that the waiter is cleaned up */
 static void test_cleanup_waiter(void **state)
 {
 	struct test_data *datap = (struct test_data *)(*state);
diff --git a/tests/util.c b/tests/util.c
index e9a004f..113b134 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -74,6 +74,8 @@ static void test_basenamecpy_good5(void **state)
 	assert_string_equal(dst, "bar");
 }
 
+/* multipath expects any trailing whitespace to be stripped off the basename,
+ * so that it will match pp->dev */
 static void test_basenamecpy_good6(void **state)
 {
         char dst[6];
-- 
2.7.4

From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c
Date: 15 Jan 2007 18:58:40 -0000
Message-ID: <20070115185840.31619.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-01-15 18:58:40

Modified files:
	dmeventd       : dmeventd.c 

Log message:
	static naming

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.29&r2=1.30

--- device-mapper/dmeventd/dmeventd.c	2007/01/15 18:21:01	1.29
+++ device-mapper/dmeventd/dmeventd.c	2007/01/15 18:58:40	1.30
@@ -168,36 +168,37 @@
 static LIST_INIT(_thread_registry_unused);
 
 static int _timeout_running;
-static LIST_INIT(timeout_registry);
+static LIST_INIT(_timeout_registry);
 static pthread_mutex_t _timeout_mutex = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t _timeout_cond = PTHREAD_COND_INITIALIZER;
 
 /* Allocate/free the status structure for a monitoring thread. */
-static struct thread_status *alloc_thread_status(struct message_data *data,
-						 struct dso_data *dso_data)
+static struct thread_status *_alloc_thread_status(struct message_data *data,
+						  struct dso_data *dso_data)
 {
 	struct thread_status *ret = (typeof(ret)) dm_malloc(sizeof(*ret));
 
-	if (ret) {
-		if (!memset(ret, 0, sizeof(*ret)) ||
-		    !(ret->device.uuid = dm_strdup(data->device_uuid))) {
-			dm_free(ret);
-			ret = NULL;
-		} else {
-			ret->current_task = NULL;
-			ret->device.name = NULL;
-			ret->device.major = ret->device.minor = 0;
-			ret->dso_data = dso_data;
-			ret->events = data->events.field;
-			ret->timeout = data->timeout.secs;
-			list_init(&ret->timeout_list);
-		}
+	if (!ret)
+		return NULL;
+
+	if (!memset(ret, 0, sizeof(*ret)) ||
+	    !(ret->device.uuid = dm_strdup(data->device_uuid))) {
+		dm_free(ret);
+		return NULL;
 	}
 
+	ret->current_task = NULL;
+	ret->device.name = NULL;
+	ret->device.major = ret->device.minor = 0;
+	ret->dso_data = dso_data;
+	ret->events = data->events.field;
+	ret->timeout = data->timeout.secs;
+	list_init(&ret->timeout_list);
+
 	return ret;
 }
 
-static void free_thread_status(struct thread_status *thread)
+static void _free_thread_status(struct thread_status *thread)
 {
 	dm_free(thread->device.uuid);
 	dm_free(thread->device.name);
@@ -205,7 +206,7 @@
 }
 
 /* Allocate/free DSO data. */
-static struct dso_data *alloc_dso_data(struct message_data *data)
+static struct dso_data *_alloc_dso_data(struct message_data *data)
 {
 	struct dso_data *ret = (typeof(ret)) dm_malloc(sizeof(*ret));
 
@@ -221,7 +222,7 @@
 	return ret;
 }
 
-static void free_dso_data(struct dso_data *data)
+static void _free_dso_data(struct dso_data *data)
 {
 	dm_free(data->dso_name);
 	dm_free(data);
@@ -233,8 +234,7 @@
  */
 /* FIXME? move to libdevmapper to share with the client lib (need to
    make delimiter a parameter then) */
-static const char delimiter = ' ';
-static int fetch_string(char **ptr, char **src)
+static int _fetch_string(char **ptr, char **src, const char delimiter)
 {
 	int ret = 0;
 	char *p;
@@ -262,7 +262,7 @@
 }
 
 /* Free message memory. */
-static void free_message(struct message_data *message_data)
+static void _free_message(struct message_data *message_data)
 {
 	if (message_data->dso_name)
 		dm_free(message_data->dso_name);
@@ -273,7 +273,7 @@
 }
 
 /* Parse a register message from the client. */
-static int parse_message(struct message_data *message_data)
+static int _parse_message(struct message_data *message_data)
 {
 	int ret = 0;
 	char *p = message_data->msg->data;
@@ -286,10 +286,10 @@
 	 * Retrieve application identifier, mapped device
 	 * path and events # string from message.
 	 */
-	if (fetch_string(&message_data->dso_name, &p) &&
-	    fetch_string(&message_data->device_uuid, &p) &&
-	    fetch_string(&message_data->events.str, &p) &&
-	    fetch_string(&message_data->timeout.str, &p)) {
+	if (_fetch_string(&message_data->dso_name, &p, ' ') &&
+	    _fetch_string(&message_data->device_uuid, &p, ' ') &&
+	    _fetch_string(&message_data->events.str, &p, ' ') &&
+	    _fetch_string(&message_data->timeout.str, &p, ' ')) {
 		if (message_data->events.str) {
 			enum dm_event_mask i = atoi(message_data->events.str);
 
@@ -317,18 +317,18 @@
 };
 
 /* Global mutex to lock access to lists et al. */
-static int lock_mutex(void)
+static int _lock_mutex(void)
 {
 	return pthread_mutex_lock(&_global_mutex);
 }
 
-static int unlock_mutex(void)
+static int _unlock_mutex(void)
 {
 	return pthread_mutex_unlock(&_global_mutex);
 }
 
 /* Store pid in pidfile. */
-static int storepid(int lf)
+static int _storepid(int lf)
 {
 	int len;
 	char pid[8];
@@ -348,7 +348,7 @@
 }
 
 /* Check, if a device exists. */
-static int fill_device_data(struct thread_status *ts)
+static int _fill_device_data(struct thread_status *ts)
 {
 	struct dm_task *dmt;
 	struct dm_info dmi;
@@ -391,7 +391,7 @@
  *
  * Mutex must be held when calling this.
  */
-static struct thread_status *lookup_thread_status(struct message_data *data)
+static struct thread_status *_lookup_thread_status(struct message_data *data)
 {
 	struct thread_status *thread;
 
@@ -403,35 +403,35 @@
 }
 
 /* Cleanup at exit. */
-static void exit_dm_lib(void)
+static void _exit_dm_lib(void)
 {
 	dm_lib_release();
 	dm_lib_exit();
 }
 
-static void exit_timeout(void *unused)
+static void _exit_timeout(void *unused)
 {
 	_timeout_running = 0;
 	pthread_mutex_unlock(&_timeout_mutex);
 }
 
 /* Wake up monitor threads every so often. */
-static void *timeout_thread(void *unused)
+static void *_timeout_thread(void *unused)
 {
 	struct timespec timeout;
 	time_t curr_time;
 
 	timeout.tv_nsec = 0;
-	pthread_cleanup_push(exit_timeout, NULL);
+	pthread_cleanup_push(_exit_timeout, NULL);
 	pthread_mutex_lock(&_timeout_mutex);
 
-	while (!list_empty(&timeout_registry)) {
+	while (!list_empty(&_timeout_registry)) {
 		struct thread_status *thread;
 
 		timeout.tv_sec = (time_t) -1;
 		curr_time = time(NULL);
 
-		list_iterate_items_gen(thread, &timeout_registry, timeout_list) {
+		list_iterate_items_gen(thread, &_timeout_registry, timeout_list) {
 			if (thread->next_time < curr_time) {
 				thread->next_time = curr_time + thread->timeout;
 				pthread_kill(thread->thread, SIGALRM);
@@ -450,7 +450,7 @@
 	return NULL;
 }
 
-static int register_for_timeout(struct thread_status *thread)
+static int _register_for_timeout(struct thread_status *thread)
 {
 	int ret = 0;
 
@@ -459,7 +459,7 @@
 	thread->next_time = time(NULL) + thread->timeout;
 
 	if (list_empty(&thread->timeout_list)) {
-		list_add(&timeout_registry, &thread->timeout_list);
+		list_add(&_timeout_registry, &thread->timeout_list);
 		if (_timeout_running)
 			pthread_cond_signal(&_timeout_cond);
 	}
@@ -468,7 +468,7 @@
 		pthread_t timeout_id;
 
 		if (!(ret = -pthread_create(&timeout_id, NULL,
-					    timeout_thread, NULL)))
+					    _timeout_thread, NULL)))
 			_timeout_running = 1;
 	}
 
@@ -477,7 +477,7 @@
 	return ret;
 }
 
-static void unregister_for_timeout(struct thread_status *thread)
+static void _unregister_for_timeout(struct thread_status *thread)
 {
 	pthread_mutex_lock(&_timeout_mutex);
 	if (!list_empty(&thread->timeout_list)) {
@@ -487,7 +487,7 @@
 	pthread_mutex_unlock(&_timeout_mutex);
 }
 
-static void no_intr_log(int level, const char *file, int line,
+static void _no_intr_log(int level, const char *file, int line,
 			const char *f, ...)
 {
 	va_list ap;
@@ -512,7 +512,7 @@
 		fprintf(stdout, "\n");
 }
 
-static sigset_t unblock_sigalrm(void)
+static sigset_t _unblock_sigalrm(void)
 {
 	sigset_t set, old;
 
@@ -527,7 +527,7 @@
 #define DM_WAIT_FATAL 2
 
 /* Wait on a device until an event occurs. */
-static int event_wait(struct thread_status *thread, struct dm_task **task)
+static int _event_wait(struct thread_status *thread, struct dm_task **task)
 {
 	sigset_t set;
 	int ret = DM_WAIT_RETRY;
@@ -549,8 +549,8 @@
 	 * This is so that you can break out of waiting on an event,
 	 * either for a timeout event, or to cancel the thread.
 	 */
-	set = unblock_sigalrm();
-	dm_log_init(no_intr_log);
+	set = _unblock_sigalrm();
+	dm_log_init(_no_intr_log);
 	errno = 0;
 	if (dm_task_run(dmt)) {
 		thread->current_events |= DM_EVENT_DEVICE_ERROR;
@@ -585,7 +585,7 @@
 }
 
 /* Register a device with the DSO. */
-static int do_register_device(struct thread_status *thread)
+static int _do_register_device(struct thread_status *thread)
 {
 	return thread->dso_data->register_device(thread->device.name,
 						 thread->device.uuid,
@@ -594,7 +594,7 @@
 }
 
 /* Unregister a device with the DSO. */
-static int do_unregister_device(struct thread_status *thread)
+static int _do_unregister_device(struct thread_status *thread)
 {
 	return thread->dso_data->unregister_device(thread->device.name,
 						   thread->device.uuid,
@@ -603,17 +603,17 @@
 }
 
 /* Process an event in the DSO. */
-static void do_process_event(struct thread_status *thread, struct dm_task *task)
+static void _do_process_event(struct thread_status *thread, struct dm_task *task)
 {
 	thread->dso_data->process_event(task, thread->current_events);
 }
 
 /* Thread cleanup handler to unregister device. */
-static void monitor_unregister(void *arg)
+static void _monitor_unregister(void *arg)
 {
 	struct thread_status *thread = arg;
 
-	if (!do_unregister_device(thread))
+	if (!_do_unregister_device(thread))
 		syslog(LOG_ERR, "%s: %s unregister failed\n", __func__,
 		       thread->device.name);
 	if (thread->current_task)
@@ -622,25 +622,25 @@
 }
 
 /* Device monitoring thread. */
-static void *monitor_thread(void *arg)
+static void *_monitor_thread(void *arg)
 {
 	struct thread_status *thread = arg;
 	int wait_error = 0;
 	struct dm_task *task;
 
 	pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);
-	pthread_cleanup_push(monitor_unregister, thread);
+	pthread_cleanup_push(_monitor_unregister, thread);
 
 	/* Wait for do_process_request() to finish its task. */
-	lock_mutex();
+	_lock_mutex();
 	thread->status = DM_THREAD_RUNNING;
-	unlock_mutex();
+	_unlock_mutex();
 
 	/* Loop forever awaiting/analyzing device events. */
 	while (1) {
 		thread->current_events = 0;
 
-		wait_error = event_wait(thread, &task);
+		wait_error = _event_wait(thread, &task);
 		if (wait_error == DM_WAIT_RETRY)
 			continue;
 
@@ -655,39 +655,39 @@
 		/*
 		 * Check against filter.
 		 *
-		 * If there's current events delivered from event_wait() AND
+		 * If there's current events delivered from _event_wait() AND
 		 * the device got registered for those events AND
 		 * those events haven't been processed yet, call
 		 * the DSO's process_event() handler.
 		 */
-		lock_mutex();
+		_lock_mutex();
 		if (thread->status == DM_THREAD_SHUTDOWN) {
-			unlock_mutex();
+			_unlock_mutex();
 			break;
 		}
-		unlock_mutex();
+		_unlock_mutex();
 
 		if (thread->events & thread->current_events) {
-			lock_mutex();
+			_lock_mutex();
 			thread->processing = 1;
-			unlock_mutex();
+			_unlock_mutex();
 
-			do_process_event(thread, task);
+			_do_process_event(thread, task);
 			dm_task_destroy(task);
 			thread->current_task = NULL;
 
-			lock_mutex();
+			_lock_mutex();
 			thread->processing = 0;
-			unlock_mutex();
+			_unlock_mutex();
 		} else {
 			dm_task_destroy(task);
 			thread->current_task = NULL;
 		}
 	}
 
-	lock_mutex();
+	_lock_mutex();
 	thread->status = DM_THREAD_DONE;
-	unlock_mutex();
+	_unlock_mutex();
 
 	pthread_cleanup_pop(1);
 
@@ -695,12 +695,12 @@
 }
 
 /* Create a device monitoring thread. */
-static int create_thread(struct thread_status *thread)
+static int _create_thread(struct thread_status *thread)
 {
-	return pthread_create(&thread->thread, NULL, monitor_thread, thread);
+	return pthread_create(&thread->thread, NULL, _monitor_thread, thread);
 }
 
-static int terminate_thread(struct thread_status *thread)
+static int _terminate_thread(struct thread_status *thread)
 {
 	int ret;
 
@@ -711,41 +711,41 @@
 }
 
 /* DSO reference counting. */
-static void lib_get(struct dso_data *data)
+static void _lib_get(struct dso_data *data)
 {
 	data->ref_count++;
 }
 
-static void lib_put(struct dso_data *data)
+static void _lib_put(struct dso_data *data)
 {
 	if (!--data->ref_count) {
 		dlclose(data->dso_handle);
 		UNLINK_DSO(data);
-		free_dso_data(data);
+		_free_dso_data(data);
 	}
 }
 
 /* Find DSO data. */
-static struct dso_data *lookup_dso(struct message_data *data)
+static struct dso_data *_lookup_dso(struct message_data *data)
 {
 	struct dso_data *dso_data, *ret = NULL;
 
-	lock_mutex();
+	_lock_mutex();
 
 	list_iterate_items(dso_data, &_dso_registry)
 	    if (!strcmp(data->dso_name, dso_data->dso_name)) {
-		lib_get(dso_data);
+		_lib_get(dso_data);
 		ret = dso_data;
 		break;
 	}
 
-	unlock_mutex();
+	_unlock_mutex();
 
 	return ret;
 }
 
 /* Lookup DSO symbols we need. */
-static int lookup_symbol(void *dl, struct dso_data *data,
+static int _lookup_symbol(void *dl, struct dso_data *data,
 			 void **symbol, const char *name)
 {
 	if ((*symbol = dlsym(dl, name)))
@@ -756,16 +756,16 @@
 
 static int lookup_symbols(void *dl, struct dso_data *data)
 {
-	return lookup_symbol(dl, data, (void *) &data->process_event,
+	return _lookup_symbol(dl, data, (void *) &data->process_event,
 			     "process_event") &&
-	    lookup_symbol(dl, data, (void *) &data->register_device,
+	    _lookup_symbol(dl, data, (void *) &data->register_device,
 			  "register_device") &&
-	    lookup_symbol(dl, data, (void *) &data->unregister_device,
+	    _lookup_symbol(dl, data, (void *) &data->unregister_device,
 			  "unregister_device");
 }
 
 /* Load an application specific DSO. */
-static struct dso_data *load_dso(struct message_data *data)
+static struct dso_data *_load_dso(struct message_data *data)
 {
 	void *dl;
 	struct dso_data *ret = NULL;
@@ -780,13 +780,13 @@
 		return NULL;
 	}
 
-	if (!(ret = alloc_dso_data(data))) {
+	if (!(ret = _alloc_dso_data(data))) {
 		dlclose(dl);
 		return NULL;
 	}
 
 	if (!(lookup_symbols(dl, ret))) {
-		free_dso_data(ret);
+		_free_dso_data(ret);
 		dlclose(dl);
 		return NULL;
 	}
@@ -796,17 +796,17 @@
 	 * we've got no references to it any more.
 	 */
 	ret->dso_handle = dl;
-	lib_get(ret);
+	_lib_get(ret);
 
-	lock_mutex();
+	_lock_mutex();
 	LINK_DSO(ret);
-	unlock_mutex();
+	_unlock_mutex();
 
 	return ret;
 }
 
 /* Return success on daemon active check. */
-static int active(struct message_data *message_data)
+static int _active(struct message_data *message_data)
 {
 	return 0;
 }
@@ -817,14 +817,14 @@
  * Only one caller at a time here, because we use
  * a FIFO and lock it against multiple accesses.
  */
-static int register_for_event(struct message_data *message_data)
+static int _register_for_event(struct message_data *message_data)
 {
 	int ret = 0;
 	struct thread_status *thread, *thread_new = NULL;
 	struct dso_data *dso_data;
 
-	if (!(dso_data = lookup_dso(message_data)) &&
-	    !(dso_data = load_dso(message_data))) {
+	if (!(dso_data = _lookup_dso(message_data)) &&
+	    !(dso_data = _load_dso(message_data))) {
 		stack;
 #ifdef ELIBACC
 		ret = -ELIBACC;
@@ -835,35 +835,35 @@
 	}
 
 	/* Preallocate thread status struct to avoid deadlock. */
-	if (!(thread_new = alloc_thread_status(message_data, dso_data))) {
+	if (!(thread_new = _alloc_thread_status(message_data, dso_data))) {
 		stack;
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	if (!fill_device_data(thread_new)) {
+	if (!_fill_device_data(thread_new)) {
 		stack;
 		ret = -ENODEV;
 		goto out;
 	}
 
-	lock_mutex();
+	_lock_mutex();
 
-	if (!(thread = lookup_thread_status(message_data))) {
-		unlock_mutex();
+	if (!(thread = _lookup_thread_status(message_data))) {
+		_unlock_mutex();
 
-		if (!(ret = do_register_device(thread_new)))
+		if (!(ret = _do_register_device(thread_new)))
 			goto out;
 
 		thread = thread_new;
 		thread_new = NULL;
 
 		/* Try to create the monitoring thread for this device. */
-		lock_mutex();
-		if ((ret = -create_thread(thread))) {
-			unlock_mutex();
-			do_unregister_device(thread);
-			free_thread_status(thread);
+		_lock_mutex();
+		if ((ret = -_create_thread(thread))) {
+			_unlock_mutex();
+			_do_unregister_device(thread);
+			_free_thread_status(thread);
 			goto out;
 		} else
 			LINK_THREAD(thread);
@@ -872,7 +872,7 @@
 	/* Or event # into events bitfield. */
 	thread->events |= message_data->events.field;
 
-	unlock_mutex();
+	_unlock_mutex();
 
 	/* FIXME - If you fail to register for timeout events, you
 	   still monitor all the other events. Is this the right
@@ -881,7 +881,7 @@
 	   successfully started up later, you will start receiving
 	   DM_EVENT_TIMEOUT events */
 	if (thread->events & DM_EVENT_TIMEOUT)
-		ret = -register_for_timeout(thread);
+		ret = -_register_for_timeout(thread);
 
       out:
 	/*
@@ -889,7 +889,7 @@
 	 * the lock in case we haven't used it.
 	 */
 	if (thread_new)
-		free_thread_status(thread_new);
+		_free_thread_status(thread_new);
 
 	return ret;
 }
@@ -899,7 +899,7 @@
  *
  * Only one caller at a time here as with register_for_event().
  */
-static int unregister_for_event(struct message_data *message_data)
+static int _unregister_for_event(struct message_data *message_data)
 {
 	int ret = 0;
 	struct thread_status *thread;
@@ -908,10 +908,10 @@
 	 * Clear event in bitfield and deactivate
 	 * monitoring thread in case bitfield is 0.
 	 */
-	lock_mutex();
+	_lock_mutex();
 
-	if (!(thread = lookup_thread_status(message_data))) {
-		unlock_mutex();
+	if (!(thread = _lookup_thread_status(message_data))) {
+		_unlock_mutex();
 		ret = -ENODEV;
 		goto out;
 	}
@@ -919,7 +919,7 @@
 	thread->events &= ~message_data->events.field;
 
 	if (!(thread->events & DM_EVENT_TIMEOUT))
-		unregister_for_timeout(thread);
+		_unregister_for_timeout(thread);
 	/*
 	 * In case there's no events to monitor on this device ->
 	 * unlink and terminate its monitoring thread.
@@ -928,7 +928,7 @@
 		UNLINK_THREAD(thread);
 		LINK(thread, &_thread_registry_unused);
 	}
-	unlock_mutex();
+	_unlock_mutex();
 
       out:
 	return ret;
@@ -939,7 +939,7 @@
  *
  * Only one caller at a time here as with register_for_event().
  */
-static int registered_device(struct message_data *message_data,
+static int _registered_device(struct message_data *message_data,
 			     struct thread_status *thread)
 {
 	struct dm_event_daemon_message *msg = message_data->msg;
@@ -956,12 +956,12 @@
 
 	msg->size = dm_asprintf(&(msg->data), fmt, dso, dev, events);
 
-	unlock_mutex();
+	_unlock_mutex();
 
 	return 0;
 }
 
-static int want_registered_device(char *dso_name, char *device_uuid,
+static int _want_registered_device(char *dso_name, char *device_uuid,
 				  struct thread_status *thread)
 {
 	/* If DSO names and device paths are equal. */
@@ -980,16 +980,16 @@
 	return 1;
 }
 
-static int _get_registered_device(struct message_data *message_data, int next)
+static int _get_registered_dev(struct message_data *message_data, int next)
 {
 	int hit = 0;
 	struct thread_status *thread;
 
-	lock_mutex();
+	_lock_mutex();
 
 	/* Iterate list of threads checking if we want a particular one. */
 	list_iterate_items(thread, &_thread_registry)
-	    if ((hit = want_registered_device(message_data->dso_name,
+	    if ((hit = _want_registered_device(message_data->dso_name,
 					      message_data->device_uuid,
 					      thread)))
 		break;
@@ -1006,39 +1006,39 @@
 			goto out;
 
 		thread = list_item(thread->list.n, struct thread_status);
-	} while (!want_registered_device(message_data->dso_name, NULL, thread));
+	} while (!_want_registered_device(message_data->dso_name, NULL, thread));
 
-	return registered_device(message_data, thread);
+	return _registered_device(message_data, thread);
 
       out:
-	unlock_mutex();
+	_unlock_mutex();
 
 	return -ENOENT;
 }
 
-static int get_registered_device(struct message_data *message_data)
+static int _get_registered_device(struct message_data *message_data)
 {
-	return _get_registered_device(message_data, 0);
+	return _get_registered_dev(message_data, 0);
 }
 
-static int get_next_registered_device(struct message_data *message_data)
+static int _get_next_registered_device(struct message_data *message_data)
 {
-	return _get_registered_device(message_data, 1);
+	return _get_registered_dev(message_data, 1);
 }
 
-static int set_timeout(struct message_data *message_data)
+static int _set_timeout(struct message_data *message_data)
 {
 	struct thread_status *thread;
 
-	lock_mutex();
-	if ((thread = lookup_thread_status(message_data)))
+	_lock_mutex();
+	if ((thread = _lookup_thread_status(message_data)))
 		thread->timeout = message_data->timeout.secs;
-	unlock_mutex();
+	_unlock_mutex();
 
 	return thread ? 0 : -ENODEV;
 }
 
-static int get_timeout(struct message_data *message_data)
+static int _get_timeout(struct message_data *message_data)
 {
 	struct thread_status *thread;
 	struct dm_event_daemon_message *msg = message_data->msg;
@@ -1046,21 +1046,21 @@
 	if (msg->data)
 		dm_free(msg->data);
 
-	lock_mutex();
-	if ((thread = lookup_thread_status(message_data))) {
+	_lock_mutex();
+	if ((thread = _lookup_thread_status(message_data))) {
 		msg->size =
 		    dm_asprintf(&(msg->data), "%" PRIu32, thread->timeout);
 	} else {
 		msg->data = NULL;
 		msg->size = 0;
 	}
-	unlock_mutex();
+	_unlock_mutex();
 
 	return thread ? 0 : -ENODEV;
 }
 
 /* Initialize a fifos structure with path names. */
-static void init_fifos(struct dm_event_fifos *fifos)
+static void _init_fifos(struct dm_event_fifos *fifos)
 {
 	memset(fifos, 0, sizeof(*fifos));
 
@@ -1069,7 +1069,7 @@
 }
 
 /* Open fifos used for client communication. */
-static int open_fifos(struct dm_event_fifos *fifos)
+static int _open_fifos(struct dm_event_fifos *fifos)
 {
 	/* Create fifos */
 	if (((mkfifo(fifos->client_path, 0600) == -1) && errno != EEXIST) ||
@@ -1123,7 +1123,7 @@
  * Read message from client making sure that data is available
  * and a complete message is read.  Must not block indefinitely.
  */
-static int client_read(struct dm_event_fifos *fifos,
+static int _client_read(struct dm_event_fifos *fifos,
 		       struct dm_event_daemon_message *msg)
 {
 	struct timeval t;
@@ -1179,7 +1179,7 @@
 /*
  * Write a message to the client making sure that it is ready to write.
  */
-static int client_write(struct dm_event_fifos *fifos,
+static int _client_write(struct dm_event_fifos *fifos,
 			struct dm_event_daemon_message *msg)
 {
 	unsigned bytes = 0;
@@ -1216,21 +1216,21 @@
  * We put the request handling functions into
  * a list because of the growing number.
  */
-static int handle_request(struct dm_event_daemon_message *msg,
+static int _handle_request(struct dm_event_daemon_message *msg,
 			  struct message_data *message_data)
 {
 	static struct {
 		unsigned int cmd;
 		int (*f)(struct message_data *);
 	} requests[] = {
-		{ DM_EVENT_CMD_REGISTER_FOR_EVENT, register_for_event},
-		{ DM_EVENT_CMD_UNREGISTER_FOR_EVENT, unregister_for_event},
-		{ DM_EVENT_CMD_GET_REGISTERED_DEVICE, get_registered_device},
+		{ DM_EVENT_CMD_REGISTER_FOR_EVENT, _register_for_event},
+		{ DM_EVENT_CMD_UNREGISTER_FOR_EVENT, _unregister_for_event},
+		{ DM_EVENT_CMD_GET_REGISTERED_DEVICE, _get_registered_device},
 		{ DM_EVENT_CMD_GET_NEXT_REGISTERED_DEVICE,
-			get_next_registered_device},
-		{ DM_EVENT_CMD_SET_TIMEOUT, set_timeout},
-		{ DM_EVENT_CMD_GET_TIMEOUT, get_timeout},
-		{ DM_EVENT_CMD_ACTIVE, active},
+			_get_next_registered_device},
+		{ DM_EVENT_CMD_SET_TIMEOUT, _set_timeout},
+		{ DM_EVENT_CMD_GET_TIMEOUT, _get_timeout},
+		{ DM_EVENT_CMD_ACTIVE, _active},
 	}, *req;
 
 	for (req = requests; req < requests + sizeof(requests); req++)
@@ -1241,7 +1241,7 @@
 }
 
 /* Process a request passed from the communication thread. */
-static int do_process_request(struct dm_event_daemon_message *msg)
+static int _do_process_request(struct dm_event_daemon_message *msg)
 {
 	int ret;
 	static struct message_data message_data;
@@ -1249,19 +1249,19 @@
 	/* Parse the message. */
 	memset(&message_data, 0, sizeof(message_data));
 	message_data.msg = msg;
-	if (msg->cmd != DM_EVENT_CMD_ACTIVE && !parse_message(&message_data)) {
+	if (msg->cmd != DM_EVENT_CMD_ACTIVE && !_parse_message(&message_data)) {
 		stack;
 		ret = -EINVAL;
 	} else
-		ret = handle_request(msg, &message_data);
+		ret = _handle_request(msg, &message_data);
 
-	free_message(&message_data);
+	_free_message(&message_data);
 
 	return ret;
 }
 
 /* Only one caller at a time. */
-static void process_request(struct dm_event_fifos *fifos)
+static void _process_request(struct dm_event_fifos *fifos)
 {
 	struct dm_event_daemon_message msg;
 
@@ -1271,10 +1271,10 @@
 	 * Read the request from the client (client_read, client_write
 	 * give true on success and false on failure).
 	 */
-	if (!client_read(fifos, &msg))
+	if (!_client_read(fifos, &msg))
 		return;
 
-	msg.cmd = do_process_request(&msg);
+	msg.cmd = _do_process_request(&msg);
 	if (!msg.data) {
 		msg.data = dm_strdup(strerror(-msg.cmd));
 		if (msg.data)
@@ -1285,20 +1285,20 @@
 		}
 	}
 
-	if (!client_write(fifos, &msg))
+	if (!_client_write(fifos, &msg))
 		stack;
 
 	if (msg.data)
 		dm_free(msg.data);
 }
 
-static void cleanup_unused_threads(void)
+static void _cleanup_unused_threads(void)
 {
 	int ret;
 	struct list *l;
 	struct thread_status *thread;
 
-	lock_mutex();
+	_lock_mutex();
 	while ((l = list_first(&_thread_registry_unused))) {
 		thread = list_item(l, struct thread_status);
 		if (thread->processing) {
@@ -1311,7 +1311,7 @@
 		} else if (thread->status == DM_THREAD_SHUTDOWN) {
 			if (!thread->events) {
 				/* turn codes negative -- should we be returning this? */
-				ret = terminate_thread(thread);
+				ret = _terminate_thread(thread);
 
 				if (ret == ESRCH) {
 					thread->status = DM_THREAD_DONE;
@@ -1332,27 +1332,27 @@
 		} else if (thread->status == DM_THREAD_DONE) {
 			list_del(l);
 			pthread_join(thread->thread, NULL);
-			lib_put(thread->dso_data);
-			free_thread_status(thread);
+			_lib_put(thread->dso_data);
+			_free_thread_status(thread);
 		}
 	}
       out:
-	unlock_mutex();
+	_unlock_mutex();
 }
 
-static void sig_alarm(int signum)
+static void _sig_alarm(int signum)
 {
 	pthread_testcancel();
 }
 
 /* Init thread signal handling. */
-static void init_thread_signals(void)
+static void _init_thread_signals(void)
 {
 	sigset_t my_sigset;
 	struct sigaction act;
 
 	memset(&act, 0, sizeof(act));
-	act.sa_handler = sig_alarm;
+	act.sa_handler = _sig_alarm;
 	sigaction(SIGALRM, &act, NULL);
 	sigfillset(&my_sigset);
 
@@ -1372,7 +1372,7 @@
  * Set the global variable which the process should
  * be watching to determine when to exit.
  */
-static void exit_handler(int sig)
+static void _exit_handler(int sig)
 {
 	/*
 	 * We exit when '_exit_now' is set.
@@ -1389,7 +1389,7 @@
 
 }
 
-static int lock_pidfile(void)
+static int _lock_pidfile(void)
 {
 	int lf;
 	char pidfile[] = DMEVENTD_PIDFILE;
@@ -1400,13 +1400,13 @@
 	if (flock(lf, LOCK_EX | LOCK_NB) < 0)
 		exit(EXIT_LOCKFILE_INUSE);
 
-	if (!storepid(lf))
+	if (!_storepid(lf))
 		exit(EXIT_FAILURE);
 
 	return 0;
 }
 
-static void daemonize(void)
+static void _daemonize(void)
 {
 	int status;
 	int pid;
@@ -1420,7 +1420,7 @@
 		fprintf(stderr, "Unable to restore signals.");
 		exit(EXIT_FAILURE);
 	}
-	signal(SIGTERM, &exit_handler);
+	signal(SIGTERM, &_exit_handler);
 
 	pid = fork();
 
@@ -1478,12 +1478,12 @@
 
 	openlog("dmeventd", LOG_PID, LOG_DAEMON);
 
-	lock_pidfile();		/* exits if failure */
+	_lock_pidfile();		/* exits if failure */
 
 	/* Set the rest of the signals to cause '_exit_now' to be set */
-	signal(SIGINT, &exit_handler);
-	signal(SIGHUP, &exit_handler);
-	signal(SIGQUIT, &exit_handler);
+	signal(SIGINT, &_exit_handler);
+	signal(SIGHUP, &_exit_handler);
+	signal(SIGQUIT, &_exit_handler);
 }
 
 int main(int argc, char *argv[])
@@ -1492,16 +1492,16 @@
 	struct dm_event_fifos fifos;
 	//struct sys_log logdata = {DAEMON_NAME, LOG_DAEMON};
 
-	daemonize();
+	_daemonize();
 
-	init_thread_signals();
+	_init_thread_signals();
 
 	//multilog_clear_logging();
 	//multilog_add_type(std_syslog, &logdata);
 	//multilog_init_verbose(std_syslog, _LOG_DEBUG);
 	//multilog_async(1);
 
-	init_fifos(&fifos);
+	_init_fifos(&fifos);
 
 	pthread_mutex_init(&_global_mutex, NULL);
 
@@ -1510,7 +1510,7 @@
 		exit(EXIT_FAILURE);
 #endif
 
-	if ((ret = open_fifos(&fifos)))
+	if ((ret = _open_fifos(&fifos)))
 		exit(EXIT_FIFO_FAILURE);
 
 	/* Signal parent, letting them know we are ready to go. */
@@ -1518,8 +1518,8 @@
 	syslog(LOG_INFO, "dmeventd ready for processing.");
 
 	while (!_exit_now) {
-		process_request(&fifos);
-		cleanup_unused_threads();
+		_process_request(&fifos);
+		_cleanup_unused_threads();
 		if (!list_empty(&_thread_registry)
 		    || !list_empty(&_thread_registry_unused))
 			_thread_registries_empty = 0;
@@ -1527,7 +1527,7 @@
 			_thread_registries_empty = 1;
 	}
 
-	exit_dm_lib();
+	_exit_dm_lib();
 
 #ifdef MCL_CURRENT
 	munlockall();

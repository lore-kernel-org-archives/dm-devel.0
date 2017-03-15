From: Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH] kobject: support passing in variables for
	synthetic uevents
Date: Wed, 15 Mar 2017 16:17:24 +0100
Message-ID: <20170315151724.4696-1-prajnoha@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: gregkh@linuxfoundation.org, jeyu@redhat.com, rusty@rustcorp.com.au
Cc: kay@redhat.com, dm-devel@redhat.com, Peter Rajnoha <prajnoha@redhat.com>, linux-kernel@vger.kernel.org, harald@redhat.com
List-Id: dm-devel.ids

This patch makes it possible to pass additional arguments in addition
to uevent action name when writing /sys/.../uevent attribute. These
additional arguments are then inserted into generated synthetic uevent
as additional environment variables.

Before, we were not able to pass any additional uevent environment
variables for synthetic uevents. This made it hard to identify such uevents
properly in userspace to make proper distinction between genuine uevents
originating from kernel and synthetic uevents triggered from userspace.
Also, it was not possible to pass any additional information which would
make it possible to optimize and change the way the synthetic uevents are
processed back in userspace based on the originating environment of the
triggering action in userspace. With the extra additional variables, we are
able to pass through this extra information needed and also it makes it
possible to synchronize with such synthetic uevents as they can be clearly
identified back in userspace.

The format for writing the uevent attribute is following:

        ACTION [UUID [KEY=VALUE ...]

There's no change in how "ACTION" is recognized - it stays the same
("add", "change", "remove"). The "ACTION" is the only argument required
to generate synthetic uevent, the rest of arguments, that this patch
adds support for, are optional.

The "UUID" is considered as transaction identifier so it's possible to
use the same UUID value for one or more synthetic uevents in which case
we logically group these uevents together for any userspace listeners.
The "UUID" is expected to be in "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
format where "x" is a hex digit. The value appears in uevent as
"SYNTH_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" environment variable.

The "KEY=VALUE" pairs can contain alphanumeric characters only. It's
possible to define zero or more more pairs - each pair is then delimited
by a space character " ". Each pair appears in synthetic uevents as
"SYNTH_ARG_KEY=VALUE" environment variable. That means the KEY name gains
"SYNTH_ARG_" prefix to avoid possible collisions with existing variables.
To pass the "KEY=VALUE" pairs, it's also required to pass in the "UUID"
part for the synthetic uevent first.

If "UUID" is not passed in, the generated synthetic uevent gains
"SYNTH_UUID=0" environment variable automatically so it's possible to
identify this situation in userspace when reading generated uevent and so
we can still make a difference between genuine and synthetic uevents.

Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 6470eb8..f945f2f 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -648,10 +648,7 @@ static void remove_probe_files(struct bus_type *bus)
 static ssize_t uevent_store(struct device_driver *drv, const char *buf,
 			    size_t count)
 {
-	enum kobject_action action;
-
-	if (kobject_action_type(buf, count, &action) == 0)
-		kobject_uevent(&drv->p->kobj, action);
+	kobject_synth_uevent(&drv->p->kobj, buf, count);
 	return count;
 }
 static DRIVER_ATTR_WO(uevent);
@@ -868,10 +865,7 @@ static void klist_devices_put(struct klist_node *n)
 static ssize_t bus_uevent_store(struct bus_type *bus,
 				const char *buf, size_t count)
 {
-	enum kobject_action action;
-
-	if (kobject_action_type(buf, count, &action) == 0)
-		kobject_uevent(&bus->p->subsys.kobj, action);
+	kobject_synth_uevent(&bus->p->subsys.kobj, buf, count);
 	return count;
 }
 static BUS_ATTR(uevent, S_IWUSR, NULL, bus_uevent_store);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 684bda4..63ca69f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -986,12 +986,9 @@ static ssize_t uevent_show(struct device *dev, struct device_attribute *attr,
 static ssize_t uevent_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	enum kobject_action action;
+	if (kobject_synth_uevent(&dev->kobj, buf, count))
+		dev_err(dev, "uevent: failed to send synthetic uevent\n");
 
-	if (kobject_action_type(buf, count, &action) == 0)
-		kobject_uevent(&dev->kobj, action);
-	else
-		dev_err(dev, "uevent: unknown action-string\n");
 	return count;
 }
 static DEVICE_ATTR_RW(uevent);
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index e628459..c4b88cb 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -215,11 +215,9 @@ extern struct kobject *firmware_kobj;
 int kobject_uevent(struct kobject *kobj, enum kobject_action action);
 int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			char *envp[]);
+int kobject_synth_uevent(struct kobject *kobj, const char *buf, size_t count);
 
 __printf(2, 3)
 int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...);
 
-int kobject_action_type(const char *buf, size_t count,
-			enum kobject_action *type);
-
 #endif /* _KOBJECT_H_ */
diff --git a/kernel/module.c b/kernel/module.c
index 7eba6de..a055bcb 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1181,10 +1181,7 @@ static ssize_t store_uevent(struct module_attribute *mattr,
 			    struct module_kobject *mk,
 			    const char *buffer, size_t count)
 {
-	enum kobject_action action;
-
-	if (kobject_action_type(buffer, count, &action) == 0)
-		kobject_uevent(&mk->kobj, action);
+	kobject_synth_uevent(&mk->kobj, buffer, count);
 	return count;
 }
 
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 9a2b811..719c155 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -23,6 +23,8 @@
 #include <linux/socket.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
+#include <linux/uuid.h>
+#include <linux/ctype.h>
 #include <net/sock.h>
 #include <net/net_namespace.h>
 
@@ -52,19 +54,13 @@ static const char *kobject_actions[] = {
 	[KOBJ_OFFLINE] =	"offline",
 };
 
-/**
- * kobject_action_type - translate action string to numeric type
- *
- * @buf: buffer containing the action string, newline is ignored
- * @count: length of buffer
- * @type: pointer to the location to store the action type
- *
- * Returns 0 if the action string was recognized.
- */
-int kobject_action_type(const char *buf, size_t count,
-			enum kobject_action *type)
+static int kobject_action_type(const char *buf, size_t count,
+			       enum kobject_action *type,
+			       const char **args)
 {
 	enum kobject_action action;
+	size_t count_first;
+	const char *args_start;
 	int ret = -EINVAL;
 
 	if (count && (buf[count-1] == '\n' || buf[count-1] == '\0'))
@@ -73,11 +69,20 @@ int kobject_action_type(const char *buf, size_t count,
 	if (!count)
 		goto out;
 
+	args_start = strnchr(buf, count, ' ');
+	if (args_start) {
+		count_first = args_start - buf;
+		args_start = args_start + 1;
+	} else
+		count_first = count;
+
 	for (action = 0; action < ARRAY_SIZE(kobject_actions); action++) {
-		if (strncmp(kobject_actions[action], buf, count) != 0)
+		if (strncmp(kobject_actions[action], buf, count_first) != 0)
 			continue;
-		if (kobject_actions[action][count] != '\0')
+		if (kobject_actions[action][count_first] != '\0')
 			continue;
+		if (args)
+			*args = args_start;
 		*type = action;
 		ret = 0;
 		break;
@@ -86,6 +91,142 @@ int kobject_action_type(const char *buf, size_t count,
 	return ret;
 }
 
+static const char *action_arg_word_end(const char *buf, const char *buf_end,
+				       char delim)
+{
+	const char *next = buf;
+
+	while (next <= buf_end && *next != delim)
+		if (!isalnum(*next++))
+			return NULL;
+
+	if (next == buf)
+		return NULL;
+
+	return next;
+}
+
+static int kobject_action_args(const char *buf, size_t count,
+			       struct kobj_uevent_env **ret_env)
+{
+	struct kobj_uevent_env *env = NULL;
+	const char *next, *buf_end, *key;
+	int key_len;
+	int r = -EINVAL;
+
+	if (count && (buf[count - 1] == '\n' || buf[count - 1] == '\0'))
+		count--;
+
+	if (!count)
+		return -EINVAL;
+
+	env = kzalloc(sizeof(*env), GFP_KERNEL);
+	if (!env)
+		return -ENOMEM;
+
+	/* first arg is UUID */
+	if (count < UUID_STRING_LEN || !uuid_is_valid(buf) ||
+	    add_uevent_var(env, "SYNTH_UUID=%.*s", UUID_STRING_LEN, buf))
+		goto out;
+
+	/*
+	 * the rest are custom environment variables in KEY=VALUE
+	 * format with ' ' delimiter between each KEY=VALUE pair
+	 */
+	next = buf + UUID_STRING_LEN;
+	buf_end = buf + count - 1;
+
+	while (next <= buf_end) {
+		if (*next != ' ')
+			goto out;
+
+		/* skip the ' ', key must follow */
+		key = ++next;
+		if (key > buf_end)
+			goto out;
+
+		buf = next;
+		next = action_arg_word_end(buf, buf_end, '=');
+		if (!next || next > buf_end || *next != '=')
+			goto out;
+		key_len = next - buf;
+
+		/* skip the '=', value must follow */
+		if (++next > buf_end)
+			goto out;
+
+		buf = next;
+		next = action_arg_word_end(buf, buf_end, ' ');
+		if (!next)
+			goto out;
+
+		if (add_uevent_var(env, "SYNTH_ARG_%.*s=%.*s",
+				   key_len, key, (int) (next - buf), buf))
+			goto out;
+	}
+
+	r = 0;
+out:
+	if (r)
+		kfree(env);
+	else
+		*ret_env = env;
+	return r;
+}
+
+/**
+ * kobject_synth_uevent - send synthetic uevent with arguments
+ *
+ * @kobj: struct kobject for which synthetic uevent is to be generated
+ * @buf: buffer containing action type and action args, newline is ignored
+ * @count: length of buffer
+ *
+ * Returns 0 if kobject_synthetic_uevent() is completed with success or the
+ * corresponding error when it fails.
+ */
+int kobject_synth_uevent(struct kobject *kobj, const char *buf, size_t count)
+{
+	char *no_uuid_envp[] = { "SYNTH_UUID=0", NULL };
+	enum kobject_action action;
+	const char *action_args;
+	struct kobj_uevent_env *env;
+	const char *msg = NULL, *devpath;
+	int r;
+
+	r = kobject_action_type(buf, count, &action, &action_args);
+	if (r) {
+		msg = "unknown uevent action string\n";
+		goto out;
+	}
+
+	if (!action_args) {
+		r = kobject_uevent_env(kobj, action, no_uuid_envp);
+		goto out;
+	}
+
+	r = kobject_action_args(action_args,
+				count - (action_args - buf), &env);
+	if (r == -EINVAL) {
+		msg = "incorrect uevent action arguments\n";
+		goto out;
+	}
+
+	if (r)
+		goto out;
+
+	r = kobject_uevent_env(kobj, action, env->envp);
+	kfree(env);
+out:
+	if (r) {
+		devpath = kobject_get_path(kobj, GFP_KERNEL);
+		printk(KERN_WARNING "synth uevent: %s: %s",
+		       devpath ?: "unknown device",
+		       msg ?: "failed to send uevent");
+		kfree(devpath);
+	}
+	return r;
+}
+
 #ifdef CONFIG_NET
 static int kobj_bcast_filter(struct sock *dsk, struct sk_buff *skb, void *data)
 {

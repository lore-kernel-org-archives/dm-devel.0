From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/7] multipath: validate devmap names
Date: Tue, 31 May 2016 18:16:48 -0500
Message-ID: <1464736610-20027-6-git-send-email-bmarzins@redhat.com>
References: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Any device identifier given to multipath that isn't either a block
device or a major:minor id is assumed to be a multipath alias. This can
cause some confusing messages if the user accidentally enters something
that is clearly a pathname, but isn't a block device. Since multipath
device aliases are not allowed to have a "/" in them, multipath now
checks the identifier for this before assuming that is is a device
alias, and if there is a "/", it errors out with a helpful message.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 8 ++++++++
 libmultipath/alias.h | 1 +
 multipath/main.c     | 7 ++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 7d12a0c..5fdcdb5 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -36,6 +36,14 @@
  * See the file COPYING included with this distribution for more details.
  */
 
+int
+valid_alias(char *alias)
+{
+	if (strchr(alias, '/') != NULL)
+		return 0;
+	return 1;
+}
+
 
 static int
 format_devname(char *name, int id, int len, char *prefix)
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index 9cb3e8f..95473ff 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -7,6 +7,7 @@
 "# alias wwid\n" \
 "#\n"
 
+int valid_alias(char *alias);
 char *get_user_friendly_alias(char *wwid, char *file, char *prefix,
 			      int bindings_readonly);
 int get_user_friendly_wwid(char *alias, char *buff, char *file);
diff --git a/multipath/main.c b/multipath/main.c
index c33f689..aadebec 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -465,8 +465,9 @@ get_dev_type(char *dev) {
 	}
 	else if (sscanf(dev, "%d:%d", &i, &i) == 2)
 		return DEV_DEVT;
-	else
+	else if (valid_alias(dev))
 		return DEV_DEVMAP;
+	return DEV_NONE;
 }
 
 int
@@ -596,6 +597,10 @@ main (int argc, char *argv[])
 		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
 		if (conf->dev_type != DEV_UEVENT)
 			conf->dev_type = get_dev_type(conf->dev);
+		if (conf->dev_type == DEV_NONE) {
+			condlog(0, "'%s' is not a valid argument\n", conf->dev);
+			goto out;
+		}
 	}
 	conf->daemon = 0;
 	if (conf->dev_type == DEV_UEVENT) {
-- 
1.8.3.1

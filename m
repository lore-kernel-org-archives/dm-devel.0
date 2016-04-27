From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/57] Only filter for udev property if
	uid_attribute is present
Date: Wed, 27 Apr 2016 13:10:30 +0200
Message-ID: <1461755458-29225-30-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

It only makes sense to filter for an existing udev property if the
'uid_attribute' variable is set. Otherwise multipath did not
get the uid from udev and so we might not even have udev information.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index ca20ba5..0076485 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -967,7 +967,8 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 				return ret;
 			}
 		}
-		if (pp->udev && filter_property(conf, pp->udev) > 0)
+		if (pp->udev && pp->uid_attribute &&
+		    filter_property(conf, pp->udev) > 0)
 			return 2;
 
 		refwwid = pp->wwid;
@@ -994,7 +995,8 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 				return ret;
 			}
 		}
-		if (pp->udev && filter_property(conf, pp->udev) > 0)
+		if (pp->udev && pp->uid_attribute &&
+		    filter_property(conf, pp->udev) > 0)
 			return 2;
 
 		refwwid = pp->wwid;
@@ -1017,7 +1019,8 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 					dev);
 			return ret;
 		}
-		if (pp->udev && filter_property(conf, pp->udev) > 0)
+		if (pp->udev && pp->uid_attribute &&
+		    filter_property(conf, pp->udev) > 0)
 			return 2;
 
 		refwwid = pp->wwid;
-- 
2.6.6

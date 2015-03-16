From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/78] libmultipath: filter for missing property
	in get_refwwid()
Date: Mon, 16 Mar 2015 13:35:50 +0100
Message-ID: <1426509425-15978-4-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

get_refwwid() needs to filter for missing udev properties,
otherwise it'll accept just about any SCSI device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 1e6a0c5..9012258 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -962,6 +962,9 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 				return ret;
 			}
 		}
+		if (pp->udev && filter_property(conf, pp->udev) > 0)
+			return 2;
+
 		refwwid = pp->wwid;
 		goto out;
 	}
@@ -986,6 +989,9 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 				return ret;
 			}
 		}
+		if (pp->udev && filter_property(conf, pp->udev) > 0)
+			return 2;
+
 		refwwid = pp->wwid;
 		goto out;
 	}
-- 
1.8.4.5

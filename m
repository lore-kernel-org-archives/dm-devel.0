From: Florian Zumbiehl <florz@florz.de>
Subject: [PATCH] umask in device node creation error handling
Date: Wed, 26 Aug 2009 17:51:17 +0200
Message-ID: <20090826155117.GU2717@florz.florz.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

I guess that the diff is pretty much self-explaining ...

diff --git a/libdm/libdm-common.c b/libdm/libdm-common.c
index b7782a7..554c1a4 100644
--- a/libdm/libdm-common.c
+++ b/libdm/libdm-common.c
@@ -360,6 +360,7 @@ static int _add_dev_node(const char *dev_name, uint32_t major, uint32_t minor,
 
 	old_mask = umask(0);
 	if (mknod(path, S_IFBLK | mode, dev) < 0) {
+		umask(old_mask);
 		log_error("Unable to make device node for '%s'", dev_name);
 		return 0;
 	}

Florian

From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] kobj_uevent: Ignore if some listeners cannot handle message
Date: Mon, 22 Aug 2011 15:51:34 +0200
Message-ID: <1314021094-15453-1-git-send-email-mbroz@redhat.com>
References: <4E4ECA5D.1020907@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E4ECA5D.1020907@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, kay.sievers@vrfy.org, ebiederm@xmission.com, greg@kroah.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

kobject_uevent() uses a multicast socket and should ignore
if one of listeners cannot handle messages or nobody is
listening at all.

Easily reproducible when a process in system is cloned
with CLONE_NEWNET flag.

(See also http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/5256)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 lib/kobject_uevent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 70af0a7..ad72a03 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -282,7 +282,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 							    kobj_bcast_filter,
 							    kobj);
 			/* ENOBUFS should be handled in userspace */
-			if (retval == -ENOBUFS)
+			if (retval == -ENOBUFS || retval == -ESRCH)
 				retval = 0;
 		} else
 			retval = -ENOMEM;
-- 
1.7.6

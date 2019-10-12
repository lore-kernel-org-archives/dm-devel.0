From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 61/72] multipath tests: blacklist: remove
 always-true condition
Date: Sat, 12 Oct 2019 21:28:53 +0000
Message-ID: <20191012212703.12989-62-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

clang warns about this (udev_device->property_list can't be NULL).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/blacklist.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tests/blacklist.c b/tests/blacklist.c
index 733ee398..6e7c1864 100644
--- a/tests/blacklist.c
+++ b/tests/blacklist.c
@@ -40,8 +40,6 @@ struct udev_list_entry *
 __wrap_udev_device_get_properties_list_entry(struct udev_device *udev_device)
 {
 	assert_non_null(udev_device);
-	if (!udev_device->property_list)
-		return NULL;
 	if (!*udev_device->property_list)
 		return NULL;
 	return (struct udev_list_entry *)udev_device->property_list;
-- 
2.23.0

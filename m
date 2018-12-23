From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 20/20] libmultipath/foreign/nvme: fix ouput
	for "%n" wildcard
Date: Sun, 23 Dec 2018 23:21:26 +0100
Message-ID: <20181223222126.30882-21-mwilck@suse.com>
References: <20181223222126.30882-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181223222126.30882-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The output for "%n" ("name") is broken: it omits the NSID,
and thus it isn't unique per namespace; and it duplicates the
NQN. Change the format to "$NQN:nsid.$NSID".

Real-world example:
nqn.1992-08.com.netapp:sn.7c6b997ca1f611e8abb200a09890f5bf:subsystem.netapp-nvme-svm-subsystem:nsid.1

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 838e450e..f0e82937 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -148,10 +148,11 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
 		return snprintf(buff, len, "%s",
 				udev_device_get_sysname(nvm->udev));
 	case 'n':
-		return snprintf(buff, len, "%s:NQN:%s",
-				udev_device_get_sysname(nvm->subsys),
+		return snprintf(buff, len, "%s:nsid.%s",
 				udev_device_get_sysattr_value(nvm->subsys,
-							      "subsysnqn"));
+							      "subsysnqn"),
+				udev_device_get_sysattr_value(nvm->udev,
+							      "nsid"));
 	case 'w':
 		return snprintf(buff, len, "%s",
 				udev_device_get_sysattr_value(nvm->udev,
-- 
2.19.2

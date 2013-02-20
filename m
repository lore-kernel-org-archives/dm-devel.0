From: Phileas Fogg <phileas-fogg@mail.ru>
Subject: Re: [PATCH] Add PS3 HDD partition table support
Date: Wed, 20 Feb 2013 18:47:43 +0100
Message-ID: <51250C3F.8020104@mail.ru>
References: <511F8115.5000501@mail.ru>
	<1361341699.3217.4.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1361341699.3217.4.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Christophe Varoqui wrote:

> Would you be so kind as to rebase this patch for inclusion ?
>
> As I have no way to test it, so if someone can sign it off, all the
> better.
>
> Best regards,
> Christophe Varoqui
> www.opensvc.com

Hi,
I tested the patch on my PS3 console.


 From 4c278900979bbfcad7b431dde31c65835fd7872b Mon Sep 17 00:00:00 2001
From: glevand <geoffrey.levand@mail.ru>
Date: Wed, 20 Feb 2013 18:45:13 +0100
Subject: [PATCH] kpartx: add ps3 partition table support

---
  kpartx/Makefile    |  2 +-
  kpartx/byteorder.h |  4 +++
  kpartx/kpartx.c    |  1 +
  kpartx/kpartx.h    |  1 +
  kpartx/ps3.c       | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
  5 files changed, 79 insertions(+), 1 deletion(-)
  create mode 100644 kpartx/ps3.c

diff --git a/kpartx/Makefile b/kpartx/Makefile
index b0d73a3..4ba38ba 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -14,7 +14,7 @@ endif

  LDFLAGS = -ldevmapper
  OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
-       gpt.o mac.o crc32.o lopart.o xstrncpy.o devmapper.o
+       gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
  EXEC = kpartx

  all: $(EXEC)
diff --git a/kpartx/byteorder.h b/kpartx/byteorder.h
index 21962d6..199c66b 100644
--- a/kpartx/byteorder.h
+++ b/kpartx/byteorder.h
@@ -12,12 +12,16 @@
  #  define le16_to_cpu(x) (x)
  #  define be16_to_cpu(x) bswap_16(x)
  #  define le32_to_cpu(x) (x)
+#  define le64_to_cpu(x) (x)
  #  define be32_to_cpu(x) bswap_32(x)
+#  define be64_to_cpu(x) bswap_64(x)
  #elif BYTE_ORDER == BIG_ENDIAN
  #  define le16_to_cpu(x) bswap_16(x)
  #  define be16_to_cpu(x) (x)
  #  define le32_to_cpu(x) bswap_32(x)
+#  define le64_to_cpu(x) bswap_64(x)
  #  define be32_to_cpu(x) (x)
+#  define be64_to_cpu(x) (x)
  #else
  #  error unsupported
  #endif
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index dd57294..30b3bd9 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -81,6 +81,7 @@ initpts(void)
  	addpts("dasd", read_dasd_pt);
  	addpts("mac", read_mac_pt);
  	addpts("sun", read_sun_pt);
+	addpts("ps3", read_ps3_pt);
  }

  static char short_opts[] = "rladfgvp:t:su";
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 43ae3f8..61d31b6 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -39,6 +39,7 @@ extern ptreader read_gpt_pt;
  extern ptreader read_dasd_pt;
  extern ptreader read_mac_pt;
  extern ptreader read_sun_pt;
+extern ptreader read_ps3_pt;

  char *getblock(int fd, unsigned int secnr);

diff --git a/kpartx/ps3.c b/kpartx/ps3.c
new file mode 100644
index 0000000..c17124d
--- /dev/null
+++ b/kpartx/ps3.c
@@ -0,0 +1,72 @@
+#include "kpartx.h"
+#include "byteorder.h"
+#include <sys/types.h>
+#include <string.h>
+
+#define SECTOR_SIZE		512
+#define MAX_ACL_ENTRIES		8
+#define MAX_PARTITIONS		8
+
+#define MAGIC1			0x0FACE0FFULL
+#define MAGIC2			0xDEADFACEULL
+
+struct p_acl_entry {
+	u_int64_t laid;
+	u_int64_t rights;
+};
+
+struct d_partition {
+	u_int64_t p_start;
+	u_int64_t p_size;
+	struct p_acl_entry p_acl[MAX_ACL_ENTRIES];
+};
+
+struct disklabel {
+	u_int8_t d_res1[16];
+	u_int64_t d_magic1;
+	u_int64_t d_magic2;
+	u_int64_t d_res2;
+	u_int64_t d_res3;
+	struct d_partition d_partitions[MAX_PARTITIONS];
+	u_int8_t d_pad[0x600 - MAX_PARTITIONS * sizeof(struct d_partition)- 0x30];
+};
+
+static int
+read_disklabel(int fd, struct disklabel *label) {
+	unsigned char *data;
+	int i;
+
+	for (i = 0; i < sizeof(struct disklabel) / SECTOR_SIZE; i++) {
+		data = (unsigned char *) getblock(fd, i);
+		if (!data)
+			return 0;
+
+		memcpy((unsigned char *) label + i * SECTOR_SIZE, data, SECTOR_SIZE);
+	}
+
+	return 1;
+}
+
+int
+read_ps3_pt(int fd, struct slice all, struct slice *sp, int ns) {
+	struct disklabel label;
+        int n = 0;
+	int i;
+
+	if (!read_disklabel(fd, &label))
+		return -1;
+
+	if ((be64_to_cpu(label.d_magic1) != MAGIC1) ||
+	    (be64_to_cpu(label.d_magic2) != MAGIC2))
+		return -1;
+
+	for (i = 0; i < MAX_PARTITIONS; i++) {
+		if (label.d_partitions[i].p_start && label.d_partitions[i].p_size) {
+			sp[n].start =  be64_to_cpu(label.d_partitions[i].p_start);
+			sp[n].size =  be64_to_cpu(label.d_partitions[i].p_size);
+			n++;
+		}
+	}
+
+	return n;
+}
-- 
1.8.1.3

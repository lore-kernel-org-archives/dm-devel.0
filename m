From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools (patch): Do not select sysfs prioritizer
 for RDAC arrays (was Re: [PATCH 00/33] multipath-tools fixes from SUSE)
Date: Thu, 23 Mar 2017 19:43:22 +0100
Message-ID: <9300564f-d989-b6d9-f170-2e4385fa1c1e@gmail.com>
References: <20170228162329.14517-1-mwilck@suse.com>
	<baaf80fb-ff18-c8b1-c1e5-ef1bf64334c4@gmail.com>
	<1488355933.23148.4.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1488355933.23148.4.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>, "Stewart, Sean" <Sean.Stewart@netapp.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/01/2017 09:12 AM, Martin Wilck wrote:

> On Tue, 2017-02-28 at 23:44 +0100, Xose Vazquez Perez wrote:
>>
>> There is a recent one missing:
>> ---
>> Subject: libmultipath/propsel: Do not select sysfs prioritizer for
>> RDAC arrays
> 
> Well observed :-) This one still needs verification. We will submit it
> when it's final.

Is it stable/tested enough to be merged?



commit 0119472d847eaa24cae7a0f3b523af82f50dd4df
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Feb 10 15:47:43 2017 +0100

    libmultipath/propsel: Do not select sysfs prioritizer for RDAC arrays

    Recent RDAC (NetApp E-Series) firmware implemented an internal load
    balancer and switched to implicit ALUA.
    Unfortunately the load balancer relies on periodic REPORT TARGET PORT
    GROUPS from the host, so we cannot use the sysfs prioritizer here.

    References: bsc#1004858

    Signed-off-by: Hannes Reinecke <hare@suse.com>

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4d4fc895..46483172 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1112,7 +1112,7 @@ get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
 	return len;
 }

-static int
+int
 get_vpd_sgio (int fd, int pg, char * str, int maxlen)
 {
 	int len, buff_len;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 3039268d..2479c242 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -35,6 +35,7 @@ int path_discovery (vector pathvec, int flag);
 int do_tur (char *);
 int path_offline (struct path *);
 int get_state (struct path * pp, struct config * conf, int daemon);
+int get_vpd_sgio (int fd, int pg, char * str, int maxlen);
 int pathinfo (struct path * pp, struct config * conf, int mask);
 int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 			      int flag, struct path **pp_ptr);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 0c499339..87d2d5f9 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -363,6 +363,24 @@ out:
 	return 0;
 }

+/*
+ * Current RDAC (NetApp E-Series) firmware relies
+ * on periodic REPORT TARGET PORT GROUPS for
+ * internal load balancing.
+ * Using the sysfs priority checker defeats this purpose.
+ */
+static int
+check_rdac(struct path * pp)
+{
+	int len;
+	char buff[44];
+
+	len = get_vpd_sgio(pp->fd, 0xC9, buff, 44);
+	if (len <= 0)
+		return 0;
+	return !(memcmp(buff + 4, "vac1", 4));
+}
+
 void
 detect_prio(struct config *conf, struct path * pp)
 {
@@ -372,8 +390,10 @@ detect_prio(struct config *conf, struct path * pp)

 	if (pp->tpgs <= 0)
 		return;
-	if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
-		default_prio = PRIO_SYSFS;
+	if (pp->tpgs == 2 && !check_rdac(pp)) {
+		if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
+			default_prio = PRIO_SYSFS;
+	}
 	prio_get(conf->multipath_dir, p, default_prio, DEFAULT_PRIO_ARGS);
 }

From: Denis Semakin <d.semakin@omprussia.ru>
Subject: Re: dm table: add support for secure erase forwarding
 [was: Re: Adaptation secure erase forwarding for 4.1x kernels]
Date: Mon, 26 Mar 2018 10:45:33 +0300 (MSK)
Message-ID: <1996070847.39629.1522050333423.JavaMail.zimbra@omprussia.ru>
References: <1496940834.549721.1520933025411.JavaMail.zimbra@omprussia.ru>
	<20180322151045.GA27598@redhat.com>
	<695931032.318989.1521816469739.JavaMail.zimbra@omprussia.ru>
	<20180323153844.GA4914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180323153844.GA4914@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi, sorry for my misunderstanding.


>Thinking further, it is absolutely needed, otherwise dm-stripe.c won't
>be able to use the optimization I mentioned above.  In addition, other
>targets shouldn't be getting REQ_OP_SECURE_ERASE unless there is a real
>need.  ti->num_secure_erase_bios will allow for a much safer and
>controlled rollout of this support.

Ok. I got it.

>As my previous email elaborated, ti->num_secure_erase_bios is the right
>way forward.

Then a patch for this may look like:

From 2b9dfd5af813023cdaded4d91b4c25cec8a1783d Mon Sep 17 00:00:00 2001
From: Denis Semakin <d.semakin@omprussia.ru>
Date: Mon, 26 Mar 2018 10:44:14 +0300
Subject: [PATCH] Add num_secure_erase_bios field

Signed-off-by: Denis Semakin <d.semakin@omprussia.ru>
---
 drivers/md/dm-linear.c        | 1 +
 drivers/md/dm-table.c         | 3 +++
 include/linux/device-mapper.h | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index d5f8eff..ff751b0 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -59,6 +59,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)

        ti->num_flush_bios = 1;
        ti->num_discard_bios = 1;
+       ti->num_secure_erase_bios = 1;
        ti->num_write_same_bios = 1;
        ti->num_write_zeroes_bios = 1;
        ti->private = lc;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d857369..0acffdb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1863,6 +1863,9 @@ static bool dm_table_supports_secure_erase(struct dm_table *t)
        for (i = 0; i < dm_table_get_num_targets(t); i++) {
                ti = dm_table_get_target(t, i);

+              if (!ti->num_secure_erase_bios)
+                      return false;
+
                if (!ti->type->iterate_devices ||
                    ti->type->iterate_devices(ti, device_not_secure_erase_capable, NULL))
                       return false;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1e2426c..233ac8f 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -267,6 +267,8 @@ struct dm_target {
         */
        unsigned num_discard_bios;

+       unsigned num_secure_erase_bios;
+
        /*
         * The number of WRITE SAME bios that will be submitted to the target.
         * The bio number can be accessed with dm_bio_get_target_bio_nr.
-- 
1.9.1

What do you think?

Denis.

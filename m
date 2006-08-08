From: Edward Goggin <egoggin@emc.com>
Subject: dm_table_put_md to mirror dm_table_get_md
Date: Tue, 8 Aug 2006 11:28:44 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1352@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

Alasdair,

This patch adds the module exported symbol dm_table_put_md to allow a
module function to release a mapped device's table structure after
calling dm_table_get_md.  I've got another patch coming which uses both
dm_table_get_md and dm_table_put_md in order to retrieve a dm mapped
device's name attribute to pass to multipath hardware handler for the
enhancement of event logging messages.

Ed


*** drivers/md/dm-table.c.orig	Thu Aug  3 04:04:54 2006
--- drivers/md/dm-table.c	Thu Aug  3 04:04:54 2006
***************
*** 1008,1013 ****
--- 1008,1018 ----
  	return t->md;
  }
 =20
+ void dm_table_put_md(struct dm_table *t)
+ {
+ 	dm_put(t->md);
+ }
+=20
  EXPORT_SYMBOL(dm_vcalloc);
  EXPORT_SYMBOL(dm_get_device);
  EXPORT_SYMBOL(dm_put_device);
***************
*** 1015,1020 ****
--- 1020,1026 ----
  EXPORT_SYMBOL(dm_table_get_size);
  EXPORT_SYMBOL(dm_table_get_mode);
  EXPORT_SYMBOL(dm_table_get_md);
+ EXPORT_SYMBOL(dm_table_put_md);
  EXPORT_SYMBOL(dm_table_put);
  EXPORT_SYMBOL(dm_table_get);
  EXPORT_SYMBOL(dm_table_unplug_all);


*** include/linux/device-mapper.h.orig	Mon Jul 24 03:27:09 2006
--- include/linux/device-mapper.h	Mon Jul 24 03:28:44 2006
***************
*** 217,222 ****
--- 217,223 ----
  unsigned int dm_table_get_num_targets(struct dm_table *t);
  int dm_table_get_mode(struct dm_table *t);
  struct mapped_device *dm_table_get_md(struct dm_table *t);
+ void dm_table_put_md(struct dm_table *t);
 =20
  /*
   * Trigger an event.

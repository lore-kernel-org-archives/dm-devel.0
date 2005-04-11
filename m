From: Lars Marowsky-Bree <lmb@suse.de>
Subject: [PATCH] Export dm_table_get_size()
Date: Mon, 11 Apr 2005 14:47:25 +0200
Message-ID: <20050411124725.GN12752@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IvGM3kKqwtniy32b"
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

the attached trivial patch is needed to resolve an unresolved symbol in
the latest udm patchset.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dm-dm_table_get_size

From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Export dm_table_get_size
Patch-mainline: 2.6.12

dm-snapshot needs this to be exported.

Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>

Index: linux-2.6.5/drivers/md/dm-table.c
===================================================================
--- linux-2.6.5.orig/drivers/md/dm-table.c	2005-04-11 14:26:18.672891916 +0200
+++ linux-2.6.5/drivers/md/dm-table.c	2005-04-11 14:40:57.478641891 +0200
@@ -946,5 +946,6 @@ EXPORT_SYMBOL(dm_table_event);
 EXPORT_SYMBOL(dm_table_get_mode);
 EXPORT_SYMBOL(dm_table_put);
 EXPORT_SYMBOL(dm_table_get);
+EXPORT_SYMBOL(dm_table_get_size);
 EXPORT_SYMBOL(dm_table_unplug_all);
 EXPORT_SYMBOL(dm_table_flush_all);

--IvGM3kKqwtniy32b
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--IvGM3kKqwtniy32b--

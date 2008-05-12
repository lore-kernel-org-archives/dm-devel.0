From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/6] drivers/md: remove null pointer dereference
Date: Mon, 12 May 2008 15:37:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805121537100.3694@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757506AbYELNh5@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

From: Julia Lawall <julia@diku.dk>

If pgpath->pg->ps.type is NULL, it is not possible to access its name
field.  So I have simply modified the error message to drop the printing of
the name field.


This problem was found using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c	2008-04-16 13:27:57.000000000 +0200
+++ b/drivers/md/dm-mpath.c	2008-05-12 09:19:35.000000000 +0200
@@ -884,8 +884,7 @@ static int reinstate_path(struct pgpath 
 		goto out;
 
 	if (!pgpath->pg->ps.type) {
-		DMWARN("Reinstate path not supported by path selector %s",
-		       pgpath->pg->ps.type->name);
+		DMWARN("Reinstate path not supported by path selector");
 		r = -EINVAL;
 		goto out;
 	}

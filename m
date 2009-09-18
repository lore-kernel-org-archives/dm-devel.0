From: akpm@linux-foundation.org
Subject: [patch 3/3] drivers/md/dm-log-userspace-base.c: fix
	warning
Date: Fri, 18 Sep 2009 12:45:09 -0700
Message-ID: <200909181945.n8IJj9cE010432@imap1.linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

From: Andrew Morton <akpm@linux-foundation.org>

mips:

drivers/md/dm-log-userspace-base.c: In function `userspace_ctr':
drivers/md/dm-log-userspace-base.c:159: warning: cast from pointer to int=
eger of different size

Cc: Neil Brown <neilb@suse.de>
Cc: Jonathan Brassow <jbrassow@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log-userspace-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-log-userspace-base.c~drivers-md-dm-log-userspace-=
basec-fix-warning drivers/md/dm-log-userspace-base.c
--- a/drivers/md/dm-log-userspace-base.c~drivers-md-dm-log-userspace-base=
c-fix-warning
+++ a/drivers/md/dm-log-userspace-base.c
@@ -156,7 +156,7 @@ static int userspace_ctr(struct dm_dirty
 	}
=20
 	/* The ptr value is sufficient for local unique id */
-	lc->luid =3D (uint64_t)lc;
+	lc->luid =3D (unsigned long)lc;
=20
 	lc->ti =3D ti;
=20
_

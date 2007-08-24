From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH 26/30] md: vmalloc() returns void pointer so we
	don't need to cast it in dm-ioctl
Date: Fri, 24 Aug 2007 02:30:43 +0200
Message-ID: <d10569804357e6b76a0906a0864b2dfd128d2b3d.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-To: Jesper Juhl <jesper.juhl@gmail.com>
Resent-Message-ID: <200708240228.56770.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
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
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: dm-devel@redhat.com, Jesper Juhl <jesper.juhl@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

In drivers/md/dm-ioctl.c::copy_params() there's a call to vmalloc()
where we currently cast the return value, but that's pretty pointles
given that vmalloc() returns "void *".

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b441d82..efbf9b6 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1358,7 +1358,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 	if (tmp.data_size < sizeof(tmp))
 		return -EINVAL;
 
-	dmi = (struct dm_ioctl *) vmalloc(tmp.data_size);
+	dmi = vmalloc(tmp.data_size);
 	if (!dmi)
 		return -ENOMEM;
 
-- 
1.5.2.2

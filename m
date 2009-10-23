From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 04/17] dm snapshot: exception handover
	improvements
Date: Fri, 23 Oct 2009 11:01:34 -0400
Message-ID: <20091023150134.GA25363@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
	<1256078825-11331-5-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1256078825-11331-5-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 20 2009 at  6:46pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Simplify exception handover so that the duplicate snapshot is found in
> one location (snapshot_ctr) and recorded in the associated (old and new)
> snapshots that will be participating in the handover.
> 
> Confines handover to be from a specific snapshot to another specific
> snapshot without additional __find_duplicate() calls.
> 
> Documents the exception handover state diagram with relevant comments
> in the associated code.

In testing --onactivate support I found that my revised handover
incorrectly assumed that the snapshot-merge target _always_ needs the
exceptions explicitly handed over to it.

In reality --onactivate doesn't require any handover at all.  The
snapshot_ctr() for such a merge is provided with the correct cow_path up
front; so no handover is needed.

I also found that I was missing some locking when changing the "old"
snapshot's 'handover_snap' reference.

The following incremental patch addresses both these oversights; I'll be
posting v3 of this "dm snapshot: exception handover improvements"
shortly (it will include these fixes).

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index fca2479..e0330e3 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -982,13 +982,13 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		}
 
 		/* cross reference snapshots that will do handover */
+		down_write(&dup->lock);
 		dup->handover_snap = s;
+		up_write(&dup->lock);
 		s->handover_snap = dup;
+
 		/* this new snapshot will accept the handover */
 		s->handover = 1;
-	} else if (is_merge(ti)) {
-		ti->error = "Unable to find snapshot that is to be merged";
-		goto bad_load_and_register;
 	}
 
 	/* Metadata must only be loaded into one table at once */

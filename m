From: Ondrej Palkovsky <ondrap@penguin.cz>
Subject: Snapshot read consistency?
Date: Wed, 27 Apr 2005 21:55:58 +0200
Message-ID: <1114631758.6389.6.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I am trying to modify the snapshot code to slightly different layout of
the exception store (to mimic behaviour of some commercial systems), and
I came across the code to read data from snapshot. It seems to me that
if the code is preempted after the up_read(&s->lock), the pending
exception could be completed (or even new exception could be created and
written!), the new block could be written to the origin and then the
snapshot would read the new-incorrect data from origin. Highly
improbable, but possible? Am I correct or is there some other locking
mechanism that I have missed?

Ondrej

- snapshot_map(), dm-snap.c

	if (bio_rw(bio) == WRITE) {
.......
	} else {
		/*
		 * FIXME: this read path scares me because we
		 * always use the origin when we have a pending
		 * exception.  However I can't think of a
		 * situation where this is wrong - ejt.
		 */

		/* Do reads */
		down_read(&s->lock);

		/* See if it it has been remapped */
		e = lookup_exception(&s->complete, chunk);
		if (e)
			remap_exception(s, e, bio);
		else
			bio->bi_bdev = s->origin->bdev;

		up_read(&s->lock);
	}


-- 

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm snapshot: allow live exception store
	handover between tables
Date: Tue, 10 Nov 2009 22:26:25 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911102221470.3386@hs20-bc2-1.build.redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

> +	/*
> +	 * 'is_handover_destination' denotes another snapshot with the same
> +	 * cow block device (as identified with find_snapshot_using_cow)
> +	 * will hand over its exception store to this snapshot.
> +	 *
> +	 * 'is_handover_destination' is set in snapshot_ctr if an existing
> +	 * snapshot has the same cow device. The handover is performed,
> +	 * and 'is_handover_destination' is cleared, when either of the
> +	 * following occurs:
> +	 * - src (old) snapshot, that is handing over, is destructed
> +	 * - dest (new) snapshot, that is accepting the handover, is resumed
> +	 */
> +	int is_handover_destination;
> +
> +	/*
> +	 * reference to the other snapshot that will participate in the
> +	 * exception store handover; src references dest, dest references src
> +	 */
> +	struct dm_snapshot *handover_snap;

Hi

Please drop snapshot-linking through this "handover_snap" field, it will 
create real or possible problems with locking or with dangling pointers 
(i.e. are both properly locked? Which to lock first? If you destroy a 
snapshot, you must check if something links to it, etc. --- these problems 
could be solved, but if they can be avoided by dropping linking, it's 
better to avoid them).

When you are about to do a handover (Alasdair is arranging generic dm core 
do handover only un resume), just search for a possible handover candidate 
with find_snapshot_using_cow.

Mikulas

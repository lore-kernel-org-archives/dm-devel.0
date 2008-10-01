From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Block integrity patches for 2.6.28
Date: Wed,  1 Oct 2008 03:38:36 -0400
Message-ID: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


This patch series contains block layer integrity updates for 2.6.28.

There are a few fixes to the core bits, including a switch from
block_device to gendisk in the integrity compare function.  I also had
to add a helper to access a gendisk's integrity profile.  This is used
by MD.

The DM bits have been cleaned up and a separate dm_table_set_integrity
function has been introduced.  This allows us to avoid changing
dm_table_set_restrictions() and its callers.

The MD patch now correctly handles devices that come and go (as
requested by Neil).

The patches are against for-2.6.28 and depend on

    d7533ad0e132f92e75c1b2eb7c26387b25a583c1

being reverted.

--
Martin K. Petersen      Oracle Linux Engineering

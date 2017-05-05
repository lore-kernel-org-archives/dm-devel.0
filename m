From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 08/10] kpartx: use partition UUID for
	non-DM	devices
Date: Fri, 5 May 2017 23:30:05 +0100
Message-ID: <20170505223005.GH11857@agk-dp.fab.redhat.com>
References: <20170505220559.7248-1-mwilck@suse.com>
	<20170505220559.7248-9-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170505220559.7248-9-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, May 06, 2017 at 12:05:57AM +0200, Martin Wilck wrote:
> Introduce a "fake" UUID for these devices to make sure kpartx
> deletes only devices it had created previously. Otherwise kpartx
> might e.g. delete LVM LVs that are inside a device it is trying
> to delete partitions for. It seems to be wiser to make sure the
> user delete these manually before running "kpartx -d".
> 
> With the fake UUID in place, we can re-introduce the UUID check
> for non-DM device that was removed in the earlier patch
> "kpartx: dm_remove_partmaps: support non-dm devices".
> 
> This disables also deletion of partition mappings created
> by earlier versions of kpartx. If kpartx has been updated after
> partition mappings were created, the "-f" flag can be used
> to force delting these partitions, too.
 
Indeed - always supply a uuid for every dm device created.
Add a standard prefix to the beginning of it, ideally "KPARTX-" to be
consistent with other dm tools ("LVM-", "CRYPT-" etc.) if you're
able to break compatibility, but "part" is still unique and adequate.  
(Stacked devices can end up with a stack of prefixes - only the leftmost one
counts.)

Alasdair

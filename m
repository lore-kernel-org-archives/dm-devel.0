From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [DRAFT] Snapshot boot design document
Date: Thu, 8 Jun 2017 15:34:10 +0100
Message-ID: <20170608143410.GB32358@dhcp-24-191.fab.redhat.com>
References: <20170601204734.GB3619@localhost.localdomain>
	<20170607162330.GA10393@suse.de> <20170608081705.GA18236@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170608081705.GA18236@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thorsten Kukuk <kukuk@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 08, 2017 at 10:17:05AM +0200, Thorsten Kukuk wrote:
> On Wed, Jun 07, Thorsten Kukuk wrote:
> One more: please don't forget read-only root filesystems with all of
> your designs. btrfs snapshots are read-only, so if you boot an old
> snapshot, you have a read-only root filesystem.
> And if you play with transactional updates by snapshots and rollback,
> you will really like read-only root filesystems.

Good point again, thanks. Coming from a device-mapper and LVM2 background
that's my natural priority, but we are very clear that we want to create
a solution that will work for the full range of snapshot techniques now
available on Linux (including potentially ZFS although it's not a high
priority, simply due to how few distributions ship it).

Regards,
Bryn.

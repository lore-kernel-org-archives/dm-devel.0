From: Thorsten Kukuk <kukuk@suse.de>
Subject: Re: [DRAFT] Snapshot boot design document
Date: Thu, 8 Jun 2017 10:17:05 +0200
Message-ID: <20170608081705.GA18236@suse.de>
References: <20170601204734.GB3619@localhost.localdomain>
	<20170607162330.GA10393@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170607162330.GA10393@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Wed, Jun 07, Thorsten Kukuk wrote:

> 
> Hi,
> 
> On Thu, Jun 01, Bryn M. Reeves wrote:
> 
> > We're drafting a proposal for a generic snapshot boot mechanism, to
> > allow booting into previous snapshots of the system for LVM2 and
> > BTRFS volumes (as well as Stratis[1] in the future).
> 
> I like that proposal.
> 
> Some comments from me:

One more: please don't forget read-only root filesystems with all of
your designs. btrfs snapshots are read-only, so if you boot an old
snapshot, you have a read-only root filesystem.
And if you play with transactional updates by snapshots and rollback,
you will really like read-only root filesystems.

  Thorsten

-- 
Thorsten Kukuk, Distinguished Engineer, Senior Architect SLES & CaaSP
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nuernberg, Germany
GF: Felix Imendoerffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nuernberg)

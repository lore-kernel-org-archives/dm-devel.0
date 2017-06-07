From: Thorsten Kukuk <kukuk@suse.de>
Subject: Re: [DRAFT] Snapshot boot design document
Date: Wed, 7 Jun 2017 18:23:30 +0200
Message-ID: <20170607162330.GA10393@suse.de>
References: <20170601204734.GB3619@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170601204734.GB3619@localhost.localdomain>
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


Hi,

On Thu, Jun 01, Bryn M. Reeves wrote:

> We're drafting a proposal for a generic snapshot boot mechanism, to
> allow booting into previous snapshots of the system for LVM2 and
> BTRFS volumes (as well as Stratis[1] in the future).

I like that proposal.

Some comments from me:

We use snapshots currently for another use case: transactional updates.
Means, create a snapshot, update the system inside of the snapshot and
if no error occurs, mark this snapshot as the new default root filesystem
for the next reboot.

About Future extensions: I see 
1.4.1 Goal: Simplify management of large numbers of snapshots 

The biggest roblems we see with our customers are already very good
summarized there, that's why I think this is something important
for the tools, the one taking the snapshot and the boot manager.
And should be for that reason not only be a future extension.

Wish from me for a future extension:
Automatic rollback on boot failure. If this happens after the root
filesystem is mounted, it is pretty trivial. But if the problem is
that the harddisk cannot be found, maybe because the kernel update
has problems with the harddisk controller, this needs help of the
boot manager.

2 Linux boot process management

Isn't there "gummiboot" missing? To my knowledge this is needed
for the Rasperry PI 3.

Between, it's openSUSE, lower O, upper U, since the beginning.
Same for SUSE, it's upper U since 18 years or so.

2.3.2 perl-Bootlaoder
Support for anything else beside grub2 is, if not already removed,
outdated and no longer official supported.

5.3.3 Support expiry of snapshots by user specified policy
You should consider something like priorisation for snapshots. Else the
result of a lot of small changes to config files can lead to deletion
of snapshots with the real big changes.
For that reason we had to introduce this for SLES, else a rollback
wouldn't have been possible too fast.

  Thorsten

-- 
Thorsten Kukuk, Distinguished Engineer, Senior Architect SLES & CaaSP
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nuernberg, Germany
GF: Felix Imendoerffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nuernberg)

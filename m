From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 1/3] sysfs representation of stacked devices
	(dm/md common)
Date: Tue, 21 Feb 2006 10:33:40 -0500
Message-ID: <43FB32D4.3080101@ce.jp.nec.com>
References: <43F60F31.1030507@ce.jp.nec.com> <43F60F8C.8090207@ce.jp.nec.com>
	<20060217184435.GM12169@agk.surrey.redhat.com>
	<43F67274.80509@ce.jp.nec.com>
	<20060218195005.GT12169@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060218195005.GT12169@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Thanks Alasdair and Neil,

Alasdair G Kergon wrote:
> Test with trees of devices too - where a whole tree is suspended -

Suspending maps in the tree and reload one of them?
I'll try that.

> I don't think you can allocate anywhere in dm_swap_table()
> without PF_MEMALLOC (which I recently removed and am reluctant
> to reinstate).

I understand your reluctance and I don't want to revive it either.
I think moving sysfs_add_link() outside of dm_swap_table() solves
this. Am I right?
Or do you want to eliminate the possibility that sysfs_remove_symlink()
may require memory allocation in future?

Anyway, I'll seek for bd_claim based approach.

> Have you considered if anything is feasible based around bd_claim()?
> Doesn't it make more sense for the links to be set up at table
> load time - i.e. superset of both tables if present?

I think it makes sense. But I have difficulty with it.

What I once thought was extending bd_claim() like:
   bd_claim_with_owner(bdev, void *holder, struct kobject *owner)
where "owner" is a kobject for "slaves" directory.
We may have the object embedded in gendisk structure.
Then we can create symlinks like:
   /sys/block/<bdev>/holders/<owner> --> /sys/block/<owner>
   /sys/block/<owner>/slaves/<bdev> --> /sys/block/<bdev>

This should work for md.

However, dm needs more for its flexibility.
Because multiple dm devices can hold one device and one dm device
can hold a device twice (i.e. current table and new table),
we need to reference-count per relationship basis, not per slave
device.
This might be solved by allocating management struct in bd_claim()
to reference-counting the relationship.
I'll try this. Comments are welcome.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

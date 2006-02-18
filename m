From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] sysfs representation of stacked devices
	(dm/md common)
Date: Sat, 18 Feb 2006 19:50:05 +0000
Message-ID: <20060218195005.GT12169@agk.surrey.redhat.com>
References: <43F60F31.1030507@ce.jp.nec.com> <43F60F8C.8090207@ce.jp.nec.com>
	<20060217184435.GM12169@agk.surrey.redhat.com>
	<43F67274.80509@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43F67274.80509@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 17, 2006 at 08:03:48PM -0500, Jun'ichi Nomura wrote:
> I moved the sysfs_add_link() to the last part of dm_resume().

Test with trees of devices too - where a whole tree is suspended -
I don't think you can allocate anywhere in dm_swap_table()
without PF_MEMALLOC (which I recently removed and am reluctant
to reinstate).

Have you considered if anything is feasible based around bd_claim()?
Doesn't it make more sense for the links to be set up at table
load time - i.e. superset of both tables if present?

Alasdair
-- 
agk@redhat.com

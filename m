From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 6/7] bio-cgroup: Implement the bio-cgroup
Date: Fri, 08 Aug 2008 17:30:45 +0900 (JST)
Message-ID: <20080808.173045.112614776.ryov@valinux.co.jp>
References: <20080804.175934.112619046.ryov@valinux.co.jp>
	<20080804.180022.183027902.ryov@valinux.co.jp>
	<489BF14D.6050009@oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <489BF14D.6050009@oss.ntt.co.jp>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: yoshikawa.takuya@oss.ntt.co.jp
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org
List-Id: dm-devel.ids

Hi Yoshikawa-san,

> > +static void bio_cgroup_move_task(struct cgroup_subsys *ss,
> > +				struct cgroup *cont,
> > +				struct cgroup *old_cont,
> > +				struct task_struct *p)
> > +{
> > +	struct mm_struct *mm;
> > +	struct bio_cgroup *biog, *old_biog;
> > +
> > +	if (bio_cgroup_disabled())
> > +		return;
> > +
> > +	mm = get_task_mm(p);
> > +	if (mm == NULL)
> > +		return;
> > +
> > +	biog = cgroup_bio(cont);
> > +	old_biog = cgroup_bio(old_cont);
> > +
> > +	mmput(mm);
> > +	return;
> > +}
> 
> Is this function fully implemented?

This function can be more simplified, there is some unnecessary code 
from old version.

> I tried to put a process into a group by writing to
> "/cgroup/bio/BGROUP/tasks" but failed.

Could you tell me what you actually did? I will try the same thing.

--
Ryo Tsuruta <ryov@valinux.co.jp>

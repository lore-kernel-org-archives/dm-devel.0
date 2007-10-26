From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: noflush resizing (0/3)
Date: Fri, 26 Oct 2007 01:37:53 +0100
Message-ID: <20071026003753.GO10006@agk.fab.redhat.com>
References: <471FB83D.4060307@ce.jp.nec.com>
	<20071025012456.GK10006@agk.fab.redhat.com>
	<4720A59A.8060001@ce.jp.nec.com>
	<20071025144833.GN10006@agk.fab.redhat.com>
	<4720E479.4020906@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4720E479.4020906@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Oct 25, 2007 at 02:46:17PM -0400, Jun'ichi Nomura wrote:
> So as far as I understand, the point is:
>   1. it's preferable to resize inode after the resume, if possible

Not quite - I'm not expressing a preference yet.

I'm saying the patches you presented were one option to resolve the
problem, but it was not obvious to me they are the only option and I
wanted to see a deeper analysis (keeping in mind the general direction
I want the device-mapper code to be heading in).

In other words, an analysis that draws out the conflict at the heart of
this problem, and whether the problem we have with this locking is
intrinsic to the current design or just a matter of implementation that
can be fixed with some re-ordering or tweaks to the usage rules or types
of the locks.

Alasdair
-- 
agk@redhat.com

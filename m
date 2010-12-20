From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: update workqueue usages
Date: Mon, 20 Dec 2010 09:14:48 -0500
Message-ID: <20101220141448.GA27280@redhat.com>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
	<4D053D49.1010605@redhat.com> <4D079205.3010204@kernel.org>
	<20101214160324.GB7944@redhat.com> <4D0795B2.7010606@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4D0795B2.7010606@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Dec 14 2010 at 11:05am -0500,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 12/14/2010 05:03 PM, Mike Snitzer wrote:
> > I'll be reviewing your workqueue patches today.  I can take care of
> > rebasing the patches as needed ontop of Alasdair's quilt tree (up to
> > dm-raid1-support-discard.patch):
> > http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/series
> > 
> > Once I've folded your patches in I will share the url for resulting
> > quilt tree.
> 
> Thanks.  I'll hold off for now then.

Hi Tejun,

I've refreshed your patches, tweaked the patch headers and subjects a
bit and added my Signed-off-by.  I've staged them in a quilt tree for
Alasdair to pick up here:
http://people.redhat.com/msnitzer/patches/upstream/for-agk/series.html

(your patches are at the end, 0005-0010).

Thanks,
Mike

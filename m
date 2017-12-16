From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: dm-verity: aggregate crypto API calls
Date: Fri, 15 Dec 2017 20:58:21 -0500
Message-ID: <20171216015820.GA20853@redhat.com>
References: <1508921899-24801-1-git-send-email-yael.chemla@foss.arm.com>
	<20171025151916.GA28274@redhat.com>
	<008101d374b0$c4b5ef00$4e21cd00$@foss.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <008101d374b0$c4b5ef00$4e21cd00$@foss.arm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: yael.chemla@foss.arm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 14 2017 at  2:54am -0500,
yael.chemla@foss.arm.com <yael.chemla@foss.arm.com> wrote:

> we are trying to be able to parallalize the handling of blocks, this
> patch is a precursor to that effort. 
> currently this patch does not change CPU utiliztion but we wanted to
> veritfy there is no objection to the direction first, hence sending
> the patch.

If it doesn't improve cpu utilization then it doesn't need to go in
now.  But I'll revisit once the dust settles on some other work I'm
focused on.

Thanks,
Mike

From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-statistics: report precise timestamps and
	histogram
Date: Tue, 18 Aug 2015 17:41:12 -0400
Message-ID: <20150818214112.GA17757@redhat.com>
References: <alpine.LRH.2.02.1508181618100.19666@file01.intranet.prod.int.rdu2.redhat.com>
	<20150818210727.GA17473@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150818210727.GA17473@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Bryn Reeves <breeves@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 18 2015 at  5:07pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Aug 18 2015 at  4:26pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Mike, please submit this patch to the upstream kernel before 4.2 is 
> > released, so that the all the kernels that support the options 
> > "precise_timestamps" and "histogram" also report these values back.
> 
> It is really late to be sending pull requests for 4.2 (next release is
> likely 4.2 final).  I've already sent 6 'fixes' pull requests to Linus
> for 4.2.  This patch is just too late, sorry.
> 
> But what I will do is tag this commit for 4.2-stable inclusion.
> 
> Userspace will have to check the DM ioctl version to know if DM provides
> these extra keywords.

I've staged the following for 4.3:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=bd49784fd1e8f42c7600fbfa206361324857f373

Bryn, please verify this change is sufficient for your needs.

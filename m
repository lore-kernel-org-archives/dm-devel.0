From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Tue, 18 Feb 2014 20:14:02 -0500
Message-ID: <20140219011401.GA17796@redhat.com>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<52B2AC96.8010909@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52B2AC96.8010909@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 19 2013 at  3:21am -0500,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 12/18/13 16:28, Stewart, Sean wrote:
> > The most severe case is with
> > InfiniBand, where the LLD may place a device offline, then every single
> > reload that is trying to add a good path in will fail.  I will qualify
> > this by saying that I realize it is a problem that the device gets
> > placed offline in the first place, but this patch would allow it a
> > chance to continue on. The user still has to take manual steps to fix
> > the problem in this case, but it seems less disruptive to applications.
> 
> Are you perhaps referring to the SRP initiator ? The above is correct
> for old versions of the SRP initiator (< Linux kernel 3.12) but no
> longer for upstream kernel versions >= 3.12. An effort is ongoing to
> backport the latest SRP initiator changes into RHEL and SLES.

Hi Bart,

It has been a while.  Where do things stand for the RHEL backport of
these SRP initiator changes?  Are we talking RHEL6 and RHEL7?  Who at
Red Hat is your contact for this work?

Regardless of whether some version of Hannes's patch is applied to
upstream dm-mpath: I'd really like to see this offlining problem that
forced the need for this dm-mpath change addressed.

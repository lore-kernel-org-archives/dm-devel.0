From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Wed, 19 Feb 2014 09:11:55 +0100
Message-ID: <5304674B.4020001@acm.org>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<52B2AC96.8010909@acm.org> <20140219011401.GA17796@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140219011401.GA17796@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/19/14 02:14, Mike Snitzer wrote:
> On Thu, Dec 19 2013 at  3:21am -0500,
> Bart Van Assche <bvanassche@acm.org> wrote:
> 
>> On 12/18/13 16:28, Stewart, Sean wrote:
>>> The most severe case is with
>>> InfiniBand, where the LLD may place a device offline, then every single
>>> reload that is trying to add a good path in will fail.  I will qualify
>>> this by saying that I realize it is a problem that the device gets
>>> placed offline in the first place, but this patch would allow it a
>>> chance to continue on. The user still has to take manual steps to fix
>>> the problem in this case, but it seems less disruptive to applications.
>>
>> Are you perhaps referring to the SRP initiator ? The above is correct
>> for old versions of the SRP initiator (< Linux kernel 3.12) but no
>> longer for upstream kernel versions >= 3.12. An effort is ongoing to
>> backport the latest SRP initiator changes into RHEL and SLES.
> 
> It has been a while.  Where do things stand for the RHEL backport of
> these SRP initiator changes?  Are we talking RHEL6 and RHEL7?  Who at
> Red Hat is your contact for this work?
> 
> Regardless of whether some version of Hannes's patch is applied to
> upstream dm-mpath: I'd really like to see this offlining problem that
> forced the need for this dm-mpath change addressed.

Hello Mike,

At https://github.com/bvanassche/ib_srp-backport a version of the SRP
initiator driver can be found that works fine with at least RHEL 6.3,
6.4, 6.5 and SLES 11. I have not yet had a chance to test that driver
against RHEL 7. The SRP initiator driver backport includes all changes
that have been accepted upstream up to and including kernel 3.14-rc3.
That means that both versions of the SRP initiator driver include the
code that changes the SCSI device state from "offline" into "running"
after reconnecting succeeded after a cable pull. The relevant RHEL
bugzilla entries are as follows:
* https://bugzilla.redhat.com/show_bug.cgi?id=1012926
* https://bugzilla.redhat.com/show_bug.cgi?id=1055654

Thanks,

Bart.

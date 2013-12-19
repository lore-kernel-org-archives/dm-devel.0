From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Thu, 19 Dec 2013 09:21:42 +0100
Message-ID: <52B2AC96.8010909@acm.org>
References: <1387353155-7271-1-git-send-email-hare@suse.de>	<20131218140858.GC17730@redhat.com>
	<52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 12/18/13 16:28, Stewart, Sean wrote:
> The most severe case is with
> InfiniBand, where the LLD may place a device offline, then every single
> reload that is trying to add a good path in will fail.  I will qualify
> this by saying that I realize it is a problem that the device gets
> placed offline in the first place, but this patch would allow it a
> chance to continue on. The user still has to take manual steps to fix
> the problem in this case, but it seems less disruptive to applications.

Are you perhaps referring to the SRP initiator ? The above is correct
for old versions of the SRP initiator (< Linux kernel 3.12) but no
longer for upstream kernel versions >= 3.12. An effort is ongoing to
backport the latest SRP initiator changes into RHEL and SLES.

Bart.

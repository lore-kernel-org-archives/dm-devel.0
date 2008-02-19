From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath not rebuilding correctly on reboot
Date: Tue, 19 Feb 2008 11:21:45 -0600
Message-ID: <20080219172145.GH15608@ether.msp.redhat.com>
References: <20080218222014.GA26319@us.ibm.com>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F203@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F203@exchmail03.ncogroup.com>
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
List-Id: dm-devel.ids

On Tue, Feb 19, 2008 at 07:21:19AM -0500, Greene, Rick wrote:
> I just checked one of my RHEL5 servers, and it does have udevsettle, so
> it looks like I'm stuck with my current rc.local workaround.
> 
> >From what you said before, maybe sticking a sleep in rc.sysinit before
> the multipath.static is called could also help?  If so, how long a sleep
> would you suggest?

You'll probably need to experiment. Start with something like 5. If that
works, try cutting it down.

I'll try to get a test-rpm with the patch I sent earlier built
soonish, so you can try that.

I don't think udevsettle would help things anyway.  It looks like your
devices may have come online before udev was started. In that case, udev
won't handle them, which is why the multipath call exists in rc.sysinit.

-Ben
 
> Thanks,
> Rick
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of malahal@us.ibm.com
> Sent: Monday, February 18, 2008 5:20 PM
> To: dm-devel@redhat.com
> Subject: Re: [dm-devel] Multipath not rebuilding correctly on reboot
> 
> Greene, Rick [rick.greene@ncogroup.com] wrote:
> > Quick question...what RPM would I find udevsettle in? Doesn't appear
> to
> > be installed on my system (RedHat Enterprise Linux 4), nor can I find
> > reference to it on RedHat's site.
> 
> Part of udev rpm (udev-085-30.37) on my system (SLES10 SP1). Maybe RHEL4
> has an older version of udev that lacks udevsettle. That explains why
> they used a "sleep"!
> 
> --Malahal.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

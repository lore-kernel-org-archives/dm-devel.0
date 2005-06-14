From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: tools target for SLES9 SP2 and RHEL4 U2
Date: Tue, 14 Jun 2005 13:44:34 +0200
Message-ID: <20050614114434.GA12019@averon.dyndns.org>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<20050610061033.GA9474@us.ibm.com>
	<20050610104711.GC20162@marowsky-bree.de>
	<20050614103450.GH25295@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050614103450.GH25295@marowsky-bree.de>
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

On Tue, Jun 14, 2005 at 12:34:50PM +0200, Lars Marowsky-Bree wrote:
> On 2005-06-10T12:47:11, Lars Marowsky-Bree <lmb@suse.de> wrote:
> 
> > > What about multipathd's use of uevents for dm updates and the distro
> > > kernels currently not supporting this capability. Will a person just have
> > > to restart multipathd if one changes the dm config and a newer kernel is
> > > not being used?
> > We'll need a workaround for that, or back it out for our distribution
> > and go back to the signal version...
> 
> So any comments on this one, christophe?
> 
> Maybe fallback to signals if the kernel version is too old? Or should we
> maintain a separate patch for the distribution?
> 
I'm sure you understand this patch is rather invasive.
I'm clearly reluctant to maintain backward compatibility on this point.

Distributors assuming the burden of it is not nice either.

Have you pondered backporting the uevent kernel patch : it seems rather safe (from my seat, that is :)

Regards,
cvaroqui

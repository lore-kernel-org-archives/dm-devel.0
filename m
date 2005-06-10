From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: tools target for SLES9 SP2 and RHEL4 U2
Date: Fri, 10 Jun 2005 08:44:20 +0200
Message-ID: <20050610064420.GA16369@averon.dyndns.org>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<20050610061033.GA9474@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050610061033.GA9474@us.ibm.com>
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

On Thu, Jun 09, 2005 at 11:10:33PM -0700, Mike Anderson wrote:
> Alasdair G Kergon [agk@redhat.com] wrote:
> > On Thu, Jun 09, 2005 at 08:16:42PM +0200, christophe varoqui wrote:
> > > Should we stabilize a 0.4.5 out of the git head
> > 
> > Yes - both distributions are basing their next package on your 
> > current git head.
> > 
> 
> What about multipathd's use of uevents for dm updates and the distro
> kernels currently not supporting this capability. Will a person just have
> to restart multipathd if one changes the dm config and a newer kernel is
> not being used?
> 
And should we consider moving the libdevmapper event daemon framework for 0.4.5 ?

Regards,
cvaroqui

From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: tools target for SLES9 SP2 and RHEL4 U2
Date: Thu, 9 Jun 2005 23:10:33 -0700
Message-ID: <20050610061033.GA9474@us.ibm.com>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050609191541.GO15809@agk.surrey.redhat.com>
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

Alasdair G Kergon [agk@redhat.com] wrote:
> On Thu, Jun 09, 2005 at 08:16:42PM +0200, christophe varoqui wrote:
> > Should we stabilize a 0.4.5 out of the git head
> 
> Yes - both distributions are basing their next package on your 
> current git head.
> 

What about multipathd's use of uevents for dm updates and the distro
kernels currently not supporting this capability. Will a person just have
to restart multipathd if one changes the dm config and a newer kernel is
not being used?

-andmike
--
Michael Anderson
andmike@us.ibm.com

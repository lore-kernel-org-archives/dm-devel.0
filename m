From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Clariion CX600 automatic failback support
Date: Mon, 7 Nov 2005 13:25:10 -0600
Message-ID: <20051107192510.GC26529@phlogiston.msp.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321AD96@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AD96@SRMANNING.eng.emc.com>
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

On Wed, Nov 02, 2005 at 04:32:06PM -0500, goggin, edward wrote:
> On Date: Mon, 31 Oct 2005 08:58:06 -0500
> Brian Long <brilong@cisco.com> wrote 
> 
> > 
> > On Wed, 2005-10-26 at 15:37 -0400, Phil Lowden (plowden) wrote:
> > > I'm using LVM2 with device-mapper-multipath 0.4.5 on GA 
> > RHEL 4 update 2 
> > > release, kernel version 2.6.9-22.ELsmp.  Storage is 4 Clariion CX600
> > > LUNs, 
> > > 2 with a primary path on SP A and 2 on SP B.  HBAs are QLA3240 with
> > > firmware 3.03.15 IPX and the RedHat-distributed driver version
> > > 8.01.00b5-rh2.
> > > 
> > > When I disrupt one path by disabling a host or SP switch port,
> > > failover works great but failback doesn't happen automatically
> > > with the current config (below).  By this I mean
> > > when the connection to e.g. SP B is restored, all
> > > 4 LUNs stay trespassed to SP A.  Is this by design?
> > > Or is there support for automatic failback, i.e.
> > > I/O is paused and a trespass is issued to restore
> > > the 2 SP B LUNs to their primary paths?
> > > 
> > > Of course manual failback is possible, but without
> > > quiescing I/O I found I was able to munge my LVM2
> > > objects up quite nicely.  Manual failback with quiesced 
> > > I/O is fine.
> > 
> > No one has automatic failback working on Clarrion storage?
> 
> Unfortunately, this doesn't just work "out of the box" yet.
> 
> You need to setup a default failback setting of immediate in the
> /etc/multipath.conf configuration file, ...
> 
> 	defaults {
> 		failback 	immediate
> 	}
> 
> ... or selectively set the failback setting to immediate in the
> multipath config file for each EMC CLARiiON logical unit
> 
> 	multipaths {
> 		multipath {
> 			wwid	360061 ...
> 			failback	immediate
> 		}
> 		...
> 	}
> 
> Setting this attribute value for the entire EMC CLARiiON class of
> devices via the multipath config file "device" attribute doesn't
> work because of a bug (mpp->hwe field is never set for multipathd)
> in the multipathd code which is patched to work by the single line
> patch below.  Due to the same bug, a patch I submitted many weeks
> ago to libmultipath/hwtable.c to setup the default failback policy
> for EMC CLARiiON to immediate also does not work.
> 
> Once the distributors pick up both this single line change and the
> change in hwtable.c, immediate path group failback for CLARiiON
> will just work.

These changes are both in the RHEL4 U3 code.
 
> -------------------------------------------------------------------
> diff --git a/multipathd/main.c b/multipathd/main.c
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -146,6 +146,7 @@ adopt_paths (struct vectors * vecs, stru
>  		if (!strncmp(mpp->wwid, pp->wwid, WWID_SIZE)) {
>  			condlog(4, "%s ownership set", pp->dev_t);
>  			pp->mpp = mpp;
> +			mpp->hwe = pp->hwe;
>  		}
>  	}
>  }
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

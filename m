From: Joe Thornber <thornber@redhat.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Fri, 29 Jan 2016 16:04:21 +0000
Message-ID: <20160129160420.GA23215@rh-vpn>
References: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
	<569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
	<20160121194405.GA22766@redhat.com>
	<20160122133828.GN26774@soda.linbit>
	<20160122164345.GA15295@rh-vpn>
	<20160129145031.GD32614@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160129145031.GD32614@soda.linbit>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 29, 2016 at 03:50:31PM +0100, Lars Ellenberg wrote:
> On Fri, Jan 22, 2016 at 04:43:46PM +0000, Joe Thornber wrote:
> > On Fri, Jan 22, 2016 at 02:38:28PM +0100, Lars Ellenberg wrote:
> > > We have seen lvremove of thin snapshots sometimes minutes,
> > > even ~20 minutes before.
> > 
> > I did some work on speeding up thin removal in autumn '14, in
> > particular agressively prefetching metadata pages sped up the tree
> > traversal hugely.  Could you confirm you're seeing pauses of this
> > duration with currently kernels please?
> 
> There is 
> https://bugzilla.redhat.com/show_bug.cgi?id=990583
> Bug 990583 - lvremove of thin snapshots takes 5 to 20 minutes (single
> core cpu bound?) 
> 
> >From August 2013, closed by you in October 2015,
> as "not a bug", also pointing to meta data prefetch.
> 
> Now, you tell me, how prefetching meta data (doing disk IO
> more efficiently) helps with something that is clearly CPU bound
> (eating 100% single core CPU traversing whatever)...
> 
> Reason I mention this bug again here is:
> there should be a lvm thin meta data dump in there,
> which you could use for benchmarking improvements yourself.

There is no metadata dump attached to that bug.  I do benchmark stuff
myself, and I found prefetching to make a big difference (obviously
I'm not cpu bound like you).  We all have different hardware, which is
why I ask people with more real world scenarios to test stuff separately.

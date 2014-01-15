From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache for Fedora 21?
Date: Wed, 15 Jan 2014 10:34:46 +0000
Message-ID: <20140115103446.GA7943@debian>
References: <52D15B93.8000500@rolffokkens.nl> <20140113101800.GC4984@debian>
	<061301cf10a2$b58b37e0$20a1a7a0$@acm.org>
	<20140114102148.GC6450@debian> <52D5C739.1070504@rolffokkens.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52D5C739.1070504@rolffokkens.nl>
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
List-Id: dm-devel.ids

On Wed, Jan 15, 2014 at 12:24:41AM +0100, Rolf Fokkens wrote:
> On 01/14/2014 11:21 AM, Joe Thornber wrote:
> >On Mon, Jan 13, 2014 at 01:01:58PM -0800, Paul B. Henson wrote:
> >>Just out of curiosity, when do you think you will remove the experimental
> >>tag? 3.14? 3.15? Or too soon yet to tell :)?
> >Once I finish the dm-era work (which makes dm-cache play nicely with
> >snapshots on external devices).  potentially 3.14.
> This is all very promising for F21. AFAIK dm-cache can be integrated
> with / applied to existing volumes / device mapper targets which
> would imply that (as opposed to bcache) no migration of existing LVM
> volumes to dm-cache is need. An this would also mean that there's no
> need to integrate it explicitly in Anaconda, since is dm-cache can
> be applied after installation. Is my understanding correct?

I'm not sure what the LVM interface to caching will look like.  But
I'd expect you to be able to point to any existing volume and say
'speed that up with XG of cache'.

Mike Snitzer tells the 3.14 merge window is opening very soon, so
we'll aim to drop the experimental tag in 3.15.

- joe

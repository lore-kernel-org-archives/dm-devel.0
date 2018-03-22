From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 1/2] libmultipath: don't reject maps with
 undefined prio
Date: Thu, 22 Mar 2018 18:52:25 -0500
Message-ID: <20180322235225.GE3103@octiron.msp.redhat.com>
References: <20180321093419.9295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180321093419.9295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 21, 2018 at 10:34:18AM +0100, Martin Wilck wrote:
> libmultipath's prio routines can deal with pp->priority == PRIO_UNDEF
> just fine. PRIO_UNDEF is just a very low priority. So there's
> no reason to reject setting up a multipath map because paths have
> undefined priority.
> 

The problem with this is that presumably, if there is a prioritizer set,
then the paths aren't supposed to be in the same pathgroup.  If this is
the case and you end up setting all the paths to the same pathgroup
because the prioritizer is wrong, you will likely have a bad experience.
Either you will frequently be writing to a non-optimized path (which can
auto-trespass and become an optimized one in some arrays, causing
horrible ping-ponging), or some of your paths will just always keep
getting restored and then failed, since they require a manual trespass
to be actually usable, but ghost paths are treated as usable by the kernel.

If you just set the priortizer for this device to const (or whatever
make sense if the device isn't alua) and have detect_prio enabled, won't
it correctly detect an alua prioritizer when it is supported, and
failback to const when not?

-Ben

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index fa6e21cb31af..bb3d8771592d 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -993,9 +993,6 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  			continue;
>  		}
>  
> -		if (pp1->priority == PRIO_UNDEF)
> -			mpp->action = ACT_REJECT;
> -
>  		if (!mpp->paths) {
>  			condlog(0, "%s: skip coalesce (no paths)", mpp->alias);
>  			remove_map(mpp, vecs, 0);
> @@ -1021,8 +1018,6 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  					mpp->size);
>  				mpp->action = ACT_REJECT;
>  			}
> -			if (pp2->priority == PRIO_UNDEF)
> -				mpp->action = ACT_REJECT;
>  		}
>  		verify_paths(mpp, vecs);
>  
> -- 
> 2.16.1

From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 04/16] libmultipath: should_multipath:
 keep existing maps
Date: Fri, 19 Jan 2018 10:06:51 -0600
Message-ID: <20180119160651.GC5638@octiron.msp.redhat.com>
References: <20180119002916.10323-1-mwilck@suse.com>
	<20180119002916.10323-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180119002916.10323-5-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Fri, Jan 19, 2018 at 01:29:04AM +0100, Martin Wilck wrote:
> If with find_multipaths and !ignore_new_devs, if a path is already
> multipathed, keep it. The same logic is applied in multipath -u
> with ignore_wwids.

One question, why the requirement that (first_path(mp) != NULL)?
It seems possible that we have a multipath device that is in use and
loses all of it's path devices.  When the first path is rediscovered,
we want to add it back immediately.  Obviously, the wwid check should
take care of this. But if we think we need this check as a backup, then
I don't see why we wouldn't want to accept the first path?

Also, I have one small worry, but I'm pretty convinced that I'm just
being paranoid. There is a case where this will be more lenient in
accepting devices than our existing code, and possibly too lenient.
Right now, we only add a wwid to the wwids file after a multipath device
has been successfully created.  But we add the multipath device to the
mpvec before we try to create it.  I can't think of a case where we
would add a device the the mpvec where we shouldn't be accepting paths
to that device as multipathable, but the ordering difference seems a
little worrying.

Both of these could be avoided, albeit a little slower, by actually
getting a listing multipath devices from dm, and checking against their
wwids. This is what the multipath command is doing, so we would be using
the exact same logic in both places.  I really wish you could get a list
of dm devices by wwid as easily as you can by name.

Another option is, as I mentioned before, to trust that any multipath
device will have it's wwid in the wwids file. Have you seen a case where
this doesn't happen?

-Ben

> ---
>  libmultipath/wwids.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index fcbf5281b491..828a3de5b5cb 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c
> @@ -287,6 +287,13 @@ should_multipath(struct path *pp1, vector pathvec, vector mpvec)
>  
>  	condlog(4, "checking if %s should be multipathed", pp1->dev);
>  	if (!ignore_new_devs) {
> +		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
> +
> +		if (mp != NULL && first_path(mp) != NULL) {
> +			condlog(3, "wwid %s is already multipathed, keeping it",
> +				pp1->wwid);
> +			return 1;
> +		}
>  		vector_foreach_slot(pathvec, pp2, i) {
>  			if (pp1->dev == pp2->dev)
>  				continue;
> -- 
> 2.15.1

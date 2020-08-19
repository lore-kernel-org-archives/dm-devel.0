From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 5/5] libmultipath fix daemon memory leak in
 disassemble_map
Date: Wed, 19 Aug 2020 10:26:15 +0200
Message-ID: <d76537854b7e9171738cf8db094319088bb13c3a.camel@suse.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
	<e15fee1e-145b-2880-c84a-aba7b1496555@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e15fee1e-145b-2880-c84a-aba7b1496555@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: linfeilong@huawei.com, dm-devel mailing list <dm-devel@redhat.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

Hello lixiaokeng,

Thanks again for your contribution.

On Wed, 2020-08-19 at 09:50 +0800, lixiaokeng wrote:
> 
> If checking is_deamon is deleted, there are many other things need be
> done like in
> https://www.redhat.com/archives/dm-devel/2020-July/msg00245.html. And
> this
> branch develops from 0.8.3 but upstream_queue is mainline which
> develops from
> 0.8.4.

This is a misunderstanding. My upstream-queue branch is *not* mainline.
Mainline is http://git.opensvc.com/multipath-tools/.git. Also, my
entire patch series (link above) was based on upstream-queue, which in
turn was based on 0.8.4, not 0.8.3.

As the name says, "upstream-queue" represents the queue of pending
patches which have at least one positive review (and no negative ones).
The intention is 1. to provide an overview for myself and other
interested parties, and 2. to simplify matters for the actual
maintainer, Christophe, when he applies patches onto mainline.

My patch series changes the same code path as this one, and I think it
solves the same issue, albeit differently. Most of my series has
meanwhile been positively reviewed by Ben, and the remaining open
issues are in other parts of the series. I'll hopefully be able to push
it to upstream-queue soon. IMO it makes little sense to push changes to
upstream-queue which are going to be removed again when my series is
applied (I don't intend to start using merge operations in this
branch).

Christophe is on the recipients list of your patch. He may of course
decide to apply your patch before my series, in which case I'll have to
rebase mine. But he'll probably have other prior patches to look at
first before he gets down to this one.

Regards,
Martin

> Here, we skip alloc_path if pp isn't find in pathvec and process is
> daemon.  In
> daemon, we should not store path with incomplete information to
> pathvec.  The
> pathvec stores all paths in daemon, so it is reasonable keep same
> with pathvec.
> 
> Reported-by: Tianxiong Li <lutianxiong@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  libmultipath/dmparser.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index f02c551..0f370e9 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -314,6 +314,16 @@ int disassemble_map(vector pathvec, char
> *params, struct multipath *mpp,
>  			}
> 
>  			if (!pp) {
> +				/* daemon should keep same with pathvec
> */
> +				/* pp is not find in pathvec, skip it
> */
> +				if (is_daemon) {
> +					FREE(word);
> +					for (k = 0; k < num_paths_args;
> k++) {
> +						p += get_word(p, NULL);
> +					}
> +					continue;
> +				}
> +
>  				pp_unfound = 1;
>  				pp = alloc_path();
> 
> @@ -326,8 +336,8 @@ int disassemble_map(vector pathvec, char *params,
> struct multipath *mpp,
>  					strncpy(pp->wwid, mpp->wwid,
>  						WWID_SIZE - 1);
>  				}
> -				/* Only call this in multipath client
> mode */
> -				if (!is_daemon && store_path(pathvec,
> pp)) {
> +
> +				if (store_path(pathvec, pp)) {
>  					free_path(pp);
>  					goto out1;
>  				}
> --
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

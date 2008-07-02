From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/6] drivers/md: remove null pointer dereference
Date: Wed, 2 Jul 2008 11:54:34 +0100
Message-ID: <20080702105434.GF22522@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0805121537100.3694@ask.diku.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805121537100.3694@ask.diku.dk>
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
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 12, 2008 at 03:37:31PM +0200, Julia Lawall wrote:
> If pgpath->pg->ps.type is NULL, it is not possible to access its name
> field.  So I have simply modified the error message to drop the printing of
> the name field.
> 
> This problem was found using the following semantic match
> (http://www.emn.fr/x-info/coccinelle/)
 
> --- a/drivers/md/dm-mpath.c	2008-04-16 13:27:57.000000000 +0200
> +++ b/drivers/md/dm-mpath.c	2008-05-12 09:19:35.000000000 +0200
> @@ -884,8 +884,7 @@ static int reinstate_path(struct pgpath 
>  		goto out;
>  
>  	if (!pgpath->pg->ps.type) {
> -		DMWARN("Reinstate path not supported by path selector %s",
> -		       pgpath->pg->ps.type->name);
> +		DMWARN("Reinstate path not supported by path selector");
>  		r = -EINVAL;
>  		goto out;
>  	}
 
Thanks for reporting this.

A more-sophisticated checker might discover that the test can never fail
- see parse_path_selector() - and so the real problem here is that it is
the wrong test.

The next line is:
	r = pgpath->pg->ps.type->reinstate_path(&pgpath->pg->ps, &pgpath->path);
and the error message makes it clear that the intent was to ensure that
the reinstate_path method exists before attempting to use it.

IOW
	if (!pgpath->pg->ps.type->reinstate_path) {

Alasdair
-- 
agk@redhat.com

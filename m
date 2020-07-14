From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/4]  Fix segfault on access to mpp->hwe
Date: Tue, 14 Jul 2020 18:54:21 -0500
Message-ID: <20200714235421.GL11089@octiron.msp.redhat.com>
References: <20200713110743.26329-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200713110743.26329-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 13, 2020 at 01:07:39PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This is in response to Lixiaokeng's post
> "master - libmultipath: fix use after free when iscsi logs in".
> 
> On top of Lixiaokeng's patch, I've added some log messages and
> a fix for mpp->hwe handling in sync_paths().
> 
> The question remains how we handle maps without paths. I believe we're good
> here, please review my assessment.
> 
> mpp->hwe is only accessed in propsel.c, via the mp_set_hwe() macro. Patch 3 of
> my series adds an error message if this happens while mpp->hwe is NULL. IMO it
> shouldn't happen because we don't check map properties for empty
> maps. Normally this is done when a map is created, and we don't create maps
> without paths.
> 
> The case where a map looses all paths during its normal lifetime and
> can't be removed (e.g. because it's busy) is already covered by the
> current code AFAICT. When a new path is re-added, we'll call adopt_paths
> and verify_paths(), which will make sure that mpp->hwe is set again
> to the pp->hwe member of the newly added path.
> 
> Reviews and comments welcome.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Regards
> Martin
> 
> Martin Wilck (3):
>   libmultipath: warn if freeing path that holds mpp->hwe
>   libmultipath: warn about NULL value of mpp->hwe
>   libmultipath: fix mpp->hwe handling in sync_paths()
> 
> lixiaokeng (1):
>   master - libmultipath: fix use after free when iscsi logs in
> 
>  libmultipath/propsel.c     | 4 +++-
>  libmultipath/structs_vec.c | 9 +++++++++
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> -- 
> 2.26.2

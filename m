From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: free pp if store_path fails in
 disassemble_map
Date: Thu, 23 Jul 2020 08:22:39 -0500
Message-ID: <20200723132239.GL11089@octiron.msp.redhat.com>
References: <b1cccadd-955e-0341-879f-01659a04dbb4@huawei.com>
	<20200722205310.GK11089@octiron.msp.redhat.com>
	<fadebd49-d6b0-2813-68b0-57218f8fa13e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fadebd49-d6b0-2813-68b0-57218f8fa13e@huawei.com>
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
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: yanxiaodan@huawei.com, linfeilong@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, mwilck@suse.com
List-Id: dm-devel.ids

On Thu, Jul 23, 2020 at 09:28:51AM +0800, Zhiqiang Liu wrote:
> 
> 
> On 2020/7/23 4:53, Benjamin Marzinski wrote:
> > On Wed, Jul 22, 2020 at 04:41:28PM +0800, Zhiqiang Liu wrote:
> >> In disassemble_map func, one pp will be allocated and stored in pathvec
> >> (only in client mode) and pgp->paths. However, if store_path fails, pp
> >> will not be freed, then memory leak problem occurs.
> >>
> >> Here, we will call free_path to free pp when store_path fails.
> >>
> > 
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> > 
> > However, this will need to get reworked on top of Martin's patches (or
> > incorporated into his next verion patchset).
> > 
> 
> Thanks for your suggestion.
> Which branch should I choose to modify my patch?

Martin's latest set of commits is available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-2007

> 
> 
> > -Ben
> > 
> >> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> >> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> >> ---
> >>  libmultipath/dmparser.c | 15 +++++++++++++--
> >>  1 file changed, 13 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> >> index 6225838b..3dc77242 100644
> >> --- a/libmultipath/dmparser.c
> >> +++ b/libmultipath/dmparser.c
> >> @@ -142,6 +142,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
> >>  	int def_minio = 0;
> >>  	struct path * pp;
> >>  	struct pathgroup * pgp;
> >> +	int pp_need_free_flag = 0;
> >>
> >>  	p = params;
> >>
> >> @@ -293,6 +294,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
> >>  			char devname[FILE_NAME_SIZE];
> >>
> >>  			pp = NULL;
> >> +			pp_need_free_flag = 0;
> >>  			p += get_word(p, &word);
> >>
> >>  			if (!word)
> >> @@ -323,9 +325,15 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
> >>  					strncpy(pp->wwid, mpp->wwid,
> >>  						WWID_SIZE - 1);
> >>  				}
> >> +
> >> +				if (is_daemon)
> >> +					pp_need_free_flag = 1;
> >> +
> >>  				/* Only call this in multipath client mode */
> >> -				if (!is_daemon && store_path(pathvec, pp))
> >> +				if (!is_daemon && store_path(pathvec, pp)) {
> >> +					free_path(pp);
> >>  					goto out1;
> >> +				}
> >>  			} else {
> >>  				if (!strlen(pp->wwid) &&
> >>  				    strlen(mpp->wwid))
> >> @@ -334,8 +342,11 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
> >>  			}
> >>  			FREE(word);
> >>
> >> -			if (store_path(pgp->paths, pp))
> >> +			if (store_path(pgp->paths, pp)) {
> >> +				if (pp_need_free_flag)
> >> +					free_path(pp);
> >>  				goto out;
> >> +			}
> >>
> >>  			/*
> >>  			 * Update wwid for multipaths which are not setup
> >> -- 
> >> 2.24.0.windows.2
> >>
> > 
> > 
> > .
> > 

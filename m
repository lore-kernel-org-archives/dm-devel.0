From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Autoload of DM kernel targets?
Date: Mon, 24 Apr 2017 14:53:12 -0400
Message-ID: <20170424185312.GA2370@redhat.com>
References: <3474bd1a-7a81-29ba-3562-aaaaeca47cc7@gmail.com>
	<87zif6phzt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87zif6phzt.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 24 2017 at 12:05am -0400,
NeilBrown <neilb@suse.com> wrote:

> On Fri, Apr 21 2017, Andrei Borzenkov wrote:
> 
> > See as example https://bugzilla.opensuse.org/show_bug.cgi?id=983221
> >
> > "non-standard" DM targets do not appear to be autoloaded (the problem
> > was hit with thin-pool, but it seems to apply to other targets as well).
> > "Common" targets (like linear) are provided by dm-mod which seems to be
> > autoloaded by virtue of /dev/mapper/control.
> >
> > Is it expected and intentional? Or are users required to manually load
> > necessary modules on boot?
> >
> > TIA
> >
> > -andrei
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> Does this patch fix it for you?
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 8f811dc8b3cc..d2c6a9a12d75 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -4400,3 +4400,4 @@ MODULE_PARM_DESC(no_space_timeout, "Out of data space queue IO timeout in second
>  MODULE_DESCRIPTION(DM_NAME " thin provisioning target");
>  MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("dm-thin-pool");
> 
> NeilBrown

The module is named "dm-thin-pool.ko", so I'm not following why that
patch would help.

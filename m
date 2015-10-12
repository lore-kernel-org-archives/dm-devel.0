From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/18] libmpathpersist: uninstall man page
 correctly
Date: Mon, 12 Oct 2015 09:09:57 +0200
Message-ID: <561B5CC5.9080403@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-16-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-16-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> the libmpathpersist man pages were being installed to
> /usr/share/man/man3, but uninstalled from /usr/share/man/man8.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmpathpersist/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> =

> diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
> index 7dcfd26..e49cdb9 100644
> --- a/libmpathpersist/Makefile
> +++ b/libmpathpersist/Makefile
> @@ -40,8 +40,8 @@ install: $(LIBS)
>  =

>  uninstall:
>  	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
> -	rm $(DESTDIR)$(mandir)/mpath_persistent_reserve_in.3.gz	=

> -	rm $(DESTDIR)$(mandir)/mpath_persistent_reserve_out.3.gz	=

> +	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz	=

> +	rm $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz	=

>  =

>  clean:
>  	rm -f core *.a *.o =

> =

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

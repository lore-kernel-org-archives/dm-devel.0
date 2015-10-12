From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/18] Make use of /run depend on systemd
Date: Mon, 12 Oct 2015 09:09:36 +0200
Message-ID: <561B5CB0.7000105@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-15-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-15-git-send-email-bmarzins@redhat.com>
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
> While there are other ways to decide whether to use /run or /var/run,
> I believe this should be good enough, and it uses a Makefile define
> that already exists.  If it doesn't work for everyone, I'll switch it
> to actually test the directories and add a new define to CFLAGS.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/defaults.h | 4 ++++
>  1 file changed, 4 insertions(+)
> =

> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index e2d2779..a313d75 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -27,7 +27,11 @@
>  #define MAX_CHECKINT(a)		(a << 2)
>  =

>  #define MAX_DEV_LOSS_TMO	0x7FFFFFFF
> +#ifdef USE_SYSTEMD
>  #define DEFAULT_PIDFILE		"/run/multipathd.pid"
> +#else
> +#define DEFAULT_PIDFILE         "/var/run/multipathd.pid"
> +#endif
>  #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
>  #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
>  #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
> =

Hmpf. Again.

But yeah, I guess it's okay.

If only systemd would stop moving things around ...

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/10] set retrigger_tries to 0 for multipath
Date: Sun, 30 Oct 2016 14:54:56 +0100
Message-ID: <bc70efb7-a4ed-6738-b664-454d79e4ba0e@suse.de>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-11-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-11-git-send-email-bmarzins@redhat.com>
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

On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> Multipathd uses retrigger_tries to give udev more chances to to fill in
> the uid_attribute, so that the path device is correctly set up in the
> udev database. However the multipath command can't do this, so it should
> just immediately give up on udev, and try to get the wwid directly.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/multipath/main.c b/multipath/main.c
> index ee00fdb..06add30 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -521,6 +521,7 @@ main (int argc, char *argv[])
>  	if (!conf)
>  		exit(1);
>  	multipath_conf =3D conf;
> +	conf->retrigger_tries =3D 0;
>  	while ((arg =3D getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) !=3D =
EOF ) {
>  		switch(arg) {
>  		case 1: printf("optarg : %s\n",optarg);
>
Hehe.
I've come across the very same issue.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

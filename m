From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 16/16] multipath: update man pages
Date: Wed, 14 Aug 2019 21:21:32 +0000
Message-ID: <d563722667ec1caba7a072b6df632844e64ea690.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-17-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-17-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <A5462B9F62218F4B999B21B49DE3353D@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-08-02 at 11:33 -0500, Benjamin Marzinski wrote:
> Add documentation for the marginal_pathgroups option and the
> (un)setmarginal commands.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/multipath.conf.5 | 34 ++++++++++++++++++++++++++++++----
>  multipathd/multipathd.8    | 19 +++++++++++++++++++
>  2 files changed, 49 insertions(+), 4 deletions(-)
> 
> --- a/multipathd/multipathd.8
> +++ b/multipathd/multipathd.8
> @@ -277,6 +277,25 @@ Remove the persistent reservation key associated
> with $map from the
>  \fIreservation_key\fR is set to \fBfile\fR in
> \fI/etc/multipath.conf\fR.
>  .
>  .TP
> +.B path $path setmarginal
> +move $path to a marginal pathgroup. The path will remain in the
> marginal
> +path group until \fIunsetmarginal\fR is called. This command will
> only
> +work if \fImarginal_pathgroups\fR is enabled and there is no Shaky
> paths
> +detection method configured (see the multipath.conf man page for
> details).

This is counter-intuitive. It's unclear to me why we need these
commands at all. By nature of "shaky" paths, it doesn't make a lot of
sense to make these settings (only) manually. I'd like it better if the
cli commands somehow hooked into the different "shaky" algorithms. E.g.
for the san_path_err_ algorithm, setting a path to marginal would mean
artificially setting its failure count to a value above the configured
threshold. That way, the manual settings could work togehter with the
automatic detection methods, and could be used for overriding them
in special cases.

Martin

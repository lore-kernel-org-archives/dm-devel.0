From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: LVM
Date: Sun, 5 Jul 2020 14:30:00 -0600
Message-ID: <20200705143000.51c350b7@lwn.net>
References: <20200627103138.71885-1-grandmaster@al2klimov.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200627103138.71885-1-grandmaster@al2klimov.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Sat, 27 Jun 2020 12:31:38 +0200
"Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:

> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>           If both the HTTP and HTTPS versions
>           return 200 OK and serve the same content:
>             Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Applied but...

> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 921888df6764..30ba3573626c 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -27,7 +27,7 @@ config BLK_DEV_MD
>  
>  	  More information about Software RAID on Linux is contained in the
>  	  Software RAID mini-HOWTO, available from
> -	  <http://www.tldp.org/docs.html#howto>. There you will also learn
> +	  <https://www.tldp.org/docs.html#howto>. There you will also learn

This HOWTO, once one finds it beyond that link, starts by saying:

	This HOWTO is deprecated; the Linux RAID HOWTO is maintained as a
	wiki by the linux-raid community at http://raid.wiki.kernel.org/

So clearly adding HTTPS isn't really the optimal fix here...

jon

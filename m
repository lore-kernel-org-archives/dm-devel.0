From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH] dm-core-add-ratelimit-printing.patch
Date: Thu, 05 Apr 2007 17:59:49 +0100
Message-ID: <46152B05.2050008@redhat.com>
References: <1175791012.24640.6.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1175791012.24640.6.camel@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jonathan Brassow wrote:
>  #define DMINFO(f, arg...) printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
> +#define DMINFO_LIMIT(f, arg...) \
> +	if (printk_ratelimit())	\
> +		printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
>  #ifdef CONFIG_DM_DEBUG
>  #  define DMDEBUG(f, arg...) printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
>  #else
> 

Cool! Can we get one for DMDEBUG too? There are some uses of DMDEBUG
messages where it'd be really nice to have a rate limited version of the
macro.

Regards,
Bryn.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGFSsF6YSQoMYUY94RAouZAJ9kuBSCfJalAnION286Ne/7hrOU7QCgnWJV
Awno4+Q38pWdPH3/d7oaNrk=
=L2hN
-----END PGP SIGNATURE-----

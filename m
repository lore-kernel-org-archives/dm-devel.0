From: "Carlos Manuel Duclos Vergara" <carlos@embedded.cl>
Subject: Re: [KJ] [PATCH] dm: uninitialize static variables
Date: Mon, 5 Dec 2005 12:47:40 -0000 (GMT)
Message-ID: <50993.206.49.219.34.1133786860.squirrel@webmail.embedded.cl>
References: <20051205132800.34631bbf@lucky.kitzblitz>
Reply-To: carlos@embedded.cl
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-bounces@lists.osdl.org>
In-Reply-To: <20051205132800.34631bbf@lucky.kitzblitz>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: Nicolas Kaiser <nikai@nikai.net>
Cc: kernel-janitors@lists.osdl.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

> uninitialize static variables initialized to 0, to make them go
> to .bss instead of .data.
>

if you want that why not explicitely put them in .bss?
something like:

> -static unsigned int major = 0;
> +static unsigned int major; /* = 0 */

static unsigned int major = 0 __attribute__ ((section(".bss"));

Even when crt should take care of initializing bss to zero, so I think
that you're trying to save some cpu cycles

my $1

-- 
Carlos Manuel Duclos Vergara
http://www.toolchains.com/personal/blog

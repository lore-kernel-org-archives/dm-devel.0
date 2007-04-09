From: Olaf Kirch <okir@lst.de>
Subject: Re: [PATCH] dm-core-add-ratelimit-printing.patch
Date: Mon, 9 Apr 2007 19:23:54 +0200
Message-ID: <200704091923.55986.okir@lst.de>
References: <1175791012.24640.6.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1175791012.24640.6.camel@hydrogen.msp.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Thursday 05 April 2007 18:36, Jonathan Brassow wrote:
>  #define DMERR(f, arg...) printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
> +#define DMERR_LIMIT(f, arg...) \
> +	if (printk_ratelimit())	\
> +		printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)

I would put a "do { ... } while (0)" around this, else you end up with nasty surprises
if it's used as in "if (..) DMERR_LIMIT(..) else do_something"

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax

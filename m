From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/2] multipath-tools: fix compilation with
 gcc < 4.9
Date: Wed, 17 May 2017 14:23:52 +0000
Message-ID: <1495031031.2945.6.camel@sandisk.com>
References: <20170517135439.25935-1-mwilck@suse.com>
	<20170517135439.25935-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517135439.25935-3-mwilck@suse.com>
Content-Language: en-US
Content-ID: <7CD2215300F1194E960DD733FE264434@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2017-05-17 at 15:54 +0200, Martin Wilck wrote:
> +# $(call TEST_CC_OPTION,option,fallback)
> +# Test if the C compiler supports the option.
> +# Evaluates to "option" if yes, and "fallback" otherwise.
> +TEST_CC_OPTION = $(shell \
> +	if $(CC) -o /dev/null -c "$(1)" -xc - <<<'int main(void){return 0;}' &>/dev/null; \
> +	then \
> +		echo "$(1)"; \
> +	else \
> +		echo "$(2)"; \
> +	fi)

Since '<<<' is nonstandard, please consider to use 'echo' and a pipe instead.
See also http://pubs.opengroup.org/onlinepubs/9699919799/.

> +STACKPROT = $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)

Please consider to use ":=" instead of "=" such that TEST_CC_OPTION gets called
once per "make" invocation instead of once per C file that is built.

Thanks,

Bart.

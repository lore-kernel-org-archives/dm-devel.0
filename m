From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH v2] dm-crypt: add ability to use keys from
 the kernel key retention service
Date: Thu, 17 Nov 2016 19:35:54 +0300
Message-ID: <8d8a7521-b69a-9616-410d-be8866580508@virtuozzo.com>
References: <afaabcf3-0ea0-375d-c0f2-6892dd70de2a@gmail.com>
	<1479329231-4572-1-git-send-email-okozina@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1479329231-4572-1-git-send-email-okozina@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com
Cc: mpatocka@redhat.com, snitzer@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On 11/16/2016 11:47 PM, Ondrej Kozina wrote:
> (Please still consider it to be RFC only, I need to modify the uspace teststuite
> again due to changes in key_string format. Also the changes to dm-crypt documentation
> will follow before final submit. Feature wide I'd consider the patch being complete
> unless any bugs would emerge)
> 
> The kernel key service is a generic way to store keys for the use of
> other subsystems. Currently there is no way to use kernel keys in dm-crypt.
> This patch aims to fix that. Instead of key userspace may pass a key
> description with preceding ':'. So message that constructs encryption
> mapping now looks like this:
> 
>   <cipher> [<key>|:<key_string>] <iv_offset> <dev_path> <start> [<#opt_params> <opt_params>]
> 
> where <key_string> is in format: <key_size>:<key_type>:<key_description>
> 
> Currently we only support two elementary key types: 'user' and 'logon'.
> Keys may be loaded in dm-crypt either via <key_string> or using
> classical method and pass the key in hex representation directly.
>

I think we need to hexify key description too, because it can contain spaces.
<key_size> seems like unnecessary complication. Kernel knows key_size, it doesn't need
that information from userspace.
Handling different types is probably an overkill too. If it works with logon keys,
why would we need to use 'user' keys?

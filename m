From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2] libmultipath: fix a memory leak in
	set_ble_device
Date: Tue, 11 Aug 2020 11:32:35 +0200
Message-ID: <109bd950021918cce1c89d0e92d137ffa6336ea2.camel@suse.com>
References: <c6ff6ae5-8b58-4beb-b6c9-10db444ffce2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c6ff6ae5-8b58-4beb-b6c9-10db444ffce2@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com, lutianxiong@huawei.com
List-Id: dm-devel.ids

Hi Liaxiaokeng,

thanks again. I still have minor issues, see below.

On Tue, 2020-08-11 at 15:23 +0800, lixiaokeng wrote:

> In set_ble_device func, if blist is NULL or ble is NULL,
> the vendor and product isn't freed. We think it is not
> reasonable that strdup(XXX) is used as set_ble_device
> and store_ble functions' parameter.
> 
> Here we call strdup() in store_ble and set_ble_device
> functions and the string will be free if functions fail.
> Because constant string like "sdb" will be their parameter,
> char * is changed to const char *. This is base on
> upstream-queue branch in openSUSE/multipath-tools.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  libmultipath/blacklist.c | 81 ++++++++++++++++++++++--------------
> ----
>  libmultipath/blacklist.h |  4 +-
>  tests/blacklist.c        | 31 +++++++--------
>  3 files changed, 59 insertions(+), 57 deletions(-)
> 
> ...
> 
> @@ -93,31 +100,40 @@ int set_ble_device(vector blist, char * vendor,
> char * product, int origin)
>  		return 1;
> 
>  	if (vendor) {
> -		regex_str = check_invert(vendor, &ble->vendor_invert);
> -		if (regcomp(&ble->vendor_reg, regex_str,
> -			    REG_EXTENDED|REG_NOSUB)) {
> -			FREE(vendor);
> -			if (product)
> -				FREE(product);
> -			return 1;
> -		}
> -		ble->vendor = vendor;
> +		vendor_str = STRDUP(vendor);
> +		if (!vendor_str)
> +			goto out;
> +
> +		regex_str = check_invert(vendor_str, &ble-
> >vendor_invert);
> +		if (regcomp(&ble->vendor_reg, regex_str,
> REG_EXTENDED|REG_NOSUB))
> +			goto out;
> +
> +		ble->vendor = vendor_str;
>  	}
>  	if (product) {
> -		regex_str = check_invert(product, &ble-
> >product_invert);
> -		if (regcomp(&ble->product_reg, regex_str,
> -			    REG_EXTENDED|REG_NOSUB)) {
> -			FREE(product);
> -			if (vendor) {
> -				ble->vendor = NULL;
> -				FREE(vendor);
> -			}
> -			return 1;
> -		}
> -		ble->product = product;
> +		product_str = STRDUP(product);
> +		if (!product_str)
> +			goto out1;
> +
> +		regex_str = check_invert(product_str, &ble-
> >product_invert);
> +		if (regcomp(&ble->product_reg, regex_str,
> REG_EXTENDED|REG_NOSUB))
> +			goto out1;
> +
> +		ble->product = product_str;
>  	}
>  	ble->origin = origin;
>  	return 0;
> +out1:
> +	if (vendor_str)
> +		ble->vendor = NULL;
> +out:
> +       free(vendor_str);
> +       vendor_str = NULL;
> +
> +       free(product_str);
> +       product_str = NULL;
> +
> +       return 1;
>  }

Thinking about it again, I believe the error handling code should look
like this:

 out1:
        if (vendor) {
                regfree(&ble->vendor_reg);
                ble->vendor_reg = NULL;
                ble->vendor = NULL;
        }
 out:
        free(vendor_str);
        free(product_str);
	return 1;

Rationale: vendor_str and product_str are local variables, there's no
point in setting them to NULL. But the ble fields need careful
treatment, as vendor and product can either be set in a single call of
this function, or in two separate calls. You should test "vendor"
rather than "vendor_str" in the "out1" clause to make this logic
obvious, even though you never pass "out1" if allocating vendor_str
failed.

Note the regfree() I added. It's missing in the current code as well.

Regards,
Martin

From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH V2] libmultipath: fix a memory leak in
 set_ble_device
Date: Thu, 13 Aug 2020 16:00:50 +0800
Message-ID: <c074551f-ae1f-ea69-a012-95777007b1b5@huawei.com>
References: <c6ff6ae5-8b58-4beb-b6c9-10db444ffce2@huawei.com>
	<109bd950021918cce1c89d0e92d137ffa6336ea2.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <109bd950021918cce1c89d0e92d137ffa6336ea2.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com, lutianxiong@huawei.com
List-Id: dm-devel.ids

Hi  Martin
   I'm sorry for send  "[PATCH V3] libmultipath: fix a memory leak in set_ble_device"
to you  before finishing compile. Here is some question in ble->vendor_reg = NULL.
The type of ble->vendor_reg is regex_t but not void *, so it can not be set to
NULL. Do you have any good idea about how to set ble->vendor_reg. You can ignore
the email [PATCH V3] libmultipath: fix a memory leak in set_ble_device.

Lixiaokeng


> Thinking about it again, I believe the error handling code should look
> like this:
> 
>  out1:
>         if (vendor) {
>                 regfree(&ble->vendor_reg);
>                 ble->vendor_reg = NULL;
>                 ble->vendor = NULL;
>         }
>  out:
>         free(vendor_str);
>         free(product_str);
> 	return 1;
> 
> Rationale: vendor_str and product_str are local variables, there's no
> point in setting them to NULL. But the ble fields need careful
> treatment, as vendor and product can either be set in a single call of
> this function, or in two separate calls. You should test "vendor"
> rather than "vendor_str" in the "out1" clause to make this logic
> obvious, even though you never pass "out1" if allocating vendor_str
> failed.
> 
> Note the regfree() I added. It's missing in the current code as well.
> 
> Regards,
> Martin
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 
> .
> 

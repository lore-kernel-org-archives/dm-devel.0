From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/5 v4] libmultipath fix a memory leak in
	set_ble_device
Date: Tue, 18 Aug 2020 17:57:27 +0200
Message-ID: <3d99bd1341a4bded6785a8c67fe0907e8260a871.camel@suse.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
	<a3e11ab6-c81c-d136-68ea-3d36fc59c810@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a3e11ab6-c81c-d136-68ea-3d36fc59c810@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

On Tue, 2020-08-18 at 21:02 +0800, lixiaokeng wrote:
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
> The type of ble->vendor_reg is regex_t struct but not a
> pointer, so it can not be set NULL.

Ups. Right. Thanks for correcting me.

> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

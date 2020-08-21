From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2 3/5] libmultipath: check blist before
 calling MALLOC in alloc_ble_device func
Date: Fri, 21 Aug 2020 13:15:46 +0200
Message-ID: <5e5b2021953e364ab6971f1bc3d945c6930d8072.camel@suse.com>
References: <52b3b834-6da6-99c1-a2d1-95c2387c47e3@huawei.com>
	<9fbd5246-ff4f-0486-d33a-c77ccd334a4d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9fbd5246-ff4f-0486-d33a-c77ccd334a4d@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids

On Fri, 2020-08-21 at 19:00 +0800, Zhiqiang Liu wrote:
> In alloc_ble_device func, ble is firstly allocated by calling MALLOC,
> and then input blist is checked whether it is valid. If blist is not
> valid, ble will be freed without using.
> 
> Here, we should check blist firstly.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

This one is already applied in my "upstream-queue" branch.

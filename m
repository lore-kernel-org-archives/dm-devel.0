From: Martin Wilck <mwilck@suse.com>
Subject: Re: [dm- devel][PATCH] checker: add input check of state
 in checker_state_name func
Date: Mon, 10 Aug 2020 12:17:58 +0200
Message-ID: <2625305858d9381eb1f69642d6bbcd743a995af2.camel@suse.com>
References: <9c67963b-477f-b3f5-8c8c-048de9357ff9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9c67963b-477f-b3f5-8c8c-048de9357ff9@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, christophe.varoqui@opensvc.com, zkabelac@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids

On Mon, 2020-08-10 at 09:14 +0800, Zhiqiang Liu wrote:
> In checker_state_name func, we donot check whether input i
> is valid. It may cause array access violation problem.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  libmultipath/checkers.c | 26 +++++++++++++++-----------
>  libmultipath/checkers.h |  3 ++-
>  2 files changed, 17 insertions(+), 12 deletions(-)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks for the patch.

Btw, are you currently reviewing multipath-tools with coverity or some
similar tool?

Martin

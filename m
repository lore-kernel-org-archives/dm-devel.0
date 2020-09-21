From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V6 11/14] mpathpersist: check whether malloc
 paramp->trnptid_list fails in handle_args func
Date: Mon, 21 Sep 2020 10:56:45 +0200
Message-ID: <2784ac6e3115342c807fb750ddd72874621db4ca.camel@suse.com>
References: <ae709d8f-64f7-30bc-bd08-fc2398c0c093@huawei.com>
	<39c4b48b-4cc8-062e-c6c8-1207b38f576a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <39c4b48b-4cc8-062e-c6c8-1207b38f576a@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Sat, 2020-09-19 at 18:28 +0800, lixiaokeng wrote:
> In handle_args func, we donot check whether malloc paramp and
> each paramp->trnptid_list[j] fails before using them, it may
> cause access NULL pointer.
> 
> Here, we add alloc_prout_param_descriptor to allocate and init
> paramp, and we add free_prout_param_descriptor to free paramp
> and each paramp->trnptid_list[j].
> 
> We change num_transport to num_transportids to combine them.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  mpathpersist/main.c | 64 ++++++++++++++++++++++++++++++++++---------
> --
>  1 file changed, 49 insertions(+), 15 deletions(-)
> 

OK. So your v5 patch wasn't wrong either, as you did set
num_transportids twice. I admit I missed that. But it's better now
anyway. 

Actually, I would have preferred if you solved the issue the other way
around, by moving the assignment to num_transportids to after the
memset() in alloc_prout_param_descriptor(). But it's not worth forcing
you into yet another iteration, so:

Reviewed-by: Martin Wilck <mwilck@suse.com>

This means the whole series (except 8/14 which had been taken back) is
acked now, and I'll push it to the upstream-queue branch.

Martin

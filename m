From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2 1/5] multipathd: adopt static char* arr in
 daemon_status
Date: Fri, 21 Aug 2020 13:07:08 +0200
Message-ID: <5edc6f28c4a825c26c8b1515369a4a4c533e72ba.camel@suse.com>
References: <52b3b834-6da6-99c1-a2d1-95c2387c47e3@huawei.com>
	<b2c96dc6-1e01-beb2-0ccb-22e1d0d980a6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b2c96dc6-1e01-beb2-0ccb-22e1d0d980a6@huawei.com>
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

On Fri, 2020-08-21 at 18:58 +0800, Zhiqiang Liu wrote:
> We adopt static char* array (demon_status_msg) in daemon_status func,
> so it looks more simpler and easier to expand.
> 
> V1->V2:
> - use "int" as the type of "status" (suggested by Martin)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>

> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  multipathd/main.c | 30 +++++++++++++++---------------
>  multipathd/main.h |  3 ++-
>  2 files changed, 17 insertions(+), 16 deletions(-)

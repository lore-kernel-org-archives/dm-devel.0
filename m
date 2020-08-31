From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V3 1/5] multipathd: adopt static char* arr in
 daemon_status
Date: Mon, 31 Aug 2020 16:37:38 +0200
Message-ID: <dd407fdd07d2f03429c9528d5b296e1823031112.camel@suse.com>
References: <dc4f5730-157f-8a27-247c-628f38bb6cb5@huawei.com>
	<c31619f2-93e6-f317-809c-828026e6ee03@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c31619f2-93e6-f317-809c-828026e6ee03@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, yanxiaodan@huawei.com, linfeilong@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Sat, 2020-08-29 at 11:03 +0800, Zhiqiang Liu wrote:
> We adopt static char* array (demon_status_msg) in daemon_status func,
> so it looks more simpler and easier to expand.
> 
> V2->V3:
> - add default case in sd_notify_status to fix compile error
> V1->V2:
> - use "int" as the type of "status" (suggested by Martin)
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  multipathd/main.c | 32 +++++++++++++++++---------------
>  multipathd/main.h |  3 ++-
>  2 files changed, 19 insertions(+), 16 deletions(-)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>

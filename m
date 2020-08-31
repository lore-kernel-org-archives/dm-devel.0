From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 2/5] multipathd: use daemon_status_msg to
 construct sd notify msg in do_sd_notify func
Date: Mon, 31 Aug 2020 16:36:58 +0200
Message-ID: <bfd637399397e33f01b5cdb9b7f8f9eaaa698103.camel@suse.com>
References: <50b2333d-8c5d-8705-a31a-11bb84980373@huawei.com>
	<76528c71-f8b9-1595-edc1-e9061858a76f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <76528c71-f8b9-1595-edc1-e9061858a76f@huawei.com>
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, yanxiaodan@huawei.com, linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com, zkabelac@redhat.com
List-Id: dm-devel.ids

On Mon, 2020-08-31 at 19:37 +0800, Zhiqiang Liu wrote:
> sd_notify_status() is very similar with daemon_status(), except
> DAEMON_IDLE and DAEMON_RUNNING state. As suggested by Martin,
> we can create the sd notification string in a dynamic buffer,
> and treat DAEMON_IDLE and DAEMON_RUNNING cases first. Then,
> we can use daemon_status_msg[state] for other cases.
> 
> V3->V4:
> - put "STATUS=" in format string to avoid "prefix" var as suggested
> by
> Martin.
> 
> V2->V3:
> - set MSG_SIZE to 32 and use safe_sprintf as suggested by Martin.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  multipathd/main.c | 33 +++++++++++----------------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
> 

Thank you.
Reviewed-by: Martin Wilck <mwilck@suse.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 00/15] Fifteen multipath-tools patches
Date: Mon, 10 Oct 2016 13:34:43 -0700
Message-ID: <971ae354-4705-78c0-ad3b-3acf26a89380@sandisk.com>
References: <201610081005252322566@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201610081005252322566@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn, christophe.varoqui@opensvc.com
Cc: bart.vanassche@sandisk.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/07/2016 07:05 PM, tang.junhui@zte.com.cn wrote:
> "0007-multipathd-Fix-a-data-race.patch"
>
> This patch solved the data race problem,
>
> but the assignment for paths check interval has no effect,
>
> since there is no path in vecs when calling
> init_path_check_interval(vecs) in child(),
>
> I think it is better to call
>  init_path_check_interval(vecs) at reconfigure() or configure()
>
> after the paths has created in vecs .

Hello Tang,

If init_path_check_interval() doesn't have any effect then I propose to 
remove that function. pp->checkint is namely already initialized in 
cli_add_path().

Bart.

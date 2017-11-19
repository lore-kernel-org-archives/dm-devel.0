From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 4/4] libmultipath: path latency: remove
	warnings
Date: Sun, 19 Nov 2017 11:00:38 +0800
Message-ID: <40620b36-625e-63f7-2387-367f46b5de09@huawei.com>
References: <20171118001134.26622-1-mwilck@suse.com>
	<20171118001134.26622-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171118001134.26622-5-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, niuhaoxin <niuhaoxin@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>
List-Id: dm-devel.ids


Looks fine.

Reviewed-by: Guan Junxiong <guanjunxiong@huawei.com>

On 2017/11/18 8:11, Martin Wilck wrote:
> The warnings at here are pointless. We are looking at a single
> path only. Firstly, the standdard deviation for this measurement
> can't be "too low" - the lower, the more precise the measurement,
> the better. Secondly, a high standard deviation indicates an
> unstable path with highly variable latency. Not good, but nothing
> to warn about here.
> 
> What matters for the selection of "base_num" is not how a single
> path behaves, but how different paths of the same path group relate
> to each other, which we don't know at this point at the code.
> 

Oh, you are right. Thanks.

> What we want to avoid is too fine a differentiation, in particular
> in combination with group_by_prio, because we'd loose the ability for
> load balancing. But this is rather a topic for the man page or a
> "best practices" document.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/prioritizers/path_latency.c | 34 --------------------------------
>  1 file changed, 34 deletions(-)
> 

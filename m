From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] multipathd: fix issue in 'map $map
 getprstatus' reply
Date: Wed, 3 Aug 2016 09:26:16 -0700
Message-ID: <fcc1a865-f918-17a8-c424-6cff341129e1@sandisk.com>
References: <1470208155-6544-1-git-send-email-peng.liang5@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470208155-6544-1-git-send-email-peng.liang5@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: peng.liang5@zte.com.cn, christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/03/2016 12:09 AM, peng.liang5@zte.com.cn wrote:
> +	*len = 3;
> +	asprintf(reply, "%d\n", mpp->prflag);

Hello Peng,

Please use the return value of asprintf() to compute *len instead of 
assigning a hard-coded constant to *len.

Thanks,

Bart.

From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] dm-mpath: Fix a race condition
Date: Tue, 12 Dec 2017 01:01:27 +0000
Message-ID: <1513040486.2747.43.camel@wdc.com>
References: <20171212002624.7747-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171212002624.7747-1-bart.vanassche@wdc.com>
Content-Language: en-US
Content-ID: <1DCFFF933B729D42A80CB899CE250736@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hare@suse.com" <hare@suse.com>
List-Id: dm-devel.ids

On Mon, 2017-12-11 at 16:26 -0800, Bart Van Assche wrote:
> This patch fixes the following crash:
> 
> general protection fault: 0000 [#1] PREEMPT SMP
> RIP: 0010:multipath_busy+0x77/0xd0 [dm_multipath]

Please ignore this patch for now - I just hit the same crash again.

Bart.

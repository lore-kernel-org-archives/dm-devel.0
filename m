From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] multipath-tools: beautify path_latency.c code
Date: Thu, 22 Jun 2017 16:59:30 +0000
Message-ID: <1498150769.11898.1.camel@wdc.com>
References: <20170622164623.4511-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170622164623.4511-1-xose.vazquez@gmail.com>
Content-Language: en-US
Content-ID: <F3E036BB24F0EA40A04794FF15D7DA3B@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "philip.yang@huawei.com" <philip.yang@huawei.com>
List-Id: dm-devel.ids

On Thu, 2017-06-22 at 18:46 +0200, Xose Vazquez Perez wrote:
> Mainly running scripts/Lindent, from kernel dir, to replace indent spaces
> by tabs.

Hello Xose,

Why do you think this kind of changes is useful? Are you aware that
whitespace-only changes are very annoying to anyone else who is preparing
changes on the same file because such changes result in a huge number of
annoying rebase conflicts?

Bart.

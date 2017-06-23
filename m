From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: beautify path_latency.c code
Date: Fri, 23 Jun 2017 19:13:39 +0200
Message-ID: <d454863f-8781-1729-f824-88d15be2ba29@gmail.com>
References: <20170622164623.4511-1-xose.vazquez@gmail.com>
	<1498150769.11898.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1498150769.11898.1.camel@wdc.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "philip.yang@huawei.com" <philip.yang@huawei.com>
List-Id: dm-devel.ids

On 06/22/2017 06:59 PM, Bart Van Assche wrote:

> Why do you think this kind of changes is useful? Are you aware that
> whitespace-only changes are very annoying to anyone else who is preparing
> changes on the same file because such changes result in a huge number of
> annoying rebase conflicts?

Be consistent with the rest of the multipath-tools code. Have do you seen
the original and the patched file?
Cleanings like this were done before without troubles.

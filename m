From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 05/13] dm-mpath: Make it easier to analyze
 requeuing behavior
Date: Thu, 27 Apr 2017 19:57:27 +0000
Message-ID: <1493323046.2625.12.camel@sandisk.com>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
	<20170427171126.26814-6-bart.vanassche@sandisk.com>
	<20170427192923.GB67119@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170427192923.GB67119@redhat.com>
Content-Language: en-US
Content-ID: <C2E44367F0486F498C4AB02461895400@namprd04.prod.outlook.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Thu, 2017-04-27 at 15:29 -0400, Mike Snitzer wrote:
> Documentation/process/coding-style.rst says:
> "Coming up with good debugging messages can be quite a challenge; and once
> you have them, they can be a huge help for remote troubleshooting.  However
> debug message printing is handled differently than printing other non-debug
> messages.  While the other pr_XXX() functions print unconditionally,
> pr_debug() does not; it is compiled out by default, unless either DEBUG is
> defined or CONFIG_DYNAMIC_DEBUG is set."
> 
> So I assume you're leveraging DYNAMIC_DEBUG.
> 
> Anyway, I'm not liking the idea of making this debugging part of the
> mpath code.  But if there is a convincing argument for it please
> elaborate.
> 
> Are you finding that things are going wrong on production systems and
> enabling pr_debug() in these paths would have, or has, saved you?

Hello Mike,

If the dm-mpath driver is busy with requeuing requests in a loop today there
is no way to figure out why that continuous requeuing happens. The pr_debug()
statements introduced by this patch provide an easy way to figure out on
development systems why the requeuing happens. Please note that there is no
guarantee on production systems that CONFIG_DYNAMIC_DEBUG=y.

Bart.

From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH 00/29] SLES resync
Date: Mon, 15 Jul 2013 15:53:51 +0200
Message-ID: <51E3FEEF.7050301@profitbricks.com>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 15.07.2013 15:00, Hannes Reinecke wrote:
[...]
> - When using libudev to read attribute variables we'd be getting
>   an automated caching from libudev. Which is nice, unless the
>   data changed in between. So I'd have to go back an roll our
>   own accessors, skipping libudev here.
[...]

Hi Hannes,

nice, that's what I've already reported. Could you point me to the fix
commit(s) for this please?

I couldn't find any related code in the series. Also here is still the
cached behavior for the device state:
https://github.com/hreinecke/multipath-tools/blob/sles-resync/libmultipath/discovery.c

Or is this planned as future work?

Cheers,
Sebastian

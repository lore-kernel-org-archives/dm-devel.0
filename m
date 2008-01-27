From: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 1/2] dm-band: The I/O bandwidth controller:
	Source code patch
Date: Sun, 27 Jan 2008 16:44:53 +0100
Message-ID: <E1JJ9gj-0001SH-U2@faramir.fjphome.nl>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
	<20080123.215632.226773739.ryov@valinux.co.jp>
	<E1JHfjM-0003NV-BR@faramir.fjphome.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-reply-To: <E1JHfjM-0003NV-BR@faramir.fjphome.nl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frans Pop <elendil@planet.nl>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Frans Pop wrote:
> The help should probably be a bit more verbose as this does not tell
> anybody much who has not already read the documentation.
> 
> Maybe something like:
> <snip>
> This device-mapper target allows to define how the
> available bandwith of a storage device should be
> shared between processes or cgroups.
> 
> Information on how to use dm-band is available in:
>    Documentation/device-mapper/band.txt
> </snip>

I just see in other Kconfig files that the last line should be:
   <file:Documentation/device-mapper/band.txt>.

Cheers,
FJP

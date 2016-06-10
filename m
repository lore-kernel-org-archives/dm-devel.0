From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 05/57] Add HP MSA 2040 to the hardware table
Date: Fri, 10 Jun 2016 16:30:44 +0200
Message-ID: <feddf362-5f06-120f-4b0b-8143bf5875c8@gmail.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-6-git-send-email-hare@suse.de>
	<20160429000605.00006561@localhost> <5722F736.1050404@suse.de>
	<01a29af9-deb9-64be-b01d-a1e248382cbc@gmail.com>
	<575A5B69.60600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <575A5B69.60600@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 06/10/2016 08:17 AM, Hannes Reinecke wrote:

> On 06/09/2016 04:20 PM, Xose Vazquez Perez wrote:

>> In VxVM(libvxmsa2kfc_sa) they are grouped that way:
>> https://web.archive.org/web/20160608233140/https://sort.veritas.com/asl/details/756
>>
>> Otherwise if hwtable.c is filled with a lot of duplicate entries,
>> it could be unmanageable.

> Well.
> MSA2000 is already out of support, and P2000 is heading there.
> So it's _extremely_ unlikely that we get additional hardware entries for
> those.
> At the same time, re-grouping hardware entries by combining regular
> expressions always has the real risk of messing up the regular
> expressions, and requires a test on the actual hardware to check if we
> didn't mess up. Seeing the both are basically unsupported it'll get hard
> to validate this.
> For this reasons I prefer to leave them alone.

BTW, a "Unit serial number" attribute could be added to provide more flexibility.

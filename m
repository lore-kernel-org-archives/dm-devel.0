From: Milan Broz <mbroz@redhat.com>
Subject: Re: Possible severe bug in the device mapper?
Date: Mon, 31 Jan 2011 12:13:09 +0100
Message-ID: <4D469945.9000401@redhat.com>
References: <4D46811C.9050506@gmx.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D46811C.9050506@gmx.com>
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
Cc: Andreas Heinlein <aheinlein@gmx.com>
List-Id: dm-devel.ids


On 01/31/2011 10:30 AM, Andreas Heinlein wrote:

> Expected behavior: Writing to the still mounted mapping should at least
> give an error

It should, at least the first flush must return error.

Reading from page cache will probably not hit DM code at all, so it 
is possible that you can read some data without failure.

Can you reproduce this on recent kernel? 2.6.32 is quite old and I expect
it is some heavy patches distro kernel.

> This does not happen with whole block devices as targets, which is AFAIK
> the case in most uses of the device mapper.

What do you mean by "whole block devices" here? Like not partitioned disk?

> Since this is reproducible with other device mapper targets, I am sure
> this is not a truecrypt problem. It might be related to udev, which
> AFAIK should notify higher levels when a device is removed.

Yes, Truecrypt uses dm-crypt here. Udev should get remove event and remove
all symlinks, also there can be some higher level (udisks) which forcily
removes crypt mapping when underlying device disappears.

But it still must return error on write when underlying device disappeared.

Milan

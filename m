From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Thu, 18 Mar 2010 17:24:18 +0000
Message-ID: <20100318172418.GI17615@agk-dp.fab.redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Thu, Mar 18, 2010 at 05:13:22PM +0100, Kay Sievers wrote:
> How about doing a two-stage instantiation instead of mangling events
> to work around this setup model? Instead of creating the mentioned
> event/sys inconsistencies, did you think about not registering the
> "dead" blockdev until it is ready to be used as a blockdev? Like you
> would allocate the dm instance in the kernel, but only register the
> blockdev with the block subsystem when the device is resumed/the table
> loaded. That way, only after the device is usable, it would get
> registered and appear in /dev, /sys and proc.
 
Still going around in circles, I'm afraid.

That looked like even bigger block layer surgery last time we considered it.
By all means, look at it yet again...

We're creating trees of devices that reference each other (need to know
minor numbers) and have constraints about which parts of the code may
allocate new memory.

Alasdair

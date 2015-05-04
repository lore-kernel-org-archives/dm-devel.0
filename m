From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: A target for hotswap?
Date: Mon, 04 May 2015 19:37:34 +0900
Message-ID: <55474BEE.1090402@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hi,

Some DM target requires additional device that could be a single point of failure.
Let's consider dm-cache.
dm-cache requires a HDD and a SSD and if SSD is dead, the data is lost.
To protect from this, SSD can be built RAID. But RAID isn't an ideal solution with SSD
because the devices can be dead at the same time. Cost is the another problem of course.

So, let's think about hotswap.
A hotswap device has an active device and multiple ready devices.
The active device is usually used and when the device is ordered to swap by
a ready device it starts to sync the two devices and change the active device
when sync is over. It's not simply dd-ing the devices because I/O isn't suspended and
not all region is necessarily copied.
You can order swapping whenever you like to. For example, swapping every week can be
double the longevity of the cache device.

I don't know how I can do this with DM targets.
Do other part of linux technologies have such functinality? Please teach me if so.

- Akira

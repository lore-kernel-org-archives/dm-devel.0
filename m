From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 10:55:32 -0600
Message-ID: <n51dq4$dit$1@ger.gmane.org>
References: <n508c1$8dl$1@ger.gmane.org>
	<22132.12088.729694.12882@quad.stoffel.home>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22132.12088.729694.12882@quad.stoffel.home>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/18/2015 10:07 AM, John Stoffel wrote:
>>From my reading of the docs, it's clear that zodcache is lower down
> the stack than LVMcache, but higher than bcache.

I would actually say that zodcache is at about the same level as
bcache.  The main conceptual difference is that zodcache does device
probing/recognition and setup are done in userspace, where bcache does
it in kernel space.  (I.e. echo the device name to
/sys/fs/bcache/register and the kernel looks a the device, decides
what it is, etc.)

> So describinng how your setup can provide a central cache pool across
> multiple VGs would be awesome, but it's not quite clear to me that you
> can do this in reality without doing multiple layers of block devices.

Currently you'll need multiple zodcache devices to create multiple VGs.
It should be possible to make these devices partitionable with a udev
rule that calls kpartx as appropriate.

> And since I'm paranoid (to a degree!) about resiliency, mirroring the
> cache devices is a critical part for me.

I haven't yet tested zodcache on top of MD RAID, but I fully expect it
to work.

> Also, I'm on debian, so that's another piece of documentation that's
> kinda sorta missing.

What do you need beyond what's in section III-B of the README?

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================

From: "John Stoffel" <john@stoffel.org>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 13:53:46 -0500
Message-ID: <22132.22074.53925.307966@quad.stoffel.home>
References: <n508c1$8dl$1@ger.gmane.org>
	<22132.12088.729694.12882@quad.stoffel.home>
	<n51dq4$dit$1@ger.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <n51dq4$dit$1@ger.gmane.org>
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

>>>>> "Ian" == Ian Pilcher <arequipeno@gmail.com> writes:

Ian> On 12/18/2015 10:07 AM, John Stoffel wrote:
>>> From my reading of the docs, it's clear that zodcache is lower down
>> the stack than LVMcache, but higher than bcache.

Ian> I would actually say that zodcache is at about the same level as
Ian> bcache.  The main conceptual difference is that zodcache does device
Ian> probing/recognition and setup are done in userspace, where bcache does
Ian> it in kernel space.  (I.e. echo the device name to
Ian> /sys/fs/bcache/register and the kernel looks a the device, decides
Ian> what it is, etc.)

I think a picture would help show this all more clearly, but I do
appreciate your clarifications.  I had looked at bcache myself, but
the inflexibility of it didn't make me happy.

I like that lvmcache allows me to dynamically remove the cache without
impacting the system, except for performance.  :-)

>> So describinng how your setup can provide a central cache pool across
>> multiple VGs would be awesome, but it's not quite clear to me that you
>> can do this in reality without doing multiple layers of block devices.

Ian> Currently you'll need multiple zodcache devices to create
Ian> multiple VGs.  It should be possible to make these devices
Ian> partitionable with a udev rule that calls kpartx as appropriate.

Ok, that makes sense.  One other issue I have with lvmcache is that
the cache LVs are in the VG, so if you're not careful, you could
expand other LVs onto those PVs.  I think this is a bad design myself.

>> And since I'm paranoid (to a degree!) about resiliency, mirroring the
>> cache devices is a critical part for me.

Ian> I haven't yet tested zodcache on top of MD RAID, but I fully expect it
Ian> to work.

>> Also, I'm on debian, so that's another piece of documentation that's
>> kinda sorta missing.

Ian> What do you need beyond what's in section III-B of the README?

Sorry, I must have skipped over that too quickly, I didn't see it,
I'll try to take a look and see if I can spin up something.

John

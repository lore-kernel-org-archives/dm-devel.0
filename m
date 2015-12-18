From: "John Stoffel" <john@stoffel.org>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 11:07:20 -0500
Message-ID: <22132.12088.729694.12882@quad.stoffel.home>
References: <n508c1$8dl$1@ger.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <n508c1$8dl$1@ger.gmane.org>
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


Ian> I've been looking for a "simple" way to manage dm-cache devices
Ian> for a while now -- something that operates a bit more like bcache
Ian> than LVM cache does, while still using the dm-cache
Ian> infrastructure.  Having not found anything, I finally created
Ian> "zodcache".  (The name is mostly due to wanting something that
Ian> could be used as a magic number -- 20DCAC8E.)

Ian> Hopefully the README does a decent job of explaining how it works, so I
Ian> won't belabor it here:

I just read this over because I've just deployed lvmcache on my home
system, and I was interested in how this would be different.  One
thing I would comment on is that having a diagram comparting the three
options would be really useful.

From my reading of the docs, it's clear that zodcache is lower down
the stack than LVMcache, but higher than bcache.

For my setup, I have a pair of mirrored SSDs for root, /boot and
lvmcache partitions.  I'm using MD to mirror the partitions I've
created on the SSDs.

I then have another MD mirror composed of two 4Tb disks, which is
turned into a PV in a VG with a bunch of LVs which are now cached.
Before I had seperate VGs for some of my data, but now I've coalesced
them so that I don't need multiple MD arrays for seperate cache PVs in
each VG.

So describinng how your setup can provide a central cache pool across
multiple VGs would be awesome, but it's not quite clear to me that you
can do this in reality without doing multiple layers of block devices.

And since I'm paranoid (to a degree!) about resiliency, mirroring the
cache devices is a critical part for me.

Also, I'm on debian, so that's another piece of documentation that's
kinda sorta missing.

John

From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: dm-mon fails to load raid1 target
Date: Sun, 30 Jan 2005 18:20:37 +0100
Message-ID: <62b0912f05013009209d8d8f0@mail.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: gerte@nieuwenborg.nl
List-Id: dm-devel.ids

Hi

I can't get dm_mon to load the raid1 target.

The syslog says (timestamps removed):
livecd device-mapper: : unknown target type
livecd
livecd device-mapper: error adding target to table

Seems that there's a completely blank syslog message (reproducible),
and a surplus colon in the first message.  Might be related to the
dmraid tool.  Anyway.

I'm booting with a Gentoo CD [gen2dmraid 0.99 - kernel: 2.6.9, driver
4.1.0, library 1.00.17-ioctl].

The /lib/modules/.../raid1.ko file is present.

I tried modprobe raid1 (fine), this didn't add the mirror target to
"dmsetup targets".
Tried unloading dm-mon, reloading raid1, loading dm-mon, still no mirror target.

Any hints on what is going wrong / what I am doing wrong?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

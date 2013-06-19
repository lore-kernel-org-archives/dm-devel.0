From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: dm-cache caching network volume
Date: Wed, 19 Jun 2013 09:44:20 -0700
Message-ID: <20130619164420.GA16033@blackbox.djwong.org>
References: <1371547972.6128.8.camel@expiron> <kpr15n$a53$1@ger.gmane.org>
	<kpr9c9$iej$1@ger.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <kpr9c9$iej$1@ger.gmane.org>
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

On Tue, Jun 18, 2013 at 07:07:03PM -0700, Alex Elsayed wrote:
> Alex Elsayed wrote:
> =

> > =C9tienne BERSAC wrote:
> > =

> >> Hi,
> >> =

> >> I'm testing dm-cache for using a local SSD as a cache for a network
> >> volume. My goal is to test dm-cache behaviour when network is down.
> >> =

> >> The device is shared through iSCSI. The first test is filling a huge
> >> file with dd from /dev/zero. So, this is sequential access. While dd is
> >> running, i remove the tun iface from the bridge on the host. iSCSI
> >> properly detects the network failure.
> >> =

> >> I expected dm-cache to continue filling dirty blocks, even if the
> >> network device is blocking. But it doesn't. The status shows that dirty
> >> blocks count stays the same. dd is blocking.
> >> =

> >> I'm wondering if there is some cache desactivation due to
> >> sequential_threshold. But increasing sequential_threshold did not help.
> >> Where does dm-cache blocks ?
> >> =

> >> Is it possible to have dm-cache "bufferize" blocks for network
> >> failures ?

I'm a user, not the author, but here's what I've experienced with dmcache:

Huge sequential writes will generally bypass the cache; what is your setting
for sequential_threshold?  (Your message hints that it might actually be hi=
gh
enough.)

Second, even if it /is/ caching the blocks, I think the default mode is
writethrough mode, which means that the write request waits first for ssd
commit and then for origin device commit.

As for 'bufferizing' blocks ... in 3.9 (3.10?) writeback mode seems to write
blocks to the ssd while issuing an asynchronous write to the origin device.

(Maybe you're already using wb mode?)

> >> =

> >> Regards,
> > =

> > Disclaimer: Not an expert, and not actually involved in writing bcache
> > =

> > Well, since you didn't mention changing it, I suspect you are operating=
 in
> > the default "writethrough" mode - this doesn't return to userspace until
> > the data is on the backing (iSCSI in your case) device. For bcache over=
 a
> > network volume, this is the safe option, since the client machine dying
> > won't lose data.
> > =

> > If you put bcache in writethrough mode, it may well do exactly as you
> > describe, but only if iSCSI itself recovers from the connection loss (a=
nd
> > possibly other caveats I'm not thinking of). If it doesn't, or if it do=
es
> > but doesn't manage to maintain the exact state it was in on disconnecti=
on,
> > then you will lose data.
> =

> My apologies, I didn't realize until I ready my own reply on the way back =

> that this was on the topic of dm-cache rather than bcache.
> =

> To properly respond, as I understand it dm-cache works by migrating chunk=
s =

> between the backing device and the faster cache. If your write would go t=
o =

> the backing device, it would block exactly as normal.

dmcache's default controller manages hot blocks...

--D
> =

> (I hope I didn't get this egregiously wrong...)
> =

> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

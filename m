From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Bug#403426: kernel corrupts LUKS partition header on
	arm
Date: Wed, 3 Jan 2007 20:37:22 +0100
Message-ID: <20070103193722.GC27931@deprecation.cyrius.com>
References: <20061220161529.GA10820@deprecation.cyrius.com>
	<87lkkrgej4.wl%clemens@endorphin.org>
	<20061229202434.GD23246@deprecation.cyrius.com>
	<87vejt64kc.wl%clemens@endorphin.org>
	<20061230131342.GF4981@deprecation.cyrius.com>
	<87odph5ppk.wl%clemens@endorphin.org>
	<20070102180440.GB4216@deprecation.cyrius.com>
	<87hcv859nm.wl%clemens@endorphin.org>
	<20070103191442.GA28165@deprecation.cyrius.com>
	<87fyar6h49.wl%clemens@endorphin.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87fyar6h49.wl%clemens@endorphin.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Clemens Fruhwirth <clemens@endorphin.org>
Cc: 403426@bugs.debian.org, dm-devel@redhat.com, Brian Brunswick <bdb-reportbug@forbidden.co.uk>
List-Id: dm-devel.ids

* Clemens Fruhwirth <clemens@endorphin.org> [2007-01-03 20:32]:
> > I just applied the two patches from that thread and successfully ran
> > 'cryptsetup luksClose' on ARM.
> 
> "cryptsetup luksClose" is just an alias for "cryptsetup remove". This
> should never fail. What's with luksOpen after the patches?

Sorry, I meant to say that luksOpen worked with the patches.  I simply
copy&pasted the wrong line.

> > Would the lack of __flush_anon_page() on ARM explain the corruption
> > you've observed?
> Again, I'm not familiar with this.

Well, it seems to fix the problem and according to the thread on lkml
the lack of flush_anon_page() on ARM is associated with some
corruption.  At least FUSE doesn't work on ARM without those patches,
so it seems likely that luksOpen is also affected.
-- 
Martin Michlmayr
http://www.cyrius.com/

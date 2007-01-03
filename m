From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Bug#403426: kernel corrupts LUKS partition header on
	arm
Date: Wed, 3 Jan 2007 20:14:42 +0100
Message-ID: <20070103191442.GA28165@deprecation.cyrius.com>
References: <20061217022906.2434.60658.reportbug@LKG8A754B.example.org>
	<20061220161529.GA10820@deprecation.cyrius.com>
	<87lkkrgej4.wl%clemens@endorphin.org>
	<20061229202434.GD23246@deprecation.cyrius.com>
	<87vejt64kc.wl%clemens@endorphin.org>
	<20061230131342.GF4981@deprecation.cyrius.com>
	<87odph5ppk.wl%clemens@endorphin.org>
	<20070102180440.GB4216@deprecation.cyrius.com>
	<87hcv859nm.wl%clemens@endorphin.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87hcv859nm.wl%clemens@endorphin.org>
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

* Clemens Fruhwirth <clemens@endorphin.org> [2007-01-03 17:59]:
> After a bit of debugging on Gordon's slug, I found out that we have
> some kind of read race/read corruption when reading the encrypted
> master key from a key slot.
...
> As far as I understand page caching comes after dm-crypt, so maybe we
> have some kind of cache corruption here?

Do you think this is related to http://lkml.org/lkml/2006/12/21/157
I just applied the two patches from that thread and successfully ran
'cryptsetup luksClose' on ARM.  Would the lack of __flush_anon_page()
on ARM explain the corruption you've observed?
-- 
Martin Michlmayr
http://www.cyrius.com/

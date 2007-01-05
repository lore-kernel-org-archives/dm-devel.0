From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Bug#403426: kernel corrupts LUKS partition header on
	arm
Date: Fri, 5 Jan 2007 10:59:03 +0100
Message-ID: <20070105095903.GL15109@deprecation.cyrius.com>
References: <20061230131342.GF4981@deprecation.cyrius.com>
	<87odph5ppk.wl%clemens@endorphin.org>
	<20070102180440.GB4216@deprecation.cyrius.com>
	<87hcv859nm.wl%clemens@endorphin.org>
	<20070103191442.GA28165@deprecation.cyrius.com>
	<87fyar6h49.wl%clemens@endorphin.org>
	<20070103193722.GC27931@deprecation.cyrius.com>
	<87ejqb57k4.wl%clemens@endorphin.org>
	<20070104150951.GM27931@deprecation.cyrius.com>
	<97a0a9ac0701050036l7def022dr9d45ab8bde787da5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <97a0a9ac0701050036l7def022dr9d45ab8bde787da5@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gordon Farquharson <gordonfarquharson@gmail.com>
Cc: Clemens Fruhwirth <clemens@endorphin.org>, dm-devel@redhat.com, Brian Brunswick <bdb-reportbug@forbidden.co.uk>, 403426@bugs.debian.org
List-Id: dm-devel.ids

* Gordon Farquharson <gordonfarquharson@gmail.com> [2007-01-05 01:36]:
> However, I have found that I am unable to access the LUKS partition
> when the system is under heavy load and swapping.

Interesting.  Can you check whether you see the same problems with
FUSE (see #402876)?

> Martin, I wonder if this has anything to do with the virtual memory
> bug in the kernel that we experienced with apt. It could be that this
> bug existed before 2.6.19 but was much harder to trigger (e.g. see

I don't know.  I'm aware this bug has been around for a while (but
hard to trigger) but I'd b cautious to attribute every bug we see to
it.  Of course it's possible that this is the problem but somehow I
doubt it.
-- 
Martin Michlmayr
http://www.cyrius.com/

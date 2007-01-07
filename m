From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Subject: Bug#403426: kernel corrupts LUKS partition header on arm
Date: Sat, 6 Jan 2007 22:47:06 -0700
Message-ID: <97a0a9ac0701062147s5d122d85v98141b30c5786b2f@mail.gmail.com>
References: <20061229202434.GD23246@deprecation.cyrius.com>
	 <87odph5ppk.wl%clemens@endorphin.org>
	 <20070102180440.GB4216@deprecation.cyrius.com>
	 <87hcv859nm.wl%clemens@endorphin.org>
	 <20070103191442.GA28165@deprecation.cyrius.com>
	 <87fyar6h49.wl%clemens@endorphin.org>
	 <20070103193722.GC27931@deprecation.cyrius.com>
	 <87ejqb57k4.wl%clemens@endorphin.org>
	 <20070104150951.GM27931@deprecation.cyrius.com>
	 <97a0a9ac0701050036l7def022dr9d45ab8bde787da5@mail.gmail.com>
Reply-To: "Gordon Farquharson" <gordonfarquharson@gmail.com>,
	403426@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <bounce-debian-bugs-rc=glddbr-debian-bugs-rc=gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.403426.B403426.116814882814803@bugs.debian.org>
In-Reply-To: <97a0a9ac0701050036l7def022dr9d45ab8bde787da5@mail.gmail.com>
Content-Disposition: inline
List-Post: <mailto:debian-bugs-rc@lists.debian.org>
List-Help: <mailto:debian-bugs-rc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=unsubscribe>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Clemens Fruhwirth <clemens@endorphin.org>, dm-devel@redhat.com, Brian Brunswick <bdb-reportbug@forbidden.co.uk>, 403426@bugs.debian.org
List-Id: dm-devel.ids

On 1/5/07, Gordon Farquharson <gordonfarquharson@gmail.com> wrote:

> However, I have found that I am unable to access the LUKS partition
> when the system is under heavy load and swapping.
>
> Martin, I wonder if this has anything to do with the virtual memory
> bug in the kernel that we experienced with apt. It could be that this
> bug existed before 2.6.19 but was much harder to trigger (e.g. see
> http://lkml.org/lkml/2007/1/3/285). It would be interesting to try
> accessing a LUKS partition under heavy load while running 2.6.20-git,
> but that will have to wait until the weekend for me to test it.

Ok, I tested 2.6.19-1~experimental.1 +

   vm-fix-nasty-and-subtle-race-in-shared-mmap-ed-page-writeback.patch
   flush_anon_page-generic.patch
   flush_anon_page-arm.patch

and I am still unable to access the LUKS paritition under heavy load
and swapping, so it appears that there is someting else causing this
problem.

Gordon

-- 
Gordon Farquharson

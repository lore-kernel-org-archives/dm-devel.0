From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Subject: Bug#403426: kernel corrupts LUKS partition header on arm
Date: Fri, 5 Jan 2007 01:36:14 -0700
Message-ID: <97a0a9ac0701050036l7def022dr9d45ab8bde787da5@mail.gmail.com>
References: <20061229202434.GD23246@deprecation.cyrius.com>
	 <20061230131342.GF4981@deprecation.cyrius.com>
	 <87odph5ppk.wl%clemens@endorphin.org>
	 <20070102180440.GB4216@deprecation.cyrius.com>
	 <87hcv859nm.wl%clemens@endorphin.org>
	 <20070103191442.GA28165@deprecation.cyrius.com>
	 <87fyar6h49.wl%clemens@endorphin.org>
	 <20070103193722.GC27931@deprecation.cyrius.com>
	 <87ejqb57k4.wl%clemens@endorphin.org>
	 <20070104150951.GM27931@deprecation.cyrius.com>
Reply-To: "Gordon Farquharson" <gordonfarquharson@gmail.com>,
	403426@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.403426.B403426.1167986179554@bugs.debian.org>
In-Reply-To: <20070104150951.GM27931@deprecation.cyrius.com>
Content-Disposition: inline
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Clemens Fruhwirth <clemens@endorphin.org>, dm-devel@redhat.com, Brian Brunswick <bdb-reportbug@forbidden.co.uk>, 403426@bugs.debian.org
List-Id: dm-devel.ids

On 1/4/07, Martin Michlmayr <tbm@cyrius.com> wrote:

> * Clemens Fruhwirth <clemens@endorphin.org> [2007-01-04 12:56]:
> > So, can we close the bug against cryptsetup in this case?
>
> #403426 is really about the header corruption which you have fixed in
> SVN.  It should be closed when the Debian maintainers make a new
> upload with that fix.
>
> > Maybe someone else can verify that?
>
> CCing Gordon. :)

Ok, so here are some interesting results...

I am able to access the LUKS partition on the NSLU2 running 2.6.18
from subversion (which includes flush_anon_page-generic.patch and
flush_anon_page-arm.patch) with both cryptsetup-1.0.4-8 (the latest
version in testing) and cryptsetup-1.0.4-8 plus 02_fix_arm.dpatch and
03_no_header_conv.dpatch that were posted to this thread.

$ sudo cryptsetup luksOpen /dev/sdb3 testfs
Enter LUKS passphrase:
key slot 0 unlocked.
Command successful.
gordon@LKG7102D7:~$ sudo mount /dev/mapper/testfs /mnt/tmp
gordon@LKG7102D7:~$ sudo umount /mnt/tmp
gordon@LKG7102D7:~$ sudo cryptsetup luksClose testfs

However, I have found that I am unable to access the LUKS partition
when the system is under heavy load and swapping.

$ sudo cryptsetup luksOpen /dev/sdb3 testfs
Enter LUKS passphrase:
Enter LUKS passphrase:
Enter LUKS passphrase:
Command failed: No key available with this passphrase.

gordon@LKG7102D7:~$ uptime
 00:22:23 up 16 min,  2 users,  load average: 3.01, 1.85, 0.93
gordon@LKG7102D7:~$ free
             total       used       free     shared    buffers     cached
Mem:         29988      28908       1080          0        172       3028
-/+ buffers/cache:      25708       4280
Swap:        88316      67508      20808

Once the system load decreases and the swapping stops, I am able to
access the LUKS partition again. This behaviour is very repeatable.

Martin, I wonder if this has anything to do with the virtual memory
bug in the kernel that we experienced with apt. It could be that this
bug existed before 2.6.19 but was much harder to trigger (e.g. see
http://lkml.org/lkml/2007/1/3/285). It would be interesting to try
accessing a LUKS partition under heavy load while running 2.6.20-git,
but that will have to wait until the weekend for me to test it.

Gordon

-- 
Gordon Farquharson

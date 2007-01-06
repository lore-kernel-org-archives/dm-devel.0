From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Subject: Bug#403426: kernel corrupts LUKS partition header on arm
Date: Fri, 5 Jan 2007 23:38:39 -0700
Message-ID: <97a0a9ac0701052238h64471dev99cf63528bae3117@mail.gmail.com>
References: <20061230131342.GF4981@deprecation.cyrius.com>
	 <20070102180440.GB4216@deprecation.cyrius.com>
	 <87hcv859nm.wl%clemens@endorphin.org>
	 <20070103191442.GA28165@deprecation.cyrius.com>
	 <87fyar6h49.wl%clemens@endorphin.org>
	 <20070103193722.GC27931@deprecation.cyrius.com>
	 <87ejqb57k4.wl%clemens@endorphin.org>
	 <20070104150951.GM27931@deprecation.cyrius.com>
	 <97a0a9ac0701050036l7def022dr9d45ab8bde787da5@mail.gmail.com>
	 <20070105095903.GL15109@deprecation.cyrius.com>
Reply-To: "Gordon Farquharson" <gordonfarquharson@gmail.com>,
	403426@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <bounce-debian-bugs-rc=glddbr-debian-bugs-rc=gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.403426.B403426.116806552428172@bugs.debian.org>
In-Reply-To: <20070105095903.GL15109@deprecation.cyrius.com>
Content-Disposition: inline
List-Post: <mailto:debian-bugs-rc@lists.debian.org>
List-Help: <mailto:debian-bugs-rc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=unsubscribe>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Clemens Fruhwirth <clemens@endorphin.org>, dm-devel@redhat.com, Brian Brunswick <bdb-reportbug@forbidden.co.uk>, 403426@bugs.debian.org
List-Id: dm-devel.ids

On 1/5/07, Martin Michlmayr <tbm@cyrius.com> wrote:
> * Gordon Farquharson <gordonfarquharson@gmail.com> [2007-01-05 01:36]:
> > However, I have found that I am unable to access the LUKS partition
> > when the system is under heavy load and swapping.
>
> Interesting.  Can you check whether you see the same problems with
> FUSE (see #402876)?

FUSE works with 2.6.18-9 (checked out from subversion on 2007.01.04)
under heavy load and swapping.

gordon@LKG7102D7:~$ encfs /home/gordon/.encrypted /home/gordon/encrypted
EncFS Password:
gordon@LKG7102D7:~$ ls -l encrypted/
total 4
-rw-r--r-- 1 gordon gordon 13 2007-01-05 22:40 example.txt
gordon@LKG7102D7:~$ cat encrypted/example.txt
Some text...
gordon@LKG7102D7:~$ fusermount -u /home/gordon/encrypted
gordon@LKG7102D7:~$ uptime
 23:33:58 up 22:37,  2 users,  load average: 3.38, 2.27, 1.08
gordon@LKG7102D7:~$ free
             total       used       free     shared    buffers     cached
Mem:         29988      28876       1112          0        172       1840
-/+ buffers/cache:      26864       3124
Swap:        88316      63124      25192

Gordon

-- 
Gordon Farquharson

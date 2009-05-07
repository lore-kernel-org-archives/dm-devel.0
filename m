From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Fri, 8 May 2009 00:40:04 +0200
Message-ID: <20090507224003.GB29774@linux>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org> <20090506023332.GA1212@redhat.com> <20090506203228.GH8180@redhat.com> <20090506213453.GC4282@linux> <20090506215235.GJ8180@redhat.com> <20090507090450.GA4613@linux> <20090507141126.GA9463@redhat.com> <20090507144501.GB9463@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763097AbZEGWkb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090507144501.GB9463@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, peterz@infradead.org
List-Id: dm-devel.ids

On Thu, May 07, 2009 at 10:45:01AM -0400, Vivek Goyal wrote:
> So now we are left with the issue of loosing the notion of priority and
> class with-in cgroup. In fact on bigger systems we will probably run into
> issues of kiothrottled scalability as single thread is trying to cater to
> all the disks.
> 
> If we do max bw control at IO scheduler level, then I think we should be able
> to control max bw while maintaining the notion of priority and class with-in
> cgroup. Also there are multiple pdflush threads and jens seems to be pushing
> flusher threads per bdi which will help us achieve greater scalability and
> don't have to replicate that infrastructure for kiothrottled also.

There's a lot of room for improvements and optimizations in the
kiothrottled part, obviously the single-threaded approach is not a
definitive solutions.

Flusher threads are probably a good solution. But I don't think we need
to replicate the pdflush replacement infrastructure for throttled
writeback IO. Instead it could be just integrated with the flusher
threads, i.e. activate flusher threads only when the request needs to be
written to disk according to the dirty memory limit and IO BW limits.

I mean, I don't see any critical problem for this part.

Instead, preserving the IO priority and IO scheduler logic inside
cgroups seems a more critical issue to me. And I'm quite convinced that
the right approach for this is to operate at the IO scheduler, but I'm
still a little bit skeptical that only operating at the IO scheduler
level would resolve all our problems.

-Andrea

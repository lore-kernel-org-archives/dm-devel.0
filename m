From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: IO scheduler based IO Controller V2
Date: Sat, 09 May 2009 11:22:52 +0200
Message-ID: <1241860972.6316.91.camel@laptop>
References: <20090506203228.GH8180@redhat.com> <20090506213453.GC4282@linux>
	 <20090506215235.GJ8180@redhat.com> <20090507090450.GA4613@linux>
	 <20090507141126.GA9463@redhat.com> <20090507144501.GB9463@redhat.com>
	 <20090507153642.GC9463@redhat.com> <20090507221900.GA29774@linux>
	 <20090508180951.GG7293@redhat.com> <20090508200458.GA3708@linux>
	 <20090508215618.GJ7293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754415AbZEIJYg@vger.kernel.org>
In-Reply-To: <20090508215618.GJ7293@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <righi.andrea@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com
List-Id: dm-devel.ids

On Fri, 2009-05-08 at 17:56 -0400, Vivek Goyal wrote:
>   So, we shall have to come up with something better, I think Dhaval was
>   implementing upper limit for cpu controller. May be PeterZ and Dhaval can
>   give us some pointers how did they manage to implement both proportional
>   and max bw control with the help of a single tree while maintaining the
>   notion of prio with-in cgroup.

We don't do max bandwidth control in the SCHED_OTHER bits as I oppose to
making it non work conserving.

SCHED_FIFO/RR do constant bandwidth things and are always scheduled in
favour of SCHED_OTHER. 

That is, we provide a minimum bandwidth for real-time tasks, but since
having a maximum higher than the minimum is useless since one cannot
rely on it (non deterministic) we put max = min.

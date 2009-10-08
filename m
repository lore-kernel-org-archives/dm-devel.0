From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: More performance numbers (Was: Re: IO scheduler
	based IO controller V10)
Date: Thu, 8 Oct 2009 10:34:38 +0200
Message-ID: <20091008083438.GC4220@linux>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	<20090924143315.781cd0ac.akpm@linux-foundation.org>
	<20091008044251.GA3490@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091008044251.GA3490@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, Andrew Morton <akpm@linux-foundation.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Thu, Oct 08, 2009 at 12:42:51AM -0400, Vivek Goyal wrote:
> Apart from IO scheduler controller number, I also got a chance to run same
> tests with dm-ioband controller. I am posting these too. I am also
> planning to run similar numbers on Andrea's "max bw" controller also.
> Should be able to post those numbers also in 2-3 days.

For those who are interested (expecially to help Vivek to test all this
stuff) here the all-in-one patchset of the io-throttle controller,
rebased to 2.6.31:
http://www.develer.com/~arighi/linux/patches/io-throttle/old/cgroup-io-throttle-2.6.31.patch

And this one is v18 rebased to 2.6.32-rc3:
http://www.develer.com/~arighi/linux/patches/io-throttle/cgroup-io-throttle-v18.patch

Thanks,
-Andrea

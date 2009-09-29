From: Nauman Rafique <nauman@google.com>
Subject: Re: IO scheduler based IO controller V10
Date: Mon, 28 Sep 2009 17:37:28 -0700
Message-ID: <e98e18940909281737q142c788dpd20b8bdc05dd0eff@mail.gmail.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, yoshikawa.takuya@oss.ntt.co.jp, jmoyer@redhat.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi Vivek,
Me, Divyesh, Fernando and Yoshikawa had a chance to have a chat with
Jens about IO controller during Linux Plumbers Conference '09. Jens
expressed his concerns about the size and complexity of the patches. I
believe that is a reasonable concern. We talked about things that
could be done to reduce the size of the patches. The requirement that
the "solution has to work with all IO schedulers" seems like a
secondary concern at this point; and it came out as one thing that can
help to reduce the size of the patch set. Another possibility is to
use a simpler scheduling algorithm e.g. weighted round robin, instead
of BFQ scheduler. BFQ indeed has great properties, but we cannot deny
the fact that it is complex to understand, and might be cumbersome to
maintain. Also, hierarchical scheduling is something that could be
unnecessary in the first set of patches, even though cgroups are
hierarchical in nature.

We are starting from a point where there is no cgroup based IO
scheduling in the kernel. And it is probably not reasonable to satisfy
all IO scheduling related requirements in one patch set. We can start
with something simple, and build on top of that. So a very simple
patch set that enables cgroup based proportional scheduling for CFQ
seems like the way to go at this point.

It would be great if we discuss our plans on the mailing list, so we
can get early feedback from everyone.

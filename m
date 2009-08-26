From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: IO controller Mini-Summit 2009
Date: Wed, 26 Aug 2009 20:32:51 +0900 (JST)
Message-ID: <20090826.203251.260094379.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: ioband-devel@lists.sourceforge.net, corsetproject@googlegroups.com, kunai@linux-foundation.jp, osonoi@linux-foundation.jp
List-Id: dm-devel.ids

Hi All,

As I have notified before, The 1st Linux IO controller Mini-Summit
will be held in Tokyo Japan on Oct 17 -- day before the 9th Linux
kernel summit. So I would like to propose the following topics for 
the mini-summit and discuss about them.

- Multiple IO controller development projects
  - There are two activities for the development of IO controller,
    Vivek's io-controller and dm-ioband. Do we have to pick one of
    them to put into the mainline? How to advance the development?

- Extensions of struct bio
  - Make a bio point to the io_context of a process which creates the
    I/O request. This allows to pass the IO scheduling class and
    priority information to IO controller even if the IO is submitted
    by another process which does not create the request, such as a
    worker thread.
  - Add a new flag to struct bio to identify the bio as urgent. This
    gives IO controller a chance to handle the bio as high priority.
    This flag should be set if the bio is created for the page-out
    operation.

- I/O tracking and charging policy
  - Which process, a page-requesting process or a page-returning
    process, should be charged for the I/O caused by page reclaim?
    We should consider two cases where the IO flushes anonymous pages
    and file mapped pages.

I think this is a good opportunity to meet face-to-face to discuss
about IO controller development. I would like to many developers to
join this mini-summit. Please visit the following URL for more
information about the mini-summit.
http://apps.sourceforge.net/trac/ioband/wiki/iosummit
If you would like to join the mini-summit, please e-mail to me or post
on the wiki page, 
(You need an account on SourceForge.net to edit the wiki page.)

All comments, questions, suggestions and anything else are appreciated.

Thanks,
Ryo Tsuruta

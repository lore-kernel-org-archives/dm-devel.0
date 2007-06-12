From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Question about NetLink
Date: Tue, 12 Jun 2007 12:37:45 -0700
Message-ID: <20070612193745.GA14958@us.ibm.com>
References: <118141608864-git-send-email-michaelc@cs.wisc.edu>
	<D44F48C7D79D2943A073C8FA0F49A3CCFE5DC9@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CCFE5DC9@orsmsx418.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Wood, Brian J <brian.j.wood@intel.com> wrote:
> Hello, Alasdair recently said that device-mapper was moving to the a
> netlink event reporting model (and I see the patches have been posted).
> I found an article (2 years old) describing this at:
> http://www.linuxjournal.com/article/7356. I wanted to read up on this
> and wondered if this article was a good starting point.
> 

I found that it was easier to use the libnl interface.
http://people.suug.ch/~tgr/libnl/

I have previously posted a test program using the libnl interface with the
dm netlink patches. You should be able to find the program in the
archives.

or

I updated the demo program some so ping me if you would like an updated
copy.

-andmike
--
Michael Anderson
andmike@us.ibm.com

From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 3/4] dm-mpath: separate pg-init handling
	from	process_queued_ios()
Date: Tue, 2 Feb 2010 18:24:37 +0000
Message-ID: <20100202182437.GI864@agk-dp.fab.redhat.com>
References: <4B665507.8080205@ct.jp.nec.com> <4B6656FF.5000701@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B6656FF.5000701@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 01, 2010 at 01:22:23PM +0900, Kiyoshi Ueda wrote:
> This patch is a preparation of the next patch, which fixes the issue
> that ioctl isn't processed until any I/O is issued.  (And also it is
> a preparation of another patch-set to remove multipath internal queue.)
> No functional change.
 
I've split this into two, but it's very 'tight' code forming a state
machine here, and while I understand the principle of the patch, I can't
spot an easy way to tell that all the paths through the code are right.
Is it worth trying to extend the explanation, or will later patches be
replacing this code, making it better to wait for that new code before
reviewing?

  ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-mpath-refactor-pg_init-trigger.patch

Alasdair

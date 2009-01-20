From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm-ioband: I/O bandwidth controller
	v1.10.0: Source code and patch
Date: Tue, 20 Jan 2009 15:19:55 +0000
Message-ID: <20090120151955.GG9859@agk.fab.redhat.com>
References: <20090120.141022.193708059.ryov@valinux.co.jp>
	<20090120.141114.226778416.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090120.141114.226778416.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

OK, an easy thing first.

Please review all the debugging messages and decide whether they will really
still be necessary in an upstream kernel.

Then convert them to DM_DEBUG or DM_DEBUG_LIMIT as appropriate and remove
the 'debug' option.

If you genuinely believe you need to be able to enable some of these at runtime
on a live machine - and so far no other part of dm has found that necessary -
then you should offer some justification and extend the DM_DEBUG* macros (in a
separate patch) to support that.

If however this is more about statistics/verbosity - i.e. information the
user might want to see about how the target is behaving, then consider
alternative ways of making that information available to userspace.

Alasdair

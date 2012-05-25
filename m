From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 0/2] multipath: compile cleanup
Date: Fri, 25 May 2012 07:20:53 +0200
Message-ID: <1337923253.757.0.camel@lapoo.opensvc.com>
References: <1337921863-26482-1-git-send-email-bmarzins@redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1337921863-26482-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On jeu., 2012-05-24 at 23:57 -0500, Benjamin Marzinski wrote:
> When the multipath code is compiled with the standard redhat rpm cflags,
> there are a number of warnings that get issued, some about real problems.
> 
> These patches switch multipath to use those cflags, and then clean up
> warnings. If people want upstream to continue using the existing cflags,
> I don't particularly mind.  I really included the first patch to make sure
> people can see the warnings that the second patch corrects.
> 
> Also, some of the warnings are for actual errors, and how to fix them is
> obvious.  Others won't actually cause problems, and if people object to
> the changes I made to make them go away, I'm happy to fix them differently. 
> 
Merged.

Thanks.

> Benjamin Marzinski (2):
>   multipath: Build with standard rpm cflags
>   multipath: Fix warnings from stricter compile options.
> 
>  Makefile.inc                     |    6 +++++-
>  libmpathpersist/mpath_persist.c  |   10 +++++++---
>  libmpathpersist/mpath_pr_ioctl.c |    9 +++++++++
>  libmultipath/alias.c             |    8 ++++++--
>  mpathpersist/main.c              |    2 --
>  multipathd/main.c                |   24 +++++++++++++++++++-----
>  6 files changed, 46 insertions(+), 13 deletions(-)
> 

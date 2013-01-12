From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 3/3] Drop useless link to curses library
Date: Sat, 12 Jan 2013 14:14:17 +0100
Message-ID: <1357996457.4263.14.camel@lapoo.opensvc.com>
References: <1357725956-24346-1-git-send-email-rrs@debian.org>
	<1357725956-24346-4-git-send-email-rrs@debian.org>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357725956-24346-4-git-send-email-rrs@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ritesh Raj Sarraf <rrs@debian.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On mer., 2013-01-09 at 15:35 +0530, Ritesh Raj Sarraf wrote:
> Description: Do not link against ncurses unnecessarily
> Author: Sven Joachim <svenjoac@gmx.de>
> Bug-Debian: http://bugs.debian.org/646148
> Last-Update: <2011-11-05>
> 
Merged.

> Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
> ---
>  multipathd/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 9553251..b490c1d 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -6,7 +6,7 @@ include ../Makefile.inc
>  # basic flags setting
>  #
>  CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
> -LDFLAGS += -lpthread -ldevmapper -lreadline -lncurses -ludev -ldl \
> +LDFLAGS += -lpthread -ldevmapper -lreadline -ludev -ldl \
>  	   -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
>  
>  #

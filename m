From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH 1/1] fix build, replace GZIP with GZIPCMD
Date: Wed, 10 Sep 2014 10:24:04 +0200
Message-ID: <54100AA4.5080008@redhat.com>
References: <1410251280-16898-1-git-send-email-mail@eworm.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410251280-16898-1-git-send-email-mail@eworm.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@opensvc.com
Cc: Christian Hesse <mail@eworm.de>
List-Id: dm-devel.ids

Dne 9.9.2014 v 10:28 Christian Hesse napsal(a):
> Files are compressed by gzip. In Makefiles the variable GZIP is
> used, this evaluates to 'gzip gzip' on my system.
>
>>From man gzip:
>> The environment variable GZIP can hold a set of
>> default options for gzip. These options are interpreted first and can
>> be overwritten by explicit command line parameters.
>
> So using any other variable name fixes this.
> ---
>   Makefile.inc             | 2 +-
>   kpartx/Makefile          | 2 +-
>   libmpathpersist/Makefile | 4 ++--
>   mpathpersist/Makefile    | 2 +-
>   multipathd/Makefile      | 2 +-
>   5 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/Makefile.inc b/Makefile.inc
> index 20ae23e..662b1a2 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -42,7 +42,7 @@ libdir	    = $(prefix)/$(LIB)/multipath
>   unitdir     = $(prefix)/usr/lib/systemd/system
>   mpathpersistdir = $(TOPDIR)/libmpathpersist
>
> -GZIP        = gzip -9 -c
> +GZIPCMD        = gzip -9 -c
>   INSTALL_PROGRAM = install


This rather looks like a bug in your system you should fix locally.


>
>   ifndef RPM_OPT_FLAGS
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index 4ba38ba..d533c9e 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -21,7 +21,7 @@ all: $(EXEC)
>
>   $(EXEC): $(OBJS)
>   	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS)
> -	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
> +	$(GZIPCMD) $(EXEC).8 > $(EXEC).8.gz


Probably pastbin output of your  makefile processing here.
Together with your environmental vars.


> --- a/libmpathpersist/Makefile
> +++ b/libmpathpersist/Makefile
> @@ -22,8 +22,8 @@ $(LIBS):
>   	$(CC) -Wall -fPIC -c $(CFLAGS) *.c
>   	$(CC)  -shared $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
>   	ln -s $(LIBS) $(DEVLIB)
> -	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz	
> -	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz	
> +	$(GZIPCMD) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
> +	$(GZIPCMD) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz

On the other hand - I'm quite puzzled why upstream build bothers to compress 
man pages?

Common practice is to leave this up-to distro packagers to maintain compressed 
man pages?

Or is there some new guide line for projects to build man pages in compressed 
form?

Zdenek

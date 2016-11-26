From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] multipath-tools: add CFLAGS to compilation
 options for prioritizers and checkers
Date: Sat, 26 Nov 2016 23:00:50 +0000
Message-ID: <BLUPR02MB16833109A27B319E7E1F319281880@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <20161126222649.29409-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/26/16 14:26, Xose Vazquez Perez wrote:
> Is there anything else missing or leftover?
>
> $ git grep "(CC)"
> Makefile.inc:   $(CC) $(CFLAGS) -c -o $@ $<
> kpartx/Makefile:        $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
> libmpathcmd/Makefile:   $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
> libmpathpersist/Makefile:       $(CC) -c $(CFLAGS) *.c
> libmpathpersist/Makefile:       $(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
> libmultipath/Makefile:  $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
> libmultipath/checkers/Makefile: $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev
> libmultipath/checkers/Makefile: $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
> libmultipath/checkers/Makefile: $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> libmultipath/prioritizers/Makefile:     $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> libmultipath/prioritizers/Makefile:     $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> mpathpersist/Makefile:  $(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
> multipath/Makefile:     $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
> multipathd/Makefile:    $(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
>
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/checkers/Makefile     | 6 +++---
>  libmultipath/prioritizers/Makefile | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
> index 11ab76f..c44c08e 100644
> --- a/libmultipath/checkers/Makefile
> +++ b/libmultipath/checkers/Makefile
> @@ -19,13 +19,13 @@ LIBS= \
>  all: $(LIBS)
>
>  libcheckrbd.so: rbd.o
> -	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev
> +	$(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev
>
>  libcheckdirectio.so: libsg.o directio.o
> -	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
> +	$(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
>
>  libcheck%.so: libsg.o %.o
> -	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> +	$(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
>
>  install:
>  	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
> diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
> index 36b42e4..e85a9d8 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -23,10 +23,10 @@ LIBS = \
>  all: $(LIBS)
>
>  libprioalua.so: alua.o alua_rtpg.o
> -	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> +	$(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
>
>  libprio%.so: %.o
> -	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> +	$(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
>
>  install: $(LIBS)
>  	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)

Hello Xose,

What is the purpose of this patch and why do you think it is useful? It 
is already possible to specify flags for linking shared libraries 
through LDFLAGS. I don't see why CFLAGS should be added to the shared 
library creation commands. Additionally, automake also ignores CFLAGS 
when linking shared libraries. See also 
https://www.gnu.org/software/automake/manual/html_node/Libtool-Flags.html#Libtool-Flags.

Bart.

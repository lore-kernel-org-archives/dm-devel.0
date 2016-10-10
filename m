From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 15/15] Makefile.inc: Enable -Wextra and
 -Wformat-nonliteral
Date: Mon, 10 Oct 2016 21:17:44 +0200
Message-ID: <e3558026-9180-42a3-97ae-1f8fe66938de@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Bart,

With this patch, clang is emitting four new warnings:

> Instead of selecting some of the options enabled by -Wextra, enable
> -Wextra and disable some of the options enabled by -Wextra. Enable
> -Wformat-nonliteral.
>
> --- a/Makefile.inc
> +++ b/Makefile.inc
>  [...]
> -OPTFLAGS	= -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall \
> -		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector --param=ssp-buffer-size=4
> +OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 \
> +		  -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered\
> +		  -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector \
> +		  --param=ssp-buffer-size=4


clang -O2 -g -pipe -Wall -Wextra -Wformat=2 -Wno-sign-compare -Wno-unused-parameter -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmpathcmd
-DUSE_SYSTEMD=229 -DLIBDM_API_FLUSH -D_GNU_SOURCE -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DLIBDM_API_DEFERRED -c -o devmapper.o devmapper.c
devmapper.c:86:20: warning: format string is not a string literal [-Wformat-nonliteral]
                vfprintf(stdout, f, ap);
                                 ^
1 warning generated.

clang -O2 -g -pipe -Wall -Wextra -Wformat=2 -Wno-sign-compare -Wno-unused-parameter -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmpathcmd
-DUSE_SYSTEMD=229 -DLIBDM_API_FLUSH -D_GNU_SOURCE -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DLIBDM_API_DEFERRED -c -o debug.o debug.c
debug.c:41:21: warning: format string is not a string literal [-Wformat-nonliteral]
                        vfprintf(stdout, fmt, ap);
                                         ^~~
1 warning generated.

clang -O2 -g -pipe -Wall -Wextra -Wformat=2 -Wno-sign-compare -Wno-unused-parameter -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmpathcmd
-DUSE_SYSTEMD=229 -DLIBDM_API_FLUSH -D_GNU_SOURCE -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DLIBDM_API_DEFERRED -c -o log_pthread.o log_pthread.c
log_pthread.c:28:17: warning: format string is not a string literal [-Wformat-nonliteral]
                vsyslog(prio, fmt, ap);
                              ^~~
1 warning generated.

clang -O2 -g -pipe -Wall -Wextra -Wformat=2 -Wno-sign-compare -Wno-unused-parameter -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmpathcmd
-DUSE_SYSTEMD=229 -DLIBDM_API_FLUSH -D_GNU_SOURCE -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DLIBDM_API_DEFERRED -c -o log.o log.c
log.c:121:32: warning: format string is not a string literal [-Wformat-nonliteral]
        vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
                                      ^~~
1 warning generated.

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] set pthread stack size to at
	least	PTHREAD_STACK_MIN
Date: Fri, 13 Mar 2009 11:51:59 +0100
Message-ID: <49BA3ACF.1010101@suse.de>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
	<1236883093-2989-3-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1236883093-2989-3-git-send-email-bmarzins@redhat.com>
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

Benjamin Marzinski wrote:
> Attempting to set the stacksize of a pthread to below
> PTHREAD_STACK_MIN causes pthread_attr_setstacksize() to fail, which
> means that the thread will use the default stack size.  This fix
> makes sure that multipathd never requests a stack size less than
> PTHREAD_STACK_MIN.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/log_pthread.c |    6 +++++-
>  libmultipath/waiter.c      |    5 ++++-
>  multipathd/main.c          |    5 ++++-
>  3 files changed, 13 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index a1d4a10..5d2fe76 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -6,6 +6,7 @@
>  #include <stdarg.h>
>  #include <pthread.h>
>  #include <sys/mman.h>
> +#include <limits.h>
> =20
>  #include <memory.h>
> =20
> @@ -52,6 +53,7 @@ static void * log_thread (void * et)
> =20
>  void log_thread_start (void)
>  {
> +	size_t stacksize =3D 64 * 1024;
>  	pthread_attr_t attr;
> =20
>  	logdbg(stderr,"enter log_thread_start\n");
> @@ -65,7 +67,9 @@ void log_thread_start (void)
>  	pthread_cond_init(logev_cond, NULL);
> =20
>  	pthread_attr_init(&attr);
> -	pthread_attr_setstacksize(&attr, 64 * 1024);
> +	if (stacksize < PTHREAD_STACK_MIN)
> +		stacksize =3D PTHREAD_STACK_MIN;
> +	pthread_attr_setstacksize(&attr, stacksize);
> =20
>  	if (log_init("multipathd", 0)) {
>  		fprintf(stderr,"can't initialize log buffer\n");
[ .. ]
Hmm. I don't quite agree. I run into the same problem, but having
discovered that we're not checking any return values at all here
we should rather do the prudent thing and check them once and for all.

I've chosen this approach:

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index 9e9aebe..c33480e 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -53,9 +53,30 @@ static void * log_thread (void * et)
 void log_thread_start (void)
 {
        pthread_attr_t attr;
+       size_t stacksize;
=20
        logdbg(stderr,"enter log_thread_start\n");
=20
+       if (pthread_attr_init(&attr)) {
+               fprintf(stderr,"can't initialize log thread\n");
+               exit(1);
+       }
+
+       if (pthread_attr_getstacksize(&attr, &stacksize) !=3D 0)
+               stacksize =3D PTHREAD_STACK_MIN:
+
+       /* Check if the stacksize is large enough */
+       if (stacksize < (64 * 1024))
+               stacksize =3D 64 * 1024;
+
+       /* Set stacksize and try to reinitialize attr if failed */
+       if (stacksize > PTHREAD_STACK_MIN &&
+           pthread_attr_setstacksize(&attr, stacksize) !=3D 0 &&
+           pthread_attr_init(&attr)) {
+               fprintf(stderr,"can't set log thread stack size\n");
+               exit(1);
+       }
+
        logq_lock =3D (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t))=
;
        logev_lock =3D (pthread_mutex_t *) malloc(sizeof(pthread_mutex_t)=
);
        logev_cond =3D (pthread_cond_t *) malloc(sizeof(pthread_cond_t));
@@ -64,9 +85,6 @@ void log_thread_start (void)
        pthread_mutex_init(logev_lock, NULL);
        pthread_cond_init(logev_cond, NULL);
=20
-       pthread_attr_init(&attr);
-       pthread_attr_setstacksize(&attr, 64 * 1024);
-
        if (log_init("multipathd", 0)) {
                fprintf(stderr,"can't initialize log buffer\n");
                exit(1);


This way we'll at least be notified if something goes wrong in
the future. We shouldn't make the same mistake again and
ignore error codes which don't happen to trigger now.

If agreed I'll post the full patch here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

From: Joe Thornber <joe.thornber@gmail.com>
Subject: Re: [PATCH 2/3] set pthread stack size to at least
	PTHREAD_STACK_MIN
Date: Fri, 13 Mar 2009 11:08:55 +0000
Message-ID: <95d3ae170903130408j5a92bf5bua7d64a3e8d517651@mail.gmail.com>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
	<1236883093-2989-3-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

At least pull this logic out into a seperate function rather than
repeating it three times.  Also you may find min() useful.

- Joe

2009/3/12 Benjamin Marzinski <bmarzins@redhat.com>:
> Attempting to set the stacksize of a pthread to below
> PTHREAD_STACK_MIN causes pthread_attr_setstacksize() to fail, which
> means that the thread will use the default stack size. =A0This fix
> makes sure that multipathd never requests a stack size less than
> PTHREAD_STACK_MIN.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/log_pthread.c | =A0 =A06 +++++-
> =A0libmultipath/waiter.c =A0 =A0 =A0| =A0 =A05 ++++-
> =A0multipathd/main.c =A0 =A0 =A0 =A0 =A0| =A0 =A05 ++++-
> =A03 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
> index a1d4a10..5d2fe76 100644
> --- a/libmultipath/log_pthread.c
> +++ b/libmultipath/log_pthread.c
> @@ -6,6 +6,7 @@
> =A0#include <stdarg.h>
> =A0#include <pthread.h>
> =A0#include <sys/mman.h>
> +#include <limits.h>
>
> =A0#include <memory.h>
>
> @@ -52,6 +53,7 @@ static void * log_thread (void * et)
>
> =A0void log_thread_start (void)
> =A0{
> + =A0 =A0 =A0 size_t stacksize =3D 64 * 1024;
> =A0 =A0 =A0 =A0pthread_attr_t attr;
>
> =A0 =A0 =A0 =A0logdbg(stderr,"enter log_thread_start\n");
> @@ -65,7 +67,9 @@ void log_thread_start (void)
> =A0 =A0 =A0 =A0pthread_cond_init(logev_cond, NULL);
>
> =A0 =A0 =A0 =A0pthread_attr_init(&attr);
> - =A0 =A0 =A0 pthread_attr_setstacksize(&attr, 64 * 1024);
> + =A0 =A0 =A0 if (stacksize < PTHREAD_STACK_MIN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stacksize =3D PTHREAD_STACK_MIN;
> + =A0 =A0 =A0 pthread_attr_setstacksize(&attr, stacksize);
>
> =A0 =A0 =A0 =A0if (log_init("multipathd", 0)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr,"can't initialize log buf=
fer\n");
> diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
> index 54cd19f..4d449e1 100644
> --- a/libmultipath/waiter.c
> +++ b/libmultipath/waiter.c
> @@ -194,6 +194,7 @@ void *waitevent (void *et)
>
> =A0int start_waiter_thread (struct multipath *mpp, struct vectors *vecs=
)
> =A0{
> + =A0 =A0 =A0 size_t stacksize =3D 32 * 1024;
> =A0 =A0 =A0 =A0pthread_attr_t attr;
> =A0 =A0 =A0 =A0struct event_thread *wp;
>
> @@ -203,7 +204,9 @@ int start_waiter_thread (struct multipath *mpp, str=
uct vectors *vecs)
> =A0 =A0 =A0 =A0if (pthread_attr_init(&attr))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> - =A0 =A0 =A0 pthread_attr_setstacksize(&attr, 32 * 1024);
> + =A0 =A0 =A0 if (stacksize < PTHREAD_STACK_MIN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stacksize =3D PTHREAD_STACK_MIN;
> + =A0 =A0 =A0 pthread_attr_setstacksize(&attr, stacksize);
> =A0 =A0 =A0 =A0pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACH=
ED);
>
> =A0 =A0 =A0 =A0wp =3D alloc_waiter();
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 98153df..dae9152 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1267,6 +1267,7 @@ set_oom_adj (int val)
> =A0static int
> =A0child (void * param)
> =A0{
> + =A0 =A0 =A0 size_t stacksize =3D 64 * 1024;
> =A0 =A0 =A0 =A0pthread_t check_thr, uevent_thr, uxlsnr_thr;
> =A0 =A0 =A0 =A0pthread_attr_t attr;
> =A0 =A0 =A0 =A0struct vectors * vecs;
> @@ -1347,7 +1348,9 @@ child (void * param)
> =A0 =A0 =A0 =A0 * start threads
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0pthread_attr_init(&attr);
> - =A0 =A0 =A0 pthread_attr_setstacksize(&attr, 64 * 1024);
> + =A0 =A0 =A0 if (stacksize < PTHREAD_STACK_MIN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stacksize =3D PTHREAD_STACK_MIN;
> + =A0 =A0 =A0 pthread_attr_setstacksize(&attr, stacksize);
> =A0 =A0 =A0 =A0pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACH=
ED);
>
> =A0 =A0 =A0 =A0pthread_create(&check_thr, &attr, checkerloop, vecs);
> --
> 1.5.3.3
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

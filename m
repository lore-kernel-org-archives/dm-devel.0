From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Tue, 16 Aug 2016 08:31:16 +0200
Message-ID: <2a584b4c-88b7-288b-3f89-62c565774cf1@suse.de>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/15/2016 05:28 PM, Bart Van Assche wrote:
> Use pthread_join() to wait until worker threads have finished
> instead of using a counter to keep track of how many threads are
> trying to grab a mutex. Remove mutex_lock.depth since this member
> variable is no longer needed.
> =

> This patch fixes two race conditions:
> * Incrementing "depth" in lock() without holding a mutex.
> * Destroying a mutex from the main thread without waiting for the
>   worker threads to finish using that mutex.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  libmultipath/lock.h | 15 +--------------
>  multipathd/main.c   | 13 ++++++-------
>  2 files changed, 7 insertions(+), 21 deletions(-)
> =

> diff --git a/libmultipath/lock.h b/libmultipath/lock.h
> index 9808480..a170efe 100644
> --- a/libmultipath/lock.h
> +++ b/libmultipath/lock.h
> @@ -3,35 +3,22 @@
>  =

>  #include <pthread.h>
>  =

> -/*
> - * Wrapper for the mutex. Includes a ref-count to keep
> - * track of how many there are out-standing threads blocking
> - * on a mutex. */
>  struct mutex_lock {
>  	pthread_mutex_t mutex;
> -	int depth;
>  };
>  =

>  static inline void lock(struct mutex_lock *a)
>  {
> -	a->depth++;
>  	pthread_mutex_lock(&a->mutex);
>  }
>  =

>  static inline int timedlock(struct mutex_lock *a, struct timespec *tmo)
>  {
> -	int r;
> -
> -	a->depth++;
> -	r =3D pthread_mutex_timedlock(&a->mutex, tmo);
> -	if (r)
> -		a->depth--;
> -	return r;
> +	return pthread_mutex_timedlock(&a->mutex, tmo);
>  }
>  =

>  static inline void unlock(struct mutex_lock *a)
>  {
> -	a->depth--;
>  	pthread_mutex_unlock(&a->mutex);
>  }
>  =

> diff --git a/multipathd/main.c b/multipathd/main.c
> index fff482c..c288195 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2046,7 +2046,6 @@ init_vecs (void)
>  		return NULL;
>  =

>  	pthread_mutex_init(&vecs->lock.mutex, NULL);
> -	vecs->lock.depth =3D 0;
>  =

>  	return vecs;
>  }
> @@ -2394,16 +2393,16 @@ child (void * param)
>  	pthread_cancel(uxlsnr_thr);
>  	pthread_cancel(uevq_thr);
>  =

> +	pthread_join(check_thr, NULL);
> +	pthread_join(uevent_thr, NULL);
> +	pthread_join(uxlsnr_thr, NULL);
> +	pthread_join(uevq_thr, NULL);
> +
>  	lock(&vecs->lock);
>  	free_pathvec(vecs->pathvec, FREE_PATHS);
>  	vecs->pathvec =3D NULL;
>  	unlock(&vecs->lock);
> -	/* Now all the waitevent threads will start rushing in. */
> -	while (vecs->lock.depth > 0) {
> -		sleep (1); /* This is weak. */
> -		condlog(3, "Have %d wait event checkers threads to de-alloc,"
> -			" waiting...", vecs->lock.depth);
> -	}
> +
>  	pthread_mutex_destroy(&vecs->lock.mutex);
>  	FREE(vecs);
>  	vecs =3D NULL;
> =


Makes one wonder: what happens to the waitevent threads?
We won't be waiting for them after applying this patch, right?
So why did we ever had this busy loop here?
Ben?

(And while we're at the subject: can't we drop the waitevent threads
altogether? We're listening to uevents nowadays, so we should be
notified if something happened to the device-mapper tables. Which should
make the waitevent threads unnecessary, right?)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

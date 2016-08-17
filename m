From: Dragan Stancevic <dragan.stancevic@canonical.com>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Wed, 17 Aug 2016 14:36:09 -0500
Message-ID: <CAAZtj81LAeoq8Duvu1hLzyOFNp0B_ZAfcqyQAMvmQd19jRLw8A@mail.gmail.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8021650317399159655=="
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
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8021650317399159655==
Content-Type: multipart/alternative; boundary=001a113f37ccc8de5a053a4993b7

--001a113f37ccc8de5a053a4993b7
Content-Type: text/plain; charset=UTF-8

Hi Bart-

Acked-by: dragan.stancevic@canonical.com

I agree with your patch, I have been tracking an issue where multipathd
dumps core on the exit path just past the treads being canceled. Your patch
is very similar to mine (minus nuking the depth) that I was going to send
out to a user to test with. The checker thread accesses a valid pointer
with garbage values....

On Mon, Aug 15, 2016 at 10:28 AM, Bart Van Assche <
bart.vanassche@sandisk.com> wrote:

> Use pthread_join() to wait until worker threads have finished
> instead of using a counter to keep track of how many threads are
> trying to grab a mutex. Remove mutex_lock.depth since this member
> variable is no longer needed.
>
> This patch fixes two race conditions:
> * Incrementing "depth" in lock() without holding a mutex.
> * Destroying a mutex from the main thread without waiting for the
>   worker threads to finish using that mutex.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  libmultipath/lock.h | 15 +--------------
>  multipathd/main.c   | 13 ++++++-------
>  2 files changed, 7 insertions(+), 21 deletions(-)
>
> diff --git a/libmultipath/lock.h b/libmultipath/lock.h
> index 9808480..a170efe 100644
> --- a/libmultipath/lock.h
> +++ b/libmultipath/lock.h
> @@ -3,35 +3,22 @@
>
>  #include <pthread.h>
>
> -/*
> - * Wrapper for the mutex. Includes a ref-count to keep
> - * track of how many there are out-standing threads blocking
> - * on a mutex. */
>  struct mutex_lock {
>         pthread_mutex_t mutex;
> -       int depth;
>  };
>
>  static inline void lock(struct mutex_lock *a)
>  {
> -       a->depth++;
>         pthread_mutex_lock(&a->mutex);
>  }
>
>  static inline int timedlock(struct mutex_lock *a, struct timespec *tmo)
>  {
> -       int r;
> -
> -       a->depth++;
> -       r = pthread_mutex_timedlock(&a->mutex, tmo);
> -       if (r)
> -               a->depth--;
> -       return r;
> +       return pthread_mutex_timedlock(&a->mutex, tmo);
>  }
>
>  static inline void unlock(struct mutex_lock *a)
>  {
> -       a->depth--;
>         pthread_mutex_unlock(&a->mutex);
>  }
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index fff482c..c288195 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2046,7 +2046,6 @@ init_vecs (void)
>                 return NULL;
>
>         pthread_mutex_init(&vecs->lock.mutex, NULL);
> -       vecs->lock.depth = 0;
>
>         return vecs;
>  }
> @@ -2394,16 +2393,16 @@ child (void * param)
>         pthread_cancel(uxlsnr_thr);
>         pthread_cancel(uevq_thr);
>
> +       pthread_join(check_thr, NULL);
> +       pthread_join(uevent_thr, NULL);
> +       pthread_join(uxlsnr_thr, NULL);
> +       pthread_join(uevq_thr, NULL);
> +
>         lock(&vecs->lock);
>         free_pathvec(vecs->pathvec, FREE_PATHS);
>         vecs->pathvec = NULL;
>         unlock(&vecs->lock);
> -       /* Now all the waitevent threads will start rushing in. */
> -       while (vecs->lock.depth > 0) {
> -               sleep (1); /* This is weak. */
> -               condlog(3, "Have %d wait event checkers threads to
> de-alloc,"
> -                       " waiting...", vecs->lock.depth);
> -       }
> +
>         pthread_mutex_destroy(&vecs->lock.mutex);
>         FREE(vecs);
>         vecs = NULL;
> --
> 2.9.2
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a113f37ccc8de5a053a4993b7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Bart-<div><br></div><div>Acked-by: <a href=3D"mailto:dr=
agan.stancevic@canonical.com">dragan.stancevic@canonical.com</a><br></div><=
div><br></div><div>I agree with your patch, I have been tracking an issue w=
here multipathd dumps core on the exit path just past the treads being canc=
eled. Your patch is very similar to mine (minus nuking the depth) that I wa=
s going to send out to a user to test with. The checker thread accesses a v=
alid pointer with garbage values....</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Aug 15, 2016 at 10:28 AM, Bart Van A=
ssche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" t=
arget=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">Use pthread_join() to wait until worker threads ha=
ve finished<br>
instead of using a counter to keep track of how many threads are<br>
trying to grab a mutex. Remove mutex_lock.depth since this member<br>
variable is no longer needed.<br>
<br>
This patch fixes two race conditions:<br>
* Incrementing &quot;depth&quot; in lock() without holding a mutex.<br>
* Destroying a mutex from the main thread without waiting for the<br>
=C2=A0 worker threads to finish using that mutex.<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/lock.h | 15 +--------------<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0| 13 ++++++-------<br>
=C2=A02 files changed, 7 insertions(+), 21 deletions(-)<br>
<br>
diff --git a/libmultipath/lock.h b/libmultipath/lock.h<br>
index 9808480..a170efe 100644<br>
--- a/libmultipath/lock.h<br>
+++ b/libmultipath/lock.h<br>
@@ -3,35 +3,22 @@<br>
<br>
=C2=A0#include &lt;pthread.h&gt;<br>
<br>
-/*<br>
- * Wrapper for the mutex. Includes a ref-count to keep<br>
- * track of how many there are out-standing threads blocking<br>
- * on a mutex. */<br>
=C2=A0struct mutex_lock {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_t mutex;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int depth;<br>
=C2=A0};<br>
<br>
=C2=A0static inline void lock(struct mutex_lock *a)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0a-&gt;depth++;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_lock(&amp;a-&gt;mutex);<br>
=C2=A0}<br>
<br>
=C2=A0static inline int timedlock(struct mutex_lock *a, struct timespec *tm=
o)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int r;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0a-&gt;depth++;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D pthread_mutex_timedlock(&amp;a-&gt;<wbr>m=
utex, tmo);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (r)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0a-&gt;depth--;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return pthread_mutex_timedlock(&amp;a-&gt;<wbr>=
mutex, tmo);<br>
=C2=A0}<br>
<br>
=C2=A0static inline void unlock(struct mutex_lock *a)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0a-&gt;depth--;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_unlock(&amp;a-&gt;<wbr>mutex);<br=
>
=C2=A0}<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index fff482c..c288195 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -2046,7 +2046,6 @@ init_vecs (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_init(&amp;vecs-&gt;<wbr>lock.mute=
x, NULL);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0vecs-&gt;lock.depth =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return vecs;<br>
=C2=A0}<br>
@@ -2394,16 +2393,16 @@ child (void * param)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_cancel(uxlsnr_thr);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_cancel(uevq_thr);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_join(check_thr, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_join(uevent_thr, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_join(uxlsnr_thr, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_join(uevq_thr, NULL);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 lock(&amp;vecs-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 free_pathvec(vecs-&gt;pathvec, FREE_PATHS);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vecs-&gt;pathvec =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unlock(&amp;vecs-&gt;lock);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Now all the waitevent threads will start rus=
hing in. */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0while (vecs-&gt;lock.depth &gt; 0) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sleep (1); /* This =
is weak. */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;Ha=
ve %d wait event checkers threads to de-alloc,&quot;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0&quot; waiting...&quot;, vecs-&gt;lock.depth);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_destroy(&amp;vecs-&gt;<wbr>lock.m=
utex);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(vecs);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vecs =3D NULL;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.9.2<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--001a113f37ccc8de5a053a4993b7--


--===============8021650317399159655==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8021650317399159655==--

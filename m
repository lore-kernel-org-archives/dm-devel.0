From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH V3] multipathd: release uxsocket and resource
 when cancel thread
Date: Tue, 16 Jan 2018 16:45:22 -0600
Message-ID: <20180116224522.GQ5638@octiron.msp.redhat.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342957D1C@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A342957D1C@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wuchongyun <wu.chongyun@h3c.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

On Tue, Jan 16, 2018 at 11:48:28AM +0000, Wuchongyun wrote:
> Hi Martin,
> Sorry to forget that, actually I found that dead_client() will not be int=
errupt by thread cancle, because after all dead_client() calling point be d=
one then handle_signals() have chance to be called by uxsock_listen() which=
 will call exit_daemon() and send =

> cancel threads signal to all child process include uxlsnr.
> But your comments is good can make code more safer. Below is the new patc=
h, please have a look, thanks.
> =


I have one small issue with this patch.

Since you are now closing ux_sock in uxsock_cleanup(), you should remove
the close(ux_sock) at the end of uxsock_listen(). pthread_cleanup_pop()
will already take care of that.

-Ben


> Issue description: we meet this issue: when multipathd initilaze and
> call uxsock_listen to create unix domain socket, but return -1 and
> the errno is 98 and then the uxsock_listen return null. After multipathd
> startup we can't receive any user's multipathd commands to finish the
> new multipath creation or any operations any more!
> =

> We found that uxlsnr thread's cleanup function not close the sockets
> also not release the clients when cancel thread, the domain socket
> will be release by the system. In any special environment like the
> machine's load is very heavy or any situations, the system may not close
> the old domain socket when we try to create and bind the new domain
> socket may return errno:98(Address already in use).
> =

> And also we make some experiments:
> in uxsock_cleanup if we close the ux_sock first and then immdediately
> call ux_socket_listen to create new ux_sock and initialization will be
> OK; if we don't close the ux_sock and call ux_socket_listen will return
> -1 and errno =3D 98.
> =

> So we believe that close uxsocket and release clients  when cancel
> thread can make sure of that new starting multipathd thread can
> create new uxsocket successfully, also can receive multipathd commands
> properly. And this path can fix clients' memory leak too.
> =

> Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
> ---
>  multipathd/uxlsnr.c |   29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> =

> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 98ac25a..c8065ea 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -102,14 +102,21 @@ static void new_client(int ux_sock)
>  /*
>   * kill off a dead client
>   */
> -static void dead_client(struct client *c)
> +static void _dead_client(struct client *c)
>  {
> -	pthread_mutex_lock(&client_lock);
> +	int fd =3D c->fd;
>  	list_del_init(&c->node);
> -	pthread_mutex_unlock(&client_lock);
> -	close(c->fd);
>  	c->fd =3D -1;
>  	FREE(c);
> +	close(fd);
> +}
> +
> +static void dead_client(struct client *c)
> +{
> +	pthread_cleanup_push(cleanup_lock, &client_lock);
> +	pthread_mutex_lock(&client_lock);
> +	_dead_client(c);
> +	pthread_cleanup_pop(1);
>  }
>  =

>  void free_polls (void)
> @@ -139,6 +146,18 @@ void check_timeout(struct timespec start_time, char =
*inbuf,
>  =

>  void uxsock_cleanup(void *arg)
>  {
> +	struct client *client_loop;
> +	struct client *client_tmp;
> +	int ux_sock =3D (int)arg;
> +
> +	pthread_mutex_lock(&client_lock);
> +	list_for_each_entry_safe(client_loop, client_tmp, &clients, node) {
> +		_dead_client(client_loop);
> +	}
> +	pthread_mutex_unlock(&client_lock);
> +
> +	close(ux_sock);
> +
>  	cli_exit();
>  	free_polls();
>  }
> @@ -162,7 +181,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger=
, void * trigger_data)
>  		return NULL;
>  	}
>  =

> -	pthread_cleanup_push(uxsock_cleanup, NULL);
> +	pthread_cleanup_push(uxsock_cleanup, (void *)ux_sock);
>  =

>  	condlog(3, "uxsock: startup listener");
>  	polls =3D (struct pollfd *)MALLOC((MIN_POLLS + 1) * sizeof(struct pollf=
d));
> -- =

> 1.7.9.5
> =

> =

> =

> -----original-----
> sender: Martin Wilck [mailto:mwilck@suse.com] =

> send time: 2018-01-15 22:11
> receiver: wuchongyun (Cloud) <wu.chongyun@h3c.com>; dm-devel@redhat.com
> cc: guozhonghua (Cloud) <guozhonghua@h3c.com>; gechangwei (Cloud) <ge.cha=
ngwei@h3c.com>
> subject: Re: [PATCH V3] multipathd: release uxsocket and resource when ca=
ncel thread
> =

> On Mon, 2018-01-15 at 12:09 +0000, Wuchongyun wrote:
> > Hi Martin,
> > Thank you for reply so quickly.  Below is the new patch according to =

> > your comments, please help to review this patch, thanks a lot~
> > =

> > =

> [...]
> =

> >   */
> > -static void dead_client(struct client *c)
> > +static void _dead_client(struct client *c)
> >  {
> > -	pthread_mutex_lock(&client_lock);
> >  	list_del_init(&c->node);
> > -	pthread_mutex_unlock(&client_lock);
> >  	close(c->fd);
> >  	c->fd =3D -1;
> >  	FREE(c);
> >  }
> =

> You may need to use pthread_cleanup_push() here for the unlock, because c=
lose() is a cancellation point.
> =

> Regards
> Martin
> =

> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107 SUSE Linux=
 GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton HRB 21284 (AG =
N=FCrnberg)
> =

> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

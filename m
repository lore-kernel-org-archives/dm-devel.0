From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: fix multipath -q command logic
Date: Tue, 11 Oct 2016 08:52:29 +0200
Message-ID: <CABr-GndYg_0cXdWWDMXtZt=0RjmJmT_hydSk-B7=d=QNWMPOqQ@mail.gmail.com>
References: <1471347138-12032-1-git-send-email-tang.junhui@zte.com.cn>
	<OF381EB462.38223C0B-ON48258049.0024FE75-48258049.00253123@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1934130100020176545=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF381EB462.38223C0B-ON48258049.0024FE75-48258049.00253123@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, zhang.kai16@zte.com.cn
List-Id: dm-devel.ids

--===============1934130100020176545==
Content-Type: multipart/alternative; boundary=001a11408126f69d44053e915125

--001a11408126f69d44053e915125
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hannes, Ben,

are you ok with the solution to these two issues.
Seems sane to me.

Thanks,
Christophe

On Tue, Oct 11, 2016 at 8:46 AM, <tang.junhui@zte.com.cn> wrote:

> Please have a review for this patch, any comment will be highly
> appreciated.
>
>
>
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA:         tang.junhui@zte.com.cn
> =E6=94=B6=E4=BB=B6=E4=BA=BA:         christophe varoqui <christophe.varoq=
ui@free.fr>,
> =E6=8A=84=E9=80=81:        dm-devel@redhat.com, zhang.kai16@zte.com.cn, "=
tang.junhui" <
> tang.junhui@zte.com.cn>
> =E6=97=A5=E6=9C=9F:         2016/08/16 19:33
> =E4=B8=BB=E9=A2=98:        [PATCH] libmultipath: fix multipath -q command=
 logic
> ------------------------------
>
>
>
> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> multipath judged whether multipathd service in running by check_daemon()
> when executing
> mutipath commands, check_daemon() try to connect to the multipathd servic=
e
> and execute
> "show dameon" command. The expected result is that the command will be
> failed when the
> service is not running, however, mpath_connect() will activate the
> multipathd service when
> the service is not running, so check_daemon() always return with true.
> Another problem is that
> multipath command with -q parameter is not processed in coalesce_paths().
> This patch fix for
> those two problems.
>
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
> libmultipath/configure.c | 85 +++++++++++++++++++++++++++---
> ------------------
> 1 file changed, 48 insertions(+), 37 deletions(-)
>
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 707e6be..d8a17a6 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -715,36 +715,36 @@ deadmap (struct multipath * mpp)
>                  return 1; /* dead */
> }
>
> -int check_daemon(void)
> +static int
> +check_daemon(void)
> {
>                  int fd;
> -                 char *reply;
> -                 int ret =3D 0;
> -                 unsigned int timeout;
> -                 struct config *conf;
> -
> -                 fd =3D mpath_connect();
> -                 if (fd =3D=3D -1)
> -                                  return 0;
> +                 struct flock lock;
>
> -                 if (send_packet(fd, "show daemon") !=3D 0)
> -                                  goto out;
> -                 conf =3D get_multipath_config();
> -                 timeout =3D conf->uxsock_timeout;
> -                 put_multipath_config(conf);
> -                 if (recv_packet(fd, &reply, timeout) !=3D 0)
> -                                  goto out;
> -
> -                 if (strstr(reply, "shutdown"))
> -                                  goto out_free;
> -
> -                 ret =3D 1;
> +                 fd =3D open(DEFAULT_PIDFILE, O_RDONLY);
> +                 if (fd < 0) {
> +                                  if (errno =3D=3D ENOENT)
> +                                                   return 0;
> +                                  if (errno =3D=3D EMFILE)
> +                                                   condlog(0, "failed to
> open file, increase max_fds at %s", DEFAULT_CONFIGFILE);
> +                                  else
> +                                                   condlog(0, "can not
> open pidfile %s: %s", DEFAULT_PIDFILE, strerror(errno));
> +                                  return -1;
> +                 }
>
> -out_free:
> -                 FREE(reply);
> -out:
> -                 mpath_disconnect(fd);
> -                 return ret;
> +                 lock.l_type =3D F_WRLCK;
> +                 lock.l_start =3D 0;
> +                 lock.l_whence =3D SEEK_SET;
> +                 lock.l_len =3D 0;
> +                 if (fcntl(fd, F_GETLK, &lock) < 0) {
> +                                  condlog(0, "can not get file locker,
> %s: %s", DEFAULT_PIDFILE, strerror(errno));
> +                                  close(fd);
> +                                  return -1;
> +                 }
> +                 close(fd);
> +                 if (lock.l_type =3D=3D F_UNLCK)
> +                                  return 0;
> +                 return 1;
> }
>
> extern int
> @@ -873,17 +873,28 @@ coalesce_paths (struct vectors * vecs, vector newmp=
,
> char * refwwid, int force_r
>                                   if (r =3D=3D DOMAP_DRY)
>                                                    continue;
>
> -                                  conf =3D get_multipath_config();
> -                                  allow_queueing =3D conf->allow_queuein=
g;
> -                                  put_multipath_config(conf);
> -                                  if (!is_daemon && !allow_queueing &&
> !check_daemon()) {
> -                                                   if (mpp->no_path_retr=
y
> !=3D NO_PATH_RETRY_UNDEF &&
> -                                                       mpp->no_path_retr=
y
> !=3D NO_PATH_RETRY_FAIL)
> -
>  condlog(3, "%s: multipathd not running, unset "
> -
>             "queue_if_no_path feature", mpp->alias);
> -                                                   if
> (!dm_queue_if_no_path(mpp->alias, 0))
> -
>  remove_feature(&mpp->features,
> -
>                    "queue_if_no_path");
> +                                  /* run as multipath command and the
> service is not running */
> +                                  if (!is_daemon && !check_daemon()) {
> +                                                   conf =3D
> get_multipath_config();
> +                                                   allow_queueing =3D
> conf->allow_queueing;
> +
> put_multipath_config(conf);
> +                                                   /* no -q choice */
> +                                                   if (!allow_queueing) =
{
> +                                                                    if
> (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF &&
> +
>             mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL)
> +
>             condlog(3, "%s: multipathd not running, unset "
> +
>                              "queue_if_no_path feature", mpp->alias);
> +                                                                    if
> (!dm_queue_if_no_path(mpp->alias, 0))
> +
>             remove_feature(&mpp->features,
> +
>                                               "queue_if_no_path");
> +                                                   } else { /* with -q
> choice */
> +                                                                    if
> (mpp->no_path_retry =3D=3D NO_PATH_RETRY_UNDEF ||
> +
>             mpp->no_path_retry =3D=3D NO_PATH_RETRY_FAIL)
> +
>             condlog(3, "%s: multipathd not running, set "
> +
>                              "queue_if_no_path feature", mpp->alias);
> +                                                                    if
> (!dm_queue_if_no_path(mpp->alias, 1))
> +
>             add_feature(&mpp->features, "queue_if_no_path");
> +                                                   }
>                                   }
>                                   else if (mpp->no_path_retry !=3D
> NO_PATH_RETRY_UNDEF) {
>                                                    if (mpp->no_path_retry
> =3D=3D NO_PATH_RETRY_FAIL) {
> --
> 2.8.1.windows.1
>
>
>

--001a11408126f69d44053e915125
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+SGFubmVzLCBCZW4sPGRpdj48YnI+PC9kaXY+PGRpdj5hcmUgeW91IG9r
IHdpdGggdGhlIHNvbHV0aW9uIHRvIHRoZXNlIHR3byBpc3N1ZXMuPC9kaXY+PGRpdj5TZWVtcyBz
YW5lIHRvIG1lLjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+VGhhbmtzLDwvZGl2PjxkaXY+Q2hy
aXN0b3BoZTwvZGl2PjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2V4dHJhIj48YnI+PGRpdiBjbGFz
cz0iZ21haWxfcXVvdGUiPk9uIFR1ZSwgT2N0IDExLCAyMDE2IGF0IDg6NDYgQU0sICA8c3BhbiBk
aXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzp0YW5nLmp1bmh1aUB6dGUuY29tLmNuIiB0YXJn
ZXQ9Il9ibGFuayI+dGFuZy5qdW5odWlAenRlLmNvbS5jbjwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8
YnI+PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44
ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+PGZvbnQgc2l6
ZT0iMiI+UGxlYXNlIGhhdmUgYSByZXZpZXc8L2ZvbnQ+PGZvbnQgc2l6ZT0iMiIgZmFjZT0ic2Fu
cy1zZXJpZiI+DQpmb3IgdGhpcyBwYXRjaCwgYW55IGNvbW1lbnQgd2lsbCBiZSBoaWdobHkgYXBw
cmVjaWF0ZWQuPC9mb250Pjxmb250IHNpemU9IjIiIGZhY2U9InNhbnMtc2VyaWYiPjxicj4NCjwv
Zm9udD4NCjxicj4NCjxicj4NCjxicj4NCjxicj48Zm9udCBzaXplPSIxIiBjb2xvcj0iIzVmNWY1
ZiIgZmFjZT0ic2Fucy1zZXJpZiI+5Y+R5Lu25Lq6OiDCoCDCoA0KwqAgwqAgPC9mb250Pjxmb250
IHNpemU9IjEiIGZhY2U9InNhbnMtc2VyaWYiPjxhIGhyZWY9Im1haWx0bzp0YW5nLmp1bmh1aUB6
dGUuY29tLmNuIiB0YXJnZXQ9Il9ibGFuayI+dGFuZy5qdW5odWlAenRlLmNvbS5jbjwvYT48L2Zv
bnQ+DQo8YnI+PGZvbnQgc2l6ZT0iMSIgY29sb3I9IiM1ZjVmNWYiIGZhY2U9InNhbnMtc2VyaWYi
PuaUtuS7tuS6ujogwqAgwqANCsKgIMKgIDwvZm9udD48Zm9udCBzaXplPSIxIiBmYWNlPSJzYW5z
LXNlcmlmIj5jaHJpc3RvcGhlDQp2YXJvcXVpICZsdDs8YSBocmVmPSJtYWlsdG86Y2hyaXN0b3Bo
ZS52YXJvcXVpQGZyZWUuZnIiIHRhcmdldD0iX2JsYW5rIj5jaHJpc3RvcGhlLnZhcm9xdWlAZnJl
ZS5mcjwvYT4mZ3Q7LCA8L2ZvbnQ+DQo8YnI+PGZvbnQgc2l6ZT0iMSIgY29sb3I9IiM1ZjVmNWYi
IGZhY2U9InNhbnMtc2VyaWYiPuaKhOmAgTogwqAgwqANCsKgIMKgPC9mb250Pjxmb250IHNpemU9
IjEiIGZhY2U9InNhbnMtc2VyaWYiPjxhIGhyZWY9Im1haWx0bzpkbS1kZXZlbEByZWRoYXQuY29t
IiB0YXJnZXQ9Il9ibGFuayI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT4sDQo8YSBocmVmPSJtYWls
dG86emhhbmcua2FpMTZAenRlLmNvbS5jbiIgdGFyZ2V0PSJfYmxhbmsiPnpoYW5nLmthaTE2QHp0
ZS5jb20uY248L2E+LCAmcXVvdDt0YW5nLmp1bmh1aSZxdW90OyAmbHQ7PGEgaHJlZj0ibWFpbHRv
OnRhbmcuanVuaHVpQHp0ZS5jb20uY24iIHRhcmdldD0iX2JsYW5rIj50YW5nLmp1bmh1aUB6dGUu
Y29tLmNuPC9hPiZndDs8L2ZvbnQ+DQo8YnI+PGZvbnQgc2l6ZT0iMSIgY29sb3I9IiM1ZjVmNWYi
IGZhY2U9InNhbnMtc2VyaWYiPuaXpeacnzogwqAgwqANCsKgIMKgIDwvZm9udD48Zm9udCBzaXpl
PSIxIiBmYWNlPSJzYW5zLXNlcmlmIj4yMDE2LzA4LzE2DQoxOTozMzwvZm9udD4NCjxicj48Zm9u
dCBzaXplPSIxIiBjb2xvcj0iIzVmNWY1ZiIgZmFjZT0ic2Fucy1zZXJpZiI+5Li76aKYOiDCoCDC
oA0KwqAgwqA8L2ZvbnQ+PGZvbnQgc2l6ZT0iMSIgZmFjZT0ic2Fucy1zZXJpZiI+W1BBVENIXSBs
aWJtdWx0aXBhdGg6DQpmaXggbXVsdGlwYXRoIC1xIGNvbW1hbmQgbG9naWM8L2ZvbnQ+DQo8YnI+
DQo8aHIgbm9zaGFkZT48ZGl2IGNsYXNzPSJIT0VuWmIiPjxkaXYgY2xhc3M9Img1Ij4NCjxicj4N
Cjxicj4NCjxicj48dHQ+PGZvbnQgc2l6ZT0iMiI+RnJvbTogJnF1b3Q7dGFuZy5qdW5odWkmcXVv
dDsgJmx0OzxhIGhyZWY9Im1haWx0bzp0YW5nLmp1bmh1aUB6dGUuY29tLmNuIiB0YXJnZXQ9Il9i
bGFuayI+dGFuZy5qdW5odWlAenRlLmNvbS5jbjwvYT4mZ3Q7PGJyPg0KPGJyPg0KbXVsdGlwYXRo
IGp1ZGdlZCB3aGV0aGVyIG11bHRpcGF0aGQgc2VydmljZSBpbiBydW5uaW5nIGJ5IGNoZWNrX2Rh
ZW1vbigpDQp3aGVuIGV4ZWN1dGluZzxicj4NCm11dGlwYXRoIGNvbW1hbmRzLCBjaGVja19kYWVt
b24oKSB0cnkgdG8gY29ubmVjdCB0byB0aGUgbXVsdGlwYXRoZCBzZXJ2aWNlDQphbmQgZXhlY3V0
ZTxicj4NCiZxdW90O3Nob3cgZGFtZW9uJnF1b3Q7IGNvbW1hbmQuIFRoZSBleHBlY3RlZCByZXN1
bHQgaXMgdGhhdCB0aGUgY29tbWFuZA0Kd2lsbCBiZSBmYWlsZWQgd2hlbiB0aGU8YnI+DQpzZXJ2
aWNlIGlzIG5vdCBydW5uaW5nLCBob3dldmVyLCBtcGF0aF9jb25uZWN0KCkgd2lsbCBhY3RpdmF0
ZSB0aGUgbXVsdGlwYXRoZA0Kc2VydmljZSB3aGVuPGJyPg0KdGhlIHNlcnZpY2UgaXMgbm90IHJ1
bm5pbmcsIHNvIGNoZWNrX2RhZW1vbigpIGFsd2F5cyByZXR1cm4gd2l0aCB0cnVlLg0KQW5vdGhl
ciBwcm9ibGVtIGlzIHRoYXQ8YnI+DQptdWx0aXBhdGggY29tbWFuZCB3aXRoIC1xIHBhcmFtZXRl
ciBpcyBub3QgcHJvY2Vzc2VkIGluIGNvYWxlc2NlX3BhdGhzKCkuDQpUaGlzIHBhdGNoIGZpeCBm
b3I8YnI+DQp0aG9zZSB0d28gcHJvYmxlbXMuPGJyPg0KPGJyPg0KU2lnbmVkLW9mZi1ieTogdGFu
Zy5qdW5odWkgJmx0OzxhIGhyZWY9Im1haWx0bzp0YW5nLmp1bmh1aUB6dGUuY29tLmNuIiB0YXJn
ZXQ9Il9ibGFuayI+dGFuZy5qdW5odWlAenRlLmNvbS5jbjwvYT4mZ3Q7PGJyPg0KLS0tPGJyPg0K
IGxpYm11bHRpcGF0aC9jb25maWd1cmUuYyB8IDg1ICsrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLTx3YnI+LS0tLS0tLS0tLS0tLS0tLS0tPGJyPg0KIDEgZmlsZSBjaGFuZ2VkLCA0OCBpbnNl
cnRpb25zKCspLCAzNyBkZWxldGlvbnMoLSk8YnI+DQo8YnI+DQpkaWZmIC0tZ2l0IGEvbGlibXVs
dGlwYXRoL2NvbmZpZ3VyZS5jIGIvbGlibXVsdGlwYXRoL2NvbmZpZ3VyZS5jPGJyPg0KaW5kZXgg
NzA3ZTZiZS4uZDhhMTdhNiAxMDA2NDQ8YnI+DQotLS0gYS9saWJtdWx0aXBhdGgvY29uZmlndXJl
LmM8YnI+DQorKysgYi9saWJtdWx0aXBhdGgvY29uZmlndXJlLmM8YnI+DQpAQCAtNzE1LDM2ICs3
MTUsMzYgQEAgZGVhZG1hcCAoc3RydWN0IG11bHRpcGF0aCAqIG1wcCk8YnI+DQogwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqByZXR1cm4NCjE7IC8qIGRlYWQgKi88YnI+DQogfTxicj4NCiA8YnI+
DQotaW50IGNoZWNrX2RhZW1vbih2b2lkKTxicj4NCitzdGF0aWMgaW50PGJyPg0KK2NoZWNrX2Rh
ZW1vbih2b2lkKTxicj4NCiB7PGJyPg0KIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaW50DQpm
ZDs8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQpjaGFyICpyZXBseTs8YnI+DQotIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgDQppbnQgcmV0ID0gMDs8YnI+DQotIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgDQp1bnNpZ25lZCBpbnQgdGltZW91dDs8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgDQpzdHJ1Y3QgY29uZmlnICpjb25mOzxicj4NCi08YnI+DQotIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgDQpmZCA9IG1wYXRoX2Nvbm5lY3QoKTs8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgDQppZiAoZmQgPT0gLTEpPGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4NCjA7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoA0Kc3RydWN0IGZsb2NrIGxvY2s7PGJyPg0KIDxicj4NCi0gwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqANCmlmIChzZW5kX3BhY2tldChmZCwgJnF1b3Q7c2hvdyBkYWVtb24mcXVvdDspICE9
IDApPGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBnb3RvDQpvdXQ7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KY29uZiA9IGdl
dF9tdWx0aXBhdGhfY29uZmlnKCk7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KdGlt
ZW91dCA9IGNvbmYtJmd0O3V4c29ja190aW1lb3V0Ozxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqANCnB1dF9tdWx0aXBhdGhfY29uZmlnKGNvbmYpOzxicj4NCi0gwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqANCmlmIChyZWN2X3BhY2tldChmZCwgJmFtcDtyZXBseSwgdGltZW91dCkgIT0gMCk8
YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oGdvdG8NCm91dDs8YnI+DQotPGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KaWYgKHN0
cnN0cihyZXBseSwgJnF1b3Q7c2h1dGRvd24mcXVvdDspKTxicj4NCi0gwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ290bw0Kb3V0X2ZyZWU7PGJyPg0K
LTxicj4NCi0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCnJldCA9IDE7PGJyPg0KKyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoA0KZmQgPSBvcGVuKERFRkFVTFRfUElERklMRSwgT19SRE9OTFkpOzxi
cj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCmlmIChmZCAmbHQ7IDApIHs8YnI+DQorIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmDQooZXJy
bm8gPT0gRU5PRU5UKTxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KcmV0dXJuIDA7PGJyPg0K
KyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZg0K
KGVycm5vID09IEVNRklMRSk8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCmNvbmRsb2coMCwg
JnF1b3Q7ZmFpbGVkIHRvIG9wZW4gZmlsZSwgaW5jcmVhc2UgbWF4X2ZkcyBhdCAlcyZxdW90Oywg
REVGQVVMVF9DT05GSUdGSUxFKTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoGVsc2U8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCmNv
bmRsb2coMCwgJnF1b3Q7Y2FuIG5vdCBvcGVuIHBpZGZpbGUgJXM6ICVzJnF1b3Q7LCBERUZBVUxU
X1BJREZJTEUsIHN0cmVycm9yKGVycm5vKSk7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4NCi0xOzxicj4NCisgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqANCn08YnI+DQogPGJyPg0KLW91dF9mcmVlOjxicj4NCi0gwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqANCkZSRUUocmVwbHkpOzxicj4NCi1vdXQ6PGJyPg0KLSDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoA0KbXBhdGhfZGlzY29ubmVjdChmZCk7PGJyPg0KLSDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoA0KcmV0dXJuIHJldDs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQps
b2NrLmxfdHlwZSA9IEZfV1JMQ0s7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KbG9j
ay5sX3N0YXJ0ID0gMDs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQpsb2NrLmxfd2hl
bmNlID0gU0VFS19TRVQ7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KbG9jay5sX2xl
biA9IDA7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KaWYgKGZjbnRsKGZkLCBGX0dF
VExLLCAmYW1wO2xvY2spICZsdDsgMCkgezxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAN
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygwLA0KJnF1b3Q7Y2FuIG5vdCBnZXQg
ZmlsZSBsb2NrZXIsICVzOiAlcyZxdW90OywgREVGQVVMVF9QSURGSUxFLCBzdHJlcnJvcihlcnJu
bykpOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgY2xvc2UoZmQpOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuDQotMTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgDQp9PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KY2xvc2UoZmQpOzxicj4NCisg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCmlmIChsb2NrLmxfdHlwZSA9PSBGX1VOTENLKTxicj4N
CisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0
dXJuDQowOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCnJldHVybiAxOzxicj4NCiB9
PGJyPg0KIDxicj4NCiBleHRlcm4gaW50PGJyPg0KQEAgLTg3MywxNyArODczLDI4IEBAIGNvYWxl
c2NlX3BhdGhzIChzdHJ1Y3QgdmVjdG9ycyAqIHZlY3MsIHZlY3RvciBuZXdtcCwNCmNoYXIgKiBy
ZWZ3d2lkLCBpbnQgZm9yY2Vfcjxicj4NCiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqANCmlmIChyID09IERPTUFQX0RSWSk8YnI+DQogwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoGNvbnRpbnVlOzxicj4NCiA8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmYNCj0gZ2V0X211bHRpcGF0aF9jb25m
aWcoKTs8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoGFsbG93X3F1ZXVlaW5nDQo9IGNvbmYtJmd0O2FsbG93X3F1ZXVlaW5nOzxicj4NCi0g
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHV0X211
bHRpcGF0aF9jb25maWcoY29uZik7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZg0KKCFpc19kYWVtb24gJmFtcDsmYW1wOyAhYWxsb3df
cXVldWVpbmcgJmFtcDsmYW1wOyAhY2hlY2tfZGFlbW9uKCkpIHs8YnI+DQotIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqANCmlmIChtcHAtJmd0O25vX3BhdGhfcmV0cnkgIT0gTk9fUEFUSF9SRVRSWV9VTkRF
RiAmYW1wOyZhbXA7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCBtcHAtJmd0O25v
X3BhdGhfcmV0cnkgIT0gTk9fUEFUSF9SRVRSWV9GQUlMKTxicj4NCi0gwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsDQomcXVvdDslczogbXVs
dGlwYXRoZCBub3QgcnVubmluZywgdW5zZXQgJnF1b3Q7PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAN
CiZxdW90O3F1ZXVlX2lmX25vX3BhdGggZmVhdHVyZSZxdW90OywgbXBwLSZndDthbGlhcyk7PGJy
Pg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAN
CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQppZiAoIWRtX3F1ZXVlX2lmX25vX3BhdGgobXBwLSZn
dDs8d2JyPmFsaWFzLCAwKSk8YnI+DQotIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgcmVtb3ZlX2ZlYXR1cmUoJmFtcDttcHAtJmd0Ozx3YnI+ZmVhdHVyZXMs
PGJyPg0KLSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgJnF1b3Q7cXVldWVfaWZfbm9fcGF0
aCZxdW90Oyk7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAvKg0KcnVuIGFzIG11bHRpcGF0aCBjb21tYW5kIGFuZCB0aGUgc2VydmljZSBp
cyBub3QgcnVubmluZyAqLzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgaWYNCighaXNfZGFlbW9uICZhbXA7JmFtcDsgIWNoZWNrX2RhZW1v
bigpKSB7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQpjb25mID0gZ2V0X211bHRpcGF0aF9j
b25maWcoKTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCmFsbG93X3F1ZXVlaW5nID0gY29u
Zi0mZ3Q7YWxsb3dfcXVldWVpbmc7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQpwdXRfbXVs
dGlwYXRoX2NvbmZpZyhjb25mKTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCi8qIG5vIC1x
IGNob2ljZSAqLzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KaWYgKCFhbGxvd19xdWV1ZWlu
Zykgezxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBpZg0KKG1wcC0mZ3Q7bm9fcGF0aF9yZXRyeSAhPSBOT19QQVRIX1JFVFJZX1VOREVGICZhbXA7
JmFtcDs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KbXBwLSZndDtub19wYXRoX3JldHJ5ICE9IE5P
X1BBVEhfUkVUUllfRkFJTCk8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KY29uZGxvZygzLCAmcXVv
dDslczogbXVsdGlwYXRoZCBub3QgcnVubmluZywgdW5zZXQgJnF1b3Q7PGJyPg0KKyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7cXVldWVfaWZfbm9fcGF0
aA0KZmVhdHVyZSZxdW90OywgbXBwLSZndDthbGlhcyk7PGJyPg0KKyDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmDQooIWRtX3F1ZXVlX2lmX25vX3BhdGgo
bXBwLSZndDs8d2JyPmFsaWFzLCAwKSk8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KcmVtb3ZlX2Zl
YXR1cmUoJmFtcDttcHAtJmd0O2ZlYXR1cmVzLDxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCiZxdW90O3F1
ZXVlX2lmX25vX3BhdGgmcXVvdDspOzxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KfSBlbHNl
IHsgLyogd2l0aCAtcSBjaG9pY2UgKi88YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYNCihtcHAtJmd0O25vX3BhdGhfcmV0cnkgPT0gTk9fUEFU
SF9SRVRSWV9VTkRFRiB8fDxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQptcHAtJmd0O25vX3BhdGhf
cmV0cnkgPT0gTk9fUEFUSF9SRVRSWV9GQUlMKTxicj4NCisgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQpjb25k
bG9nKDMsICZxdW90OyVzOiBtdWx0aXBhdGhkIG5vdCBydW5uaW5nLCBzZXQgJnF1b3Q7PGJyPg0K
KyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7cXVldWVf
aWZfbm9fcGF0aA0KZmVhdHVyZSZxdW90OywgbXBwLSZndDthbGlhcyk7PGJyPg0KKyDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmDQooIWRtX3F1ZXVlX2lm
X25vX3BhdGgobXBwLSZndDs8d2JyPmFsaWFzLCAxKSk8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0K
YWRkX2ZlYXR1cmUoJmFtcDttcHAtJmd0O2ZlYXR1cmVzLCAmcXVvdDtxdWV1ZV9pZl9ub19wYXRo
JnF1b3Q7KTs8YnI+DQorIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoA0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqANCn08YnI+DQogwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQp9PGJyPg0KIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoA0KZWxzZSBpZiAobXBw
LSZndDtub19wYXRoX3JldHJ5ICE9IE5PX1BBVEhfUkVUUllfVU5ERUYpIHs8YnI+DQogwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqANCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgDQrCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoGlmDQoobXBwLSZndDtub19wYXRoX3JldHJ5ID09IE5PX1BBVEhfUkVU
UllfRkFJTCkgezxicj4NCi0tIDxicj4NCjIuOC4xLndpbmRvd3MuMTxicj4NCjxicj4NCjwvZm9u
dD48L3R0Pg0KPGJyPg0KPC9kaXY+PC9kaXY+PC9ibG9ja3F1b3RlPjwvZGl2Pjxicj48L2Rpdj4N
Cg==
--001a11408126f69d44053e915125--


--===============1934130100020176545==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1934130100020176545==--

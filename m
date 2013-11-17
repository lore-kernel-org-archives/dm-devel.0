From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 04/13] libmultipath: return error numbers
	from sysfs_get_XXX
Date: Sun, 17 Nov 2013 18:34:53 +0100
Message-ID: <CABr-Gndi_0r_2f4KNArkc9pOUvr=N51L55xQJzh5zLLo+umpeQ@mail.gmail.com>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
	<1384511384-27642-5-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8077019151013877451=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-5-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============8077019151013877451==
Content-Type: multipart/alternative; boundary=047d7b2e76046944cb04eb62d9e1

--047d7b2e76046944cb04eb62d9e1
Content-Type: text/plain; charset=ISO-8859-1

 declare_sysfs_get_str(devtype);
-declare_sysfs_get_str(cutype);
 declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);

This part seems correct, as this function is not used anywhere, but
orthogonal to the patch.
Can you confirm this slip is safe ?

Best regards,
Christophe Varoqui
www.opensvc.com



On Fri, Nov 15, 2013 at 11:29 AM, Hannes Reinecke <hare@suse.de> wrote:

> Instead of returning hand-crafted error values from sysfs_get_XXX
> functions we should be using the standard error numbers.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/discovery.c   | 40 +++++++++++++++++++++-------------------
>  libmultipath/discovery.h   |  2 +-
>  libmultipath/propsel.c     |  2 +-
>  libmultipath/structs_vec.c |  3 +--
>  4 files changed, 24 insertions(+), 23 deletions(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 3292358..d5557d9 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -140,31 +140,34 @@ path_discovery (vector pathvec, struct config *
> conf, int flag)
>  }
>
>  #define declare_sysfs_get_str(fname)                                   \
> -extern int                                                             \
> +extern ssize_t                                                         \
>  sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len) \
>  {                                                                      \
> +       ssize_t ret;                                                    \
>         const char * attr;                                              \
>         const char * devname;                                           \
>                                                                         \
> +       if (!udev)                                                      \
> +               return -ENOSYS;                                         \
> +                                                                       \
>         devname = udev_device_get_sysname(udev);                        \
>                                                                         \
>         attr = udev_device_get_sysattr_value(udev, #fname);             \
>         if (!attr) {                                                    \
>                 condlog(3, "%s: attribute %s not found in sysfs",       \
>                         devname, #fname);                               \
> -               return 1;                                               \
> +               return -ENXIO;                                          \
>         }                                                               \
>         if (strlen(attr) > len) {                                       \
>                 condlog(3, "%s: overflow in attribute %s",              \
>                         devname, #fname);                               \
> -               return 2;                                               \
> +               return -EINVAL;                                         \
>         }                                                               \
> -       strlcpy(buff, attr, len);                                       \
> -       return 0;                                                       \
> +       ret = strlcpy(buff, attr, len);                                 \
> +       return ret;                                                     \
>  }
>
>  declare_sysfs_get_str(devtype);
> -declare_sysfs_get_str(cutype);
>  declare_sysfs_get_str(vendor);
>  declare_sysfs_get_str(model);
>  declare_sysfs_get_str(rev);
> @@ -180,7 +183,7 @@ sysfs_get_timeout(struct path *pp, unsigned int
> *timeout)
>         unsigned int t;
>
>         if (!pp->udev || pp->bus != SYSFS_BUS_SCSI)
> -               return 1;
> +               return -ENOSYS;
>
>         parent = pp->udev;
>         while (parent) {
> @@ -192,7 +195,7 @@ sysfs_get_timeout(struct path *pp, unsigned int
> *timeout)
>         }
>         if (!attr) {
>                 condlog(3, "%s: No timeout value in sysfs", pp->dev);
> -               return 1;
> +               return -ENXIO;
>         }
>
>         r = sscanf(attr, "%u\n", &t);
> @@ -200,7 +203,7 @@ sysfs_get_timeout(struct path *pp, unsigned int
> *timeout)
>         if (r != 1) {
>                 condlog(3, "%s: Cannot parse timeout attribute '%s'",
>                         pp->dev, attr);
> -               return 1;
> +               return -EINVAL;
>         }
>
>         *timeout = t;
> @@ -650,17 +653,17 @@ scsi_sysfs_pathinfo (struct path * pp)
>         if (!attr_path || pp->sg_id.host_no == -1)
>                 return 1;
>
> -       if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE))
> +       if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) <= 0)
>                 return 1;
>
>         condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
>
> -       if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE))
> +       if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE) <=
> 0)
>                 return 1;
>
>         condlog(3, "%s: product = %s", pp->dev, pp->product_id);
>
> -       if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE))
> +       if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) <= 0)
>                 return 1;
>
>         condlog(3, "%s: rev = %s", pp->dev, pp->rev);
> @@ -712,7 +715,7 @@ ccw_sysfs_pathinfo (struct path * pp)
>
>         condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
>
> -       if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE))
> +       if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE) <= 0)
>                 return 1;
>
>         if (!strncmp(attr_buff, "3370", 4)) {
> @@ -772,17 +775,17 @@ cciss_sysfs_pathinfo (struct path * pp)
>         if (!attr_path || pp->sg_id.host_no == -1)
>                 return 1;
>
> -       if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE))
> +       if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) <= 0)
>                 return 1;
>
>         condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
>
> -       if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE))
> +       if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE) <=
> 0)
>                 return 1;
>
>         condlog(3, "%s: product = %s", pp->dev, pp->product_id);
>
> -       if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE))
> +       if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) <= 0)
>                 return 1;
>
>         condlog(3, "%s: rev = %s", pp->dev, pp->rev);
> @@ -816,7 +819,7 @@ common_sysfs_pathinfo (struct path * pp)
>                 condlog(4, "%s: udev not initialised", pp->dev);
>                 return 1;
>         }
> -       if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE)) {
> +       if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE) <= 0) {
>                 condlog(3, "%s: no 'dev' attribute in sysfs", pp->dev);
>                 return 1;
>         }
> @@ -956,8 +959,7 @@ get_state (struct path * pp, int daemon)
>         if (daemon)
>                 checker_set_async(c);
>         if (!conf->checker_timeout &&
> -           (pp->bus != SYSFS_BUS_SCSI ||
> -            sysfs_get_timeout(pp, &(c->timeout))))
> +           sysfs_get_timeout(pp, &(c->timeout)) <= 0)
>                 c->timeout = DEF_TIMEOUT;
>         state = checker_check(c);
>         condlog(3, "%s: state = %s", pp->dev, checker_state_name(state));
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> index d049ead..3d2d0ce 100644
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -26,7 +26,7 @@
>
>  struct config;
>
> -int sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);
> +ssize_t sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);
>  int path_discovery (vector pathvec, struct config * conf, int flag);
>
>  int do_tur (char *);
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index e47d0ca..f092227 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -351,7 +351,7 @@ out:
>                 condlog(3, "%s: checker timeout = %u s (config file
> default)",
>                                 pp->dev, c->timeout);
>         }
> -       else if (pp->udev && sysfs_get_timeout(pp, &c->timeout) == 0)
> +       else if (sysfs_get_timeout(pp, &c->timeout) > 0)
>                 condlog(3, "%s: checker timeout = %u ms (sysfs setting)",
>                                 pp->dev, c->timeout);
>         else {
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 14ea1c7..abb2c56 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -451,8 +451,7 @@ verify_paths(struct multipath * mpp, struct vectors *
> vecs, vector rpvec)
>                 /*
>                  * see if path is in sysfs
>                  */
> -               if (!pp->udev || sysfs_get_dev(pp->udev, pp->dev_t,
> -                                              BLK_DEV_SIZE)) {
> +               if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE) <= 0)
> {
>                         if (pp->state != PATH_DOWN) {
>                                 condlog(1, "%s: removing valid path %s in
> state %d",
>                                         mpp->alias, pp->dev, pp->state);
> --
> 1.8.1.4
>
>

--047d7b2e76046944cb04eb62d9e1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-family:arial,sans-serif;font-size:12.8=
00000190734863px">=A0declare_sysfs_get_str(devtype)</span><span style=3D"fo=
nt-family:arial,sans-serif;font-size:12.800000190734863px">;</span><br styl=
e=3D"font-family:arial,sans-serif;font-size:12.800000190734863px">
<span style=3D"font-family:arial,sans-serif;font-size:12.800000190734863px"=
>-declare_sysfs_get_str(cutype)</span><span style=3D"font-family:arial,sans=
-serif;font-size:12.800000190734863px">;</span><br style=3D"font-family:ari=
al,sans-serif;font-size:12.800000190734863px">
<span style=3D"font-family:arial,sans-serif;font-size:12.800000190734863px"=
>=A0declare_sysfs_get_str(vendor);</span><br style=3D"font-family:arial,san=
s-serif;font-size:12.800000190734863px"><span style=3D"font-family:arial,sa=
ns-serif;font-size:12.800000190734863px">=A0declare_sysfs_get_str(model);</=
span><br style=3D"font-family:arial,sans-serif;font-size:12.800000190734863=
px">
<span style=3D"font-family:arial,sans-serif;font-size:12.800000190734863px"=
>=A0declare_sysfs_get_str(rev);</span><br style=3D"font-family:arial,sans-s=
erif;font-size:12.800000190734863px"><div><span style=3D"font-family:arial,=
sans-serif;font-size:12.800000190734863px"><br>
</span></div><div style><span style=3D"font-family:arial,sans-serif;font-si=
ze:12.800000190734863px">This part seems correct, as this function is not u=
sed anywhere, but orthogonal to the patch.</span></div><div style><span sty=
le=3D"font-family:arial,sans-serif;font-size:12.800000190734863px">Can you =
confirm this slip is safe ?</span></div>
<div style><span style=3D"font-family:arial,sans-serif;font-size:12.8000001=
90734863px"><br></span></div><div style><span style=3D"font-family:arial,sa=
ns-serif;font-size:12.800000190734863px">Best regards,</span></div><div sty=
le>
<span style=3D"font-family:arial,sans-serif;font-size:12.800000190734863px"=
>Christophe Varoqui</span></div><div style><font face=3D"arial, sans-serif"=
><a href=3D"http://www.opensvc.com">www.opensvc.com</a></font></div><div st=
yle>
<font face=3D"arial, sans-serif"><br></font></div></div><div class=3D"gmail=
_extra"><br><br><div class=3D"gmail_quote">On Fri, Nov 15, 2013 at 11:29 AM=
, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" tar=
get=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Instead of returning hand-crafted error valu=
es from sysfs_get_XXX<br>
functions we should be using the standard error numbers.<br>
<br>
Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@sus=
e.de</a>&gt;<br>
---<br>
=A0libmultipath/discovery.c =A0 | 40 +++++++++++++++++++++-----------------=
--<br>
=A0libmultipath/discovery.h =A0 | =A02 +-<br>
=A0libmultipath/propsel.c =A0 =A0 | =A02 +-<br>
=A0libmultipath/structs_vec.c | =A03 +--<br>
=A04 files changed, 24 insertions(+), 23 deletions(-)<br>
<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index 3292358..d5557d9 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -140,31 +140,34 @@ path_discovery (vector pathvec, struct config * conf,=
 int flag)<br>
=A0}<br>
<br>
=A0#define declare_sysfs_get_str(fname) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
-extern int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
+extern ssize_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len) \=
<br>
=A0{ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\<br=
>
+ =A0 =A0 =A0 ssize_t ret; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\<br>
=A0 =A0 =A0 =A0 const char * attr; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\<br>
=A0 =A0 =A0 =A0 const char * devname; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
+ =A0 =A0 =A0 if (!udev) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSYS; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 devname =3D udev_device_get_sysname(udev); =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 attr =3D udev_device_get_sysattr_value(udev, #fname); =A0 =
=A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 if (!attr) { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(3, &quot;%s: attribute %s not found=
 in sysfs&quot;, =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 devname, #fname); =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENXIO; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\<br>
=A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 if (strlen(attr) &gt; len) { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(3, &quot;%s: overflow in attribute =
%s&quot;, =A0 =A0 =A0 =A0 =A0 =A0 =A0\<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 devname, #fname); =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 2; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
- =A0 =A0 =A0 strlcpy(buff, attr, len); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
- =A0 =A0 =A0 return 0; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
+ =A0 =A0 =A0 ret =3D strlcpy(buff, attr, len); =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
+ =A0 =A0 =A0 return ret; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \<br>
=A0}<br>
<br>
=A0declare_sysfs_get_str(devtype);<br>
-declare_sysfs_get_str(cutype);<br>
=A0declare_sysfs_get_str(vendor);<br>
=A0declare_sysfs_get_str(model);<br>
=A0declare_sysfs_get_str(rev);<br>
@@ -180,7 +183,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeou=
t)<br>
=A0 =A0 =A0 =A0 unsigned int t;<br>
<br>
=A0 =A0 =A0 =A0 if (!pp-&gt;udev || pp-&gt;bus !=3D SYSFS_BUS_SCSI)<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSYS;<br>
<br>
=A0 =A0 =A0 =A0 parent =3D pp-&gt;udev;<br>
=A0 =A0 =A0 =A0 while (parent) {<br>
@@ -192,7 +195,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeou=
t)<br>
=A0 =A0 =A0 =A0 }<br>
=A0 =A0 =A0 =A0 if (!attr) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(3, &quot;%s: No timeout value in sy=
sfs&quot;, pp-&gt;dev);<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENXIO;<br>
=A0 =A0 =A0 =A0 }<br>
<br>
=A0 =A0 =A0 =A0 r =3D sscanf(attr, &quot;%u\n&quot;, &amp;t);<br>
@@ -200,7 +203,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeou=
t)<br>
=A0 =A0 =A0 =A0 if (r !=3D 1) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(3, &quot;%s: Cannot parse timeout a=
ttribute &#39;%s&#39;&quot;,<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pp-&gt;dev, attr);<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>
=A0 =A0 =A0 =A0 }<br>
<br>
=A0 =A0 =A0 =A0 *timeout =3D t;<br>
@@ -650,17 +653,17 @@ scsi_sysfs_pathinfo (struct path * pp)<br>
=A0 =A0 =A0 =A0 if (!attr_path || pp-&gt;sg_id.host_no =3D=3D -1)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
- =A0 =A0 =A0 if (sysfs_get_vendor(parent, pp-&gt;vendor_id, SCSI_VENDOR_SI=
ZE))<br>
+ =A0 =A0 =A0 if (sysfs_get_vendor(parent, pp-&gt;vendor_id, SCSI_VENDOR_SI=
ZE) &lt;=3D 0)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
=A0 =A0 =A0 =A0 condlog(3, &quot;%s: vendor =3D %s&quot;, pp-&gt;dev, pp-&g=
t;vendor_id);<br>
<br>
- =A0 =A0 =A0 if (sysfs_get_model(parent, pp-&gt;product_id, SCSI_PRODUCT_S=
IZE))<br>
+ =A0 =A0 =A0 if (sysfs_get_model(parent, pp-&gt;product_id, SCSI_PRODUCT_S=
IZE) &lt;=3D 0)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
=A0 =A0 =A0 =A0 condlog(3, &quot;%s: product =3D %s&quot;, pp-&gt;dev, pp-&=
gt;product_id);<br>
<br>
- =A0 =A0 =A0 if (sysfs_get_rev(parent, pp-&gt;rev, SCSI_REV_SIZE))<br>
+ =A0 =A0 =A0 if (sysfs_get_rev(parent, pp-&gt;rev, SCSI_REV_SIZE) &lt;=3D =
0)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
=A0 =A0 =A0 =A0 condlog(3, &quot;%s: rev =3D %s&quot;, pp-&gt;dev, pp-&gt;r=
ev);<br>
@@ -712,7 +715,7 @@ ccw_sysfs_pathinfo (struct path * pp)<br>
<br>
=A0 =A0 =A0 =A0 condlog(3, &quot;%s: vendor =3D %s&quot;, pp-&gt;dev, pp-&g=
t;vendor_id);<br>
<br>
- =A0 =A0 =A0 if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE))<br>
+ =A0 =A0 =A0 if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE) &lt;=
=3D 0)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
=A0 =A0 =A0 =A0 if (!strncmp(attr_buff, &quot;3370&quot;, 4)) {<br>
@@ -772,17 +775,17 @@ cciss_sysfs_pathinfo (struct path * pp)<br>
=A0 =A0 =A0 =A0 if (!attr_path || pp-&gt;sg_id.host_no =3D=3D -1)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
- =A0 =A0 =A0 if (sysfs_get_vendor(parent, pp-&gt;vendor_id, SCSI_VENDOR_SI=
ZE))<br>
+ =A0 =A0 =A0 if (sysfs_get_vendor(parent, pp-&gt;vendor_id, SCSI_VENDOR_SI=
ZE) &lt;=3D 0)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
=A0 =A0 =A0 =A0 condlog(3, &quot;%s: vendor =3D %s&quot;, pp-&gt;dev, pp-&g=
t;vendor_id);<br>
<br>
- =A0 =A0 =A0 if (sysfs_get_model(parent, pp-&gt;product_id, SCSI_PRODUCT_S=
IZE))<br>
+ =A0 =A0 =A0 if (sysfs_get_model(parent, pp-&gt;product_id, SCSI_PRODUCT_S=
IZE) &lt;=3D 0)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
=A0 =A0 =A0 =A0 condlog(3, &quot;%s: product =3D %s&quot;, pp-&gt;dev, pp-&=
gt;product_id);<br>
<br>
- =A0 =A0 =A0 if (sysfs_get_rev(parent, pp-&gt;rev, SCSI_REV_SIZE))<br>
+ =A0 =A0 =A0 if (sysfs_get_rev(parent, pp-&gt;rev, SCSI_REV_SIZE) &lt;=3D =
0)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
<br>
=A0 =A0 =A0 =A0 condlog(3, &quot;%s: rev =3D %s&quot;, pp-&gt;dev, pp-&gt;r=
ev);<br>
@@ -816,7 +819,7 @@ common_sysfs_pathinfo (struct path * pp)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(4, &quot;%s: udev not initialised&q=
uot;, pp-&gt;dev);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
=A0 =A0 =A0 =A0 }<br>
- =A0 =A0 =A0 if (sysfs_get_dev(pp-&gt;udev, pp-&gt;dev_t, BLK_DEV_SIZE)) {=
<br>
+ =A0 =A0 =A0 if (sysfs_get_dev(pp-&gt;udev, pp-&gt;dev_t, BLK_DEV_SIZE) &l=
t;=3D 0) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(3, &quot;%s: no &#39;dev&#39; attri=
bute in sysfs&quot;, pp-&gt;dev);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
=A0 =A0 =A0 =A0 }<br>
@@ -956,8 +959,7 @@ get_state (struct path * pp, int daemon)<br>
=A0 =A0 =A0 =A0 if (daemon)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 checker_set_async(c);<br>
=A0 =A0 =A0 =A0 if (!conf-&gt;checker_timeout &amp;&amp;<br>
- =A0 =A0 =A0 =A0 =A0 (pp-&gt;bus !=3D SYSFS_BUS_SCSI ||<br>
- =A0 =A0 =A0 =A0 =A0 =A0sysfs_get_timeout(pp, &amp;(c-&gt;timeout))))<br>
+ =A0 =A0 =A0 =A0 =A0 sysfs_get_timeout(pp, &amp;(c-&gt;timeout)) &lt;=3D 0=
)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 c-&gt;timeout =3D DEF_TIMEOUT;<br>
=A0 =A0 =A0 =A0 state =3D checker_check(c);<br>
=A0 =A0 =A0 =A0 condlog(3, &quot;%s: state =3D %s&quot;, pp-&gt;dev, checke=
r_state_name(state));<br>
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h<br>
index d049ead..3d2d0ce 100644<br>
--- a/libmultipath/discovery.h<br>
+++ b/libmultipath/discovery.h<br>
@@ -26,7 +26,7 @@<br>
<br>
=A0struct config;<br>
<br>
-int sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);<br>
+ssize_t sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);=
<br>
=A0int path_discovery (vector pathvec, struct config * conf, int flag);<br>
<br>
=A0int do_tur (char *);<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index e47d0ca..f092227 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -351,7 +351,7 @@ out:<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(3, &quot;%s: checker timeout =3D %u=
 s (config file default)&quot;,<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pp-&gt;dev,=
 c-&gt;timeout);<br>
=A0 =A0 =A0 =A0 }<br>
- =A0 =A0 =A0 else if (pp-&gt;udev &amp;&amp; sysfs_get_timeout(pp, &amp;c-=
&gt;timeout) =3D=3D 0)<br>
+ =A0 =A0 =A0 else if (sysfs_get_timeout(pp, &amp;c-&gt;timeout) &gt; 0)<br=
>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(3, &quot;%s: checker timeout =3D %u=
 ms (sysfs setting)&quot;,<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pp-&gt;dev,=
 c-&gt;timeout);<br>
=A0 =A0 =A0 =A0 else {<br>
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c<br>
index 14ea1c7..abb2c56 100644<br>
--- a/libmultipath/structs_vec.c<br>
+++ b/libmultipath/structs_vec.c<br>
@@ -451,8 +451,7 @@ verify_paths(struct multipath * mpp, struct vectors * v=
ecs, vector rpvec)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* see if path is in sysfs<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!pp-&gt;udev || sysfs_get_dev(pp-&gt;udev=
, pp-&gt;dev_t,<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0BLK_DEV_SIZE)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sysfs_get_dev(pp-&gt;udev, pp-&gt;dev_t, =
BLK_DEV_SIZE) &lt;=3D 0) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pp-&gt;state !=3D PATH_=
DOWN) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(1, =
&quot;%s: removing valid path %s in state %d&quot;,<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 mpp-&gt;alias, pp-&gt;dev, pp-&gt;state);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.1.4<br>
<br>
</font></span></blockquote></div><br></div>

--047d7b2e76046944cb04eb62d9e1--


--===============8077019151013877451==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8077019151013877451==--

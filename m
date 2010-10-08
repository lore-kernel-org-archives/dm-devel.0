From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] Make it possible to set a uuid if one was
	not set during DM_DEV_CREATE.
Date: Fri, 8 Oct 2010 15:46:01 -0500
Message-ID: <02AB7750-4128-4C92-9A6D-B5F7CC0CC2C3@redhat.com>
References: <1286560423-12748-1-git-send-email-pjones@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/mixed; boundary="===============2479913898835457734=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1286560423-12748-1-git-send-email-pjones@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


--===============2479913898835457734==
Content-Type: multipart/alternative; boundary=Apple-Mail-1--974083149


--Apple-Mail-1--974083149
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On Oct 8, 2010, at 12:53 PM, Peter Jones wrote:

> This makes it possible to use DM_DEV_RENAME to add a uuid to a  
> device so
> long as one has not been previously set either with DM_DEV_CREATE or
> with DM_DEV_RENAME. This is proposed as a fix to rhbz#584328 .
>
> Also bump the minor number to 19.
>
> Includes changes suggested by jbrassow.
> ---
> drivers/md/dm-ioctl.c    |  112 +++++++++++++++++++++++++++++++ 
> +-------------
> include/linux/dm-ioctl.h |    9 +++-
> 2 files changed, 86 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 3e39193..450dfe3 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -298,7 +298,7 @@ retry:
> static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
> 					    const char *new)
> {
> -	char *new_name, *old_name;
> +	char *new_data, *old_data;
> 	struct hash_cell *hc;
> 	struct dm_table *table;
> 	struct mapped_device *md;
> @@ -306,8 +306,8 @@ static struct mapped_device  
> *dm_hash_rename(struct dm_ioctl *param,
> 	/*
> 	 * duplicate new.
> 	 */
> -	new_name = kstrdup(new, GFP_KERNEL);
> -	if (!new_name)
> +	new_data = kstrdup(new, GFP_KERNEL);
> +	if (!new_data)
> 		return ERR_PTR(-ENOMEM);
>
> 	down_write(&_hash_lock);
> @@ -315,14 +315,28 @@ static struct mapped_device  
> *dm_hash_rename(struct dm_ioctl *param,
> 	/*
> 	 * Is new free ?
> 	 */
> -	hc = __get_name_cell(new);
> -	if (hc) {
> -		DMWARN("asked to rename to an already-existing name %s -> %s",
> -		       param->name, new);
> -		dm_put(hc->md);
> -		up_write(&_hash_lock);
> -		kfree(new_name);
> -		return ERR_PTR(-EBUSY);
> +	if (param->flags & DM_NEW_UUID_FLAG) {
> +		hc = __get_uuid_cell(new);
> +		if (hc) {
> +			DMWARN("Unable to change uuid on device with an "
> +			       "already-existing uuid %s -> %s",
> +			       param->name, new);
> +			dm_put(hc->md);
> +			up_write(&_hash_lock);
> +			kfree(new_data);
> +			return ERR_PTR(-EBUSY);
> +		}
> +	} else {
> +		hc = __get_name_cell(new);
> +		if (hc) {
> +			DMWARN("asked to rename to an already-existing name "
> +			       "%s -> %s",
> +			       param->name, new);
> +			dm_put(hc->md);
> +			up_write(&_hash_lock);
> +			kfree(new_data);
> +			return ERR_PTR(-EBUSY);
> +		}
> 	}

>
> 	/*
> @@ -333,19 +347,42 @@ static struct mapped_device  
> *dm_hash_rename(struct dm_ioctl *param,
> 		DMWARN("asked to rename a non-existent device %s -> %s",
> 		       param->name, new);
> 		up_write(&_hash_lock);
> -		kfree(new_name);
> +		kfree(new_data);
> 		return ERR_PTR(-ENXIO);
> 	}
>
> -	/*
> -	 * rename and move the name cell.
> -	 */
> -	list_del(&hc->name_list);
> -	old_name = hc->name;
> -	mutex_lock(&dm_hash_cells_mutex);
> -	hc->name = new_name;
> -	mutex_unlock(&dm_hash_cells_mutex);
> -	list_add(&hc->name_list, _name_buckets + hash_str(new_name));
> +	if (param->flags & DM_NEW_UUID_FLAG) {
> +		/*
> +		 * Does this device already have a uuid?
> +		 */
> +		if (hc->uuid) {
> +			DMWARN("asked to change uuid of device with uuid "
> +			       "already set %s %s -> %s",
> +			       param->name, hc->uuid, param->uuid);
> +			up_write(&_hash_lock);
> +			kfree(new_data);
> +			return ERR_PTR(-EINVAL);
> +		}
> +		/*
> +		 * reuuid and move the uuid cell.
> +		 */
> +		list_del(&hc->uuid_list);
> +		old_data = hc->uuid;
> +		mutex_lock(&dm_hash_cells_mutex);
> +		hc->uuid = new_data;
> +		mutex_unlock(&dm_hash_cells_mutex);
> +		list_add(&hc->uuid_list, _uuid_buckets + hash_str(new_data));
> +	} else {
> +		/*
> +		 * rename and move the name cell.
> +		 */
> +		list_del(&hc->name_list);
> +		old_data = hc->name;
> +		mutex_lock(&dm_hash_cells_mutex);
> +		hc->name = new_data;
> +		mutex_unlock(&dm_hash_cells_mutex);
> +		list_add(&hc->name_list, _name_buckets + hash_str(new_data));
> +	}
>
> 	/*
> 	 * Wake up any dm event waiters.
> @@ -361,7 +398,7 @@ static struct mapped_device  
> *dm_hash_rename(struct dm_ioctl *param,
>
> 	md = hc->md;
> 	up_write(&_hash_lock);
> -	kfree(old_name);
> +	kfree(old_data);
>
> 	return md;
> }
> @@ -774,21 +811,30 @@ static int invalid_str(char *str, void *end)
> static int dev_rename(struct dm_ioctl *param, size_t param_size)
> {
> 	int r;
> -	char *new_name = (char *) param + param->data_start;
> +	char *new_data = (char *) param + param->data_start;
> 	struct mapped_device *md;
>
> -	if (new_name < param->data ||
> -	    invalid_str(new_name, (void *) param + param_size) ||
> -	    strlen(new_name) > DM_NAME_LEN - 1) {
> -		DMWARN("Invalid new logical volume name supplied.");
> -		return -EINVAL;
> -	}
> +	if (param->flags & DM_NEW_UUID_FLAG) {
> +		if (new_data < param->data ||
> +		    invalid_str(new_data, (void *) param + param_size) ||
> +		    strlen(new_data) > DM_UUID_LEN - 1) {
> +			DMWARN("Invalid new device uuid supplied.");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (new_data < param->data ||
> +		    invalid_str(new_data, (void *) param + param_size) ||
> +		    strlen(new_data) > DM_NAME_LEN - 1) {
> +			DMWARN("Invalid new device name supplied.");
> +			return -EINVAL;
> +		}
>
> -	r = check_name(new_name);
> -	if (r)
> -		return r;
> +		r = check_name(new_data);
> +		if (r)
> +			return r;
> +	}
>
> -	md = dm_hash_rename(param, new_name);
> +	md = dm_hash_rename(param, new_data);
> 	if (IS_ERR(md))
> 		return PTR_ERR(md);
>
> diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
> index 49eab36..e369460 100644
> --- a/include/linux/dm-ioctl.h
> +++ b/include/linux/dm-ioctl.h
> @@ -267,9 +267,9 @@ enum {
> #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD,  
> struct dm_ioctl)
>
> #define DM_VERSION_MAJOR	4
> -#define DM_VERSION_MINOR	18
> +#define DM_VERSION_MINOR	19
> #define DM_VERSION_PATCHLEVEL	0
> -#define DM_VERSION_EXTRA	"-ioctl (2010-06-29)"
> +#define DM_VERSION_EXTRA	"-ioctl (2010-10-07)"
>
> /* Status bits */
> #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
> @@ -322,4 +322,9 @@ enum {
>  */
> #define DM_UEVENT_GENERATED_FLAG	(1 << 13) /* Out */
>
> +/*
> + * If set, rename operates on uuid, not name.
> + */
> +#define DM_NEW_UUID_FLAG        (1 << 14) /* In */
> +
> #endif				/* _LINUX_DM_IOCTL_H */
> -- 
> 1.7.2.2
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--Apple-Mail-1--974083149
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><br><div><div>On Oct 8, 2010, =
at 12:53 PM, Peter Jones wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div>This =
makes it possible to use DM_DEV_RENAME to add a uuid to a device =
so<br>long as one has not been previously set either with DM_DEV_CREATE =
or<br>with DM_DEV_RENAME. This is proposed as a fix to rhbz#584328 =
.<br><br>Also bump the minor number to 19.<br><br>Includes changes =
suggested by jbrassow.<br>---<br> drivers/md/dm-ioctl.c =
&nbsp;&nbsp;&nbsp;| &nbsp;112 =
++++++++++++++++++++++++++++++++-------------<br> =
include/linux/dm-ioctl.h | &nbsp;&nbsp;&nbsp;9 +++-<br> 2 files changed, =
86 insertions(+), 35 deletions(-)<br><br>diff --git =
a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c<br>index =
3e39193..450dfe3 100644<br>--- a/drivers/md/dm-ioctl.c<br>+++ =
b/drivers/md/dm-ioctl.c<br>@@ -298,7 +298,7 @@ retry:<br> static struct =
mapped_device *dm_hash_rename(struct dm_ioctl *param,<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;const char *new)<br> {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>char =
*new_name, *old_name;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>char *new_data, *old_data;<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>struct hash_cell *hc;<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct dm_table *table;<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
mapped_device *md;<br>@@ -306,8 +306,8 @@ static struct mapped_device =
*dm_hash_rename(struct dm_ioctl *param,<br> <span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span>/*<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * =
duplicate new.<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> */<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>new_name =
=3D kstrdup(new, GFP_KERNEL);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (!new_name)<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>new_data =
=3D kstrdup(new, GFP_KERNEL);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (!new_data)<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
ERR_PTR(-ENOMEM);<br><br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>down_write(&amp;_hash_lock);<br>@@ -315,14 +315,28 @@ static =
struct mapped_device *dm_hash_rename(struct dm_ioctl *param,<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>/*<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
* Is new free ?<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> */<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>hc =3D =
__get_name_cell(new);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (hc) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>DMWARN("asked to rename to an already-existing name %s -&gt; =
%s",<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;param-&gt;name, =
new);<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>dm_put(hc-&gt;md);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>up_write(&amp;_hash_lock);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>kfree(new_name);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
ERR_PTR(-EBUSY);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (param-&gt;flags &amp; =
DM_NEW_UUID_FLAG) {<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>hc =3D =
__get_uuid_cell(new);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (hc) {<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>DMWARN("Unable to change uuid on device with an "<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"already-existing uuid %s -&gt; =
%s",<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;param-&gt;name, =
new);<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>dm_put(hc-&gt;md);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>up_write(&amp;_hash_lock);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>kfree(new_data);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
ERR_PTR(-EBUSY);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>} else =
{<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>hc =3D __get_name_cell(new);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (hc) {<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>DMWARN("asked to rename to an already-existing name "<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"%s -&gt; %s",<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;param-&gt;name, new);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>dm_put(hc-&gt;md);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>up_write(&amp;_hash_lock);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>kfree(new_data);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
ERR_PTR(-EBUSY);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br></div></blockquote><div><br></div><blockquote =
type=3D"cite"><div><font class=3D"Apple-style-span" =
color=3D"#000000"><br></font> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>/*<br>@@ -333,19 +347,42 @@ =
static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>DMWARN("asked to rename a non-existent device %s -&gt; %s",<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;param-&gt;name, new);<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>up_write(&amp;_hash_lock);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>kfree(new_name);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>kfree(new_data);<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return ERR_PTR(-ENXIO);<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br><br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span>/*<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * rename and move the name =
cell.<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> */<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>list_del(&amp;hc-&gt;name_list);<br>-<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span>old_name =3D =
hc-&gt;name;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span>mutex_lock(&amp;dm_hash_cells_mutex);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>hc-&gt;name =3D new_name;<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>mutex_unlock(&amp;dm_hash_cells_mutex);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>list_add(&amp;hc-&gt;name_list, _name_buckets + =
hash_str(new_name));<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (param-&gt;flags &amp; =
DM_NEW_UUID_FLAG) {<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>/*<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * Does =
this device already have a uuid?<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> */<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(hc-&gt;uuid) {<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>DMWARN("asked to change uuid of =
device with uuid "<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"already set %s %s -&gt; =
%s",<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;param-&gt;name, hc-&gt;uuid, =
param-&gt;uuid);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>up_write(&amp;_hash_lock);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>kfree(new_data);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
ERR_PTR(-EINVAL);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>/*<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * reuuid and move the uuid cell.<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
*/<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>list_del(&amp;hc-&gt;uuid_list);<br>+<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>old_data =3D =
hc-&gt;uuid;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>mutex_lock(&amp;dm_hash_cells_mutex);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>hc-&gt;uuid =3D new_data;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>mutex_unlock(&amp;dm_hash_cells_mutex);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>list_add(&amp;hc-&gt;uuid_list, _uuid_buckets + =
hash_str(new_data));<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>} else {<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>/*<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * rename and move the name cell.<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
*/<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>list_del(&amp;hc-&gt;name_list);<br>+<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>old_data =3D =
hc-&gt;name;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>mutex_lock(&amp;dm_hash_cells_mutex);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>hc-&gt;name =3D new_data;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>mutex_unlock(&amp;dm_hash_cells_mutex);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>list_add(&amp;hc-&gt;name_list, _name_buckets + =
hash_str(new_data));<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br><br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>/*<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
* Wake up any dm event waiters.<br>@@ -361,7 +398,7 @@ static struct =
mapped_device *dm_hash_rename(struct dm_ioctl *param,<br><br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>md =3D =
hc-&gt;md;<br> <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>up_write(&amp;_hash_lock);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>kfree(old_name);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>kfree(old_data);<br><br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return md;<br> }<br>@@ -774,21 =
+811,30 @@ static int invalid_str(char *str, void *end)<br> static int =
dev_rename(struct dm_ioctl *param, size_t param_size)<br> {<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int =
r;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>char *new_name =3D (char *) param + =
param-&gt;data_start;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>char *new_data =3D (char *) param =
+ param-&gt;data_start;<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct mapped_device =
*md;<br><br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>if (new_name &lt; param-&gt;data ||<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;invalid_str(new_name, (void *) param + param_size) =
||<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;strlen(new_name) &gt; DM_NAME_LEN - 1) =
{<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>DMWARN("Invalid new logical volume name supplied.");<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
-EINVAL;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>if (param-&gt;flags &amp; DM_NEW_UUID_FLAG) {<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(new_data &lt; param-&gt;data ||<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;invalid_str(new_data, (void *) param + param_size) =
||<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;strlen(new_data) &gt; DM_UUID_LEN - 1) =
{<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>DMWARN("Invalid new device uuid supplied.");<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
-EINVAL;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>} else {<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (new_data &lt; param-&gt;data =
||<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;invalid_str(new_data, (void *) param + =
param_size) ||<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;strlen(new_data) &gt; DM_NAME_LEN - 1) {<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>DMWARN("Invalid new device name supplied.");<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
-EINVAL;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br><br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span>r =3D check_name(new_name);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(r)<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>return r;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>r =3D =
check_name(new_data);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (r)<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
r;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br><br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span>md =3D dm_hash_rename(param, new_name);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>md =3D =
dm_hash_rename(param, new_data);<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (IS_ERR(md))<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
PTR_ERR(md);<br><br>diff --git a/include/linux/dm-ioctl.h =
b/include/linux/dm-ioctl.h<br>index 49eab36..e369460 100644<br>--- =
a/include/linux/dm-ioctl.h<br>+++ b/include/linux/dm-ioctl.h<br>@@ =
-267,9 +267,9 @@ enum {<br> #define DM_DEV_SET_GEOMETRY<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)<br><br> =
#define DM_VERSION_MAJOR<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>4<br>-#define =
DM_VERSION_MINOR<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>18<br>+#define DM_VERSION_MINOR<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>19<br> #define =
DM_VERSION_PATCHLEVEL<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>0<br>-#define =
DM_VERSION_EXTRA<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>"-ioctl (2010-06-29)"<br>+#define DM_VERSION_EXTRA<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>"-ioctl =
(2010-10-07)"<br><br> /* Status bits */<br> #define =
DM_READONLY_FLAG<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>(1 &lt;&lt; 0) /* In/Out */<br>@@ -322,4 +322,9 @@ enum {<br> =
&nbsp;*/<br> #define DM_UEVENT_GENERATED_FLAG<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>(1 =
&lt;&lt; 13) /* Out */<br><br>+/*<br>+ * If set, rename operates on =
uuid, not name.<br>+ */<br>+#define DM_NEW_UUID_FLAG =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1 &lt;&lt; 14) /* In =
*/<br>+<br> #endif<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>/* _LINUX_DM_IOCTL_H */<br>-- =
<br>1.7.2.2<br><br>--<br>dm-devel mailing list<br><a =
href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>https://www=
.redhat.com/mailman/listinfo/dm-devel<br></div></blockquote></div><br></bo=
dy></html>=

--Apple-Mail-1--974083149--


--===============2479913898835457734==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2479913898835457734==--

From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] libmultipath: Don't chop const strings
Date: Thu, 13 Feb 2014 22:22:44 +0100
Message-ID: <CABr-Gne1OWx6DfOA8kn9iDCxhAgo=ikhD0Y2WArajt5N-DQyJg@mail.gmail.com>
References: <1392222110-13324-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1392222110-13324-1-git-send-email-bmarzins@redhat.com>
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

Applied,
thanks.

On Wed, Feb 12, 2014 at 5:21 PM, Benjamin Marzinski <bmarzins@redhat.com> wrote:
> multipath was chopping sysfs attr strings in order to make sure that
> ending whitespace didn't cause them to overflow their buffer. However
> those strings were const strings. This patch makes multipath check how
> much of the string length is ending whitespace, so that it can tell if
> it will really overflow the buffer without chopping the const string.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 228ffd3..a6ff658 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -4,6 +4,7 @@
>   * Copyright (c) 2005 Mike Anderson
>   */
>  #include <stdio.h>
> +#include <ctype.h>
>  #include <unistd.h>
>  #include <fcntl.h>
>  #include <sys/ioctl.h>
> @@ -143,6 +144,7 @@ path_discovery (vector pathvec, struct config * conf, int flag)
>  extern ssize_t                                                         \
>  sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len) \
>  {                                                                      \
> +       int l;                                                  \
>         const char * attr;                                              \
>         const char * devname;                                           \
>                                                                         \
> @@ -157,12 +159,14 @@ sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len)    \
>                         devname, #fname);                               \
>                 return -ENXIO;                                          \
>         }                                                               \
> -       if (strchop(attr) > len) {                                      \
> +       for (l = strlen(attr); l >= 1 && isspace(attr[l-1]); l--);      \
> +       if (l > len) {                                                  \
>                 condlog(3, "%s: overflow in attribute %s",              \
>                         devname, #fname);                               \
>                 return -EINVAL;                                         \
>         }                                                               \
> -       return strlcpy(buff, attr, len);                                \
> +       strlcpy(buff, attr, len);                                       \
> +       return strchop(buff);                                           \
>  }
>
>  declare_sysfs_get_str(devtype);
> --
> 1.8.4.2
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

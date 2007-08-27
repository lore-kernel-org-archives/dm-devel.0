From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Resizing multipath maps: reload ioctl failed: Invalid
	argument
Date: Mon, 27 Aug 2007 11:25:59 -0400
Message-ID: <46D2ED07.2080003@ce.jp.nec.com>
References: <46D2CB7F.80900@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46D2CB7F.80900@linpro.no>
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

Hi,

Tore Anderson wrote:
>   Hi.  I'm trying to resize multipath maps, but there appears to be
>  something wrong with the ioctl call...  I resized the "www" volume on
>  the storage array from 25GB to 45GB, and attempted to reload it on the
>  host, which is running 2.6.23-rc3 and multipath-tools 0.4.7.  It
>  resulted in the following:

It's due to kernel device-mapper restriction.

multipath-tools uses no_flush suspend of device-mapper device
to save I/O errors in all-paths-down case.
(Without the option, device-mapper needs to flush all pending I/Os,
 that will result in I/O errors if there is no working path.)

For no_flush suspend, resizing is disabled because of known dead-lock:
it requires a lock that can be kept hold until the pending I/Os
are flushed.

>   Ultimately I found no other way to make this work but to umount the
>  file system, then run "multipath -f www; multipath", which kind of
>  defeated the point of fancy online resizing support in the file system
>  and storage array since I need downtime to do it.  Is there any other
>  way to make online resizing work?

A workaround for it would be using modified multipath-tools which doesn't
use no_noflush.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

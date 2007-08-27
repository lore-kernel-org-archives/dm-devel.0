From: Tore Anderson <tore@linpro.no>
Subject: Re: Resizing multipath maps: reload ioctl failed: Invalid
	argument
Date: Mon, 27 Aug 2007 20:47:00 +0200
Message-ID: <46D31C24.4030201@linpro.no>
References: <46D2CB7F.80900@linpro.no> <46D2ED07.2080003@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46D2ED07.2080003@ce.jp.nec.com>
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


   Hello,

* Jun'ichi Nomura

> It's due to kernel device-mapper restriction.
> 
> multipath-tools uses no_flush suspend of device-mapper device to save
> I/O errors in all-paths-down case. (Without the option, device-mapper
> needs to flush all pending I/Os, that will result in I/O errors if
> there is no working path.)
> 
> For no_flush suspend, resizing is disabled because of known
> dead-lock: it requires a lock that can be kept hold until the pending
> I/Os are flushed.

   Hmm.  So this deadlock is a kernel bug that (hopefully) will be fixed
  in the future, so resizing can again be enabled, or is this a design
  limitation that it's impossible to do something about?

   Can the no_flush thing be toggled online;  that is, would it be
  possible to alter multipath-tools so that when it attempted to resize a
  map, it would disable no_flush, resize it, and then re-enable it?  I
  think a two-second window of vulnerability to all-paths-down is
  acceptable...

   Similarily, if this no_flush option is relevant only when
  features=queue_if_no_paths (at least that's the impression I get from
  your description of it), would it work to temporarily reload the map
  without this feature, resize the volume, than re-add queue_if_no_path?

> A workaround for it would be using modified multipath-tools which
> doesn't use no_noflush.

   I grepped for noflush and no_flush (and so on) in the multipath-tools
  source code but can't really find where it is set..?

Thanks
-- 
Tore Anderson

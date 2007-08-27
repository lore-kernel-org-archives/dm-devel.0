From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Resizing multipath maps: reload ioctl failed: Invalid
	argument
Date: Mon, 27 Aug 2007 18:44:12 -0400
Message-ID: <46D353BC.3060805@ce.jp.nec.com>
References: <46D2CB7F.80900@linpro.no>	<46D2ED07.2080003@ce.jp.nec.com>	<46D31C24.4030201@linpro.no>	<46D3343A.6030302@ce.jp.nec.com>
	<46D33FA6.5000304@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46D33FA6.5000304@linpro.no>
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
>> Current code uses 'no_flush' unconditionally.
>> I think it's possible to improve it to do that only when
>> queue_if_no_path is enabled.
> 
>   It certainly would be an improvement if no_flush and queue_if_no_path
>  could be automatically disabled in the short time it will take to
>  reload the multipath map with an increased size.  For extra safety the
>  tool could also verify that no paths were failed before doing so,
>  maybe.  If everything is working fine it seems rather unlikely that all
>  paths will fail and all HBA driver timeouts will expire in the second
>  it takes to reload the multipath map.

It's not good to override a policy about queue_if_no_path, that will
create a small window of data loss.
Even the small window could result in a disaster.
I meant in the previous mail that there is no need for multipath-tools
to use no_flush if a user explicitly configures the device without
queue_if_no_path.
Assuming that users sensitive to the system availability would set
queue_if_no_path, I'm not sure how useful the improvement is.

>> Since the feature is added after 0.4.7, your problem may be caused
>> by other reason.
>> The call to dm_task_no_flush() is added after the release of 0.4.7.
>> It should be in dm_simplecmd() in libmultipath/devmapper.c.
> 
>   Interesting.  I sent an email titled "dm-rdac not working?" earlier
>  today, where I described another problem with the RDAC hwhandler that
>  also caused I/O errors to propagate up from device-mapper into VFS,
>  even though queue_if_no_path was in use.  Is it possible, you think,
>  that this misbehaviour was due to having loaded the multipath maps
>  using 0.4.7 and therefore without no_flush being set?  (Or in other
>  words:  Is 0.4.8 a requirement for queue_if_no_path to work correctly?)

As far as the table is not suspended, e.g. just failing or reinstating
paths, queue_if_no_path works correctly without no_flush.
When the table is suspended, e.g. a path is added or removed, pending
I/Os will be flushed on suspend even if queue_if_no_path is specified.
That's the situation no_flush solves.

Easiest check is perhaps stracing multipath/multipathd and see what
ioctls they issue. If they do DM_DEV_SUSPEND, using 0.4.8 might be a
solution. If they don't, the cause is in other place.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

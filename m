From: Martin Wilck <mwilck@suse.com>
Subject: Re: 'multipath add path' returns ok but the path is
 missing in the topology
Date: Fri, 24 Apr 2020 17:40:13 +0200
Message-ID: <59c267942a058b9bb989abbf1dbcc99ee4ee9cc3.camel@suse.com>
References: <CAJX1YtZiGXdZTrGtw8ksP3khRf26jQ7dhBWoEJcGfQQZMGb-gg@mail.gmail.com>
	<086d3e2baae71658539ac7caf634336ea0927c04.camel@suse.com>
	<CAJX1YtaKhjLNN56rvwAXh7tOP1Egbo1izmFn3OUEhD4c489E1w@mail.gmail.com>
	<3dbafeb000d558af21db70816130573106b56a9c.camel@suse.com>
	<CAJX1YtYw+aJ5xXjZKoksF9gh3aaJoQRiqAkjUigc5R0-bFPb1w@mail.gmail.com>
	<afac68664b44a28203325fed2fee7d8c0d9ae750.camel@suse.com>
	<CAJX1YtYV9j-jmW9W9FaFcndYM2CT9xLLXTs=RW-a4SB=h1N-KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJX1YtYV9j-jmW9W9FaFcndYM2CT9xLLXTs=RW-a4SB=h1N-KQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Jinpu, dm-devel@redhat.com, Wang <jinpu.wang@cloud.ionos.com>
List-Id: dm-devel.ids

On Fri, 2020-04-24 at 15:18 +0200, Gioh Kim wrote:
> 
> I would like to inform you of what I found out.
> 1. 'multipathd add path sdx' is executed
> 2. Adding thd sdx also creates a map.
> 3. The multipathd daemon waits for the change uevent from kernel.
> 4. Another sd device sdy is added with 'multipathd add path sdy'
> command
> 5. adding sdy is not done and multipathd prints a message "sdy:
> orphan
> path, waiting for create to complete"
> 6. Something (I guess it is the checker thread) removes and adds the
> dm device
> 7. sdy is removed with a message "sdy: orphan path, path removed
> externally". I guess the checker thread removes sdy as well.
> 
> I am not sure what removes the dm device and sdy device.
> I guess it would be the check thread due to the "sdy: orphan path,
> path removed externally" message.
> 
> Therefore I just added the 'udevadm settle' command after the
> 'multipathd add path sdx' command.
> So whenever my script executes 'multipathd add path', it also
> executes
> 'udevadm settle'.
> Then my test is fine for a long time.
> 
> 

This really sounds like a bug in the wait_for_udev handling.
Could you provide a full log of these events with "verbosity 3"?
No need to post it to the ML, send it privately or put it on some paste
service.

Regards
Martin

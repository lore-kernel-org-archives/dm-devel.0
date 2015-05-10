From: Minfei Huang <minfei.huang@hotmail.com>
Subject: Re: dm-snap-persistent: chunk_io doesn't call
 destroy_work_on_stack in 3.10.76
Date: Sun, 10 May 2015 10:22:09 +0800
Message-ID: <BLU436-SMTP5454046CDE9BC646F7362294DC0@phx.gbl>
References: <554C67F0.3070707@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <554C67F0.3070707@gmail.com>
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

On 05/08/15 at 04:38P, Akira Hayakawa wrote:
> Hi,
> 
> I am looking at 3.10.76 kernel and found that
> chunk_io function of dm-snap-persistent doesn't call
> destroy_work_on_stack to pair with INIT_WORK_ON_STACK.
> 
>         INIT_WORK_ONSTACK(&req.work, do_metadata);
>         queue_work(ps->metadata_wq, &req.work);
>         flush_workqueue(ps->metadata_wq);
>         // I think you need it here
>  
>         return req.result;
> 
> Is it not buggy?

commit c1a6416021b311fdb5b98e40ed8b29508845ed16
Author: Chuansheng Liu <chuansheng.liu@intel.com>
Date:   Tue Jan 7 16:56:18 2014 +0800

    dm snapshot: call destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()
    
    In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
    call destroy_work_on_stack() which frees the debug object to pair
    with INIT_WORK_ONSTACK().
    
    Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Thanks
Minfei

> 
> - Akira
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

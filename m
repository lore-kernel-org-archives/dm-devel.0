From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: dm-multipath MP_RETRY_PG_INIT patch
Date: Wed, 27 Jun 2007 13:54:35 -0500
Message-ID: <4682B26B.4090401@cs.wisc.edu>
References: <50d45ed90706210718y4ef5d66en433c9444d227ff65@mail.gmail.com>
	<50d45ed90706262325k3bfcdf9em14c6a3eaffb3d895@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50d45ed90706262325k3bfcdf9em14c6a3eaffb3d895@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jitendra Bhivare <jitendra.bhivare@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Jitendra Bhivare wrote:
> Hi,
> 
> In dm-multipath framework, using the hw-handler's error-function entry
> point, nothing can be known about the reason for IO failure. From this
> function MP_FAIL_PATH/MP_BYPASS_PG/MP_ERROR_IO can returned.
> If the same path needs to be tried (i.e. in pg_init) to figure out the
> reason for failure there is no way to tell that to dm-multipath.
> 
> One way to do so, is to return MP_RETRY_PG_INIT from hw_handler's
> error function. This would set current_pgpath and current_pg to NULL
> which would trigger pg_init. The path won't fail until pg_init says so.
> 
> Should this option MP_RETRY_PG_INIT be added to dm-multipath?
> 

I think we need something like it. What hw handler is this for? Dave W, 
sent a hw handler for old boxes that need START_STOP and he sent a patch 
which worked like what you describe? Have you seen his patch to this list?

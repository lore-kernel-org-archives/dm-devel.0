From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH V4 1/2] multipath-tools: intermittent IO
 error accounting to improve reliability
Date: Tue, 19 Sep 2017 20:53:01 +0800
Message-ID: <52829afa-ed9e-cc39-a492-3e678b8e0d03@huawei.com>
References: <1505619638-20912-1-git-send-email-guanjunxiong@huawei.com>
	<1505619638-20912-2-git-send-email-guanjunxiong@huawei.com>
	<fd6ead563a154984abc2654fd1a8ea30@BRMWP-EXMB12.corp.brocade.com>
	<7035dfdb-1c49-aa3f-3836-1ec316707c47@huawei.com>
	<1505764297.12944.2.camel@suse.com>
	<e596eefc-2d42-e840-57cf-6219d43de9d9@huawei.com>
	<8d45c076cf6c47d39bf2aade3ade7f51@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8d45c076cf6c47d39bf2aade3ade7f51@BRMWP-EXMB12.corp.brocade.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Muneendra Kumar M <mmandala@Brocade.com>, Martin Wilck <mwilck@suse.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "chengjike.cheng@huawei.com" <chengjike.cheng@huawei.com>, "niuhaoxin@huawei.com" <niuhaoxin@huawei.com>, "shenhong09@huawei.com" <shenhong09@huawei.com>
List-Id: dm-devel.ids

Hi Muneendra ,
Thanks for your suggestion. My comments inline.

On 2017/9/19 18:59, Muneendra Kumar M wrote:
> Hi Guan/Martin,
> Below are my points.
> 
>>>> "san_path_double_fault_time"  is great.  One less additional parameter and still covering most scenarios are appreciated.
> This looks good and I completely agree with Guan.
> 
> One question san_path_double_fault_time is the time between two failed states (failed-active-failed )is this correct ?.
> Then this holds good.
> 
> Instead of san_path_double_fault_time can we call it as san_path_double_failed_time as the name suggests the time between two failed states is this ok ?
> 

Both names are fine for me.

> In SAN  topology (FC,NVME,SCSI)transient intermittent network errors make the ITL paths  as marginal paths. 
>
>
> So instead of calling "path_io_err_sample_time", "path_io_err_rate_threshold" and "path_io_err_recovery_time"
> can we name as "marginal_path_err_detection_time", " marginal_path_err_rate_threshold" and " marginal_path_err_recovery_time"
> 
> Some other names should also be good as the io_path is general word from my view.
> >

Can you explain "the marginal paths" in details?  Can the users easily catch the meaning of  marginal paths?
IMO, path_io_err_XXXs are easy to under_stand

> If we agree with this one more thing which I would like to add as part of this patch.
> 
> Whenever the path is in XXX_io_error_recovery_time  and if the user runs multipath -ll command the path the state of the path is shown as failed as shown below.
> 
> 	| `- 6:0:0:0 sdb 8:16  failed ready  running
> 
> Can we add a new state as marginal so that when the admin run the multipath command and found that the state is in marginal he can quickly come to know that this a marginal 
> Path and needs to be recovered .If we keep the state as failed the admin cannot understand from past how much time the device is in failed state.
> 
>

If the user use multipathd -k , then input "show paths", the multipathd will show the path in the state of "delayed".
But we can't find the exactly reason of the delayed state path because other features such as path waiting uses it.
Shall we use existing PATH_SHAKY ?

Regards.
Guan

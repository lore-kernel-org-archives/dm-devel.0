From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] multipath: add fast_io_fail and dev_loss_tmo
 config	parameters
Date: Tue, 03 Aug 2010 10:18:48 +0900
Message-ID: <4C576E78.9020700@ce.jp.nec.com>
References: <4C5297AA.4070708@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C5297AA.4070708@ce.jp.nec.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Michael Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Hi,

(07/30/10 18:13), Jun'ichi Nomura wrote:
> (03/23/10 11:44), Benjamin Marzinski wrote:
>> This patch adds two new configuration parameters to multipath.conf,
>> fast_io_fail_tmo and dev_loss_tmo which set
>>
>> /sys/class/fc_remote_ports/rport-<host>:<channel>-<rport_id>/fast_io_fail_tmo and
>> /sys/class/fc_remote_ports/rport-<host>:<channel>-<rport_id>/dev_loss_tmo
> ...
> 
> This is nice feature but the code uses scsi_id instead of rport_id:
> 
>> +sysfs_set_scsi_tmo (struct multipath *mpp)
> ...
>> +	vector_foreach_slot(mpp->paths, pp, i) {
>> +		if (safe_snprintf(attr_path, SYSFS_PATH_SIZE,
>> +	        	          "/class/fc_remote_ports/rport-%d:%d-%d",
>> +				  pp->sg_id.host_no, pp->sg_id.channel,
>> +				  pp->sg_id.scsi_id)) {
>> +			condlog(0, "attr_path '/class/fc_remote_ports/rport-%d:%d-%d' too large", pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.scsi_id);
>> +			return 1;
>> +		}
> 
> So it sets fast_io_fail_tmo/dev_loss_tmo for wrong rport.
> 
> For example, I have a storage with node_id 0x2000003013842bcb
> connected via switch, whose node_id is 0x100000051e09ee30.
> When I set 'fast_io_fail_tmo = 8' in multipath.conf,
> multipath command sets the timeout like this:
>   # for f in /sys/class/fc_remote_ports/rport-*/fast_io_fail_tmo; do d=$(dirname $f); echo $(basename $d):$(cat $d/node_name):$(cat $f); done
>   rport-0:0-0:0x100000051e09ee30:8
>   rport-0:0-1:0x100000051e09ee30:8
>   rport-0:0-2:0x2000003013842bcb:off
>   rport-0:0-3:0x2000003013842bcb:off
>   rport-1:0-0:0x100000051e09ee30:8
>   rport-1:0-1:0x100000051e09ee30:8
>   rport-1:0-2:0x2000003013842bcb:off
>   rport-1:0-3:0x2000003013842bcb:off
> As a result, when a link is down for the storage and fast_io_fail_tmo
> has passed, I/O will be still blocked.
> 
> 
> Attached is a quick patch for this problem.
> 
> With this patch, fast_io_fail_tmo is set like this:
>   rport-0:0-0:0x100000051e09ee30:8
>   rport-0:0-1:0x100000051e09ee30:8
>   rport-0:0-2:0x2000003013842bcb:off
>   rport-0:0-3:0x2000003013842bcb:off
>   rport-1:0-0:0x100000051e09ee30:8
>   rport-1:0-1:0x100000051e09ee30:8
>   rport-1:0-2:0x2000003013842bcb:off
>   rport-1:0-3:0x2000003013842bcb:off

Sorry, I pasted the original result twice..
With the patch, fast_io_fail_tmo is set like this:
  rport-0:0-0:0x100000051e09ee30:off
  rport-0:0-1:0x100000051e09ee30:off
  rport-0:0-2:0x2000003013842bcb:8
  rport-0:0-3:0x2000003013842bcb:8
  rport-1:0-0:0x100000051e09ee30:off
  rport-1:0-1:0x100000051e09ee30:off
  rport-1:0-2:0x2000003013842bcb:8
  rport-1:0-3:0x2000003013842bcb:8

> Others might have better idea about resolving rport_id from target.
> Mike, Hannes, any comments?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation

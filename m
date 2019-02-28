From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: multipathd ignoring dev_loss_tmo setting
Date: Thu, 28 Feb 2019 13:08:29 +0100
Message-ID: <bc31916f-294e-ec82-1360-329645919a75@linux.ibm.com>
References: <d915601a3472d7448e57f968e2ec3a63c627a35e.camel@cgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d915601a3472d7448e57f968e2ec3a63c627a35e.camel@cgi.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/28/2019 12:38 PM, Martins, Bruno O wrote:
> I am trying to modify /etc/multipath.conf on my system so that the
> parameter 'dev_loss_tmo' is changed from the default value.
> 
> My multipath.conf file contains the following:
> 
> defaults {

>          no_path_retry "fail"
>          queue_without_daemon "no"
>          checker_timeout 15
>          flush_on_last_del "no"
>          user_friendly_names "yes"
>          fast_io_fail_tmo 5
>          dev_loss_tmo 10

> }

If I'm not mistaken, the default settings could be overridden by (built-in) 
device section settings.
However, in your case, where you see some rports having your desired setting 
but others not, it looks like it's due to multipath-tools only setting the 
_tmo's for those rports where it has paths it manages in path groups.
So if you don't have multipath managed paths behind e.g. 
rport-3:0-3:0x5000097408369800 it remains to use the rport's default tmo coming 
from scsi_transport_fc in the kernel.
If so, we typically don't care for those "unmanaged" ports.

> However, when checking the value currently in use I am getting the
> wrong value (which is '30') for some of the remote ports:
> 
> for f in /sys/class/fc_remote_ports/rport-*/dev_loss_tmo; do
> d=$(dirname $f); echo $(basename $d):$(cat $d/node_name):$(cat $f);
> done
> 
> rport-3:0-0:0x5742b0f00007c500:10
> rport-3:0-1:0x5742b0f00007c500:10
> rport-3:0-2:0x5742b0f00007c500:10
> rport-3:0-3:0x5000097408369800:30
> rport-3:0-4:0x500009757804cbff:30

> systool is giving me the same information:
> 
> systool -c fc_remote_ports -v | grep dev_loss_tmo

>      dev_loss_tmo        = "10"
>      dev_loss_tmo        = "30"
>      dev_loss_tmo        = "10"
>      dev_loss_tmo        = "30"
>      dev_loss_tmo        = "30"
>      dev_loss_tmo        = "30"
>      dev_loss_tmo        = "30"
> 
> Where is this value coming from? May this be a bug? I couldn't find
> anything useful on the Internet regarding this.
> 
> I am using the following versions:
> 
> rpm -qa multipath-tools
> multipath-tools-0.4.9-109.1
> 
> uname -a
> Linux mysystem 3.0.101-63-default #1 SMP Tue Jun 23 16:02:31 UTC 2015
> (4b89d0c) x86_64 x86_64 x86_64 GNU/Linux



-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

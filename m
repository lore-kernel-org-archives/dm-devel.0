From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Thu, 14 Jan 2016 11:09:36 -0800
Message-ID: <5697F270.3070205@sandisk.com>
References: <56961493.5010901@suse.de>
	<20160113175239.GE24960@octiron.msp.redhat.com>
	<56974D80.2020803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56974D80.2020803@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids

On 01/13/2016 11:25 PM, Hannes Reinecke wrote:
> On 01/13/2016 06:52 PM, Benjamin Marzinski wrote:
>> On Wed, Jan 13, 2016 at 10:10:43AM +0100, Hannes Reinecke wrote:
>>> c) implement block or scsi events whenever a remote port becomes
>>>     unavailable. This removes the need of the 'path_checker'
>>>     functionality in multipath-tools.
>>
>> I'm not convinced that we will be able to find out when paths come back
>> online in all cases without some sort of actual polling. Again, I'd love
>> this to be simpler, but asking all the types of storage we plan to
>> support to notify us when they are up and down may not be realistic.
>
> Currently we have three main transports: FC, iSCSI, and SAS.

Hello Hannes,

Since several years the Linux SRP initiator driver also has reliable and 
efficient H.A. support. The IB spec supports port state change 
notifications. But whether or not port state information affects the 
path state should be configurable. Several IB users wouldn't like it if 
port state information would affect the path state because the time 
during which a port is down can be shorter than the time during which an 
IB HCA keeps retrying to send a packet.

Bart.

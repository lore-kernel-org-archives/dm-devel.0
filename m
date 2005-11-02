From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Block multipathing in an IP-SAN
Date: Wed, 02 Nov 2005 00:56:06 -0600
Message-ID: <43686306.9030701@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321AD90@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AD90@SRMANNING.eng.emc.com>
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

goggin, edward wrote:
> I'm wondering about how block device multipathing works in conjunction with
> the high availability
> features of an IP-SAN.
> 
> Does the iSCSI initiator's session layer's retransmission capability and the
> IP-takeover capability
> of IP-SAN switches eliminate the need for block device multipathing in an
> IP-SAN?
> 
> Does the iSCSI initiator present redundant paths to the SCSI mid-layer?
> 
> Do these answers differ with software verses hardware iSCSI initiators?
> 


For linux mainline and what some distros carry, software will be similar 
to HW iscsi becuase the linux-scsi community has not wanted MCS. For 
software iscsi in mainline (open-iscsi/linux-iscsi-5) and RHEL 4 
(linux-iscsi-4), you can use bonding or trunking - whatever you know it 
as, and hide everything from the iSCSI and SCSI levels, or you can use 
dm-multipath. To do the latter for software iscsi, the iscsi driver 
creates a session to each portal, scans it, and dm-multipath/multipath 
assembles dm devices like it would for FC. The softare drivers drivers 
also support login redirect and some vendors use this for failover and 
load balancing. I think qlogic also support this.

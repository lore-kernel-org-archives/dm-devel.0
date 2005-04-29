From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Multipath setup
Date: Fri, 29 Apr 2005 17:07:23 +0200
Message-ID: <20050429150723.GB16717@averon.dyndns.org>
References: <960A9B249C99994AA3C7FCA016A0DA8901DA8EBE@ussccem08.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <960A9B249C99994AA3C7FCA016A0DA8901DA8EBE@ussccem08.corp.hds.com>
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

> 
> installed the 2.6.12.rc2-odm1 (I turned on the Multi-Device
> support/Device 
> Mapper Support and Multipath I/O Support)
> 

"Multipath I/O" is the MD driver.
You need to enable the DM one.

> 
> [root@dhcp76 multipath-tools-0.4.4]# /sbin/dmsetup targets
> striped          v1.0.2
> linear           v1.0.1
> error            v1.0.1
> 
> Is that mean I don't have multipath support compiled in the kernel ?
> 
Yes

> Also, I have a generic question regarding to the multipath tool. We ran
> some 
> virtualization softwares, which generate different UUID (SCSI VPD 83)
> for the 
> same LUN go through different path, can the multipath software config
> these 
> two LUNs with difference UUID in a multipath setup ?
> 
You have to forge your own "getuid" program then.
Default one is scsi_id.

Regards,
cvaroqui

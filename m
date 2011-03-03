From: Charles Slivkoff <slivkoff@cmu.edu>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
 Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Date: Thu, 03 Mar 2011 15:59:01 -0500
Message-ID: <4D700115.8000500@cmu.edu>
References: <4D6BFCF9.4080809@cmu.edu>
	<4D6E91E7.4010305@cmu.edu>	<4D6ECAD2.4040807@cmu.edu>
	<4D6FBE59.9040000@cmu.edu>
	<D8C50530D6022F40A817A35C40CC06A7065777D7C3@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7065777D7C3@DUBX7MCDUB01.EMEA.DELL.COM>
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

On 03/03/2011 11:47 AM, Menny_Hamburger@Dell.com wrote:
> 
> I know this is usually a wild goose chase, but what about the
> controller firmware? I can see from the profile that the controller
> FW is 07.70.06.63, while the latest according to the Dell
> compatibility matrix is 07.75.14.60

I'll look into this next.

On 03/03/2011 01:30 PM, Yanqing_Liu@Dell.com wrote:
> 
> It seems that you mapped your LUNs some time after host bootup. That 
> causes pseudo LUN 0 to be created. If you lay down DM using Dell 
> software package, please invoke "rescan_dm_devs" for
> re-configuration.

I have used "rescan_dm_devs" before. This did not eliminate the pseudo 
LUN 0.

I did manage to get rid of them, though, by un-mapping and re-mapping 
the array virtual disks as LUNs 0 & 1, instead of LUNs 1 & 2. The 
current array profile is here: http://tinypaste.com/64eebb

lsscsi now looks good. See http://tinypaste.com/3580a

Unfortunately, this did not help with the "Illegal Request" messages.

> We may need your related kernel message for further analysis. As to 
> why setting "failback" to manual doesn't work on MD3200, the problem 
> may be in multipathing daemon, in combination with SAS tranpportation
> trearing down all devices immediately after path loss. We've filed a
> bugzilla for this.

The latest syslog is here: http://tinypaste.com/87516

> BTW, what is your LVM setting for these devices?

The LUNs are each assigned to their own SCSI controller. Both LUNs (PVs) 
are members of a single VG. The LVs are striped across the PVs, thus 
allowing both paths to be used. The "lvdisplay -m" output is here: 
http://tinypaste.com/7c42a

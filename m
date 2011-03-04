From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
 Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Date: Thu, 3 Mar 2011 21:34:03 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF56B44B@cosmail01.lsi.com>
References: <4D6BFCF9.4080809@cmu.edu>	<4D6E91E7.4010305@cmu.edu>
	<4D6ECAD2.4040807@cmu.edu>	<4D6FBE59.9040000@cmu.edu>
	<D8C50530D6022F40A817A35C40CC06A7065777D7C3@DUBX7MCDUB01.EMEA.DELL.COM>,
	<4D700115.8000500@cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D700115.8000500@cmu.edu>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I have looked at your logs.. Here are the messages..

Mar  3 15:38:37 rman-ss-03 kernel: sd 1:0:0:0: Done: SUCCESS
Mar  3 15:38:37 rman-ss-03 kernel:         2 sd 1:0:0:0: 
Mar  3 15:38:37 rman-ss-03 kernel:         command: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
Mar  3 15:38:37 rman-ss-03 kernel: : Current: sense key: Illegal Request
Mar  3 15:38:37 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  3 15:38:37 rman-ss-03 kernel: 
Mar  3 15:38:38 rman-ss-03 kernel: sd 1:0:0:0: Done: SUCCESS
Mar  3 15:38:38 rman-ss-03 kernel:         2 sd 1:0:0:0: 
Mar  3 15:38:38 rman-ss-03 kernel:         command: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
Mar  3 15:38:38 rman-ss-03 kernel: : Current: sense key: Illegal Request
Mar  3 15:38:38 rman-ss-03 kernel:     <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1

These messages are coming  because of Synchronize Cache commands.  It may be related to type of filesystem you are on. Did you have barrier enabled on your filesystem. 
I see that these commands are going out to target on passive paths.. I dont understand that part yet. Normally scsi device handlers block commands going out passive paths..This should be coming in a differrent path.. I still have to figure that out.. 

________________________________________
From: dm-devel-bounces@redhat.com [dm-devel-bounces@redhat.com] On Behalf Of Charles Slivkoff [slivkoff@cmu.edu]
Sent: Thursday, March 03, 2011 2:59 PM
To: device-mapper development
Subject: Re: [dm-devel] Dell MD3200 - sd: Current: sense key: Illegal Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1

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



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

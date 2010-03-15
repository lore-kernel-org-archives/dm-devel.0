From: guy keren <choo@actcom.co.il>
Subject: Re: max number of paths
Date: Mon, 15 Mar 2010 22:15:14 +0200
Message-ID: <4B9E9552.9000603@actcom.co.il>
References: <03FB5D708BE3C8448E8079186A56CDE60162B9C7@BTIBURMAIL.bustech.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <03FB5D708BE3C8448E8079186A56CDE60162B9C7@BTIBURMAIL.bustech.com>
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


Charlie Sharkey wrote:
>  
> 
> Is there a maximum number of paths supported by the device mapper ?
> 
> I have a setup with 12 paths to 14 luns. I had to reduce the number of paths
> 
> to 10 for the device mapper to startup correctly.

i have seen such problems with linux kernel 2.4, long ago, when max SCSI 
disk devices was 256 (and hence - also max paths for such devices).

if you're not using SCSI, but rather some other type of device - it 
could be a limitation of the specific low level driver.

which kernel are you using? and which linux distribution? and what kind 
of block devices do your disks reside on?

--guy

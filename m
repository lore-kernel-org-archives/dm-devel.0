From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [patch] multipath-tools weighted path priority routine
Date: Fri, 21 Nov 2008 16:51:29 +0900
Message-ID: <49266881.7030701@ct.jp.nec.com>
References: <2118D41AB77C214BBF7D2330CD977BCF1BB3958036@GVW1162EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2118D41AB77C214BBF7D2330CD977BCF1BB3958036@GVW1162EXB.americas.hpqcorp.net>
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

Hi Vijayakumar,

Balasubramanian, Vijayakumar (STSD) wrote:
> Hi,
> 'Weighted path' is a new path prioritizer for device mapper multipath, where specific paths and the corresponding priority values can be provided as arguments.
> This prioritizer assigns the priority value provided in the configuration file based on the comparison made between the specified paths and the path instance for which this is called. Paths can be specified as a regular expression of devname of the path or as hbtl information of the path.
> 
> Syntax:
> weightedpath  <hbtl|devname> <regex1> <prio1> <regex2> <prio2> ...
> 
> Examples:
> prio  "weightedpath hbtl 1:.:.:. 2 4:.:.:. 4"   #All paths through SCSI 'H' as '1' will take prio 2 and all paths with SCSI 'H' as 4 will take prio as 4.
> prio  "weightedpath devname sda$ 10 sde$ 20"    #Path sda takes prio 10 and path sde takes prio 20. can be provided in multipath section.
> 
> 
> This prioritizer allows user to set static load balancing for devices. Useful when user has prior knowledge of path performance difference or unavailability of certain paths.

I think we can't specify a prefered path reliably in this way.
Device name, host number, etc may vary for each system reboot.
It's horrible to check and change the config file after every reboot.
We should use more persistent name.

If you'd like to specify a prefered host, you may be able to use
hosts's WWN like /sys/class/fc_host/host?/[node|port]_name.

Thanks,
Kiyoshi Ueda

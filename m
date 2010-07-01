From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: Rescan for new LUNs
Date: Thu, 1 Jul 2010 11:21:04 -0700
Message-ID: <20100701182104.GB12613@us.ibm.com>
References: <230ED15F81AFD3409345FFA4E565F0E50B83D8E1@NDHV3000.na.corp.mckesson.com>
	<20100701010738.GA24883@us.ibm.com>
	<230ED15F81AFD3409345FFA4E565F0E50B8B588B@NDHV3000.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <230ED15F81AFD3409345FFA4E565F0E50B8B588B@NDHV3000.na.corp.mckesson.com>
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

Allen, Jack [Jack.Allen@mckesson.com] wrote:
> Something to some file is not very helpful. And the other LUNs are in
> use. I am just trying to keep from having to reboot if I really do not
> need to.

I said what I said because the exact file depends on how your LUN is
connected. Here is some useful info though! For each scsi host, there
should be a sysfs file "/sys/class/scsi_host/hostN/scan". If you know
the exact host number, say "2", then you can do the following to rescan:

echo '- - -' > /sys/class/scsi_host/host2/scan

If you don't know the host number, then try on all of them.

Thanks, Malahal
PS: try running 'find /sys -name scan' to get all the files and chose
what ever you want to scan.

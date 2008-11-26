From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: RE: Temporarily squelching multipathd errors
Date: Wed, 26 Nov 2008 12:43:18 -0500
Message-ID: <20081126174317.GA19425@mars.virtualiron.com>
References: <E154952FA1D141C18A9A128FEC40B34D@pitagora.it>
	<65F9ACC78BD8304BAAEB817634C62D4C06EAFB63@AUSMAIL01.americas.ppdi.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <65F9ACC78BD8304BAAEB817634C62D4C06EAFB63@AUSMAIL01.americas.ppdi.local>
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

On Fri, Nov 21, 2008 at 01:54:01PM -0600, Daniel Keisling wrote:
> I am still getting multipath errors when unpresenting and presenting
> LUNs.  I've traced it down to getting path failures everytime I either
> remove or add a LUN to the system.  The strange thing is that I get path
> errors for maps that aren't related to the LUNs I am deleting or adding.
> In this case, I am deleting the LUN with the map 'mpath18,' but other
> maps complain whenever the LUN is deleted:
> 
> Nov 21 13:47:05 ausracdbd01 multipathd: checker failed path 67:208 in
> map orabackup_hs
> Nov 21 13:47:05 ausracdbd01 kernel: device-mapper: multipath: Failing
> path 67:208.
> Nov 21 13:47:08 ausracdbd01 multipathd: checker failed path 70:160 in
> map mpath18
> Nov 21 13:47:08 ausracdbd01 kernel: device-mapper: multipath: Failing
> path 70:160.
> Nov 21 13:47:09 ausracdbd01 multipathd: checker failed path 69:0 in map
> orabackup_hs
> Nov 21 13:47:09 ausracdbd01 kernel: device-mapper: multipath: Failing
> path 69:0.
> Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path 65:192 in
> map ph1d
> Nov 21 13:47:10 ausracdbd01 kernel: device-mapper: multipath: Failing
> path 65:192.
> Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path 65:224 in
> map limsd
> Nov 21 13:47:10 ausracdbd01 kernel: device-mapper: multipath: Failing
> path 65:224.
> Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path 65:240 in
> map limsd_arch
> 

Can you attach the 'multipath -ll' output? Run the program before
you delete/add the LUNs and after, please.

How do you delete/add the LUNs? Are you re-using the LUN number, or are you
actually deleting a LUN, deleting the block device as well, and then
when adding (with a new LUN number higher than the deleted one), rescanning 
the SCSI host channel to get the new block device for the LUN?

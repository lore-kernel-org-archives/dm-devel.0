From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: RE: Temporarily squelching multipathd errors
Date: Fri, 16 Jan 2009 16:28:59 -0500
Message-ID: <20090116212858.GA27665@mars.virtualiron.com>
References: <20081126174317.GA19425@mars.virtualiron.com>
	<65F9ACC78BD8304BAAEB817634C62D4C07441224@AUSMAIL01.americas.ppdi.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <65F9ACC78BD8304BAAEB817634C62D4C07441224@AUSMAIL01.americas.ppdi.local>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Daniel Keisling <Daniel.Keisling@ppdi.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 16, 2009 at 02:29:40PM -0600, Daniel Keisling wrote:
> Right now I'm deleting the LUN, immediately creating a new LUN, and
> presenting it back to the system with the same SCSI ID.  Since it's a
> snapshot, the LUN geometry is always the same.  I've tried unpresenting
> the LUN, deleting the SCSI devices, recreating/presenting the LUN, and
> then doing a SCSI rescan, but the multipath errors are always there.  
> 
> Here's the multipath listings.  I am only deleting/presenting the
> "mpath33" map, but you can see the multipath errors and the other paths

How are you 'deleting' the mpath33 map? Are you using 'dmsetup remove mpath33'
?

> having a fault:
> 
> Unmounting /dev/mapper/mpath33p1...
> Multipath listing before LUN is deleted...
> cred_arch (3600508b400106fcd0000700011f30000) dm-52 HP,HSV210
> [size=5.0G][features=1 queue_if_no_path][hwhandler=0]

..snip ..
> 
> 
> Multipath listing after LUN is deleted and before LUN is added...

I am not seeing how you are deleting the SCSI device of the node.
Are you doing 'echo 1 > /sys/block/sdab/device/delete' for all
of those block-devices that match the 'deleted LUN'?


.. snip ..
> 
> 
> Multipath output after LUN is added...

How are you doing a SCSI rescan?

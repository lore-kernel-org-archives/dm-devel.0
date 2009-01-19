From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: RE: Temporarily squelching multipathd errors
Date: Mon, 19 Jan 2009 10:07:06 -0500
Message-ID: <20090119150706.GA21668@mars.virtualiron.com>
References: <20081126174317.GA19425@mars.virtualiron.com>
	<65F9ACC78BD8304BAAEB817634C62D4C07441224@AUSMAIL01.americas.ppdi.local>
	<20090116212858.GA27665@mars.virtualiron.com>
	<65F9ACC78BD8304BAAEB817634C62D4C0744141F@AUSMAIL01.americas.ppdi.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <65F9ACC78BD8304BAAEB817634C62D4C0744141F@AUSMAIL01.americas.ppdi.local>
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

> 
> I'm not in this test.  Since all this takes around 20 seconds, I can
> immediately mount the LUN again on the server with any SCSI devices
> permanently disappearing.
> 
> Would you like me to:
> 
> A) Umount the filesystem
> B) Perform a 'dmsetup remove mpath33'
> C) Delete all SCSI devices via /sys/block/$device/delete
> D) Tell the storage unit to unpresent and delete the LUN
> E) Optionally do a SCSI rescan to clear everything out
> F) Tell the storage unit to create the LUN with the same WWID and SCSI
> ID
> G) Perform a SCSI rescan
> H) Do a multipath -v3 to get the maps back (?)
> I) Fsck and mount the filesystem?
> 
> I believe I get the same results as what I pasted, but will prove it if
> need be.

Please do. Step B might be unnecessary as multipathd will figure out that
devices are gone (by step C) and start removing the block devices from the
map.

> 
> BTW, I do a SCSI rescan with the HP Fibreutils package (hp_rescan -a),
> which basically does a "echo "- - -" >
> /sys/class/scsi_host/${INST}/scan" and removes devices with "echo "scsi
> remove-single-device $INST 0 $j $k" > /proc/scsi/scsi"

You only need to do the first step: echo "- - -"  > /sys/class/scsi/host/hostX/scan

> 
> Thanks,
> 
> Daniel
> 
> ______________________________________________________________________
> This email transmission and any documents, files or previous email
> messages attached to it may contain information that is confidential or
> legally privileged. If you are not the intended recipient or a person
> responsible for delivering this transmission to the intended recipient,
> you are hereby notified that you must not read this transmission and
> that any disclosure, copying, printing, distribution or use of this
> transmission is strictly prohibited. If you have received this transmission
> in error, please immediately notify the sender by telephone or return email
> and delete the original transmission and its attachments without reading
> or saving in any manner.
> 

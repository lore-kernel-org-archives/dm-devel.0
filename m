From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: RE: Temporarily squelching multipathd errors
Date: Thu, 30 Oct 2008 17:15:26 +0100
Message-ID: <E154952FA1D141C18A9A128FEC40B34D@pitagora.it>
References: <1216456070.7364.4.camel@plop>
	<65F9ACC78BD8304BAAEB817634C62D4C06C1C4D1@AUSMAIL01.americas.ppdi.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <65F9ACC78BD8304BAAEB817634C62D4C06C1C4D1@AUSMAIL01.americas.ppdi.local>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> From Daniel Keisling:
>
> What is proper procedure to completely remove all SCSI 
> devices and multipath maps so that multipathd will not 
> generate error messages when the LUN is unpresented from the system?

This is my recipe:

- Take a note of "multipath -ll" output (SCSI-IDs, long multipath
identifiers, etc)
- Umount filesystem
- Deactivate VG
	vgchange -an vg_XXX
- Export VG
	vgexport vg_XXX
- Remove multipath
	multipath -f <long-multipath-identifier>
- Unpresent/destroy array LUN
- Remove SCSI devices
	echo 1 > /sys/bus/scsi/drivers/sd/<SCSI-ID>/delete
	... (for all paths)
- Edit fstab


--
Domenico Viggiani

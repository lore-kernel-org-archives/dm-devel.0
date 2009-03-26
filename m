From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: hwtable.c for HP LOGICAL VOLUME (cciss_tur isn't working
	on iSCSI connection).
Date: Thu, 26 Mar 2009 14:46:54 -0400
Message-ID: <20090326184654.GA16297@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


One of our customers purchased a iSCSI target software that converts the
local disks into shareable SAN disks. (http://www.rocketdivision.com/wind.html).

Unfortunatly the software exports the vendor/product of the disks the same as
on the target. Meaning that the HP LOGICAL DISKS are shown over an iSCSI
initiator session. And the cciss_tur checker is kicked off and tries
this ioctl call:

    rc = ioctl(c->fd, CCISS_GETLUNINFO, &lvi);
    if ( rc != 0) {
        perror("Error: ");
        fprintf(stderr, "cciss TUR  failed in CCISS_GETLUNINFO: %s\n",


which fails, since the ioctl is done on a SCSI device instead
on the cciss driver.

So should the cciss_tur be modified try to do a normal SCSI tur
if it fails to perform the ioctl call? Maybe make a path where
it would first do a CCISS_VERSION (not sure if that exists) and
if that fail do exactly what the 'tur' checker does?

Or maybe (with more of these types of software that turn your box in
iSCSI target), provide a means of having a secondary path checker in case
the first one fails?

Thoughts?

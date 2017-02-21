From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 2/2] Fill NVMe specific path info
Date: Tue, 21 Feb 2017 16:06:57 -0500
Message-ID: <20170221210657.GA2453@localhost.localdomain>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<1487107154-24883-2-git-send-email-keith.busch@intel.com>
	<20170220175759.GA22981@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170220175759.GA22981@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 20, 2017 at 11:57:59AM -0600, Benjamin Marzinski wrote:
> > +
> > +	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
> > +	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s", udev_device_get_sysattr_value(nvme, "model"));
> > +	snprintf(pp->serial, SERIAL_SIZE, "%s", udev_device_get_sysattr_value(nvme, "serial"));
> > +	snprintf(pp->rev, SCSI_REV_SIZE, "%s", udev_device_get_sysattr_value(nvme, "firmware_rev"));
> > +	snprintf(pp->wwid, WWID_SIZE, "%s", udev_device_get_sysattr_value(pp->udev, "wwid"));
> 
> With your udev rules change, you shouldn't need to set the wwid here. It
> should just get dealt with by the get_uid call in pathinfo (or with
> the new uevent merging code, before multipathd ever calls pathinfo).

Oh right, you are correct. I can spin this with that removed.

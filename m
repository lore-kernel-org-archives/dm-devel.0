From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: [Patch 1 of 2]: scsi-dh + dm-mpath: propagate SCSI
 device deletion to multipath
Date: Wed, 15 Dec 2010 09:03:15 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4F5440A5B@cosmail01.lsi.com>
References: <D8C50530D6022F40A817A35C40CC06A7064AFC9440@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064AFC9440@DUBX7MCDUB01.EMEA.DELL.COM>
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

Patches look good.

Reviewed-by: Babu Moger <babu.moger@lsi.com>

________________________________________
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Menny_Hamburger@Dell.com
Sent: Wednesday, December 15, 2010 2:29 AM
To: dm-devel@redhat.com
Subject: [dm-devel] [Patch 1 of 2]: scsi-dh + dm-mpath: propagate SCSI device deletion to multipath

The problem:
When a SCSI device attached to a device handler is deleted, userland processes currently performing I/O on the device will I/O hang forever.

The root cause:
When scsi_dh_activate returns SCSI_DH_NOSYS the activate_complete callback is not called and the error is not propagated to the
multipath layer. A similar situation occurs when the handler is in the process of being deleted (e.g. the SCSI device is in a SDEV_CANCEL or SDEV_DEL state).

Attached is the SCSI H/W handler part of this patch.

Menny Hamburger
Engineer
Dell | IDC
office +972 97698789,  fax +972 97698889
Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel

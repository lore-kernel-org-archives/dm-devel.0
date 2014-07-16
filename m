From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: [PATCH ] multipath: Fall back to getuid_callout if
 ID_SERIAL attribute is missing.
Date: Wed, 16 Jul 2014 15:41:37 +0000
Message-ID: <1203e45680244c88a53d1f2b6e67246d@hioexcmbx01-prd.hq.netapp.com>
References: <229730203dc540ef9cae7b665577519c@hioexcmbx01-prd.hq.netapp.com>
	<53A12F18.60300@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53A12F18.60300@suse.de>
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
To: Hannes Reinecke <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, June 18, 2014 1:18 AM
> To: Merla, ShivaKrishna; christophe.varoqui@opensvc.com
> Cc: dm-devel@redhat.com
> Subject: Re: [PATCH ] multipath: Fall back to getuid_callout if ID_SERIAL
> attribute is missing.
> 
> On 06/18/2014 02:17 AM, Merla, ShivaKrishna wrote:
> >   Sometimes whenever a path is added, scsi_id call during udev rule
> processing
> >   can fail and ID_SERIAL attribute will not be set. This causes multipathd to
> add
> >   the path as orphan. We have seen several instances of this happening
> during
> >   testing.
> >
> >        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid_attribute =
> ID_SERIAL (config file default)
> >        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: no ID_SERIAL attribute
> >        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid = <empty> (udev)
> >        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: no ID_SERIAL attribute
> >        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid = <empty> (udev)
> >        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: failed to get path uid
> >        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: orphan path, failed to
> add path
> >
> >   This patch handles this case by allowing to fall back to explict
> getuid_callout
> >   incase if ID_SERIAL attribute is not set. This way support for deprecated
> >   getuid_callout is not lost for older versions where ID_SERIAL attribute is
> not
> >   present but also serves good purpose in the scenario mentioned above.
> >
> > Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>
> 
> Hmm. I have a similar patch in my tree. Will be checking.
>
Hannes, did you get a chance to verify this?. We are seeing many scenarios
where scsi_id call can fail during udev processing and path will not be added
to map until scsi_id is successful on future udev change events. Falling back to 
getuid_callout will solve this particular problem.

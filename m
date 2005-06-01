From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: RE: Error while creating mapped device...
Date: Wed, 1 Jun 2005 07:46:35 -0500
Message-ID: <200506010746.35677.kevcorry@us.ibm.com>
References: <5959EA4638D8734599AB75EAAFBB6FEF03C401D0@mtv01ex04.mindtree.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5959EA4638D8734599AB75EAAFBB6FEF03C401D0@mtv01ex04.mindtree.com>
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

Hi Manu,

On Wed June 1 2005 3:28 am, Manu Tayal wrote:
> The version of Linux I am using is 2.4.26 and the version of device-mapper
> is 1.00.18.
>
> I found the logs as:
>
>  Device-mapper: device /dev/hda1 too small for target
>  Device-mapper: dm-linear: Device lookup failed
>  Device-mapper: error adding target to table
>
>  Device-mapper: device /dev/hda5 too small for target
>  Device-mapper: dm-linear: Device lookup failed
>  Device-mapper: error adding target to table
>
> So there seems to be some size problem.
>
>  blockdev --getsize /dev/hda1  = 2041137
>  blockdev --getsize /dev/hda5  = 1043217
>
> Is there a limitation on the size of the device or is this a bug?

On 2.4 kernels, block device sizes are normally calculated in kilobytes, 
dispite the output you get from "blockdev --getsize". Thus you should always 
take the size in sectors and round down to the nearest even number so that it 
translates to a whole number of kilobytes. You can do this by simply masking 
off the lowest bit. So the command to create your DM device would look like 
this:

echo 0 $(($(blockdev --getsize /dev/hda1) & ~1)) linear /dev/hda1 0 | \
  dmsetup create hda1

On 2.6 kernels, block device sizes are recorded in sectors, and you would not 
experience this problem.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/

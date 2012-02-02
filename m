From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH] scsi : Adding all the definitions of host
 bytes in hostbyte_table
Date: Thu, 02 Feb 2012 18:43:16 +0100
Message-ID: <4F2ACB34.6020709@suse.de>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B01034E@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B01034E@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 02/02/2012 04:27 PM, Moger, Babu wrote:
> Resubmitting it again(Probably last one had some format issues).
> Adding all the definitions of host bytes in hostbyte_table.
>
> Without this patch, scsi_show_result prints hostbyte as invalid
> for statuses that are not defined in hostbyte_table(when scsi logging=
 is enabled).
>
> Look at scsi_print_result function for better understanding.
>
> Signed-off-by: Babu Moger<babu.moger@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

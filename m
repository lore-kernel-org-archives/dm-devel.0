From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/2] Don't blacklist nvme
Date: Tue, 14 Feb 2017 13:35:45 -0800
Message-ID: <941dc20e-47ba-5b9d-5082-a87ff1530cb6@sandisk.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/14/2017 01:19 PM, Keith Busch wrote:
> These devices are mulitpath capable, and have been able to stack with
> dm-mpath since kernel 4.2.
> 
> -	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]");
> +	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");

Have you checked whether dm-mpath works properly with nvme? Last time I
tried that dm-mpath crashed when it called scsi_dh_attach() because that
last function assumes that it is passed a SCSI device queue instead of
checking whether or not the queue passed to that function is a SCSI
device queue.

Bart.
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

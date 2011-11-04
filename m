From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RESEND][PATCH 2/4] scsi_dh_hp_sw: Adding the match
 function for hp_sw device handler
Date: Fri, 04 Nov 2011 14:49:05 +0100
Message-ID: <4EB3ED51.9050300@suse.de>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DC2A0@RTPMVEXC1-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD9105DC2A0@RTPMVEXC1-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 11/04/2011 02:40 PM, Moger, Babu wrote:
> Resending just this patch after making changes per Hannes comments.
>
> This patch introduces the match function for hp_sw device handler.
> Included the check for TPGS bit before proceeding further.
> The match function was introduced by this patch
> http://www.spinics.net/lists/linux-scsi/msg54284.html
>
> Signed-off-by: Babu Moger<babu.moger@netapp.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

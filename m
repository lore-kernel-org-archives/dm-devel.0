From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: delay retry activate_path on SCSI_DH_RETRY
Date: Tue, 2 Nov 2010 15:32:17 -0400
Message-ID: <20101102193217.GA23680@redhat.com>
References: <1241493497.8721.60.camel@chandra-ubuntu>
	<1242357018.15931.14.camel@chandra-ubuntu>
	<1244580864.11385.4.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1244580864.11385.4.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 09 2009 at  4:54pm -0400,
Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> No functional change.
> 
> Repost with changes made to apply cleanly on top of the patch
> (http://marc.info/?l=dm-devel&m=124424663327710&w=2) that changed
> dm-mpath.c
> 
> -----------------
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> SCSI Device Handlers return SCSI_DH_IMM_RETRY if we could retry
> immediately and SCSI_DH_RETRY in cases where it is better to retry
> after some delay.
> 
> Currently we retry immediately irrespective of SCSI_DH_IMM_RETRY and
> SCSI_DH_RETRY. This patch adds a user configurable attribute
> pg_init_delay_secs which specifies the number of seconds to delay
> before retrying scsi_dh_activate, when it returned SCSI_DH_RETRY.
> 
> Default for this attribute is set to 2 seconds.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

I'm auditing dm-devel's patchwork and would just like to confirm that
others would still like to see this go in?

Patch in question is captured here:
https://patchwork.kernel.org/patch/29088/

Mike C.,
An earlier version of this patch got your "Looks ok.":
https://patchwork.kernel.org/patch/23946/
Can I translate that to your "Acked-by:" if/when I rebase and repost?

Please advise,
Mike

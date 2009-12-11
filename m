From: NeilBrown <neilb@suse.de>
Subject: [PATCH dmraid 0/1] pdc metadata bug fix
Date: Fri, 11 Dec 2009 14:27:10 +1100
Message-ID: <20091211032710.161471708@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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


Hi,
 the follow patch fixes a bug with pdc metadata handling, as described
 in that patch.

 I noted on reading the code that if pdc_read_metadata finds the metadata
 at and address listed in begin_sectors, info->u32 is set to an offset
 from the start of the device, rather than from the end, and then the use
 of info->u32 in setup_rd becomes incorrect.
 I didn't try to fix this as I don't know all the implications of
 a 'begin_sectors' address being used.

Thanks,
NeilBrown

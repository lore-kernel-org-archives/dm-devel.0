From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: patch to dm-emc.c
Date: Tue, 8 Aug 2006 11:07:05 -0700
Message-ID: <20060808180705.GB31792@us.ibm.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1356@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1356@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

egoggin@emc.com <egoggin@emc.com> wrote:
> ***************
> *** 10,233 ****
>   #include "dm.h"
>   #include "dm-hw-handler.h"
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_cmnd.h>
>   
> ! #define DM_MSG_PREFIX "multipath emc"
>   
>   struct emc_handler {
>   	spinlock_t lock;
> ! 
> ! 	/* Whether we should send the short trespass command (FC-series)
> ! 	 * or the long version (default for AX/CX CLARiiON arrays). */

Would it be possible to repost the patch in unified format? The first part
of the patch is, but the last part is not.

Thanks.

-andmike
--
Michael Anderson
andmike@us.ibm.com

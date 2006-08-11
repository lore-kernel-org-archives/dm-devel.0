From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: preventing block I/O to EMC CLARiiON LUNZ paths
Date: Fri, 11 Aug 2006 09:11:29 +0200
Message-ID: <20060811071129.GB18144@zezette.dyndns.org>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1351@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1351@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: egoggin@emc.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Aug 08, 2006 at 10:22:45AM -0400, egoggin@emc.com wrote:
> Christophe,
> 
> This patch simply reports a PATH_DOWN status for paths to an EMC CLARiiON
> LUNZ (or an unbound) block device since these paths cannot possibly be used
> to issue I/O to such a device.  In fact, allowing block I/O to a LUNZ
> dm-multipath device will cause the process to hang until the no_path_retry
> timeout is incurred.  This is not desirable.
> 
Applied locally.
Thanks.

cvaroqui

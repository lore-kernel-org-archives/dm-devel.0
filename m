From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: lvresize fails with "reload ioctl failed: Invalid
	argument"
Date: Sun, 10 Sep 2006 23:14:27 +0100
Message-ID: <20060910221427.GF13859@agk.surrey.redhat.com>
References: <ee20kk$s7u$1@sea.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ee20kk$s7u$1@sea.gmane.org>
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
List-Id: dm-devel.ids

On Sun, Sep 10, 2006 at 11:38:27PM +0200, Laurent Riffard wrote:
>  device-mapper: reload ioctl failed: Invalid argument

>  LVM version:     2.02.06 (2006-05-12)
>  Library version: 1.02.09 (2006-08-15)
>  Driver version:  4.8.0
> Linux version 2.6.18-rc6-mm1 (laurent@calimero.antadix) (gcc version 4.1.1 
> 20060724 (prerelease) (4.1.1-3mdk)) #145 Sun Sep 10 20:48:49 CEST 2006
 

> Is it a known problem ? 

Not sure, but try updating lvm2 version to the same date as the
library version (at least 2.02.08 15th August).

Alasdair
-- 
agk@redhat.com

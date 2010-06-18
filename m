From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath-tools only binding 2 out of 4 paths,
 bug w/ numerous devices?
Date: Fri, 18 Jun 2010 20:55:13 +0200
Message-ID: <1276887313.2657.1.camel@localhost>
References: <5B2DB4801E21E64BB49494533CCF208A07330E95@CWYMSX02.Corp.Acxiom.net>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5B2DB4801E21E64BB49494533CCF208A07330E95@CWYMSX02.Corp.Acxiom.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Costaras Steve - stcost <Steve.Costaras@acxiom.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On ven., 2010-06-18 at 13:37 -0500, Costaras Steve - stcost wrote:
> I have a STK Flexline 680 which is presenting 12 2TB LUNS across 4 paths
> (48 devices).   They are showing up below correctly as sdb through sdaw.
> They are being encapsulated into dm-0 through dm-11.  (dm-12 is a lv).
> As below multipath is working but only using/seeing two of the paths.
> With exception of sdz (FLEX680-000 (3600104f0008baaa17c99eebb00000001)).
> It appears that the 3 & 4 paths that DO NOT show up are with device
> major numbers 66 & 67.   
> 
> Is this a known bug?
> 
Hi,

do you reproduce with upstream multipath-tools ? What distribution and
versions are you using ?

Best regards,
-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC

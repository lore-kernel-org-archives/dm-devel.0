From: egoggin@emc.com
Subject: RE: Re: libdevmapper version question
Date: Thu, 24 Aug 2006 20:48:14 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1374@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

> On Thursday, August 24, 2006 2:10 PM, agk@redhat.com wrote:
> 
> See the WHATS_NEW file:
> 
>   Version 1.02.00 - 10 Nov 2005
>     Added dmsetup --nolockfs support for suspend/reload.
> 
> However, note that LVM2 hasn't always used it correctly:
>   Version 2.02.08 - 15th August 2006
>     Fix missing lockfs on first snapshot creation.

Thanks Alasdair.

I've got a related question about version dependency between
libdevmapper and the kernel resident device mapper modules.
How is this dependency handled as new features like
"skip lockfs" or "no open count" are added to the device
mapper ioctl interface? 

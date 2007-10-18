From: Tore Anderson <tore@linpro.no>
Subject: Re: multibus / failover and EMC CX600
Date: Thu, 18 Oct 2007 08:01:39 +0200
Message-ID: <4716F6C3.2040100@linpro.no>
References: <061401c810a7$cac685d0$0a00a8c0@ALDI2><4715E6A4.7060308@linpro.no>	<4715ED28.9020102@suse.de><471600F7.5090607@linpro.no>	<066001c810cc$cd9f6f90$0a00a8c0@ALDI2>
	<471631E5.9050603@linpro.no> <06b201c810f5$5b7782d0$0a00a8c0@ALDI2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <06b201c810f5$5b7782d0$0a00a8c0@ALDI2>
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

* Gerald Nowitzky

> not much difference with 2.6.23.1:

Hmm - maybe this patch helps (needs Wilcox' patch to be applied first):
<http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg09458.html>.

I tested it a bit and it helped some, but I don't remember exactly for 
which situations...  It was on a machine that was using the lpfc HBA 
driver though so no guarantees that it'll help in your case.

Anyway, since you're able to reproduce it consistently and with the 
latest kernel.org tarball, I suggest you try to take it to the 
linux-scsi list to see if they've got any suggestions.  This obviously 
is a kernel bug, and it's surely not in the DM layer.  Either in the HBA 
driver or in the SCSI layer (I'm not sure which), but linux-scsi should 
be the right list in any case.

Regards
-- 
Tore Anderson

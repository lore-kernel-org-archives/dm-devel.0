From: Milan Broz <mbroz@redhat.com>
Subject: Re: BUG: Files corrupt after moving LVM volume to USB
	disk
Date: Thu, 22 Mar 2007 11:03:58 +0100
Message-ID: <4602548E.20004@redhat.com>
References: <2a12af650703200334u2b94bbcbt2aab8e94b6f2a527@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2a12af650703200334u2b94bbcbt2aab8e94b6f2a527@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Marti Raudsepp <marti@juffo.org>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


Marti Raudsepp wrote:
> This is a reproducible demonstration of the problem initially reported in my
> first e-mail, titled "PROBLEM: 'bio too big device' after moving to a USB
> disk" (http://lkml.org/lkml/2007/3/7/657)
...
> 06. Observe "bio too big device dm-0 (256 > 240)" messages in dmesg
> 
> [non]# dmesg |tail -n7
> [101403.106825] bio too big device dm-0 (256 > 240)
> [101403.115228] bio too big device dm-0 (256 > 240)
> [101403.115912] bio too big device dm-0 (256 > 240)
> [101403.130529] bio too big device dm-0 (256 > 240)
> [101403.131220] bio too big device dm-0 (256 > 240)
> [101403.141577] bio too big device dm-0 (256 > 240)
> [101403.142255] bio too big device dm-0 (256 > 240)

if (unlikely(bio_sectors(bio) > q->max_hw_sectors)) {
	printk("bio too big device %s (%u > %u)\n", 
...

Please could you try if this patch helps ?
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-merge-max_hw_sector.patch


Milan
--
mbroz@redhat.com

From: folkert <folkert@vanheusden.com>
Subject: write intent bitmap on external disk
Date: Mon, 10 Jun 2013 11:14:12 +0200
Message-ID: <20130610091411.GE5247@belle.intranet.vanheusden.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

I think it would be helpfull to improve i/o performance of my server if
I put the RAID-1 write intent map on a seperate disk (an SSD).

It is unclear to me how to do this.
I tried setting it to /dev/VGJOURNALS/LVWRITEINTENT but that fails: I
would expect a device to work?
Because if I put a filesystem on LVWRITEINTENT then mount it on e.g.
/var/wib, then how does the initramfs know how to set this up?


Folkert van Heusden

-- 
To MultiTail einai ena polymorfiko ergaleio gia ta logfiles kai tin
eksodo twn entolwn. Prosferei: filtrarisma, xrwmatismo, sygxwneysi,
diaforetikes provoles. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
